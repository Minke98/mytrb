import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytrb/Helper/manual_con_check.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Helper/my_dio.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/user_repository.dart';

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
        Map token = await UserRepository.getToken(uc: uc);
        Dio dio = await MyDio.getDio(
            token: token['token'], refreshToken: token['refreshToken']);
        Map<String, dynamic> formDataMap = {
          "user_uc": uc,
          "email": email,
          "subject": subject,
          "pesan": pesan
        };
        FormData formData = FormData.fromMap(formDataMap);
        var res = await dio.post("contact/send", data: formData);
        Map resData = res.data;
        if (resData['status'] == true) {
          finalRes['status'] = true;
        } else {
          throw ("Failed To Send");
        }
      });
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }
}
