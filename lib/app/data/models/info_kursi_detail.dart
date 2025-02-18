import 'package:mytrb/app/data/models/info_kursi.dart';

class InfoKursiDetail {
  int? status;
  String? message;
  int? totalPage;
  int? offset;
  int? eachPage;
  List<InfoKursi>? data;

  InfoKursiDetail({
    this.status,
    this.message,
    this.totalPage,
    this.offset,
    this.eachPage,
    this.data,
  });

  // fromJson untuk mengonversi JSON menjadi objek
  factory InfoKursiDetail.fromJson(Map<String, dynamic> json) {
    return InfoKursiDetail(
      status: json['status'],
      message: json['message'],
      totalPage: json['total_page'],
      offset: json['offset'],
      eachPage: json['each_page'],
      data: json['data'] != null
          ? List<InfoKursi>.from(
              json['data'].map((diklat) => InfoKursi.fromJson(diklat)))
          : null,
    );
  }

  // toJson untuk mengonversi objek menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'total_page': totalPage,
      'offset': offset,
      'each_page': eachPage,
      'data':
          data != null ? data!.map((diklat) => diklat.toJson()).toList() : null,
    };
  }
}
