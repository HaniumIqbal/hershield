import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/app/modules/signup/model/UserInformation.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/shared/easyloading.dart';

class UpdateChatRepository {
  Stream<List<MessageModel>> getAllMessagesStream() {
    var data = FirebaseFirestore.instance
        .collection("chat_room")
        .orderBy("timestamp", descending: false)
        // .where("YsUid", isEqualTo: ysCurrentUser)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) {
              var ysPaymentData = MessageModel.fromJson(e.data());
              print(ysPaymentData.toJson());
              return ysPaymentData;
            }).toList());
    return data;
  }

  Future<void> deleteMessage(MessageModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_room')
          .where("senderID", isEqualTo: model.senderID);
      await FirebaseFirestore.instance
          .collection('chat_room')
          .where('senderID', isEqualTo: model.senderID)
          .where('timestamp', isEqualTo: model.timestamp)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      Get.snackbar("Delete", "Message deleted successfully!",
          colorText: Colors.white, backgroundColor: Colors.green);
    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }
}
