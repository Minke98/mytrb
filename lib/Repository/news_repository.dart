import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mytrb/Helper/my_db.dart';
import 'package:mytrb/Helper/my_dio.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/user_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class NewsRepository extends Repository {
  String truncate(String text, {int length = 50, String omission = '...'}) {
    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  static Future getNews(
      {int itemCount = 10,
      int page = 1,
      bool truncate = true,
      int characterMax = 60}) async {
    MyDatabase mydb = MyDatabase.instance;
    var db;
    if (mydb.transaction != null) {
      db = mydb.transaction!;
    } else {
      db = await mydb.database;
    }

    int offset = (page - 1) * itemCount;

    List<Map> news = await db.rawQuery(""" select 
      tn.*,
      CASE
        WHEN ts.uc IS NULL THEN
        0 ELSE 1 
      END AS isRead
      from 
        tech_news as tn left join tech_news_status as ts 
        on tn.uc = ts.tech_news_uc 
      order by tn.created_at desc, tn.title asc limit ? offset ? """,
        [itemCount, offset]);

    int textLength = characterMax;
    if (news != null && news.isNotEmpty) {
      List<Map> rnews = [];
      var formatParse = DateFormat('yyyy-MM-dd HH:mm:ss');
      for (Map item in news) {
        Map tmpItem = Map.from(item);
        // Check if 'created_at' is null and handle it
        DateTime createTime = tmpItem['created_at'] != null
            ? formatParse.parse(tmpItem['created_at'])
            : DateTime.now();

        // Membuat format khusus
        var customFormat = DateFormat('EEEE, MMMM dd, yyyy HH:mm', 'en_US');

        // Add the time zone (WIB - Western Indonesian Time)
        String formattedDate = customFormat.format(createTime);

        tmpItem["created_at_formated"] = formattedDate;
        tmpItem['descriptionfull'] = tmpItem['description'];
        if (truncate) {
          if (tmpItem['description'] != null &&
              textLength >= tmpItem['description'].length) {
            rnews.add(tmpItem);
            continue;
          }

          tmpItem['description'] = tmpItem['descriptionfull']?.replaceRange(
              textLength, tmpItem['descriptionfull']?.length ?? 0, ' ...');
          rnews.add(tmpItem);
        } else {
          rnews.add(tmpItem);
        }
      }
      return rnews;
    } else {
      return <Map>[];
    }
  }

  Future setRead(String newsUc) async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    try {
      var db;
      if (mydb.transaction != null) {
        db = mydb.transaction!;
      } else {
        db = await mydb.database;
      }
      await db.transaction((dbx) async {
        mydb.transaction = dbx;
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;
        List<Map> checkNews = await dbx.rawQuery(
            "select * from tech_news_status where tech_news_uc = ? and tech_user_uc = ?",
            [newsUc, userUc]);
        if (checkNews.isEmpty) {
          var uuid = const Uuid();
          String localUc = "${uuid.v1()}_$userUc";
          await dbx.rawInsert(
              """ insert into tech_news_status values (?,?,?,?)""",
              [localUc, localUc, userUc, newsUc]);
          await journalIt(
              tableName: "tech_news_status",
              actionType: "c",
              tableKey: localUc,
              db: dbx);
          log("set read $newsUc");
        }
      });
      finalRes['status'] = true;
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  static Future<Map> getNewNews() async {
    final finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    Database db = dbx;
    String lastCreatedDate = "1980-01-01 00:00:00";
    List<Map> findNews = await db.rawQuery(
        """ select * from tech_news order by created_at desc limit 1 """);

    if (findNews.isNotEmpty) {
      Map news = findNews.first;
      lastCreatedDate = news["created_at"];
    } else {
      lastCreatedDate = "1980-01-01 00:00:00";
    }
    final prefs = await SharedPreferences.getInstance();
    String userUc = prefs.getString('userUc')!;
    Map token = await UserRepository.getToken(uc: userUc);
    Dio dio = await MyDio.getDio(
        token: token['token'], refreshToken: token['refreshToken']);
    try {
      await dbx.transaction((db) async {
        mydb.transaction = db;
        var response = await dio.get("news/getnew", queryParameters: {
          "last": lastCreatedDate,
        });
        log("get new news $response");
        Map resp = response.data as Map;
        if (resp['status'] == true) {
          for (Map item in resp['news']) {
            List<Map> findOldNews = await db.rawQuery(
                """ select * from tech_news where uc = ? limit 1 """,
                [item['uc']]);
            if (findOldNews.isEmpty) {
              await db
                  .rawInsert(""" insert into tech_news values(?,?,?,?,?) """, [
                item['uc'],
                item['title'],
                item['description'],
                item['created_at'],
                item['updated_at']
              ]);
            } else {
              await db.rawUpdate(""" update tech_news 
                set 
                  title = ?,
                  description = ?,
                  created_at = ?,
                  updated_at = ?
                  where uc = ?
              """, [
                item['title'],
                item['description'],
                item['created_at'],
                item['updated_at'],
                item['uc']
              ]);
            }
          }
          finalRes['status'] = true;
        }
      });
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }
}
