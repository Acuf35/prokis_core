import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar/alarm.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/languages/select.dart';

class KornaIptal extends StatefulWidget {
  List<Map> gelenDBveri;
  KornaIptal(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KornaIptalState(gelenDBveri);
  }
}

class KornaIptalState extends State<KornaIptal> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  List<bool> kornaIptal =new List.filled(61, false);

  
  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;

  String baglantiDurum = "";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  String gelenVeri="";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KornaIptalState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }
    

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  void dispose() {
    timerCancel = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);


    if (timerSayac == 0) {
      Metotlar().takipEt('32*', 2236).then((veri) {
        if (veri.split("*")[0] == "error") {
          baglanti = false;
          baglantiDurum =
              Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
          setState(() {});
        } else {
          takipEtVeriIsleme(veri);
          baglantiDurum = "";
        }
      });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;

          Metotlar().takipEt('32*', 2236).then((veri) {
            if (veri.split("*")[0] == "error") {
              baglanti = false;
              baglantiDurum =
                  Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
              setState(() {});
            } else {
              takipEtVeriIsleme(veri);
              baglantiDurum = "";
            }
          });
        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/10)*1;

    return Scaffold(resizeToAvoidBottomPadding: false,
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv726', baglantiDurum, alarmDurum),
      body: Column(
        children: <Widget>[
          //Saat&Tarih
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
                          color: Colors.blue[800],
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
                          color: Colors.blue[800],
                          fontFamily: 'Kelly Slab',
                          fontSize: 12 * oran,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 9,
            child: Container(
            padding: EdgeInsets.only(left:8*oran, right: 8*oran, top: 15*oran),
            color: Colors.white,
            alignment: Alignment.center,
            child: GridView.extent(
                    padding: EdgeInsets.all(0),
                    
                    maxCrossAxisExtent: oranOzel,
                    childAspectRatio: 1.2,
                    

                    children: List.generate(44, (index){
                      return Padding(
                            padding: EdgeInsets.only(left:4*oran,right: 4*oran ),
                            child: Column(
                      children: <Widget>[
                        Expanded(flex: 4,
                          child: SizedBox(
                            child: Container(
                              child: AutoSizeText(
                                Dil().sec(dilSecimi, "korna${index+1}"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: 2,
                                minFontSize: 2,
                              ),
                            ),
                          )
                        ),
                        Expanded(flex: 4,
                                    child: RawMaterialButton(
                              onPressed: (){

                                String veri="";
                                if(kornaIptal[index+1]){
                                  kornaIptal[index+1]=false;
                                  veri="0";
                                }else{
                                  kornaIptal[index+1]=true;
                                  veri="1";
                                }

                                setState(() {});


                                yazmaSonrasiGecikmeSayaci = 0;
                                String komut ="33*${index+1}*$veri";
                                Metotlar().veriGonder(komut, 2235).then((value) {
                                  if (value.split("*")[0] == "error") {
                                    Toast.show(
                                        Dil().sec(dilSecimi, "toast101"),
                                        context,
                                        duration: 3);
                                  } else {
                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

                                    baglanti = false;
                                    Metotlar().takipEt('32*', 2236).then((veri) {
                                      if (veri.split("*")[0] == "error") {
                                        baglanti = false;
                                        baglantiDurum = Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
                                        setState(() {});
                                      } else {
                                        takipEtVeriIsleme(veri);
                                        baglantiDurum = "";
                                      }
                                    });
                                  }
                                });



                              },
                              fillColor: kornaIptal[index+1] ? Colors.green : Colors.grey[600],

                              child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        child: Container(
                                          child: AutoSizeText(
                                            kornaIptal[index+1]==true ? Dil().sec(dilSecimi, "tv236") : Dil().sec(dilSecimi, "tv237"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              fontSize: 60,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                            ),
                                            minFontSize: 2,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                            ),
                        ),
                        Spacer()
                      ],
                            ),
                          );
  

                    })),
            ),
          ),
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
                    builder: (context) => Alarm(dbVeriler)),
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
                      Dil().sec(dilSecimi, "tv726"), 
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
                          subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                //Giriş metni
                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info52"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                
                              ]
                            ),
                          ),
                        
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  takipEtVeriIsleme(String gelenMesaj) {
    var degerler = gelenMesaj.split('*');
    print(degerler);
    print(yazmaSonrasiGecikmeSayaci);

    for (var i = 0; i < 60; i++) {
      kornaIptal[i+1]=degerler[i]=="1" ? true : false;
    }

    alarmDurum=degerler[60];


    

    baglanti = false;
    if (!timerCancel && gelenMesaj!=gelenVeri) {
      gelenVeri=gelenMesaj;
      setState(() {});
    }
  }


 




  Future sayfaGeriAlert(BuildContext context, String dilSecimi,String uyariMetni, DBProkis dbProkis, int index) async {

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {

        return SayfaGeriAlert.deger(dilSecimi, uyariMetni);
      },
    ).then((val) {
      if (val) {

          dbProkis.dbSatirSil(200+index, 200+index);
          for (var i = index; i < 20; i++) {
            dbProkis.dbSatirEkleGuncelle(200+i, dbProkis.dbVeriGetir(200+i+1, 1, ""), dbProkis.dbVeriGetir(200+i+1, 2, ""), "0", "0");
            dbProkis.dbSatirSil(200+i+1, 200+i+1);
          }
          setState(() {
            
          });
      }
    });
  }
  //--------------------------METOTLAR--------------------------------

}
