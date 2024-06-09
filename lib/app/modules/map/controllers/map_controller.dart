import 'dart:ffi';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hershield/app/constant.dart';
import 'package:hershield/app/modules/map/model/MapModel.dart';
import 'package:hershield/app/services/MapRepository.dart';
import 'package:hershield/constant/colors.dart';
import 'package:location/location.dart';
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding_platform_interface/src/models/placemark.dart'
    as placemark;

class MapController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  Location location = Location();

  MapModel mapModel = MapModel(
      review: "",
      markerID: "",
      address: "",
      latitude: "",
      longitude: "",
      type: true,
      rating: 0);
  MapRepository mapRepository = MapRepository();
  RxList<MapModel> mapModelList = RxList<MapModel>();
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  double rating = 0;
  Rx<Map<String, Marker>> markers = Rx<Map<String, Marker>>({});
  RxSet<Marker> markersObx = RxSet();
  Rx<double> latitude = Rx<double>(0.0);
  Rx<double> longitude = Rx<double>(0.0);
  GoogleMapController? mapController;
  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(33.298037, 44.2879251),
    zoom: 10,
  );

  @override
  void onInit() {
    getCurrentLocation(0, 0, "", "Address");
    getAllMapData();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getCurrentLocation(double lat, double lng, String desc, String title) async {
    print("GET location called");
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      //check if thelocation service was enable or not
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
//if the location was denied it will ask next time the user enter the screen
      if (permissionGranted != PermissionStatus.granted) {
//in case of denied you can add any thing here like error message or something else
        return;
      }
    }
    if (lat == 0 || lng == 0) {
      LocationData currentPosition = await location.getLocation();
      latitude.value = currentPosition.latitude!;
      longitude.value = currentPosition.longitude!;
      print("current lat " + currentPosition.latitude!.toString());
      print("current long " + currentPosition.longitude!.toString());
      kGooglePlex = CameraPosition(
        target: LatLng(currentPosition.latitude!, currentPosition.longitude!),
        zoom: 10,
      );
    } else {
      latitude.value = lat;
      longitude.value = lng;
    }
    updateMarkers(desc, title);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latitude.value, longitude.value), zoom: 15),
      ),
    );
  }

  void updateMarkers(String description, String title) {
    final marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(0.4),
        // markerId: MarkerId(DateTime.now().millisecond.toString()),
        markerId: const MarkerId('myLocation'),
        position: LatLng(latitude.value, longitude.value),
        // infoWindow:  InfoWindow(
        //   title: "Review",
        //   snippet: description,
        // ),
        onTap: () async {
          geocoding
              .placemarkFromCoordinates(latitude!.value, longitude!.value)
              .then((placemarks) {
            var output = 'No results found.';
            if (placemarks.isNotEmpty) {
              placemark.Placemark place = placemarks[0];
              String address =
                  "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
              mapModel.address = address;
              description = address;
              updateMarkers(description, title);
              print("place" + output);
            }
          });
          customInfoWindowController.addInfoWindow!(
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColor.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        description,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                      ),
                    )),
                  ],
                ),
              ),
              LatLng(latitude.value, longitude.value));
        });
    markers.value['myLocation'] = marker;

    markersObx.clear();
    markersObx.add(marker);
    print("LAT UPDATE ${latitude.value}");
    print("LONG UPDAYE ${longitude.value}");
    mapModel.longitude = longitude.value.toString();
    mapModel.latitude = latitude.value.toString();

    geocoding
        .placemarkFromCoordinates(latitude!.value, longitude!.value)
        .then((placemarks) {
      var output = 'No results found.';
      if (placemarks.isNotEmpty) {
        placemark.Placemark place = placemarks[0];
        String address =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        mapModel.address = address;
        description = address;
        print("place" + output);
      }
    });

    // Map<String, Marker> currentMarkers = markers.value;
    // currentMarkers['myLocation'] = marker;
    // markers.value = currentMarkers;
  }

  void addMapData(MapModel model) {
    print(model.toJson());
    mapRepository.addMapData(model);
  }

  void getAllMapData() {
    mapRepository.getAllMapStream().listen((event) {
      if (event != null) {
        mapModelList.value = event;
        print(mapModelList.value.length);
      } else {
        mapModelList.value = [];
      }
    });
  }
}
