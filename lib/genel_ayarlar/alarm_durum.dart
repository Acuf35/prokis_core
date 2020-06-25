
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class AlarmUyariDurum extends StatefulWidget {
  List<Map> gelenDBveri;
  AlarmUyariDurum(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return AlarmUyariDurumState(gelenDBveri);
  }
}

class AlarmUyariDurumState extends State<AlarmUyariDurum> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  List<Map> dbVeriler;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum="";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";


  List<bool> alarmProkisDurum = new List.filled(61, false);
  List<bool> alarmProkis = new List.filled(61, false);
  List<String> alarmProkisZaman = new List.filled(61, "");
  List<int> alarmProkisSayac = new List.filled(61, 0);
  List<String> alarmProkisHataKodu = new List.filled(61, "0");

  List<bool> uyariProkisDurum = new List.filled(21, false);
  List<bool> uyariProkis = new List.filled(21, false);
  List<String> uyariProkisZaman = new List.filled(21, "");
  List<int> uyariProkisSayac = new List.filled(21, 0);
  List<String> uyariProkisHataKodu = new List.filled(21, "0");
  
  
  bool alarmTimedOutDurum=false;
  bool alarmTimedOut=false;
  String alarmTimedOutZaman="";
  int alarmTimedOutSayac=0;
  String alarmTimedOutHataKodu="0";

  bool alarmConnectionFailedDurum=false;
  bool alarmConnectionFailed=false;
  String alarmConnectionFailedZaman="";
  int alarmConnectionFailedSayac=0;
  String alarmConnectionFailedHataKodu="0";

  bool alarmConnectionRefusedDurum=false;
  bool alarmConnectionRefused=false;
  String alarmConnectionRefusedZaman="";
  int alarmConnectionRefusedSayac=0;
  String alarmConnectionRefusedHataKodu="0";

  bool alarmBilinmeyenDurum=false;
  bool alarmBilinmeyen=false;
  String alarmBilinmeyenZaman="";
  int alarmBilinmeyenSayac=0;
  String alarmBilinmeyenHataKodu="0";

  bool alarmResetByPeerDurum=false;
  bool alarmResetByPeer=false;
  String alarmResetByPeerZaman="";
  int alarmResetByPeerSayac=0;
  String alarmResetByPeerHataKodu="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  AlarmUyariDurumState(List<Map> dbVeri) {
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
    timerCancel=true;
    super.dispose();
  }

  Metotlar metotlar=new Metotlar();
  

  @override
  Widget build(BuildContext context) {

    final dbProkis = Provider.of<DBProkis>(context);

    if (timerSayac == 0) {
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

    return Scaffold(
      
      appBar: Metotlar().appBarAlarm(dilSecimi, context, oran, 'tv717',baglantiDurum, alarmDurum),
      body: Column(
        children: <Widget>[
          //Saat&Tarih
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
          SizedBox(height: 5*oran,),
          Expanded(
            child: RaisedButton(
              onPressed: (){

              yazmaSonrasiGecikmeSayaci = 0;
              Metotlar().veriGonder("38*", 2235).then((value) {
                if (value.split("*")[0] == "error") {
                  Toast.show(
                      Metotlar().errorToastMesaj(value.split("*")[1], dbProkis),
                      context,
                      duration: 3);
                } else {
                  Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

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


                      for(int i=0;i<=59;i++){
                  
                        if(alarmDurum.substring(i,i+1)=="0" && dbProkis.dbVeriGetir(100+i, 1, "0")=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="1"){
                          dbProkis.dbSatirEkleGuncelle(100+i, "1", "0", dbProkis.dbVeriGetir(100+i, 3, "0"), "0");
                        }

                      }

                      for(int i=60;i<=79;i++){
                        
                        if(alarmDurum.substring(i,i+1)=="0" && dbProkis.dbVeriGetir(100+i, 1, "0")=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="1"){
                          dbProkis.dbSatirEkleGuncelle(100+i, "1", "0", dbProkis.dbVeriGetir(100+i, 3, "0"), "0");
                        }

                      }



                      if(!timerCancel)
                        setState(() {});
                    }
                  });
                }
              });



                
              },
              child: Text("ALARMLARI GÜNCELLE"),
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 5*oran,),
          Expanded(
            flex: 8,
            child: ListView.builder
            
                    (
                      itemCount: 79,
                      itemBuilder: (BuildContext ctxt, int index) {
                        
                      return Visibility(visible: dbProkis.dbVeriGetir(100+index, 1, "0")=="1" ? true : false,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom:10*oran),
                    color: Colors.grey[300],
                    child: ExpansionTile(
                      backgroundColor: Colors.grey[300],

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: LayoutBuilder(builder:
                            (context,
                                constraint) {
                          return Icon(
                            index<=59 ? Icons.add_alert : Icons.warning,
                            size: constraint
                                .biggest
                                .width,
                            color: index<=59 ? ( dbProkis.dbVeriGetir(100+index, 2, "0")=="1" ? Colors.red : Colors.green[400] ) : 
                            ( dbProkis.dbVeriGetir(100+index, 2, "0")=="1" ? Colors.yellow[700] : Colors.green[400]),
                          );
                        }),
                      ),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            index <=59 ? Dil().sec(dilSecimi, "alarm${index+1}") : Dil().sec(dilSecimi, "uyari${index+1}"),
                            textScaleFactor: oran,
                            style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                dbProkis.dbVeriGetir(100+index, 3, "0"),
                                textScaleFactor: oran,
                              ),
                              RawMaterialButton(
                                onPressed: (){
                                  if(dbProkis.dbVeriGetir(100+index, 1, "0")=="1" && dbProkis.dbVeriGetir(100+index, 2, "0")=="1"){
                                    Toast.show(Dil().sec(dilSecimi, "toast99"), context, duration: 3);
                                  }else{
                                    dbProkis.dbSatirEkleGuncelle(100+index, "0", "0", "0", "0");
                                  }
                                  
                                },
                                child: Text(
                                  index<=59 ? Dil().sec(dilSecimi, "tv718") : Dil().sec(dilSecimi, "tv719"),
                                  style: TextStyle(
                                    fontFamily: 'Kelly Slab',
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                constraints: BoxConstraints(),
                                fillColor: Colors.yellow,
                                padding: EdgeInsets.only(top: 8*oran, bottom: 5*oran, left:20*oran, right: 20*oran),
                              ),
                            ],
                          )
                        ],
                      ),
                      children: <Widget>[
                        Text(
                          Dil().sec(dilSecimi, "tv720"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                          ),
                          textScaleFactor: oran,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5*oran, right: 5*oran),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "\n"+Dil().sec(dilSecimi, "alarminfo${index+1}"),
                            style: TextStyle(
                              fontFamily: 'Kelly Slab',
                            ),
                            textScaleFactor: oran,
                          ),
                        )
                      ],
                    ),
                  ),
                );

                      //Text(dbProkis.dbVeriGetir(100+index, 1, "aa"));
                      
                      }
                    )
            
          ),
          /*
          Expanded(
            flex: 20,
            child: ListView.builder
                    (
                      itemCount: 79,
                      itemBuilder: (BuildContext ctxt, int index) {
                        
                      return Text(dbProkis.dbVeriGetir(100+index, 1, "aa") + " - " + dbProkis.dbVeriGetir(100+index, 2, "bb") + " - " + dbProkis.dbVeriGetir(100+index, 3, "cc") );
                      
                      }
                    )
            
          )
        */
        
        ],
      ),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
              child: FittedBox(
                              child: FloatingActionButton(
          onPressed: () {
            timerCancel=true;
            dbProkis.dbSatirEkleGuncelle(48, "1", "1", "1", "1");
            Navigator.pop(context);

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
                      Dil().sec(dilSecimi, "tv691"), 
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
                                  text: Dil().sec(dilSecimi, "info49"),
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
      drawer: Metotlar().navigatorMenu(dilSecimi, context, oran)
      
      
      );
  
    
    
  }

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
}



