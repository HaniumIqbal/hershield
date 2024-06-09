import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/app/modules/signup/model/UserInformation.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/shared/easyloading.dart';

class ChatRepository {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendMessage(MessageModel model) async {
    try {
      model.senderID = currentUserID;
      await FirebaseFirestore.instance
          .collection('chat_room')
          .doc()
          .set(model.toJson());
    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }

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
}
