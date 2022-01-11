import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';

class ChatMessage extends StatelessWidget {
  //const ChatMessage({ Key? key }) : super(key: key);
  ChatMessage(this.data, this.mine);
  final Map<String, dynamic> data;
  final bool mine;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          !mine
              ? Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['senderPhotoUrl']),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data['imgUrl'] != null
                    ? Image.network(
                        data['imgUrl'],
                        width: 250,
                      )
                    : Text(
                        data['text'],
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                Text(
                  data['senderName'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          mine
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['senderPhotoUrl']),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
