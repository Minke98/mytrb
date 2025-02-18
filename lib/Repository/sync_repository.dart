import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/utils/custom_error.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytrb/Helper/custom_error.dart';
import 'package:mytrb/Helper/manual_con_check.dart';
import 'package:mytrb/Helper/multipart_extended.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Helper/my_dio.dart';
import 'package:mytrb/Repository/chat_repository.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/user_repository.dart';
import 'package:mytrb/constants/constants.dart';
import 'package:path/path.dart' as Path;

class SyncRepository extends Repository {
  Future doSync({required StreamController<String> stream}) async {
    var con = await ConnectionTest.check();
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map finalRes = {"status": true};
    try {
      if (con == false) {
        throw CustomException(
            "Silahkan Hidupkan Koneksi Internet Untuk Melakukan Sinkronisasi");
      }
      stream.add("Checking Server Changes");
      var getNew = await SyncRepository.getServerJournal();

      bool serverSync = await fromServerSync(stream: stream);
      // if (serverSync['status'] == false) {
      //   throw CustomException(serverSync["message"]);
      // }
      // log("SSYNC $serverSync");

      List<Map> toSync = [];
      List<Map> res = await db
          .rawQuery(""" select * from tech_journal order by log_stamp asc """);
      if (res.isNotEmpty) {
        int syncCount = res.length;
        int syncCountProgres = 0;
        for (Map item in res) {
          syncCountProgres++;
          log("syncRepo: Item $item");
          switch (item["table_name"]) {
            case "tech_sign":
              stream.add("Sync Sign ($syncCountProgres/$syncCount)");
              await techSign(item: item);
              break;
            case "tech_sign_att":
              // List<Map> testResTechSignAtt =
              //     await db.rawQuery(""" select * from tech_sign_att """);
              // log("syncRepo: resTestAtt $testResTechSignAtt");
              stream.add("Sync Sign Media ($syncCountProgres/$syncCount)");
              await techSignAtt(item: item, stream: stream);
              break;
            case "tech_report_route":
              // List<Map> testResTechSignAtt =
              //     await db.rawQuery(""" select * from tech_report_route """);
              // log("syncRepo: resTestAtt $testResTechSignAtt");
              stream.add("Sync Route ($syncCountProgres/$syncCount)");
              await techReportRoute(item: item);
              break;
            case "tech_report_log":
              stream.add("Sync Report ($syncCountProgres/$syncCount)");
              await techReportLog(item: item);
              break;
            case "tech_report_log_att":
              stream.add("Sync Report Media ($syncCountProgres/$syncCount)");
              await techReportLogAtt(item: item);
              break;
            case "tech_task_check":
              stream.add("Sync Task ($syncCountProgres/$syncCount)");
              await techTaskCheck(item: item);
              break;
            case "tech_news_status":
              stream.add("Sync News Status ($syncCountProgres/$syncCount)");
              await techNewsStatus(item: item);
              break;
            case "tech_logbook":
              stream.add("Sync Log Book ($syncCountProgres/$syncCount)");
              await techLogBook(item: item);
              break;
            default:
              log("homePage: No handle yet for ${item['table_name']}");
          }
          // List<Map> tmpRes = await db
          //     .rawQuery("""select * from ${item["table_name"]} limit 1 """, []);
          // if (tmpRes.isNotEmpty) {
          //   Map tmp = {"table_name": item['table_name']};
          //   tmp['action_type'] = item['action_type'];
          //   tmp['data'] = tmpRes.first;
          //   toSync.add(tmp);
          // }
        }
      }
      log("syncRepo: toSync $toSync");
    } on CustomException catch (e) {
      log("CUSTOM $e");
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    }

    return finalRes;
  }

