

import 'package:flutter/cupertino.dart';
import 'package:prokis/yardimci/database_helper.dart';

class DBProkis with ChangeNotifier{

  List<Map> dbVeri;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;


  //Obje ilk okunduğunda database deki verileri List halinde "dbVeri" içine yazar
  DBProkis(){
    dbVeriCekme();
  }

  List get getDbVeri => dbVeri;

  Future dbVeriCekme() {
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      dbSatirlar.then((List<Map> satir) {
        dbVeri = satir;
        notifyListeners();
      });
    });
  }


  dbSatirEkleGuncelle(int id, String v1,String v2,String v3,String v4){
    dbHelper.veriYOKSAekleVARSAguncelle(id, v1, v2, v3, v4).then((value) => dbVeriCekme());
    
  }

  dbSatirSil(int ilk, int son){
    print("VERİLER SİLİNDİ");
    for (var i = ilk; i <= son; i++) {
      dbHelper.veriSil(i).then((value) => dbVeriCekme());
    }
    
  }

  

  dbVeriGetir(int id, int veriNo, var kayitYoksaDeger) {

    String veri="yok";

    for (int i = 0; i <= dbVeri.length - 1; i++) {
            
      if (dbVeri[i]["id"] == id) {
        veri = dbVeri[i]["veri$veriNo"];
      }

    }
    return veri=="yok" ? kayitYoksaDeger : veri;
  }



}