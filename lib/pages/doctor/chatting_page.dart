// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_doctor/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChattingPage extends StatefulWidget {
  final String guestName;
  final String guestImage;
  final String guestPhoneNumber;
  final int guestId;

  ChattingPage({
    required this.guestName,
    required this.guestImage,
    required this.guestPhoneNumber,
    required this.guestId,
  });

  @override
  ChattingPageState createState() => ChattingPageState();
}

class ChattingPageState extends State<ChattingPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  ChatStore? chatStore;

  void _sendMessage(String message, Function sendMessage, int hostId) {
    if (message.isNotEmpty) {
      final chatStore = Provider.of<ChatStore>(context, listen: false);
      int newMessageId = _getNextMessageId(chatStore.messages[widget.guestId]);

      Map<String, dynamic> mess = {
        'id': newMessageId,
        'text_body': message,
        'sender': hostId,
        'receiver': widget.guestId,
        'delivery_status': false,
        'read_status': false,
      };

      sendMessage(mess, widget.guestId);
      _controller.clear();
    }
  }

  Future<void> _uploadMedia(
      String type, Function sendMessage, int hostId) async {
    final pickedFile = await _picker.pickImage(
        source: type == 'image' ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      String mediaUrl = await _uploadToApi(pickedFile);

      final chatStore = Provider.of<ChatStore>(context, listen: false);
      int newMessageId = _getNextMessageId(chatStore.messages[widget.guestId]);

      Map<String, dynamic> mess = {
        'id': newMessageId,
        'document_url': mediaUrl,
        'sender': hostId,
        'receiver': widget.guestId,
        'delivery_status': false,
        'read_status': false,
      };

      sendMessage(mess, widget.guestId);
    }
  }

  int _getNextMessageId(Map<int, Map<String, dynamic>>? messages) {
    if (messages == null || messages.isEmpty) {
      return 1;
    }
    return messages.keys.reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<String> _uploadToApi(XFile file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('chat_uploads/$fileName');
      UploadTask uploadTask = ref.putFile(File(file.path));

      Fluttertoast.showToast(
        msg: 'Uploading media',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey[200],
        textColor: Colors.white,
        fontSize: 16.0,
      );

      TaskSnapshot taskSnapshot = await uploadTask;
      Fluttertoast.cancel();
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading to Firebase: $e');
      Fluttertoast.showToast(
        msg: 'Error uploading media',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red[200],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return '';
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, int hostId) {
    String? hostUrl = context.read<DataStore>().patientData?['picture_url'];
    bool isSender = message['sender'] == hostId;
    Map tempData = context.read<ChatStore>().tempData;
    String status = message['read_status'] == true
        ? '✓✓'
        : message['delivery_status'] == true
            ? '✓✓'
            : '✓';

    if (message['read_status'] != true && message['sender'] != hostId) {
      tempData['readStatusFor'].add(message['id']);
      // print('adding to readstatusfor array for message id ${message['id']}');
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSender)
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.guestImage,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (!isSender) SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.green[100] : Colors.blue[100],
                    borderRadius: BorderRadius.only(
                      topLeft: isSender ? Radius.circular(10) : Radius.zero,
                      topRight: isSender ? Radius.zero : Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message['text_body'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            message['text_body'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      if (message['document_url'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: SizedBox(
                            height: 150,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  message['document_url'],
                                  height: 150,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image,
                                        size: 100, color: Colors.grey);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (message['sender'] == hostId)
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            color: message['read_status'] == true
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isSender) SizedBox(width: 8),
              if (isSender)
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: hostUrl != null
                          ? Image.network(
                              hostUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.person),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int hostId = context.read<DataStore>().doctorData?['id'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ChatStore>().tempData['idsWithUnreadMessages'].contains(widget.guestId)) {
    context.read<ChatStore>().removeFromUnreadList(widget.guestId);
    }
      final sendReadStatusAndOlderMessagesCall =
          context.read<ChatStore>().sendReadStatusAndOlderMessagesCall;
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        Map tempData = context.read<ChatStore>().tempData;
        // print('this is the oldermessages ======== ${tempData['loadedOlderMessages']}');
        if (!tempData['loadedOlderMessages'].contains(widget.guestId)) {
          tempData['getOlderMessagesFor'] = widget.guestId;
          // print('therefore sending to get older');
        }
        sendReadStatusAndOlderMessagesCall();
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.guestName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10,
                ),
              ],
            ),
            Text(
              'Available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.guestImage),
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: widget.guestPhoneNumber,
              );
              launchUrl(launchUri);
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatStore>(
              builder: (context, chatStore, _) {
                final messages = chatStore.messages[widget.guestId] ?? {};
                final sortedMessages = messages.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key));

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: sortedMessages.length,
                  itemBuilder: (context, index) {
                    final message = sortedMessages[index].value;
                    return _buildMessageBubble(message, hostId);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () => _uploadMedia(
                      'image', context.read<ChatStore>().sendMessage, hostId),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String trimmedMessage = _controller.text.trim();
                    if (trimmedMessage.isNotEmpty) {
                      _sendMessage(trimmedMessage,
                          context.read<ChatStore>().sendMessage, hostId);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
