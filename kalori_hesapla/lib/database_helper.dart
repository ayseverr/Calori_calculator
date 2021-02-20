import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kalori_hesapla/gunlukkalori.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  factory DataBaseHelper() {
    /*Buradaki işlemleri internetten aldım
    çalışma mantığı telefonun hafızasında benim verdiğim veritabanı yoksa
      veya bu gun kaydelimişse bu gün dün ise dün yazar.*/

    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper.internal();
      return _dataBaseHelper;
    } else {
      return _dataBaseHelper;
    }
  }

  DataBaseHelper.internal();

  _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "gunluk_kalori.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "gunluk_kalori.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(path,
        readOnly: false); // İnternetten aldığım yerin sonu
  }

  Future<List<Map<String, dynamic>>> gunleriGetir() async {
    // getDatabase ile aldığım db içinde query içinde yazan sql komutunu çalıştırıp
    // Bana map turunde bir liste verir
    var db = await _getDatabase();
    var sonuc = await db.query("gunluk_kalori order by gun_id Desc;");
    return sonuc;
  }

  Future<List<GunKalori>> gunListesiniGetir() async {
    var gunleriIcerenMapListesi =
        await gunleriGetir(); // üsteki fonksiyon çağılır gelen listeyi map formatından çıkarır
    var gunListesi = List<GunKalori>();
    for (Map map in gunleriIcerenMapListesi) {
      gunListesi.add(GunKalori.fromMap(map));
    }
    return gunListesi;
  }

  Future<int> gunEkle(GunKalori gunKalori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("gunluk_kalori",
        gunKalori.toMap()); // veritananına yeni eleman ekliyorum .
    return sonuc;
  }

  Future<int> gunSil(int gunID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete("gunluk_kalori",
        where: "gun_id = ?",
        whereArgs: [gunID]); // gün =id si şu olan günü sil şeklinde çalışır
    return sonuc;
  }

  String dateFormat(DateTime tm) {
    /* Bunuda internetten aldım
     temel amacı 21/11/2021 olan tarihi 21 kasım diye yazması
      veya bu gun kaydelimişse bu gün dün ise dün yazar.*/
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylül";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
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
