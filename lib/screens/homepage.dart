import 'dart:developer';
import 'package:bloc_chatapp/models/userModel.dart';
import 'package:bloc_chatapp/screens/loginpage.dart';
import 'package:bloc_chatapp/screens/profileupload.dart';
import 'package:bloc_chatapp/screens/searchpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/ChatroomModel.dart';
import '../models/firebasehelper.dart';
import 'chatpage.dart';

final _auth = FirebaseAuth.instance;
late User loggedInUser;

//final _fireStore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const HomePage({super.key, required this.userModel, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navToChatPage() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return ChatPage();
    // }));
  }

  void logoutSnackBar() {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: const Text(
          'Logged-Out Successfully!!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: (Colors.tealAccent),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProfileUpload(
        userModel: widget.userModel,
        user: widget.user,
      );
    }));
  }

  void navigateToSearchPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchPage(
        user: widget.user,
        userModel: widget.userModel,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(
                child: Text(
              "Your Chats",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            )),
          ),
          IconButton(
              onPressed: navigateToSearchPage,
              icon: Icon(
                Icons.search,
                size: 30,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
                onTap: navigateToProfile,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userModel.profilepic!),
                )),
          ),
          IconButton(
            onPressed: () {
              _auth.signOut();
              GoogleSignIn().signOut();
              navigateToLoginPage();
              logoutSnackBar();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chatrooms")
            .where("participants.${widget.userModel.uid}", isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

              return ListView.builder(
                itemCount: chatRoomSnapshot.docs.length,
                itemBuilder: (context, index) {
                  ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                      chatRoomSnapshot.docs[index].data()
                          as Map<String, dynamic>);
                  log(chatRoomModel.participants.toString());

                  Map<String, dynamic> participants =
                      chatRoomModel.participants!;

                  List<String> participantKeys = participants.keys.toList();
                  participantKeys.remove(widget.userModel.uid);

                  return FutureBuilder<UserModel>(
                    future: FirebaseHelper.getUserModelbyId(participantKeys[0]),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          UserModel? targetUser = userData.data;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatPage(
                                        chatRoom: chatRoomModel,
                                        user: widget.user,
                                        userModel: widget.userModel,
                                        targetUser: targetUser,
                                      );
                                    }),
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      targetUser!.profilepic.toString()),
                                ),
                                title: Text(targetUser.fullName.toString()),
                                subtitle: (chatRoomModel.lastMessage
                                            .toString() !=
                                        "")
                                    ? Text(chatRoomModel.lastMessage.toString())
                                    : Text(
                                        "Say hi to your new friend!",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              log("Error no data");
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Center(
                child: Text("No Chats"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void navigateToLoginPage() async {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginPage(onTap: () {});
    }));
  }
}