  static Future<Map> getServerJournal() async {
    log("getServerJournal");
    Map finalRes = {"status": false};
    var con = await ConnectionTest.check();
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      if (con == false) {
        throw ("no network");
      }
      log("getServerJournal 2b");
      await dbx.transaction((db) async {
        mydb.transaction = db;
        log("getServerJournal 3b");
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;
        List findUser = await db.rawQuery(
            """ select * from tech_user where uc = ? limit 1 """, [userUc]);
        if (findUser.isEmpty) {
          log("getServerJournal $findUser");
          throw ("user not found");
        }
        log("getServerJournal 4 $findUser");
        Map token = await UserRepository.getToken(uc: userUc);
        Dio dio = await MyDio.getDio(
            token: token['token'], refreshToken: token['refreshToken']);

        List findServerJournal = await db.rawQuery(
            """ select * from tech_journal_server order by log_stamp desc limit 1 """);
        int time = 0;
        if (findServerJournal.isNotEmpty) {
          Map tmp = findServerJournal.first;
          time = tmp['log_stamp'];
        } else {
          List findInLast = await db
              .rawQuery(""" select * from tech_journal_server_last limit 1 """);
          if (findInLast.isNotEmpty) {
            Map tmp = findInLast.first;
            time = int.parse(tmp['time']);
          }
        }
        Map<String, dynamic> formDataMap = {"uc": userUc, "time": time};
        log("getServerJournal 5 $formDataMap");
        FormData formData = FormData.fromMap(formDataMap);
        var response = await dio.post("journal/server", data: formData);
        Map data = response.data;
        log("getServerJournal 6 $data");
        if (data['status'] == true) {
          for (Map m in data['journal']) {
            log("getServerJournal 7 $m");
            List findJournal = await db.rawQuery(
                """ select * from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ? """,
                [
                  m['table_name'],
                  m['table_key'],
                  m['action_type'],
                  m['log_stamp']
                ]);

            if (findJournal.isEmpty) {
              log("getServerJournal 7b $m");
              await db.rawInsert(
                  """ insert into tech_journal_server values (?,?,?,?)  """,
                  [
                    m['table_name'],
                    m['table_key'],
                    m['action_type'],
                    m['log_stamp']
                  ]);
            }
            log("getServerJournal 8 $m");
            await db.rawUpdate(
                """ update tech_journal_server_last set time = ? where id = 'server_journal' """,
                [m['log_stamp']]);
          }
        }
        finalRes['status'] = true;
      });
    } on DioError catch (e) {
      log("syncRepo: Dio Error $e");
    } catch (e) {
      log("getServerJournal $e");
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future fromServerSync({required StreamController<String> stream}) async {
    log("getServerJournal fromServerSync");
    var con = await ConnectionTest.check();

    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      log("getServerJournal fromServerSync start");
      await db.transaction((txn) async {
        mydb.transaction = txn;
        if (con == false) {
          throw CustomException(
              "Silahkan Hidupkan Koneksi Internet Untuk Melakukan Sinkronisasi [2]");
        }
        log("getServerJournal fromServerSync findServerJournal");
        List<Map> findServerJournal = await txn.rawQuery(
            """ select * from tech_journal_server order by log_stamp asc """);
        log("getServerJournal fromServerSync find $findServerJournal");
        if (findServerJournal.isNotEmpty) {
          for (Map item in findServerJournal) {
            if (item['action_type'] == 'c' || item['action_type'] == 'u') {
              Map token = await UserRepository.getToken();
              Dio dio = await MyDio.getDio(token: token['token']);
              Map<String, dynamic> fdata = {
                'table': item['table_name'],
                'table_uc': item['table_key'],
              };
              FormData formData = FormData.fromMap(fdata);
              log("formData $fdata");
              var resSign =
                  await dio.post("tableendpoint/data", data: formData);
              log("getServerJournal fromServerSync $resSign ");
              if (resSign.data['status'] == true) {
                switch (item['table_name']) {
                  case "tech_user":
                    log("getServerJournal fromServerSync tech user ${resSign.data['data']}");
                    stream.add("Sync Tech User");
                    await serverTechUser(
                        db: txn, item: resSign.data['data'], journalItem: item);
                    break;
                  case "tech_participant":
                    stream.add("Sync Tech Participant");
                    await serverTechParticipant(
                        db: txn, item: resSign.data['data'], journalItem: item);
                    break;
                  case "tech_instructor":
                    stream.add("Sync Tech Instructor");
                    await serverTechInstructor(
                        db: txn, item: resSign.data['data'], journalItem: item);
                    break;
                  case "tech_task_check":
                    stream.add("Sync Task CheckList Approval");
                    await severTechTaskCheck(
                        db: txn, item: resSign.data['data'], journalItem: item);
                    break;
                  case "tech_report_log":
                    stream.add("Sync Task Report Approval");
                    await severTechReportLog(
                        db: txn, item: resSign.data['data'], journalItem: item);
                    break;
                  case "tech_type_vessel":
                    stream.add("Sync Task Vessel");
                    await serverVesselType(
                        db: txn, item: resSign.data['data'], journalItem: item);
                    break;
                  default:
                    log("homePage: No handle yet for ${resSign.data["table_name"]}");
                }
              } else {
                await txn.rawDelete(
                    """ delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ? """,
                    [
                      item['table_name'],
                      item['table_key'],
                      item['action_type'],
                      item['log_stamp']
                    ]);
              }
            }
          }
        }
      });
      mydb.transaction = null;
      return true;
    } on DioError catch (e) {
      log("getServerJournal Dio Error $e");
    } on CustomException catch (e) {
      log("getServerJournal fromServerSync ERr $e");
      return Future.error(CustomException(e.toString()));
    } finally {
      mydb.transaction = null;
    }
  }

  Future severTechReportLog(
      {required db, required Map item, required Map journalItem}) async {
    if (journalItem['action_type'] == 'u') {
      log("UPDATE SEREVER SYNC tech_report_log ${journalItem['table_key']} $item");
      List findReportLog = await db.rawQuery(
          """ select * from tech_report_log where uc = ? limit 1 """,
          [journalItem['table_key']]);
      if (findReportLog.isNotEmpty) {
        Map reportLog = findReportLog.first;
        await db.rawUpdate(
            """ update tech_report_log set app_lect_status = ?, app_lect_uc = ?, app_lect_time = ? where uc_report_list = ? """,
            [
              item['app_lect_status'],
              item['app_lect_uc'],
              item['app_lect_time'],
              reportLog['uc_report_list']
            ]);
      }
    }
    log("UPDATE SEREVER SYNC tech_report_log removing $journalItem");
    await db.rawDelete(
        """delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ?""",
        [
          journalItem['table_name'],
          journalItem['table_key'],
          journalItem['action_type'],
          journalItem['log_stamp'],
        ]);
  }

