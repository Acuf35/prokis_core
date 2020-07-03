
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

class BaglantiDurum extends StatefulWidget {
  List<Map> gelenDBveri;
  BaglantiDurum(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return BaglantiDurumState(gelenDBveri);
  }
}

class BaglantiDurumState extends State<BaglantiDurum> {
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
  BaglantiDurumState(List<Map> dbVeri) {
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
      metotlar.takipEt("alarm*", 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              var xx=baglantiDurum.split("*");
              alarmConnectionFailedDurum=xx[0]=="1" ? true : false;
              alarmConnectionFailed=xx[1]=="1" ? true : false;
              alarmConnectionFailedZaman=xx[2];
              alarmConnectionFailedHataKodu=xx[3];
              alarmTimedOutDurum=xx[4]=="1" ? true : false;
              alarmTimedOut=xx[5]=="1" ? true : false;
              alarmTimedOutZaman=xx[6];
              alarmTimedOutHataKodu=xx[7];
              alarmConnectionRefusedDurum=xx[8]=="1" ? true : false;
              alarmConnectionRefused=xx[9]=="1" ? true : false;
              alarmConnectionRefusedZaman=xx[10];
              alarmConnectionRefusedHataKodu=xx[11];
              alarmBilinmeyenDurum=xx[12]=="1" ? true : false;
              alarmBilinmeyen=xx[13]=="1" ? true : false;
              alarmBilinmeyenZaman=xx[14];
              alarmBilinmeyenHataKodu=xx[15];
              alarmResetByPeerDurum=xx[16]=="1" ? true : false;
              alarmResetByPeer=xx[17]=="1" ? true : false;
              alarmResetByPeerZaman=xx[18];
              alarmResetByPeerHataKodu=xx[19];
              

              setState(() {});
            }else{
              alarmDurum=veri;
              baglantiDurum=Metotlar().errorToastMesaj("",dbProkis);
              baglanti=false;

              alarmConnectionFailed=dbProkis.dbVeriGetir(39, 1, "0")=="1" ? true : false; 
              alarmTimedOut=dbProkis.dbVeriGetir(39, 2, "0")=="1" ? true : false; 
              alarmConnectionRefused=dbProkis.dbVeriGetir(39, 3, "0")=="1" ? true : false;
              alarmBilinmeyen=dbProkis.dbVeriGetir(39, 4, "0")=="1" ? true : false;
              alarmResetByPeer=dbProkis.dbVeriGetir(44, 1, "0")=="1" ? true : false;

              alarmConnectionFailedDurum=dbProkis.dbVeriGetir(40, 1, "0")=="1" ? true : false; 
              alarmTimedOutDurum=dbProkis.dbVeriGetir(40, 2, "0")=="1" ? true : false; 
              alarmConnectionRefusedDurum=dbProkis.dbVeriGetir(40, 3, "0")=="1" ? true : false;
              alarmBilinmeyenDurum=dbProkis.dbVeriGetir(40, 4, "0")=="1" ? true : false;
              alarmResetByPeerDurum=dbProkis.dbVeriGetir(45, 1, "0")=="1" ? true : false;

              alarmConnectionFailedZaman=dbProkis.dbVeriGetir(41, 1, "0"); 
              alarmTimedOutZaman=dbProkis.dbVeriGetir(41, 2, "0");
              alarmConnectionRefusedZaman=dbProkis.dbVeriGetir(41, 3, "0");
              alarmBilinmeyenZaman=dbProkis.dbVeriGetir(41, 4, "0");
              alarmResetByPeerZaman=dbProkis.dbVeriGetir(46, 1, "0");

              alarmConnectionFailedHataKodu=dbProkis.dbVeriGetir(42, 1, "0"); 
              alarmTimedOutHataKodu=dbProkis.dbVeriGetir(42, 2, "0");
              alarmConnectionRefusedHataKodu=dbProkis.dbVeriGetir(42, 3, "0");
              alarmBilinmeyenHataKodu=dbProkis.dbVeriGetir(42, 4, "0");
              alarmResetByPeerHataKodu=dbProkis.dbVeriGetir(47, 1, "0");

              
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
          metotlar.takipEt("alarm*", 2236).then((veri){
            if(veri.split("*")[0]=="error"){

              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);

              var xx=baglantiDurum.split("*");
              alarmConnectionFailedDurum=xx[0]=="1" ? true : false;
              alarmConnectionFailed=xx[1]=="1" ? true : false;
              alarmConnectionFailedZaman=xx[2];
              alarmConnectionFailedHataKodu=xx[3];
              alarmTimedOutDurum=xx[4]=="1" ? true : false;
              alarmTimedOut=xx[5]=="1" ? true : false;
              alarmTimedOutZaman=xx[6];
              alarmTimedOutHataKodu=xx[7];
              alarmConnectionRefusedDurum=xx[8]=="1" ? true : false;
              alarmConnectionRefused=xx[9]=="1" ? true : false;
              alarmConnectionRefusedZaman=xx[10];
              alarmConnectionRefusedHataKodu=xx[11];
              alarmBilinmeyenDurum=xx[12]=="1" ? true : false;
              alarmBilinmeyen=xx[13]=="1" ? true : false;
              alarmBilinmeyenZaman=xx[14];
              alarmBilinmeyenHataKodu=xx[15];
              alarmResetByPeerDurum=xx[16]=="1" ? true : false;
              alarmResetByPeer=xx[17]=="1" ? true : false;
              alarmResetByPeerZaman=xx[18];
              alarmResetByPeerHataKodu=xx[19];

              setState(() {});
            }else{
              alarmDurum=veri;
              baglantiDurum=Metotlar().errorToastMesaj("",dbProkis);
              baglanti=false;
              
              alarmConnectionFailed=dbProkis.dbVeriGetir(39, 1, "0")=="1" ? true : false; 
              alarmTimedOut=dbProkis.dbVeriGetir(39, 2, "0")=="1" ? true : false; 
              alarmConnectionRefused=dbProkis.dbVeriGetir(39, 3, "0")=="1" ? true : false;
              alarmBilinmeyen=dbProkis.dbVeriGetir(39, 4, "0")=="1" ? true : false;
              alarmResetByPeer=dbProkis.dbVeriGetir(44, 1, "0")=="1" ? true : false;

              alarmConnectionFailedDurum=dbProkis.dbVeriGetir(40, 1, "0")=="1" ? true : false; 
              alarmTimedOutDurum=dbProkis.dbVeriGetir(40, 2, "0")=="1" ? true : false; 
              alarmConnectionRefusedDurum=dbProkis.dbVeriGetir(40, 3, "0")=="1" ? true : false;
              alarmBilinmeyenDurum=dbProkis.dbVeriGetir(40, 4, "0")=="1" ? true : false;
              alarmResetByPeerDurum=dbProkis.dbVeriGetir(45, 1, "0")=="1" ? true : false;

              alarmConnectionFailedZaman=dbProkis.dbVeriGetir(41, 1, "0"); 
              alarmTimedOutZaman=dbProkis.dbVeriGetir(41, 2, "0");
              alarmConnectionRefusedZaman=dbProkis.dbVeriGetir(41, 3, "0");
              alarmBilinmeyenZaman=dbProkis.dbVeriGetir(41, 4, "0");
              alarmResetByPeerZaman=dbProkis.dbVeriGetir(46, 1, "0");

              alarmConnectionFailedHataKodu=dbProkis.dbVeriGetir(42, 1, "0"); 
              alarmTimedOutHataKodu=dbProkis.dbVeriGetir(42, 2, "0");
              alarmConnectionRefusedHataKodu=dbProkis.dbVeriGetir(42, 3, "0");
              alarmBilinmeyenHataKodu=dbProkis.dbVeriGetir(42, 4, "0");
              alarmResetByPeerHataKodu=dbProkis.dbVeriGetir(47, 1, "0");

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
      
      appBar: Metotlar().appBarBaglanti(dilSecimi, context, oran, 'tv691',baglantiDurum, alarmDurum),
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
          
          SizedBox(height: 20*oran,),
          Expanded(
            flex: 40,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[

                Visibility(visible: alarmConnectionFailedDurum,
                                  child: Container(
                    color: Colors.red[100],
                    child: ExpansionTile(
                      backgroundColor: Colors.grey[300],

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: LayoutBuilder(builder:
                            (context,
                                constraint) {
                          return Icon(
                            Icons
                                .router,
                            size: constraint
                                .biggest
                                .width,
                            color: alarmConnectionFailed ? Colors.red : Colors.green[400],
                          );
                        }),
                      ),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Dil().sec(dilSecimi, "tv692"),
                            textScaleFactor: oran,
                            style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                alarmConnectionFailedZaman,
                                textScaleFactor: oran,
                              ),
                              RawMaterialButton(
                                onPressed: (){
                                  if(alarmConnectionFailed && alarmConnectionFailedDurum){
                                    Toast.show(Dil().sec(dilSecimi, "toast98"), context, duration: 3);
                                  }else{
                                    alarmConnectionFailedDurum=false;
                                    dbProkis.dbSatirEkleGuncelle(40, "0", alarmTimedOutDurum ? "1" : "0", alarmConnectionRefusedDurum ? "1" : "0", alarmBilinmeyenDurum ? "1" : "0");
                                  }
                                  
                                },
                                child: Text(
                                  Dil().sec(dilSecimi, "tv695"),
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
                          Dil().sec(dilSecimi, "tv721"),
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
                            "\n"+Dil().sec(dilSecimi, "tv698")+": "+alarmConnectionFailedHataKodu+"\n\n"+
                            Dil().sec(dilSecimi, "baglantiinfo1"),
                            style: TextStyle(
                              fontFamily: 'Kelly Slab',
                            ),
                            textScaleFactor: oran,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(visible:alarmConnectionFailedDurum,child: SizedBox(height: 10*oran,)),
                Visibility(visible: alarmTimedOutDurum,
                                  child: Container(
                    color: Colors.red[100],
                    child: ExpansionTile(
                      backgroundColor: Colors.grey[300],

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: LayoutBuilder(builder:
                            (context,
                                constraint) {
                          return Icon(
                            Icons
                                .router,
                            size: constraint
                                .biggest
                                .width,
                            color: alarmTimedOut ? Colors.red : Colors.green[400],
                          );
                        }),
                      ),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Dil().sec(dilSecimi, "tv693"),
                            textScaleFactor: oran,
                            style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                alarmTimedOutZaman,
                                textScaleFactor: oran,
                              ),
                              RawMaterialButton(
                                onPressed: (){
                                  if(alarmTimedOut && alarmTimedOutDurum){
                                    Toast.show(Dil().sec(dilSecimi, "toast98"), context, duration: 3);
                                  }else{
                                    alarmTimedOutDurum=false;
                                    dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" : "0", "0", alarmConnectionRefusedDurum ? "1" : "0", alarmBilinmeyenDurum ? "1" : "0");
                                  }
                                  
                                },
                                child: Text(
                                  Dil().sec(dilSecimi, "tv695"),
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
                          Dil().sec(dilSecimi, "tv721"),
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
                            "\n"+Dil().sec(dilSecimi, "tv698")+": "+alarmTimedOutHataKodu+"\n\n"+
                            Dil().sec(dilSecimi, "baglantiinfo2"),
                            style: TextStyle(
                              fontFamily: 'Kelly Slab',
                            ),
                            textScaleFactor: oran,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(visible:alarmTimedOutDurum,child: SizedBox(height: 10*oran,)),
                Visibility(visible: alarmConnectionRefusedDurum,
                                  child: Container(
                    color: Colors.red[100],
                    child: ExpansionTile(
                      backgroundColor: Colors.grey[300],

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: LayoutBuilder(builder:
                            (context,
                                constraint) {
                          return Icon(
                            Icons
                                .router,
                            size: constraint
                                .biggest
                                .width,
                            color: alarmConnectionRefused ? Colors.red : Colors.green[400],
                          );
                        }),
                      ),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Dil().sec(dilSecimi, "tv694"),
                            textScaleFactor: oran,
                            style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                alarmConnectionRefusedZaman,
                                textScaleFactor: oran,
                              ),
                              RawMaterialButton(
                                onPressed: (){
                                  if(alarmConnectionRefused && alarmConnectionRefusedDurum){
                                    Toast.show(Dil().sec(dilSecimi, "toast98"), context, duration: 3);
                                  }else{
                                    alarmConnectionRefusedDurum=false;
                                    dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" : "0", alarmTimedOutDurum ? "1" : "0", "0", alarmBilinmeyenDurum ? "1" : "0");
                                  }
                                  
                                  
                                },
                                child: Text(
                                  Dil().sec(dilSecimi, "tv695"),
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
                          Dil().sec(dilSecimi, "tv721"),
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
                            "\n"+Dil().sec(dilSecimi, "tv698")+": "+alarmConnectionRefusedHataKodu+"\n\n"+
                            Dil().sec(dilSecimi, "baglantiinfo3"),
                            style: TextStyle(
                              fontFamily: 'Kelly Slab',
                            ),
                            textScaleFactor: oran,
                          ),
                        ),




                      ],
                    ),
                  ),
                ),
                Visibility(visible:alarmConnectionRefusedDurum,child: SizedBox(height: 10*oran,)),
                Visibility(visible: alarmBilinmeyenDurum,
                                  child: Container(
                    color: Colors.red[100],
                    child: ExpansionTile(
                      backgroundColor: Colors.grey[300],

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: LayoutBuilder(builder:
                            (context,
                                constraint) {
                          return Icon(
                            Icons
                                .router,
                            size: constraint
                                .biggest
                                .width,
                            color: alarmBilinmeyen ? Colors.red : Colors.green[400],
                          );
                        }),
                      ),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Dil().sec(dilSecimi, "tv696"),
                            textScaleFactor: oran,
                            style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                alarmBilinmeyenZaman,
                                textScaleFactor: oran,
                              ),
                              RawMaterialButton(
                                onPressed: (){
                                  if(alarmBilinmeyen && alarmBilinmeyenDurum){
                                    Toast.show(Dil().sec(dilSecimi, "toast98"), context, duration: 3);
                                  }else{
                                    alarmBilinmeyenDurum=false;
                                    dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" : "0", alarmTimedOutDurum ? "1" : "0", alarmConnectionRefusedDurum ? "1" : "0", "0");
                                  }
                                  
                                  
                                },
                                child: Text(
                                  Dil().sec(dilSecimi, "tv695"),
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
                          Dil().sec(dilSecimi, "tv721"),
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
                            "\n"+Dil().sec(dilSecimi, "tv698")+": "+alarmBilinmeyenHataKodu+"\n\n"+
                            Dil().sec(dilSecimi, "baglantiinfo5"),
                            style: TextStyle(
                              fontFamily: 'Kelly Slab',
                            ),
                            textScaleFactor: oran,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(visible:alarmResetByPeerDurum,child: SizedBox(height: 10*oran,)),
                Visibility(visible: alarmResetByPeerDurum,
                                  child: Container(
                    color: Colors.red[100],
                    child: ExpansionTile(
                      backgroundColor: Colors.grey[300],

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: LayoutBuilder(builder:
                            (context,
                                constraint) {
                          return Icon(
                            Icons
                                .router,
                            size: constraint
                                .biggest
                                .width,
                            color: alarmResetByPeer ? Colors.red : Colors.green[400],
                          );
                        }),
                      ),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Dil().sec(dilSecimi, "tv697"),
                            textScaleFactor: oran,
                            style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                alarmResetByPeerZaman,
                                textScaleFactor: oran,
                              ),
                              RawMaterialButton(
                                onPressed: (){
                                  if(alarmResetByPeer && alarmResetByPeerDurum){
                                    Toast.show(Dil().sec(dilSecimi, "toast98"), context, duration: 3);
                                  }else{
                                    alarmResetByPeerDurum=false;
                                    dbProkis.dbSatirEkleGuncelle(45, "0", "0", "0", "0");
                                  }
                                  
                                  
                                },
                                child: Text(
                                  Dil().sec(dilSecimi, "tv695"),
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
                          Dil().sec(dilSecimi, "tv721"),
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
                            "\n"+Dil().sec(dilSecimi, "tv698")+": "+alarmResetByPeerHataKodu+"\n\n"+
                            Dil().sec(dilSecimi, "baglantiinfo4"),
                            style: TextStyle(
                              fontFamily: 'Kelly Slab',
                            ),
                            textScaleFactor: oran,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(visible:alarmBilinmeyenDurum,child: SizedBox(height: 10*oran,)),
                
                
                
                
                ListTile(
                  leading: SizedBox(
                    height: 100 * oran,
                    
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
              child: FittedBox(
                              child: FloatingActionButton(
          onPressed: () {
            timerCancel=true;
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
