class SignupUserModel {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String? profileImgPath;

  SignupUserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    this.profileImgPath,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phone": phone,
      // if (profileImgPath != null && profileImgPath!.isNotEmpty)
      "profileImgPath": profileImgPath ?? '',
    };
  }
}
