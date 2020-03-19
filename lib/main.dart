import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'dil_secimi.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "PROKOS PANEL",
    home: Giris(),
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
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------




//++++++++++++++++++++++++++OTOMATİK SAYFA GEÇİŞ İŞLEMİ+++++++++++++++++++++++++++++++

  @override
  Future initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          //MaterialPageRoute(builder: (context) => DilSecimi(dbVeriler)),
          MaterialPageRoute(builder: (context) => kurulumDurum=="0" ? DilSecimi(dbVeriler,true) :  GenelAyarlar(dbVeriler)),
        ));
  }

//--------------------------OTOMATİK SAYFA GEÇİŞ İŞLEMİ--------------------------------




  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++DATABASE'den SATIRLARI ÇEKME+++++++++++++++++++++++++++++++
    
    
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      if (dbSayac == 0) {
        dbSatirlar.then((List<Map> satir) => _satirlar(satir));
        dbSayac++;
      }
    });
//--------------------------DATABASE'den SATIRLARI ÇEKME--------------------------------


//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------


//++++++++++++++++++++++++++STATUS BAR SAKLAMA ve EKRANI YATAYA SABİTLEME+++++++++++++++++++++++++++++++

    SystemChrome.setEnabledSystemUIOverlays([]);
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        Dil().sec(dilSecimi, "slogan"),
                        style: TextStyle(color: Colors.yellow.shade600,fontFamily: 'Audio wide',fontSize: 16),textScaleFactor: oran,
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 1,
                  ),
                ],
              )),
        ],
      ),
    );
//--------------------------SCAFFOLD--------------------------------

  }



//++++++++++++++++++++++++++METOTLAR+++++++++++++++++++++++++++++++

  _satirlar(List<Map> satirlar) {

    dbVeriler=satirlar;

    if (dbSatirSayisi > 0) {
      dilSecimi = satirlar[0]["veri1"];
    }else{
      dbHelper.veriYOKSAekleVARSAguncelle(1, "EN", "0", "0", "0");
      dbHelper.veriYOKSAekleVARSAguncelle(2, "0", "0", "0", "0");
    }

    if (dbSatirSayisi > 1) {
      kurulumDurum = satirlar[1]["veri1"];
    }

    //print(satirlar);
    setState(() {});
  }


  void _landscapeModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
//--------------------------METOTLAR--------------------------------

  
}

