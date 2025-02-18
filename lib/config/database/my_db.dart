import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// ignore: constant_identifier_names
const USEVERSION = 1;

class MyDatabase {
  static final MyDatabase instance = MyDatabase.init();
  static Database? _database;
  Transaction? transaction;

  MyDatabase.init();

  Future<Database> get database async {
    transaction = null;
    // log("mydb: getting DB $_database");
    if (_database != null) return _database!;
    // log("mydb: reopen DB $_database");
    _database = await initDatabase();
    // log("mydb: reopen done DB $_database");
    return _database!;
  }

  Future<bool> isOpen() async {
  MyDatabase mydb = MyDatabase.instance;
  // Assuming `MyDatabase` has a method `isOpen()` that returns a boolean.
  return await mydb.isOpen();
}

  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var dbpath = p.join(appDocDir.path, "tresea.db");
    // log("DIR ${appDocDir.path} $dbpath");
    var exists = await databaseExists(dbpath);
    if (!exists) {
      // Should happen only the first time you launch your application
      // log("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(p.dirname(dbpath)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(p.join("assets", "pub", "dbs", "tresea.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbpath).writeAsBytes(bytes, flush: true);
    } else {
      // log("Reading Existing Database");
    }
    // log("mydb: OPENING DB");
    Database db =
        await openDatabase(dbpath, readOnly: false, version: USEVERSION);
    await db.execute("PRAGMA foreign_keys=ON");
    return db;
  }

  Future close() async {
    // if (_database != null) {
    //   final db = await instance.database;
    //   _database = null;
    //   log("mydb: CLOSING DB");
    //   db.close();
    // }
  }
  Future close2() async {
    if (_database != null) {
      final db = await instance.database;
      instance.transaction = null;
      // log("mydb: CLOSING DB");
      db.close();
      _database = null;
    }
  }

  Future<bool> close3() async {
  try {
    if (_database != null) {
      final db = await instance.database;
      _database = null;
      // log("mydb: CLOSING DB");
      await db.close();
      return true; // Berhasil menutup database
    }
    return false; // Database sudah ditutup sebelumnya
  } catch (e) {
    print("Error closing database: $e");
    return false; // Gagal menutup database
  }
}
  
}

class MyDatabaseReadOnly {
  static final MyDatabaseReadOnly instance = MyDatabaseReadOnly.init();
  static Database? _database;

  MyDatabaseReadOnly.init();

  Future<Database> get database async {
    // log("mydb: getting DB $_database");
    if (_database != null) return _database!;
    // log("mydb: reopen DB $_database");
    _database = await initDatabase();
    // log("mydb: reopen done DB $_database");
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var dbpath = p.join(appDocDir.path, "tresea.db");
    // log("DIR ${appDocDir.path} $dbpath");
    var exists = await databaseExists(dbpath);
    if (!exists) {
      // Should happen only the first time you launch your application
      // log("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(p.dirname(dbpath)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(p.join("assets", "pub", "dbs", "tresea.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbpath).writeAsBytes(bytes, flush: true);
    } else {
      // log("Reading Existing Database");
    }
    // log("mydb: OPENING DB");
    Database db =
        await openDatabase(dbpath, readOnly: true, version: USEVERSION);
    return db;
  }

  Future close2() async {
    if (_database != null) {
      final db = await instance.database;
      // log("mydb: CLOSING DB");
      db.close();
      _database = null;
    }
  }
}
