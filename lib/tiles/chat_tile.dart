import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chatModel.dart';
import '../screens/chatpage.dart';

class ChatTile extends StatelessWidget {
  //final Item item;

  final String documentId;

  const ChatTile({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void navToChatPage() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatPage();
      }));
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            if (snapshot.data!.data() != null) {
              return Card(
                  color: Colors.lightBlueAccent.shade700,
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        onTap: navToChatPage,
                        leading: CircleAvatar(
                            backgroundColor: Colors.lightBlueAccent.shade400,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            )),
                        tileColor: Colors.tealAccent.shade400,
                        title: Text('${data['fname']}' + ' ${data['lname']}',
                            style: TextStyle(color: Colors.white))),
                  ));
            }
          }
          return Text('Loading...');
        });
  }
}
// return Card(
//   color: Colors.white,
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: ListTile(
//       onTap: navToChatPage,
//       leading: Image.asset(item.image),
//       title: Text(
//         item.name,
//         style: TextStyle(color: Colors.black),
//       ),
//       subtitle: Text(item.desc, style: TextStyle(color: Colors.black)),
//       trailing: Padding(
//         padding: const EdgeInsets.only(bottom: 25),
//         child: Text(
//           item.lastseen,
//           textScaleFactor: 1.5,
//           style: TextStyle(
//             fontSize: 8,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//       ),
//     ),
//   ),
// );
