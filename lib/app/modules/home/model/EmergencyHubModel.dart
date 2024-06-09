import 'dart:convert';

import 'package:hershield/app/modules/policeHelpLine/model/ListTileModel.dart';

class EmergencyHubModel {
  String docID, title, imgPath, destinationPath, argTitle;
  List<ListTileModel> argument;

  EmergencyHubModel({
    required this.docID,
    required this.title,
    required this.imgPath,
    required this.destinationPath,
    required this.argument,
    required this.argTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      "docID": docID,
      "title": title,
      "imgPath": imgPath,
      "destinationPath": destinationPath,
      "argTitle": argTitle,
      "argument": List<dynamic>.from(argument.map((d) => d.toJson())),
    };
  }

  factory EmergencyHubModel.fromJson(Map<String, dynamic> json) {
    return EmergencyHubModel(
      docID: json["docID"],
      title: json["title"],
      imgPath: json["imgPath"],
      destinationPath: json["destinationPath"],
      argTitle: json["argTitle"],
      argument: (json['argument'] as List<dynamic>)
          .map((argJson) => ListTileModel.fromJson(argJson))
          .toList(),
    );
  }
//
}
