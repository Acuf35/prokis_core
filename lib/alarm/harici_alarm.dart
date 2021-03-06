import 'dart:async';

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

class HariciAlarm extends StatefulWidget {
  List<Map> gelenDBveri;
  HariciAlarm(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return HariciAlarmState(gelenDBveri);
  }
}

class HariciAlarmState extends State<HariciAlarm> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;


  String hariciAlarmText="";

  
  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;

  String baglantiDurum = "";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  HariciAlarmState(List<Map> dbVeri) {
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

    TextEditingController tec1 = new TextEditingController(text: hariciAlarmText);

    _textFieldCursorPosition(tec1, hariciAlarmText==null ? "" : hariciAlarmText);

    if (timerSayac == 0) {
      dbProkis.dbSatirEkleGuncelle(48, "1", "1", "1", "1");
      Metotlar().takipEt("alarm*", 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              setState(() {});
            }else{
              alarmDurum=veri;
              baglantiDurum="";
              baglanti=false;
              if(!timerCancel)
                setState(() {});
            }
          });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          Metotlar().takipEt("alarm*", 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              setState(() {});
            }else{
              alarmDurum=veri;
              print(veri);
              baglantiDurum="";
              baglanti=false;
              if(!timerCancel)
                setState(() {});
            }
          });
        }
      });
      
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(resizeToAvoidBottomPadding: false,
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv723', baglantiDurum, alarmDurum),
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
            child: Column(
              children: <Widget>[
              Spacer(),
              Expanded(flex: 5,
                child: Padding(padding: EdgeInsets.only(right: 10*oran, left: 10*oran),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 8,
                        child: TextField(
                          maxLength: 55,
                          style: TextStyle(
                              fontFamily: 'Kelly Slab',
                              color: Colors.grey[600],
                              fontSize: 20 * oran),
                          textAlign: TextAlign.left,
                          controller: tec1,
                          onTap: () {
                                  
                                },
                          onChanged: (String metin) {
                            hariciAlarmText = metin;
                          },
                          onSubmitted: (String metin) {
                            
                          },
                          //keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                              labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16 * oran,
                                  fontWeight: FontWeight.bold),
                              labelText: Dil().sec(dilSecimi, "tv725")),
                        ),
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: (){
                            int sayac=0;
                            
                            if(hariciAlarmText.length>=10){
                              for (var i = 200; i <= 219; i++) {
                                if(dbProkis.dbVeriGetir(i, 1, "0")=="ok"){
                                  sayac++;
                                }
                              }
                              print("SAYAÇ: $sayac");
                              dbProkis.dbSatirEkleGuncelle(199+sayac+1, "ok", hariciAlarmText, "0", "0");
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast100"), context,duration: 3);
                            }

                            setState(() {
                              hariciAlarmText="";
                            });
                          },
                          //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //constraints: BoxConstraints(),
                          fillColor: Colors.green[700],
                          child: Text(
                            "+ ${Dil().sec(dilSecimi, "btn14")}",
                            style: TextStyle(
                              fontFamily: 'Audio Wide',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              Expanded(flex: 20,
              
              child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (BuildContext ctxt, int index) {
                        
                      return Visibility(visible: dbProkis.dbVeriGetir(200+index, 1 , "")=="ok" ? true : false,
                          child: Padding(
                            padding: EdgeInsets.only(top:2*oran, bottom: 2*oran),
                            child: RawMaterialButton(
                              onPressed: (){
                                

                                sayfaGeriAlert(context, dilSecimi,"tv724", dbProkis,index);

                              },
                              fillColor: index%2==0 ? Colors.blue[100] : Colors.green[100],
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              constraints: BoxConstraints(),
                              child: Container(
                                padding: EdgeInsets.only(left: 10*oran,top: 10*oran, bottom: 10*oran),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (index+1).toString()+") "+ dbProkis.dbVeriGetir(200+index, 2 , ""),
                                ),
                              )
                        ),
                          )
                      );
                      
                      }
                    )
            
              
              )
                                  
              
              ],
            ),
          )
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
                      Dil().sec(dilSecimi, "tv723"), 
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
                                  text: Dil().sec(dilSecimi, "info51"),
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

  _textFieldCursorPosition(TextEditingController tec, String str) {
    tec
      ..text = str
      ..selection =
          TextSelection.collapsed(offset: str.length != null ? str.length : 0);
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
