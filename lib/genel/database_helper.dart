import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "genel_1x4.db";
  static final _databaseVersion = 1;

  static final table = 'tablo_1x4';

  static final columnId = 'id';
  static final columnV1 = 'veri1';
  static final columnV2 = 'veri2';
  static final columnV3 = 'veri3';
  static final columnV4 = 'veri4';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnV1 TEXT NOT NULL,
            $columnV2 TEXT NOT NULL,
            $columnV3 TEXT NOT NULL,
            $columnV4 TEXT NOT NULL
          )
          ''');
  }

  // Helper methods





  // VERİ EKLEME METODU
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> veriYOKSAekleVARSAguncelle(int xid,String xV1,String xV2,String xV3,String xV4,) async {

    Database db = await instance.database;

    //region Girilen ID'nin database de var olup olmadığına bakar

    List<Map> satir=await db.rawQuery('SELECT * FROM tablo_1x4 WHERE id = ?',[xid]);

    String sonuc;

    if(satir.toString() == "[]")
      sonuc="";
    else
      sonuc= satir[0]['id'].toString();

    bool id_var=false;

    sonuc==xid.toString() ? id_var=true : id_var=false;

    //endregion

    if(!id_var) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: xid,
        DatabaseHelper.columnV1: xV1,
        DatabaseHelper.columnV2: xV2,
        DatabaseHelper.columnV3: xV3,
        DatabaseHelper.columnV4: xV4
      };
      return await db.insert(table, row);
    }
    else {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId : xid,
        DatabaseHelper.columnV1  : xV1,
        DatabaseHelper.columnV2  : xV2,
        DatabaseHelper.columnV3  : xV3,
        DatabaseHelper.columnV4  : xV4
      };
      print("GÜNCELLENDİ");

      return await db.update(table, row, where: '$columnId = ?', whereArgs: [xid]);
    }

  }



  // VERİ ÇEKME METODU
  Future<String> veriCek(int xid, int xindex_No) async{

    String xindexNo;
    if(xindex_No==0)
      xindexNo="id";
    if(xindex_No==1)
      xindexNo="veri1";
    if(xindex_No==2)
      xindexNo="veri2";
    if(xindex_No==3)
      xindexNo="veri3";
    if(xindex_No==4)
      xindexNo="veri4";

    Database db = await instance.database;

    List<Map> satir=await db.rawQuery('SELECT * FROM tablo_1x4 WHERE id = ?',[xid]);

    String sonuc;
    print(satir.toString() + "Satir degeridir");

    if(satir.toString() == "[]")
      sonuc="";
    else
      sonuc= satir[0][xindexNo].toString();

    return sonuc;

  }



  // SATIR ÇEKME METODU
  Future<List<Map>> satirCek(int xid) async{


    Database db = await instance.database;

    List<Map> satir=await db.rawQuery('SELECT * FROM tablo_1x4 WHERE id = ?',[xid]);

    print(satir.toString() + "Satir degeridir");

    return satir;

  }







  // VERİ GÜNCELLEME METODU
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> veriGuncelle(int xid,String xV1, String xV2, String xV3, String xV4) async {

    Map<String, dynamic> row = {
      DatabaseHelper.columnId : xid,
      DatabaseHelper.columnV1  : xV1,
      DatabaseHelper.columnV2  : xV2,
      DatabaseHelper.columnV3  : xV3,
      DatabaseHelper.columnV4  : xV4
    };

    Database db = await instance.database;
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [xid]);
  }


  // VERİ SİLME METODU
  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> veriSil(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }





  // TÜM SATIRLARI GETİRME METODU
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> satirlariCek() async {
    Database db = await instance.database;
    return await db.query(table);
  }


  // SATIR SAYISINI GETİRME METODU
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> satirSayisi() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }


}