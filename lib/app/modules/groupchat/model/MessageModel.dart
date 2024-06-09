class MessageModel {
  String message, senderID, replyTo, timestamp;
  String? senderName;

  MessageModel(
      {required this.message,
      required this.senderID,
      required this.replyTo,
      required this.timestamp,
      required this.senderName});

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "senderID": senderID,
      "replyTo": replyTo,
      "timestamp": timestamp,
      "senderName": senderName,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json["message"],
      senderID: json["senderID"],
      replyTo: json["replyTo"],
      timestamp: json["timestamp"],
      senderName: json["senderName"] ?? "",
    );
  }
//

//
  // factory MessageModel.fromJson(Map<String, dynamic> json) {
  //   return MessageModel(
  //     message: json["message"],
  //     senderID: json["senderID"],
  //     senderName: json["senderName"],
  //     replyTo: json["replyTo"],
  //     timestamp: json["timestamp"],
  //   );
  // }
  //
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     "message": message,
  //     "senderID": senderID,
  //     "senderName": senderName,
  //     "replyTo": replyTo,
  //     "timestamp": timestamp,
  //   };
  // }
  //
  // MessageModel(
  //     {required this.message,
  //     required this.senderID,
  //     required this.senderName,
  //     required this.replyTo,
  //     required this.timestamp});
}
