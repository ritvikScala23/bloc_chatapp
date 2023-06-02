import 'package:bloc_chatapp/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static Future<UserModel> getUserModelbyId(String uId) async {
    UserModel? userModel;

    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();

    if (docSnapshot.data() != null) {
      userModel = UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    }
    return userModel!;
  }
}
