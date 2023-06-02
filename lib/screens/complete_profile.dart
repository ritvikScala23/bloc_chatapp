import 'dart:developer';
import 'dart:io';
import 'package:bloc_chatapp/components/mybutton.dart';
import 'package:bloc_chatapp/components/mytext_fields.dart';
import 'package:bloc_chatapp/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../models/userModel.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel usermodel;
  final User user;

  const CompleteProfile(
      {super.key, required this.usermodel, required this.user});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? galleryFile;

  final picker = ImagePicker();

  TextEditingController fncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: _showPicker,
              child: CircleAvatar(
                backgroundColor: Colors.tealAccent[700],
                radius: 100,
                backgroundImage:
                    (galleryFile != null) ? FileImage(galleryFile!) : null,
                child: (galleryFile == null)
                    ? Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyTextFields(
                controller: fncontroller,
                mhintText: "Full Name",
                mobsecureText: false,
                onChanged: (value) {}),
            SizedBox(
              height: 30,
            ),
            MyButton(
              onTap: checkValue,
              btntitle: "Submit",
            )
          ],
        ),
      ),
    );
  }

  _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          cropImage(pickedFile);
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  void cropImage(XFile? file) async {
    File? croppedImage = (await ImageCropper.platform.cropImage(
        sourcePath: file!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20)) as File?;
    if (croppedImage != null) {
      setState(() {
        galleryFile = croppedImage;
      });
    }
  }

  checkValue() {
    if (fncontroller == "" || galleryFile == "") {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Error"),
                content: const Text("Please fill all data fields"),
              ));
    } else {
      log("Data Uplaoding....");
      uploadImage();
    }
  }

  Future uploadImage() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepic")
        .child(widget.usermodel.uid.toString())
        .putFile(galleryFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = fncontroller.text.trim();

    widget.usermodel.fullName = fullName;
    widget.usermodel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.usermodel.uid)
        .set(widget.usermodel.toMap())
        .then((value) => navigateToHomePage());
  }

  navigateToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage(
        userModel: widget.usermodel,
        user: widget.user,
      );
    }));

    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: const Text(
          'Profile Created Successfull!!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: (Colors.tealAccent),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  snackBarShow() {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: const Text(
          'All Set!!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: (Colors.tealAccent),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
