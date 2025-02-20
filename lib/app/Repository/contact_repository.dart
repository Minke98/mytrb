import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:mytrb/Repository/user_repository.dart';

class ContactRepository extends Repository {
  Future send(
      {required String pesan,
      required String email,
      required String subject}) async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      await dbx.transaction((db) async {
        bool con = await ConnectionTest.check();
        if (con == false) {
          throw ("Koneksi Internet Diperlukan Untuk Mengirim Pesan");
        }
        mydb.transaction = db;
        final prefs = await SharedPreferences.getInstance();
        String? uc = prefs.getString('userUc');

        // Step 1: Prepare form data
        Map<String, dynamic> formDataMap = {
          "user_uc": uc,
          "email": email,
          "subject": subject,
          "pesan": pesan
        };

        // Step 2: Use BaseClient to send the message
        await BaseClient.safeApiCall(
          Environment.contactSend, // Endpoint for sending message
          RequestType.post, // POST request
          data: formDataMap, // Data to send in the request
          headers: {}, // Any headers (if needed)
          onSuccess: (response) {
            Map resData = response.data;
            if (resData['status'] == true) {
              finalRes['status'] = true;
            } else {
              throw ("Failed To Send");
            }
          },
          onError: (error) {
            log("Error sending message: ${error.message}");
            finalRes['status'] = false;
          },
        );
      });
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } catch (e) {
      log("Error: $e");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }
}
