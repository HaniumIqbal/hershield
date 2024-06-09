import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/admin_app/adminHome/model/EmeregencyHubDataModel.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/shared/easyloading.dart';

class HubRepository {
  Future<void> addHubData(EmergencyHubModel model, String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection('hub_data')
          .doc(docID)
          .set(model.toJson());
    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }

  Stream<List<EmergencyHubModel>> getAllHubData() {
    var data = FirebaseFirestore.instance
        .collection("hub_data")
        .orderBy("docID", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) {
              var ysPaymentData = EmergencyHubModel.fromJson(e.data());
              return ysPaymentData;
            }).toList());
    return data;
  }

  Future<void> updateHubData(EmergencyHubModel model, String docID) async {
    try {
      Loading.showLoading();
      await FirebaseFirestore.instance
          .collection('hub_data')
          .doc(docID)
          .update(model.toJson());
      Loading.dismissLoading();
      Get.snackbar("Success", "Updated successfully!",
          colorText: Colors.white, backgroundColor: Colors.green);
    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }
}
