class userModel {
  final String userId;
  final String? name;
  final String? profileImg;
  final String? email;
  final String? phone;
  final String role;
  final String? authUid;


  userModel({
    required this.userId,
    this.name,
    this.profileImg,
    this.email,
    this.phone,
    required this.role,
    this.authUid,
  });

  factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      userId: json['userId'],
      name: json['name'],
      profileImg: json['profileImg'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      authUid: json['authUid'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileImg': profileImg,
      'email': email,
      'phone': phone,
      'role': role,
      'authUid': authUid,
    };
  }
}
