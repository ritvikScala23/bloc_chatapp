import 'dart:async';
import 'package:bloc_chatapp/models/firebasehelper.dart';
import 'package:bloc_chatapp/models/userModel.dart';
import 'package:bloc_chatapp/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/loginpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? currentuser = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),
        () => (currentuser
        !=null)?navigateToHome():navigateToLogin());
  }

  navigateToHome() async {
    UserModel thisUserModel = await FirebaseHelper.getUserModelbyId(currentuser!.uid);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage(userModel: thisUserModel, user: currentuser!);
    }));
  }

   navigateToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginPage(onTap: () {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 260,
              width: 400,
              child: Image.asset(
                "images/chatlogo.png",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Let's Chat",
              style: TextStyle(
                  fontFamily: 'RubikWetPaint',
                  fontWeight: FontWeight.w700,
                  fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
