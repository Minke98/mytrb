import 'dart:developer';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/utils/custom_error.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

class LogBookRepository extends Repository {
  static Future<String> logbookStatus({required int status}) async {
    Map<int, String> statusString = {0: "-", 1: "Diterima", 2: "Revisi"};
    if (statusString.containsKey(status)) {
      return statusString[status]!;
    } else {
      return "unknown";
    }
  }

  Future loadOne({required String uc}) async {
    Map ret = {"status": true};
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        List<Map> findLog = await dbx.rawQuery(
            """ select * from tech_logbook where local_uc = ? limit 1""", [uc]);
        if (findLog.isEmpty) {
          throw CustomException("Not Found");
        }
        Map logData = Map.from(findLog.first);
        DateTime parsed = DateFormat('y-M-d').parse(logData['log_date']);
        logData['date_parsed'] = parsed;
        var format = DateFormat('d MMMM y');
        logData['date_formated'] = format.format(parsed);
        logData['status_formated'] =
            await logbookStatus(status: logData['app_inst_status']);
        // Directory appDocDir = await getApplicationDocumentsDirectory();
        // String appDocPath = appDocDir.path;
        // String localImage = Path.join(
        //     appDocPath, LOG_APPROVAL_FOTO_FOLDER, logData['app_inst_photo']);
        // bool imageExist = await File(localImage).exists();
        // if (imageExist == true) {
        //   logData['app_inst_photo'] = null;
        //   logData['app_inst_photo_full'] = null;
        // } else {
        //   logData['app_inst_photo_full'] = localImage;
        // }
        ret['data'] = logData;
      });
    } on CustomException catch (e) {
      ret['status'] = false;
      ret['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return ret;
  }

  Future load({String sort = "ASC"}) async {
    Map ret = {"status": true};
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        Map userData = await UserRepository.getLocalUser();
        if (userData['status'] == false && userData['data']['sign'] == false) {
          throw CustomException("not signed!");
        }
        userData = userData['data'];
        String signUc = userData['sign_uc'];
        List<Map> findLogBook = await dbx.rawQuery(
            """ select * from tech_logbook where uc_sign = ? order by log_date $sort """,
            [signUc]);
        if (findLogBook.isNotEmpty) {
          List<Map> logBookList = [];
          var format = DateFormat("d MMMM y");
          for (Map item in findLogBook) {
            log("Item $item");
            Map tmp = Map.from(item);
            // DateTime parsed = DateTime.parse(item['log_date'] + " 00:00:00Z");
            DateTime parsed = DateFormat('yyyy-MM-dd').parse(item['log_date']);
            tmp['log_date_formated'] = format.format(parsed);
            tmp['status_string'] =
                await logbookStatus(status: tmp['app_inst_status']);
            log("TMP $tmp");
            logBookList.add(tmp);
          }
          ret['data'] = logBookList;
        } else {
          ret['data'] = [];
        }
      });
    }
    // catch (e) {
    //   ret['status'] = false;
    //   ret['message'] = e.toString();
    // }
    finally {
      mydb.transaction = null;
    }
    return ret;
  }

  Future saveApproval(
      {required String uc,
      required File foto,
      required String namaInstruktur,
      required int status,
      required String komentar}) async {
    Map ret = {"status": true};
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      await db.transaction((dbx) async {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String savePath = Path.join(appDocPath, LOG_APPROVAL_FOTO_FOLDER);
        Directory(savePath).createSync(recursive: true);
        String fotoExt = Path.extension(foto.path);
        mydb.transaction = dbx;
        log("finding Log");
        List<Map> findLog = await dbx.rawQuery(
            """ select * from tech_logbook where local_uc = ? limit 1""", [uc]);
        log("findLog ${findLog.isEmpty}");
        if (findLog.isEmpty) {
          throw CustomException("Unable To Find Log");
        }
        Map logData = findLog.first;
        String signUc = logData['uc_sign'];
        String fotoName = "";
        String? fotoRemote;
        if (foto.path == "assets/pub/images/noimage.jpg") {
          fotoName = logData['app_inst_photo'];
          fotoRemote = logData['app_inst_photo_remote'];
        } else {
          fotoName = "${uc}_${signUc}_foto$fotoExt";
          fotoRemote = null;
        }
        DateTime currentTime = DateTime.now().toUtc();
        var format = DateFormat('yyyy-MM-dd HH:mm:ss');
        String currentTimeFormated = format.format(currentTime);
        // String deviceId = await getUniqueDeviceId();
        await dbx.rawUpdate(""" update tech_logbook 
            set app_inst_status = ?, 
            app_inst_name = ?, 
            app_inst_comment = ?,
            app_inst_photo = ?,
            app_inst_photo_remote = ?,
            app_inst_time = ?
            where local_uc = ? """, [
          status,
          namaInstruktur,
          komentar,
          fotoName,
          fotoRemote,
          currentTimeFormated,
          uc
        ]);
        if (foto.path != "assets/pub/images/noimage.jpg") {
          foto.copySync("$savePath/$fotoName");
        }
        await journalIt(
            tableName: "tech_logbook", actionType: "u", db: dbx, tableKey: uc);
      });
    } on CustomException catch (e) {
      ret['message'] = e.toString();
      ret['status'] = false;
    } finally {
      mydb.transaction = null;
    }
    log("finalRet $ret");
    return ret;
  }

  Future save(
      {required String date,
      required String keterangan,
      required Position pos,
      String? uc}) async {
    Map ret = {"status": true};
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    try {
      await db.transaction((dbx) async {
        String deviceId = await getUniqueDeviceId();
        String doAction = "create";
        mydb.transaction = dbx;
        Map userData = await UserRepository.getLocalUser();
        if (userData['status'] == false && userData['data']['sign'] == false) {
          throw CustomException("not signed!");
        }
        userData = userData['data'];
        log("userData $userData");
        String userUc = userData['uc_tech_user'];
        var uuid = const Uuid();
        String localUc = "local_${uuid.v1()}_$userUc";
        String signUc = userData['sign_uc'];
        if (uc != null) {
          doAction = "update";
          localUc = uc;
        }
        if (doAction == "create") {
          await dbx.rawInsert("""insert into tech_logbook values (?,?,?,?,
          ?,?,?,0,
          null,null,null,null,
          null,?)""", [
            localUc,
            localUc,
            signUc,
            date,
            keterangan,
            pos.latitude,
            pos.longitude,
            deviceId
          ]);
          await journalIt(
              db: dbx,
              tableName: "tech_logbook",
              actionType: "c",
              tableKey: localUc);
        } else {
          await dbx.rawUpdate(""" update tech_logbook 
              set log_date = ?, 
              log_activity = ?, 
              check_latitude = ?, 
              check_longitude = ?, 
              app_inst_status = 0,
              app_inst_name = null,
              app_inst_comment = null,
              app_inst_photo = null,
              app_inst_photo_remote = null,
              app_inst_time = null
               where local_uc = ? """,
              [date, keterangan, pos.latitude, pos.longitude, uc]);
          await journalIt(
              db: dbx,
              tableName: "tech_logbook",
              actionType: "u",
              tableKey: localUc);
        }
      });
    } on CustomException catch (e) {
      ret['status'] = false;
      ret['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return ret;
  }
}
