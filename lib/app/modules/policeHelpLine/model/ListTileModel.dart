import 'package:flutter/cupertino.dart';

class ListTileModel {
  String iconData;
  String title, subTtile;
  String? mapLink;

  ListTileModel(
      {required this.iconData,
      required this.title,
      required this.subTtile,
      required this.mapLink});

  Map<String, dynamic> toJson() {
    return {
      "iconData": iconData,
      "title": title,
      "subTtile": subTtile,
      "mapLink": mapLink,
    };
  }

  factory ListTileModel.fromJson(Map<String, dynamic> json) {
    return ListTileModel(
      iconData: json["iconData"],
      title: json["title"],
      subTtile: json["subTtile"],
      mapLink: json["mapLink"],
    );
  }
//
}
