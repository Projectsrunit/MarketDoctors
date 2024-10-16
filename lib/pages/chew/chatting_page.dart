import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_doctor/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChattingPage extends StatefulWidget {
  final String doctorName;
  final String doctorImage;
  final String doctorPhoneNumber;
  final int doctorId;

  ChattingPage({
    required this.doctorName,
    required this.doctorImage,
    required this.doctorPhoneNumber,
    required this.doctorId,
  });

  @override
  ChattingPageState createState() => ChattingPageState();
}

class ChattingPageState extends State<ChattingPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool loadedOlderMessages = false;
  ChatStore? chatStore;
  RealTimeDelivery? deliverer;

  @override
  void initState() {
    super.initState();
    deliverer = context.read<RealTimeDelivery>();
    deliverer?.addListener(doDeliveryChecks);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void doDeliveryChecks() {
    final latestsMap = deliverer?.latestsMap;
    if (latestsMap?[widget.doctorId] != null) {
      latestsMap?[widget.doctorId]?.forEach((messageId, message) {
        _handleMessageStatus(message, messageId);

      });
      deliverer?.removeLatestsMessage(widget.doctorId);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      if (!loadedOlderMessages) {
        _loadOlderMessages();
        _checkAndSendUnreadDeliveryStatuses();
      }
    });
  }

  void _checkAndSendUnreadDeliveryStatuses() {
    final messages = chatStore?.messages[widget.doctorId] ?? {};

    messages.forEach((messageId, message) {
      if (message['sender'] == widget.doctorId) {
        if (message['delivery_status'] != true) {
          chatStore?.sendDeliveryStatus(messageId);
        }

        if (message['read_status'] == false || message['read_status'] == null) {
          chatStore?.sendReadStatus(messageId);
        }
      }
    });
  }

  void _handleMessageStatus(Map<String, dynamic>? message, int messageId) {
    ChatStore chatStore = context.read<ChatStore>();
    if (message?['delivery_status'] != true) {
      chatStore.sendDeliveryStatus(messageId);
    }

    if (message?['read_status'] == false || message?['read_status'] == null) {
      chatStore.sendReadStatus(messageId);
    }
  }

  void _loadOlderMessages() {
    int chewId = context.read<DataStore>().chewData?['id'];

    Map<String, dynamic> requestParams = {
      'own_id': chewId,
      'other_id': widget.doctorId,
    };

    final messages = chatStore?.messages[widget.doctorId] ?? {};

    if (messages.isNotEmpty) {
      int oldestMessageId = messages.keys.reduce((a, b) => a < b ? a : b);
      String? oldestMessageDate = messages[oldestMessageId]?['createdAt'];
      if (oldestMessageDate != null) {
        requestParams['oldest_message_date'] = oldestMessageDate;
      }
    }

    chatStore?.getOlderMessages(requestParams);
    loadedOlderMessages = true;
  }

  void _sendMessage(String message, Function sendMessage, int chewId) {
    if (message.isNotEmpty) {
      final chatStore = Provider.of<ChatStore>(context, listen: false);
      int newMessageId = _getNextMessageId(chatStore.messages[widget.doctorId]);

      Map<String, dynamic> mess = {
        'id': newMessageId,
        'text_body': message,
        'sender': chewId,
        'receiver': widget.doctorId,
        'delivery_status': false,
        'read_status': false,
      };

      sendMessage(mess, widget.doctorId);
      _controller.clear();
    }
  }

  Future<void> _uploadMedia(
      String type, Function sendMessage, int chewId) async {
    final pickedFile = await _picker.pickImage(
        source: type == 'image' ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      String mediaUrl = await _uploadToApi(pickedFile);

      final chatStore = Provider.of<ChatStore>(context, listen: false);
      int newMessageId = _getNextMessageId(chatStore.messages[widget.doctorId]);

      Map<String, dynamic> mess = {
        'id': newMessageId,
        'document_url': mediaUrl,
        'sender': chewId,
        'receiver': widget.doctorId,
        'delivery_status': false,
        'read_status': false,
      };

      sendMessage(mess, widget.doctorId);
    }
  }

  int _getNextMessageId(Map<int, Map<String, dynamic>>? messages) {
    if (messages == null || messages.isEmpty) {
      return 1;
    }
    return messages.keys.reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<String> _uploadToApi(XFile file) async {
    await Future.delayed(Duration(seconds: 2));
    return 'https://example.com/uploads/${file.name}';
  }

  Widget _buildMessageBubble(Map<String, dynamic>? message, int chewId) {
    String? chewUrl = context.read<DataStore>().chewData?['picture_url'];
    bool isSender = message?['sender'] == chewId;
    String status = message?['delivery_status'] == true ? '✓✓' : '✓';

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
                      widget.doctorImage,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              if (!isSender) SizedBox(width: 8),
              Expanded(
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
                      if (message?['text_body'] != null)
                        Text(
                          message?['text_body'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      if (message?['document_url'] != null)
                        Image.network(
                          message?['document_url'],
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      if (message?['sender'] == chewId)
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            color: message?['read_status'] == true
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
                  radius: 14, // Adjust radius as needed
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, width: 2, // Grey border
                      ),
                    ),
                    child: ClipOval(
                      child: chewUrl != null
                          ? Image.network(
                              chewUrl,
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
    int chewId = context.read<DataStore>().chewData?['id'];

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
                  widget.doctorName,
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
            backgroundImage: NetworkImage(widget.doctorImage),
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: widget.doctorPhoneNumber,
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
                final messages = chatStore.messages[widget.doctorId] ?? {};
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
                    return _buildMessageBubble(message, chewId);
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
                      'image', context.read<ChatStore>().sendMessage, chewId),
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
                  onPressed: () => _sendMessage(_controller.text,
                      context.read<ChatStore>().sendMessage, chewId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
