import 'package:bloc_chatapp/models/userModel.dart';
import 'package:bloc_chatapp/screens/profileupload.dart';
import 'package:bloc_chatapp/screens/searchpage.dart';
import 'package:bloc_chatapp/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../tiles/chat_tile.dart';
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
  List<String> AllData = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentUser();
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getIds() async {
    AllData = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              AllData.add(element.reference.id);
            }));
  }

  void navToChatPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatPage();
    }));
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
      return ProfileUpload();
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
              Navigator.pop(context);
              logoutSnackBar();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
              future: getIds(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: AllData.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(5),
                          child: ChatTile(documentId: AllData[index]));
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
