class UserModel {
  String phoneNumber;
  String uid;
  String createdAt;

  UserModel(
      {required this.phoneNumber, required this.uid, required this.createdAt});

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {"phoneNumber": phoneNumber, "uid": uid, "createdAt": createdAt};
  }
}
