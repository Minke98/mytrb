import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mytrb/Helper/manual_con_check.dart';
import 'package:mytrb/Helper/my_dio.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/user_repository.dart';
import 'package:mytrb/utils/manual_con_check.dart';

class ExamRepository extends Repository {
  Future<Map<String, dynamic>> getExam({required userData}) async {
    try {
      var con = await ConnectionTest.check();

      if (con == true) {
        log("appRepo: userData $userData");
        Map token = await UserRepository.getToken(uc: userData['uc_tech_user']);
        Dio dio = await MyDio.getDio(
          token: token['token'],
          refreshToken: token['refreshToken'],
        );

        var response = await dio.get("examination/course", queryParameters: {
          "uc_level": userData['uc_level'],
        });

        if (response.statusCode == 200) {
          var resData = response.data;
          return {
            'status': resData['status'],
            'data': resData['data'],
          };
        } else {
          throw Exception('Failed to fetch exam data');
        }
      } else {
        throw Exception('No internet connection.');
      }
    } catch (e) {
      print("Error in getExam: $e");
      throw Exception('Failed to load exams: $e');
    }
  }

  Future<Map<String, dynamic>> getUrlExam(userData, String uc) async {
    try {
      var con = await ConnectionTest.check();

      if (con == true) {
        log("appRepo: userData $userData");
        Map<String, dynamic> token =
            await UserRepository.getToken(uc: userData['uc_tech_user']);
        Dio dio = await MyDio.getDio(
          token: token['token'],
          refreshToken: token['refreshToken'],
        );
        var response = await dio.get(
          "examination/go",
          queryParameters: {
            /* "uc_user": userData['uc_participant'], */
            "uc_topic": uc,
            "seafarer_code": userData['seafarer_code'],
            "uc_trb_schedule": userData['uc_trb_schedule'],
          },
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> resData = response.data;

          // Menggabungkan parameter dari API examination/go ke URL yang lain
          String examUrl =
              "https://mytrb.technomulti.co.id/examination/go/${uc}/${userData['seafarer_code']}/${userData['uc_trb_schedule']}";

          return {
            'status': resData['status'],
            'data': resData['data'],
            'examUrl': examUrl,
          };
        } else {
          throw Exception('Gagal mengambil url ujian');
        }
      } else {
        throw Exception('Tidak ada koneksi internet.');
      }
    } catch (e) {
      print("Error in getUrlExam: $e");
      throw Exception('Gagal memuat url: $e');
    }
  }
}
