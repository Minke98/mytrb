import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mytrb/Repository/repository.dart';
import 'package:mytrb/Repository/sign_repository.dart';
import 'package:mytrb/Repository/user_repository.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/database/my_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class ChatRepository extends Repository {
  Future<Map> getConversations() async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;

    List<Map> converstationList = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      String instructorSign = "0";

      bool manualAdd = true;
      Map userData = await UserRepository.getLocalUser();
      if (userData['status'] == true &&
          userData['data']['sign_uc_local'] != null) {
        Map signData = await SignRepository.getData(
            localSignUc: userData['data']['sign_uc_local']);

        log("Local Sign $instructorSign $userData");
        if (signData['status'] == true &&
            signData['data']['instructorUc'] != null) {
          instructorSign = signData['data']['instructorUc'];
        }
      }
      await dbx.transaction((db) async {
        mydb.transaction = db;
        log("chat search $userUc");
        List<Map> chatUserSearch2 = await db.rawQuery(
            """ select * from tech_chat_user where tech_user_uc is not null""");
        log("chat search $chatUserSearch2");

        List<Map> chatUserSearch = await db.rawQuery(
            """ select * from tech_chat_user where tech_user_uc = ? limit 1""",
            [userUc]);
        if (chatUserSearch.isEmpty) {
          throw ("CHAT USER NOT FOUND");
        }
        log("chat search $chatUserSearch");
        Map chatUser = chatUserSearch.first;
        // List<Map> participantSearcht =
        //     await db.rawQuery(""" select * from tech_chat_participant""");
        // log("participant search $participantSearcht");

        // List<Map> participantSearch = await db.rawQuery(
        //     """ select uc_room from tech_chat_participant where uc_chat_user = ? group by uc_room  """,
        //     [chatUser['uc_chat_user']]);
        List<Map> participantSearch = await db.rawQuery(""" SELECT
	tech_chat_participant.uc_room,
  CASE		
		WHEN last_message.sent_on IS NOT NULL THEN last_message.sent_on
		ELSE '1989-01-01 00:00:00'
	END AS sent_on	 
  FROM
    tech_chat_participant
    LEFT JOIN ( SELECT uc_room, MAX( sent_on ) AS sent_on FROM tech_chat_message GROUP BY uc_room ) AS last_message ON tech_chat_participant.uc_room = last_message.uc_room 
  WHERE
    uc_chat_user = ? 
  GROUP BY
    tech_chat_participant.uc_room
  order by sent_on desc
        """, [chatUser['uc_chat_user']]);
        log("participant search $participantSearch");
        if (participantSearch.isNotEmpty) {
          for (Map item in participantSearch) {
            Map tmpConversation = {};
            List<Map> roomSearch = await db.rawQuery(
                """ select * from tech_chat_room where uc_room = ? limit 1 """,
                [item['uc_room']]);
            if (roomSearch.isNotEmpty) {
              Map room = roomSearch.first;
              if (room['status'] == 1) {
                String q = """ select 
                    tech_chat_participant.*,
                    CASE
                      WHEN tech_user.uc IS NOT NULL THEN tech_user.full_name
                      WHEN tech_instructor.uc IS NOT NULL THEN tech_instructor.full_name
                      ELSE "-"
                    END AS room_name,
                    CASE
                      WHEN tech_user.uc IS NOT NULL THEN "user"
                      WHEN tech_instructor.uc IS NOT NULL THEN "lecturer"
                      ELSE NULL
                    END AS room_type,                    
                    tech_instructor.uc as instructor_uc 
                    from tech_chat_participant 
                    left join tech_chat_user on tech_chat_participant.uc_chat_user = tech_chat_user.uc_chat_user
                    left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
                    left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc                     
                    where tech_chat_participant.uc_room = ? and tech_chat_participant.uc_chat_user != ?""";
                List<Map> memberSearch = await db
                    .rawQuery(q, [item['uc_room'], chatUser['uc_chat_user']]);
                if (memberSearch.isNotEmpty) {
                  log("member search $memberSearch");
                  for (Map item in memberSearch) {
                    // Map member = memberSearch.first;
                    Map member = item;
                    tmpConversation['uc_chat_user'] = member['uc_chat_user'];
                    tmpConversation['uc_room'] = room['uc_room'];
                    tmpConversation['room_name'] = member['room_name'];
                    tmpConversation['room_type'] = member['room_type'];
                    tmpConversation['room_status'] = 1;
                    tmpConversation['room_name_short'] =
                        tmpConversation['room_name'][0];
                    if (instructorSign != "0" &&
                        instructorSign == member['instructor_uc']) {
                      manualAdd = false;
                    }
                  }
                }
              } else {
                tmpConversation['uc_chat_user'] = null;
                tmpConversation['uc_room'] = room['uc_room'];
                tmpConversation['room_name'] = room['room_name'];
                tmpConversation['room_type'] = "group";
                tmpConversation['room_status'] = 2;
                tmpConversation['room_name_short'] =
                    tmpConversation['room_name'][0];
              }
              converstationList.add(tmpConversation);
            }
          }
        }
        // converstationList = [];
        if (converstationList.isEmpty || manualAdd == true) {
          log("Add One Manualy");
          // Map tmpConversation = {};

          // if (userData['status'] == true &&
          //     userData['data']['sign_uc_local'] != null) {
          //   Map signData = await SignRepository.getData(
          //       localSignUc: userData['data']['sign_uc_local']);
          //   log("SignOK $signData");
          //   if (signData['status'] == true &&
          //       signData['data']['instructorUc'] != null) {
          //     List<Map> lecturerSearch = await db.rawQuery(""" SELECT
          //           tech_instructor.full_name AS 'full_name',
          //           tech_chat_user.uc_chat_user AS 'uc_chat_user'
          //         FROM
          //           tech_instructor join tech_chat_user ON tech_instructor.uc = tech_chat_user.tech_instructor_uc
          //         where tech_instructor.uc = ? limit 1 """,
          //         [signData['data']['instructorUc']]);
          //     log("Lecturer $lecturerSearch");
          //     if (lecturerSearch.isNotEmpty) {
          //       Map lecturer = lecturerSearch.first;
          //       tmpConversation['uc_chat_user'] = lecturer['uc_chat_user'];
          //       tmpConversation['uc_room'] = null;
          //       tmpConversation['room_name'] = lecturer['full_name'];
          //       tmpConversation['room_type'] = "lecturer";
          //       tmpConversation['room_name_short'] =
          //           tmpConversation['room_name'][0];
          //       converstationList.insert(0, tmpConversation);
          //     }
          //   }
          // }
        } else {
          log("Conv Not Empty");
        }
      });
      log("Clist $converstationList");
      finalRes['conversations'] = converstationList;
      finalRes['status'] = true;
    }
    // catch (e) {
    //   log("errror ${e.toString()}");
    //   finalRes['status'] = false;
    // }
    finally {
      mydb.transaction = null;
    }

    return finalRes;
  }

  static Future<Map> staticCheckRoom({required String room}) async {
    log("Check Room");
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;

    try {
      await dbx.transaction((db) async {
        mydb.transaction = db;

        // Cek apakah room sudah ada di database
        List findRoom = await db.rawQuery(
          """ select * from tech_chat_room where uc_room = ? limit 1 """,
          [room],
        );

        if (findRoom.isEmpty) {
          // Gunakan safeApiCall untuk request
          await BaseClient.safeApiCall(
            "chat/getroom",
            RequestType.get,
            queryParameters: {"ucroom": room},
            onSuccess: (response) async {
              Map resData = response.data;
              Map roomres = resData['room'];
              List participant = resData['participant'];

              // Insert data room ke database
              await db.rawInsert("""
              insert into tech_chat_room ('uc_room','active','status','created_by','created_on')
              values (?,?,?,?,?)
             """, [
                roomres['uc_room'],
                roomres['active'],
                roomres['status'],
                roomres['created_by'],
                roomres['created_on']
              ]);

              // Insert participants ke database
              for (Map temp in participant) {
                await db.rawInsert(
                    """ insert into tech_chat_participant values (?,?) """,
                    [temp['uc_room'], temp['uc_chat_user']]);
              }

              log("Check Room New Insert");
              finalRes['status'] = true;
            },
            onError: (error) {
              // Tangani error jika API call gagal
              log("Error fetching room data: ${error.message}");
              finalRes['status'] = false;
            },
          );
        } else {
          log("Room already exists in database");
        }
      });
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
      await dbx.execute("""PRAGMA foreign_keys = 1""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 1""");
    }
    return finalRes;
  }

  Future<Map> getNewMessage(
      {required String room, String? sender, String? sendername}) async {
    log("== chat phase Get New MEssage");
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      await dbx.execute("""PRAGMA foreign_keys = 0""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 0""");
      await dbx.transaction((db) async {
        mydb.transaction = db;
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;
        List findChatUser = await db.rawQuery(
            """ select * from tech_chat_user where tech_user_uc = ? limit 1 """,
            [userUc]);
        if (findChatUser.isEmpty) {
          throw ("not chat user");
        }
        Map chatUser = findChatUser.first;
        String chatUserUc = chatUser['uc_chat_user'];

        // Register new chat user if not exist
        if (sender != null) {
          List findChatSender = await db.rawQuery(
              """ select * from tech_chat_user where uc_chat_user = ? limit 1 """,
              [sender]);
          if (findChatSender.isEmpty) {
            await db.rawInsert(
                """ insert into tech_chat_user values (?,?,?,?) """,
                [sender, null, null, sendername]);
          }
        }
        List<Map> findLastMessage = await db.rawQuery(
            """ select * from tech_chat_message where uc_room = ? order by sent_on desc limit 1 """,
            [room]);

        Map<String, dynamic> formDataMap = {
          "room": room,
        };

        if (findLastMessage.isNotEmpty) {
          Map lastMessage = findLastMessage.first;
          formDataMap['last'] = lastMessage['sent_on'];
        }
        FormData formData = FormData.fromMap(formDataMap);

        // Call the API using safeApiCall
        await BaseClient.safeApiCall(
          "chat/newmessage",
          RequestType.post,
          data: formData,
          onSuccess: (response) async {
            log("== chat phase 7a DIO $response");
            Map newMessages = {};
            List<String> newMessageKeys = [];
            if (response.data['status'] == true &&
                response.data.containsKey("new_messages")) {
              var formatDate = DateFormat("y-MM-dd");
              var fromatTime = DateFormat("HH:mm:ss");
              for (Map item in response.data['new_messages']) {
                List<Map> findMessage = await db.rawQuery(
                    """ select * from tech_chat_message where uc_message = ? limit 1 """,
                    [item['uc_message']]);
                if (findMessage.isEmpty) {
                  await db.rawInsert(
                      """ insert into tech_chat_message values(?,?,?,?,?,?,?) """,
                      [
                        item['uc_message'],
                        item['uc_room'],
                        item['uc_chat_user'],
                        item['message'],
                        item['media'],
                        item['sent_on'],
                        item['status']
                      ]);
                } else {
                  await db.rawUpdate(""" update tech_chat_message 
                      set 
                        uc_room = ?,
                        uc_chat_user = ?,
                        message = ?,
                        media = ?,
                        sent_on = ?,
                        status = ?
                        where uc_message = ?
                    """, [
                    item['uc_room'],
                    item['uc_chat_user'],
                    item['message'],
                    item['media'],
                    item['sent_on'],
                    item['status'],
                    item['uc_message']
                  ]);
                }
                DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
                int key = sentOn.microsecondsSinceEpoch;

                List<Map> findChatUser = await db.rawQuery(""" 
                select 
                tech_chat_message.uc_chat_user as uc_chat_user,
                CASE 
                    WHEN tech_user.full_name is not null THEN tech_user.full_name
                    WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
                    ELSE tech_chat_user.full_name
                END as full_name
                from tech_chat_message
                left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
                left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
                left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
                where tech_user_uc = ? 
                limit 1 
              """, [item['uc_chat_user']]);
                String sender = "0";
                if (findChatUser.isNotEmpty) {
                  sender = findChatUser.first['uc_chat_user'];
                }
                log("== chat phase 7b $key $item");
                newMessages[key] = {
                  "isMe": chatUserUc == item['uc_chat_user'] ? true : false,
                  "sender": sender,
                  "message": item['message'],
                  "date": formatDate.format(sentOn),
                  "time": fromatTime.format(sentOn),
                  "status": item['status']
                };

                //TODO: RECEIVE STATUS SENT FROM HERE
                if (int.parse(item['status']) < 2) {
                  newMessageKeys.add(item['uc_message']);
                }
              }
              if (newMessageKeys.isNotEmpty) {
                Map<String, dynamic> formDataMapUpdate = {
                  "messagesids[]": newMessageKeys,
                  "status": 2,
                  "room": room,
                  "from": chatUser['uc_chat_user']
                };
                FormData formData2 = FormData.fromMap(formDataMapUpdate);

                // Call the API using safeApiCall
                await BaseClient.safeApiCall(
                  "chat/updatestatus",
                  RequestType.post,
                  data: formData2,
                  onSuccess: (response2) {
                    log("== chat phase 10a update status $response2");
                  },
                  onError: (error) {
                    log("Error updating status: ${error.message}");
                  },
                );
              }
            }
          },
          onError: (error) {
            log("Error fetching new messages: ${error.message}");
          },
        );
      });
      finalRes['status'] = true;
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
      await dbx.execute("""PRAGMA foreign_keys = 1""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 1""");
    }
    return finalRes;
  }

  static Future<Map> staticGetNewMessage(
      {required String room, String? sender, String? sendername}) async {
    log("Get New MEssage");
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;

    try {
      await dbx.execute("""PRAGMA foreign_keys = 0""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 0""");
      await dbx.transaction((db) async {
        mydb.transaction = db;
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;
        List findChatUser = await db.rawQuery(
            """ select * from tech_chat_user where tech_user_uc = ? limit 1 """,
            [userUc]);
        if (findChatUser.isEmpty) {
          throw ("not chat user");
        }
        Map chatUser = findChatUser.first;
        String chatUserUc = chatUser['uc_chat_user'];

        if (sender != null) {
          List findChatSender = await db.rawQuery(
              """ select * from tech_chat_user where uc_chat_user = ? limit 1 """,
              [sender]);
          if (findChatSender.isEmpty) {
            await db.rawInsert(
                """ insert into tech_chat_user values (?,?,?,?) """,
                [sender, null, null, sendername]);
          }
        }

        Map token = await UserRepository.getToken(uc: userUc);
        Dio dio = await MyDio.getDio(
            token: token['token'], refreshToken: token['refreshToken']);
        List<Map> findLastMessage = await db.rawQuery(
            """ select * from tech_chat_message where uc_room = ? order by sent_on desc limit 1 """,
            [room]);

        Map<String, dynamic> formDataMap = {
          "room": room,
          // "from": chatUserUc
        };

        if (findLastMessage.isNotEmpty) {
          Map lastMessage = findLastMessage.first;
          // log("Last $lastMessage");
          formDataMap['last'] = lastMessage['sent_on'];
        }
        FormData formData = FormData.fromMap(formDataMap);
        var response = await dio.post("chat/newmessage", data: formData);
        Map newMessages = {};
        List<String> newMessageKeys = [];
        if (response.data['status'] == true &&
            response.data.containsKey("new_messages")) {
          var formatDate = DateFormat("y-MM-dd");
          var fromatTime = DateFormat("HH:mm:ss");
          for (Map item in response.data['new_messages']) {
            List<Map> findMessage = await db.rawQuery(
                """ select * from tech_chat_message where uc_message = ? limit 1 """,
                [item['uc_message']]);
            if (findMessage.isEmpty) {
              await db.rawInsert(
                  """ insert into tech_chat_message values(?,?,?,?,?,?,?) """,
                  [
                    item['uc_message'],
                    item['uc_room'],
                    item['uc_chat_user'],
                    item['message'],
                    item['media'],
                    item['sent_on'],
                    item['status']
                  ]);
            } else {
              await db.rawUpdate(""" update tech_chat_message 
                    set 
                      uc_room = ?,
                      uc_chat_user = ?,
                      message = ?,
                      media = ?,
                      sent_on = ?,
                      status = ?
                      where uc_message = ?
                  """, [
                item['uc_room'],
                item['uc_chat_user'],
                item['message'],
                item['media'],
                item['sent_on'],
                item['status'],
                item['uc_message']
              ]);
            }
            DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
            int key = sentOn.microsecondsSinceEpoch;
            // log("key $key $item");
            List<Map> findChatUser = await db.rawQuery(""" 
              select 
              tech_chat_message.uc_chat_user as uc_chat_user,
              CASE 
                  WHEN tech_user.full_name is not null THEN tech_user.full_name
                  WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
                  ELSE tech_chat_user.full_name
              END as full_name
              from tech_chat_message
              left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
              left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
              left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
              where tech_user_uc = ? 
              limit 1 
            """, [item['uc_chat_user']]);
            String sender = "0";
            if (findChatUser.isNotEmpty) {
              sender = findChatUser.first['uc_chat_user'];
            }
            newMessages[key] = {
              "isMe": chatUserUc == item['uc_chat_user'] ? true : false,
              "sender": sender,
              "message": item['message'],
              "date": formatDate.format(sentOn),
              "time": fromatTime.format(sentOn),
              "status": item['status']
            };

            //TODO: RECEIVE STATUS SENT FROM HERE
            if (int.parse(item['status']) < 2) {
              newMessageKeys.add(item['uc_message']);
            }
          }
          if (newMessageKeys.isNotEmpty) {
            Map<String, dynamic> formDataMapUpdate = {
              "messagesids[]": newMessageKeys,
              "status": 2,
              "room": room,
              "from": chatUser['uc_chat_user']
            };
            FormData formData2 = FormData.fromMap(formDataMapUpdate);
            var response2 =
                await dio.post("chat/updatestatus", data: formData2);
            log("== chat phase 10b update status  $response2");
          }
        }
      });
      finalRes['status'] = true;
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } finally {
      mydb.transaction = null;
      await dbx.execute("""PRAGMA foreign_keys = 1""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 1""");
    }
    return finalRes;
  }

  // static Future<Map> createRoom(
  //     {required String to, String name = "", String description = ""}) async {
  //   Map finalRes = {"status": false};
  //   return finalRes;
  // }

  Future<Map> saveBeforeSend(
      {String? ucRoom,
      String? ucTo,
      required String message,
      bool getNew = true}) async {
    Map finalRes = {"status": false};
    bool con = await ConnectionTest.check();
    if (con == false) {
      finalRes['status'] = false;
      finalRes['message'] = "Cannot Reach Server";
      return finalRes;
    }
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      await dbx.execute("""PRAGMA foreign_keys = 0""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 0""");
      await dbx.transaction((db) async {
        mydb.transaction = db;

        List findChatUser = await db.rawQuery(
            """ select * from tech_chat_user where tech_user_uc = ? limit 1 """,
            [userUc]);
        if (findChatUser.isNotEmpty) {
          Map chatUser = findChatUser.first;
          String chatUserUc = chatUser['uc_chat_user'];

          log("test room $ucRoom, ucTo $ucTo, message $message");
          Map token = await UserRepository.getToken(uc: userUc);
          Dio dio = await MyDio.getDio(
              token: token['token'], refreshToken: token['refreshToken']);
          Map<String, dynamic> formDataMap = {
            "message": message,
            "to": ucTo,
            "room": ucRoom,
            "from": chatUserUc
          };
          if (getNew == true && ucRoom != null) {
            List<Map> findLastMessage = await db.rawQuery(""" select 
                    tech_chat_message.uc_message as uc_message,
                    tech_chat_message.uc_room as uc_room,
                    tech_chat_message.uc_chat_user as uc_chat_user,
                    tech_chat_message.message as message,
                    tech_chat_message.media as media,
                    tech_chat_message.sent_on as sent_on,
                    tech_chat_message.status as status,
                    CASE 
                      WHEN tech_user.full_name is not null THEN tech_user.full_name
                      WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
                      ELSE tech_chat_user.full_name
                    END as full_name
                    from tech_chat_message 
                    left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
                    left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
                    left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
                    where tech_chat_message.uc_room = ? order by sent_on desc limit 1 """,
                [ucRoom]);
            if (findLastMessage.isNotEmpty) {
              Map lastMessage = findLastMessage.first;
              // log("Last $lastMessage");
              formDataMap['lastMsg'] = lastMessage['sent_on'];
            }
            // log("last nooo $findLastMessage");
          }
          // MultipartFileExtended.fromFileSync(imagePath);
          FormData formData = FormData.fromMap(formDataMap);
          var response = await dio.post("chat/send", data: formData);
          log("response send chat $response");
          if (ucRoom == "" && response.data['status'] == true) {
            String roomUc = response.data['message_data']['uc_room'];
            String sentOn = response.data['message_data']['sent_on'];
            finalRes['room'] = roomUc;
            await db.rawInsert(""" 
            insert into tech_chat_room ('uc_room','active','status','created_by','created_on')
            values (?,?,?,?,?)
             """, [roomUc, 1, 1, chatUserUc, sentOn]);
            log("insert room");
            if (response.data.containsKey("participant")) {
              for (Map temp in response.data["participant"]) {
                List<Map> tres = await db.rawQuery(
                    """ select uc_room from tech_chat_participant where uc_room = ? and uc_chat_user = ? limit 1""",
                    [roomUc, temp['uc_chat_user']]);
                if (tres.isEmpty) {
                  log("insert participant $temp");
                  await db.rawInsert(
                      """ insert into tech_chat_participant values (?,?) """,
                      [roomUc, temp['uc_chat_user']]);
                }
              }
            }
          }

          if (response.data['status'] == true) {
            String msgId = response.data['message_data']['uc_message'];
            String roomUc = response.data['message_data']['uc_room'];
            String chatUser = response.data['message_data']['uc_chat_user'];
            String message = response.data['message_data']['message'];
            finalRes['room'] = roomUc;
            finalRes['new_messages'] = {};
            if (response.data.containsKey('new_messages')) {
              var formatDate = DateFormat("y-MM-dd");
              var fromatTime = DateFormat("HH:mm:ss");
              List newMessages = response.data['new_messages'];
              Map newMessagesMaped = {};
              for (Map item in newMessages) {
                List<Map> findMessage = await db.rawQuery(
                    """ select * from tech_chat_message where uc_message = ? limit 1 """,
                    [item['uc_message']]);
                if (findMessage.isEmpty) {
                  await db.rawInsert(
                      """ insert into tech_chat_message values(?,?,?,?,?,?,?) """,
                      [
                        item['uc_message'],
                        item['uc_room'],
                        item['uc_chat_user'],
                        item['message'],
                        item['media'],
                        item['sent_on'],
                        item['status']
                      ]);
                } else {
                  await db.rawUpdate(""" update tech_chat_message 
                    set 
                      uc_room = ?,
                      uc_chat_user = ?,
                      message = ?,
                      media = ?,
                      sent_on = ?,
                      status = ?
                      where uc_message = ?
                  """, [
                    item['uc_room'],
                    item['uc_chat_user'],
                    item['message'],
                    item['media'],
                    item['sent_on'],
                    item['status'],
                    item['uc_message']
                  ]);
                }
                DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
                int key = sentOn.microsecondsSinceEpoch;
                // log("key $key $item");
                int status = 0;
                if (item['status'] is String) {
                  status = int.parse(item['status']);
                } else {
                  status = item['status'];
                }
                List<Map> messageInfoList = await db.rawQuery(""" select 
                    tech_chat_message.uc_chat_user as uc_chat_user,
                    CASE 
                      WHEN tech_user.full_name is not null THEN tech_user.full_name
                      WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
                      ELSE tech_chat_user.full_name
                    END as full_name
                    from tech_chat_message 
                    left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
                    left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
                    left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
                    where tech_chat_message.uc_message = ? limit 1 """,
                    [item['uc_message']]);
                String? name;
                if (messageInfoList.isNotEmpty) {
                  Map messageInfo = messageInfoList.first;
                  name = messageInfo['full_name'];
                }

                newMessagesMaped[key] = {
                  "isMe": chatUserUc == item['uc_chat_user'] ? true : false,
                  "sender": item['uc_chat_user'],
                  "message": item['message'],
                  "date": formatDate.format(sentOn),
                  "time": fromatTime.format(sentOn),
                  "status": status,
                  "name": name
                };

                if (newMessagesMaped[key]['isMe'] == true) {
                  newMessagesMaped[key]['name'] = null;
                }
              }
              finalRes['new_messages'] = newMessagesMaped;
            }
            String? media;
            if (response.data['message_data']['media'] != null) {
              media = response.data['message_data']['media'];
            }
            String sentOn = response.data['message_data']['sent_on'];
            int status = response.data['message_data']['status'];
            // log("insert msg");
            // await db.rawInsert("""
            // insert into tech_chat_message ('uc_message','uc_room','uc_chat_user','message','media','sent_on', 'status')
            // values (?,?,?,?,?,?,?)
            //  """, [msgId, roomUc, chatUser, message, media, sentOn, status]);
            Map tmp = {};
            tmp['message_id'] = msgId;
            tmp['uc_room'] = roomUc;
            tmp['uc_chat_user'] = chatUser;
            tmp['message'] = message;
            tmp['media'] = media;
            tmp['sent_on'] = sentOn;

            DateTime parsed = DateTime.parse('${sentOn}Z');
            // DateTime parsedLocal = DateTime.parse('${sentOn}');
            int unix = parsed.millisecondsSinceEpoch;
            tmp['sent_stamp'] = unix;
            // var format = DateFormat.yMd().addPattern("H:m:s");
            var format = DateFormat.yMd().addPattern("HH:mm:ss");
            tmp['sent_on_ltime'] = format.format(parsed);
            var formatDate = DateFormat("y-MM-dd");
            var fromatTime = DateFormat("HH:mm:ss");
            tmp['sent_on_date'] = formatDate.format(parsed);
            tmp['sent_on_time'] = fromatTime.format(parsed);
            tmp['message_status'] = status;
            finalRes['message'] = tmp;
            finalRes['status'] = true;
          }
          log("response send $response");
        }
      });
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    }
    // catch (e) {
    //   log("ERR $e");
    //   finalRes['status'] = false;
    // }
    finally {
      mydb.transaction = null;
      await dbx.execute("""PRAGMA foreign_keys = 1""");
      await dbx.execute("""PRAGMA ignore_check_constraints = 1""");
    }
    return finalRes;
  }

  Future<Map> loadMessages({String last = "", required String ucRoom}) async {
    Map finalRes = {"status": false};
    if (ucRoom == "") {
      finalRes['status'] = true;
      finalRes['messages'] = {};
    }
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;

      var format = DateFormat("y-MM-dd HH:mm:ss");
      DateTime ctime;
      if (last == "") {
        ctime = DateTime.now().toUtc();
      } else {
        ctime = DateTime.parse("${last}Z");
      }
      String ctimeStr = format.format(ctime);
      Map messages = {};
      await dbx.transaction((db) async {
        List<Map> findChatUser = await db.rawQuery(""" 
          select 
           tech_chat_user.uc_chat_user as uc_chat_user,
           tech_chat_user.tech_user_uc as tech_user_uc,
           tech_chat_user.tech_instructor_uc as tech_instructor_uc,
           CASE 
              WHEN tech_user.full_name is not null THEN tech_user.full_name
              WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
              ELSE tech_chat_user.full_name
           END as full_name
           from tech_chat_user 
           left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
           left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
           where tech_user_uc = ? 
           limit 1 
        """, [userUc]);
        if (findChatUser.isEmpty) {
          throw ("not chat user");
        }
        Map chatUser = findChatUser.first;
        mydb.transaction = db;
        List<Map> findMessages = [];
        if (last == "") {
          findMessages = await db.rawQuery(""" 
          select 
            tech_chat_message.uc_message as uc_message,
            tech_chat_message.uc_room as uc_room,
            tech_chat_message.uc_chat_user as uc_chat_user,
            tech_chat_message.message as message,
            tech_chat_message.media as media,
            tech_chat_message.sent_on as sent_on,
            tech_chat_message.status as status,
            CASE 
              WHEN tech_user.full_name is not null THEN tech_user.full_name
              WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
              ELSE tech_chat_user.full_name
            END as full_name
          from tech_chat_message 
          left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
          left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
          left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
          where tech_chat_message.uc_room = ? order by tech_chat_message.sent_on desc limit 50
        """, [ucRoom]);

          // log(""" select * from tech_chat_message where uc_room = $ucRoom order by sent_on desc limit 50 """);
        } else {
          findMessages = await db.rawQuery(""" 
          select 
            tech_chat_message.uc_message as uc_message,
            tech_chat_message.uc_room as uc_room,
            tech_chat_message.uc_chat_user as uc_chat_user,
            tech_chat_message.message as message,
            tech_chat_message.media as media,
            tech_chat_message.sent_on as sent_on,
            tech_chat_message.status as status,
            CASE 
              WHEN tech_user.full_name is not null THEN tech_user.full_name
              WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
              ELSE tech_chat_user.full_name
            END as full_name
          from tech_chat_message 
          left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
          left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
          left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
          where tech_chat_message.uc_room = ? and tech_chat_message.sent_on <= ? order by tech_chat_message.sent_on desc limit 50
        """, [ucRoom, ctimeStr]);

          // log(""" select * from tech_chat_message where uc_room = $ucRoom and sent_on <= $ctimeStr order by sent_on desc limit 50 """);
        }
        var formatDate = DateFormat("y-MM-dd");
        var fromatTime = DateFormat("HH:mm:ss");
        List<String> deleteUpdate = [];
        if (findMessages.isNotEmpty) {
          for (Map item in findMessages) {
            bool isMe = false;
            if (item['uc_chat_user'] == chatUser['uc_chat_user']) {
              isMe = true;
            }
            DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
            int key = sentOn.microsecondsSinceEpoch;
            // log("key $key $item");
            messages[key] = {
              "isMe": isMe,
              "sender": item['uc_chat_user'],
              "message": item['message'],
              "date": formatDate.format(sentOn),
              "time": fromatTime.format(sentOn),
              "status": item['status'],
              "name": item['full_name']
            };
            if (isMe == true) {
              messages[key]['name'] = null;
            }
            deleteUpdate.add(item['uc_message']);
          }
        }
        if (deleteUpdate.isNotEmpty) {
          String placeHold = List.filled(deleteUpdate.length, '?').join(',');
          await db.rawDelete(
              """ delete from tech_chat_update where uc_message in ($placeHold) """,
              [...deleteUpdate]);
        }

        Map newmap = {};
        for (int _key in messages.keys.toList().reversed) {
          newmap[_key] = messages[_key];
        }

        // log("msg $messages");
        finalRes['status'] = true;
        finalRes['messages'] = newmap;
      });
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future<Map> loadUpdatedMessage({required String room}) async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    Map updateMessage = {};
    // log("load updated in room $room");
    try {
      await dbx.transaction((db) async {
        mydb.transaction = db;
        // String placeHold = List.filled(messageIds.length, '?').join(',');
        List<Map> findUpdatedMessages = await db
            .rawQuery(""" select tech_chat_message.* from tech_chat_message 
          join tech_chat_update on tech_chat_message.uc_message = tech_chat_update.uc_message 
          where tech_chat_message.uc_room = ?""", [room]);
        // log("found updated message $findUpdatedMessages");
        if (findUpdatedMessages.isNotEmpty) {
          // var formatDate = DateFormat("y-MM-dd");
          // var fromatTime = DateFormat("HH:mm:ss");

          List<String> deleteUpdate = [];
          for (Map item in findUpdatedMessages) {
            DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
            int key = sentOn.microsecondsSinceEpoch;
            updateMessage[key] = {
              "status": item['status'],
              'uc_message': item['uc_message']
            };
            deleteUpdate.add(item['uc_message']);
          }
          if (deleteUpdate.isNotEmpty) {
            String placeHold = List.filled(deleteUpdate.length, '?').join(',');
            await db.rawDelete(
                """ delete from tech_chat_update where uc_message in ($placeHold) """,
                [...deleteUpdate]);
          }
          finalRes['updatedMessage'] = updateMessage;
          finalRes['status'] = true;
        }

        // Check if new message
      });
    } finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future<Map> loadNewMessage(
      {required String last, required String room}) async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    Map messages = {};
    try {
      await dbx.transaction((db) async {
        mydb.transaction = db;
        final prefs = await SharedPreferences.getInstance();
        String userUc = prefs.getString('userUc')!;
        List<Map> findChatUser = await db.rawQuery(""" 
          select * from tech_chat_user where tech_user_uc = ? limit 1 
        """, [userUc]);
        if (findChatUser.isEmpty) {
          throw ("not chat user");
        }
        Map chatUser = findChatUser.first;

        List<Map> findMessages = [];
        findMessages = await db.rawQuery("""
          select 
            tech_chat_message.uc_message as uc_message,
            tech_chat_message.uc_room as uc_room,
            tech_chat_message.uc_chat_user as uc_chat_user,
            tech_chat_message.message as message,
            tech_chat_message.media as media,
            tech_chat_message.sent_on as sent_on,
            tech_chat_message.status as status,
            CASE 
              WHEN tech_user.full_name is not null THEN tech_user.full_name
              WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
              ELSE tech_chat_user.full_name
            END as full_name
          from tech_chat_message 
          left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
          left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
          left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc
          where tech_chat_message.uc_room = ? and tech_chat_message.sent_on > ? order by tech_chat_message.sent_on asc
        """, [room, last]);
        var formatDate = DateFormat("y-MM-dd");
        var fromatTime = DateFormat("HH:mm:ss");
        if (findMessages.isNotEmpty) {
          for (Map item in findMessages) {
            log("Items Message $item");
            bool isMe = false;
            if (item['uc_chat_user'] == chatUser['uc_chat_user']) {
              isMe = true;
            }
            DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
            int key = sentOn.microsecondsSinceEpoch;
            // log("key $key $item");
            messages[key] = {
              "isMe": isMe,
              "sender": item['uc_chat_user'],
              "message": item['message'],
              "date": formatDate.format(sentOn),
              "time": fromatTime.format(sentOn),
              "status": item['status'],
              "name": item['full_name']
            };
            if (isMe == true) {
              messages[key]['name'] = null;
            }
          }
        }
      });
      finalRes['new_messages'] = messages;
      finalRes['status'] = true;
    }
    // catch (e) {
    //   finalRes['status'] = false;
    // }
    finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future<Map?> getChatUser({String? uc}) async {
    MyDatabase mydb = MyDatabase.instance;
    Database db = await mydb.database;
    List findChatUser = [];
    findChatUser = await db.rawQuery(
        """ select * from tech_chat_user where tech_user_uc = ? limit 1 """,
        [uc]);
    if (findChatUser.isEmpty) {
      findChatUser = await db.rawQuery(
          """ select * from tech_chat_user where tech_instructor_uc = ? limit 1 """,
          [uc]);
    }

    if (findChatUser.isEmpty) {
      return null;
    } else {
      return findChatUser.first;
    }
  }

  Future<Map> saveToken({String fcmtoken = ""}) async {
    Map finalRes = {"status": false};
    try {
      MyDatabase mydb = MyDatabase.instance;
      Database db = await mydb.database;
      // MultipartFileExtended.fromFileSync(imagePath);
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;

      Map? chatUser = await getChatUser(uc: userUc);
      if (chatUser == null) {
      } else {
        Map<String, dynamic> formDataMap = {
          "token": fcmtoken,
          "chatUc": chatUser['uc_chat_user']
        };

        FormData formData = FormData.fromMap(formDataMap);
        Map token = await UserRepository.getToken(uc: chatUser['uc_chat_user']);
        Dio dio = await MyDio.getDio(
            token: token['token'], refreshToken: token['refreshToken']);
        await dio.post("chat/savetoken", data: formData);
        prefs.setString("fcmToken", fcmtoken);
      }
      finalRes['status'] = true;
    } on DioError catch (e) {
      log("ERR ${e.response}");
      finalRes['status'] = false;
    } catch (e) {
      log("ERR $e");
      finalRes['status'] = false;
    }
    return finalRes;
  }

  Future<Map> updateStatus(
      {List<String> messagesId = const [],
      required int status,
      required String room}) async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    try {
      await dbx.transaction((db) async {
        if (messagesId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          String userUc = prefs.getString('userUc')!;
          List<Map> findChatUser = await db.rawQuery(""" 
          select * from tech_chat_user where tech_user_uc = ? limit 1 
        """, [userUc]);
          if (findChatUser.isEmpty) {
            throw ("not chat user");
          }
          Map chatUser = findChatUser.first;
          String placeHold = List.filled(messagesId.length, '?').join(',');
          await db.rawUpdate(
              """ update tech_chat_message set status = ? where uc_message in ($placeHold) and status < ?""",
              [status, ...messagesId, status]);
          // List<Map> updatedMessage = await db.rawQuery(
          //     """ select * from tech_chat_message where uc_message in ($placeHold) and uc_room = ?""",
          //     [...messagesId, room]);
          List<Map> updatedMessage = await db.rawQuery("""select 
            tech_chat_message.uc_message as uc_message,
            tech_chat_message.uc_room as uc_room,
            tech_chat_message.uc_chat_user as uc_chat_user,
            tech_chat_message.message as message,
            tech_chat_message.media as media,
            tech_chat_message.sent_on as sent_on,
            tech_chat_message.status as status,
            CASE 
              WHEN tech_user.full_name is not null THEN tech_user.full_name
              WHEN tech_instructor.full_name is not null THEN tech_instructor.full_name
              ELSE tech_chat_user.full_name
            END as full_name
          from tech_chat_message 
          left join tech_chat_user on tech_chat_message.uc_chat_user = tech_chat_user.uc_chat_user
          left join tech_user on tech_chat_user.tech_user_uc = tech_user.uc
          left join tech_instructor on tech_chat_user.tech_instructor_uc = tech_instructor.uc 
          where tech_chat_message.uc_message in ($placeHold) and tech_chat_message.uc_room = ?""",
              [...messagesId, room]);
          Map updated = {};
          var formatDate = DateFormat("y-MM-dd");
          var fromatTime = DateFormat("HH:mm:ss");
          if (updatedMessage.isNotEmpty) {
            for (Map item in updatedMessage) {
              DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
              int key = sentOn.microsecondsSinceEpoch;
              bool isMe = false;
              if (item['uc_chat_user'] == chatUser['uc_chat_user']) {
                isMe = true;
              }
              // updated[key] = {'status': item['status']};
              updated[key] = {
                "isMe": isMe,
                "sender": item['uc_chat_user'],
                "message": item['message'],
                "date": formatDate.format(sentOn),
                "time": fromatTime.format(sentOn),
                "status": item['status'],
                "name": item['full_name'],
              };
            }
          }
          if (updated.isNotEmpty) {
            finalRes['updated'] = updated;
          }
          finalRes['status'] = true;
        }
      });
    }
    // catch (e) {
    //   finalRes['status'] = false;
    // }
    finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  static Future<Map> staticUpdateStatus(
      {List<String> messagesId = const [],
      required int status,
      required String room}) async {
    Map finalRes = {"status": false};
    MyDatabase mydb = MyDatabase.instance;
    Database dbx = await mydb.database;
    log("== chat phase 10aa static update status");
    try {
      await dbx.transaction((db) async {
        if (messagesId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          String userUc = prefs.getString('userUc')!;
          List<Map> findChatUser = await db.rawQuery(""" 
          select * from tech_chat_user where tech_user_uc = ? limit 1 
        """, [userUc]);
          if (findChatUser.isEmpty) {
            throw ("not chat user");
          }
          // Map chatUser = findChatUser.first;
          String placeHold = List.filled(messagesId.length, '?').join(',');
          await db.rawUpdate(
              """ update tech_chat_message set status = ? where uc_message in ($placeHold) and status < ?""",
              [status, ...messagesId, status]);
          List<Map> updatedMessage = await db.rawQuery(
              """ select * from tech_chat_message where uc_message in ($placeHold) and uc_room = ?""",
              [...messagesId, room]);
          // List<String> updatedKeys = [];
          // List<String> pendUpdateKeys =
          //     prefs.getStringList("updateMessageKeys") ?? [];
          // updatedKeys.addAll(pendUpdateKeys);
          if (updatedMessage.isNotEmpty) {
            for (Map item in updatedMessage) {
              // DateTime sentOn = DateTime.parse("${item['sent_on']}Z");
              // int key = sentOn.microsecondsSinceEpoch;
              // updated[key] = {'status': item['status']};
              // if (updatedKeys.contains(item['uc_message'])) {
              // } else {
              //   updatedKeys.add(item['uc_message']);
              // }
              await db.rawInsert("insert into tech_chat_update values (?)",
                  [item['uc_message']]);
            }
          }
          log("update from notif $messagesId from selectiion $updatedMessage");
          finalRes['status'] = true;
        }
      });
    }
    // catch (e) {
    //   finalRes['status'] = false;
    // }
    finally {
      mydb.transaction = null;
    }
    return finalRes;
  }

  Future<Map> getStatus(
      {List<String> messageIds = const [], required String ucRoom}) async {
    Map finalRes = {"status": false};
    try {
      MyDatabase mydb = MyDatabase.instance;
      Database dbx = await mydb.database;
      if (messageIds.isEmpty) {
        throw ("no update");
      }
      String placeHold = List.filled(messageIds.length, '?').join(',');
      List<Map> findUpdateMessage = await dbx.rawQuery(
          """ select * from tech_message_chat where uc_message in ($placeHold) and uc_room = ? """,
          [...messageIds, ucRoom]);
      if (findUpdateMessage.isEmpty) {
        throw ("no update");
      }
      for (Map item in findUpdateMessage) {}
      finalRes["status"] = true;
    } catch (e) {
      log("err get status ${e.toString()}");
      finalRes['status'] = false;
    } finally {}
    return finalRes;
  }

  static Future<Map> joinLecturerGroup(
      {String uc_chat_user = "", String uc_lecturer = "", required db}) async {
    Map ret = {};
    try {
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      Map token = await UserRepository.getToken(uc: userUc);
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);
      List<Map> chatUserList = await db.rawQuery(
          "SELECT * FROM tech_chat_user WHERE tech_user_uc = ? LIMIT 1",
          [userUc]);
      if (chatUserList.isEmpty) {
        throw ("NO USER FOUND IN CHAT");
      }
      Map chatUser = chatUserList.first;

      Map<String, dynamic> formDataMap = {
        "uc_chat_user": chatUser['uc_chat_user'],
        "uc_lecturer": uc_lecturer,
      };
      FormData formData = FormData.fromMap(formDataMap);
      var response = await dio.post("chat/joinLecturerGroup", data: formData);
      if (response.data['status'] == true) {
        List other_rooms = response.data['other_rooms'];
        if (other_rooms.isNotEmpty) {
          other_rooms.insert(0, chatUser['uc_chat_user']);

          // Split the delete operation into batches
          const batchSize = 20;
          for (var i = 0; i < other_rooms.length; i += batchSize) {
            final end = (i + batchSize < other_rooms.length)
                ? i + batchSize
                : other_rooms.length;
            final batchRooms = other_rooms.sublist(i, end);
            String placeholders = List.filled(batchRooms.length, '?').join(',');
            await db.rawDelete(
                "DELETE FROM tech_chat_participant WHERE uc_chat_user = ? AND uc_room IN ($placeholders)",
                [chatUser['uc_chat_user'], ...batchRooms]);
          }
        }

        Map creator = response.data['creator'];
        List<Map> findChatUser = await db.rawQuery(
            "SELECT * FROM tech_chat_user WHERE uc_chat_user = ? LIMIT 1",
            [creator['uc_chat_user']]);
        if (findChatUser.isEmpty) {
          await db.rawInsert("INSERT INTO tech_chat_user VALUES (?,?,?,?)", [
            creator['uc_chat_user'],
            creator['tech_user_uc'],
            creator['tech_instructor_uc'],
            creator['full_name']
          ]);
        }

        Map room = response.data['room'];
        List<Map> findRoom = await db.rawQuery(
            "SELECT * FROM tech_chat_room WHERE uc_room = ? LIMIT 1",
            [room['uc_room']]);
        if (findRoom.isEmpty) {
          await db
              .rawInsert("INSERT INTO tech_chat_room VALUES (?,?,?,?,?,?,?)", [
            room['uc_room'],
            room['room_name'],
            room['room_description'],
            room['active'],
            room['status'],
            room['created_by'],
            room['created_on']
          ]);
        }

        List<Map> findParticipant = await db.rawQuery(
            "SELECT * FROM tech_chat_participant WHERE uc_room = ? AND uc_chat_user = ? LIMIT 1",
            [room['uc_room'], chatUser['uc_chat_user']]);
        if (findParticipant.isEmpty) {
          await db.rawInsert("INSERT INTO tech_chat_participant VALUES (?,?)",
              [room['uc_room'], chatUser['uc_chat_user']]);
        }
      }

      return response.data;
    } on DioError catch (e) {
      log("ERR ${e.response}");
      ret['status'] = false;
    }

    return ret;
  }

  static Future<Map> leaveLecturerGroup(
      {required String ucLecturer, required db}) async {
    Map ret = {};
    try {
      MyDatabase mydb = MyDatabase.instance;
      // var db;
      // if (mydb.transaction != null) {
      //   db = mydb.transaction!;
      // } else {
      //   db = await mydb.database;
      // }
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      Map token = await UserRepository.getToken(uc: userUc);
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);

      List<Map> chatUserList = await db.rawQuery(
          """ select * from tech_chat_user where tech_user_uc = ? limit 1""",
          [userUc]);
      if (chatUserList.isEmpty) {
        throw ("NO USER FOUND IN CHAT");
      }
      Map chatUser = chatUserList.first;

      Map<String, dynamic> formDataMap = {
        "uc_lecturer": ucLecturer,
      };
      FormData formData = FormData.fromMap(formDataMap);
      var response = await dio.post("chat/getlecturergroup", data: formData);

      if (response.data['status'] == true) {
        String room = response.data['room']['uc_room'];
        formDataMap = {
          "uc_room": response.data['room']['uc_room'],
          "uc_chat_user": chatUser['uc_chat_user'],
        };
        formData = FormData.fromMap(formDataMap);
        response = await dio.post("chat/leavegroup", data: formData);
        log("signRepository: remove from group ${response.data}");
        if (response.data['status'] == true) {
          await db.rawDelete(
              """ delete from tech_chat_participant where uc_room = ? and uc_chat_user = ? """,
              [room, chatUser['uc_chat_user']]);
        }
      }
      ret['status'] = true;
    } on DioError catch (e) {
      log("ERR ${e.response}");
      ret['status'] = false;
    }
    return ret;
  }

  static Future<Map> leaveGroup({required String uc_room, required db}) async {
    Map ret = {};
    try {
      // MyDatabase mydb = MyDatabase.instance;
      // var db;
      // if (mydb.transaction != null) {
      //   db = mydb.transaction!;
      // } else {
      //   db = await mydb.database;
      // }
      final prefs = await SharedPreferences.getInstance();
      String userUc = prefs.getString('userUc')!;
      Map token = await UserRepository.getToken(uc: userUc);
      Dio dio = await MyDio.getDio(
          token: token['token'], refreshToken: token['refreshToken']);

      List<Map> chatUserList = await db.rawQuery(
          """ select * from tech_chat_user where tech_user_uc = ? limit 1""",
          [userUc]);
      if (chatUserList.isEmpty) {
        throw ("NO USER FOUND IN CHAT");
      }
      Map chatUser = chatUserList.first;

      Map<String, dynamic> formDataMap = {
        "uc_chat_user": userUc,
        "uc_room": chatUser['uc_chat_user'],
      };
      FormData formData = FormData.fromMap(formDataMap);
      var response = await dio.post("chat/leavegroup", data: formData);
      Map data = response.data;
      if (data['status'] == true) {
        await db.rawDelete(
            """ delete from tech_chat_participant where uc_room = ? and uc_chat_user = ? """,
            [uc_room, chatUser['uc_chat_user']]);
      }
      ret['status'] = true;
    } on DioError catch (e) {
      log("ERR ${e.response}");
      ret['status'] = false;
    }
    return ret;
  }
}
