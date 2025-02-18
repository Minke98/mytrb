import 'package:flutter/material.dart';

class ReportEvaluation {
  String? ucPengaduan;
  String? noTicket;
  String? typePengaduan;
  String? tglPengaduan;
  String? status;
  String? namaDiklat;
  String? keterangan;
  String? jawabanOperator;
  String? timeOperator;
  String? fileUrl; 

  ReportEvaluation({
    this.ucPengaduan,
    this.noTicket,
    this.typePengaduan,
    this.tglPengaduan,
    this.status,
    this.namaDiklat,
    this.keterangan,
    this.jawabanOperator,
    this.timeOperator,
    this.fileUrl, // Inisialisasi fileUrl
  });

  // Convert JSON to ReportEvaluation
  factory ReportEvaluation.fromJson(Map<String, dynamic> json) {
    return ReportEvaluation(
      ucPengaduan: json['uc_pengaduan'],
      noTicket: json['no_tiket'],
      typePengaduan: json['type_pengaduan'],
      tglPengaduan: json['tgl_aduan'],
      status: json['status'],
      namaDiklat: json['namaDiklat'],
      keterangan: json['keterangan'],
      jawabanOperator: json['jawabanOperator'],
      timeOperator: json['timeOperator'],
      fileUrl: json['fileUrl'],
    );
  }

  // Convert ReportEvaluation to JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_pengaduan': ucPengaduan,
      'noTicket': noTicket,
      'typePengaduan': typePengaduan,
      'tglPengaduan': tglPengaduan,
      'status': status,
      'namaDiklat': namaDiklat,
      'keterangan': keterangan,
      'jawabanOperator': jawabanOperator,
      'timeOperator': timeOperator,
      'fileUrl': fileUrl,
    };
  }
}

Color getStatusColor(String? status) {
  switch (status) {
    case '0':
      return Colors.blue;
    case '1':
      return Colors.orange;
    case '2':
      return Colors.green;
    default:
      return Colors.grey;
  }
}


String getStatusText(String? status) {
  switch (status) {
    case '1':
      return 'Progress';
    case '2':
      return 'Diterima';
    default:
      return 'Pengajuan';
  }
}

