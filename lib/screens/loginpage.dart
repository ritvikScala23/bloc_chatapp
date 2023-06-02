import 'package:bloc_chatapp/screens/forgot_password.dart';
import 'package:bloc_chatapp/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/mybutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/mytext_fields.dart';
import '../components/square_tile.dart';
import '../models/userModel.dart';
import '../services/auth_service.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  bool showLoading = false;
  UserModel? userModel;
  final _auth = FirebaseAuth.instance;
  UserCredential? credential;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void navToForgotpage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ForgotPasswordPage();
    }));
  }

  void navToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegisterPage(onTap: () {});
    }));
  }

  void signInWithGoogle() async {
    setState(() {
      showLoading = true;
    });
    try {
      final currgooglesignIn = await AuthService().SignInWithGoogle();

      if (currgooglesignIn != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage(
            userModel: userModel!,
            user: credential!.user!,
          );
        }));

        final snackBar = SnackBar(
          content: Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text(
              'Google Signned-In Successfully!!',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: (Colors.tealAccent),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      setState(() {
        showLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      mErrorMessage(e.code);
    }
  }

  void checkValues() {
    String Email = email.trim();
    String Paswd = password.trim();

    if (Email == "" || Paswd == "") {
    } else {
      signin();
    }
  }

  void signin() async {
    setState(() {
      showLoading = true;
    });

    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      mErrorMessage(e.code.toString());
    }

    if (credential != null) {
      String uid = credential!.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage(
          userModel: userModel,
          user: credential!.user!,
        );
      }));
    }
    setState(() {
      showLoading = false;
    });
    //     if (currUser != null) {
    //       Navigator.push(context, MaterialPageRoute(builder: (context) {
    //         return HomePage();
    //       }));
    //
    //       final snackBar = SnackBar(
    //         content: Padding(
    //           padding: const EdgeInsets.all(15.0),
    //           child: const Text(
    //             'Logged-In Successfully!!',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //         backgroundColor: (Colors.tealAccent),
    //       );
    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     }
    //
    //     setState(() {
    //       showLoading = false;
    //     });
    //   } on FirebaseAuthException catch (e) {
    //     Navigator.pop(context);
    //     mErrorMessage(e.code);
    //   }
  }

// Custom Wrong EMail Error
  void mErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(message),
          );
        });

    // final snackBar = SnackBar(
    //   content: const Text(
    //     'Wrong Password!',
    //     style: TextStyle(color: Colors.white),
    //   ),
    //   backgroundColor: (Colors.black),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 26.0,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    MyTextFields(
                      mhintText: "Email",
                      mobsecureText: false,
                      onChanged: (value) {
                        email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    MyTextFields(
                      mhintText: "Password",
                      mobsecureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: navToForgotpage,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    MyButton(
                      onTap: signin,
                      btntitle: 'Sign In',
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Or Continue with",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          imagePath: "images/google.png",
                          onTap: () => signInWithGoogle(),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        SquareTile(
                          imagePath: "images/fb.png",
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: navToRegister,
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
