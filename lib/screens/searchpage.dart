import 'package:bloc_chatapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final User? user;
  final UserModel? userModel;

  SearchPage({super.key, required this.user, required this.userModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController seachController = TextEditingController();

    void back() {
      Navigator.pop(context);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextField(
//        onChanged: (value) => updateList(value),
                          controller: seachController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: IconButton(
                              onPressed: back,
                              icon: Icon(Icons.arrow_back),
                            ),
                            prefixIconColor: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Icon(
                          Icons.search,
                          size: 30,
                        ))
                  ],
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: seachController.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel userModel = UserModel.fromMap(userMap);
                        return ListTile(
                          leading: CircleAvatar(
                            child: Image.network(userModel.profilepic!),
                          ),
                          title: Text(userModel.email!),
                          subtitle: Text(userModel.fullName!),
                        );
                      } else {
                        return Text("No result found");
                      }
                    } else if (snapshot.hasError) {
                      return Text("Error Occured!!");
                    } else {
                      return Text("No result found");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
