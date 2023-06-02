import 'package:bloc_chatapp/components/mybutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/mytext_fields.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late String forgotpswd;

  Future resetPaswd() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgotpswd.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("We've sent you reset link, please check..."),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 25),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Roboto"),
                        ),
                      ),
                      MyTextFields(
                        mhintText: "Email",
                        mobsecureText: false,
                        onChanged: (value) {
                          forgotpswd = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyButton(onTap: resetPaswd, btntitle: "Reset")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
