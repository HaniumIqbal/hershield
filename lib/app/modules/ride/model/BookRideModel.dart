import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:hershield/app/modules/ride/model/AcceptedUserModel.dart';

class BookRideModel{
   String userID,fromPlace, toPlace, time, totalDistance, totalFare, userName,yourfare, lat,long;
   int phoneNo, capacity;
   List<AcceptedUserModel>? acceptedUserList;




  BookRideModel(
      {
    required  this.userID,
    required  this.fromPlace,
    required  this.toPlace,
    required  this.time,
    required  this.totalDistance,
    required  this.totalFare,
    required  this.userName,
     required  this.phoneNo,
     required  this.capacity,
     required  this.acceptedUserList,
     required  this.yourfare,
     required  this.lat,
     required  this.long,
      });



   Map<String, dynamic> toJson() {
    return {
      "userID": userID,
      "fromPlace": fromPlace,
      "toPlace": toPlace,
      "time": time,
      "totalDistance": totalDistance,
      "totalFare": totalFare,
      "userName": userName,
      "phoneNo": phoneNo,
      "capacity": capacity,
      "yourfare": yourfare,
      "lat": lat,
      "long": long,
      "acceptedUserList": acceptedUserList!.map((user) => user.toJson()).toList(),
    };
  }
   factory BookRideModel.fromJson(Map<String, dynamic> json) {
    return BookRideModel(
      userID: json["userID"],
      fromPlace: json["fromPlace"],
      toPlace: json["toPlace"],
      time: json["time"],
      totalDistance: json["totalDistance"],
      totalFare: json["totalFare"],
      userName: json["userName"],
      phoneNo: json["phoneNo"] as int,
      capacity: json["capacity"] as int,
      yourfare: json["yourfare"] ,
      lat: json["lat"] ,
      long: json["long"] ,
      acceptedUserList:  (json["acceptedUserList"] as List)
          .map((i) => AcceptedUserModel.fromJson(i))
          .toList(),
    );
  }
//

//

//
}