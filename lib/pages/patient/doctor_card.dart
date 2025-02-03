import 'package:flutter/material.dart';
import 'package:market_doctor/chat_store.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int id;
  final String profession;
  final double rating;
  final VoidCallback onChatPressed;
  final VoidCallback onViewProfilePressed;
  final VoidCallback onBookAppointmentPressed;

  DoctorCard({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.profession,
    required this.rating,
    required this.onChatPressed,
    required this.onViewProfilePressed,
    required this.onBookAppointmentPressed,
  });

  @override
  Widget build(BuildContext context) {
    final unreadList = context.read<ChatStore>().idsWithUnreadMessages;
    return Container(
        margin: EdgeInsets.only(top: 0, bottom: 8, right: 5, left: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]!
                : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3)),
          ],
        ),
        child: Container(
          height: 145,
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.network(
                  imageUrl,
                  width: 112,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4),
              Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Text(name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      width: 200,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          profession,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onViewProfilePressed,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                        child: Text('View Profile',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4.0),
                          Text('$rating',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: onChatPressed,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                        constraints: BoxConstraints(
                          minHeight: 24,
                        ),
                        child: Text('Chat with doctor',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    // SizedBox(height: 4,)
                  ]),
              SizedBox(width: 8.0),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Consumer<ChatStore>(builder: (context, chatStore, child) {
                        print(
                            'Consumer builder called! this is the list: ${chatStore.idsWithUnreadMessages}');
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (unreadList.contains(id))
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3.0, right: 3.0),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                          ],
                        );
                      }),
                      Spacer(),
                      GestureDetector(
                        onTap: onBookAppointmentPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Book',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
