import 'dart:developer';

import 'package:mytrb/config/database/my_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Models/instructor.dart';
import 'package:mytrb/Repository/repository.dart';

class InstructorRepository extends Repository {
  static const int DOSEN = 2;
  static const int INSTRUKTUR = 3;
  static Future getDosen({required String id}) async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }
    List<Map> res = await db.rawQuery(""" 
      select * from tech_instructor where id_number = ? and category = ? limit 1
      """, [id, DOSEN]);
    Map? ret;
    if (res.isNotEmpty) {
      ret = res.first;
      return ret;
    } else {
      return null;
    }
  }

  static Future findInstructor(
      {required String patern, required int type}) async {
    log("FIND INT $patern");
    Map finalRes = {};
    try {
      MyDatabase mydb = MyDatabase.instance;
      Database db = await mydb.database;
      List<Map> res = await db.rawQuery(""" 
      select * from tech_instructor where full_name like ? and category = ?
      """, ['%$patern%', type]);
      if (res.isNotEmpty) {
        List<Instructor> data = <Instructor>[];
        for (Map item in res) {
          Instructor instr = Instructor(
              uc: item['uc'],
              category: item['category'],
              idNumber: item["id_category"],
              fullName: item["full_name"]);
          data.add(instr);
        }
        finalRes["status"] = true;
        finalRes["data"] = data;
      } else {
        finalRes["status"] = false;
      }
    } finally {}
    return finalRes;
  }
}
