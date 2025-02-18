import 'dart:developer';
import 'dart:io';
import 'package:mytrb/config/database/my_db.dart';
import 'package:path/path.dart' as Path;
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:mytrb/Helper/manual_con_check.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Models/type_vessel.dart';
import 'package:mytrb/Repository/chat_repository.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/constants/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class SignRepository extends Repository {
  Future<Map> getStatus({required seafarerCode}) async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map ret = {};
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // List<Map> resultSignAtt = await db.rawQuery("select * from tech_sign");
    // log("signRepository: check $resultSignAtt");

    log("signRepository: appPath $appDocPath");
    try {
      // List<Map> testSign = await db.rawQuery("select * from tech_sign_att");
      // log("signRepository: testSign $testSign");

      List<Map> resultSign = await db.rawQuery("""
SELECT
	tech_sign.uc AS signUc,* 
FROM
	tech_sign
	LEFT JOIN tech_type_vessel ON tech_sign.uc_type_vessel = tech_type_vessel.uc 
	LEFT JOIN tech_sign_att ON tech_sign.uc = tech_sign_att.uc_sign
  LEFT JOIN tech_instructor ON tech_sign.uc_lecturer = tech_instructor.uc  
WHERE
	seafarer_code = ?
	AND tech_sign.sign_on_date IS NOT NULL 
	AND tech_sign.sign_off_date IS NULL 
ORDER BY
	sign_on_date DESC, sign_on_stamp DESC 
	LIMIT 1""", [seafarerCode]);
      if (resultSign.isNotEmpty) {
        Map resSign = Map.from(resultSign.first);
        ret = {"status": true, "sign_uc": resSign["signUc"]};
        resSign.remove("uc");
        resSign.remove("signUc");
        resSign.remove("uc_sign");
        DateTime signOnDate = DateTime.parse(resSign["sign_on_date"]);
        var format = DateFormat.yMMMMd();
        resSign["sign_on_date_formated"] = format.format(signOnDate);
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String savePath = Path.join(
          appDocPath,
          "sign",
        );
        String signOnFoto = Path.join(savePath, resSign['local_att_sign_on']);
        resSign['sign_on_foto'] = signOnFoto;
        if (resSign['att_sign_on'] != null) {
          resSign['sign_on_foto_url'] = resSign['att_sign_on'];
        } else {
          resSign['sign_on_foto_url'] = null;
        }
        ret["signData"] = resSign;
      } else {
        ret = {"status": false, "sign_uc": ""};
      }
      log("signRepository: $ret");
    } finally {
      // log("signRepository: Closing DB");
      // await mydb.close();
    }

    return ret;
  }

  static Future<Map> getData(
      {required String localSignUc, bool allowModify = true}) async {
    Map finalResult = {"status": true};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      log("there is transaction");
      db = mydb.transaction!;
    } else {
      log("there is no transaction");
      db = await mydb.database;
      log("there is no transaction for sure");
    }
    try {
      // throw ("not found");
      // log("query start");
      String q = """
SELECT
	tech_sign.uc AS signUc,
  tech_sign.local_uc AS signUcLocal,
  tech_instructor.uc AS instructorUc,
  tech_instructor.full_name AS pembimbing,
  * 
FROM
	tech_sign
	LEFT JOIN tech_type_vessel ON tech_sign.uc_type_vessel = tech_type_vessel.uc 
	LEFT JOIN tech_sign_att ON tech_sign.uc = tech_sign_att.uc_sign
  LEFT JOIN tech_instructor ON tech_sign.uc_lecturer = tech_instructor.uc
WHERE
	tech_sign.local_uc = ?
	AND tech_sign.sign_on_date IS NOT NULL 
	AND tech_sign.sign_off_date IS NULL 
ORDER BY
	sign_on_date DESC, sign_on_stamp DESC 
	LIMIT 1""";

      String q2 = """
SELECT
	tech_sign.uc AS signUc,
  tech_sign.local_uc AS signUcLocal,
  tech_instructor.uc AS instructorUc,
  * 
FROM
	tech_sign
	LEFT JOIN tech_type_vessel ON tech_sign.uc_type_vessel = tech_type_vessel.uc 
	LEFT JOIN tech_sign_att ON tech_sign.uc = tech_sign_att.uc_sign
  LEFT JOIN tech_instructor ON tech_sign.uc_lecturer = tech_instructor.uc
WHERE
	tech_sign.local_uc = ?
	AND tech_sign.sign_on_date IS NOT NULL 
ORDER BY
	sign_on_date DESC, sign_on_stamp DESC 
	LIMIT 1""";

      String useQ = q;
      if (allowModify == false) {
        useQ = q2;
      }

      List<Map> resultSign = await db.rawQuery(useQ, [localSignUc]);
      // log("query end $localSignUc");
      if (resultSign.isEmpty) {
        throw ("not found");
      }
      // log("data ${resultSign.first}");
      Map res = Map.from(resultSign.first);
      res.remove("uc");
      res.remove("uc_sign");
      res.remove("id_number");
      DateTime signOnDate = DateTime.parse(res["sign_on_date"]);
      var format = DateFormat.yMMMMd();
      res["sign_on_date_formated"] = format.format(signOnDate);
      finalResult['data'] = res;
    } catch (e) {
      finalResult['status'] = false;
    }

    return finalResult;
  }

  static Future<Map> getDataFromUc({required String uc}) async {
    Map finalResult = {"status": true};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      log("there is transaction");
      db = mydb.transaction!;
    } else {
      log("there is no transaction");
      db = await mydb.database;
      log("there is no transaction for sure");
    }
    try {
      // throw ("not found");
      // log("query start");
      List<Map> resultSign = await db.rawQuery("""
SELECT
	tech_sign.uc AS signUc,
  tech_sign.local_uc AS signUcLocal,* 
FROM
	tech_sign
	LEFT JOIN tech_type_vessel ON tech_sign.uc_type_vessel = tech_type_vessel.uc 
	LEFT JOIN tech_sign_att ON tech_sign.uc = tech_sign_att.uc_sign
  LEFT JOIN tech_instructor ON tech_sign.uc_lecturer = tech_instructor.uc
WHERE
	tech_sign.uc = ?
	AND tech_sign.sign_on_date IS NOT NULL 
	AND tech_sign.sign_off_date IS NULL 
ORDER BY
	sign_on_date DESC 
	LIMIT 1""", [uc]);
      // log("query end $localSignUc");
      if (resultSign.isEmpty) {
        throw ("not found");
      }
      // log("data ${resultSign.first}");
      Map res = Map.from(resultSign.first);
      res.remove("uc");
      res.remove("uc_sign");
      DateTime signOnDate = DateTime.parse(res["sign_on_date"]);
      var format = DateFormat.yMMMMd();
      res["sign_on_date_formated"] = format.format(signOnDate);
      finalResult['data'] = res;
    } catch (e) {
      finalResult['status'] = false;
    }

    return finalResult;
  }

  Future getVesselType() async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    Map finalResult = {"status": true};
    try {
      List<Map> resultVessel = await db
          .rawQuery("select * from tech_type_vessel order by type_vessel asc");
      finalResult["status"] = true;
      List<type_vessel> result = [];
      for (var r in resultVessel) {
        type_vessel temp =
            type_vessel(uc: r['uc'], typeVessel: r['type_vessel']);
        result.add(temp);
      }
      finalResult['vessel'] = result;
    } catch (e) {
      finalResult['status'] = false;
    } finally {
      await mydb.close();
    }
    return finalResult;
  }

  Future doSignOff(
      {required String signUc,
      required Position pos,
      File? signOffImoFoto,
      File? signOffPelabuhanFoto,
      File? crewListFoto}) async {
    log("singRepository: signOFF Start");
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    log("INSTANCE db $db");
    try {
      await db.transaction((txn) async {
        mydb.transaction = txn;
        DateTime now = DateTime.now().toUtc();
        String signOffDate = DateFormat('yyyy-MM-dd', null).format(now);
        List<Map> signAtt = await txn.rawQuery(
            "select * from tech_sign_att where uc_sign = ? limit 1", [signUc]);
        List<Map> sign = await txn.rawQuery(
            "select local_uc, uc_lecturer from tech_sign where uc = ? limit 1",
            [signUc]);
        log("signRepository: sign $sign");
        if (signAtt.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          String? userUc = prefs.getString('userUc');
          Map resAtt = Map.from(signAtt.first);
          Map resSign = Map.from(sign.first);
          log("signRepository: res $resAtt");
          String attUc = resAtt["local_uc"];
          String preName = attUc;

          Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          String savePath = Path.join(appDocPath, "sign");
          Directory(savePath).createSync(recursive: true);
          String imoFotoExt = Path.extension(signOffImoFoto!.path);

          File signOffImoFotoNew =
              signOffImoFoto.copySync("$savePath/${preName}_imoOff$imoFotoExt");
          String signOffPelabuhanFotoExt =
              Path.extension(signOffPelabuhanFoto!.path);
          File signOffPelabuhanFotoNew = signOffPelabuhanFoto.copySync(
              "$savePath/${preName}_pelabuhan$signOffPelabuhanFotoExt");
          String crewListFotoExt = Path.extension(crewListFoto!.path);
          File crewListFotoNew = crewListFoto
              .copySync("$savePath/${preName}_crewListFotoOff$crewListFotoExt");
          await txn.rawUpdate("""
          update tech_sign_att set local_att_imo_off = ?, local_att_foto_pelabuhan = ?, local_att_crew_list_off = ? where local_uc = ?
          """, [
            "${preName}_imoOff$imoFotoExt",
            "${preName}_pelabuhan$signOffPelabuhanFotoExt",
            "${preName}_crewListFotoOff$crewListFotoExt",
            attUc
          ]);
          DateTime current = DateTime.now().toUtc();
          String signOnDbFormat =
              DateFormat('yyyy-MM-dd', null).format(current);
          await txn.rawUpdate("""
          update tech_sign set sign_off_date = ?, sign_off_latitude = ?, sign_off_longitude = ? where uc = ?
          """, [signOnDbFormat, pos.latitude, pos.longitude, signUc]);

          await super.journalIt(
              tableName: "tech_sign_att",
              actionType: "u",
              tableKey: attUc,
              db: txn);

          await super.journalIt(
              tableName: "tech_sign",
              actionType: "u",
              tableKey: resSign['local_uc'],
              db: txn);
          bool conStatus = await ConnectionTest.check();
          if (conStatus == true) {
            await ChatRepository.leaveLecturerGroup(
                ucLecturer: resSign['uc_lecturer'], db: txn);
          }
        } else {
          throw ("signRepository: att not found");
        }
      });
    } finally {
      mydb.transaction = null;
      // log("singRepository: signOFF done Closing DB");
      // await db.close();
    }

    log("signRepository: signOFF done all");
  }

  Future doSignOn(
      {String? signOnDate,
      String? seafarerCode,
      String? ucTypeVessel,
      String? vesselName,
      String? companyName,
      String? imoNumber,
      String? mmsiNumber,
      String? ucLecturer,
      double? signOnLat,
      double? signOnLon,
      File? signOnFoto,
      File? mutasiOnFoto,
      File? imoFoto,
      File? crewListFoto,
      File? bukuPelautFoto}) async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    var uuid = const Uuid();
    bool finalResult = false;
    try {
      await db.transaction((txn) async {
        mydb.transaction = txn;
        final prefs = await SharedPreferences.getInstance();
        String? userUc = prefs.getString('userUc');
        String localUc = "local_${uuid.v1()}_$userUc";
        String localUcAtt = "local_${uuid.v1()}_$userUc";
        log("signRepository: localUc $localUc");
        var format = DateFormat('y-MM-dd HH:mm:ss');
        DateTime currentTime = DateTime.now().toUtc();
        String currentTimeFormated = format.format(currentTime);
        await txn.rawInsert(
            "INSERT INTO tech_sign VALUES (?,?,?,?,?,?,?,?,?,?,?,null,null,null,null,?,?)",
            [
              localUc,
              localUc,
              seafarerCode,
              ucTypeVessel,
              vesselName,
              companyName,
              imoNumber,
              mmsiNumber,
              signOnDate,
              signOnLat,
              signOnLon,
              ucLecturer,
              currentTimeFormated
            ]);
        await super.journalIt(
            tableName: "tech_sign",
            actionType: "c",
            tableKey: localUc,
            db: txn);
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String savePath = Path.join(appDocPath, SIGN_IMAGE_FOLDER);
        Directory(savePath).createSync(recursive: true);
        String signOnFotoExt = Path.extension(signOnFoto!.path);
        File signOnFotoNew =
            signOnFoto.copySync("$savePath/${localUcAtt}_signOn$signOnFotoExt");
        String mutasiOnFotoExt = Path.extension(mutasiOnFoto!.path);
        File mutasiOnFotoNew = mutasiOnFoto
            .copySync("$savePath/${localUcAtt}_mutasiOn$mutasiOnFotoExt");
        String imoFotoExt = Path.extension(imoFoto!.path);
        File imoFotoNew =
            imoFoto.copySync("$savePath/${localUcAtt}_imoFoto$imoFotoExt");
        String crewListFotoExt = Path.extension(crewListFoto!.path);
        File crewListFotoNew = crewListFoto
            .copySync("$savePath/${localUcAtt}_crewListFoto$crewListFotoExt");
        String bukuPelautFotoExt = Path.extension(bukuPelautFoto!.path);
        File bukuPelautFotoNew = bukuPelautFoto.copySync(
            "$savePath/${localUcAtt}_bukuPelautFoto$bukuPelautFotoExt");
        await txn.rawInsert(
            "INSERT INTO tech_sign_att (uc, local_uc, uc_sign, local_att_sign_on, local_att_mutasi_on, local_att_imo_on, local_att_crew_list_on, local_att_buku_pelaut_on) VALUES (?,?,?,?,?,?,?,?)",
            [
              localUcAtt,
              localUcAtt,
              localUc,
              "${localUcAtt}_signOn$signOnFotoExt",
              "${localUcAtt}_mutasiOn$mutasiOnFotoExt",
              "${localUcAtt}_imoFoto$imoFotoExt",
              "${localUcAtt}_crewListFoto$crewListFotoExt",
              "${localUcAtt}_bukuPelautFoto$bukuPelautFotoExt"
            ]);
        await super.journalIt(
            tableName: "tech_sign_att",
            actionType: "c",
            tableKey: localUcAtt,
            db: txn);
        log("signRepository: try joining group $ucLecturer");
        bool conStatus = await ConnectionTest.check();
        if (conStatus == true) {
          Map joinStatus = await ChatRepository.joinLecturerGroup(
              uc_chat_user: userUc!, uc_lecturer: ucLecturer!, db: txn);
          log("signRepository: joinStatus $joinStatus");
        }
      });
      finalResult = true;
    } finally {
      mydb.transaction = null;
    }
    return finalResult;
  }
}
