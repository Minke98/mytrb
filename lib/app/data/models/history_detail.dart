import 'package:mytrb/app/data/models/history.dart';

class HistoryDetail {
  int? status;
  String? message;
  int? totalPage;
  int? offset;
  int? eachPage;
  List<History>? data;

  HistoryDetail({
    this.status,
    this.message,
    this.totalPage,
    this.offset,
    this.eachPage,
    this.data,
  });

  factory HistoryDetail.fromJson(Map<String, dynamic> json) {
    return HistoryDetail(
      status: json['status'],
      message: json['message'],
      totalPage: json['total_page'],
      offset: json['offset'],
      eachPage: json['each_page'],
      data: json['data'] != null
          ? List<History>.from(
              json['data'].map((history) => History.fromJson(history)))
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
      'data': data != null
          ? data!.map((history) => history.toJson()).toList()
          : null,
    };
  }
}
