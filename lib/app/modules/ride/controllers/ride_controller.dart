import 'dart:async';
import 'dart:math';
import 'package:background_location/background_location.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hershield/app/modules/profile/controllers/profile_controller.dart';
import 'package:hershield/app/modules/ride/UserLiveMap/model/UserLiveModel.dart';
import 'package:hershield/app/modules/ride/model/BookRideModel.dart';
import 'package:hershield/app/services/RideRepository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class RideController extends GetxController {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final loc.Location location= loc.Location();
  RxSet<Marker> markers = RxSet<Marker>();
  late StreamSubscription<loc.Location> _locationStream;
  TextEditingController fromTextEditingController = TextEditingController();
  TextEditingController toTextEditingController = TextEditingController();
  TextEditingController capacityTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  final profileController = Get.find<ProfileController>();
  Rx<TextEditingController> kmTextEditingController = TextEditingController(text: "20").obs;
  Rx<Time> time = Time(hour: 11, minute: 30, second: 20).obs;
  RideRepository repository =  RideRepository();
  bool iosStyle = true;
  Rx<DateTime> dateTime = DateTime(0,0,0).obs;

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
  String? _locationMessage;

  static const double CAMERA_ZOOM = 16;
  static const double CAMERA_TILT = 80;
  static const double CAMERA_BEARING = 30;
  static const double PIN_VISIBLE_POSITION = 20;
  static const double PIN_INVISIBLE_POSITION = -220;
  GoogleMapController? mapController;
  RxList<BookRideModel> rideList = RxList<BookRideModel>();
  double pinPillPosition = PIN_VISIBLE_POSITION;
  late LatLng currentLocation;
  late LatLng destinationLocation;
  bool userBadgeSelected = false;

  // Set<Polyline> polylines = Set<Polyline>();
  static const LatLng SOURCE_LOCATION = LatLng(42.7477863,-71.1699932);
  static const LatLng DEST_LOCATION = LatLng(42.744421,-71.1698939);

  //TODO: Implement RideController
  Rx<String> orderMessage = "".obs;
  Rx<double> latitude = Rx<double>(0.0);
  Rx<double> user_latitude = Rx<double>(0.0);
  Rx<double> longitude = Rx<double>(0.0);
  Rx<double> user_longitude = Rx<double>(0.0);

  Rx<double> toLatitude = Rx<double>(0.0);
  Rx<double> totalFare = Rx<double>(0.0);
  Rx<double> distance = Rx<double>(0.0);
  Rx<double> toLongitude = Rx<double>(0.0);
  Rx<LatLng> start = Rx<LatLng>(const LatLng(0.0,0.0));
  Rx<LatLng> destination = Rx<LatLng>(const LatLng(0.0,0.0));
  Rx<LatLng> startLat = Rx<LatLng>(const LatLng(0.0,0.0));
  Rx<LatLng> destinationLong = Rx<LatLng>(const LatLng(0.0,0.0));
  StreamSubscription? _locationSubscription;
  // Set<Polyline> polylines = {};
  Completer<GoogleMapController> polyController = Completer();

  RxSet<Polyline> polylines = RxSet<Polyline>();

  RxList<LatLng> polylineCoordinates = RxList<LatLng>();
  PolylinePoints _polylinePoints = PolylinePoints();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    getAllBookRide();

    print(profileController.userInformation.fName);
    print(userID);
    // Firebase.initializeApp().then((_) async {
    //   // Initialize background location tracking
    //   BackgroundLocation.startLocationService(distanceFilter: 10);
    //   // Listen to location updates
    //   updateCurrentLocation();
    //
    // }).catchError((error) {
    //   print('Error initializing Firebase: $error');
    // });

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    BackgroundLocation.stopLocationService();
  }

  bool isValid() {
     if(
    kmTextEditingController.value.text.isEmpty ||
        fromTextEditingController.text.isEmpty ||
    toTextEditingController.text.isEmpty ||
    capacityTextEditingController.text.isEmpty ||
    phoneTextEditingController.text.isEmpty){
      return false;
    }
    else{
    if(phoneTextEditingController.text.length < 11){
    Get.snackbar("Invalid", "Please enter 11 digit phone no!",backgroundColor: Colors.red, colorText: Colors.white);
    return false;
    }
      return true;
    }

  }



  void onTimeChanged(Time newTime) {
      time.value = newTime;
  }
  Stream<List<BookRideModel>> getAllBookRide() {
    repository.gettAllRideStream().listen((event) {
      print("Get Result Messages ${event.length}");
      rideList.value = event;
      print("Get Result Messages");
      print(rideList.length);

    });
    return rideList.stream;
  }


  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
        _locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        user_latitude.value = position.latitude;
        user_longitude.value = position.longitude;

    } catch (e) {
      print('Error: $e');

        _locationMessage = "Could not fetch location";

    }
  }


  Future<void> addRideToFirebase(BookRideModel model) async {
    // getCurrentLocation();
    model.userName = (profileController.userInformation.fName! + profileController.userInformation.lName!);
    print(model.userName);
    model.lat = user_latitude.value.toString();
    model.long = user_longitude.value.toString();
    print(model.toJson());

    await repository.addRide(model).then((value) {
      if(value){
        updateCurrentLocation();
      }
      else{
        print("Nothing ");
      }

    });
  }

  void updateRideInFirebase(BookRideModel model) async {
    await repository.updateRide(model);
  }

  Future launchWhatsAppUrl(String phone) async {
    String finalUrl =
        'https://wa.me/$phone}';

      if (!await launchUrl(Uri.parse(finalUrl))) {
        throw Exception('Could not launch $finalUrl');
      }
    }
  //
 Future<void> updateCurrentLocation() async {
    // StreamSubscription locationSubscription =
   listenLocation();
   BackgroundLocation.getLocationUpdates((location) async {
     print("Serves get called");
     await repository.updateLocationInFirebase(location.latitude.toString(),location.longitude.toString());
   });


   }
  Marker updateMarkers(String description, String title) {
    final marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(0.4),
        // markerId: MarkerId(DateTime.now().millisecond.toString()),
        markerId: const MarkerId('myLocation'),
        position: LatLng(latitude.value, longitude.value));
    return marker;

  }

  // void startLocationUpdates() {
  //   print("UPDATE LIVE LOCATION");
  //   Geolocator.getPositionStream(
  //       locationSettings: const LocationSettings(distanceFilter: 0,accuracy: LocationAccuracy.bestForNavigation)
  //   ).listen((Position position) async {
  //     print("lat");
  //     print(position.latitude.toString());
  //     // currentLatLong.value.longitude = position.longitude;
  //     repository.updateLocationInFirebase(position.latitude.toString(),position.longitude.toString());
  //
  //     // updateFirebaseLocation(position.latitude, position.longitude);
  //   });
  // }

  Future<void> listenLocation() async {
    _locationStream = location.onLocationChanged.handleError((onError){
      print(onError);
      _locationStream.cancel();
    }).listen((currentLocation) {
      repository.updateLocationInFirebase(currentLocation.latitude.toString(),currentLocation.longitude.toString());
      print("Listen location");
    }) as StreamSubscription<loc.Location>;

  }

}
