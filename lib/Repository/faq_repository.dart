import 'package:mytrb/config/database/my_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Repository/repository.dart';

class FaqRepository extends Repository {
  Future getFaq() async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      await dbx.transaction((db) async {
        mydb.transaction = db;
        List<Map> findFaq = await db.rawQuery(""" select * from tech_faq """);
        if (findFaq.isEmpty) {
          throw ("Empty Faq");
        }
        finalRes['faq'] = findFaq;
        finalRes['status'] = true;
      });
    } catch (e) {
      finalRes['status'] = false;
      finalRes['message'] = e.toString();
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }
}
