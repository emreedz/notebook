import 'dart:io';
import 'dart:typed_data';
import 'package:not_sepeti_proje/models/kategori.dart';
import 'package:not_sepeti_proje/models/notlar.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      return _dataBaseHelper!;
    } else {
      return _dataBaseHelper!;
    }
  }

  DataBaseHelper._internal();

  Future<Database> _getDatabase() async {
    return await _initializeDatabase();
  }

  Future<Database> _initializeDatabase() async {
    late Database _db;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "appDB.db");
    print("OLUSACAK DBNIN PATHI : $path");

    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "Notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    _db = await openDatabase(path, readOnly: false);
    return _db;
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");

    return sonuc;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async{
     var kategorileriIcerenMapListesi = await kategorileriGetir();
     var kategoriListesi =<Kategori>[];
     for(Map<String,dynamic> map in kategorileriIcerenMapListesi){
       kategoriListesi.add(Kategori.fromMap(map));
     }
     return kategoriListesi;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update("kategori", kategori.toMap(),
        where: 'kategoriId=?', whereArgs: [kategori.kategoriId]);

    return sonuc;
  }

  Future<int> kategoriSil(int kategoriId) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete("kategori", where: 'kategoriId=?', whereArgs: [kategoriId]);

    return sonuc;
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery('select * from "not" inner join kategori on kategori.kategoriId = "not".kategorID order by notId DESC;');
    return sonuc;
  }

  Future<List<Not>> notListesiniGetir() async {
    var notlarMapListesi = await notlariGetir();
    var notListesi =<Not>[];
    for(Map<String,dynamic> map in notlarMapListesi){
      notListesi.add(Not.fromMap(map));
    }
    return notListesi;

  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("not", not.toMap());

    return sonuc;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db
        .update("not", not.toMap(), where: 'notId=?', whereArgs: [not.notId]);

    return sonuc;
  }

  Future<int> notSil(int notId) async {
    var db = await _getDatabase();
    var sonuc = await db.delete("not", where: 'notId=?', whereArgs: [notId]);

    return sonuc;
  }

  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
     late String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "??ubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "May??s";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "A??ustos";
        break;
      case 9:
        month = "Eyl??k";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kas??m";
        break;
      case 12:
        month = "Aral??k";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bug??n";
    } else if (difference.compareTo(twoDay) < 1) {
      return "D??n";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Sal??";
        case 3:
          return "??ar??amba";
        case 4:
          return "Per??embe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
