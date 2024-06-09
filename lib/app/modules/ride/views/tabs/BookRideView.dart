import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hershield/app/modules/ride/model/BookRideModel.dart';
import 'package:hershield/constant/colors.dart';

import '../../../../../widget/custom_text.dart';
import '../../../../../widget/custom_textfield.dart';
import '../../../../../widget/my_button.dart';
import '../../../../../widget/search_location_widget.dart';
import '../../controllers/ride_controller.dart';

class BookRideView extends GetView<RideController> {
  const BookRideView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.updateCurrentLocation();
    return Builder(builder: (context) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "From",
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                SearchLocationWidget(
                  controller: controller,
                  hint: "From",
                  editingController: controller.fromTextEditingController,
                  onGetLatLong: (Prediction prediction) {
                    controller.latitude.value = double.parse(prediction.lat!);
                    controller.longitude.value = double.parse(prediction
                        .lng!);
                    print("LAT ${controller.latitude.value}");
                    print("LONG ${controller.longitude.value}");
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                const CustomText(
                  text: "To",
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                SearchLocationWidget(
                  controller: controller,
                  hint: "To",
                  editingController: controller.toTextEditingController,
                  onGetLatLong: (Prediction prediction) {
                    controller.toLatitude.value = double.parse(prediction
                        .lat!);
                    controller.toLongitude.value = double.parse(prediction
                        .lng!);
                    print("LAT   ${controller.toLatitude.value}");
                    print("LONG ${controller.toLongitude.value}");
                  },

                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Phone Number",
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            textEditingController:
                            controller.phoneTextEditingController,
                            hint: "Phone Number",
                            textInputType: TextInputType.number,

                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomText(
                            text: "capacity",
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            textEditingController:
                            controller.capacityTextEditingController,
                            hint: "0",
                            textInputType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Per Kilometer Fare", color: Colors.black,),
                    SizedBox(
                      width: 70,
                      child: CustomTextField(
                        textEditingController:
                        controller.kmTextEditingController.value,
                        hint: "100",
                        textInputType: TextInputType.number,
                        onChange: (value) {
                          _setTotalFare(value!);
                        },
                      ),
                    ),
                  ],),

                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: MyColor.inputFieldColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          showPicker(
                            is24HrFormat: false,
                            showSecondSelector: true,
                            context: context,
                            value: controller.time.value,
                            onChange: controller.onTimeChanged,

                            minuteInterval: TimePickerInterval.FIVE,
                            // Optional onChange to receive value as DateTime
                            onChangeDateTime: (DateTime dateTime) {
                              controller.dateTime.value = dateTime;

                            },

                          ),
                        );
                      },

                      child: const Row(
                        children: [
                          Text(
                            "Set Time",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(width: 6,),
                          Icon(Icons.date_range,color: Colors.black,)
                        ],
                      ),
                    ),
                    Spacer(),
                    Obx(() {
                      return CustomText(
                        text: controller.time.value.toString(),
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      );
                    }),


                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Obx(() {
                  return CustomText(
                    text: "Total Distance : ${controller.distance.value
                        .roundToDouble()} km",
                    color: Colors.black,);
                }),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return CustomText(
                        text: "Total Fare : ${controller.totalFare.value
                            .roundToDouble()} PKR",
                        color: Colors.black,
                        fontSize: 18,);
                    }),
                  ],
                ),
                Expanded(
                  child: MyButton(
                      title: 'Book Ride',
                      onTab: () {

                        if (controller.isValid()) {
                          controller.distance.value = FlutterMapMath()
                              .distanceBetween(
                              controller.latitude.value,
                              controller.longitude.value,
                              controller.toLatitude.value,
                              controller.toLongitude.value,
                              "km"
                          );
                          _setTotalFare(controller.kmTextEditingController.value
                              .text);
                          print(
                              "Total Distance package ${controller.distance
                                  .value}");

                             double yourFare = (controller.totalFare/int.parse(controller.capacityTextEditingController.text));
                             print(yourFare);


                          BookRideModel model = BookRideModel(
                              userID: controller.userID,
                              fromPlace:
                              controller.fromTextEditingController.text.trim(),
                              toPlace: controller.toTextEditingController.text.trim(),
                              time: controller.dateTime.value.toString(),
                              totalDistance: controller.distance.string,
                              totalFare: controller.totalFare.string,
                              userName: "",
                              phoneNo: int.parse(controller.phoneTextEditingController.text),
                              capacity: int.parse(controller.capacityTextEditingController.text),
                              acceptedUserList: [],
                              yourfare: yourFare.roundToDouble().toString(), lat: '', long: ''

                          );
                            controller.addRideToFirebase(model);
                          controller.fromTextEditingController.text = "";
                          controller.fromTextEditingController.text = "";
                          controller.distance.value = 0.0;
                          controller.phoneTextEditingController.text = "";
                          controller.capacityTextEditingController.text= "";
                          controller.toTextEditingController.text= "";


                        }
                        else {
                          Get.snackbar("Invalid",
                              "Please fill all the required fields",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      }),
                ),
              ],
            ),
          ),

        ],
      );
    });
  }

  void _setTotalFare(String value) {

    double? parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      controller.totalFare.value = parsedValue * controller.distance.value;
      print(controller.totalFare.value);
    } else {
      // Handle invalid input
      print("PARSING DOUBLE ISSUE");
    }
    // controller.totalFare.value =
    //     double.parse(value) *
    //         controller.distance.value;
  }
}