/*
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
              
              print(baglantiDurum);

              if(baglantiDurum.contains("Connection timed out")){
                alarmTimedOutDurum=true;
                alarmTimedOut=true;
              }
              if(baglantiDurum.contains("Connection failed")){
                alarmConnectionFailedDurum=true;
                alarmConnectionFailed=true;
              }
              if(baglantiDurum.contains("Connection refused")){
                alarmConnectionRefusedDurum=true;
                alarmConnectionRefused=true;
              }


              if(alarmConnectionFailed &&alarmConnectionFailedDurum && alarmConnectionFailedSayac==0){
                alarmConnectionFailedSayac++;
                alarmConnectionFailedZaman=Metotlar().getSystemDate(dbVeriler)+" - "+Metotlar().getSystemTime(dbVeriler);
              }

              if(alarmTimedOut && alarmTimedOutDurum && alarmTimedOutSayac==0){
                alarmTimedOutSayac++;
                alarmTimedOutZaman=Metotlar().getSystemDate(dbVeriler)+" - "+Metotlar().getSystemTime(dbVeriler);
              }
              if(alarmConnectionRefused && alarmConnectionRefusedDurum && alarmConnectionRefusedSayac==0){
                alarmConnectionRefusedSayac++;
                alarmConnectionRefusedZaman=Metotlar().getSystemDate(dbVeriler)+" - "+Metotlar().getSystemTime(dbVeriler);
              }

              setState(() {});
            }else{
              alarmDurum=veri;
              baglantiDurum="";
              baglanti=false;
              
              alarmConnectionFailed=false;
              alarmConnectionFailedSayac=0;
              alarmTimedOut=false;
              alarmTimedOutSayac=0;
              alarmConnectionRefused=false;
              alarmConnectionRefusedSayac=0;

              if(!timerCancel)
                setState(() {});
            }
          });
        }
      });
*/
