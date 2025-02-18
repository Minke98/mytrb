class UpdatePhotoProfile {
  String? data;

  UpdatePhotoProfile({this.data});

  UpdatePhotoProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }
  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
