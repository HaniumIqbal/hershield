import 'dart:ffi';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hershield/app/constant.dart';
import 'package:hershield/app/modules/map/model/MapModel.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/widget/my_button.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Obx(() {
                    return GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      initialCameraPosition: controller.kGooglePlex,
                      markers: controller.markersObx.value,
                      onTap: (LatLng latlng) async {
                        controller.latitude.value = latlng.latitude;
                        controller.longitude.value = latlng.longitude;
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                latlng.latitude, latlng.longitude);
                        Placemark place = placemarks[0];
                        String address =
                            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                        print("TAB ADDRES" + address);
                        controller.mapModel.address = address;
                        controller.mapModel.markerID =
                            DateTime.now().millisecond.toString();
                        controller.updateMarkers(address, "Address");
                        controller.customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        controller.customInfoWindowController.onCameraMove!();
                      },
                      onMapCreated: (GoogleMapController controllerMap) {
                        controller.mapController = controllerMap;
                        controller.customInfoWindowController
                            .googleMapController = controllerMap;
                      },
                    );
                  }),
                  CustomInfoWindow(
                    controller: controller.customInfoWindowController,
                    height: 130,
                    width: 220,
                    offset: 50,
                  ),
                ],
              ),
            ),
            Container(
              height: 56,
              margin: const EdgeInsets.only(right: 60, left: 12),
              child: GooglePlaceAutoCompleteTextField(
                textStyle: const TextStyle(color: Colors.white),
                boxDecoration: BoxDecoration(
                    color: MyColor.pinkTextColor,
                    borderRadius: BorderRadius.circular(8)),
                textEditingController: controller.textEditingController,
                googleAPIKey: API_KEY,
                inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search your location",
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal)),
                debounceTime: 800,
                countries: ["pk"],

                // optional by default null is set
                isLatLngRequired: true,
                // if you required coordinates from place detail
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  // this method will return latlng with place detail
                  controller.latitude.value = double.parse(prediction.lat!);
                  controller.longitude.value = double.parse(prediction.lng!);
                  controller.getCurrentLocation(
                      controller.latitude.value,
                      controller.longitude.value,
                      prediction.description!,
                      "Address");
                  controller.mapModel.address = prediction.description!;
                  controller.mapModel.markerID = prediction.placeId!;
                  controller.updateMarkers(prediction.description!, "Address");
                },
                // this callback is called when isLatLngRequired is true
                itemClick: (Prediction prediction) {
                  controller.textEditingController.text =
                      prediction.description!;
                  controller.textEditingController.selection =
                      TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length));
                },

                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(child: Text(prediction.description ?? ""))
                      ],
                    ),
                  );
                },
                seperatedBuilder: const Divider(),
                isCrossBtnShown: true,
                containerHorizontalPadding: 10,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.mapModelList.isEmpty)
                      Text("")
                    else
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.mapModelList.length,
                            itemBuilder: (context, index) {
                              MapModel model =
                                  controller.mapModelList.value[index];
                              return ReviewCard(
                                mapModel: model,
                                mapController: controller,
                              );
                            }),
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(MyColor.pinkTextColor)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                                controller, controller.mapModel);
                          },
                        );
                      },
                      child: const Text(
                        'Comment this location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.mapModel,
    required this.mapController,
  });

  final MapModel mapModel;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        mapController.customInfoWindowController.hideInfoWindow!();
        mapController.customInfoWindowController.googleMapController =
            mapController.mapController;
        mapController.getCurrentLocation(double.parse(mapModel.latitude),
            double.parse(mapModel.longitude), mapModel.review, "Review");
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, offset: Offset(3, 4), blurRadius: 6)
            ],
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_city,
                  size: 28,
                  color: MyColor.pinkTextColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${mapModel.address.substring(0, 10)}...",
                      style: TextStyle(
                          color: MyColor.pinkTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    RatingBarIndicator(
                      rating: mapModel.rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 14.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Review",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Text(
                mapModel.review,
                style: TextStyle(
                  color: MyColor.pinkTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  final MapController mapController;
  final MapModel mapModel;

  CustomDialog(this.mapController, this.mapModel);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Leave feedback'),
      content: TextField(
        controller: textController,
        maxLines: 4,
        onChanged: (value) {
          textController.text = value;
          mapModel.review = value;
        },
        decoration: const InputDecoration(
            hintText: 'Write your review', border: OutlineInputBorder()),
      ),
      actions: <Widget>[
        RatingBar(
          itemSize: 24,
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: const Icon(Icons.star, color: Colors.amber),
            half: const Icon(Icons.star_half, color: Colors.amber),
            empty: const Icon(Icons.star_border, color: Colors.amber),
          ),
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            mapController.rating = rating;
            mapModel.rating = rating;
          },
        ),

        TextButton(
          onPressed: () {
            if (mapModel.review == "") {
              Get.snackbar("Empty", "Please write a review!",
                  backgroundColor: Colors.redAccent);
            } else {
              if (mapModel.address != "" && mapModel != null) {
                print(textController.text.toString());
                mapModel.type = false;
                mapController.addMapData(mapModel);
                Get.back();
              } else {
                Get.snackbar("Empty", "Please select or search address",
                    backgroundColor: Colors.redAccent);
              }
            }
          },
          child: const Text('Submit'),
        ),
        // TextButton(
        //   onPressed: () {
        //     if(mapModel != null){
        //       mapModel.type = true;
        //       mapController.addMapData(mapModel);
        //       Get.back();
        //     }
        //   },
        //   child: const Text('Positive'),
        // ),
      ],
    );
  }
}
