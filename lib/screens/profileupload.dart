import 'package:bloc_chatapp/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileUpload extends StatefulWidget {
  UserModel? userModel;
  User? user;

  ProfileUpload({required this.userModel, required this.user});

  @override
  State<ProfileUpload> createState() => _ProfileUploadState();
}

class _ProfileUploadState extends State<ProfileUpload> {
  File? galleryFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 20,
        title: Text("Profile"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 200.0,
                        width: 300.0,
                        child: CircleAvatar(
                          radius: 120,
                          child: CircleAvatar(
                            radius: 110,
                            backgroundImage: NetworkImage(
                                widget.userModel!.profilepic.toString()),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(widget.userModel!.fullName.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                SizedBox(
                  height: 10.0,
                ),
                Text(widget.userModel!.email.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                SizedBox(
                  height: 30.0,
                ),



                // ElevatedButton(
                //   style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all(
                //           Colors.deepOrange.shade400)),
                //   child: const Text('Select Image'),
                //   onPressed: () {
                //     _showPicker(context: context);
                //   },
//                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
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
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
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
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
