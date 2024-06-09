import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hershield/constant/colors.dart';

import '../controllers/user_live_map_controller.dart';

class UserLiveMapView extends GetView<UserLiveMapController> {
  const UserLiveMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.lightPinkColor,
        title: const Text('UserMapView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          controller.startLat.value == null
              ? CircularProgressIndicator(color: MyColor.pinkTextColor,) :

          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Obx(() {

                  return GoogleMap(
                    myLocationButtonEnabled: true,
                    mapType: MapType.terrain,
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,

                    polylines:
                        Set<Polyline>.of(controller.polylines.value.values),

                    initialCameraPosition: CameraPosition(
                        zoom: 16.2, target: controller.currentLatLong.value),

                    markers:
                    // controller.markers.value,
                    <Marker>{
                  Marker(
                  markerId: const MarkerId('userLocationPin'),
                  position: controller.currentLatLong.value,
                  icon:  BitmapDescriptor.defaultMarker,
                  infoWindow: const InfoWindow(
                  title: "User location",
                  snippet: "User live location"

                  )),

                  Marker(
                  markerId: const MarkerId('sourcePin'),
                  position: controller.startLat.value,
                  icon:  BitmapDescriptor.defaultMarkerWithHue(0.4),
                  infoWindow: InfoWindow(
                  title: "Pick Up",
                  snippet: controller.argumentModel.value.fromPlace

                  )),
                  Marker(
                  markerId: const MarkerId('destinationPin'),
                  position: controller.destinationLong.value,
                  icon:  BitmapDescriptor.defaultMarkerWithHue(0.4),
                  infoWindow: InfoWindow(
                  title: "Drop off",
                  snippet: controller.argumentModel.value.toPlace

                  ))

                  },
                    onMapCreated: (GoogleMapController controllerMap) async {
                      controller.mapController.complete(controllerMap);
                      controller.isCameraMoving.value = true;

                    },
                  );
                }),
                IconButton(
                    onPressed: () {
                      print("hazmat");
                      print(
                          "current lat long${controller.currentLatLong.value}");

                      controller.mapController.future.then((GoogleMapController mController) {
                        mController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              zoom: 16.6,
                              target: controller.currentLatLong.value,
                            ),
                          ),
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.directions,
                      color: Colors.blue,
                      size: 40,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
