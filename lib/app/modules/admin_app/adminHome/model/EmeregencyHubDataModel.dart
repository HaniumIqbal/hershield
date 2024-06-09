class EmergencyHubDataModel {
  String title, address, phone;

  EmergencyHubDataModel(
      {required this.title, required this.address, required this.phone});

  factory EmergencyHubDataModel.fromJson(Map<String, dynamic> json) {
    return EmergencyHubDataModel(
      title: json["title"],
      address: json["address"],
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "address": address,
      "phone": phone,
    };
  }
}
