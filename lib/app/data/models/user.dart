class User {
  String? uc;
  String? userName;
  String? fullName;
  String? token;
  String? refreshToken;

  User({
    this.uc,
    this.userName,
    this.fullName,
    this.token,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uc: json['uc'],
      userName: json['username'],
      fullName: json['full_name'],
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc': uc,
      'userName': userName,
      'fullName': fullName,
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
