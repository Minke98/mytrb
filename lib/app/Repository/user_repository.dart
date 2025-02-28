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
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/custom_error.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:mytrb/Helper/my_dio.dart';
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

  Future login({
    required String username,
    required String password,
    required String device_id,
    // required StreamController<String> stream,
  }) async {
    // stream.add("Login.");
    var ret;
    var con = await ConnectionTest.check();
    MyDatabase mydb = MyDatabase.instance;

    if (con) {
      try {
        Database db = await mydb.database;
        // stream.add("Login..");
        await BaseClient.safeApiCall(
          Environment.login,
          RequestType.post,
          data: {
            'username': username,
            'password': password,
            'device_id': device_id
          },
          isJson: false,
          onSuccess: (Response response) async {
            var data = response.data;
            final key = encrypt.Key.fromUtf8(uk);
            final iv = encrypt.IV.fromLength(16);
            final encrypter = encrypt.Encrypter(encrypt.AES(key));
            final encrypted = encrypter.encrypt(password, iv: iv);

            // stream.add("Get BaseLine Data...");
            List<Map> result = await db.rawQuery(
                "select * from tech_user where uc = ? limit 1", [data['uc']]);

            Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            String savePath = Path.join(appDocPath, SIGN_PROFILE_FOLDER);
            Directory(savePath).createSync(recursive: true);

            if (result.isEmpty) {
              if (data['foto_profile_path'] != null) {
                await BaseClient.download(
                  url: data['foto_profile_path'],
                  savePath: Path.join(savePath, data['foto_profile_file']),
                  onSuccess: () => log("Download sukses"),
                  onError: (e) => log("Download gagal: ${e.message}"),
                );
              }

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

              await db.rawInsert(
                  "insert into tech_chat_user values (?,?,null,null)",
                  [data["uc_chat_user"], data["uc"]]);
            } else {
              if (data['foto_profile_full'] != null) {
                await BaseClient.download(
                  url: data['foto_profile_full'],
                  savePath: Path.join(savePath, data['foto_profile_file']),
                  onSuccess: () => log("Download sukses"),
                  onError: (e) => log("Download gagal: ${e.message}"),
                );
              }

              await db.rawUpdate(
                  "Update tech_user set uc_participant=?, user_name = ?, full_name = ?, email = ?, password = ?, token = ?, refresh_token = ? where uc = ?",
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
            }

            ret = {
              "status": true,
              "user": User(
                  uc: data["uc"],
                  userName: data["user_name"],
                  fullName: data["full_name"],
                  token: data['token'],
                  refreshToken: data['refresh_token'])
            };
          },
          onError: (e) {
            if (e.response != null && e.response!.data is Map) {
              ret = {
                "status": false,
                "message": e.response!.data["message"] ?? "Terjadi kesalahan"
              };
            } else {
              ret = {"status": false, "message": e.message};
            }
          },
        );
      } catch (e) {
        ret = {"status": false, "message": e.toString()};
      } finally {
        await mydb.close();
      }
    } else {
      try {
        Database db = await mydb.database;
        List<Map> resultVessel =
            await db.rawQuery("select * from tech_type_vessel limit 1");
        if (resultVessel.isEmpty) {
          throw "Koneksi Internet Diperlukan Saat Login Untuk Pertama Kalinya";
        }

        List<Map> result = await db.rawQuery(
            "select * from tech_user where user_name = ? limit 1", [username]);
        if (result.isEmpty) {
          throw "Local Username or Password is Invalid";
        }
        var resUser = result.first;
        final key = encrypt.Key.fromUtf8(uk);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final decrypted = encrypter
            .decrypt(encrypt.Encrypted.fromBase64(resUser['password']), iv: iv);

        if (password == decrypted) {
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
          throw "Local Username or Password is Invalid";
        }
      } catch (e) {
        ret = {"status": false, "message": e};
      } finally {
        await mydb.close();
      }
    }
    return ret;
  }

  Future checkAuth(
      {required String deviceId, bool fromBackround = false}) async {
    var con = await ConnectionTest.check();
    log("checkAuth: CON $con background $fromBackround");
    Map<String, dynamic> ret = {
      "status": false,
      "message": "Terjadi kesalahan"
    };
    MyDatabase mydb = MyDatabase.instance;

    if (con == true && fromBackround == false) {
      try {
        Database db = await mydb.database;
        List<Map> result = await db.rawQuery(
            "select * from tech_user where token is not null limit 1");
        log("checkAuth: isEmpty \${result.isEmpty}");

        if (result.isEmpty) {
          ret = {"status": false};
        } else {
          var resUser = result.first;
          await BaseClient.safeApiCall(
            Environment.authCheck,
            RequestType.post,
            data: {"device_id": deviceId},
            onSuccess: (Response response) {
              var data = response.data;
              log("checkAuth: TOKEN \${resUser['token']}");
              if (data['auth'] == false) {
                log("checkAuth: INVALID TOKEN");
                ret = {"status": false, "message": data['message']};
              } else {
                user = User(
                  uc: resUser["uc"],
                  userName: resUser["user_name"],
                  fullName: resUser["full_name"],
                  token: resUser["token"],
                  refreshToken: resUser["refresh_token"],
                );
                ret = {"status": true, "user": user};
              }
            },
            onError: (e) {
              log("checkAuth: ERROR DIO \${e.message}");
              ret = {"status": false, "message": e.message};
            },
          );
        }
      } catch (e) {
        log("Auth Something Went Wrong $e");
        ret = {"status": false};
      }
    } else {
      try {
        Database db = await mydb.database;
        List<Map> result = await db.rawQuery(
            "select * from tech_user where token is not null and refresh_token is not null limit 1");
        log('checkAuth: check local \$result');

        if (result.isEmpty) {
          ret = {"status": false};
        } else {
          var resUser = result.first;
          user = User(
            uc: resUser["uc"],
            userName: resUser["user_name"],
            fullName: resUser["full_name"],
            token: resUser["token"],
            refreshToken: resUser["refresh_token"],
          );
          ret = {"status": true, "user": user};
        }
      } catch (e) {
        user = null;
        ret = {"status": false, "message": e};
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

  Future checkSeafarer({required String seafarer}) async {
    MyDatabase mydb = MyDatabase.instance;
    Map<String, dynamic> ret = {
      'status': false,
      'message': "Silahkan Coba Lagi [99]"
    };

    try {
      await BaseClient.safeApiCall(
        Environment.checkSeafarer,
        RequestType.post,
        data: {'seafarer_code': seafarer},
        isJson: false,
        onSuccess: (Response response) {
          log("LOG ${response.data['data']}");
          ret = {'status': true, 'data': response.data['data']};
        },
        onError: (e) {
          log("E ${e.message}");
          ret = {'status': false, 'message': e.message};
        },
      );
    } catch (e) {
      log("E $e");
    } finally {
      log("seafarer close db");
      await mydb.close();
    }
    return ret;
  }

  Future claim({
    required String device_id,
    required String uc_participant,
    required String email,
    required String full_name,
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> ret = {
      'status': false,
      'message': "Silahkan Coba Lagi [99]"
    };

    try {
      await BaseClient.safeApiCall(
        Environment.claim,
        RequestType.post,
        data: {
          'device_id': device_id,
          'uc_participant': uc_participant,
          'username': username,
          'password': password,
          'email': email,
          'full_name': full_name,
        },
        onSuccess: (Response response) {
          ret = {'status': true};
        },
        onError: (e) {
          log("E ${e.message}");
          ret = {'status': false, 'message': e.message};
        },
      );
    } catch (e) {
      log("E $e");
    }

    return ret;
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

      try {
        log("getData: ONLINE CHECK");
        // Menggunakan BaseClient untuk melakukan request API
        await BaseClient.safeApiCall(
          Environment.getUserData, // URL endpoint
          RequestType.post, // Jenis request
          data: {'uc': uc}, // Data yang dikirim
          onSuccess: (Response response) async {
            log("getData: trb check $response");
            var data = response.data['data'];
            data['trb_participant'].remove("id");

            // Simpan atau update data ke dalam database lokal
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
          },
          onError: (e) {
            log("getData: failed to get user data from online ${e.message}");
          },
        );
      } catch (e) {
        log("getData: Error $e");
      }
    }

    Database db = await mydb.database;
    try {
      List<Map> result = await db.rawQuery(
          "select uc as uc_tech_user, uc_participant, user_name, full_name, email from tech_user where uc = ? limit 1",
          [uc]);
      if (result.isEmpty) {
        throw ("notfound");
      }

      var resUser = result.first;
      log("getData: resUser $resUser");
      Map ret = {};
      ret.addAll(resUser);

      Map resTrb = {};
      List<Map> resultTrb = await db.rawQuery(
          "select uc_trb_schedule, uc_participant, uc_diklat_participant, seafarer_code from tech_trb_participant where uc_participant = ? limit 1",
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
          ret.addAll(resSchedule);
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
