import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:provider/provider.dart';

class ChewOrPatientCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int id;
  final VoidCallback onChatPressed;

  ChewOrPatientCard({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    final unreadList =
        context.read<ChatStore>().tempData['idsWithUnreadMessages'];
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
          height: 75,
          padding: const EdgeInsets.all(2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.network(
                  imageUrl,
                  width: 62,
                  height: 66,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                // Ensure this section fills available space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(), // Fills remaining space
                        if (unreadList.contains(id))
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onChatPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                        constraints: BoxConstraints(minHeight: 24),
                        child: Text(
                          'Open Chat',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