  Future severTechTaskCheck(
      {required db, required Map item, required Map journalItem}) async {
    if (journalItem['action_type'] == 'u') {
      log("UPDATE SEREVER SYNC tech_task_check");
      await db.rawUpdate(
          """ update tech_task_check set app_lect_status = ?, app_lect_uc = ?, app_lect_time = ? where uc = ? """,
          [
            item['app_lect_status'],
            item['app_lect_uc'],
            item['app_lect_time'],
            journalItem['table_key']
          ]);
    }
    await db.rawDelete(
        """delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ?""",
        [
          journalItem['table_name'],
          journalItem['table_key'],
          journalItem['action_type'],
          journalItem['log_stamp'],
        ]);
  }

  Future serverTechUser(
      {required db, required Map item, required Map journalItem}) async {
    if (journalItem['action_type'] == 'u') {
      log("UPDATE SEREVER SYNC tech_user");
      await db.rawUpdate(
          """ update tech_user set full_name = ? where uc = ? """,
          [item['full_name'], journalItem['table_key']]);
    }
    await db.rawDelete(
        """delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ?""",
        [
          journalItem['table_name'],
          journalItem['table_key'],
          journalItem['action_type'],
          journalItem['log_stamp'],
        ]);
  }

  Future serverTechParticipant(
      {required db, required Map item, required Map journalItem}) async {
    log("UPDATE SEREVER SYNC tech_participant");
    if (journalItem['action_type'] == 'u') {
      await db.rawUpdate(
          """ update tech_participant set full_name = ? where uc = ? """,
          [item['full_name'], journalItem['table_key']]);
    }
    await db.rawDelete(
        """delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ?""",
        [
          journalItem['table_name'],
          journalItem['table_key'],
          journalItem['action_type'],
          journalItem['log_stamp'],
        ]);
  }

  Future serverTechInstructor(
      {required db, required Map item, required Map journalItem}) async {
    if (journalItem['action_type'] == "c") {
      await db.rawInsert(""" insert into tech_instructor values (?,?,?,?) """,
          [item['uc'], item['category'], item['id_number'], item['full_name']]);
    } else if (journalItem['action_type'] == "u") {
      List findInstructor = await db.rawQuery(
          """ select * from tech_instructor where uc =? limit 1""",
          [journalItem['table_key']]);
      if (findInstructor.isEmpty) {
        await db.rawInsert(
            """ insert into tech_instructor values (?,?,?,?) """,
            [
              item['uc'],
              item['category'],
              item['id_number'],
              item['full_name']
            ]);
      } else {
        await db.rawUpdate(
            """ update tech_instructor set category = ?, id_number = ?, full_name = ? where uc = ? """,
            [
              item['category'],
              item['id_number'],
              item['full_name'],
              journalItem['table_key']
            ]);
      }
    } else if (item['action_type'] == 'd') {
      // """ delete from tech_instructor where category = ? and id_number = ? and full_name = ? and uc = ? """,
      // [
      //       item['category'],
      //       item['id_number'],
      //       item['full_name'],
      //       journalItem['table_key']
      //     ]
      await db.rawDelete(""" delete from tech_instructor where uc = ? """,
          [journalItem['table_key']]);
    }
    await db.rawDelete(
        """delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ?""",
        [
          journalItem['table_name'],
          journalItem['table_key'],
          journalItem['action_type'],
          journalItem['log_stamp'],
        ]);
  }

  Future serverVesselType(
      {required db, required Map item, required Map journalItem}) async {
    if (journalItem['action_type'] == "c") {
      await db.rawInsert(""" insert into tech_type_vessel values (?,?) """,
          [item['uc'], item['type_vessel']]);
    } else if (journalItem['action_type'] == "u") {
      List findInstructor = await db.rawQuery(
          """ select * from tech_type_vessel where uc =? limit 1""",
          [journalItem['table_key']]);
      if (findInstructor.isEmpty) {
        await db.rawInsert(""" insert into tech_type_vessel values (?,?) """,
            [item['uc'], item['type_vessel']]);
      } else {
        await db.rawUpdate(
            """ update tech_type_vessel set type_vessel = ? where uc = ? """,
            [item['type_vessel'], journalItem['table_key']]);
      }
    } else if (item['action_type'] == 'd') {
      await db.rawDelete(""" delete from tech_type_vessel where uc = ? """,
          [journalItem['table_key']]);
    }
    await db.rawDelete(
        """delete from tech_journal_server where table_name = ? and table_key = ? and action_type = ? and log_stamp = ?""",
        [
          journalItem['table_name'],
          journalItem['table_key'],
          journalItem['action_type'],
          journalItem['log_stamp'],
        ]);
  }

