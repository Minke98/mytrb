import 'dart:developer';

import 'package:mytrb/config/database/my_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  Repository();
  // Future<bool> journalUpdate(
  //     {Transaction? db,
  //     required String oldTableKey,
  //     required String tableKey}) async {
  //   bool status;
  //   try {
  //     if (db == null) {
  //       MyDatabase mydb = MyDatabase.instance;
  //       Database db = await mydb.database;
  //     }
  //     // var updateSign = await db?.rawDelete(
  //     //     """ delete from journal where table_name = ? and table_key = ? and action_type = ? and log_stamp = ? """,
  //     //     [tableName, tableKey, actionType, logStamp]);
  //     // log("journal: update journal $updateSign");
  //     status = true;
  //   } catch (e) {
  //     status = false;
  //   } finally {}
  //   return status;
  // }

  Future<bool> journalRemove(
      {required String tableName,
      String? tableKey,
      required String actionType,
      required int logStamp,
      Transaction? db,
      bool closeDb = false}) async {
    log("journal: removing $tableKey $tableName $actionType $logStamp");
    if (db == null) {
      MyDatabase mydb = MyDatabase.instance;
      Database db = await mydb.database;
    }
    final prefs = await SharedPreferences.getInstance();
    String uc = prefs.getString('userUc')!;
    bool status;
    try {
      var deleteSign = await db?.rawDelete(
          """ delete from tech_journal where table_name = ? and table_key = ? and action_type = ? and log_stamp = ? and uc_user = ? """,
          [tableName, tableKey, actionType, logStamp, uc]);
      log("journal: remove journal $deleteSign");
      status = true;
    } catch (e) {
      status = false;
    } finally {}
    log("journal: status $status");
    return status;
  }

  Future<bool> journalIt(
      {required String tableName,
      String? tableKey,
      required String actionType,
      String? serverKey,
      Transaction? db,
      bool closeDb = false}) async {
    MyDatabase mydb = MyDatabase.instance;
    if (db == null) {
      Database db = await mydb.database;
    }
    log("JOURNAL $tableName $tableKey $actionType");
    try {
      final prefs = await SharedPreferences.getInstance();
      String uc = prefs.getString('userUc')!;
      int stamp = DateTime.now().millisecondsSinceEpoch;
      if (actionType == 'd') {
        await db!.rawDelete(
            """ delete from tech_journal where table_name = ? and table_key=? and uc_user = ? """,
            [tableName, tableKey, uc]);
        await db.rawDelete(
            """ delete from tech_journal where table_name = ? and table_key=? and uc_user = ? """,
            [tableName, serverKey, uc]);
        if (serverKey != tableKey) {
          await db.rawInsert("insert into tech_journal values (?,?,?,?,?)",
              [uc, tableName, serverKey, actionType, stamp]);
        }
      } else {
        String q1 =
            "select * from tech_journal where table_name = ? and table_key=? and action_type = ? and uc_user = ? limit 1";
        List<Map> journal =
            await db!.rawQuery(q1, [tableName, tableKey, actionType, uc]);

        // String q2 =
        //     "select * from tech_journal where table_name = ? and table_key=? and uc_user = ? limit 1";
        // List<Map> journal = await db!.rawQuery(q2, [tableName, tableKey, uc]);
        if (journal.isEmpty) {
          log("Journal Entry");
          await db.rawInsert("insert into tech_journal values (?,?,?,?,?)",
              [uc, tableName, tableKey, actionType, stamp]);
        } else {
          log("Journal Update");
          //else {}
//         await db.rawUpdate(
//             """
// update tech_journal set log_stamp = ?, action_type = ?
// where table_name = ? and table_key = ? and uc_user = ?
// """,
//             [stamp, actionType, tableName, tableKey, uc]);
        }
      }
    } finally {
      // if (closeDb == true) {
      //   await mydb.close();
      // }
    }
    return true;
  }

  static Future<bool> isNeedSync() async {
    MyDatabase mydb = MyDatabase.instance;
    var db = null;
    if (mydb.transaction == null) {
      db = await mydb.database;
    } else {
      db = mydb.transaction!;
    }
    final prefs = await SharedPreferences.getInstance();
    String uc = prefs.getString('userUc')!;
    List<Map> res = await db.rawQuery(
        """ select * from tech_journal where uc_user = ? limit 1 """, [uc]);

    List<Map> resServer =
        await db.rawQuery(""" select * from tech_journal_server limit 1 """);

    log("need Sync $res $resServer");
    if (res.isEmpty && resServer.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
