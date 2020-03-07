import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:prokis/genel/metotlar.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_1x2.dart';
import 'genel/deger_giris_2x0.dart';
import 'genel/deger_giris_2x1.dart';
import 'genel/deger_giris_3x0.dart';
import 'genel/deger_giris_6x0.dart';
import 'languages/select.dart';

class Kalibrasyon extends StatefulWidget {
  List<Map> gelenDBveri;
  Kalibrasyon(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KalibrasyonState(gelenDBveri);
  }
}

class KalibrasyonState extends State<Kalibrasyon> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String kumesTuru = "1";
  String disNemAktif = "0";
  List<Map> dbVeriler;

  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;


  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;
  bool bottomDrawerAktif = false;

  int isisensorAdet = 0;
  int isisensorBaglanti = 1;

  List<int> isisensorNo = new List(23);

  List<bool> aktifSensorVisibility = new List(16);
  List<int> aktifSensorNo = new List(16);
  List<String> aktifSensorID = new List(16);
  List<String> aktifSensorValue = new List(16);
  List<bool> aktifSensorDurum = new List(16);
  List<String> aktifSensorArtiKalibDegeri = new List(16);
  List<String> aktifSensorEksiKalibDegeri = new List(16);
  int aktifSenSay = 0;
  bool aktifSensorNoTekerrur = false;
  bool atanacakSensorVarmi = true;

  bool veriGonderildi = false;

  String icNemDeger="0.0";
  String icNemArtiKalibDegeri="0.0";
  String icNemEksiKalibDegeri="0.0";
  String disNemDeger="0.0";
  String disNemArtiKalibDegeri="0.0";
  String disNemEksiKalibDegeri="0.0";

  

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KalibrasyonState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    bool isisensorNoOK = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 3) {
        kumesTuru = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 13) {
        disNemAktif = dbVeri[i]["veri4"];
      }

      if (dbVeri[i]["id"] == 4) {
        var xx=dbVeri[i]["veri4"].split('#');
        isisensorAdet = int.parse(xx[0]);
        isisensorBaglanti=int.parse(xx[1]);
      }

      if (dbVeri[i]["id"] == 21) {
        String xx;
        String yy;
        String zz;

        if (dbVeri[i]["veri1"] == "ok") {
          isisensorNoOK = true;
          xx = dbVeri[i]["veri2"];
          yy = dbVeri[i]["veri3"];
          zz = dbVeri[i]["veri4"];
          var isisensorNolar = xx.split("#");
          var aktifIsisensorNolar = yy.split("#");
          var aktifIsisensorIDler = zz.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorNo[i] = int.parse(isisensorNolar[i - 1]);
          }

          if (aktifIsisensorNolar.length > 2 && aktifIsisensorIDler.length > 2) {
            for (int i = 1; i <= 15; i++) {
              aktifSensorNo[i] = int.parse(aktifIsisensorNolar[i - 1]);
              aktifSensorID[i] = aktifIsisensorIDler[i - 1];
            }
          } else {
            for (int i = 1; i <= 15; i++) {
              aktifSensorNo[i] = 0;
            }
          }

        }
      }
    }

    for (int i = 1; i <= 15; i++) {
      aktifSensorValue[i] = "0.0";
      aktifSensorVisibility[i] = false;
      aktifSensorDurum[i] = false;
      aktifSensorArtiKalibDegeri[i]='0.0';
      aktifSensorEksiKalibDegeri[i]='0.0';
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {




    if (timerSayac == 0) {
      if(isisensorBaglanti==1){
        _takipEtWifi();
      }else{
        _takipEtAnalog();
      }

      Timer.periodic(Duration(seconds: 4), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti) {
          baglanti = true;

          if(isisensorBaglanti==1){
            _takipEtWifi();
          }else{
            _takipEtAnalog();
          }
        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv431'),
        body: Column(
          children: <Widget>[
            //Saat ve Tarih
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[300],
                    padding: EdgeInsets.only(left: 10 * oran),
                    child: TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      return Text(
                        Metotlar().getSystemTime(dbVeriler),
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'Kelly Slab',
                            fontSize: 12 * oran,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.grey[300],
                    padding: EdgeInsets.only(right: 10 * oran),
                    child: TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      return Text(
                        Metotlar().getSystemDate(dbVeriler),
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'Kelly Slab',
                            fontSize: 12 * oran,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Container(height: 20*oran,),
            Container(child: Text(Dil().sec(dilSecimi, "tv435"),textScaleFactor: oran,style: TextStyle(fontFamily: 'Kelly Slab'),),color: Colors.yellow[300],alignment: Alignment.center,),
            Expanded(flex: 6,
              child: Stack(
                children: <Widget>[
                  Visibility(
                    visible: isisensorBaglanti==2  ? false : (aktifSenSay==0 ? true : false),
                    child: Center(
                        child: Text(
                      Dil()
                          .sec(dilSecimi, "tv60"),
                      style: TextStyle(
                          fontSize: 20 * oran,
                          fontFamily: "Kelly Slab",
                          color: Colors.grey[300],
                          fontWeight: FontWeight.bold),
                      textScaleFactor: oran,
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(flex: 3),
                      //Aktif Sensorler 1-2-3
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: <Widget>[
                            //Aktif sensör 1
                            _aktifSensor(1, oran),
                            //Aktif sensör 2
                            _aktifSensor(2, oran),
                            //Aktif sensör 3
                            _aktifSensor(3, oran),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Aktif Sensorler 4-5-6
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: <Widget>[
                            //Aktif sensör 4
                            _aktifSensor(4, oran),
                            //Aktif sensör 5
                            _aktifSensor(5, oran),
                            //Aktif sensör 6
                            _aktifSensor(6, oran),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Aktif Sensorler 7-8-9
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: <Widget>[
                            //Aktif sensör 7
                            _aktifSensor(7, oran),
                            //Aktif sensör 8
                            _aktifSensor(8, oran),
                            //Aktif sensör 9
                            _aktifSensor(9, oran),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Aktif Sensorler 10-11-12
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: <Widget>[
                            //Aktif sensör 10
                            _aktifSensor(10, oran),
                            //Aktif sensör 11
                            _aktifSensor(11, oran),
                            //Aktif sensör 12
                            _aktifSensor(12, oran),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Aktif Sensorler 13-14-15
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: <Widget>[
                            //Aktif sensör 13
                            _aktifSensor(13, oran),
                            //Aktif sensör 14
                            _aktifSensor(14, oran),
                            //Aktif sensör 15
                            _aktifSensor(15, oran),
                          ],
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  ),
                ],
              )),
            Spacer(flex: 1,),
            Container(child: Text(Dil().sec(dilSecimi, "tv440"),textScaleFactor: oran,style: TextStyle(fontFamily: 'Kelly Slab'),),color: Colors.yellow[300],alignment: Alignment.center,),
            Expanded(flex: 6,
              child: Stack(
                children: <Widget>[
                  Visibility(
                    visible: isisensorBaglanti==2  ? false : (aktifSenSay==0 ? true : false),
                    child: Center(
                        child: Text(
                      Dil()
                          .sec(dilSecimi, "tv60"),
                      style: TextStyle(
                          fontSize: 20 * oran,
                          fontFamily: "Kelly Slab",
                          color: Colors.grey[300],
                          fontWeight: FontWeight.bold),
                      textScaleFactor: oran,
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(flex: 9),
                      //Aktif Sensorler 1-2-3
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            //Aktif sensör 1
                            _aktifSensorNem(1, oran),
                            //Aktif sensör 2
                            _aktifSensorNem(2, oran),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                      Spacer(flex: 9),
                    ],
                  ),
                ],
              )),
            ],
        ),
        floatingActionButton: Container(
          width: 56 * oran,
          height: 56 * oran,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GenelAyarlar(dbVeriler)),
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.arrow_back,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
        endDrawer: SizedBox(
          width: 320 * oran,
          child: Drawer(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        Dil().sec(dilSecimi, "tv453"), 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Kelly Slab',
                        ),
                        textScaleFactor: oran,
                      ),
                      color: Colors.yellow[700],
                    ),
                  ),
                  Expanded(
                    flex: 17,
                    child: Container(
                      color: Colors.yellow[100],
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          ListTile(
                            dense: false,
                            title: Text(
                              Dil().sec(dilSecimi, "tv186"),
                              textScaleFactor: oran,
                            ),
                            subtitle: Text(
                              Dil().sec(dilSecimi, "info21"),
                              style: TextStyle(
                                fontSize: 13 * oran,
                              ),
                            ),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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

 
  _veriGonder(String emir) async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2235).then((socket) {
        String gelen_mesaj = "";

        socket.add(utf8.encode(emir));

        socket.listen(
          (List<int> event) {
            print(utf8.decode(event));
            gelen_mesaj = utf8.decode(event);
            var gelen_mesaj_parcali = gelen_mesaj.split("*");

            if (gelen_mesaj_parcali[0] == 'ok') {
              Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 2);
            } else {
              Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            setState(() {});
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
    }
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {
        socket.add(utf8.encode('15*$kumesTuru'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);


              //socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (!timerCancel) {
              setState(() {});
            }
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
    }
  }

  _takipEtWifi() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2233).then((socket) {

        socket.add(utf8.encode('24aa*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            print(gelenMesaj);

            if (gelenMesaj != "") {
              var veri=gelenMesaj.split('#');
              var sensorler =veri[0].split('*');
              var artiEksiDegerler=veri[1].split('*');
              var nemDegerler=veri[2].split('*');

              aktifSenSay = (sensorler.length - 1).toInt();

              for (int i = 1; i <= 15; i++) {
                if (i <= aktifSenSay) {
                  aktifSensorVisibility[i] = true;
                }
              }
              for(int i=0;i<=sensorler.length-2;i++){
                var deger=sensorler[i].split('+');
                aktifSensorID[i+1]=deger[0];
                aktifSensorValue[i+1]=deger[1];
                aktifSensorDurum[i+1]=deger[2] == 'ok' ? true : false;
              }
              //print(aktifSensorDurum[1]);
              //print(aktifSensorDurum[2]);


              for(int i=0;i<=artiEksiDegerler.length-2;i++){
                var deger=artiEksiDegerler[i].split('+');
                aktifSensorArtiKalibDegeri[i+1]=deger[0];
                aktifSensorEksiKalibDegeri[i+1]=deger[1];
              }

              for(int i=1;i<=15;i++){
                aktifSensorValue[i]=(double.parse(aktifSensorValue[i])+double.parse(aktifSensorArtiKalibDegeri[i])-double.parse(aktifSensorEksiKalibDegeri[i])).toStringAsFixed(1);
              }

              icNemDeger=nemDegerler[0];
              icNemArtiKalibDegeri=nemDegerler[1];
              icNemEksiKalibDegeri=nemDegerler[2];
              disNemDeger=nemDegerler[3];
              disNemArtiKalibDegeri=nemDegerler[4];
              disNemEksiKalibDegeri=nemDegerler[5];



              socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (!timerCancel) {
              setState(() {});
            }
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  _takipEtAnalog() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2233).then((socket) {

        socket.add(utf8.encode('24bb'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {
              var veri=gelenMesaj.split("*");
              var sensorler = veri[0].split('#');
              var artiDegerler = veri[1].split('#');
              var eksiDegerler = veri[2].split('#');
              var nemDegerler = veri[3].split('#');
              print(veri);

              aktifSensorVisibility[1] =  isisensorAdet>=1 ? true :false;
              aktifSensorVisibility[4] =  isisensorAdet>=2 ? true :false;
              aktifSensorVisibility[7] =  isisensorAdet>=3 ? true :false;
              aktifSensorVisibility[10] = isisensorAdet>=4 ? true :false;
              aktifSensorVisibility[13] = isisensorAdet>=5 ? true :false;
              aktifSensorVisibility[2] =  isisensorAdet>=6 ? true :false;
              aktifSensorVisibility[5] =  isisensorAdet>=7 ? true :false;
              aktifSensorVisibility[8] =  isisensorAdet>=8 ? true :false;
              aktifSensorVisibility[11] = isisensorAdet>=9 ? true :false;
              aktifSensorVisibility[14] = isisensorAdet>=10 ? true :false;

              aktifSensorID[1] = Dil().sec(dilSecimi, "tv443");
              aktifSensorID[4] = Dil().sec(dilSecimi, "tv444");
              aktifSensorID[7] = Dil().sec(dilSecimi, "tv445");
              aktifSensorID[10] = Dil().sec(dilSecimi, "tv446");
              aktifSensorID[13] = Dil().sec(dilSecimi, "tv447");
              aktifSensorID[2] = Dil().sec(dilSecimi, "tv448");
              aktifSensorID[5] = Dil().sec(dilSecimi, "tv449");
              aktifSensorID[8] = Dil().sec(dilSecimi, "tv450");
              aktifSensorID[11] = Dil().sec(dilSecimi, "tv451");
              aktifSensorID[14] = Dil().sec(dilSecimi, "tv452");
              aktifSensorValue[1]   = sensorler[0] ;
              aktifSensorValue[4]   = sensorler[1] ;
              aktifSensorValue[7]   = sensorler[2] ;
              aktifSensorValue[10]  = sensorler[3] ;
              aktifSensorValue[13]  = sensorler[4] ;
              aktifSensorValue[2]   = sensorler[5] ;
              aktifSensorValue[5]   = sensorler[6];
              aktifSensorValue[8]   = sensorler[7];
              aktifSensorValue[11]  = sensorler[8];
              aktifSensorValue[14]  = sensorler[9];
              aktifSensorDurum[1]   = sensorler[0]=="0.0" ? false : true ;
              aktifSensorDurum[4]   = sensorler[1]=="0.0" ? false : true ;
              aktifSensorDurum[7]   = sensorler[2]=="0.0" ? false : true ;
              aktifSensorDurum[10]  = sensorler[3]=="0.0" ? false : true ;
              aktifSensorDurum[13]  = sensorler[4]=="0.0" ? false : true ;
              aktifSensorDurum[2]   = sensorler[5]=="0.0" ? false : true ;
              aktifSensorDurum[5]   = sensorler[6]=="0.0" ? false : true;
              aktifSensorDurum[8]   = sensorler[7]=="0.0" ? false : true;
              aktifSensorDurum[11]  = sensorler[8]=="0.0" ? false : true;
              aktifSensorDurum[14]  = sensorler[9]=="0.0" ? false : true;

              aktifSensorArtiKalibDegeri[1]   = artiDegerler[0] ;
              aktifSensorArtiKalibDegeri[4]   = artiDegerler[1] ;
              aktifSensorArtiKalibDegeri[7]   = artiDegerler[2] ;
              aktifSensorArtiKalibDegeri[10]  = artiDegerler[3] ;
              aktifSensorArtiKalibDegeri[13]  = artiDegerler[4] ;
              aktifSensorArtiKalibDegeri[2]   = artiDegerler[5] ;
              aktifSensorArtiKalibDegeri[5]   = artiDegerler[6];
              aktifSensorArtiKalibDegeri[8]   = artiDegerler[7];
              aktifSensorArtiKalibDegeri[11]  = artiDegerler[8];
              aktifSensorArtiKalibDegeri[14]  = artiDegerler[9];

              aktifSensorEksiKalibDegeri[1]   = eksiDegerler[0] ;
              aktifSensorEksiKalibDegeri[4]   = eksiDegerler[1] ;
              aktifSensorEksiKalibDegeri[7]   = eksiDegerler[2] ;
              aktifSensorEksiKalibDegeri[10]  = eksiDegerler[3] ;
              aktifSensorEksiKalibDegeri[13]  = eksiDegerler[4] ;
              aktifSensorEksiKalibDegeri[2]   = eksiDegerler[5] ;
              aktifSensorEksiKalibDegeri[5]   = eksiDegerler[6];
              aktifSensorEksiKalibDegeri[8]   = eksiDegerler[7];
              aktifSensorEksiKalibDegeri[11]  = eksiDegerler[8];
              aktifSensorEksiKalibDegeri[14]  = eksiDegerler[9];


              icNemDeger=nemDegerler[0];
              icNemArtiKalibDegeri=nemDegerler[1];
              icNemEksiKalibDegeri=nemDegerler[2];
              disNemDeger=nemDegerler[3];
              disNemArtiKalibDegeri=nemDegerler[4];
              disNemEksiKalibDegeri=nemDegerler[5];

              //socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (!timerCancel) {
              setState(() {});
            }
          },
        );
      }).catchError((Object error) {
        print(error.toString()+"Deneme");
        if(!timerCancel)
          Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e.toString()+"DEneme2");
      if(!timerCancel)
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }


  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik, onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlar, birler, ondalik, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      String veri="";

      for (var i = 1; i <= 15; i++) {
        if(_index==i){
          aktifSensorArtiKalibDegeri[_index]=(_onlar*10+_birler).toString()+'.'+_ondalik.toString();
          veri=aktifSensorArtiKalibDegeri[_index];
        }
        if(_index==i+100){
          aktifSensorEksiKalibDegeri[_index-100]=(_onlar*10+_birler).toString()+'.'+_ondalik.toString();
          veri=aktifSensorEksiKalibDegeri[_index-100];
        }
      }
      String id="";
      if(isisensorBaglanti==1){
        if(_index<100){
          id=aktifSensorID[_index];
        }else{
          id=aktifSensorID[_index-100];
        }
    }


      if (veriGonderilsinMi && isisensorBaglanti==1) {
        _veriGonder("18*$isisensorBaglanti*$id*$_index*$veri");
      }else if(veriGonderilsinMi && isisensorBaglanti==2){
        _veriGonder("19*$_index*$veri");
      }

      setState(() {});
    });
  }


  Widget _aktifSensor(int index, double oran) {
    return Expanded(
      child: Visibility(
        visible: aktifSensorVisibility[index],
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              Dil().sec(dilSecimi, "tv50") +
                  aktifSensorNo[index].toString(),
              style: TextStyle(
                  fontSize: 14,
                  color: aktifSensorNo[index] == 0
                      ? Colors.black
                      : Colors.blue[700],
                  fontWeight: aktifSensorNo[index] == 0
                      ? FontWeight.normal
                      : FontWeight.bold),
              textScaleFactor: oran,
            ),
            Expanded(
              child: RawMaterialButton(
                onPressed: () {
                  bottomDrawerAktif=true;
                  int sayac1=0;

                  showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, state) {

                                    if(sayac1==0){

                                      Timer.periodic(Duration(seconds: 2), (timer) {

                                        if(!bottomDrawerAktif){
                                          timer.cancel();
                                        }else{
                                          bottomDrawerIcindeGuncelle(state); 
                                        }
                                        
                                
                                    });
                                    }
                                    

                                    sayac1++;

                                    return Container(
                                      color: Colors.orange,
                                      height: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          //Başlık bölümü
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              Dil().sec(
                                                  dilSecimi, "tv436"),
                                                  textScaleFactor: oran,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          //Sensor +,- kalibrasyon bölümü
                                          Expanded(
                                            flex: 10,
                                            child: Container(
                                              color: Colors.white,

                                              child:Row(
                                                children: <Widget>[
                                                Expanded(
                                                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          
                                                          RaisedButton(elevation: 16,
                                                    onPressed: (){
                                                      _index = index;
                                                      _onlar = int.parse(
                                                                  aktifSensorArtiKalibDegeri[index].split(".")[0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(
                                                                  aktifSensorArtiKalibDegeri[index].split(".")[0]) ~/
                                                              10);
                                                      _birler =
                                                          int.parse(aktifSensorArtiKalibDegeri[index].split(".")[0]) %
                                                              10;
                                                      _ondalik =
                                                          int.parse(aktifSensorArtiKalibDegeri[index].split(".")[1]);
               
                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv438",
                                                          "").then((value) {
                                                            bottomDrawerIcindeGuncelle(state);
                                                          });
                                                    },
                                                    
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(Dil().sec(dilSecimi, "tv438"),
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: oran,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        fontSize: 30,
                                                        color: Colors.yellow

                                                      ),
                                                      ),
                                                        Text(
                                                                   aktifSensorArtiKalibDegeri[index],
                                                                   textScaleFactor: oran,
                                                                   style: TextStyle(
                                                                     fontFamily: 'Kelly Slab',
                                                                     fontSize: 50,
                                                                     color: Colors.white
                                                                     
                                                                   ),
                                                        ),
                                                      ],
                                                    ),
                                                    color: Colors.blueGrey[700],
                                                    ),
                                                        ],
                                                      ),
                                                ),
                                                Expanded(child: 
                                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(alignment: Alignment.bottomCenter,
                                                          child: Text(aktifSensorID[index]+' '+Dil().sec(dilSecimi, "tv437"),
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: oran,
                                                      style: TextStyle(
                                                          fontFamily: 'Kelly Slab',

                                                      ),
                                                      ),
                                                        ),
                                                    ),
                                                    Expanded(
                                                      child: Container(alignment: Alignment.topCenter,
                                                        padding:  EdgeInsets.only(left:15*oran, right: 15*oran),
                                                        child: Text(aktifSensorValue[index],
                                                        style: TextStyle(
                                                          
                                                          fontFamily: 'Kelly Slab',
                                                          fontSize: 50*oran,
                                                          color: Colors.grey[600],
                                                          fontWeight: FontWeight.bold),),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                ,)
                                                ,Expanded(
                                                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          
                                                          RaisedButton(elevation: 16,
                                                    onPressed: (){
                                                      _index = index+100;
                                                      _onlar = int.parse(
                                                                  aktifSensorEksiKalibDegeri[index].split(".")[0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(
                                                                  aktifSensorEksiKalibDegeri[index].split(".")[0]) ~/
                                                              10);
                                                      _birler =
                                                          int.parse(aktifSensorEksiKalibDegeri[index].split(".")[0]) %
                                                              10;
                                                      _ondalik =
                                                          int.parse(aktifSensorEksiKalibDegeri[index].split(".")[1]);
               
                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv439",
                                                          "").then((value) {
                                                            bottomDrawerIcindeGuncelle((fn) { });
                                                          });
                                                    },
                                                    
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(Dil().sec(dilSecimi, "tv439"),
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: oran,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        fontSize: 30,
                                                        color: Colors.yellow

                                                      ),
                                                      ),
                                                        Text(
                                                                   aktifSensorEksiKalibDegeri[index],
                                                                   textScaleFactor: oran,
                                                                   style: TextStyle(
                                                                     fontFamily: 'Kelly Slab',
                                                                     fontSize: 50,
                                                                     color: Colors.white
                                                                     
                                                                   ),
                                                        ),
                                                      ],
                                                    ),
                                                    color: Colors.blueGrey[700],
                                                    ),
                                                        ],
                                                      ),
                                                ),
                                                
                                              ],)
                                              
                                              ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).whenComplete((){
                                bottomDrawerAktif=false;
                              });
                        



                },
                fillColor:
                    aktifSensorDurum[index] ? Colors.green[300] : Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(3.0 * oran),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              aktifSensorID[index] + " :",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              aktifSensorValue[index] + "°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(minWidth: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _aktifSensorNem(int index, double oran) {
    return Expanded(
      child: Visibility(
        visible: index==1 ? true : (disNemAktif=="1" ? true : false),
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              Dil().sec(dilSecimi, index==1 ? "tv441" : "tv442"),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textScaleFactor: oran,
            ),
            Expanded(
              child: RawMaterialButton(
                onPressed: () {
                  bottomDrawerAktif=true;
                  int sayac1=0;

                  showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, state) {

                                    if(sayac1==0){

                                      Timer.periodic(Duration(seconds: 2), (timer) {

                                        if(!bottomDrawerAktif){
                                          timer.cancel();
                                        }else{
                                          bottomDrawerIcindeGuncelle(state); 
                                        }
                                        
                                
                                    });
                                    }
                                    

                                    sayac1++;

                                    return Container(
                                      color: Colors.orange,
                                      height: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          //Başlık bölümü
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              Dil().sec(
                                                  dilSecimi, "tv436"),
                                                  textScaleFactor: oran,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          //Sensor +,- kalibrasyon bölümü
                                          Expanded(
                                            flex: 10,
                                            child: Container(
                                              color: Colors.white,

                                              child:Row(
                                                children: <Widget>[
                                                Expanded(
                                                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          
                                                          RaisedButton(elevation: 16,
                                                    onPressed: (){
                                                      _index = index+200;
                                                      String veri=index==1 ? icNemArtiKalibDegeri : disNemArtiKalibDegeri;
                                                      _onlar = int.parse(
                                                                  veri.split(".")[0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(
                                                                  veri.split(".")[0]) ~/
                                                              10);
                                                      _birler =
                                                          int.parse(veri.split(".")[0]) %
                                                              10;
                                                      _ondalik =
                                                          int.parse(veri.split(".")[1]);
               
                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv441",
                                                          "").then((value) {
                                                            bottomDrawerIcindeGuncelle(state);
                                                          });
                                                    },
                                                    
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(Dil().sec(dilSecimi, "tv438"),
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: oran,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        fontSize: 30,
                                                        color: Colors.yellow

                                                      ),
                                                      ),
                                                        Text(
                                                                   index==1 ? icNemArtiKalibDegeri : disNemArtiKalibDegeri,
                                                                   textScaleFactor: oran,
                                                                   style: TextStyle(
                                                                     fontFamily: 'Kelly Slab',
                                                                     fontSize: 50,
                                                                     color: Colors.white
                                                                     
                                                                   ),
                                                        ),
                                                      ],
                                                    ),
                                                    color: Colors.blueGrey[700],
                                                    ),
                                                        ],
                                                      ),
                                                ),
                                                Expanded(child: 
                                                      Column(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Container(alignment: Alignment.bottomCenter,
                                                          child: Text(Dil().sec(dilSecimi, index==1 ? "tv443" : "tv444")+'\n'+Dil().sec(dilSecimi, index==1 ? "tv441" : "tv442")+' (%)',
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: oran,
                                                      style: TextStyle(
                                                          fontFamily: 'Kelly Slab',

                                                      ),
                                                      ),
                                                        ),
                                                    ),
                                                    Expanded(
                                                      child: Container(alignment: Alignment.topCenter,
                                                        padding:  EdgeInsets.only(left:15*oran, right: 15*oran),
                                                        child: Text(index==1 ? icNemDeger : disNemDeger,
                                                        style: TextStyle(
                                                          
                                                          fontFamily: 'Kelly Slab',
                                                          fontSize: 50*oran,
                                                          color: Colors.grey[600],
                                                          fontWeight: FontWeight.bold),),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                ,),
                                                Expanded(
                                                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          
                                                          RaisedButton(elevation: 16,
                                                    onPressed: (){
                                                      _index = index+200;
                                                      String veri=index==1 ? icNemEksiKalibDegeri : disNemEksiKalibDegeri;
                                                      _onlar = int.parse(
                                                                  veri.split(".")[0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(
                                                                  veri.split(".")[0]) ~/
                                                              10);
                                                      _birler =
                                                          int.parse(veri.split(".")[0]) %
                                                              10;
                                                      _ondalik =
                                                          int.parse(veri.split(".")[1]);
               
                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv439",
                                                          "").then((value) {
                                                            bottomDrawerIcindeGuncelle((fn) { });
                                                          });
                                                    },
                                                    
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(Dil().sec(dilSecimi, "tv439"),
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: oran,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        fontSize: 30,
                                                        color: Colors.yellow

                                                      ),
                                                      ),
                                                        Text(
                                                                   index==1 ? icNemEksiKalibDegeri : disNemEksiKalibDegeri,
                                                                   textScaleFactor: oran,
                                                                   style: TextStyle(
                                                                     fontFamily: 'Kelly Slab',
                                                                     fontSize: 50,
                                                                     color: Colors.white
                                                                     
                                                                   ),
                                                        ),
                                                      ],
                                                    ),
                                                    color: Colors.blueGrey[700],
                                                    ),
                                                        ],
                                                      ),
                                                ),
                                                
                                              ],)
                                              
                                              ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).whenComplete((){
                                bottomDrawerAktif=false;
                              });
                        



                },
                fillColor:
                    Colors.green[300],
                child: Padding(
                  padding: EdgeInsets.all(3.0 * oran),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              index==1 ? Dil().sec(dilSecimi, "tv443") : Dil().sec(dilSecimi, "tv444") ,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              (index ==1 ? icNemDeger : disNemDeger) + " %",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(minWidth: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }


Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  //--------------------------METOTLAR--------------------------------

}
