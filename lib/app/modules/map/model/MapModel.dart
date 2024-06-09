import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

class MapModel {
  String review, markerID, address, latitude, longitude;
  bool type;
  double rating;

  MapModel(
      {required this.review,
      required this.markerID,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.type,
      required this.rating});

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      review: json["review"],
      markerID: json["markerID"],
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      type: json["type"] == true,
      rating: double.parse(json["rating"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "review": review,
      "markerID": markerID,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "type": type,
      "rating": rating,
    };
  }

//

//

//
}