  Future techSign({required Map item}) async {
    log("syncRepo: tech_sign sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(token: token['token']);
      await db.transaction((txn) async {
        //get current data
        mydb.transaction = txn;
        List<Map> resTechSign = await txn.rawQuery(
            """ select * from tech_sign where local_uc = ? limit 1""",
            [item['table_key']]);
        if (resTechSign.isNotEmpty) {
          Map<String, dynamic> techSign = Map.from(resTechSign.first);
          Map<String, dynamic> tmp = Map.from(resTechSign.first);

          final prefs = await SharedPreferences.getInstance();
          String userUc = prefs.getString('userUc')!;
          String localUc = techSign["uc"];
          // Map getUser = await UserRepository.getLocalUser(uc: userUc);
          // if (getUser['status'] == false) {
          //   throw ("UNABLE TO GET USER");
          // }
          if (techSign["sign_on_date"] != null &&
              techSign["sign_off_date"] != null) {
            await ChatRepository.leaveLecturerGroup(
                ucLecturer: techSign['uc_lecturer'], db: txn);
          } else if (techSign["sign_on_date"] != null &&
              techSign["sign_off_date"] == null) {
            await ChatRepository.joinLecturerGroup(
                uc_chat_user: userUc,
                uc_lecturer: techSign['uc_lecturer'],
                db: txn);
          }
          log("syncRepo: all $techSign");
          if (item['action_type'] == "c") {
            techSign.remove("uc");
          }
          List techSignToBeRemoved = [];
          techSign.forEach((key, value) {
            if (value == null) {
              techSignToBeRemoved.add(key);
            }
          });
          for (var element in techSignToBeRemoved) {
            techSign.remove(element);
          }
          log("syncRepo: create tech sign $techSign");
          // techSign['vessel_name'] = "TEstUpdate";
          FormData formData = FormData.fromMap(techSign);
          var resSign = await dio.post("sync/sign", data: formData);
          log("res $resSign");
          Map resSignData = resSign.data;
          if (resSignData['status'] == true) {
            // if (item['action_type'] == "c") {
            //   int signUpdate = await txn.rawUpdate(
            //       """ update tech_sign set uc = ? where local_uc = ? """,
            //       [resSignData['uc'], techSign['local_uc']]);
            // }
            if (tmp['uc'] != resSignData['uc']) {
              int signUpdate = await txn.rawUpdate(
                  """ update tech_sign set uc = ? where local_uc = ? """,
                  [resSignData['uc'], techSign['local_uc']]);
            }
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
      mydb.transaction = null;
    } on DioError catch (e) {
      log("syncRepo: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
      // , "message": e.response?.data['message']
    } finally {
      mydb.transaction = null;
    }
  }

  Future techSignAtt({required Map item, StreamController? stream}) async {
    log("syncRepo: tech_sign_att sync");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    // FormData test = FormData.fromMap({
    //   "sign_on": MultipartFileExtended.fromFileSync("./example/upload.txt",
    //       filename: "upload.txt")
    // });
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(token: token['token']);
      await db.transaction((txn) async {
        //get current data
        mydb.transaction = txn;
        List<Map> resTechSignAtt = await txn.rawQuery(
            """ select * from tech_sign_att where local_uc = ? limit 1""",
            [item['table_key']]);
        if (resTechSignAtt.isNotEmpty) {
          Map<String, dynamic> postData = {};
          Map<String, dynamic> techSignAtt = Map.from(resTechSignAtt.first);
          Map<String, dynamic> tmp = Map.from(resTechSignAtt.first);
          log("syncRepo: all tech_sign_att $techSignAtt");
          io.Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          String savePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER);

          if (item['action_type'] == "u") {
            postData['uc'] = techSignAtt['uc'];
          }
          postData['local_uc'] = techSignAtt['local_uc'];
          postData['uc_sign'] = techSignAtt['uc_sign'];

          String imagePath;
          bool imageExist;

          if (techSignAtt['local_att_sign_on'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_sign_on']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_sign_on'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_mutasi_on'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_mutasi_on']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_mutasi_on'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_imo_on'] != null) {
            imagePath = Path.join(
                appDocPath, SIGN_IMAGE_FOLDER, techSignAtt['local_att_imo_on']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_imo_on'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_crew_list_on'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_crew_list_on']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_crew_list_on'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_buku_pelaut_on'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_buku_pelaut_on']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_buku_pelaut_on'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_spesifikasi_kapal'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_spesifikasi_kapal']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_spesifikasi_kapal'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_sign_off'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_sign_off']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_sign_off'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_imo_off'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_imo_off']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_imo_off'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_foto_pelabuhan'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_foto_pelabuhan']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_foto_pelabuhan'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (techSignAtt['local_att_crew_list_off'] != null) {
            imagePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER,
                techSignAtt['local_att_crew_list_off']);
            imageExist = await io.File(imagePath).exists();
            log("syncRepo: $imageExist $imagePath");
            if (imageExist == true) {
              postData['att_crew_list_off'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          // if (stream != null) {
          //   stream.add("posting $postData");
          //   await Future.delayed(const Duration(seconds: 5));
          // }
          FormData formData = FormData.fromMap(postData);

          log("syncRepo: postData $postData");
          var resSignAtt = await dio.post("sync/signatt", data: formData);
          Map resSignDataAtt = resSignAtt.data;
          log("syncRepo: res ${resSignDataAtt}");

          if (resSignDataAtt['status'] == true) {
            if (tmp['uc'] != resSignDataAtt['uc']) {
              int dataUpdate = await txn.rawUpdate(
                  """ update tech_sign_att set uc = ? where local_uc = ? """,
                  [resSignDataAtt['uc'], techSignAtt['local_uc']]);
            }
            Map images = {
              "att_sign_on": null,
              "att_mutasi_on": null,
              "att_imo_on": null,
              "att_crew_list_on": null,
              "att_buku_pelaut_on": null,
              "att_spesifikasi_kapal": null,
              "att_sign_off": null,
              "att_imo_off": null,
              "att_foto_pelabuhan": null,
              "att_crew_list_off": null,
            };
            Map joinedImages = {...images, ...resSignDataAtt['server_images']};
            // if (item['action_type'] == "c") {
            List insertData = [resSignDataAtt['uc']];
            joinedImages.forEach((key, value) {
              insertData.add(value);
            });
            insertData.add(techSignAtt['local_uc']);
            int signAttUpdate =
                await txn.rawUpdate(""" update tech_sign_att set uc = ?, 
                  att_sign_on = ?,
                  att_mutasi_on = ?, 
                  att_imo_on = ?, 
                  att_crew_list_on = ? ,
                  att_buku_pelaut_on = ? ,
                  att_spesifikasi_kapal = ?,
                  att_sign_off = ? ,
                  att_imo_off = ? ,
                  att_foto_pelabuhan = ? ,
                  att_crew_list_off = ?
                  where local_uc = ? """, insertData);
            // }
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
      mydb.transaction = null;
    } on DioError catch (e) {
      log("syncRepo: ERROR DIO sign att ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
      // , "message": e.response?.data['message']
    }
  }

  Future techReportRoute({required Map item}) async {
    log("syncRepo: tech_report_route sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(token: token['token']);
      await db.transaction((txn) async {
        //get current data
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """ select * from tech_report_route where local_uc = ? limit 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          Map<String, dynamic> tmp = Map.from(res.first);

          String localUc = data["local_uc"];
          log("syncRepo: all $data");
          if (item['action_type'] == "c") {
            data.remove("uc");
          }

          if (item['action_type'] == 'd') {
          } else {
            List dataToBeRemoved = [];
            data.forEach((key, value) {
              if (value == null) {
                dataToBeRemoved.add(key);
              }
            });
            dataToBeRemoved.forEach((element) {
              data.remove(element);
            });
            log("syncRepo: create tech_report_route $data");

            FormData formData = FormData.fromMap(data);
            var toServer = await dio.post("sync/reportroute", data: formData);
            Map toServerData = toServer.data;
            if (toServerData['status'] == true) {
              // if (item['action_type'] == "c") {
              //   int dataUpdate = await txn.rawUpdate(
              //       """ update tech_report_route set uc = ? where local_uc = ? """,
              //       [toServerData['uc'], data['local_uc']]);
              // }
              if (tmp['uc'] != toServerData['uc']) {
                int dataUpdate = await txn.rawUpdate(
                    """ update tech_report_route set uc = ? where local_uc = ? """,
                    [toServerData['uc'], data['local_uc']]);
              }
              super.journalRemove(
                  db: txn,
                  tableName: item['table_name'],
                  actionType: item['action_type'],
                  logStamp: item["log_stamp"],
                  tableKey: item["table_key"]);
            }
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
      mydb.transaction = null;
    } on DioError catch (e) {
      log("syncRepo: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
      // , "message": e.response?.data['message']
    }
  }

  Future techReportLog({required Map item}) async {
    log("syncRepo: tech_report_log sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret;
    try {
      Map token = await UserRepository.getToken();
      // Dio dio = await MyDio.getDio(token: token['token']);
      log("TOKEN ${token['refreshToken']}");
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);
      await db.transaction((txn) async {
        //get current data
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """ select * from tech_report_log where local_uc = ? limit 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          Map<String, dynamic> tmp = Map.from(res.first);

          String localUc = data["local_uc"];
          log("syncRepo: all $data");
          if (item['action_type'] == "c") {
            data.remove("uc");
          }

          if (item['action_type'] == 'd') {
          } else {
            List dataToBeRemoved = [];
            data.forEach((key, value) {
              if (value == null) {
                dataToBeRemoved.add(key);
              }
            });
            dataToBeRemoved.forEach((element) {
              data.remove(element);
            });
            log("syncRepotLog: create tech_report_route $data");

            io.Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            String savePath = Path.join(appDocPath, REPORT_FOTO_FOLDER);

            String imagePath;
            bool imageExist;

            if (data['app_inst_local_foto'] != null) {
              imagePath = Path.join(appDocPath, APPROVAL_FOTO_FOLDER,
                  data['app_inst_local_foto']);
              log("imagePath $imagePath");
              imageExist = await io.File(imagePath).exists();
              log("syncRepotLog: $imageExist $imagePath");
              if (imageExist == true) {
                data['app_inst_foto'] =
                    MultipartFileExtended.fromFileSync(imagePath);
              }
            }

            FormData formData = FormData.fromMap(data);
            var toServer = await dio.post("sync/reportlog", data: formData);
            log("serverData ${toServer.data}");
            Map toServerData = toServer.data;
            if (toServerData['status'] == true) {
              // if (item['action_type'] == "c") {
              //   int dataUpdate = await txn.rawUpdate(
              //       """ update tech_report_route set uc = ? where local_uc = ? """,
              //       [toServerData['uc'], data['local_uc']]);
              // }
              Map images = {
                "app_inst_foto": null,
              };
              Map joinedImages = {};
              if (toServerData['server_images'] != false) {
                joinedImages = {...images, ...toServerData['server_images']};
              } else {
                joinedImages = images;
              }
              if (tmp['uc'] != toServerData['uc']) {
                int dataUpdate = await txn.rawUpdate(
                    """ update tech_report_log set uc = ? where local_uc = ? """,
                    [toServerData['uc'], data['local_uc']]);
              }
              List updateData = [];
              joinedImages.forEach((key, value) {
                updateData.add(value);
              });
              updateData.add(data['local_uc']);
              int dataUpdate = await txn.rawUpdate(
                  """ update tech_report_log set app_inst_foto = ? where local_uc = ? """,
                  updateData);
              super.journalRemove(
                  db: txn,
                  tableName: item['table_name'],
                  actionType: item['action_type'],
                  logStamp: item["log_stamp"],
                  tableKey: item["table_key"]);
            }
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
      mydb.transaction = null;
    } on DioError catch (e) {
      log("syncRepo: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
      // , "message": e.response?.data['message']
    } finally {
      mydb.transaction = null;
    }
  }

  Future techReportLogAtt({required Map item}) async {
    log("syncRepo: tech_report_log_att sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);
      await db.transaction((txn) async {
        //get current data
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """ select * from tech_report_log_att where local_uc = ? limit 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          Map<String, dynamic> tmp = Map.from(res.first);

          String localUc = data["local_uc"];
          log("syncRepotLogAtt: all $data");
          if (item['action_type'] == "c") {
            data.remove("uc");
          }

          if (item['action_type'] == 'd') {
          } else {
            List dataToBeRemoved = [];
            data.forEach((key, value) {
              if (value == null) {
                dataToBeRemoved.add(key);
              }
            });
            for (var element in dataToBeRemoved) {
              data.remove(element);
            }
            log("syncRepotLogAtt: create tech_report_route $data");

            io.Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            String savePath = Path.join(appDocPath, REPORT_FOTO_FOLDER);

            String imagePath;
            bool imageExist;

            if (data['local_file'] != null) {
              imagePath =
                  Path.join(appDocPath, REPORT_FOTO_FOLDER, data['local_file']);
              log("imagePath $imagePath");
              imageExist = await io.File(imagePath).exists();
              log("syncRepotLogAtt: $imageExist $imagePath");
              if (imageExist == true) {
                data['file'] = MultipartFileExtended.fromFileSync(imagePath);
              }
            }

            FormData formData = FormData.fromMap(data);
            var toServer = await dio.post("sync/reportlogatt", data: formData);
            log("syncRepotLogAtt: serverData ${toServer.data}");
            Map toServerData = toServer.data;
            if (toServerData['status'] == true) {
              // if (item['action_type'] == "c") {
              //   int dataUpdate = await txn.rawUpdate(
              //       """ update tech_report_route set uc = ? where local_uc = ? """,
              //       [toServerData['uc'], data['local_uc']]);
              // }
              Map images = {
                "file": null,
              };
              Map joinedImages = {};
              if (toServerData['server_images'] != false) {
                joinedImages = {...images, ...toServerData['server_images']};
              } else {
                joinedImages = images;
              }
              if (tmp['uc'] != toServerData['uc']) {
                int dataUpdate = await txn.rawUpdate(
                    """ update tech_report_log_att set uc = ? where local_uc = ? """,
                    [toServerData['uc'], data['local_uc']]);
              }
              List updateData = [];
              joinedImages.forEach((key, value) {
                updateData.add(value);
              });
              updateData.add(data['local_uc']);
              int dataUpdate = await txn.rawUpdate(
                  """ update tech_report_log_att set file = ? where local_uc = ? """,
                  updateData);
              super.journalRemove(
                  db: txn,
                  tableName: item['table_name'],
                  actionType: item['action_type'],
                  logStamp: item["log_stamp"],
                  tableKey: item["table_key"]);
            }
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
      mydb.transaction = null;
    } on DioError catch (e) {
      log("syncRepotLogAtt: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
      // , "message": e.response?.data['message']
    } finally {
      mydb.transaction = null;
    }
  }

  /* Future techTaskCheck({required Map item}) async {
    log("syncRepo: tech_task_check sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(token: token['token']);
      await db.transaction((txn) async {
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """ select * from tech_task_check where local_uc = ? limit 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          Map<String, dynamic> tmp = Map.from(res.first);

          String localUc = data["local_uc"];
          log("syncTaskCheck: all $data");
          if (item['action_type'] == "c" || (data['uc'] == localUc)) {
            data.remove("uc");
          }

          List dataToBeRemoved = [];
          data.forEach((key, value) {
            if (value == null) {
              dataToBeRemoved.add(key);
            }
          });
          for (var element in dataToBeRemoved) {
            data.remove(element);
          }
          log("syncTaskCheck: create tech_task_check $data");

          io.Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          String savePath = Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER);

          io.Directory fotoDir = await getApplicationDocumentsDirectory();
          String fotoDirPath = fotoDir.path;
          String fotoPath = Path.join(fotoDirPath, TASK_APPROVAL_FOTO_FOLDER);

          io.Directory videoDir = await getApplicationDocumentsDirectory();
          String videoDirPath = videoDir.path;
          String videoPath = Path.join(videoDirPath, TASK_CHECKLIST_URL_FOLDER);

          String imagePath;
          bool imageExist;

          if (data['app_inst_local_photo'] != null) {
            imagePath = Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER,
                data['app_inst_local_photo']);
            log("syncTaskCheck: imagePath $imagePath");
            imageExist = await io.File(imagePath).exists();
            log("syncTaskCheck: $imageExist $imagePath");
            if (imageExist == true) {
              data['app_inst_photo'] =
                  MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (data['local_photo'] != null) {
            imagePath = Path.join(fotoDirPath, TASK_APPROVAL_FOTO_FOLDER,
                data['local_photo'].toString());
            log("syncTaskCheck: photo $imagePath");
            imageExist = await io.File(imagePath).exists();
            log("syncTaskCheck: $imagePath");
            if (imageExist == true) {
              data['att_photo'] = MultipartFileExtended.fromFileSync(imagePath);
            }
          }

          if (data['local_url'] != null) {
            imagePath = Path.join(
                videoDirPath, TASK_CHECKLIST_URL_FOLDER, data['local_url']);
            log("syncTaskCheck: url $imagePath");
            imageExist = await io.File(imagePath).exists();
            log("syncTaskCheck: $imagePath");
            if (imageExist == true) {
              data['att_url'] = imagePath;
            }
          }

          log("syncTaskCheck: fdata $data");
          FormData formData = FormData.fromMap(data);
          var toServer = await dio.post("sync/techtaskcheck", data: formData);
          log("syncTaskCheck: serverData ${toServer.data}");
          Map toServerData = toServer.data;
          if (toServerData['status'] == true) {
            Map images = {
              "app_inst_photo": null,
              "att_photo": null,
              "att_url": null,
            };

            Map joinedImages = {};
            if (toServerData['server_images'] != false) {
              joinedImages = {...images, ...toServerData['server_images']};
            } else {
              joinedImages = images;
            }
            if (tmp['uc'] != toServerData['uc']) {
              await txn.rawUpdate(
                  """ update tech_task_check set uc = ? where local_uc = ? """,
                  [toServerData['uc'], data['local_uc']]);
            }
            List updateData = [];
            joinedImages.forEach((key, value) {
              updateData.add(value);
            });
          }
        }
      });
    } on DioError catch (e) {
      log("syncTaskCheck: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
    } finally {
      mydb.transaction = null;
    }
  } */

  Future<void> techTaskCheck({required Map item}) async {
    log("syncRepo: tech_task_check sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(token: token['token']);
      await db.transaction((txn) async {
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """SELECT * FROM tech_task_check WHERE local_uc = ? LIMIT 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          String localUc = data["local_uc"];
          log("syncTaskCheck: all $data");
          if (item['action_type'] == "c" || (data['uc'] == localUc)) {
            data.remove("uc");
          }

          // Remove null values from data
          data.removeWhere((key, value) => value == null);

          log("syncTaskCheck: create tech_task_check $data");

          // Build image paths
          String appDocPath = (await getApplicationDocumentsDirectory()).path;
          String imagePath;

          // Check and include app_inst_photo
          if (data['app_inst_local_photo'] != null) {
            imagePath = Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER,
                data['app_inst_local_photo']);
            bool imageExist = await File(imagePath).exists();
            if (imageExist) {
              data['app_inst_photo'] = await MultipartFile.fromFile(imagePath);
            }
          }

          // Check and include local_photo
          if (data['local_photo'] != null) {
            imagePath = Path.join(
                appDocPath, TASK_APPROVAL_FOTO_FOLDER, data['local_photo']);
            bool imageExist = await File(imagePath).exists();
            if (imageExist) {
              data['att_photo'] = await MultipartFile.fromFile(imagePath);
            }
          }

          log("syncTaskCheck: fdata $data");
          FormData formData = FormData.fromMap(data);
          var toServer = await dio.post("sync/techtaskcheck", data: formData);
          log("syncTaskCheck: serverData ${toServer.data}");
          Map toServerData = toServer.data;
          if (toServerData['status'] == true) {
            // Update local database with server data
            await txn.rawUpdate(
                """UPDATE tech_task_check SET uc = ? WHERE local_uc = ?""",
                [toServerData['uc'], data['local_uc']]);

            // Remove images if necessary
            // Add logic here if needed

            // Remove item from journal
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        } else {
          // Handle deletion action
          if (item['action_type'] == "d") {
            Map<String, dynamic> fdata = {"uc": item['table_key']};
            log("remove server $item $fdata");
            FormData formData = FormData.fromMap(fdata);

            var toServer =
                await dio.post("sync/techtaskcheckdelete", data: formData);
            Map toServerData = toServer.data;
            if (toServerData['status'] == true) {
              super.journalRemove(
                  db: txn,
                  tableName: item['table_name'],
                  actionType: item['action_type'],
                  logStamp: item["log_stamp"],
                  tableKey: item["table_key"]);
            }
          } else {
            // Handle other action types here
          }
        }
      });
    } on DioError catch (e) {
      log("syncRepotLogAtt: ERROR DIO ${e.response}");
      throw CustomException(
          e.response?.data['message'] ?? "Unknown error occurred");
    } finally {
      mydb.transaction = null;
    }
  }

  Future techNewsStatus({required Map item}) async {
    log("syncNewsStatus: tech_news_status sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(token: token['token']);
      await db.transaction((txn) async {
        //get current data
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """ select * from tech_news_status where local_uc = ? limit 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          Map<String, dynamic> tmp = Map.from(res.first);

          String localUc = data["local_uc"];
          log("syncNewsStatus: data lokal $data");
          if (item['action_type'] == "c") {
            data.remove("uc");
          }

          if (item['action_type'] == 'd') {
          } else {
            List dataToBeRemoved = [];
            data.forEach((key, value) {
              if (value == null) {
                dataToBeRemoved.add(key);
              }
            });
            dataToBeRemoved.forEach((element) {
              data.remove(element);
            });
            log("syncNewsStatus: create tech_news_status $data");

            FormData formData = FormData.fromMap(data);
            var toServer =
                await dio.post("sync/technewsstatus", data: formData);
            Map toServerData = toServer.data;
            log("syncNewsStatus: server response $toServerData");
            if (toServerData['status'] == true) {
              // if (item['action_type'] == "c") {
              //   int dataUpdate = await txn.rawUpdate(
              //       """ update tech_report_route set uc = ? where local_uc = ? """,
              //       [toServerData['uc'], data['local_uc']]);
              // }
              if (tmp['uc'] != toServerData['uc']) {
                int dataUpdate = await txn.rawUpdate(
                    """ update tech_news_status set uc = ? where local_uc = ? """,
                    [toServerData['uc'], data['local_uc']]);
              }
              super.journalRemove(
                  db: txn,
                  tableName: item['table_name'],
                  actionType: item['action_type'],
                  logStamp: item["log_stamp"],
                  tableKey: item["table_key"]);
            }
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
      mydb.transaction = null;
    } on DioError catch (e) {
      log("syncRepo: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
      // , "message": e.response?.data['message']
    }
  }

  Future techLogBook({required Map item}) async {
    log("syncRepo: tech_report_log_att sync $item");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      Map token = await UserRepository.getToken();
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);
      await db.transaction((txn) async {
        mydb.transaction = txn;
        List<Map> res = await txn.rawQuery(
            """ select * from tech_logbook where local_uc = ? limit 1""",
            [item['table_key']]);
        if (res.isNotEmpty) {
          Map<String, dynamic> data = Map.from(res.first);
          Map<String, dynamic> tmp = Map.from(res.first);

          String localUc = data["local_uc"];
          log("syncLogbook: all $data");
          if (item['action_type'] == "c" || (data['uc'] == localUc)) {
            data.remove("uc");
          }

          if (item['action_type'] == 'd') {
          } else {
            List dataToBeRemoved = ['app_inst_photo_remote'];
            data.forEach((key, value) {
              if (value == null) {
                dataToBeRemoved.add(key);
              }
            });
            for (var element in dataToBeRemoved) {
              data.remove(element);
            }
            log("syncLogbook: create tech_report_route $data");

            io.Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            String savePath = Path.join(appDocPath, LOG_APPROVAL_FOTO_FOLDER);

            String imagePath;
            bool imageExist;

            if (data['app_inst_photo'] != null) {
              imagePath = Path.join(
                  appDocPath, LOG_APPROVAL_FOTO_FOLDER, data['app_inst_photo']);
              log("imagePath $imagePath");
              imageExist = await io.File(imagePath).exists();
              log("syncLogbook: $imageExist $imagePath");
              if (imageExist == true) {
                data['app_inst_photo'] =
                    MultipartFileExtended.fromFileSync(imagePath);
              }
            }

            FormData formData = FormData.fromMap(data);
            var fromServer = await dio.post("sync/logbook", data: formData);
            log("syncLogbook: serverData ${fromServer.data}");
            Map fromServerData = fromServer.data;
            if (fromServerData['status'] == true) {
              // if (item['action_type'] == "c") {
              //   int dataUpdate = await txn.rawUpdate(
              //       """ update tech_report_route set uc = ? where local_uc = ? """,
              //       [toServerData['uc'], data['local_uc']]);
              // }
              Map images = {
                "app_inst_photo": null,
              };
              Map joinedImages = {};
              if (fromServerData['server_images'] != false) {
                joinedImages = {...images, ...fromServerData['server_images']};
              } else {
                joinedImages = images;
              }
              if (tmp['uc'] != fromServerData['uc']) {
                await txn.rawUpdate(
                    """ update tech_logbook set uc = ? where local_uc = ? """,
                    [fromServerData['uc'], data['local_uc']]);
              }
              List updateData = [];
              joinedImages.forEach((key, value) {
                updateData.add(value);
              });
              updateData.add(data['local_uc']);
              await txn.rawUpdate(
                  """ update tech_logbook set app_inst_photo_remote = ? where local_uc = ? """,
                  updateData);
              super.journalRemove(
                  db: txn,
                  tableName: item['table_name'],
                  actionType: item['action_type'],
                  logStamp: item["log_stamp"],
                  tableKey: item["table_key"]);
            }
          }
        } else {
          if (item['action_type'] != "d") {
            super.journalRemove(
                db: txn,
                tableName: item['table_name'],
                actionType: item['action_type'],
                logStamp: item["log_stamp"],
                tableKey: item["table_key"]);
          }
        }
      });
    } on DioError catch (e) {
      log("syncLogbook: ERROR DIO ${e.response}");
      Future.error(CustomException(e.response?.data['message']));
    } finally {
      mydb.transaction = null;
    }
  }
}
