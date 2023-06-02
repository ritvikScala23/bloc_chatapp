class ChatRoomModel {
  String? chatRoomId;
  List<String>? particaipants;

  ChatRoomModel({this.chatRoomId, this.particaipants});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["chatroomId"];
    particaipants = map["participants"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomId": chatRoomId,
      "participants": particaipants,
    };
  }
}
