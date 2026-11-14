class SignupUserModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String? profileImgPath;

  SignupUserModel({
    this.name = '',
    required this.email,
    required this.password,
    required this.phone,
    this.profileImgPath,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      if (profileImgPath != null && profileImgPath!.isNotEmpty)
        "profileImgPath": profileImgPath,
    };
  }
}
