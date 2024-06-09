import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/admin_app/adminHome/model/EmeregencyHubDataModel.dart';
import 'package:hershield/app/modules/groupchat/model/ExploreFeature.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/app/modules/home/views/home_view.dart';
import 'package:hershield/app/modules/profile/views/profile_view.dart';
import 'package:hershield/app/modules/setting/views/setting_view.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/app/services/HubRepository.dart';
import 'package:hershield/app/services/RideRepository.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/constant/strings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:location/location.dart' as loc;


import '../../policeHelpLine/model/ListTileModel.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController'
  List<ListTileModel> modelList = [];
  late StreamSubscription<loc.Location> _locationStream;
  List<ListTileModel> auratModelListInfo = [];
  HubRepository repository = HubRepository();
  List<ListTileModel> ambulanceModelListInfo = [];
  List<ExploreFeature> exploreFeatureModelListInfo = [];
  RxList<EmergencyHubModel> homeModel = RxList<EmergencyHubModel>();
  HubRepository hubRepository = HubRepository();
  RideRepository rideRepository = RideRepository();
  final userdID = FirebaseAuth.instance.currentUser!.uid;
  final loc.Location locations= loc.Location();

  String? _currentAddress;
  Position? _currentPosition;
  List<Widget> screen = [
    ProfileView(),
    const HomeView(),
    const SettingView(),
  ];
  RxInt currentIndex = 1.obs;
  List<String> quoteList = [];
  final count = 0.obs;
  @override
  void onInit() {
    setData();
    getHubData();
    rideRepository.getUserLocationByID(userdID).first.then((value) {
      if(value.lat != "0.0"){
        BackgroundLocation.isServiceRunning().then((value) {
          if(!value){
            BackgroundLocation.startLocationService(distanceFilter: 10);
          }
          else{
          }
        });
      }
    });
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
  }
  Future<void> listenLocation() async {
    _locationStream = locations.onLocationChanged.handleError((onError){
      print(onError);
      _locationStream.cancel();
    }).listen((currentLocation) {
      rideRepository.updateLocationInFirebase(currentLocation.latitude.toString(),currentLocation.longitude.toString());
      print("Listen location");
    }) as StreamSubscription<loc.Location>;

  }
  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void setData() {
    quoteList.add(quote1);
    quoteList.add(quote2);
    quoteList.add(quote3);
    quoteList.add(quote4);
    quoteList.add(quote5);
    quoteList.add(quote6);
    /// EXPLORE-FEATURE INFO LIST
    exploreFeatureModelListInfo.add(ExploreFeature("Empowering network",
        groupChatIconPath, Routes.GROUPCHAT, "Group Chat"));
    exploreFeatureModelListInfo
        .add(ExploreFeature(self, selfIcon, Routes.SELFDEFENCE, self));
    exploreFeatureModelListInfo
        .add(ExploreFeature(location, locationIcon, "", location));
    exploreFeatureModelListInfo.add(ExploreFeature(
        'Crowd sourced map and ratings', mapHomeImage, Routes.MAP, ''));
    exploreFeatureModelListInfo
        .add(ExploreFeature('Carpooling', rideHomeImage, Routes.RIDE, ''));
    exploreFeatureModelListInfo
        .add(ExploreFeature('File a legal complain', complaintImage, Routes.COMPLAIN, ''));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Disable",
          'Location services are disabled. Please enable the services',
          backgroundColor: Colors.green);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Denied", "'Location permissions are denied'",
            backgroundColor: Colors.green);

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission rejected",
          'Location permissions are permanently denied, we cannot request permissions.',
          backgroundColor: Colors.green);
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      print("DAR STREET");
      print(_currentAddress);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void onShare(BuildContext context) async {
    String query = Uri.encodeComponent(_currentAddress!);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    final result = await Share.shareWithResult(googleUrl);

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing my website!');
    }
  }

  Stream<List<EmergencyHubModel>> getHubData() {
    hubRepository.getAllHubData().listen((event) {
      homeModel.value = event;
      print(homeModel.value[0].argument[0].subTtile);
    });
    return repository.getAllHubData();
  }
}
