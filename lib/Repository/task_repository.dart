import 'dart:developer';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mytrb/Helper/get_device_id.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/sign_repository.dart';
import 'package:mytrb/Repository/user_repository.dart';
import 'package:path/path.dart' as Path;
import 'package:mytrb/constants/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class TaskRepository extends Repository {
  Future getFunction({required String seafarerCode}) async {
    Map finalRes = {};
    try {
      MyDatabase mydb = MyDatabase.instance;
      var db;
      if (mydb.transaction != null) {
        db = mydb.transaction!;
      } else {
        db = await mydb.database;
      }
      List<Map> resTrb = await db.rawQuery(
          """ select * from tech_trb_participant where seafarer_code = ? limit 1""",
          [seafarerCode]);
      if (resTrb.isEmpty) {
        throw ("Cannot Find Schedule");
      }
      Map trb = resTrb.first;
      String ucSchedule = trb['uc_trb_schedule'];
      List<Map> resSchedule = await db.rawQuery(
          """ select * from tech_trb_schedule where uc = ? limit 1""",
          [ucSchedule]);
      if (resSchedule.isEmpty) {
        throw ("Cannot Find Schedule [2]");
      }
      Map schedule = resSchedule.first;
      String ucLevel = schedule['uc_level'];
      List<Map> resFunction = await db.rawQuery(
          """ select * from tech_function where uc_level = ? """, [ucLevel]);
      if (resFunction.isEmpty) {
        throw ("Cannot Find Function [2]");
      }
      finalRes['status'] = true;
      finalRes['functions'] = resFunction;
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    }
  }

  Future getListCompetency() async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    Map resUser = await UserRepository.getLocalUser();
    if (resUser['status'] == false) {
      return null;
    }
    String ucLevel = resUser['data']['uc_level'];
    List<Map> resCompetency = await db.rawQuery(
        """ SELECT competency.`uc`, competency.`label`, COUNT(subcompetency.`sub_label`) as subtotal_competency FROM `tech_competency` as competency INNER JOIN `tech_function` as functiontask ON competency.`uc_function` = functiontask.`uc` INNER JOIN `tech_sub_competency` as subcompetency ON subcompetency.`uc_competency` = competency.`uc` WHERE functiontask.`uc_level` = ? GROUP BY competency.`uc` """,
        [ucLevel]);
    return resCompetency;
  }

  Future getSubListCompetency({required String ucCompetency}) async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    log("ucComp $ucCompetency");
    List<Map> resSubCompetency = await db.rawQuery(""" SELECT
	subcompetency.uc,
	subcompetency.sub_label,
	COUNT( task.task_name ) AS total_task 
FROM
	tech_sub_competency AS subcompetency
	INNER JOIN tech_competency AS competency ON subcompetency.uc_competency = competency.uc
	INNER JOIN tech_task AS task ON task.uc_sub_competency = subcompetency.uc 
WHERE
	competency.uc = ?
GROUP BY
	subcompetency.uc """, [ucCompetency]);
    return resSubCompetency;
  }

  Future getTaskList({required String ucSubCompetency, String? uc}) async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    Map userData = await UserRepository.getLocalUser(useAlternate: true);
    if (userData['status'] == false) {
      throw ("Cannot Find User Data");
    }
    if (userData['data']['sign'] == false) {
      throw ("User Not Sign");
    }
    String ucSign = userData['data']['sign_uc'];
    List<Map> tmpResTaskList = await db.rawQuery(
        // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
        """ SELECT
        tt.*,
        CASE
            WHEN tc.uc IS NULL THEN 0 ELSE 1 
        END AS isChecked,
        CASE
            WHEN tc.app_inst_status IS NULL THEN 0 ELSE tc.app_inst_status
        END AS status,
        CASE
            WHEN tc.app_lect_status IS NULL THEN 0 ELSE tc.app_lect_status
        END AS lect_status,
        tc.app_inst_time as instTime,
        tc.app_lect_time as lectTime,
        tc.notes AS note,
        tc.att_url AS url
      FROM
        tech_task AS tt
        LEFT JOIN tech_task_check AS tc 
        ON tc.uc_task = tt.uc AND tc.uc_sign = ?
      WHERE
        tt.uc_sub_competency = ? """,
        [ucSign, ucSubCompetency]);
    List<Map> resTaskList = [];
    for (Map item in tmpResTaskList) {
      Map tmp = Map.from(item);
      // var formatParse = DateFormat('y-M-d H:m:s');
      var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
      if (tmp['instTime'] != null) {
        DateTime instTime = formatParse.parse(tmp['instTime']);
        var format = DateFormat.yMMMMd().addPattern("H:m");
        tmp["instTime"] = format.format(instTime);
      }
      if (tmp['lectTime'] != null) {
        DateTime lectTime = formatParse.parse(tmp['lectTime']);
        var format = DateFormat.yMMMMd().addPattern("H:m");
        tmp["lectTime"] = format.format(lectTime);
      }
      String ucTask = tmp['uc'];
      List<Map> taskCheckData = await db.rawQuery(
          "SELECT app_inst_local_photo, app_inst_comment, app_inst_name, app_inst_photo, local_photo, att_photo FROM tech_task_check WHERE uc_task = ? AND uc_sign = ?",
          [ucTask, ucSign]);

      if (taskCheckData.isNotEmpty) {
        tmp["app_inst_local_photo"] = taskCheckData[0]["app_inst_local_photo"];
        tmp["app_inst_comment"] = taskCheckData[0]["app_inst_comment"];
        tmp["app_inst_name"] = taskCheckData[0]["app_inst_name"];
        tmp["app_inst_photo"] = taskCheckData[0]["app_inst_photo"];
        tmp["local_photo"] = taskCheckData[0]["local_photo"];
        tmp["att_photo"] = taskCheckData[0]["att_photo"];
      } else {
        tmp["app_inst_local_photo"] = null;
        tmp["app_inst_comment"] = null;
        tmp["app_inst_name"] = null;
        tmp["app_inst_photo"] = null;
        tmp["local_photo"] = null;
        tmp["att_photo"] = null;
      }
      resTaskList.add(tmp);
    }
    log("taskRepo $resTaskList | $ucSign | $ucSubCompetency");
    return resTaskList;
  }

  Future countCheck({required String ucSubCompetency, String? uc}) async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    Map userData = await UserRepository.getLocalUser();
    if (userData['status'] == false) {
      throw ("Cannot Find User Data");
    }
    if (userData['data']['sign'] == false) {
      throw ("User Not Sign");
    }
    String ucSign = userData['data']['sign_uc'];
    List<Map> resTaskList = await db.rawQuery(
        // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
        """ SELECT            
          CASE
              WHEN tc.uc IS NULL THEN
              0 ELSE 1 
            END AS isChecked
          FROM
            tech_task AS tt
            LEFT JOIN tech_task_check AS tc 
            on tc.uc_task = tt.uc and tc.uc_sign = ?
          WHERE
            tt.uc_sub_competency = ? and isChecked = 1""",
        [ucSign, ucSubCompetency]);

    log("taskRepo checked count ${resTaskList.length}");
    return resTaskList.length;
    // return resTaskList;
  }

  // Future<Map> saveLampiran({
  //   File? foto,
  //   required String ucTask,
  // }) async {
  //   Map finalres = {};
  //   MyDatabase mydb = MyDatabase.instance;
  //   var db;
  //   try {
  //     Directory fotoDir = await getApplicationDocumentsDirectory();
  //     String fotoDirPath = fotoDir.path;
  //     String fotoPath = Path.join(fotoDirPath, TASK_APPROVAL_FOTO_FOLDER);
  //     Directory(fotoPath).createSync(recursive: true);
  //     String fotoExt = foto != null ? Path.extension(foto.path) : "";
  //     if (mydb.transaction != null) {
  //       db = mydb.transaction!;
  //     } else {
  //       db = await mydb.database;
  //     }

  //     await db.transaction((dbx) async {
  //       mydb.transaction = dbx;
  //       Map userData = await UserRepository.getLocalUser();
  //       print("taskRepo $userData");

  //       if (userData['status'] == false) {
  //         throw ("Cannot Find User Data");
  //       }

  //       if (userData['data']['sign'] == false) {
  //         throw ("User Not Sign");
  //       }

  //       String ucSign = userData['data']['sign_uc'];
  //       String ucSignLocal = userData['data']['sign_uc_local'];

  //       var uuid = const Uuid();
  //       String? uc;
  //       String? ucLokal;
  //       List<Map> taskChecklist = await dbx.rawQuery(
  //         "select * from tech_task_check where uc_task = ? and uc_sign = ? limit 1 ",
  //         [ucTask, ucSign],
  //       );

  //       bool newCheckList = false;

  //       if (taskChecklist.isEmpty) {
  //         uc = "${ucSignLocal}_${uuid.v1()}_$ucTask";
  //         ucLokal = uc;
  //         newCheckList = true;
  //       } else {
  //         Map taskCheckListData = taskChecklist.first;
  //         uc = taskCheckListData['uc'];
  //         ucLokal = taskCheckListData['local_uc'];
  //         newCheckList = false;
  //       }

  //       String deviceId = await getUniqueDeviceId();

  //       String? fotoName;
  //       if (foto != null) {
  //         fotoName = "${ucLokal}_foto$fotoExt";
  //         String fotoDestPath = Path.join(fotoPath, fotoName);
  //         final compressedImage = await FlutterImageCompress.compressWithFile(
  //           foto.path,
  //           minHeight: 800,
  //           minWidth: 800,
  //           quality: 70,
  //         );

  //         if (compressedImage != null) {
  //           File(fotoDestPath).writeAsBytesSync(compressedImage);
  //         }
  //       }

  //       if (newCheckList) {
  //         await dbx.rawInsert(
  //           """insert into tech_task_check (uc, local_uc, uc_sign, uc_task, device_id, local_photo) values (?,?,?,?,?,?,?)""",
  //           [uc, ucLokal, ucSign, ucTask, deviceId, fotoName],
  //         );
  //         journalIt(
  //           tableName: "tech_task_check",
  //           actionType: "c",
  //           tableKey: ucLokal,
  //           db: dbx,
  //         );
  //       } else {
  //         await dbx.rawUpdate(
  //           """ update tech_task_check set
  //         uc_sign = ?,
  //         uc_task = ?,
  //         device_id = ?,
  //         local_photo = ?
  //         where local_uc = ?
  //         """,
  //           [ucSign, ucTask, deviceId, fotoName, ucLokal],
  //         );
  //         journalIt(
  //           tableName: "tech_task_check",
  //           actionType: "u",
  //           tableKey: ucLokal,
  //           db: dbx,
  //         );
  //       }

  //       List<Map> tmpResTaskList = await dbx.rawQuery(
  //         """ SELECT
  //       tt.*,
  //       CASE
  //         WHEN tc.uc IS NULL THEN 0 ELSE 1
  //       END AS isChecked,
  //       CASE
  //         WHEN tc.app_inst_status IS NULL THEN 0 ELSE tc.app_inst_status
  //       END AS status,
  //       CASE
  //         WHEN tc.app_lect_status IS NULL THEN 0 ELSE tc.app_lect_status
  //       END AS lect_status,
  //       tc.app_inst_time as instTime,
  //       tc.app_lect_time as lectTime,
  //       tc.notes AS note,
  //       tc.att_photo,
  //       tc.local_photo AS photo
  //     FROM
  //       tech_task AS tt
  //       LEFT JOIN tech_task_check AS tc
  //       ON tc.uc_task = tt.uc AND tc.uc_sign = ?
  //     WHERE
  //       tt.uc = ? """,
  //         [ucSign, ucTask],
  //       );

  //       List<Map> resTaskList = [];
  //       for (Map item in tmpResTaskList) {
  //         Map tmp = Map.from(item);
  //         var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
  //         if (tmp['instTime'] != null) {
  //           DateTime instTime = formatParse.parse(tmp['instTime']);
  //           var format = DateFormat.yMMMMd().addPattern("H:m");
  //           tmp["instTime"] = format.format(instTime);
  //         }
  //         if (tmp['lectTime'] != null) {
  //           DateTime lectTime = formatParse.parse(tmp['lectTime']);
  //           var format = DateFormat.yMMMMd().addPattern("H:m");
  //           tmp["lectTime"] = format.format(lectTime);
  //         }
  //         if (tmp["photo"] != null) {
  //           finalres['status'] = true;
  //         } else {
  //           finalres['status'] = false;
  //         }
  //         resTaskList.add(tmp);
  //       }

  //       Map? resTask;
  //       if (resTaskList.isNotEmpty) {
  //         resTask = resTaskList.first;
  //       }

  //       print("taskRepo approve $resTask");

  //       finalres['data'] = resTask;
  //     });
  //   } catch (e) {
  //     print("ERROR $e");
  //     finalres['status'] = false;
  //     finalres['message'] = e.toString();
  //   } finally {
  //     mydb.transaction = null;
  //   }
  //   return finalres;
  // }

  Future saveLampiran({required File foto, required String taskUc}) async {
    Map finalres = {};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String savePath = Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER);
      Directory(savePath).createSync(recursive: true);
      String fotoExt = Path.extension(foto.path);
      await db.transaction((dbx) async {
        mydb.transaction = dbx;

        Map userData = await UserRepository.getLocalUser();
        log("taskRepo $userData");
        if (userData['status'] == false) {
          throw ("Cannot Find User Data");
        }
        if (userData['data']['sign'] == false) {
          throw ("User Not Sign");
        }
        String ucSign = userData['data']['sign_uc'];
        String ucSignLocal = userData['data']['sign_uc_local'];

        var uuid = const Uuid();
        String? uc;
        String? ucLokal;
        List<Map> taskChecklist = await dbx.rawQuery(
            "select * from tech_task_check where uc_task = ? and uc_sign = ? limit 1 ",
            [taskUc, ucSign]);
        bool newCheckList = false;
        if (taskChecklist.isEmpty) {
          uc = "${ucSignLocal}_${uuid.v1()}_$taskUc";
          ucLokal = uc;
          newCheckList = true;
        } else {
          Map taskCheckListData = taskChecklist.first;
          uc = taskCheckListData['uc'];
          ucLokal = taskCheckListData['local_uc'];
          newCheckList = false;
        }

        String deviceId = await getUniqueDeviceId();
        String fotoName = "${ucLokal}_lampiran$fotoExt";
        foto.copySync("$savePath/$fotoName");

        if (newCheckList) {
          await dbx.rawInsert(
              """insert into tech_task_check (uc, local_uc, uc_sign, uc_task, local_photo, device_id) values (?,?,?,?,?,?)""",
              [uc, ucLokal, ucSign, taskUc, fotoName, deviceId]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "c",
              tableKey: ucLokal,
              db: dbx);
        } else {
          await dbx.rawUpdate(""" update tech_task_check set 
              uc_sign = ?, 
              uc_task = ?,
              local_photo = ?,
              device_id = ?
              where local_uc = ?
              """, [ucSign, taskUc, fotoName, deviceId, ucLokal]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "u",
              tableKey: ucLokal,
              db: dbx);
        }

        List<Map> tmpResTaskList = await dbx.rawQuery(
            // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
            """ SELECT
            tt.*,
          CASE
              WHEN tc.uc IS NULL THEN
              0 ELSE 1 
            END AS isChecked,
          CASE
              WHEN tc.app_inst_status IS NULL THEN
              0 ELSE tc.app_inst_status
            END AS status,
          tc.app_inst_time as instTime,
          tc.app_lect_time as lectTime,
          tc.notes AS note
          FROM
            tech_task AS tt
            LEFT JOIN tech_task_check AS tc 
            on tc.uc_task = tt.uc and tc.uc_sign = ?
          WHERE
            tt.uc = ? """,
            [ucSign, taskUc]);
        List<Map> resTaskList = [];
        for (Map item in tmpResTaskList) {
          Map tmp = Map.from(item);
          var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
          if (tmp['instTime'] != null) {
            DateTime instTime = formatParse.parse(tmp['instTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["instTime"] = format.format(instTime);
          }
          if (tmp['lectTime'] != null) {
            DateTime lectTime = formatParse.parse(tmp['lectTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["lectTime"] = format.format(lectTime);
          }
          tmp["local_photo"] = fotoName;
          resTaskList.add(tmp);
        }
        // List<Map> resTaskList = await dbx.rawQuery(""" SELECT
        //     tt.*,
        //   CASE
        //       WHEN tc.uc IS NULL THEN
        //       0 ELSE 1
        //     END AS isChecked,
        //   CASE
        //       WHEN tc.app_inst_status IS NULL THEN
        //       0 ELSE tc.app_inst_status
        //     END AS status,
        //     tc.app_inst_time as instTime,
        //   FROM
        //     tech_task AS tt
        //     LEFT JOIN tech_task_check AS tc
        //     on tc.uc_task = tt.uc and tc.uc_sign = ?
        //   WHERE
        //     tt.uc = ?""", [ucSign, taskUc]);
        Map? resTask;
        if (resTaskList.isNotEmpty) {
          resTask = resTaskList.first;
        }
        log("taskRepo lampiran $resTask");

        finalres['status'] = true;
        finalres['data'] = resTask;
      });
    } catch (e) {
      log("ERROR $e");
      finalres['status'] = false;
      finalres['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalres;
  }

  Future saveApproval(
      {String? taskCheckUc,
      required String taskUc,
      required String namaInstruktur,
      required int statusApproval,
      required String komentar,
      required File instFoto,
      required Position pos}) async {
    Map finalres = {};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String savePath = Path.join(appDocPath, TASK_APPROVAL_FOTO_FOLDER);
      Directory(savePath).createSync(recursive: true);
      String fotoExt = Path.extension(instFoto.path);
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        // Map pos = await Location.getLocation();
        // if (pos['staus'] == false) {
        //   throw (pos['message']);
        // }
        // Position position = pos['position'];
        Position position = pos;

        Map userData = await UserRepository.getLocalUser();
        log("taskRepo $userData");
        if (userData['status'] == false) {
          throw ("Cannot Find User Data");
        }
        if (userData['data']['sign'] == false) {
          throw ("User Not Sign");
        }
        String ucSign = userData['data']['sign_uc'];
        String ucSignLocal = userData['data']['sign_uc_local'];

        var uuid = const Uuid();
        String? uc;
        String? ucLokal;
        List<Map> taskChecklist = await dbx.rawQuery(
            "select * from tech_task_check where uc_task = ? and uc_sign = ? limit 1 ",
            [taskUc, ucSign]);
        bool newCheckList = false;
        if (taskChecklist.isEmpty) {
          // uc =
          //     "local_${uuid.v1()}_${taskUc}_${userData['data']['uc_tech_user']}";
          uc = "${ucSignLocal}_${uuid.v1()}_$taskUc";
          ucLokal = uc;
          newCheckList = true;
        } else {
          Map taskCheckListData = taskChecklist.first;
          uc = taskCheckListData['uc'];
          ucLokal = taskCheckListData['local_uc'];
          newCheckList = false;
        }

        String deviceId = await getUniqueDeviceId();

        var format = DateFormat('yyyy-MM-dd HH:mm:ss', 'id_ID');
        DateTime currentTime = DateTime.now();
        String currentTimeFormated = format.format(
            currentTime); /* 
        String hour = currentTime.hour.toString().padLeft(2, '0');
        String minute = currentTime.minute.toString().padLeft(2, '0'); */
        String fotoName = "${ucLokal}_approval$fotoExt";
        instFoto.copySync("$savePath/$fotoName");

        if (newCheckList) {
          await dbx.rawInsert(
              """insert into tech_task_check (uc, local_uc, uc_sign, uc_task,check_latitude, check_longitude, app_inst_time,
              app_inst_status, app_inst_name, app_inst_comment, app_inst_local_photo, app_lect_status, device_id) values (?,?,?,?,?,?,?,?,?,?,?,?,?)""",
              [
                uc,
                ucLokal,
                ucSign,
                taskUc,
                position.latitude,
                position.longitude,
                currentTimeFormated,
                statusApproval,
                namaInstruktur,
                komentar,
                fotoName,
                0,
                deviceId
              ]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "c",
              tableKey: ucLokal,
              db: dbx);
        } else {
          await dbx.rawUpdate(""" update tech_task_check set 
              uc_sign = ?, 
              uc_task = ?, 
              check_latitude = ?,
              check_longitude = ?,
              app_inst_time = ?,
              app_inst_status = ?,
              app_inst_name = ?,
              app_inst_comment = ?,
              app_inst_local_photo = ?,
              app_lect_status = ?,
              device_id = ?
              where local_uc = ?
              """, [
            ucSign,
            taskUc,
            position.latitude,
            position.longitude,
            currentTimeFormated,
            statusApproval,
            namaInstruktur,
            komentar,
            fotoName,
            0,
            deviceId,
            ucLokal
          ]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "u",
              tableKey: ucLokal,
              db: dbx);
        }

        List<Map> tmpResTaskList = await dbx.rawQuery(
            // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
            """ SELECT
            tt.*,
          CASE
              WHEN tc.uc IS NULL THEN
              0 ELSE 1 
            END AS isChecked,
          CASE
              WHEN tc.app_inst_status IS NULL THEN
              0 ELSE tc.app_inst_status
            END AS status,
          tc.app_inst_time as instTime,
          tc.app_lect_time as lectTime,
          tc.notes AS note
          FROM
            tech_task AS tt
            LEFT JOIN tech_task_check AS tc 
            on tc.uc_task = tt.uc and tc.uc_sign = ?
          WHERE
            tt.uc = ? """,
            [ucSign, taskUc]);
        List<Map> resTaskList = [];
        for (Map item in tmpResTaskList) {
          Map tmp = Map.from(item);
          var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
          if (tmp['instTime'] != null) {
            DateTime instTime = formatParse.parse(tmp['instTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["instTime"] = format.format(instTime);
          }
          if (tmp['lectTime'] != null) {
            DateTime lectTime = formatParse.parse(tmp['lectTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["lectTime"] = format.format(lectTime);
          }
          tmp["app_inst_local_photo"] = fotoName;
          resTaskList.add(tmp);
        }
        // List<Map> resTaskList = await dbx.rawQuery(""" SELECT
        //     tt.*,
        //   CASE
        //       WHEN tc.uc IS NULL THEN
        //       0 ELSE 1
        //     END AS isChecked,
        //   CASE
        //       WHEN tc.app_inst_status IS NULL THEN
        //       0 ELSE tc.app_inst_status
        //     END AS status,
        //     tc.app_inst_time as instTime,
        //   FROM
        //     tech_task AS tt
        //     LEFT JOIN tech_task_check AS tc
        //     on tc.uc_task = tt.uc and tc.uc_sign = ?
        //   WHERE
        //     tt.uc = ?""", [ucSign, taskUc]);
        Map? resTask;
        if (resTaskList.isNotEmpty) {
          resTask = resTaskList.first;
        }
        log("taskRepo approve $resTask");

        finalres['status'] = true;
        finalres['data'] = resTask;
      });
    } catch (e) {
      log("ERROR $e");
      finalres['status'] = false;
      finalres['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalres;
  }

  Future toggle({required String taskUc}) async {
    Map finalres = {};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    try {
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        Map userData = await UserRepository.getLocalUser(useAlternate: false);
        log("taskRepo $userData");
        if (userData['status'] == false) {
          throw ("Cannot Find User Data");
        }
        if (userData['data']['sign'] == false) {
          throw ("User Not Sign");
        }
        String ucSign = userData['data']['sign_uc'];
        String ucSignLocal = userData['data']['sign_uc_local'];
        Map signData = await SignRepository.getData(
            localSignUc: ucSignLocal, allowModify: false);
        if (signData['status'] == false) {
          throw ("Cannot Find Sign Data");
        }

        String lecturerUc = signData['data']['uc_lecturer'];
        log("taskRepo ${signData['data']['uc_lecturer']}  ");

        List<Map> taskChecklist = await dbx.rawQuery(
            "select * from tech_task_check where uc_task = ? and uc_sign = ? limit 1 ",
            [taskUc, ucSign]);
        bool newCheckList = false;
        var uuid = const Uuid();
        String? uc;
        String? ucLokal;
        if (taskChecklist.isEmpty) {
          // uc =
          //     "local_${uuid.v1()}_${taskUc}_${userData['data']['uc_tech_user']}";
          uc = "${ucSignLocal}_${uuid.v1()}_$taskUc";
          ucLokal = uc;
          newCheckList = true;
        } else {
          Map taskCheckListData = taskChecklist.first;
          uc = taskCheckListData['uc'];
          ucLokal = taskCheckListData['local_uc'];
          newCheckList = false;
        }
        String deviceId = await getUniqueDeviceId();
        var format = DateFormat('y-MM-dd HH:mm:ss');
        DateTime currentTime = DateTime.now();
        String currentTimeFormated = format.format(currentTime);
        if (newCheckList == true) {
          log("taskRepo ADD");
          await dbx.rawInsert(
              """insert into tech_task_check (uc, local_uc, uc_sign, uc_task, check_time,
              app_inst_status, app_lect_status, device_id, app_lect_uc) values (?,?,?,?,?,?,?,?,?)""",
              [
                uc,
                ucLokal,
                ucSign,
                taskUc,
                currentTimeFormated,
                0,
                0,
                deviceId,
                lecturerUc
              ]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "c",
              tableKey: ucLokal,
              db: dbx);
        } else {
          log("taskRepo REMOVE");
          // await dbx.rawUpdate(""" update tech_task_check set
          //     uc_sign = ?,
          //     uc_task = ?,
          //     check_time = ?,
          //     device_id = ?
          //     where local_uc = ?
          //     """, [ucSign, taskUc, currentTimeFormated, deviceId, ucLokal]);
          await dbx.rawDelete("delete from tech_task_check where uc = ?", [uc]);

          await journalIt(
              tableName: "tech_task_check",
              actionType: "d",
              tableKey: ucLokal,
              serverKey: uc,
              db: dbx);
        }
        List<Map> tmpResTaskList = await dbx.rawQuery(
            // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
            """ SELECT
            tt.*,
          CASE
              WHEN tc.uc IS NULL THEN
              0 ELSE 1 
            END AS isChecked,
          CASE
              WHEN tc.app_inst_status IS NULL THEN
              0 ELSE tc.app_inst_status
            END AS status,
          tc.app_inst_time as instTime,
          tc.app_lect_time as lectTime,
          tc.notes AS note
          FROM
            tech_task AS tt
            LEFT JOIN tech_task_check AS tc 
            on tc.uc_task = tt.uc and tc.uc_sign = ?
          WHERE
            tt.uc = ? """,
            [ucSign, taskUc]);
        List<Map> resTaskList = [];
        for (Map item in tmpResTaskList) {
          Map tmp = Map.from(item);
          var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
          if (tmp['instTime'] != null) {
            DateTime instTime = formatParse.parse(tmp['instTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["instTime"] = format.format(instTime);
          }
          if (tmp['lectTime'] != null) {
            DateTime lectTime = formatParse.parse(tmp['lectTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["lectTime"] = format.format(lectTime);
          }
          resTaskList.add(tmp);
        }
        Map? resTask;
        if (resTaskList.isNotEmpty) {
          resTask = resTaskList.first;
        }
        log("taskRepo approve $resTask");
        // List<Map> resTaskList = await dbx.rawQuery(""" SELECT
        //     tt.*,
        //   CASE
        //       WHEN tc.uc IS NULL THEN
        //       0 ELSE 1
        //     END AS isChecked,
        //   CASE
        //       WHEN tc.app_inst_status IS NULL THEN
        //       0 ELSE tc.app_inst_status
        //     END AS status,
        //     tc.notes AS note
        //   FROM
        //     tech_task AS tt
        //     LEFT JOIN tech_task_check AS tc
        //     on tc.uc_task = tt.uc and tc.uc_sign = ?
        //   WHERE
        //     tt.uc = ?""", [ucSign, taskUc]);
        // Map? resTask;
        // if (resTaskList.isNotEmpty) {
        //   resTask = resTaskList.first;
        // }
        // log("taskRepo $resTask");

        finalres['status'] = true;
        finalres['data'] = resTask;
      });
    } catch (e) {
      finalres['status'] = false;
      finalres['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalres;
  }

  static statusText(int idx) {
    List status = ["Un Approved", "Approved", "Reject"];
    return status[idx];
  }

  Future addNote({required String ucTask, required String note}) async {
    Map finalres = {};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    try {
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        Map userData = await UserRepository.getLocalUser();
        log("taskRepo $userData");
        if (userData['status'] == false) {
          throw ("Cannot Find User Data");
        }
        if (userData['data']['sign'] == false) {
          throw ("User Not Sign");
        }
        String ucSign = userData['data']['sign_uc'];
        String ucSignLocal = userData['data']['sign_uc_local'];

        List<Map> taskChecklist = await dbx.rawQuery(
            "select * from tech_task_check where uc_task = ? and uc_sign = ? limit 1 ",
            [ucTask, ucSign]);
        bool newCheckList = false;
        var uuid = const Uuid();
        String? uc;
        String? ucLokal;
        if (taskChecklist.isEmpty) {
          // uc =
          //     "local_${uuid.v1()}_${taskUc}_${userData['data']['uc_tech_user']}";
          uc = "${ucSignLocal}_${uuid.v1()}_$ucTask";
          ucLokal = uc;
          newCheckList = true;
        } else {
          Map taskCheckListData = taskChecklist.first;
          uc = taskCheckListData['uc'];
          ucLokal = taskCheckListData['local_uc'];
          newCheckList = false;
        }
        String deviceId = await getUniqueDeviceId();
        if (newCheckList == true) {
          log("taskRepo ADD");
          await dbx.rawInsert(
              """insert into tech_task_check (uc, local_uc, uc_sign, uc_task, 
              app_inst_status, app_lect_status, device_id) values (?,?,?,?,?,?,?)""",
              [uc, ucLokal, ucSign, ucTask, 0, 0, deviceId]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "c",
              tableKey: ucLokal,
              db: dbx);
        } else {
          log("taskRepo Update");
          await dbx.rawUpdate(
              """ update tech_task_check set notes = ? where uc = ? """,
              [note, uc]);

          await journalIt(
              tableName: "tech_task_check",
              actionType: "u",
              tableKey: ucLokal,
              db: dbx);
        }
        List<Map> tmpResTaskList = await dbx.rawQuery(
            // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
            """ SELECT
            tt.*,
          CASE
              WHEN tc.uc IS NULL THEN
              0 ELSE 1 
            END AS isChecked,
          CASE
              WHEN tc.app_inst_status IS NULL THEN
              0 ELSE tc.app_inst_status
            END AS status,
          CASE
              WHEN tc.app_lect_status IS NULL THEN
              0 ELSE tc.app_lect_status
            END AS lect_status,
          tc.app_inst_time as instTime,
          tc.app_lect_time as lectTime,
          tc.notes AS note
          FROM
            tech_task AS tt
            LEFT JOIN tech_task_check AS tc 
            on tc.uc_task = tt.uc and tc.uc_sign = ?
          WHERE
            tt.uc = ? """,
            [ucSign, ucTask]);
        List<Map> resTaskList = [];
        for (Map item in tmpResTaskList) {
          Map tmp = Map.from(item);
          // var formatParse = DateFormat('y-M-d H:m:s');
          var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
          if (tmp['instTime'] != null) {
            DateTime instTime = formatParse.parse(tmp['instTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["instTime"] = format.format(instTime);
          }
          if (tmp['lectTime'] != null) {
            DateTime lectTime = formatParse.parse(tmp['lectTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["lectTime"] = format.format(lectTime);
          }
          resTaskList.add(tmp);
        }
        Map? resTask;
        if (resTaskList.isNotEmpty) {
          resTask = resTaskList.first;
        }
        log("taskRepo approve $resTask");

        finalres['status'] = true;
        finalres['data'] = resTask;
      });
    } catch (e) {
      finalres['status'] = false;
      finalres['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalres;
  }

  Future urlVideo({required String ucTask, required String urlVideo}) async {
    Map finalres = {};
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    try {
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        Map userData = await UserRepository.getLocalUser();
        log("taskRepo $userData");
        if (userData['status'] == false) {
          throw ("Cannot Find User Data");
        }
        if (userData['data']['sign'] == false) {
          throw ("User Not Sign");
        }
        String ucSign = userData['data']['sign_uc'];
        String ucSignLocal = userData['data']['sign_uc_local'];

        List<Map> taskChecklist = await dbx.rawQuery(
            "select * from tech_task_check where uc_task = ? and uc_sign = ? limit 1 ",
            [ucTask, ucSign]);
        bool newCheckList = false;
        var uuid = const Uuid();
        String? uc;
        String? ucLokal;
        if (taskChecklist.isEmpty) {
          // uc =
          //     "local_${uuid.v1()}_${taskUc}_${userData['data']['uc_tech_user']}";
          uc = "${ucSignLocal}_${uuid.v1()}_$ucTask";
          ucLokal = uc;
          newCheckList = true;
        } else {
          Map taskCheckListData = taskChecklist.first;
          uc = taskCheckListData['uc'];
          ucLokal = taskCheckListData['local_uc'];
          newCheckList = false;
        }
        String deviceId = await getUniqueDeviceId();
        if (newCheckList == true) {
          log("taskRepo ADD");
          await dbx.rawInsert(
              """insert into tech_task_check (uc, local_uc, uc_sign, uc_task, 
              app_inst_status, app_lect_status, device_id) values (?,?,?,?,?,?,?)""",
              [uc, ucLokal, ucSign, ucTask, 0, 0, deviceId]);
          await journalIt(
              tableName: "tech_task_check",
              actionType: "c",
              tableKey: ucLokal,
              db: dbx);
        } else {
          log("taskRepo Update");
          await dbx.rawUpdate(
              """ update tech_task_check set att_url = ? where uc = ? """,
              [urlVideo, uc]);

          await journalIt(
              tableName: "tech_task_check",
              actionType: "u",
              tableKey: ucLokal,
              db: dbx);
        }
        List<Map> tmpResTaskList = await dbx.rawQuery(
            // """ SELECT * FROM `tech_task` WHERE `uc_sub_competency` = ? """,
            """ SELECT
            tt.*,
          CASE
              WHEN tc.uc IS NULL THEN
              0 ELSE 1 
            END AS isChecked,
          CASE
              WHEN tc.app_inst_status IS NULL THEN
              0 ELSE tc.app_inst_status
            END AS status,
          CASE
              WHEN tc.app_lect_status IS NULL THEN
              0 ELSE tc.app_lect_status
            END AS lect_status,
          tc.app_inst_time as instTime,
          tc.app_lect_time as lectTime,
          tc.att_url AS url
          FROM
            tech_task AS tt
            LEFT JOIN tech_task_check AS tc 
            on tc.uc_task = tt.uc and tc.uc_sign = ?
          WHERE
            tt.uc = ? """,
            [ucSign, ucTask]);
        List<Map> resTaskList = [];
        for (Map item in tmpResTaskList) {
          Map tmp = Map.from(item);
          // var formatParse = DateFormat('y-M-d H:m:s');
          var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
          if (tmp['instTime'] != null) {
            DateTime instTime = formatParse.parse(tmp['instTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["instTime"] = format.format(instTime);
          }
          if (tmp['lectTime'] != null) {
            DateTime lectTime = formatParse.parse(tmp['lectTime']);
            var format = DateFormat.yMMMMd().addPattern("H:m");
            tmp["lectTime"] = format.format(lectTime);
          }
          resTaskList.add(tmp);
        }
        Map? resTask;
        if (resTaskList.isNotEmpty) {
          resTask = resTaskList.first;
        }
        log("taskRepo approve $resTask");

        finalres['status'] = true;
        finalres['data'] = resTask;
      });
    } catch (e) {
      finalres['status'] = false;
      finalres['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalres;
  }
}
