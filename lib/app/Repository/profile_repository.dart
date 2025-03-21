import 'dart:developer';
import 'dart:io' as io;

import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/multipart_extended.dart';
import 'package:path/path.dart' as Path;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ProfileRepository extends Repository {
  Future updateUser({
  required String email,
  io.File? foto,
  required String password,
  required String newpassword,
}) async {
  Map finalRes = {"status": true};

  try {
    final prefs = await SharedPreferences.getInstance();
    String? uc = prefs.getString('userUc');

    // Siapkan data yang dikirim
    Map<String, dynamic> formDataMap = {"email": email, "uc": uc};

    // Tambahkan password jika diisi
    if (password.isNotEmpty && newpassword.isNotEmpty) {
      formDataMap['password'] = password;
      formDataMap['new_password'] = newpassword;
    }

    // Tangani upload foto hanya jika foto tidak null dan file-nya ada
    if (foto != null && await foto.exists()) {
      String imagePath = foto.path;
      formDataMap['foto'] = MultipartFileExtended.fromFileSync(
        imagePath,
        filename: Path.basename(imagePath),
      );
    }

    log("profileRepository: $formDataMap");

    await BaseClient.safeApiCall(
      Environment.updateUser,
      RequestType.post,
      data: formDataMap,
      onSuccess: (response) async {
        log("profileRepository: updateRes $response");
        Map resData = response.data;

        if (resData['status'] == true) {
          MyDatabase mydb = MyDatabase.instance;
          Database db = await mydb.database;

          await db.transaction((txn) async {
            mydb.transaction = txn;
            String? fotoName = resData['foto'];
            log("profileRepository: updateEmail $email");

            await txn.rawUpdate(
                "UPDATE tech_user SET email = ? WHERE uc = ?", [email, uc]);

            // Update foto jika foto baru ada di server
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
                  "UPDATE tech_user SET foto = ? WHERE uc = ?",
                  [fotoName, uc]);
            }

            // Update password jika ada password baru
            if (password.isNotEmpty && newpassword.isNotEmpty) {
              log("profileRepository: updatePassword");
              final key = encrypt.Key.fromUtf8(UK);
              final iv = encrypt.IV.fromLength(16);
              final encrypter = encrypt.Encrypter(encrypt.AES(key));
              final encrypted = encrypter.encrypt(newpassword, iv: iv);

              await txn.rawUpdate(
                  "UPDATE tech_user SET password = ? WHERE uc = ?",
                  [encrypted.base64, uc]);
            }
          });

          mydb.transaction = null;
        }
      },
      onError: (error) {
        finalRes['status'] = false;
        finalRes['message'] = error.toString();
        log("profileRepository: Error $error");
      },
    );
  } catch (e) {
    finalRes['status'] = false;
    finalRes['message'] = e.toString();
    log("profileRepository: Exception $e");
  }

  return finalRes;
}
}
