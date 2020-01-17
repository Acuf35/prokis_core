import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/kurulumu_tamamla.dart';
import 'package:prokis/silo_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'languages/select.dart';

class KurulumOzet extends StatefulWidget {
  List<Map> gelenDBveri;
  KurulumOzet(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return KurulumOzetState(gelenDBveri);
  }
}

class KurulumOzetState extends State<KurulumOzet> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";

  String kafesTuru="";
  String kafesNo="";
  String kafesIsmi="";
  String fanSayisi="";
  String klepeSayisi="";
  String pedPompaSayisi="";
  String isiSensorSayisi="";
  String bacaFanSayisi="";
  String airInletSayisi="";
  String isiticiSayisi="";
  String siloSayisi="";
  String tfYontemi="";
  String mhYontemi="";
  String klpYontemi="";
  String k1x="";
  String k2x="";
  String k3x="";
  String k4x="";
  String k5x="";
  String k6x="";
  String k7x="";
  String k8x="";
  String k9x="";
  String k10x="";
  String k1y="";
  String k2y="";
  String k3y="";
  String k4y="";
  String k5y="";
  String k6y="";
  String k7y="";
  String k8y="";
  String k9y="";
  String k10y="";
  String kumesEn="";
  String kumesYukseklik="";
  String kumesUzunluk="";
  String tfDebi="";
  String bfDebiToplam="";
  String hacimOrani="";
  String disNem="";

  

  List<int> tumCikislar = new List(111);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KurulumOzetState(List<Map> dbVeri) {
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 22) {
        if (dbVeri[i]["veri1"] == "ok") {
          tumCikislarVar = true;
          var tcikislar = dbVeri[i]["veri2"].split("#");

          for (int i = 1; i <= 110; i++) {
            tumCikislar[i] = int.parse(tcikislar[i - 1]);
          }
        }
      }
      }
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      SelectLanguage().selectStrings(dilSecimi, "tv85"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          alignment: Alignment.center,
        )),
        //aluyay Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
                ],
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(
          child: Container(
            color: Colors.grey.shade600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Spacer(),
                Spacer(
                  flex: 20,
                  ),
                //geri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        Navigator.pop(context, tumCikislar);
                      },
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      iconSize: 50 * oran,
                      onPressed: () {

                        /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KurulumuTamamla(dbVeriler)),
                          );
                         
                        */
                        
                      },
                      color: Colors.black,
                    )),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
//--------------------------SCAFFOLD--------------------------------
  }

