import 'dart:async';
import 'dart:developer';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/manual_con_check.dart';

class ExamRepository extends Repository {
  Future<Map<String, dynamic>> getExam({required userData}) async {
    try {
      bool con = await ConnectionTest.check();
      if (!con) {
        throw Exception('Tidak ada koneksi internet.');
      }

      log("appRepo: userData $userData");

      final response = await BaseClient.safeApiCall(
        Environment.examinationCourse,
        RequestType.get,
        queryParameters: {'uc_level': userData['uc_level']},
        onSuccess: (response) {
          log("Response dari API: ${response.data}");
          return {
            'status': response.data['status'],
            'data': response.data['data'] ??
                [], // Pastikan selalu mengembalikan List
          };
        },
        onError: (error) {
          throw Exception('Gagal mengambil data ujian: ${error.message}');
        },
      );

      if (response == null) {
        throw Exception("Response dari server null");
      }

      return response; // Pastikan response selalu dikembalikan
    } catch (e) {
      log("Error in getExam: $e");
      throw Exception('Gagal memuat ujian: $e');
    }
  }

  Future<Map<String, dynamic>> getUrlExam(userData, String uc) async {
    try {
      // Cek koneksi internet
      bool con = await ConnectionTest.check();
      if (!con) {
        throw Exception('Tidak ada koneksi internet.');
      }

      log("appRepo: userData $userData");

      // Gunakan BaseClient untuk melakukan permintaan HTTP
      final response = await BaseClient.safeApiCall(
        "examination/go", // URL endpoint
        RequestType.get, // Jenis permintaan (GET)
        queryParameters: {
          "uc_topic": uc,
          "seafarer_code": userData['seafarer_code'],
          "uc_trb_schedule": userData['uc_trb_schedule'],
        },

        onSuccess: (response) {
          // Handle respons sukses
          if (response.statusCode == 200) {
            Map<String, dynamic> resData = response.data;

            // Membuat URL ujian
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
        },
        onError: (error) {
          // Handle error
          throw Exception('Gagal mengambil data: ${error.message}');
        },
      );

      if (response == null) {
        throw Exception("Response dari server null");
      }

      return response; // Kembalikan response
    } catch (e) {
      log("Error in getUrlExam: $e");
      throw Exception('Gagal memuat url: $e');
    }
  }
}
