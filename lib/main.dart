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
/*
    for (var i = 0; i < 100; i++) {
      dbHelper.veriSil(i);
    }

    print("veriler silindi");
*/
    //dbHelper.veriSil(23);
    //dbHelper.veriSil(24);
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

      for (int i = 0; i <= dbVeriler.length - 1; i++) {
      
        if (dbVeriler[i]["id"] == 1) {
          dilSecimi = dbVeriler[i]["veri1"];
        }

        if (dbVeriler[i]["id"] == 2) {
          kurulumDurum = dbVeriler[i]["veri1"];
        }

      }

    }else{
      dbHelper.veriYOKSAekleVARSAguncelle(1, "EN", "0", "0", "0");
      dbHelper.veriYOKSAekleVARSAguncelle(2, "0", "0", "0", "0");
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

/*

  - assets/images/giris_ekran_arkaplan.png
  - assets/images/kurulum_fan_icon.png
  - assets/images/kurulum_klepe_icon.png
  - assets/images/kurulum_ped_icon.png
  - assets/images/kurulum_isisensor_icon.png
  - assets/images/kurulum_bacafan_icon.png
  - assets/images/kurulum_airinlet_icon.png
  - assets/images/kurulum_isitici_icon.png
  - assets/images/kurulum_isitici_kucuk_icon.png
  - assets/images/kurulum_sirkfan_icon.png
  - assets/images/kurulum_sirkfan_kucuk_icon.png
  - assets/images/kurulum_silo_icon.png
  - assets/images/kurulum_aydinlatma_icon.png
  - assets/images/kurulum_aydinlatma_icon1.png
  - assets/images/kurulum_yemleme_icon.png
  - assets/images/ky_tf_klasik_icon.png
  - assets/images/ky_tf_lineer_icon.png
  - assets/images/ky_tf_pid_icon.png
  - assets/images/ky_tf_pid_icon_grey.png
  - assets/images/ky_mh_klasik_icon.png
  - assets/images/ky_mh_agirlik_icon.png
  - assets/images/ky_mh_hacim_icon.png
  - assets/images/ky_klp_klasik_icon.png
  - assets/images/ky_klp_tunel_icon.png
  - assets/images/kumes_bina_uzunluk_icon.png
  - assets/images/fan_on_gorunuz_icon.png
  - assets/images/soru_isareti.png
  - assets/images/duvar_icon.png
  - assets/images/deger_artir_icon.png
  - assets/images/deger_dusur_icon.png
  - assets/images/onarka_duvar_gri_icon.png
  - assets/images/sagsol_duvar_gri_icon.png
  - assets/images/klepe_harita_icon.png
  - assets/images/ped_harita_icon.png
  - assets/images/bina_catisiz_ust_gorunum.png
  - assets/images/harita_isi_sensor_icon.png
  - assets/images/harita_isi_sensor_kucuk_icon.png
  - assets/images/bina_perspektif_gorunum.png
  - assets/images/bina_catili_ust_gorunum.png
  - assets/images/harita_bacafan_icon.png
  - assets/images/kurulum_airinlet_icon.png
  - assets/images/kurulum_isitici_icon.png
  - assets/images/silo_harita.png
  - assets/images/tem_hum_icon.png
  - assets/images/cooling_icon.png
  - assets/images/heating_icon.png
  - assets/images/klepe_icon2.png
  - assets/images/klepe_icon.png
  - assets/images/minvent_icon.png
  - assets/images/mancontrol_icon.png
  - assets/images/mancontrol_icon_red.png
  - assets/images/settings_icon.png
  - assets/images/settings_icon_small.png
  - assets/images/wizard_icon.png
  - assets/images/izleme_icon.png
  - assets/images/izleme_icon_red.png
  - assets/images/datalog_icon.png
  - assets/images/datalog_icon_small.png
  - assets/images/kontrol_icon.png
  - assets/images/kontrol_icon_small.png
  - assets/images/alarm_ayarlari_icon.png
  - assets/images/alarm_ayarlari_icon_small.png
  - assets/images/aydinlatma_icon.png
  - assets/images/silo_icon.png
  - assets/images/diagram_lineer_capraz.jpg
  - assets/images/diagram_lineer_normal.jpg
  - assets/images/diagram_klasik_normal.jpg
  - assets/images/diagram_klasik_capraz.jpg
  - assets/images/diagram_pid_normal.jpg
  - assets/images/diagram_pid_capraz.jpg
  - assets/images/diagram_klepe_prob_kontrol.jpg
  - assets/images/acikmavi_oval_icon.png
  - assets/images/turkuaz_oval_icon.png
  - assets/images/feeding_icon.png
  - assets/images/diagram_klepe_klasik1.jpg
  - assets/images/diagram_klepe_klasik2.jpg
  - assets/images/diagram_klepe_tunel.jpg
  - assets/images/diagram_sogutma_civbro.jpg
  - assets/images/diagram_isitma.jpg
  - assets/images/diagram_mh_klasik.jpg
  - assets/images/sagsol_duvar_icon.jpg
  - assets/images/onarka_duvar_icon.jpg
  - assets/images/sagsol_duvar_gri_icon.png
  - assets/images/onarka_duvar_gri_icon.png
  - assets/images/calibration_icon.png
  - assets/images/cati_icon.png
  - assets/images/kalibrasyon_icon.png
  - assets/images/su_silo_icon.png
  - assets/images/diger_ops_icon.png
  - assets/images/suru_icon.png
  - assets/images/kurulum_icon.png
  - assets/images/saat_tarih_ayar_icon.png
  - assets/images/giris_rotate_icon.png
  - assets/images/bfan_rotate_icon.png
  - assets/images/giris_sabit_icon.png
  - assets/images/ped_izleme_icon_off.png
  - assets/images/ped_izleme_icon_on.png

*/