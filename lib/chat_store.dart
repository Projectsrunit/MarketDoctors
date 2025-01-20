import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_doctor/main.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatStore extends ChangeNotifier {
  Map<int, Map<int, Map<String, dynamic>>> _messages = {};
  Map<int, Map<int, Map<String, dynamic>>> get messages => _messages;
  Map<int, String> latestMessageDates = {};
  List<int> idsWithUnreadMessages = [];
  Database? db;
  int? storedHost;
  IO.Socket? socket;
  bool dbInitialised = false;
  bool _isReconnecting = false;
  bool isSocketInitialized = false;
  StreamSubscription<ConnectivityResult>? conn;
  final Connectivity _connectivity = Connectivity();

  @override
  void dispose() {
    conn?.cancel();
    socket?.disconnect();
    super.dispose();
  }

  void switchOffSocket() {
    conn?.cancel();
    socket?.disconnect();
    dbInitialised = false;
    notifyListeners();
  }

  void reconnectSocket() {
    if (socket == null) {
      print('Reinitializing socket');
      if (storedHost != null) {
        initializeSocket(storedHost!);
      } else {
        print('Failing to connect chats. Socket is null and storedHost too');
        _showToast('Failing to reconnect chats. Refresh home screen');
      }
    } else {
      print('Reconnecting socket');
      socket!.connect();
    }
  }

  Future<void> initializeSocket(int hostId) async {
    print('going to initialise socket with host $hostId');

    conn?.cancel();
    conn = _connectivity.onConnectivityChanged.listen(handleConnectivityChange);

    if (socket == null) {
      final String socketUrl = dotenv.env['API_URL']!;
      socket = IO.io(socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
    }
    socket!.connect();
    socket!.emit('authenticate',
        {'own_id': hostId, 'message_dates': latestMessageDates});
    isSocketInitialized = true;

    socket!.on('connect', (_) {
      print('Socket connected ======================');
      _isReconnecting = false;
      notifyListeners();
    });

    socket!.on('new_message', (message) async {
      //check here if we are in the chattingpage of the conversation

      await flutterLocalNotificationsPlugin.show(
        message['id'], // Notification ID
        'New Message', // Title
        message['text_body'] ?? 'Object', // Body
        NotificationDetails(
          android: AndroidNotificationDetails(
            'message_channel_id', // Channel ID
            'Incoming messages', // Channel name
            channelDescription: 'Channel for new message notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
      int guestId = (message['sender'] == hostId)
          ? message['receiver']
          : message['sender'];
      addMessage(message, guestId);
      insertIntoDb(message, guestId);
      print('now to set green light for msg from ${message['sender']}');

      if (message['read_status'] != true &&
          !idsWithUnreadMessages.contains(guestId)) {
        print('here we add id $guestId to the idswithunreadmessages');
        idsWithUnreadMessages.add(guestId);
      }
      notifyListeners();
      emitWithRetry(
          'update_delivery_status', {'message_id': message['id']}, 10, 100);
    });

    socket!.on('older_messages', (messages) {
      _handleArrayOfMessages(messages, hostId);
      notifyListeners();
    });

    socket!.on('delivery_status_updated', (message) {
      int guestId = (message['sender'] == hostId)
          ? message['receiver']
          : message['sender'];
      receiveDeliveryStatus(message, guestId);
      updateDbDelivery(message['id'], guestId);
      notifyListeners();
    });

    socket!.on('read_status_updated', (message) {
      int guestId = (message['sender'] == hostId)
          ? message['receiver']
          : message['sender'];
      updateDbRead(message['id'], guestId);
      receiveReadStatus(message, guestId);
      notifyListeners();
    });

    socket!.on('catch_up_db', (messages) {
      _handleArrayOfMessages(messages, hostId);
    });

    socket!.on('disconnect', (_) {
      print('Socket disconnected');
      isSocketInitialized = false;
      notifyListeners();
    });
    isSocketInitialized = true;
    notifyListeners();
  }

  void handleConnectivityChange(ConnectivityResult result) async {
    final isOnline = result != ConnectivityResult.none;
    print('is the connectivityhandle running ======================?');
    if (isOnline) {
      print('Device is online ======================');
      // _showToast('Device is online'); //dont show for now

      if (!_isReconnecting && (socket == null || socket!.disconnected)) {
        _isReconnecting = true; // Prevent multiple reconnections
        try {
          reconnectSocket();
        } catch (e) {
          print('Error during reconnection: $e');
        } finally {
          _isReconnecting = false; // Reset flag
        }
      }
    } else {
      print('Device is offline ==========================');
      _showToast('Device is offline');
      socket?.disconnect(); // Clean up socket connection if offline
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey[200],
      textColor: Colors.grey[800],
      fontSize: 16.0,
    );
  }

  void emitWithRetry(String event, Map<String, dynamic> data, int maxRetries,
      int delayMs) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      if (socket?.connected == true) {
        socket!.emit(event, data);
        return; // Exit the function if the emit is successful
      }
      attempts++;
      await Future.delayed(Duration(milliseconds: delayMs));
    }
    print('Failed to emit event $event after $maxRetries attempts.');
  }

  void updateDbRead(int messageId, int guestId) async {
    print(
        'going to update db read of table user$guestId: message id: $messageId');
    String tableName = 'user$guestId';
    await db!.update(
      tableName,
      {'read_status': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
    print('done updating db read status');
  }

  void updateDbDelivery(int messageId, int guestId) async {
    print(
        'going to update db deliv of table user$guestId: message id: $messageId');
    String tableName = 'user$guestId';
    await db!.update(
      tableName,
      {'delivery_status': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
    print('done updating db delivery status');
  }

  void insertIntoDb(Map<String, dynamic> message, int guestId) async {
    while (!dbInitialised) {
      await Future.delayed(
          Duration(milliseconds: 100)); // Wait until DB is initialized
    }

    print('inserting into db of id $guestId: $message');
    String tableName = 'user$guestId';
    int messageId = message['id'];

    await db!.execute('''CREATE TABLE IF NOT EXISTS $tableName (
            id INTEGER PRIMARY KEY,
            text_body TEXT,
            sender INTEGER,
            delivery_status BOOLEAN,
            read_status BOOLEAN,
            document_url TEXT,
            createdAt TEXT
          )''');

    await db!.insert(
      tableName,
      {
        'id': messageId,
        'text_body': message['text_body'],
        'sender': message['sender'],
        'delivery_status': 1,
        'read_status': message['read_status'] ? 1 : 0,
        'document_url': message['document_url'],
        'createdAt': message['createdAt']
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('done inserting record into db. sync-done, not async-done');
  }

  void _handleArrayOfMessages(List<dynamic> messages, int hostId) async {
    print('handleArrayofMessages called with messages as $messages');
    for (Map<String, dynamic> message in messages) {
      int? guestId = (message['sender'] == hostId)
          ? message['receiver']
          : message['sender'];
      if (guestId != null) {
        //because some messages in backend had a missing sender or receiver
        addMessage(message, guestId);
        insertIntoDb(message, guestId);
      }
      if (message['sender'] == guestId) {
        if (message['delivery_status'] != true) {
          await flutterLocalNotificationsPlugin.show(
            message['id'], // Notification ID
            'New Message', // Title
            message['text_body'] ?? 'Object', // Body
            NotificationDetails(
              android: AndroidNotificationDetails(
                'message_channel_id', // Channel ID
                'Incoming messages', // Channel name
                channelDescription: 'Channel for new message notifications',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );

          emitWithRetry(
              'update_delivery_status', {'message_id': message['id']}, 10, 100);
        }
        if (message['read_status'] != true &&
            !idsWithUnreadMessages.contains(guestId)) {
          print('adding into idswithunreadmessages for guest $guestId');
          idsWithUnreadMessages.add(guestId!);
        }
      }
    }
    print('now going to set those green lights ==========');
  }

  void ackWasSuccess(
      Map<String, dynamic> newMessage, Map<String, dynamic> message) {
    print('ack was success and these are parameters: $newMessage, $message');

    int guestId = newMessage['receiver'];
    insertIntoDb(newMessage, guestId);
    addMessage(newMessage, guestId);
    notifyListeners();
  }

  Future<bool> sendMessage(Map<String, dynamic> message, int guestId) async {
    if (socket?.connected ?? false) {
      final completer = Completer<bool>();
      socket!.emitWithAck('new_message', message, ack: (response) {
        if (response['success'] == true) {
          Map<String, dynamic> newMessage = response['message'];
          ackWasSuccess(newMessage, message);
          print('completer going to complete with true');
          completer.complete(true);
        } else {
          print('Error: ${response['error']}');
          Fluttertoast.showToast(
            msg: 'Network error while sending',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 16.0,
          );
          notifyListeners();
          print('completer shall not say true but waited');
          completer.complete(false);
        }
      });
      print('completer halfway step ============== ');
      return completer.future;
    } else {
      print('====== network socket state: ${socket?.connected}, $socket');
      Fluttertoast.showToast(
        msg: 'Network error. There was a disconnection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      notifyListeners();
      print('now completer says false. false on first inspection');
      return Future.value(false);
    }
  }

  void addMessage(Map<String, dynamic> message, int guestId) {
    if (!_messages.containsKey(guestId)) {
      _messages[guestId] = {};
    }

    _messages[guestId]![message['id']] = message;
  }

  void sendReadStatus(int messageId, int guestId) {
    emitWithRetry('update_read_status', {'message_id': messageId}, 10, 100);
    if (!_messages.containsKey(guestId)) {
      _messages[guestId] = {};
      print(
          'This is very unusual. Readstatus sending of a message that came from where?');
    }
    _messages[guestId]![messageId]!['read_status'] = true;
    //we arent notifying listeners here because descendant is still  building
    print('sending up update for read status of message $messageId');
  }

  void receiveDeliveryStatus(Map<String, dynamic> updatedMessage, int docId) {
    int messageId = updatedMessage['id'];

    if (_messages.containsKey(docId) &&
        _messages[docId]!.containsKey(messageId)) {
      _messages[docId]![messageId] = {
        ..._messages[docId]![messageId]!,
        'delivery_status': updatedMessage['delivery_status']
      };
    }
  }

  void receiveReadStatus(Map<String, dynamic> updatedMessage, int docId) {
    int messageId = updatedMessage['id'];

    if (_messages.containsKey(docId) &&
        _messages[docId]!.containsKey(messageId)) {
      _messages[docId]![messageId] = {
        ..._messages[docId]![messageId]!,
        'read_status': updatedMessage['read_status']
      };
    }
  }

  void removeFromUnreadList(int id) {
    idsWithUnreadMessages.remove(id);
    print('removing id $id from unreadList ================');
    notifyListeners();
  }

  void getOlderMessages(int hostId, int guestId, String? createdAt) {
    emitWithRetry(
        'get_older_messages',
        {
          'own_id': hostId,
          'other_id': guestId,
          'oldest_message_date': createdAt
        },
        10,
        100);
    print('emitting to get older messages for id $guestId of date $createdAt');
  }

  Future<void> initDB(int personId) async {
    String dbName = 'person$personId.db';
    print('Initializing database: $dbName');

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(documentsDirectory.path, dbName);
    print('Database path resolved: $dbPath');

    // await deleteDatabase(dbPath); //for when resetting things
    // print('Database $dbName deleted');

    bool dbExists = await File(dbPath).exists();
    print('Database exists: $dbExists');

    db = await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      print('Database $dbName created during onCreate callback.');
    });

    if (!dbExists) {
      print('Database $dbName did not exist and has been created.');
      return;
    }

    // await db!.execute('DROP TABLE IF EXISTS user11'); //for in case you want to delete something

    List<Map<String, dynamic>> tables = await db!
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    print(
        'Tables retrieved from database: ${tables.map((t) => t['name']).toList()}');

    for (var table in tables) {
      String tableName = table['name'];
      print('Processing table: $tableName');

      if (tableName.startsWith('user')) {
        int guestId = int.parse(tableName.replaceFirst('user', ''));
        print('Detected user table for guest ID: $guestId');
        List<Map<String, dynamic>> rows = await db!.query(tableName);
        print('Rows retrieved from table $tableName');

        _messages[guestId] = {
          for (var row in rows)
            row['id']: {
              'text_body': row['text_body'],
              'sender': row['sender'],
              'delivery_status': row['delivery_status'] == '1' ? true : false,
              'read_status': row['read_status'] == '1' ? true : false,
              'id': row['id'],
              'document_url': row['document_url'],
              'createdAt': row['createdAt'],
            }
        };
        print('Messages for guest ID $guestId loaded into memory.');

        String? mostRecentDate;

        for (var row in rows) {
          if (row['read_status'] != 1 &&
              row['sender'] == guestId &&
              !idsWithUnreadMessages.contains(guestId)) {
            idsWithUnreadMessages.add(guestId);
          }

          if (mostRecentDate == null ||
              row['createdAt'].compareTo(mostRecentDate) > 0) {
            mostRecentDate = row['createdAt'];
          }
        }

        if (mostRecentDate != null) {
          latestMessageDates[guestId] = mostRecentDate;
          // print('Latest message date for guest ID $guestId: $mostRecentDate');
        }
      } else {
        print('Skipping non-user table: $tableName');
      }
    }

    // print('Database $dbName fully loaded. Messages: $_messages');
    print('Temporary data (IDs with unread messages): $idsWithUnreadMessages');
    dbInitialised = true;
    notifyListeners();
  }
}
