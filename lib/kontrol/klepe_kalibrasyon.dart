import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'klepe_klasik.dart';
import 'klepe_tunel.dart';
import 'package:prokis/languages/select.dart';

class KlepeKalibrasyon extends StatefulWidget {
  List<Map> gelenDBveri;
  KlepeKalibrasyon(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KlepeKalibrasyonState(gelenDBveri);
  }
}

class KlepeKalibrasyonState extends State<KlepeKalibrasyon> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String klepeAdet = "0";
  String kurulumDurum = "0";
  String klepeYontemi = "0";
  List<Map> dbVeriler;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  List<String> manKalibrasyonYap = new List(11);
  List<String> kalibrasyonAktuel = new List(11);
  List<String> kalibrasyonSuresi = new List(11);
  List<String> otoManDurum = new List(11);

  String baglantiDurum="";
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KlepeKalibrasyonState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 37) {
        klepeAdet = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 8) {
        klepeYontemi = dbVeri[i]["veri1"];
      }
    }

    for (int i = 1; i <= 10; i++) {
      manKalibrasyonYap[i] = "0";
      kalibrasyonAktuel[i] = "0";
      kalibrasyonSuresi[i] = "0";
      otoManDurum[i] = "0";
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

@override
  void dispose() {
    timerCancel=true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {

      Metotlar().takipEt('8*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          
          Metotlar().takipEt('8*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv239',baglantiDurum, alarmDurum),
        body: Column(
          children: <Widget>[
            Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(dbVeriler),
                            style: TextStyle(
                                  color: Colors.blue[800],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
              
              Expanded(
                              child: Container(alignment: Alignment.centerRight,color: Colors.grey[300],padding: EdgeInsets.only(right: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemDate(dbVeriler),
                            style: TextStyle(
                                  color: Colors.blue[800],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
            ],
          ),
          
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 10 * oran),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Spacer(flex: 4),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv233"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv234"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv235"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                ],
                            ),
                          ),
                          Visibility(
                              visible: int.parse(klepeAdet) > 0,
                              child: _klepeKlasikUnsur(oran, 1)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 1,
                              child: _klepeKlasikUnsur(oran, 2)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 2,
                              child: _klepeKlasikUnsur(oran, 3)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 3,
                              child: _klepeKlasikUnsur(oran, 4)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 4,
                              child: _klepeKlasikUnsur(oran, 5)),
                          Spacer(
                            flex: 4,
                            
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Visibility(
                              visible: int.parse(klepeAdet) > 5,
                              child: Column(
                                children: <Widget>[
                                  Spacer(flex: 4),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv233"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv234"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv235"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                              visible: int.parse(klepeAdet) > 5,
                              child: _klepeKlasikUnsur(oran, 6)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 6,
                              child: _klepeKlasikUnsur(oran, 7)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 7,
                              child: _klepeKlasikUnsur(oran, 8)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 8,
                              child: _klepeKlasikUnsur(oran, 9)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 9,
                              child: _klepeKlasikUnsur(oran, 10)),
                          Spacer(
                            flex: 4,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Container(width: 56*oran,height: 56*oran,
          child: FittedBox(
                      child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                if(klepeYontemi=="1"){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KlepeKlasik(dbVeriler)),
                    );
                }
                if(klepeYontemi=="2"){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KlepeTunel(dbVeriler)),
                    );  
                }
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
        endDrawer: SizedBox(width: 320*oran,
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
                Dil().sec(
                    dilSecimi, "tv240"), 
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
            flex: 10,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.yellow[100],
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 2 * oran, right: 2 * oran),
                          dense: false,
                          title: Text(
                            Dil()
                                .sec(dilSecimi, "tv186"),
                            textScaleFactor: oran,
                          ),
                          subtitle: Text(
                            Dil()
                                .sec(dilSecimi, "info9"),
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

  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('#');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              kalibrasyonAktuel[1]=degerler[0].split('*')[0]=='True' ? '1' : '0';
              kalibrasyonAktuel[2]=degerler[0].split('*')[1]=='True' ? '1' : '0';
              kalibrasyonAktuel[3]=degerler[0].split('*')[2]=='True' ? '1' : '0';
              kalibrasyonAktuel[4]=degerler[0].split('*')[3]=='True' ? '1' : '0';
              kalibrasyonAktuel[5]=degerler[0].split('*')[4]=='True' ? '1' : '0';
              kalibrasyonAktuel[6]=degerler[0].split('*')[5]=='True' ? '1' : '0';
              kalibrasyonAktuel[7]=degerler[0].split('*')[6]=='True' ? '1' : '0';
              kalibrasyonAktuel[8]=degerler[0].split('*')[7]=='True' ? '1' : '0';
              kalibrasyonAktuel[9]=degerler[0].split('*')[8]=='True' ? '1' : '0';
              kalibrasyonAktuel[10]=degerler[0].split('*')[9]=='True' ? '1' : "0";
              print(kalibrasyonAktuel[1]);
              print(degerler[0].split('*')[4]);

              kalibrasyonSuresi[1]=degerler[1].split('*')[0];
              kalibrasyonSuresi[2]=degerler[1].split('*')[1];
              kalibrasyonSuresi[3]=degerler[1].split('*')[2];
              kalibrasyonSuresi[4]=degerler[1].split('*')[3];
              kalibrasyonSuresi[5]=degerler[1].split('*')[4];
              kalibrasyonSuresi[6]=degerler[1].split('*')[5];
              kalibrasyonSuresi[7]=degerler[1].split('*')[6];
              kalibrasyonSuresi[8]=degerler[1].split('*')[7];
              kalibrasyonSuresi[9]=degerler[1].split('*')[8];
              kalibrasyonSuresi[10]=degerler[1].split('*')[9];

              otoManDurum[1]=degerler[2].split('*')[0]=='True' ? "1" : "0";
              otoManDurum[2]=degerler[2].split('*')[1]=='True' ? "1" : "0";
              otoManDurum[3]=degerler[2].split('*')[2]=='True' ? "1" : "0";
              otoManDurum[4]=degerler[2].split('*')[3]=='True' ? "1" : "0";
              otoManDurum[5]=degerler[2].split('*')[4]=='True' ? "1" : "0";
              otoManDurum[6]=degerler[2].split('*')[5]=='True' ? "1" : "0";
              otoManDurum[7]=degerler[2].split('*')[6]=='True' ? "1" : "0";
              otoManDurum[8]=degerler[2].split('*')[7]=='True' ? "1" : "0";
              otoManDurum[9]=degerler[2].split('*')[8]=='True' ? "1" : "0";
              otoManDurum[10]=degerler[2].split('*')[9]=='True' ? "1" : "0";

              alarmDurum=degerler[3];



    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 
  Widget _klepeKlasikUnsur(double oran, int klepeNo) {
    return Expanded(
      flex: 5,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Expanded(
                      flex: 8,
                      child: RawMaterialButton(

                        onLongPress: (){

                          yazmaSonrasiGecikmeSayaci = 0;
                          String komut='9*$klepeNo';
                          Metotlar().veriGonder(komut, 2235).then((value){
                            if(value.split("*")[0]=="error"){
                              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                              
                              baglanti = false;
                              Metotlar().takipEt('8*', 2236).then((veri){
                                  if(veri.split("*")[0]=="error"){
                                    baglanti=false;
                                    baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                    setState(() {});
                                  }else{
                                    takipEtVeriIsleme(veri);
                                    baglantiDurum="";
                                  }
                              });
                            }
                          });

                        },
                        onPressed: () {

                          if(kalibrasyonAktuel[klepeNo]=='1'){
                            Toast.show(Dil().sec(dilSecimi, "toast68"), context,duration: 3);
                          }else if(otoManDurum[klepeNo]=='0'){
                            Toast.show(Dil().sec(dilSecimi, "toast69"), context,duration: 3);
                          }else{

                            

                            yazmaSonrasiGecikmeSayaci = 0;
                            String komut='8*$klepeNo';
                            Metotlar().veriGonder(komut, 2235).then((value){
                              if(value.split("*")[0]=="error"){
                                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                              }else{
                                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                
                                baglanti = false;
                                Metotlar().takipEt('8*', 2236).then((veri){
                                    if(veri.split("*")[0]=="error"){
                                      baglanti=false;
                                      baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                      setState(() {});
                                    }else{
                                      takipEtVeriIsleme(veri);
                                      baglantiDurum="";
                                    }
                                });
                              }
                            });

                          }

                          
                        
                        },
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Expanded(flex: 5,
                            child: SizedBox(
                                child: Container(
                                  padding: EdgeInsets.all(5*oran),
                                  decoration: BoxDecoration(
                                    color: kalibrasyonAktuel[klepeNo]=="0" ? Colors.black : Colors.green[700],
                                    borderRadius: BorderRadius.circular(10*oran)
                                  ),
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil()
                                  .sec(dilSecimi, "tv192") +' '+klepeNo.toString()+
                              "\n" +
                             Dil()
                                  .sec(dilSecimi, "tv232"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Kelly Slab',
                                      color: Colors.white,
                                      fontSize: 60,
                                    ),
                                    maxLines:3,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )),
          
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(kalibrasyonAktuel[klepeNo] == '0'
                          ? Dil().sec(dilSecimi, "tv237")
                          : Dil().sec(dilSecimi, "tv236"), textScaleFactor: oran,
                          style: TextStyle(color: kalibrasyonAktuel[klepeNo]=="1" ? Colors.green : Colors.black,
                          fontWeight: kalibrasyonAktuel[klepeNo]=='1' ? FontWeight.bold : FontWeight.normal),),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[300],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      (double.parse(kalibrasyonSuresi[klepeNo])/1000).toStringAsFixed(1) + " " + Dil().sec(dilSecimi, "tv238"),
                      textScaleFactor: oran),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[100],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(otoManDurum[klepeNo] == '0'
                          ? Dil().sec(dilSecimi, "tv221")
                          : Dil().sec(dilSecimi, "tv220"), textScaleFactor: oran,
                          style: TextStyle(fontWeight: otoManDurum[klepeNo]=='1' ? FontWeight.bold : FontWeight.normal),),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
  //--------------------------METOTLAR--------------------------------

}
