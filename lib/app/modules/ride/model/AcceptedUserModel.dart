class AcceptedUserModel{
  final String id;

  AcceptedUserModel({required this.id});

  factory AcceptedUserModel.fromJson(Map<String, dynamic> json) {
    return AcceptedUserModel(
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
    };
  }

//
}