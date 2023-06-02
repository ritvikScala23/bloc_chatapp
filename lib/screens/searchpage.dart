import 'dart:developer';

import 'package:bloc_chatapp/components/mybutton.dart';
import 'package:bloc_chatapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../components/mytext_fields.dart';
import '../models/ChatroomModel.dart';
import 'chatpage.dart';

class SearchPage extends StatefulWidget {
  final User? user;
  final UserModel? userModel;

  SearchPage({super.key, required this.user, required this.userModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var uuid = Uuid();
  final TextEditingController seachController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
      ChatRoomModel? chatRoom;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${widget.userModel!.uid}", isEqualTo: true)
          .where("participants.${targetUser.uid}", isEqualTo: true)
          .get();

      if (snapshot.docs.length > 0) {
        // Fetch the existing one
        var docData = snapshot.docs[0].data();
        ChatRoomModel existingChatroom =
            ChatRoomModel.fromMap(docData as Map<String, dynamic>);

        chatRoom = existingChatroom;
      } else {
        // Create a new one
        ChatRoomModel newChatroom = ChatRoomModel(
          chatRoomId: uuid.v1(),
          lastMessage: "",
          participants: {
            widget.userModel!.uid.toString(): true,
            targetUser.uid.toString(): true,
          },
        );

        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(newChatroom.chatRoomId)
            .set(newChatroom.toMap());

        chatRoom = newChatroom;

        log("New Chatroom Created!");
      }

      return chatRoom;
    }

    void back() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5,right: 10),
                        child: TextField(
                            controller: seachController,
                            onChanged: (String) {},
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            )),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.search,
                            size: 35,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {});
              //   },
              //   child: Text("Search"),
              // ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: seachController.text)
                      .where("email", isNotEqualTo: widget.userModel!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        if (dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatroomModel =
                                  await getChatroomModel(searchedUser);

                              if (chatroomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChatPage(
                                    targetUser: searchedUser,
                                    userModel: widget.userModel,
                                    chatRoom: chatroomModel,
                                    user: widget.user,
                                  );
                                }));
                              }
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchedUser.profilepic!),
                              backgroundColor: Colors.grey[500],
                            ),
                            title: Text(searchedUser.fullName!),
                            subtitle: Text(searchedUser.email!),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          );
                        } else {
                          return Text("No results found!");
                        }
                      } else if (snapshot.hasError) {
                        return Text("An error occured!");
                      } else {
                        return Text("No results found!");
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
