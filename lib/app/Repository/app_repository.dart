import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class AppRepository {
  Future getBaselineData({
    required userData,
    // required StreamController<String> stream
  }) async {
    var con = await ConnectionTest.check();
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    Map finalResult = {};
    try {
      Map resData = {"status": false, "data": {}};
      bool getBaseline = false;
      await dbx.execute("PRAGMA foreign_keys = OFF");
      await dbx.transaction((db) async {
        mydb.transaction = db;

        log("appRepo: getVesselResult");
        // List<Map> resultVesselTest =
        //     await db.rawQuery("select * from tech_type_vessel limit 1");
        // stream.add("Sync Participant");
        EasyLoading.show(status: "Sync Participant");
        List<Map> resultParticipant = await db.rawQuery(
            "select * from tech_participant where seafarer_code = ? limit 1",
            [userData["seafarer_code"]]);

        if (con == true && resultParticipant.isEmpty) {
          log("appRepo: userData $userData");

          // Ambil token dengan menggunakan UserRepository

          // Gunakan safeApiCall untuk melakukan request
          await BaseClient.safeApiCall(
            Environment.baseline,
            RequestType.get,
            queryParameters: {"seafarer_code": userData["seafarer_code"]},
            onSuccess: (response) {
              // Tangani response yang berhasil
              resData = response.data;
              getBaseline = true;
            },
            onError: (error) {
              // Tangani error jika terjadi
              log("Error syncing baseline: ${error.message}");
            },
          );
        }

        // bool status = resData['status']!;
        Map data = resData['data']!;

        // stream.add("Sync Vessel");
        EasyLoading.show(status: "Sync Vessel");
        log("appRepo: techTypeVessel");
        List<Map> resultVessel =
            await db.rawQuery("select * from tech_type_vessel limit 1");
        if (getBaseline == true && resultVessel.isEmpty) {
          log("appRepo: vessel $resultVessel ${data['type_vessel']}");
          for (Map m in data['type_vessel']) {
            await db.rawInsert("insert into tech_type_vessel values (?,?)",
                [m['uc'], m['type_vessel']]);
          }
          finalResult['status_vessel'] = true;
        } else {
          finalResult['status_vessel'] = false;
        }

        // stream.add("Sync Server Journal Time");
        EasyLoading.show(status: "Sync Server Journal Time");
        if (getBaseline == true) {
          var stamp = data['log_stamp'];
          List findLog = await db.rawQuery(
              """ select * from tech_journal_server_last where id = 'server_journal' limit 1""");
          if (findLog.isEmpty) {
            await db.rawInsert(
                "insert into tech_journal_server_last values ('server_journal',?)",
                [stamp]);
          } else {
            await db.rawUpdate(
                """ update tech_journal_server_last set time = ? where id = 'server_journal' """,
                [stamp]);
          }
        }

        // stream.add("Sync Instructor");
        EasyLoading.show(status: "Sync Instructor");
        log("appRepo: techInstructor");
        List<Map> resultInstructor =
            await db.rawQuery("select * from tech_instructor limit 1");
        if (getBaseline == true && resultInstructor.isEmpty) {
          log("appRepo: instructor $resultInstructor ${data['tech_instructor']}");
          for (Map m in data['tech_instructor']) {
            await db.rawInsert("insert into tech_instructor values (?,?,?,?)",
                [m['uc'], m['category'], m['id_number'], m['full_name']]);
            if (m['uc_chat_user'] != null) {
              await db.rawInsert(
                  "insert into tech_chat_user values (?,null,?,null)",
                  [m['uc_chat_user'], m['uc']]);
            }
          }
          finalResult['status_instructor'] = true;
        } else {
          finalResult['status_instructor'] = false;
        }

        // stream.add("Sync Sign Data");
        EasyLoading.show(status: "Sync Sign Data");
        log("appRepo: techSign");
        String? ucSign;
        List<Map> resultSign = await db.rawQuery(
            "select * from tech_sign where seafarer_code = ? limit 1",
            [userData['seafarer_code']]);
        if (getBaseline == true && resultSign.isEmpty) {
          // log("appRepo: tech_sign $resultSign ${data['tech_sign']}");
          for (Map m in data['tech_sign']) {
            await db.rawInsert(
                "insert into tech_sign values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                [
                  m['uc'],
                  m['local_uc'],
                  m['seafarer_code'],
                  m['uc_type_vessel'],
                  m['vessel_name'],
                  m['company_name'],
                  m['imo_number'],
                  m['mmsi_number'],
                  m['sign_on_date'],
                  m['sign_on_latitude'],
                  m['sign_on_longitude'],
                  m['sign_off_date'],
                  m['sign_off_latitude'],
                  m['sign_off_longitude'],
                  m['uc_instructor'],
                  m['uc_lecturer'],
                  m['sign_on_stamp']
                ]);
            ucSign ??= m['uc'];
            await db.rawInsert("""insert into tech_sign_att values (?,?,?,?,
                ?,?,?,?,
                ?,?,?,?,
                ?,?,?,?,
                ?,?,?,?,
                ?,?,?)""", [
              m['uc_att'],
              m['local_uc_att'],
              m['uc'],
              m['att_sign_on'],
              m['att_imo'],
              m['att_crew_list_on'],
              m['att_buku_pelaut_on'],
              m['att_spesifikasi_kapal'],
              m['att_sign_off'],
              m['att_imo_off'],
              m['att_foto_pelabuhan'],
              m['att_crew_list_off'],
              m['att_mutasi_on'],
              m['local_att_sign_on'],
              m['local_att_imo_on'],
              m['local_att_crew_list_on'],
              m['local_att_buku_pelaut_on'],
              m['local_att_spesifikasi_kapal'],
              m['local_att_sign_off'],
              m['local_att_imo_off'],
              m['local_att_foto_pelabuhan'],
              m['local_att_crew_list_off'],
              m['local_att_mutasi_on'],
            ]);
          }
          finalResult['tech_sign'] = true;
        } else {
          finalResult['tech_sign'] = false;
        }

        // stream.add("Sync Participant");
        EasyLoading.show(status: "Sync Participant");
        Map m = {};
        if (getBaseline == true) {
          log("appRepo: techParticipant $data ${data['tech_participant']}");
          m = data['tech_participant'];
        }
        resultParticipant = await db.rawQuery(
            "select * from tech_participant where seafarer_code = ? limit 1",
            [m["seafarer_code"]]);
        if (getBaseline == true && resultParticipant.isEmpty) {
          log("appRepo: participant $resultParticipant ${data['tech_participant']}");
          await db.rawInsert(
              "insert into tech_participant values (?,?,?,?,?,?,?,?,?,?)", [
            m['uc'],
            m['seafarer_code'],
            m['nik'],
            m['passport_no'],
            m['full_name'],
            m['citizenship'],
            m['gender'],
            m['born_place'],
            m['born_date'],
            m['uc_sk_diklat']
          ]);

          finalResult['tech_participant'] = true;
        } else {
          finalResult['tech_participant'] = false;
        }

        finalResult['status_trb_participant'] = false;
        List<Map> resultTrbParticipant = [];
        if (getBaseline == true) {
          log("appRepo: tech_trb_participant");
          m = data['tech_trb_participant'];
          resultTrbParticipant = await db.rawQuery(
              "select * from tech_trb_participant where uc = ? limit 1",
              [m["uc"]]);
        }
        if (getBaseline == true && resultTrbParticipant.isEmpty) {
          log("appRepo: tech_trb_participant $resultTrbParticipant ${data['tech_trb_participant']}");
          await db.rawInsert(
              "insert into tech_trb_participant values (?,?,?,?,?)", [
            m['uc'],
            m['uc_trb_schedule'],
            m['uc_participant'],
            m['uc_diklat_participant'],
            m['seafarer_code']
          ]);

          finalResult['status_trb_participant'] = true;
        }

        // stream.add("Sync Schedule");
        EasyLoading.show(status: "Sync Schedule");
        finalResult['tech_trb_schedule'] = false;
        String? ucLevel;
        if (data.containsKey('tech_trb_schedule') && getBaseline == true) {
          Map m = data['tech_trb_schedule'];
          List<Map> resultTrbSchedule = await db.rawQuery(
              "select * from tech_trb_schedule where uc = ? limit 1",
              [m['uc']]);
          if (getBaseline == true && resultTrbSchedule.isEmpty) {
            log("appRepo: tech_trb_schedule $resultTrbSchedule ${data['tech_trb_schedule']}");

            await db.rawInsert(
                "insert into tech_trb_schedule values (?,?,?,?,?,?,?)", [
              m['uc'],
              m['title'],
              m['date_start'],
              m['date_finish'],
              m['uc_upt'],
              m['uc_pukp'],
              m['uc_level']
            ]);
            ucLevel = m['uc_level'];
            finalResult['tech_trb_schedule'] = true;
          }
        }

        // stream.add("Sync Level");
        EasyLoading.show(status: "Sync Level");
        finalResult['status_tech_level'] = false;
        if (data.containsKey('tech_level') && getBaseline == true) {
          log("appRepo: tech_level");
          List<Map> resultTechList =
              await db.rawQuery("select * from tech_level limit 1");
          if (getBaseline == true && resultTechList.isEmpty) {
            log("appRepo: tech_level $resultTechList ${data['tech_level']}");
            for (Map m in data['tech_level']) {
              await db.rawInsert("insert into tech_level values (?,?,?,?)", [
                m['uc'],
                m['label'],
                m['majors'],
                int.parse(m['level_majors'])
              ]);
            }
            finalResult['status_tech_level'] = true;
          }
        }

        // stream.add("Sync Function");
        EasyLoading.show(status: "Sync Function");
        finalResult['status_tech_function'] = false;
        if (data.containsKey('tech_function') && getBaseline == true) {
          log("appRepo: tech_function");
          List<Map> resultTechFunction =
              await db.rawQuery("select * from tech_function limit 1");
          if (getBaseline == true && resultTechFunction.isEmpty) {
            log("appRepo: tech_function $resultTechFunction");
            for (Map m in data['tech_function']) {
              await db.rawInsert("insert into tech_function values (?,?,?,?)", [
                m['label'],
                m['label_long'],
                m['uc'],
                m['uc_level'],
              ]);
            }
            finalResult['status_tech_function'] = true;
          }
        }

        // stream.add("Sync Competency");
        EasyLoading.show(status: "Sync Competency");
        finalResult['status_tech_competency'] = false;
        if (data.containsKey('tech_competency') && getBaseline == true) {
          log("appRepo: tech_competency");
          List<Map> resultTechCompetency =
              await db.rawQuery("select * from tech_competency limit 1");
          if (getBaseline == true && resultTechCompetency.isEmpty) {
            log("appRepo: tech_competency $resultTechCompetency");
            for (Map m in data['tech_competency']) {
              // log("inserted $m");
              await db.rawInsert(
                  "insert into tech_competency values (?,?,?,?,?,?)", [
                m['label'],
                m['uc'],
                m['uc_function'],
                m['sequence'],
                m['category'],
                m['pack_amt']
              ]);
            }
            finalResult['status_tech_competency'] = true;
          }
        }

        // stream.add("Sync Sub Competency");
        EasyLoading.show(status: "Sync Sub Competency");
        finalResult['status_tech_sub_competency'] = false;
        if (data.containsKey('tech_sub_competency') && getBaseline == true) {
          log("appRepo: tech_sub_competency");
          List<Map> resultTechSubCompetency =
              await db.rawQuery("select * from tech_sub_competency limit 1");
          if (getBaseline == true && resultTechSubCompetency.isEmpty) {
            log("appRepo: tech_sub_competency $resultTechSubCompetency");
            for (Map m in data['tech_sub_competency']) {
              // log("inserted $m");
              await db.rawInsert(
                  "insert into tech_sub_competency values (?,?,?,?,?)", [
                m['uc'],
                m['uc_competency'],
                m['sub_label'],
                m['created_at'],
                m['updated_at']
              ]);
            }
            finalResult['status_tech_sub_competency'] = true;
          }
        }

        // stream.add("Sync Task");
        EasyLoading.show(status: "Sync Task");
        finalResult['status_tech_task'] = false;
        if (data.containsKey('tech_task') && getBaseline == true) {
          log("appRepo: tech_task");
          List<Map> resultTechTask =
              await db.rawQuery("select * from tech_task limit 1");
          if (getBaseline == true && resultTechTask.isEmpty) {
            log("appRepo: tech_task $resultTechTask");
            for (Map m in data['tech_task']) {
              // log("inserted $m");
              await db.rawInsert("insert into tech_task values (?,?,?,?,?,?)", [
                m['uc'],
                m['uc_sub_competency'],
                m['task_name'],
                m['category'],
                m['created_at'],
                m['updated_at']
              ]);
            }
            finalResult['status_tech_task'] = true;
          }
        }

        // stream.add("Sync Task check");
        EasyLoading.show(status: "Sync Task Check");
        finalResult['status_tech_task_check'] = false;
        if (data.containsKey('tech_task_check') && getBaseline == true) {
          log("appRepo: tech_task_check");
          List<Map> resultTechTaskCheck =
              await db.rawQuery("select * from tech_task_check limit 1");
          if (getBaseline == true && resultTechTaskCheck.isEmpty) {
            log("appRepo: tech_task_check $resultTechTaskCheck");
            for (Map m in data['tech_task_check']) {
              // log("inserted $m");
              await db.rawInsert(
                  """ insert into tech_task_check values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) """,
                  [
                    m['uc'],
                    m['local_uc'],
                    m['uc_sign'],
                    m['uc_task'],
                    m['notes'],
                    m['check_latitude'],
                    m['check_longitude'],
                    m['check_time'],
                    m['app_inst_status'],
                    m['app_inst_name'],
                    m['app_inst_comment'],
                    m['app_inst_local_photo'],
                    m['app_inst_photo'],
                    m['app_inst_time'],
                    m['app_lect_status'],
                    m['app_lect_uc'],
                    m['app_lect_time'],
                    m['device_id'],
                    m['local_photo'],
                    m['att_url'],
                    m['att_photo'],
                  ]);
            }
            finalResult['status_tech_task'] = true;
          }
        }

        // stream.add("Sync Report List");
        EasyLoading.show(status: "Sync Repost List");
        finalResult['status_report_list'] = false;
        if (data.containsKey('tech_report_list') &&
            ucLevel != null &&
            getBaseline == true) {
          log("appRepo: tech_report_list");
          List<Map> resultReportList = await db.rawQuery(
              "select * from tech_report_list where uc_level = ? limit 1",
              [ucLevel]);
          if (getBaseline == true && resultReportList.isEmpty) {
            log("appRepo: tech_report_list $resultReportList ${data['tech_report_list']}");
            for (Map m in data['tech_report_list']) {
              await db.rawInsert(
                  "insert into tech_report_list values (?,?,?,?,?)", [
                m['uc'],
                m['uc_level'],
                m['title'],
                m['description'],
                int.parse(m['month'])
              ]);
            }
            finalResult['status_report_list'] = true;
          }
        }

        // stream.add("Sync Report Route");
        EasyLoading.show(status: "Sync Report Route");
        finalResult['tech_report_route'] = false;
        if (data.containsKey('tech_report_route') &&
            getBaseline == true &&
            ucSign != null) {
          log("appRepo: tech_report_list");
          List<Map> checkData = await db.rawQuery(
              "select * from tech_report_route where uc_sign = ? limit 1",
              [ucSign]);
          if (getBaseline == true && checkData.isEmpty) {
            for (Map m in data['tech_report_route']) {
              await db.rawInsert(
                  "insert into tech_report_route values (?,?,?,?,?,?,?)", [
                m['uc'],
                m['local_uc'],
                m['uc_sign'],
                int.parse(m['month']),
                m['item'],
                m['check_latitude'],
                m['check_longitude']
              ]);
            }
            finalResult['tech_report_route'] = true;
          }
        }

        // stream.add("Sync Report Log");
        EasyLoading.show(status: "Sync Report Log");
        finalResult['tech_report_log'] = false;
        if (data.containsKey('tech_report_log') &&
            getBaseline == true &&
            ucSign != null) {
          log("appRepo: tech_report_log");
          List<Map> checkData = await db.rawQuery(
              "select * from tech_report_log where uc_sign = ? limit 1",
              [ucSign]);
          if (getBaseline == true && checkData.isEmpty) {
            for (Map m in data['tech_report_log']) {
              // stream.add("Sync Report Log");
              await db.rawInsert(
                  "insert into tech_report_log values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                  [
                    m['uc'],
                    m['local_uc'],
                    m['uc_sign'],
                    m['uc_report_list'],
                    int.parse(m['month']),
                    m['check_latitude'],
                    m['check_longitude'],
                    m['check_time'],
                    m['app_inst_status'] ?? 0,
                    m['app_inst_name'],
                    m['app_inst_comment'],
                    m['app_inst_local_photo'],
                    m['app_inst_photo'],
                    m['app_inst_time'],
                    m['app_lect_status'],
                    m['app_lect_uc'],
                    m['app_lect_time'],
                    m['device_id'],
                  ]);
              if (m.containsKey('att')) {
                // stream.add("Sync Report Log Media");
                Map att = m['att'];
                await db.rawInsert(
                    """ insert into tech_report_log_att values (?,?,?,?,?,?) """,
                    [
                      att['uc'],
                      att['local_uc'],
                      att['uc_report_log'],
                      att['file'],
                      att['local_file'],
                      att['caption']
                    ]);
              }
            }
            finalResult['tech_report_log'] = true;
          }
        }

        // stream.add("Sync News");
        EasyLoading.show(status: "Sync News");
        finalResult['tech_news'] = false;
        if (data.containsKey('tech_news') && getBaseline == true) {
          // var formatParse = DateFormat('y-M-d H:m:s');
          log("appRepo: tech_news");
          if (getBaseline == true) {
            for (Map m in data['tech_news']) {
              // stream.add("Sync Tech News");
              List<Map> tres = await db.rawQuery(
                  """ select * from tech_news where uc = ? limit 1""",
                  [m['uc']]);
              if (tres.isEmpty) {
                await db.rawInsert("insert into tech_news values (?,?,?,?,?)", [
                  m['uc'],
                  m['title'],
                  m['description'],
                  m['created_at'],
                  m['updated_at'],
                ]);
              }
            }
            finalResult['tech_news'] = true;
          }
        }

        // stream.add("Sync News Status");
        EasyLoading.show(status: "Sync News Status");
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;

        finalResult['tech_news'] = false;
        if (data.containsKey('tech_news_status') && getBaseline == true) {
          // var formatParse = DateFormat('y-M-d H:m:s');
          log("appRepo: tech_news_status");
          if (getBaseline == true) {
            for (Map m in data['tech_news_status']) {
              // stream.add("Sync Tech News Status");
              List<Map> tres = await db.rawQuery(
                  """ select * from tech_news_status where uc = ? limit 1""",
                  [m['uc']]);
              if (tres.isEmpty) {
                var uuid = const Uuid();
                String localUc = "${uuid.v1()}_$userUc";
                await db.rawInsert(
                    "insert into tech_news_status values (?,?,?,?)",
                    [m['uc'], localUc, m['tech_user_uc'], m['tech_news_uc']]);
              }
            }
            finalResult['tech_news'] = true;
          }
        }

        // stream.add("Getting FAQ");
        EasyLoading.show(status: "Getting FAQ");
        if (data.containsKey('tech_faq') && getBaseline == true) {
          for (Map m in data['tech_faq']) {
            // stream.add("Sync Tech Faq");
            List<Map> tres = await db.rawQuery(
                """ select * from tech_faq where uc = ? limit 1""", [m['uc']]);
            if (tres.isEmpty) {
              // var uuid = const Uuid();
              // String localUc = "${uuid.v1()}_$userUc";
              await db.rawInsert("insert into tech_faq values (?,?,?)",
                  [m['uc'], m['question'], m['answer']]);
            }
          }
          finalResult['tech_faq'] = true;
        }

        // stream.add("Getting Logbook");
        EasyLoading.show(status: "Getting Logbook");
        if (data.containsKey('tech_logbook') && getBaseline == true) {
          for (Map m in data['tech_logbook']) {
            List<Map> findLogbook = await db.rawQuery(
                """SELECT * FROM tech_logbook WHERE uc = ? OR local_uc = ? LIMIT 1""",
                [m['uc'], m['local_uc']]); // <- CEK DUA-DUANYA

            if (findLogbook.isEmpty) {
              await db.rawInsert("""INSERT INTO tech_logbook VALUES (
                  ?,?,?,?,
                  ?,?,?,?,
                  ?,?,?,?,
                  ?,?
                )""", [
                m['local_uc'] ?? "",
                m['uc'] ?? "",
                m['uc_sign'] ?? "",
                m['log_date'] ?? "",
                m['log_activity'] ?? "",
                m['check_latitude'] ?? 0,
                m['check_longitude'] ?? 0,
                m['app_inst_status'] ?? 0,
                m['app_inst_name'] ?? "",
                m['app_inst_comment'] ?? "",
                m['app_inst_photo'] ?? "",
                m['app_inst_photo_remote'] ?? "",
                m['app_inst_time'] ?? "",
                m['device_id'] ?? "",
              ]);
            }
          }

          finalResult['tech_logbook'] = true;
        }

        // stream.add("Restoring Messages");
        EasyLoading.show(status: "Restoring Messages");
        finalResult['messages'] = false;
        if (data.containsKey('chat_room') && getBaseline == true) {
          for (Map m in data['chat_room']) {
            List<Map> tres = await db.rawQuery(
                """ select uc_room from tech_chat_room where uc_room = ? limit 1""",
                [m['uc_room']]);
            if (tres.isEmpty) {
              await db.rawInsert(
                  "insert into tech_chat_room values (?,?,?,?,?,?,?)", [
                m['uc_room'],
                m['room_name'],
                m['room_description'],
                m['active'],
                m['status'],
                m['created_by'],
                m['created_on']
              ]);
            }
          }
        }

        if (data.containsKey('chat_users') && getBaseline == true) {
          for (Map m in data['chat_users']) {
            List<Map> tres = await db.rawQuery(
                """ select uc_chat_user from tech_chat_user where uc_chat_user = ? limit 1""",
                [m['uc_chat_user']]);
            if (tres.isEmpty) {
              await db.rawInsert(
                  "insert into tech_chat_user values (?,?,?,?)", [
                m['uc_chat_user'],
                m['tech_user_uc'],
                m['tech_instructor_uc'],
                m['full_name']
              ]);
            }
          }
        }

        if (data.containsKey('participant') && getBaseline == true) {
          for (Map m in data['participant']) {
            List<Map> tres = await db.rawQuery(
                """ select uc_room from tech_chat_participant where uc_room = ? and uc_chat_user = ? limit 1""",
                [m['uc_room'], m['uc_chat_user']]);
            if (tres.isEmpty) {
              await db
                  .rawInsert("insert into tech_chat_participant values (?,?)", [
                m['uc_room'],
                m['uc_chat_user'],
              ]);
            }
          }
        }

        if (data.containsKey('messages') && getBaseline == true) {
          for (Map m in data['messages']) {
            log("res messages $m");
            List<Map> tres = await db.rawQuery(
                """ select uc_room from tech_chat_message where uc_message = ? limit 1""",
                [m['uc_message']]);
            if (tres.isEmpty) {
              await db.rawInsert(
                  "insert into tech_chat_message values (?,?,?,?,?,?,?)", [
                m['uc_message'],
                m['uc_room'],
                m['uc_chat_user'],
                m['message'],
                m['media'],
                m['sent_on'],
                m['status'],
              ]);
            }
          }
          finalResult['messages'] = true;
        }

        // stream.add("Finishing Login..");
        EasyLoading.show(status: "Finishing Login..");
      });
      mydb.transaction = null;
      await dbx.execute("PRAGMA foreign_keys = ON");
    } on DioError catch (e) {
      log("appRepo: Dio Error ${e.message}");
    } finally {
      mydb.transaction = null;
      // await mydb.close2();
      EasyLoading.dismiss();
    }
    return finalResult;
  }
}
