class UserModel {
  final String email;
  final String uid;
  UserModel({
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
      };
}
