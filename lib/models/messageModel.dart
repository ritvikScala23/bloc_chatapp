class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;
  String? messageId;

  MessageModel(
      {this.sender, this.text, this.seen, this.createdOn, this.messageId});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdOn = map["createdon"].toDate();
    messageId = map["messageId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdOn,
      "messageId": messageId
    };
  }
}
