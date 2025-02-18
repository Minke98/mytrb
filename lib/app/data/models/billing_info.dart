import 'package:mytrb/app/data/models/billing.dart';

class BillingInfo {
  int? status;
  String? message;
  int? totalPage;
  int? offset;
  int? eachPage;
  List<Billing>? data;

  BillingInfo({
    this.status,
    this.message,
    this.totalPage,
    this.offset,
    this.eachPage,
    this.data,
  });

  factory BillingInfo.fromJson(Map<String, dynamic> json) {
    return BillingInfo(
      status: json['status'],
      message: json['message'],
      totalPage: json['total_page'],
      offset: json['offset'],
      eachPage: json['each_page'],
      data: json['data'] != null
          ? List<Billing>.from(
              json['data'].map((diklat) => Billing.fromJson(diklat)))
          : null,
    );
  }

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
