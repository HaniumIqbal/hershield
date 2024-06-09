class UserInformation {
  String? fName, lName, emailAddress, password, phoneNumber;

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      fName: json["fName"],
      lName: json["lName"],
      emailAddress: json["emailAddress"],
      password: json["password"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fName": fName,
      "lName": lName,
      "emailAddress": emailAddress,
      "password": password,
      "phoneNumber": phoneNumber,
    };
  }

  UserInformation(
      {required this.fName,
      required this.lName,
      required this.emailAddress,
      required this.password,
      required this.phoneNumber});
}
