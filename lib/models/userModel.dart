class UserModel {
  String? uid;
  String? fullName;
  String? profilepic;
  String? email;

  UserModel({this.uid, this.fullName, this.profilepic, this.email});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    profilepic = map["profilepic"];
    email = map["email"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "profilepic": profilepic,
      "email": email
    };
  }
}
