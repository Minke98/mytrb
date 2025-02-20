import 'dart:developer';
import 'dart:io';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:path/path.dart' as Path;
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ReportRepository extends Repository {
  Future addRoute(
      {required String locationName,
      required Position position,
      required String ucSign,
      required int month,
      String localUc = ""}) async {
    Map finalRes = {"status": true};
    try {
      log("reportRoute: SAVE TRIGGER BLOC in repo");
      log("reportRepository: addRoute");
      MyDatabase mydb = MyDatabase.instance;
      Database db = await mydb.database;
      db.transaction((txn) async {
        mydb.transaction = txn;
        if (localUc != "") {
          log("reportRepository: update $localUc");
          await txn.rawUpdate(""" 
          update tech_report_route set month = ?, item = ?, check_latitude = ?, check_longitude = ? where local_uc = ?
          """, [
            month,
            locationName,
            position.latitude,
            position.longitude,
            localUc
          ]);
          await journalIt(
              db: txn,
              tableName: "tech_report_route",
              actionType: "u",
              tableKey: localUc);
        } else {
          log("reportRepository: inset New $locationName");
          var uuid = const Uuid();
          final prefs = await SharedPreferences.getInstance();
          String userUc = prefs.getString('userUc')!;
          String localUc = "local_${uuid.v1()}_$userUc";
          // Map signData = await SignRepository.getData(localSignUc: ucSign);
          await txn.rawInsert(
              """ insert into tech_report_route values (?,?,?,?,?,?,?) """,
              [
                localUc,
                localUc,
                ucSign,
                month,
                locationName,
                position.latitude,
                position.longitude
              ]);
          await journalIt(
              db: txn,
              tableName: "tech_report_route",
              actionType: "c",
              tableKey: localUc);
        }
      });
      mydb.transaction = null;
      log("reportRepository: OK");
    } catch (e) {
      log("reportRepository: $e");
      finalRes["status"] = false;
      finalRes['message'] = e.toString();
    }

    return finalRes;
  }

  Future getRoutes({required month, required ucSign}) async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    List<Map> res = await db.rawQuery(
        """ select * from tech_report_route where uc_sign = ? and month = ? """,
        [ucSign, month]);
    log("reportRepository: $res");
    if (res.isNotEmpty) {
      return res;
    } else {
      return [];
    }
  }

  Future getMonthContent({required ucSign}) async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    List<Map> res = await db.rawQuery(
        """ SELECT DISTINCT(month) as month FROM tech_report_route where uc_sign = ? """,
        [ucSign]);
    log("active Report repo $res $ucSign");
    List<int> ret = [];
    if (res.isNotEmpty) {
      for (Map item in res) {
        ret.add(item['month']);
      }
    }
    List<Map> res2 = await db.rawQuery(
        """ SELECT DISTINCT(month) as month FROM tech_report_log where uc_sign = ? """,
        [ucSign]);
    log("active Report repo $res $ucSign");
    if (res2.isNotEmpty) {
      for (Map item in res2) {
        if (ret.contains(item['month']) == false) {
          ret.add(item['month']);
        }
      }
    }
    return ret;
  }

  Future getReportList({required month}) async {
    Map finalRes = {"status": true};
    try {
      MyDatabase mydb = MyDatabase.instance;
      Database db = await mydb.database;
      Map userData = await UserRepository.getLocalUserReport();
      log("reportRepository $userData");
      List<Map> res = await db.rawQuery(
          """ select * from tech_trb_participant where seafarer_code=? limit 1""",
          [userData['data']['seafarer_code']]);
      if (res.isEmpty) {
        throw ("User Cannot Be Found using $userData");
      }
      Map dataTechTrbParticipant = Map.from(res.first);

      res = await db.rawQuery(
          """ select * from tech_trb_schedule where uc=? limit 1""",
          [dataTechTrbParticipant['uc_trb_schedule']]);
      if (res.isEmpty) {
        throw ("Participant Cannot Be Found");
      }
      Map dataTrbSchedule = Map.from(res.first);

      res = await db.rawQuery(
          """ select * from tech_report_list where uc_level=? and month=?""",
          [dataTrbSchedule['uc_level'], month]);
      if (res.isEmpty) {
        throw ("Participant Cannot Be Found");
      }
      finalRes['data'] = res;
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    }

    return finalRes;
  }

  Future getReportItem(
      {required month, required ucReportList, required ucSign}) async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      List<Map> reportlist = await db.rawQuery(
          """ select tech_report_log.uc as report_log_uc,tech_report_log_att.uc as report_log_att_uc, * from 
      tech_report_log join tech_report_log_att 
      on tech_report_log.uc = tech_report_log_att.uc_report_log
      where tech_report_log.month = ? and tech_report_log.uc_report_list = ? and tech_report_log.uc_sign = ? order by check_time desc
      """, [month, ucReportList, ucSign]);
      if (reportlist.isEmpty) {
        return <Map>[];
      } else {
        List<Map> ret = [];
        for (Map item in reportlist) {
          Map tmpItem = Map.from(item);
          tmpItem.remove("uc");
          ret.add(tmpItem);
        }
        log("return $ret");
        return ret;
      }
    } finally {}
  }

  Future saveImage(
      {required File foto,
      required String caption,
      required int month,
      String? uc,
      String? ucAtt,
      required String ucSign,
      required String ucLecturer,
      required String ucReport,
      required String deviceId,
      Position? position}) async {
    Map finalRes = {};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      var uuid = const Uuid();
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      bool isNew = false;
      if (uc == null) {
        uc = "local_${uuid.v1()}_$userUc";
        isNew = true;
      }
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String savePath = Path.join(appDocPath, REPORT_FOTO_FOLDER);
      Directory(savePath).createSync(recursive: true);
      String fotoExt = Path.extension(foto.path);
      dbx.transaction((db) async {
        mydb.transaction = db;
        if (isNew == true) {
          var format = DateFormat('yyyy-MM-dd');
          DateTime currentTime = DateTime.now().toUtc();
          String currentTimeFormated = format.format(currentTime);
          await db.rawInsert(""" insert into tech_report_log (
          uc, local_uc, uc_sign, uc_report_list, month, 
          check_latitude, check_longitude, check_time, app_lect_status, 
          app_lect_uc, device_id) 
          values (?,?,?,?,?,?,?,?,?,?,?)""", [
            uc,
            uc,
            ucSign,
            ucReport,
            month,
            position!.latitude,
            position.longitude,
            currentTimeFormated,
            0,
            ucLecturer,
            deviceId
          ]);
        } else {
          var format = DateFormat('yyyy-MM-dd');
          DateTime currentTime = DateTime.now().toUtc();
          String currentTimeFormated = format.format(currentTime);
          await db.rawUpdate(""" 
          update tech_report_log set
          uc_sign = ?,
          uc_report_list = ?,
          month = ?,
          check_time = ?,
          device_id = ?
          where uc = ?
        """, [ucSign, ucReport, month, currentTimeFormated, deviceId, uc]);
        }
        String fotoName = "${ucSign}_${uc}_report_$month$fotoExt";
        foto.copySync("$savePath/$fotoName");

        bool isAttNew = false;
        if (ucAtt == null) {
          isAttNew = true;
          ucAtt = "local_${uuid.v1()}_$userUc";
        }
        if (isAttNew == true) {
          await db.rawInsert(""" insert into tech_report_log_att 
              (uc, local_uc, uc_report_log, local_file, caption) 
              values (?,?,?,?,?) """, [ucAtt, ucAtt, uc, fotoName, caption]);
        } else {
          await db.rawUpdate("""
          update tech_report_log_att set
          uc_report_log = ?,
          local_file = ?,
          caption = ?
          where uc = ?
          """, [uc, foto.path, caption, ucAtt]);
        }
        finalRes['uc_file_to_load'] = "$savePath/$fotoName";
      });
      finalRes['status'] = true;
      finalRes['uc_report'] = uc;
      finalRes['uc_report_att'] = ucAtt;
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future addTugas(
      {required File foto,
      required String caption,
      required int month,
      String? uc,
      String? ucAtt,
      required String ucSign,
      required String ucLecturer,
      required String ucReport,
      required String deviceId,
      Position? position}) async {
    Map finalRes = {};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    String local_uc;
    try {
      var uuid = const Uuid();
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      bool isNew = false;
      if (uc == null) {
        uc = "local_${uuid.v1()}_$userUc";
        local_uc = uc;
        isNew = true;
      } else {
        List<Map> res = await dbx.rawQuery(
            """ select local_uc from  tech_report_log where uc = ? limit 1 """,
            [uc]);
        if (res.isEmpty) {
          throw ("Tidak Bisa Melakukan Update Log Report Tidak Di Temukan");
        } else {
          local_uc = res[0]['local_uc'];
        }
        isNew = false;
      }
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String savePath = Path.join(appDocPath, REPORT_FOTO_FOLDER);
      Directory(savePath).createSync(recursive: true);
      String fotoExt = Path.extension(foto.path);
      dbx.transaction((db) async {
        mydb.transaction = db;
        if (isNew == true) {
          List checkOther = await db.rawQuery(
              """ select * from  tech_report_log where uc_report_list = ? and uc_sign = ? limit 1""",
              [ucReport, ucSign]);
          String? instName;
          int instStatus = 0;
          String? komentar;
          String? localFoto;
          String? foto;
          String? time;
          if (checkOther.isNotEmpty) {
            Map tmp = checkOther.first;
            instStatus = tmp['app_inst_status'];
            instName = tmp['app_inst_name'];
            komentar = tmp['app_inst_komentar'];
            localFoto = tmp['app_inst_local_foto'];
            foto = tmp['app_inst_foto'];
            time = tmp['app_inst_time'];
          }
          log("NEW REPORT LOG");
          var format = DateFormat('yyyy-MM-dd');
          DateTime currentTime = DateTime.now().toUtc();
          String currentTimeFormated = format.format(currentTime);
          await db.rawInsert(""" insert into tech_report_log (
          uc, local_uc, uc_sign, uc_report_list, month, 
          check_latitude, check_longitude, check_time, app_lect_status, 
          app_lect_uc, device_id, app_inst_status, 
          app_inst_name, app_inst_komentar, app_inst_local_foto, app_inst_foto, app_inst_time) 
          values (?,?,?,?,?,?,?,?,?,?,?, ?, ?,?,?,?,?)""", [
            uc,
            local_uc,
            ucSign,
            ucReport,
            month,
            position!.latitude,
            position.longitude,
            currentTimeFormated,
            0,
            ucLecturer,
            deviceId,
            instStatus,
            instName,
            komentar,
            localFoto,
            foto,
            time
          ]);
          await journalIt(
              db: db,
              tableName: "tech_report_log",
              actionType: "c",
              tableKey: local_uc);
        } else {
          var format = DateFormat('yyyy-MM-dd');
          DateTime currentTime = DateTime.now().toUtc();
          String currentTimeFormated = format.format(currentTime);
          await db.rawUpdate(""" 
          update tech_report_log set
          uc_sign = ?,
          uc_report_list = ?,
          month = ?,
          check_time = ?,
          device_id = ?
          where uc = ?
        """, [ucSign, ucReport, month, currentTimeFormated, deviceId, uc]);
          await journalIt(
              db: db,
              tableName: "tech_report_log",
              actionType: "u",
              tableKey: local_uc);
        }

        String fotoName = "${ucSign}_${uc}_report_$month$fotoExt";
        foto.copySync("$savePath/$fotoName");

        bool isAttNew = false;
        String local_ucAtt = "";
        if (ucAtt == null) {
          isAttNew = true;
          ucAtt = "local_${uuid.v1()}_$userUc";
          local_ucAtt = ucAtt!;
        } else {
          List<Map> res = await db.rawQuery(
              """ select * from tech_report_log_att where uc = ? """, [ucAtt]);
          if (res.isNotEmpty) {
            local_ucAtt = res[0]['local_uc'];
          } else {
            throw ("Cannot Find Current Log Att");
          }
        }
        if (isAttNew == true) {
          log("NEW ATT");
          await db.rawInsert(""" insert into tech_report_log_att 
              (uc, local_uc, uc_report_log, local_file, caption) 
              values (?,?,?,?,?) """, [ucAtt, ucAtt, uc, fotoName, caption]);
          await journalIt(
              db: db,
              tableName: "tech_report_log_att",
              actionType: "c",
              tableKey: local_ucAtt);
        } else {
          await db.rawUpdate("""
          update tech_report_log_att set
          uc_report_log = ?,
          local_file = ?,
          caption = ?
          where uc = ?
          """, [uc, foto.path, caption, ucAtt]);
          await journalIt(
              db: db,
              tableName: "tech_report_log_att",
              actionType: "u",
              tableKey: local_ucAtt);
        }
        finalRes['uc_file_to_load'] = "$savePath/$fotoName";
      });
      finalRes['status'] = true;
      finalRes['uc_report'] = uc;
      finalRes['uc_report_att'] = ucAtt;
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future saveApproval(
      {required File foto,
      required String ucReportList,
      required int month,
      required int approvalStatus,
      required String namaInstruktur,
      required String komentarInstruktur,
      required String ucSign}) async {
    Map finalRes = {};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String savePath = Path.join(appDocPath, APPROVAL_FOTO_FOLDER);
      Directory(savePath).createSync(recursive: true);
      String fotoExt = Path.extension(foto.path);
      dbx.transaction((db) async {
        mydb.transaction = db;
        // var uuid = const Uuid();
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;
        List<Map> res = await db.rawQuery(
            """ select * from tech_report_log where uc_report_list = ? and uc_sign = ? """,
            [ucReportList, ucSign]);
        if (res.isEmpty) {
          throw ("Report Log Cannot Be Found");
        }
        var format = DateFormat('yyyy-MM-dd');
        DateTime currentTime = DateTime.now().toUtc();
        String currentTimeFormated = format.format(currentTime);
        String fotoName = "${ucReportList}_${userUc}_report_$month$fotoExt";
        log("APPROVAL $approvalStatus");
        await db.rawUpdate(""" update tech_report_log set 
            app_inst_local_foto = ?, 
            app_inst_status = ?, 
            app_inst_time = ?, 
            app_inst_name = ?,
            app_inst_komentar = ? 
            where uc_report_list = ? and uc_sign = ? """, [
          fotoName,
          approvalStatus,
          currentTimeFormated,
          namaInstruktur,
          komentarInstruktur,
          ucReportList,
          ucSign
        ]);
        foto.copySync("$savePath/$fotoName");
        for (Map item in res) {
          await journalIt(
              tableName: "tech_report_log",
              actionType: "u",
              db: db,
              tableKey: item['local_uc']);
        }
      });
      finalRes['status'] = true;
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }
}