//++++++++++++++++++++++++++METOTLAR+++++++++++++++++++++++++++++++

  _satirlar(List<Map> satirlar) {
    dbVeriler = satirlar;
  }

  _dbVeriCekme() {
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      dbSatirlar.then((List<Map> satir) => _satirlar(satir));
    });
  }

  _veriGonder(String dbKod, String id, String v1, String v2, String v3,
      String v4) async {
    Socket socket;

    try {
      socket = await Socket.connect('192.168.1.110', 2233);
      String gelen_mesaj = "";

      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
        print(utf8.decode(event));
        gelen_mesaj = utf8.decode(event);
        var gelen_mesaj_parcali = gelen_mesaj.split("*");

        if (gelen_mesaj_parcali[0] == 'ok') {
          Toast.show(
              SelectLanguage().selectStrings(dilSecimi, "toast8"), context,
              duration: 2);
        } else {
          Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
        }

        setState(() {});
      });

      socket.add(utf8.encode('$dbKod*$id*$v1*$v2*$v3*$v4'));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 5));

      // .. and close the socket
      socket.close();
    } catch (e) {
      print(e);
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

  String outConv(int deger) {
    String sonuc = "";

    if (deger == 1)
      sonuc = "Q0.0";
    else if (deger == 2)
      sonuc = "Q0.1";
    else if (deger == 3)
      sonuc = "Q0.2";
    else if (deger == 4)
      sonuc = "Q0.3";
    else if (deger == 5)
      sonuc = "Q0.4";
    else if (deger == 6)
      sonuc = "Q0.5";
    else if (deger == 7)
      sonuc = "Q0.6";
    else if (deger == 8)
      sonuc = "Q0.7";
    else if (deger == 9)
      sonuc = "Q1.0";
    else if (deger == 10)
      sonuc = "Q1.1";
    else if (deger == 11)
      sonuc = "Q2.0";
    else if (deger == 12)
      sonuc = "Q2.1";
    else if (deger == 13)
      sonuc = "Q2.2";
    else if (deger == 14)
      sonuc = "Q2.3";
    else if (deger == 15)
      sonuc = "Q2.4";
    else if (deger == 16)
      sonuc = "Q2.5";
    else if (deger == 17)
      sonuc = "Q2.6";
    else if (deger == 18)
      sonuc = "Q2.7";
    else if (deger == 19)
      sonuc = "Q3.0";
    else if (deger == 20)
      sonuc = "Q3.1";
    else if (deger == 21)
      sonuc = "Q3.2";
    else if (deger == 22)
      sonuc = "Q3.3";
    else if (deger == 23)
      sonuc = "Q3.4";
    else if (deger == 24)
      sonuc = "Q3.5";
    else if (deger == 25)
      sonuc = "Q3.6";
    else if (deger == 26)
      sonuc = "Q3.7";
    else if (deger == 27)
      sonuc = "Q4.0";
    else if (deger == 28)
      sonuc = "Q4.1";
    else if (deger == 29)
      sonuc = "Q4.2";
    else if (deger == 30)
      sonuc = "Q4.3";
    else if (deger == 31)
      sonuc = "Q4.4";
    else if (deger == 32)
      sonuc = "Q4.5";
    else if (deger == 33)
      sonuc = "Q4.6";
    else if (deger == 34)
      sonuc = "Q4.7";
    else if (deger == 35)
      sonuc = "Q5.0";
    else if (deger == 36)
      sonuc = "Q5.1";
    else if (deger == 37)
      sonuc = "Q5.2";
    else if (deger == 38)
      sonuc = "Q5.3";
    else if (deger == 39)
      sonuc = "Q5.4";
    else if (deger == 40)
      sonuc = "Q5.5";
    else if (deger == 41)
      sonuc = "Q5.6";
    else if (deger == 42)
      sonuc = "Q5.7";
    else if (deger == 43)
      sonuc = "Q6.0";
    else if (deger == 44)
      sonuc = "Q6.1";
    else if (deger == 45)
      sonuc = "Q6.2";
    else if (deger == 46)
      sonuc = "Q6.3";
    else if (deger == 47)
      sonuc = "Q6.4";
    else if (deger == 48)
      sonuc = "Q6.5";
    else if (deger == 49)
      sonuc = "Q6.6";
    else if (deger == 50)
      sonuc = "Q6.7";
    else if (deger == 51)
      sonuc = "Q7.0";
    else if (deger == 52)
      sonuc = "Q7.1";
    else if (deger == 53)
      sonuc = "Q7.2";
    else if (deger == 54)
      sonuc = "Q7.3";
    else if (deger == 55)
      sonuc = "Q7.4";
    else if (deger == 56)
      sonuc = "Q7.5";
    else if (deger == 57)
      sonuc = "Q7.6";
    else if (deger == 58)
      sonuc = "Q7.7";
    else if (deger == 59)
      sonuc = "Q8.0";
    else if (deger == 60)
      sonuc = "Q8.1";
    else if (deger == 61)
      sonuc = "Q8.2";
    else if (deger == 62)
      sonuc = "Q8.3";
    else if (deger == 63)
      sonuc = "Q8.4";
    else if (deger == 64)
      sonuc = "Q8.5";
    else if (deger == 65)
      sonuc = "Q8.6";
    else if (deger == 66)
      sonuc = "Q8.7";
    else if (deger == 67)
      sonuc = "Q9.0";
    else if (deger == 68)
      sonuc = "Q9.1";
    else if (deger == 69)
      sonuc = "Q9.2";
    else if (deger == 70)
      sonuc = "Q9.3";
    else if (deger == 71)
      sonuc = "Q9.4";
    else if (deger == 72)
      sonuc = "Q9.5";
    else if (deger == 73)
      sonuc = "Q9.6";
    else if (deger == 74)
      sonuc = "Q9.7";
    else if (deger == 75)
      sonuc = "Q10.0";
    else if (deger == 76)
      sonuc = "Q10.1";
    else if (deger == 77)
      sonuc = "Q10.2";
    else if (deger == 78)
      sonuc = "Q10.3";
    else if (deger == 79)
      sonuc = "Q10.4";
    else if (deger == 80)
      sonuc = "Q10.5";
    else if (deger == 81)
      sonuc = "Q10.6";
    else if (deger == 82)
      sonuc = "Q10.7";
    else if (deger == 83)
      sonuc = "Q11.0";
    else if (deger == 84)
      sonuc = "Q11.1";
    else if (deger == 85)
      sonuc = "Q11.2";
    else if (deger == 86)
      sonuc = "Q11.3";
    else if (deger == 87)
      sonuc = "Q11.4";
    else if (deger == 88)
      sonuc = "Q11.5";
    else if (deger == 89)
      sonuc = "Q11.6";
    else if (deger == 90)
      sonuc = "Q11.7";
    else if (deger == 91)
      sonuc = "Q12.0";
    else if (deger == 92)
      sonuc = "Q12.1";
    else if (deger == 93)
      sonuc = "Q12.2";
    else if (deger == 94)
      sonuc = "Q12.3";
    else if (deger == 95)
      sonuc = "Q12.4";
    else if (deger == 96)
      sonuc = "Q12.5";
    else if (deger == 97)
      sonuc = "Q12.6";
    else if (deger == 98)
      sonuc = "Q12.7";
    else if (deger == 99)
      sonuc = "Q13.0";
    else if (deger == 100)
      sonuc = "Q13.1";
    else if (deger == 101)
      sonuc = "Q13.2";
    else if (deger == 102)
      sonuc = "Q13.3";
    else if (deger == 103)
      sonuc = "Q13.4";
    else if (deger == 104)
      sonuc = "Q13.5";
    else if (deger == 105)
      sonuc = "Q13.6";
    else if (deger == 106)
      sonuc = "Q13.7";
    else if (deger == 107)
      sonuc = "Q14.0";
    else if (deger == 108)
      sonuc = "Q14.1";
    else if (deger == 109)
      sonuc = "Q14.2";
    else if (deger == 110)
      sonuc = "Q14.3";
    else if (deger == 111)
      sonuc = "Q14.4";
    else if (deger == 112)
      sonuc = "Q14.5";
    else if (deger == 113)
      sonuc = "Q14.6";
    else if (deger == 114)
      sonuc = "114.7";
    else if (deger == 115)
      sonuc = "Q15.0";
    else if (deger == 116)
      sonuc = "Q15.1";
    else if (deger == 117)
      sonuc = "Q15.2";
    else if (deger == 118)
      sonuc = "Q15.3";
    else if (deger == 119)
      sonuc = "Q15.4";
    else if (deger == 120)
      sonuc = "Q15.5";
    else if (deger == 121)
      sonuc = "Q15.6";
    else if (deger == 122)
      sonuc = "Q15.7";
    else if (deger == 123)
      sonuc = "Q16.0";
    else {
      sonuc = "";
    }

    return sonuc;
  }


//--------------------------METOTLAR--------------------------------

}
