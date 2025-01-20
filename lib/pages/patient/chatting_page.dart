import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_doctor/chat_store.dart';
import 'package:market_doctor/data_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _sendMessage(String message, int hostId) async {
    Map<String, dynamic> mess = {
      'text_body': message,
      'sender': hostId,
      'receiver': widget.guestId,
      'delivery_status': false,
      'read_status': false,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };

    final bool didSend =
        await context.read<ChatStore>().sendMessage(mess, widget.guestId);
    print('this is the state of the didSend: $didSend');
    if (didSend) {
      _controller.clear();
    }
  }

  Future<void> _uploadMedia(
      String type, Function sendMessage, int hostId) async {
    final pickedFile = await _picker.pickImage(
        source: type == 'image' ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      String mediaUrl = await _uploadToApi(pickedFile);

      Map<String, dynamic> mess = {
        'document_url': mediaUrl,
        'sender': hostId,
        'receiver': widget.guestId,
        'delivery_status': false,
        'read_status': false,
      };

      sendMessage(mess, widget.guestId);
    }
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
    final chatStore = context.read<ChatStore>();
    String status = message['read_status'] == true
        ? '✓✓'
        : message['delivery_status'] == true
            ? '✓✓'
            : '✓';

    if (message['read_status'] != true && message['sender'] != hostId) {
      chatStore.sendReadStatus(message['id'], message['sender']);
      chatStore.updateDbRead(message['id'], message['sender']);
      //this line above is ideally supposed to only call after sendreadstatus returns the ack of yes we sent. but that requires an emitwithack on this socket call
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
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback for network errors or invalid URLs
                          return Icon(Icons.person, size: 40);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
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
                                      return child; // Image loaded successfully
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    // Show a broken image icon if the image fails to load
                                    return Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                    );
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
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback for network errors or invalid URLs
                                return Icon(Icons.person, size: 72);
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )
                          : null, // No fallback for null hostUrl
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
    int hostId = context.read<DataStore>().patientData?['id'];

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
            child: ClipOval(
              child: Image.network(
                widget.guestImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback for network errors or invalid URLs
                  return Icon(Icons.person, size: 40);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
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
                  ..sort((a, b) => DateTime.parse(a.value['createdAt'])
                      .compareTo(DateTime.parse(b.value['createdAt'])));

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }
                  if (context
                      .read<ChatStore>()
                      .idsWithUnreadMessages
                      .contains(widget.guestId)) {
                    print(
                        'calling remove on idswithunread for id ${widget.guestId}');
                    context
                        .read<ChatStore>()
                        .removeFromUnreadList(widget.guestId);
                  }

                  if (ModalRoute.of(context)?.isCurrent ?? false) {
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
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String trimmedMessage = _controller.text.trim();
                    if (trimmedMessage.isNotEmpty) {
                      _sendMessage(trimmedMessage, hostId);
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
