import 'package:bloc_chatapp/models/userModel.dart';
import 'package:bloc_chatapp/screens/complete_profile.dart';
import 'package:bloc_chatapp/screens/homepage.dart';
import 'package:bloc_chatapp/screens/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/mybutton.dart';
import '../components/mytext_fields.dart';
import '../components/square_tile.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String fname;
  late String lname;
  late String email;
  late String pswd;
  late String conpswd;
  bool showLoading = false;

  final _auth = FirebaseAuth.instance;
  UserCredential? credential;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ConpasswordController = TextEditingController();

  void checkValue() {
    String Email = email.trim();
    String Password = pswd.trim();
    String Cpaswd = conpswd.trim();

    if (Email == "" || Password == "" || Cpaswd == "") {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Error"),
                content: const Text("Please fill all data fields"),
              ));
    } else if (Password != Cpaswd) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Error"),
                content: const Text("Password Does not match"),
              ));
    } else {
      signUp();
    }
  }

  navigateToCompleteprofile(UserModel newUser, User user) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: const Text(
          'Regitration Successfull!!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: (Colors.tealAccent),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CompleteProfile(usermodel: newUser, user: credential!.user!,);
    }));
  }

  void signUp() async {
    setState(() {
      showLoading = true;
    });
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pswd);
    } on FirebaseAuthException catch (e) {
      mErrorMessage(e.code.toString());
    }

    if (credential != null) {
      String uid = credential!.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullName: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) => navigateToCompleteprofile(newUser, credential!.user!));
    }
    setState(() {
      showLoading = false;
    });
  }

  //   if (newUser != null) {
  //     addUserDetails(email.trim(), fname.trim(), lname.trim());
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return HomePage();
  //     }));
  //
  //     final snackBar = SnackBar(
  //       content: Padding(
  //         padding: const EdgeInsets.all(15.0),
  //         child: const Text(
  //           'Registered Successfully!!',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //       backgroundColor: (Colors.tealAccent.shade700),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  //   setState(() {
  //     showLoading = false;
  //   });
  // } on FirebaseAuthException catch (e) {
  //   Navigator.pop(context);
  //   mErrorMessage(e.code);
  // }

  // try {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text, password: passwordController.text);
  //   Navigator.pop(context);
  // } on FirebaseAuthException catch (e) {
  //   Navigator.pop(context);
  //   mErrorMessage(e.code);
  // }

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
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
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
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    MyTextFields(
                      mhintText: "First Name",
                      mobsecureText: false,
                      onChanged: (value) {
                        fname = value;
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    MyTextFields(
                      mhintText: "Last Name",
                      mobsecureText: false,
                      onChanged: (value) {
                        lname = value;
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    MyTextFields(
                      mhintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      mobsecureText: false,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    MyTextFields(
                      mhintText: "Password",
                      mobsecureText: true,
                      onChanged: (value) {
                        pswd = value;
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    MyTextFields(
                      mhintText: "Confirm Password",
                      mobsecureText: true,
                      onChanged: (value) {
                        conpswd = value;
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    MyButton(
                      onTap: checkValue,
                      btntitle: "Sign Up",
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
                            onTap: () => AuthService().SignInWithGoogle()),
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
                          "Already Have an Account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginPage(onTap: () {});
                            }));
                          },
                          child: Text(
                            "Login Here",
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
