import 'dart:async';
import 'dart:ffi';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hershield/app/modules/ride/UserLiveMap/model/UserLiveModel.dart';
import 'package:hershield/app/modules/ride/model/BookRideModel.dart';
import 'package:hershield/app/services/RideRepository.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/constant/strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class UserLiveMapController extends GetxController {
  int argument = Get.arguments;
  RxBool isCameraMoving = false.obs;
  final loc.Location location= loc.Location();
  RxSet<Marker> markers = RxSet<Marker>();
  Completer<GoogleMapController> mapController = Completer();

  GoogleMapController? googleMapController;

  late StreamSubscription<Position> positionStream;
  Rx<LatLng> startLat = Rx<LatLng>(const LatLng(0.0,0.0));
  Rx<LatLng> destinationLong = Rx<LatLng>(const LatLng(0.0,0.0));
  Rx<LatLng> currentLatLong = Rx<LatLng>(const LatLng(0.0,0.0));
  RideRepository repository =  RideRepository();
  RxMap<PolylineId, Polyline> polylines = RxMap<PolylineId, Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Rx<CameraPosition> kGooglePlex = Rx<CameraPosition>(const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 10,
  ));

  String googleAPiKey = "AIzaSyCtu2D7oPKi14KiW2r0FY-asw086BSEsh4";
  Rx<UserLiveModel> userLiveModel = Rx<UserLiveModel>(UserLiveModel(lat: "0.0",long: "0.0"));
  Rx<BookRideModel> argumentModel = Rx<BookRideModel>(BookRideModel(
    // Initialize with default values or leave them empty/null
    userID: '',
    fromPlace: '',
    toPlace: '',
    time: '',
    totalDistance: '',
    totalFare: '',
    userName: '',
    phoneNo: 0, // or whatever default value makes sense
    capacity: 0, // or whatever default value makes sense
    acceptedUserList: [], // or null if empty list is not needed by default
    yourfare: '',
    lat: '',
    long: '',
  ));

  @override
  Future<void> onInit() async {
    super.onInit();
    googleMapController = await mapController.future ;

    getAllBookRide();
   // listenLocation();
    // getPolyline();
  }
  BookRideModel getAllBookRide() {
    repository.gettAllRideStream().listen((event) async {
      argumentModel.value = event[argument];
      print("ARG ${argumentModel.value.toPlace}");
      startLat.value = await getCoordinatesFromAddress(argumentModel.value.fromPlace);
      destinationLong.value = await getCoordinatesFromAddress(argumentModel.value.toPlace);
      getUserLiveLocation();
      getPolyline();

    });
    return argumentModel.value;
  }

  UserLiveModel getUserLiveLocation() {
    print('object');

    repository.getUserLocationByID(argumentModel.value.userID).listen((event) async {
      userLiveModel.value = event;
      // print(argumentModel.value.lat);
      currentLatLong.value = LatLng(double.parse(userLiveModel.value.lat), double.parse(userLiveModel.value.long));
      updateCameraPosition();
      showPinsOnMap();
      updateMarker();

    });
    return userLiveModel.value;
  }

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    LatLng latLng = const LatLng(0.0, 0.0);
    try {
      var locations = await locationFromAddress(address);
      for (var location in locations) {
        latLng =  LatLng(location.latitude,location.longitude);
        print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
      }
      return  latLng;
    } catch (e) {
      return latLng;

    }
  }

  Future<void> checkLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {

      print("PERMISSION GRANTED");
    } else {
      // Handle denied permission
      checkLocationPermission();
    }
  }

  void getPolyline() async {
    print('Poly line lat long');
    print(startLat.value.latitude);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(startLat.value.latitude, startLat.value.longitude),
        PointLatLng(destinationLong.value.latitude, destinationLong.value.longitude),
        travelMode: TravelMode.driving,
        );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
     addPolyLine();
  }
  void addPolyLine() {
    PolylineId id = PolylineId("poly");

    Polyline polyline = Polyline(
      width: 4,
        polylineId: id, color: MyColor.pinkTextColor, points: polylineCoordinates);
    polylines[id] = polyline;
  }



  Future<void> showPinsOnMap() async {


    print("UPDATED LOCATION${argumentModel.value.lat}");
    // setState(() {
    markers.value.add(Marker(
      markerId: const MarkerId('userLocationPin'),
      position: currentLatLong.value,
      icon:  BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(
        title: "User location",
        snippet: "User live location"

      )

    ));

    markers.value.add(Marker(
      markerId: const MarkerId('sourcePin'),
      position: startLat.value,
      icon:  BitmapDescriptor.defaultMarkerWithHue(0.4),
        infoWindow: InfoWindow(
            title: "Pick Up",
            snippet: argumentModel.value.fromPlace

        )

    ));
    markers.value.add(Marker(
        markerId: const MarkerId('destinationPin'),
        position: destinationLong.value,
        icon:  BitmapDescriptor.defaultMarkerWithHue(0.4),
        infoWindow: InfoWindow(
            title: "Drop off",
            snippet: argumentModel.value.toPlace

        )

    ));
   update();

  }

  @override
  void dispose() {
    mapController = Completer();

    super.dispose();
  }
  void updateMarker() {
    // Remove the previous user marker
    markers.removeWhere((marker) => marker.markerId.value == 'userLocationPin');
    print("UPDATE MARKER ${currentLatLong.value.latitude}");
    // Add the updated user marker
    markers.add(
      Marker(
        markerId: const MarkerId('userLocationPin'),
        position: currentLatLong.value,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: "User location",
          snippet: "User live location",
        ),
      ),
    );
    // Notify the UI to update the map
    update();
  }

  Future<void> updateCameraPosition() async {

    print("Camera postion");
    googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentLatLong.value,zoom: 16.3)));
  }





}
