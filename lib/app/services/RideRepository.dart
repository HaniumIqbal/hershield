import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hershield/app/modules/ride/UserLiveMap/model/UserLiveModel.dart';
import 'package:hershield/app/modules/ride/model/BookRideModel.dart';
import 'package:location/location.dart';

import '../../shared/easyloading.dart';

class RideRepository{
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
  Future<bool> addRide(BookRideModel model) async {
    print("MODEL"+model.toJson().toString());
    Loading.showLoading();
    try {
      await FirebaseFirestore.instance
          .collection('book_ride')
          .doc()
          .set(model.toJson());
      Loading.showSuccess();
      Loading.dismissLoading();
      // UserLiveModel userLiveModel = UserLiveModel(lat: model.lat, long: model.long);
      // addUserLiveLocation(userLiveModel);

      return true;
    } catch (e) {
      print("Error"+e.toString());
      Loading.showError();
      Loading.dismissLoading();
      return false;
    }
  }



  Stream<List<BookRideModel>> gettAllRideStream() {
    var data = FirebaseFirestore.instance
        .collection("book_ride")
        .orderBy("time", descending: true)
        // .where("YsUid", isEqualTo: ysCurrentUser)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) {
      var ysPaymentData = BookRideModel.fromJson(e.data());
      print(ysPaymentData.toJson());
      return ysPaymentData;
    }).toList());
    return data;
  }

  Future<void> updateRide(BookRideModel model) async {
    Loading.showLoading();
    try {
      await FirebaseFirestore.instance
          .collection('book_ride')
          .where('time',isEqualTo: model.time)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update(model.toJson());
        });
      });
      Loading.showSuccess();
      Loading.dismissLoading();

    } catch (e) {
      Loading.showError();
      Loading.dismissLoading();
    }
  }

  Future<void> addUserLiveLocation(UserLiveModel userLiveModel) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    print("ADD LIVE LOCATION"+ currentUserID.toString());
    try {
      await FirebaseFirestore.instance
          .collection('user_location')
          .doc(currentUserID)
          .set(userLiveModel.toJson());
      Loading.showSuccess();
      Loading.dismissLoading();
    } catch (e) {
      print(e);
      Loading.showError();
      Loading.dismissLoading();
    }
  }
  Future<void> updateLocationInFirebase(String lat, String long) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    print("USET ID "+currentUserID);
    try {
      await FirebaseFirestore.instance
          .collection('user_location')
          .doc(currentUserID)
          .set({
        "lat":lat,
        "long":long
      });

    }
    catch (e) {
      print('Error updating location: $e');
    }
  }

  Stream<UserLiveModel> getUserLocationByID(String id) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    print("Get data from firebase");
    print(id);
    return FirebaseFirestore.instance
        .collection("user_location")
        .doc(id)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        var rideModel = UserLiveModel.fromJson(data!);
        print(rideModel.toJson());
        return rideModel;
      } else {
        throw Exception('Document does not exist');
      }
    });
  }
}