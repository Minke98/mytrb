import 'dart:developer';
import 'dart:io' as io;

import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/utils/multipart_extended.dart';
import 'package:path/path.dart' as Path;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/user_repository.dart';

class ProfileRepository extends Repository {
  Future updateUser(
      {required String email,
      io.File? foto,
      required String password,
      required String newpassword}) async {
    Map finalRes = {"status": true};
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uc = prefs.getString('userUc');
      Map token = await UserRepository.getToken(uc: uc);
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);
      Map<String, dynamic> formDataMap = {"email": email, "uc": uc};

      if (password != "" && newpassword != "") {
        formDataMap['password'] = password;
        formDataMap['new_password'] = newpassword;
      }
      log("profileRepository: $formDataMap");
      if (foto != null) {
        String imagePath = foto.path;
        bool imageExist = await foto.exists();
        if (imageExist == true) {
          formDataMap['foto'] = MultipartFileExtended.fromFileSync(imagePath);
        }
      }
      FormData formData = FormData.fromMap(formDataMap);
      var res = await dio.post("auth/updateuser", data: formData);
      log("profileRepository: updateRes $res");
      Map resData = res.data;
      if (resData['status'] == true) {
        MyDatabase mydb = MyDatabase.instance;
        Database db = await mydb.database;
        await db.transaction((txn) async {
          mydb.transaction = txn;
          String? fotoName = resData['foto'];
          log("profileRepository: updateEmail $email");
          await txn.rawUpdate(
              "update tech_user set email = ? where uc = ?", [email, uc]);
          if (fotoName != null) {
            io.Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            String savePath = Path.join(appDocPath, SIGN_PROFILE_FOLDER);
            io.Directory(savePath).createSync(recursive: true);
            log("profileRepository: updateFoto $savePath $fotoName");
            foto!.copySync("$savePath/$fotoName");

            await prefs.setString(
                'foto_profile', Path.join(savePath, fotoName));

            await txn.rawUpdate(
                "update tech_user set foto = ? where uc = ?", [fotoName, uc]);
          }

          if (password != "" && newpassword != "") {
            log("profileRepository: updatePassowrd");
            final plainText = newpassword;
            final key = encrypt.Key.fromUtf8(UK);
            final iv = encrypt.IV.fromLength(16);

            final encrypter = encrypt.Encrypter(encrypt.AES(key));

            final encrypted = encrypter.encrypt(plainText, iv: iv);
            await txn.rawUpdate(
                "update tech_user set password = ? where uc = ?",
                [encrypted.base64, uc]);
          }
        });
        mydb.transaction = null;
      }
    } on DioError catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.response!.data['message'];
      log("profileRepository: pr $e");
    } finally {}
    return finalRes;
  }
}
