import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/sistem/kurulum/dil_secimi.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DBProkis>(create: (context) => DBProkis(),),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PROKIS PANEL",
      home: Giris(),
    ),
  ));
}

class Giris extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GirisYapi();
  }
}

class GirisYapi extends State<Giris> with TickerProviderStateMixin {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
/*
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
*/
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
  int sayac=0;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++OTOMATİK SAYFA GEÇİŞ İŞLEMİ+++++++++++++++++++++++++++++++

  @override
  void initState() {
    super.initState();
    
    
  }




//--------------------------OTOMATİK SAYFA GEÇİŞ İŞLEMİ--------------------------------

  @override
  Widget build(BuildContext context) {
  final dbProkis = Provider.of<DBProkis>(context);
    //_dbSatirlariCekme();

    if(sayac==0){

      new Future.delayed(const Duration(seconds: 3), () {
        kurulumDurum=dbProkis.dbVeriGetir(2, 1, "0");
        dbVeriler=dbProkis.getDbVeri;
        Navigator.push(
          context,
          //MaterialPageRoute(builder: (context) => DilSecimi(dbVeriler)),
          MaterialPageRoute(
              builder: (context) => kurulumDurum == "0"
                  ? DilSecimi(true)
                  : GenelAyarlar(dbVeriler)),
        );
      });

      sayac++;
    }


//++++++++++++++++++++++++++STATUS BAR SAKLAMA ve EKRANI YATAYA SABİTLEME+++++++++++++++++++++++++++++++
    SystemChrome.setEnabledSystemUIOverlays([]);
    _landscapeModeOnly();
//--------------------------STATUS BAR SAKLAMA ve EKRANI YATAYA SABİTLEME--------------------------------



//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage(
                          "assets/images/giris_ekran_arkaplan.png"),
                      fit: BoxFit.cover)),
              alignment: Alignment.bottomCenter,
              ),
        ],
      ),
    );
//--------------------------SCAFFOLD--------------------------------
  }

//++++++++++++++++++++++++++METOTLAR+++++++++++++++++++++++++++++++
/*

  _satirlar(List<Map> satirlar) {
    dbVeriler = satirlar;

    if (dbSatirSayisi > 0) {
      for (int i = 0; i <= dbVeriler.length - 1; i++) {
        if (dbVeriler[i]["id"] == 1) {
          dilSecimi = dbVeriler[i]["veri1"];
        }

        if (dbVeriler[i]["id"] == 2) {
          kurulumDurum = dbVeriler[i]["veri1"];
        }
      }
    } else {
      dbHelper.veriYOKSAekleVARSAguncelle(1, "EN", "0", "0", "0");
      dbHelper.veriYOKSAekleVARSAguncelle(2, "0", "0", "0", "0");
    }

    //setState(() {});
  }

  _dbSatirlariCekme() {
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      dbSatirlar.then((List<Map> satir) => _satirlar(satir));
    });
  }

*/


  void _landscapeModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
//--------------------------METOTLAR--------------------------------

}


