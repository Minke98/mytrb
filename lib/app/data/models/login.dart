class UserLogin {
  String? usrAccountId;
  String? usrEmail;
  String? usrNik;
  String? usrUc;
  String? usrKodePelaut;
  String? usrPhoto;
  String? usrNoTelephone;
  String? logName;
  int? logLogin;

  UserLogin({
    this.usrAccountId,
    this.usrEmail,
    this.usrNik,
    this.usrUc,
    this.usrKodePelaut,
    this.usrPhoto,
    this.usrNoTelephone,
    this.logName,
    this.logLogin,
  });

  // fromJson method
  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      usrAccountId: json['usr_account_id'],
      usrEmail: json['usr_email'],
      usrNik: json['usr_nik'],
      usrUc: json['usr_uc'],
      usrKodePelaut: json['usr_kode_pelaut'],
      usrPhoto: json['usr_photo'],
      usrNoTelephone: json['usr_no_telephone'],
      logName: json['log_name'],
      logLogin: json['log_login'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'usr_account_id': usrAccountId,
      'usr_email': usrEmail,
      'usr_nik': usrNik,
      'usr_uc': usrUc,
      'usr_kode_pelaut': usrKodePelaut,
      'usr_photo': usrPhoto,
      'usr_no_telephone': usrNoTelephone,
      'log_name': logName,
      'log_login': logLogin,
    };
  }
}
