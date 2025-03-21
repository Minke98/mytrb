import 'dart:developer';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
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
    if (news.isNotEmpty) {
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
      final db =
          await mydb.database; // Pastikan hanya pakai satu instance database

      // Gunakan exclusive lock untuk mencegah deadlock
      await db.transaction((txn) async {
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc') ?? '';

        if (userUc.isNotEmpty) {
          List<Map> checkNews = await txn.rawQuery(
              "SELECT * FROM tech_news_status WHERE tech_news_uc = ? AND tech_user_uc = ?",
              [newsUc, userUc]);

          if (checkNews.isEmpty) {
            var uuid = const Uuid();
            String localUc = "${uuid.v1()}_$userUc";
            await txn.rawInsert(
                """INSERT INTO tech_news_status VALUES (?,?,?,?)""",
                [localUc, localUc, userUc, newsUc]);

            await journalIt(
                tableName: "tech_news_status",
                actionType: "c",
                tableKey: localUc,
                db: txn // Pastikan pakai txn, bukan db
                );

            log("set read $newsUc");
          }
        }
      });

      finalRes['status'] = true;
    } catch (e) {
      log("Error in setRead: $e");
    }

    return finalRes;
  }

  static Future<Map> getNewNews() async {
    final finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    // Database db = dbx;
    String lastCreatedDate = "1980-01-01 00:00:00";

    // List<Map> findNews = await db.rawQuery(
    //     """SELECT * FROM tech_news ORDER BY created_at DESC LIMIT 1""");

    // if (findNews.isNotEmpty) {
    //   lastCreatedDate = findNews.first["created_at"];
    // }

    // final prefs = await SharedPreferences.getInstance();
    // String userUc = prefs.getString('userUc')!;
    // Map token = await UserRepository.getToken(uc: userUc);

    try {
      await dbx.transaction((db) async {
        mydb.transaction = db;

        await BaseClient.safeApiCall(
          Environment.getNew, // Endpoint API
          RequestType.get, // Request GET
          queryParameters: {
            "last": lastCreatedDate,
          },
          onSuccess: (response) async {
            log("get new news $response");

            Map resp = response.data as Map;
            if (resp['status'] == true) {
              for (Map item in resp['news']) {
                List<Map> findOldNews = await db.rawQuery(
                    """SELECT * FROM tech_news WHERE uc = ? LIMIT 1""",
                    [item['uc']]);

                if (findOldNews.isEmpty) {
                  await db.rawInsert(
                      """INSERT INTO tech_news VALUES(?,?,?,?,?)""",
                      [
                        item['uc'],
                        item['title'],
                        item['description'],
                        item['created_at'],
                        item['updated_at']
                      ]);
                } else {
                  await db.rawUpdate("""UPDATE tech_news
                  SET
                    title = ?,
                    description = ?,
                    created_at = ?,
                    updated_at = ?
                  WHERE uc = ?""", [
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
          },
          onError: (error) {
            throw Exception("Gagal mendapatkan berita: $error");
          },
        );
      });
    } catch (e) {
      log("ERR $e");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
    }

    return finalRes;
  }

  // static Future<List<Map<String, dynamic>>> getNewNews() async {
  //   final List<Map<String, dynamic>> finalNews = [];
  //   MyDatabase mydb = MyDatabase.instance;
  //   Database dbx = await mydb.database;
  //   Database db = dbx;
  //   String lastCreatedDate = "1980-01-01 00:00:00";

  //   // List<Map> findNews = await db.rawQuery(
  //   //     """SELECT * FROM tech_news ORDER BY created_at DESC LIMIT 1""");

  //   // if (findNews.isNotEmpty) {
  //   //   lastCreatedDate = findNews.first["created_at"];
  //   // }

  //   try {
  //     await dbx.transaction((db) async {
  //       mydb.transaction = db;

  //       await BaseClient.safeApiCall(
  //         Environment.getNew,
  //         RequestType.get,
  //         queryParameters: {
  //           "last": lastCreatedDate,
  //         },
  //         onSuccess: (response) async {
  //           log("get new news $response");

  //           Map<String, dynamic> resp = response.data as Map<String, dynamic>;
  //           if (resp['status'] == true && resp.containsKey('news')) {
  //             for (var item in resp['news']) {
  //               List<Map> findOldNews = await db.rawQuery(
  //                   """SELECT * FROM tech_news WHERE uc = ? LIMIT 1""",
  //                   [item['uc']]);

  //               if (findOldNews.isEmpty) {
  //                 await db.rawInsert(
  //                     """INSERT INTO tech_news VALUES(?,?,?,?,?)""",
  //                     [
  //                       item['uc'],
  //                       item['title'],
  //                       item['description'],
  //                       item['created_at'],
  //                       item['updated_at']
  //                     ]);
  //               } else {
  //                 await db.rawUpdate("""UPDATE tech_news
  //                 SET
  //                   title = ?,
  //                   description = ?,
  //                   created_at = ?,
  //                   updated_at = ?
  //                 WHERE uc = ?""", [
  //                   item['title'],
  //                   item['description'],
  //                   item['created_at'],
  //                   item['updated_at'],
  //                   item['uc']
  //                 ]);
  //               }
  //             }
  //             finalNews.addAll(List<Map<String, dynamic>>.from(resp['news']));
  //           }
  //         },
  //         onError: (error) {
  //           throw Exception("Gagal mendapatkan berita: $error");
  //         },
  //       );
  //     });
  //   } catch (e) {
  //     log("ERR $e");
  //   } finally {
  //     mydb.transaction = null;
  //   }

  //   return finalNews;
  // }
}
