import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/data/models/user.dart';
import 'package:mytrb/utils/custom_error.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as Path;
// enum AuthenticationStatus { unknown, authenticated, unauthenticated }

// abstract class UserRepository {
//   Future login({required username, required password});
//   Future getToken();
//   Future getUser();
//   Future checkAuth();
//   Future logOut();
// }

class UserRepository {
  final String uk = "VmYq3s6v9y\$B&E)H@McQfTjWnZr4u7w!";
  bool connection = false;
  User? user;
  // User user = new User();
  // final InternetBloc internetBloc;
  // late StreamSubscription internetBlocSubscription;
  UserRepository();
  // final _controller = StreamController<AuthenticationStatus>();
  // Stream<AuthenticationStatus> get status async* {
  //   await Future<void>.delayed(const Duration(seconds: 1));
  //   yield AuthenticationStatus.unauthenticated;
  //   yield* _controller.stream;
  // }

  // const _chars =
  //     'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // Random _rnd = Random();

  // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  //     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String sha1RandomString() {
    final randomNumber = math.Random().nextDouble();
    final randomBytes = utf8.encode(randomNumber.toString());
    final randomString = sha1.convert(randomBytes).toString();
    return randomString;
  }

  Future login(
      {required username,
      required password,
      required device_id,
      required StreamController<String> stream}) async {
    // try {
    stream.add("Login.");
    var ret;
    var con = await ConnectionTest.check();
    var conR = "NO NETWORK";
    if (con == true) {
      conR = "Network Available";
    }
    stream.add("Login..");
    log("CON $con");
    MyDatabase mydb = MyDatabase.instance;
    if (con == true) {
      try {
        log(" DB ${mydb.database} ");
        Database db = await mydb.database;
        Dio dio = await MyDio.getDio(retry: false);
        var formData = FormData.fromMap({
          'username': username,
          'password': password,
          'device_id': device_id
        });
        stream.add("Login...");
        var response = await dio.post("auth/login", data: formData);
        log("RES ${response.data['token']}");
        var data = response.data;

        final plainText = password;
        final key = encrypt.Key.fromUtf8(uk);
        final iv = encrypt.IV.fromLength(16);

        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        final encrypted = encrypter.encrypt(plainText, iv: iv);
        // final decrypted = encrypter.decrypt(encrypted, iv: iv);

        try {
          stream.add("Get BaseLine Data...");
          List<Map> result = await db.rawQuery(
              "select * from tech_user where uc = ? limit 1", [data['uc']]);
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          String savePath = Path.join(appDocPath, SIGN_PROFILE_FOLDER);
          Directory(savePath).createSync(recursive: true);
          if (result.isEmpty) {
            log("new Insert $data");
            if (data['foto_profile_path'] != null) {
              log("download FOTO ${data['foto_profile_path']} $savePath ${data['foto_profile_file']}");
              var downloadFile = await dio.download(data['foto_profile_path'],
                  Path.join(savePath, data['foto_profile_file']));
            }
            stream.add("Sync User");
            await db.rawInsert(
                "insert into tech_user values (?,?,?,?,?,?,?,?,null,?)", [
              data["uc"],
              data["uc_participant"],
              data["user_name"],
              data["full_name"],
              data["email"],
              encrypted.base64,
              data['token'],
              data['refresh_token'],
              data['foto_profile_file']
            ]);
            stream.add("Sync Chat Credential");
            await db.rawInsert(
                "insert into tech_chat_user values (?,?,null,null)",
                [data["uc_chat_user"], data["uc"]]);
          } else {
            // stream.add("Update User");
            log("update local");
            if (data['foto_profile_full'] != null) {
              var downloadFile = await dio.download(data['foto_profile_full'],
                  Path.join(savePath, data['foto_profile_file']));
            }
            // await db.rawUpdate(
            //     "Update tech_user set token = ?, refresh_token = ?",
            //     [null, null]);
            await db.rawUpdate("Update tech_user set token = ?", [null]);

            await db.rawUpdate(
                "Update tech_user set uc_participant=?, user_name = ?, full_name = ?,email = ?,password = ?, token = ?, refresh_token = ? where uc = ?",
                [
                  data["uc_participant"],
                  data["user_name"],
                  data["full_name"],
                  data["email"],
                  encrypted.base64,
                  data['token'],
                  data['refresh_token'],
                  data["uc"]
                ]);
            log("update ok");
          }
        } catch (e) {
          log("CANNOT SAVE CREDINTIAL LOCALY $e");
        } finally {
          log("CLOSE DATABASE");
          await mydb.close();
        }

        // load sync data here
        ret = {
          "status": true,
          "user": User(
              uc: data["uc"],
              userName: data["user_name"],
              fullName: data["full_name"],
              token: data['token'],
              refreshToken: data['refresh_token'])
        };
      } catch (e) {
        if (e is DioError) {
          log("DIO ${e.response}");
          ret = {"status": false, "message": e.response?.data['message']};
        } else {
          log("ERR online $e");
          ret = {"status": false, "message": e.toString()};
        }
        // return false;
      } finally {
        log("CLOSE DATABASE");
        await mydb.close();
      }
      // log("ENC ${encrypted.base64} decr $decrypted");
    } else {
      try {
        Database db = await mydb.database;
        // check baseline data
        List<Map> resultVessel =
            await db.rawQuery("select * from tech_type_vessel limit 1");
        if (resultVessel.isEmpty) {
          throw ("Koneksi Internet Diperlukan Saat Login Untuk Pertama Kalinya");
        }

        log("LOCAL LOGIN $username $password");
        List<Map> result = await db.rawQuery(
            "select * from tech_user where user_name = ? limit 1", [username]);
        // log("RES $result");
        if (result.isEmpty) {
          // throw Exception("Username or Password is Invalid");
          throw ("Local Username or Password is Invalid");
        }
        var resUser = result.first;

        var passwd = resUser['password'];
        log("APS $passwd");
        final key = encrypt.Key.fromUtf8(uk);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final decrypted =
            encrypter.decrypt(encrypt.Encrypted.fromBase64(passwd), iv: iv);
        if (password == decrypted) {
          // remove token (rewrtite to invalid ones)
          // await db.rawUpdate(
          //     "Update tech_user set token = ?, refresh_token = ?",
          //     [null, null]);

          await db.rawUpdate("Update tech_user set token = ?", [null]);

          await db.rawUpdate("Update tech_user set token = ? where uc = ?",
              ["local", resUser['uc']]);

          ret = {
            "status": true,
            "user": User(
                uc: resUser["uc"],
                userName: resUser["user_name"],
                fullName: resUser["full_name"],
                token: resUser['token'],
                refreshToken: resUser['refresh_token'])
          };
        } else {
          throw ("Local Username or Password is Invalid");
        }
      } catch (e) {
        log("LOCAL LOGIN ERR $e");
        ret = {"status": false, "message": e};
      } finally {
        log("CLOSE DB");
        await mydb.close();
      }
    }

    return ret;
  }

  Future checkAuth(
      {required String deviceId, bool fromBackround = false}) async {
    // await Future.delayed(const Duration(seconds: 5));
    var con = await ConnectionTest.check();
    log("checkAuth: CON $con background $fromBackround");
    Map<String, dynamic> ret;
    MyDatabase mydb = MyDatabase.instance;
    if (con == true && fromBackround == false) {
      try {
        // await Future.delayed(const Duration(seconds: 5));
        Database db = await mydb.database;
        List<Map> result = await db.rawQuery(
            "select * from tech_user where token is not null limit 1");
        log("checkAuth: isEmpty ${result.isEmpty}");
        if (result.isEmpty == true) {
          // throw Exception("Username or Password is Invalid");
          ret = {"status": false};
        } else {
          var resUser = result.first;
          // log("RU $resUser");
          // hit to server to validate token
          Dio dio = await MyDio.getDio(token: resUser['token']);
          // dio.options.headers["authorization"] = "Bearer ${resUser['token']}";
          // log("RE ${resUser['token']} ${dio.options.headers}");
          FormData formData = FormData.fromMap({"device_id": deviceId});
          var response = await dio.post("auth/check", data: formData);
          log("checkAuth: RES ${response.data}");
          var data = response.data;
          log("checkAuth: TOKEN ${resUser['token']}");
          if (data['auth'] == false) {
            log("checkAuth: INVALID TOKEN");
            throw (data['message']);
          } else {
            user = User(
                uc: resUser["uc"],
                userName: resUser["user_name"],
                fullName: resUser["full_name"],
                token: resUser["token"],
                refreshToken: resUser["refresh_token"]);
            // return user;
            ret = {"status": true, "user": user};
          }
          // return User(
          //     userId: resUser["user_id"],
          //     userName: resUser["user_name"],
          //     token: resUser['token'],
          //     refreshToken: resUser['refresh_token']);
        }
      } on DioError catch (e) {
        log("checkAuth: ERROR DIO ${e.response?.statusCode}");
        ret = {"status": false, "message": e.response?.data['message']};
      } catch (e) {
        log("Auth Something Went Wrong $e");
        ret = {"status": false};
      } finally {
        // log("checkAuth: CLOSE DB CHECK AUTH");
        // await mydb.close();
      }
    } else {
      try {
        Database db = await mydb.database;
        List<Map> result = await db.rawQuery(
            "select * from tech_user where token is not null and refresh_token is not null limit 1");
        log('checkAuth: check local $result');
        if (result.isEmpty) {
          // throw Exception("Username or Password is Invalid");
          ret = {"status": false};
        } else {
          var resUser = result.first;
          user = User(
              uc: resUser["uc"],
              userName: resUser["user_name"],
              fullName: resUser["full_name"],
              token: resUser["token"],
              refreshToken: resUser["refresh_token"]);
          // return user;
          ret = {"status": true, "user": user};
        }
      } catch (e) {
        // if (e is DioError) {
        //   log("ERROR DIO ${e.response?.statusCode}");
        // }
        user = null;
        // return false;
        ret = {"status": false, "message": e};
      } finally {
        // log("checkAuth: CLOSE DB");
        // await mydb.close();
      }
    }
    return ret;
  }

  Future logOut() async {
    MyDatabase mydb = MyDatabase.instance;
    try {
      Database db = await mydb.database;
      await db.rawUpdate("Update tech_user set token = null");
      List<Map> result = await db.rawQuery("select * from tech_user");
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      log("RE $result");
      log("Loging Out");
    } finally {
      log("Close DB logout");
      await mydb.close();
    }
  }

  Future checkSeaferer({required seafarer}) async {
    MyDatabase mydb = MyDatabase.instance;
    Map<String, dynamic> ret;
    try {
      // Database db = await mydb.database;
      Dio dio = await MyDio.getDio(retry: false);
      FormData formData = FormData.fromMap({'seafarer_code': seafarer});
      var response = await dio.post("auth/CheckSeafarer", data: formData);
      log("LOG ${response.data['data']}");
      ret = {'status': true, 'data': response.data['data']};
    } on DioError catch (e) {
      log("E ${e.response?.data['message']}");
      ret = {'status': false, 'message': e.response?.data['message']};
      // if (e.response?.statusCode == 404) {
      //   return false;
      // }
    } catch (e) {
      log("E $e");
      // return Error(e);
      ret = {'status': false, 'message': "Silahkan Coba Lagi [99]"};
    } finally {
      log("seafarer close db");
      await mydb.close();
    }
    return ret;
  }

  Future claim(
      {required device_id,
      required uc_participant,
      required email,
      required full_name,
      required username,
      required password}) async {
    try {
      Dio dio = await MyDio.getDio(retry: false);
      FormData formData = FormData.fromMap({
        'device_id': device_id,
        'uc_participant': uc_participant,
        'username': username,
        'password': password,
        'email': email,
        'full_name': full_name
      });
      await dio.post("auth/ClaimSeaferer2", data: formData);
      return {'status': true};
    } on DioError catch (e) {
      log("E ${e.response}");
      return {'status': false, 'message': e.response?.data['message']};
    } catch (e) {
      return {'status': false, 'message': "Silahkan Coba Lagi [99]"};
    } finally {
      // await mydb.close();
    }
  }

  Future getUserData({String? uc}) async {
    log("getData: GET DATA UC $uc");
    var con = await ConnectionTest.check();
    MyDatabase mydb = MyDatabase.instance;
    Map finalResult = {};
    if (con == true) {
      if (uc == null) {
        final prefs = await SharedPreferences.getInstance();
        uc = prefs.getString('userUc');
      }
      Map<String, dynamic> token = await UserRepository.getToken(uc: uc);
      try {
        log("getData: ONLINE CHECK");
        Dio dio = await MyDio.getDio(
            token: token['token'], refreshToken: token['refreshToken']);
        log("FormData uc: $uc");
        FormData formData = FormData.fromMap({'uc': uc});
        var response = await dio.post("auth/userdata", data: formData);
        log("getData: trb check $response");
        var data = response.data['data'];
        data['trb_participant'].remove("id");
        // isnert into local database
        Database db = await mydb.database;
        List<Map> result = await db.rawQuery(
            "select * from tech_trb_participant where uc_participant = ? limit 1",
            [data['trb_participant']['uc_participant']]);

        log("getData: CHECK tech trb $result ${data['trb_participant']}");
        if (result.isEmpty) {
          log("getData: INSET INTO LOCAL TRB");
          await db.rawInsert(
              "insert into tech_trb_participant values (?,?,?,?,?)", [
            data['trb_participant']['uc'],
            data['trb_participant']['uc_trb_schedule'],
            data['trb_participant']['uc_participant'],
            data['trb_participant']['uc_diklat_participant'],
            data['trb_participant']['seafarer_code'],
          ]);
        } else if (!mapEquals(data['participant'], result.first)) {
          log("getData: UPDATE LOCAL TRB");
          await db.rawUpdate(
              "update tech_trb_participant set uc_trb_schedule = ?, uc_participant = ?, uc_diklat_participant = ?, seafarer_code = ? where uc = ?",
              [
                data['trb_participant']['uc_trb_schedule'],
                data['trb_participant']['uc_participant'],
                data['trb_participant']['uc_diklat_participant'],
                data['trb_participant']['seafarer_code'],
                data['trb_participant']['uc'],
              ]);
        }

        // result = await db.rawQuery(
        //     "select * from tech_trb_schedule where uc = ? limit 1",
        //     [data['trb_participant']['uc_trb_schedule']]);
        // if (result.isEmpty) {
        //   log("INSET INTO LOCAL SCHEDULE");
        //   await db
        //       .rawInsert("insert into tech_trb_schedule values (?,?,?,?,?,?)", [
        //     data['schedule']['uc'],
        //     data['schedule']['title'],
        //     data['schedule']['date_start'],
        //     data['schedule']['date_finish'],
        //     data['schedule']['uc_upt'],
        //     data['schedule']['uc_pukp'],
        //   ]);
        // } else if (!mapEquals(data['schedule'], result.first)) {
        //   log("UPDATE LOCAL SCHEDULE");
        //   await db.rawUpdate(
        //       "update tech_trb_schedule set title = ?, date_start = ?, date_finish = ?, uc_upt = ?, uc_pukp = ? where uc = ?",
        //       [
        //         data['schedule']['title'],
        //         data['schedule']['date_start'],
        //         data['schedule']['date_finish'],
        //         data['schedule']['uc_upt'],
        //         data['schedule']['uc_pukp'],
        //         data['schedule']['uc'],
        //       ]);
        // }
      } on DioError catch (e) {
        log("getData: failed to get user data from online ${e.response?.statusCode}");
      }
      // catch (e) {
      //   //   if (e is DioError) {
      //   //     log("getData: failed to get user data from online");
      //   //   } else {
      //   log("getData: ERROR ONLINE FETCH $e");
      //   //   }
      // }
      finally {
        log("getData: Online DOne");
      }
    }

    Database db = await mydb.database;
    try {
      List<Map> result = await db.rawQuery(
          "select uc as uc_tech_user,uc_participant, user_name,full_name,email from tech_user where uc = ? limit 1",
          [uc]);
      if (result.isEmpty) {
        // throw Exception("Username or Password is Invalid");
        throw ("notfound");
      }

      var resUser = result.first;
      log("getData: resUser $resUser");
      // resUser.remove("password");
      // resUser.remove("uc");
      Map ret = {};
      ret.addAll(resUser);

      Map resTrb = {};
      List<Map> resultTrb = await db.rawQuery(
          "select uc_trb_schedule,uc_participant,uc_diklat_participant,seafarer_code from tech_trb_participant where uc_participant = ? limit 1",
          [resUser['uc_participant']]);
      log("getData: participant $resultTrb");
      if (resultTrb.isNotEmpty) {
        resTrb = resultTrb.first;
        ret.addAll(resTrb);
      }

      if (resTrb.isNotEmpty) {
        String ucTrbSchedule = resTrb['uc_trb_schedule'].toString();

        List<Map> resultSchedule = await db.rawQuery(
          '''
    SELECT tech_trb_schedule.title, tech_trb_schedule.date_start, tech_trb_schedule.date_finish, tech_trb_schedule.uc_upt, tech_trb_schedule.uc_pukp, tech_trb_schedule.uc_level, tech_level.label
    FROM tech_trb_schedule
    INNER JOIN tech_level ON tech_trb_schedule.uc_level = tech_level.uc
    WHERE tech_trb_schedule.uc = ?
    LIMIT 1;
    ''',
          [ucTrbSchedule],
        );

        if (resultSchedule.isNotEmpty) {
          Map resSchedule = resultSchedule.first;
          ret.addAll(resSchedule); // Menambahkan hasil query ke dalam ret
        }
      }

      List<Map> resultSign = await db.rawQuery(
          "select * from tech_sign where seafarer_code = ? and sign_on_date != null and sign_off_date == null limit 1",
          [ret['seafarer_code']]);
      if (resultSign.isNotEmpty) {
        ret['sign'] = true;
      } else {
        ret['sign'] = false;
      }

      // List<Map> resultSignTest = await db.rawQuery(
      //     "select * from tech_sign where sign_on_date != null and sign_off_date == null");
      // log("getData: finalSign $resultSignTest");
      // log("getData: finalRet $ret");
      finalResult = {'status': true, "data": ret};
    } finally {
      await mydb.close2();
    }
    return finalResult;
  }

  static Future<Map> getLocalUser(
      {String? uc,
      bool closeDb = false,
      bool withToken = false,
      bool useAlternate = false}) async {
    MyDatabase mydb = MyDatabase.instance;
    var dbx;
    if (mydb.transaction != null) {
      dbx = mydb.transaction!;
    } else {
      dbx = await mydb.database;
    }

    if (uc == null) {
      final prefs = await SharedPreferences.getInstance();
      uc = prefs.getString('userUc');
    }
    Map finalResult = {};
    try {
      // log("getData: is DB open $mydb ${await mydb.isOpen()}");
      String q = "";
      if (withToken == false) {
        q = "select uc as uc_tech_user,uc_participant, user_name, full_name, email, foto from tech_user where uc = ? limit 1";
      } else {
        q = "select uc as uc_tech_user,uc_participant, user_name, full_name, email, foto, token, refresh_token from tech_user where uc = ? limit 1";
      }
      List<Map> result = await dbx.rawQuery(q, [uc]);
      if (result.isEmpty) {
        throw ("notfound");
      }

      var resUser = Map.from(result.first);
      if (resUser['foto'] != null) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String savePath = Path.join(appDocPath, SIGN_PROFILE_FOLDER);
        resUser['foto'] = Path.join(savePath, resUser['foto']);
      }
      log("getData: resUser $resUser");
      Map ret = {};
      ret.addAll(resUser);

      Map resTrb = {};
      List<Map> resultTrb = await dbx.rawQuery(
          "select uc_trb_schedule,uc_participant,uc_diklat_participant,seafarer_code from tech_trb_participant where uc_participant = ? limit 1",
          [resUser['uc_participant']]);
      log("getData: participant $resultTrb");
      if (resultTrb.isNotEmpty) {
        resTrb = Map.from(resultTrb.first);
        ret.addAll(resTrb);
      }
      if (resTrb.isNotEmpty) {
        List<Map> resultParticipant = await dbx.rawQuery(
            "select * from tech_participant where uc = ? limit 1",
            [resUser['uc_participant']]);
        if (resultParticipant.isNotEmpty) {
          Map resParticipant = Map.from(resultParticipant.first);
          resParticipant.remove("uc");
          ret.addAll(resParticipant);
        }
      }
      if (resTrb.isNotEmpty) {
        String ucTrbSchedule = resTrb['uc_trb_schedule'].toString();

        List<Map> resultSchedule = await dbx.rawQuery(
          '''
    SELECT tech_trb_schedule.title, tech_trb_schedule.date_start, tech_trb_schedule.date_finish, tech_trb_schedule.uc_upt, tech_trb_schedule.uc_pukp, tech_trb_schedule.uc_level, tech_level.label
    FROM tech_trb_schedule
    INNER JOIN tech_level ON tech_trb_schedule.uc_level = tech_level.uc
    WHERE tech_trb_schedule.uc = ?
    LIMIT 1;
    ''',
          [ucTrbSchedule],
        );

        if (resultSchedule.isNotEmpty) {
          Map resSchedule = resultSchedule.first;
          ret.addAll(resSchedule);
        }
      }

      // if (resSchedule.isNotEmpty) {
      //   List<Map> resultSchedule = await dbx.rawQuery(
      //       "select title, date_start, date_finish, uc_upt, uc_pukp from tech_trb_schedule where uc = ? limit 1",
      //       [resTrb['uc_trb_schedule']]);
      //   if (resultSchedule.isNotEmpty) {
      //     Map resSchedule = Map.from(resultSchedule.first);
      //     ret.addAll(resSchedule);
      //   }
      // }

      if (resTrb.isNotEmpty) {
        ret['sign'] = false;
        ret['sign_uc'] = null;
        ret['sign_off'] = false;
        ret['sign_uc_local'] = null;
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("modifyTask", true);
        List<Map> resultSign = await dbx.rawQuery(
            "select uc,local_uc from tech_sign where seafarer_code = ? and sign_on_date IS NOT NULL and sign_off_date IS NULL order by sign_on_date desc, sign_on_stamp desc limit 1",
            [ret['seafarer_code']]);
        if (resultSign.isNotEmpty) {
          Map resSign = resultSign.first;
          ret['sign'] = true;
          ret['sign_off'] = false;
          ret['sign_uc'] = resSign['uc'];
          ret['sign_uc_local'] = resSign['local_uc'];
          prefs.setBool("modifyTask", true);
        } else if (useAlternate == true) {
          List<Map> resultSign2 = await dbx.rawQuery(
              """ select uc,local_uc from tech_sign where seafarer_code = ? and sign_on_date IS NOT NULL and sign_off_date IS NOT NULL order by sign_on_date desc, sign_on_stamp desc limit 1 """,
              [ret['seafarer_code']]);
          log("taskRepo R2 $resultSign2 ${ret['seafarer_code']}");
          if (resultSign2.isNotEmpty) {
            Map resSign2 = resultSign2.first;
            ret['sign'] = true;
            ret['sign_off'] = true;
            ret['sign_uc'] = resSign2['uc'];
            ret['sign_uc_local'] = resSign2['local_uc'];
            prefs.setBool("modifyTask", false);
          }
        }
      }
      finalResult = {'status': true, "data": ret};
    } catch (e) {
      // log("getData: ${e.toString()}");
      finalResult = {'status': false, 'message': e.toString()};
    } finally {}
    return finalResult;
  }

  static Future<Map> getLocalUserReport(
      {String? uc,
      bool closeDb = false,
      bool closed = false,
      bool withToken = false,
      bool useAlternate = false}) async {
    MyDatabase mydb = MyDatabase.instance;
    var dbx;
    Map finalResult = {};
    try {
      final db = await mydb.database;

      if (db.isOpen) {
        closed = false;
      } else {
        closed = true;
        await mydb.close2();
      }

      if (mydb.transaction != null) {
        dbx = mydb.transaction!;
      } else {
        dbx = await mydb.database;
      }

      if (uc == null) {
        final prefs = await SharedPreferences.getInstance();
        uc = prefs.getString('userUc');
      }
      // log("getData: is DB open $mydb ${await mydb.isOpen()}");
      String q = "";
      if (withToken == false) {
        q = "select uc as uc_tech_user,uc_participant, user_name, full_name, email, foto from tech_user where uc = ? limit 1";
      } else {
        q = "select uc as uc_tech_user,uc_participant, user_name, full_name, email, foto, token, refresh_token from tech_user where uc = ? limit 1";
      }
      List<Map> result = await dbx.rawQuery(q, [uc]);
      if (result.isEmpty) {
        throw ("notfound");
      }

      var resUser = Map.from(result.first);
      if (resUser['foto'] != null) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String savePath = Path.join(appDocPath, SIGN_PROFILE_FOLDER);
        resUser['foto'] = Path.join(savePath, resUser['foto']);
      }
      log("getData: resUser $resUser");
      Map ret = {};
      ret.addAll(resUser);

      Map resTrb = {};
      List<Map> resultTrb = await dbx.rawQuery(
          "select uc_trb_schedule,uc_participant,uc_diklat_participant,seafarer_code from tech_trb_participant where uc_participant = ? limit 1",
          [resUser['uc_participant']]);
      log("getData: participant $resultTrb");
      if (resultTrb.isNotEmpty) {
        resTrb = Map.from(resultTrb.first);
        ret.addAll(resTrb);
      }
      if (resTrb.isNotEmpty) {
        List<Map> resultParticipant = await dbx.rawQuery(
            "select * from tech_participant where uc = ? limit 1",
            [resUser['uc_participant']]);
        if (resultParticipant.isNotEmpty) {
          Map resParticipant = Map.from(resultParticipant.first);
          resParticipant.remove("uc");
          ret.addAll(resParticipant);
        }
      }
      if (resTrb.isNotEmpty) {
        String ucTrbSchedule = resTrb['uc_trb_schedule'].toString();

        List<Map> resultSchedule = await dbx.rawQuery(
          '''
    SELECT tech_trb_schedule.title, tech_trb_schedule.date_start, tech_trb_schedule.date_finish, tech_trb_schedule.uc_upt, tech_trb_schedule.uc_pukp, tech_trb_schedule.uc_level, tech_level.label
    FROM tech_trb_schedule
    INNER JOIN tech_level ON tech_trb_schedule.uc_level = tech_level.uc
    WHERE tech_trb_schedule.uc = ?
    LIMIT 1;
    ''',
          [ucTrbSchedule],
        );

        if (resultSchedule.isNotEmpty) {
          Map resSchedule = resultSchedule.first;
          ret.addAll(resSchedule);
        }
      }

      // if (resSchedule.isNotEmpty) {
      //   List<Map> resultSchedule = await dbx.rawQuery(
      //       "select title, date_start, date_finish, uc_upt, uc_pukp from tech_trb_schedule where uc = ? limit 1",
      //       [resTrb['uc_trb_schedule']]);
      //   if (resultSchedule.isNotEmpty) {
      //     Map resSchedule = Map.from(resultSchedule.first);
      //     ret.addAll(resSchedule);
      //   }
      // }

      if (resTrb.isNotEmpty) {
        ret['sign'] = false;
        ret['sign_uc'] = null;
        ret['sign_off'] = false;
        ret['sign_uc_local'] = null;
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("modifyTask", true);
        List<Map> resultSign = await dbx.rawQuery(
            "select uc,local_uc from tech_sign where seafarer_code = ? and sign_on_date IS NOT NULL and sign_off_date IS NULL order by sign_on_date desc, sign_on_stamp desc limit 1",
            [ret['seafarer_code']]);
        if (resultSign.isNotEmpty) {
          Map resSign = resultSign.first;
          ret['sign'] = true;
          ret['sign_off'] = false;
          ret['sign_uc'] = resSign['uc'];
          ret['sign_uc_local'] = resSign['local_uc'];
          prefs.setBool("modifyTask", true);
        } else if (useAlternate == true) {
          List<Map> resultSign2 = await dbx.rawQuery(
              """ select uc,local_uc from tech_sign where seafarer_code = ? and sign_on_date IS NOT NULL and sign_off_date IS NOT NULL order by sign_on_date desc, sign_on_stamp desc limit 1 """,
              [ret['seafarer_code']]);
          log("taskRepo R2 $resultSign2 ${ret['seafarer_code']}");
          if (resultSign2.isNotEmpty) {
            Map resSign2 = resultSign2.first;
            ret['sign'] = true;
            ret['sign_off'] = true;
            ret['sign_uc'] = resSign2['uc'];
            ret['sign_uc_local'] = resSign2['local_uc'];
            prefs.setBool("modifyTask", false);
          }
        }
      }
      finalResult = {'status': true, "data": ret};
    } catch (e) {
      // log("getData: ${e.toString()}");
      finalResult = {'status': false, 'message': e.toString()};
    } finally {
      if (closeDb) await mydb.close2();
    }
    return finalResult;
  }

  static Future getToken({String? uc, bool closeDb = false}) async {
    String token = "";
    String refreshToken = "";
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    Map<String, dynamic> ret;
    try {
      log("userRepo: getToken");
      if (uc == null) {
        final prefs = await SharedPreferences.getInstance();
        uc = prefs.getString('userUc');
      }
      log("userRepo: uc $uc");

      log("userRepo: db $db");
      List<Map> result = await db.rawQuery(
          "select token, refresh_token from tech_user where uc = ? limit 1",
          [uc]);
      log("userRepo: result token $result");
      if (result.isEmpty) {
        throw ("notfound");
      }

      var resUser = result.first;
      token = resUser['token'];
      refreshToken = resUser['refresh_token'];
      ret = {"status": true, "token": token, "refreshToken": refreshToken};
    } catch (e) {
      ret = {"status": false, "token": token, "refreshToken": refreshToken};
    } finally {
      // if (closeDb == true) {
      // await mydb.close2();
      // }
    }
    log("userRepo: ret $ret");
    return ret;
  }

  static Future setToken(
      {String? uc, required String token, required String refreshToken}) async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    try {
      if (uc == null) {
        final prefs = await SharedPreferences.getInstance();
        uc = prefs.getString('userUc');
      }
      await db.rawUpdate("update tech_user set token = ?, refresh_token = ?",
          [token, refreshToken]);
    } on CustomException catch (e) {}
  }
}
