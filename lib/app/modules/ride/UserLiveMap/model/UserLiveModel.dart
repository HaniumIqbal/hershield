class UserLiveModel {
  String lat,long;

  UserLiveModel({required this.lat,required this.long});

  Map<String, dynamic> toJson() {
    return {
      "lat": lat,
      "long": long,
    };
  }

  factory UserLiveModel.fromJson(Map<String, dynamic> json) {
    return UserLiveModel(
      lat: json["lat"],
      long: json["long"],
    );
  }
//
}