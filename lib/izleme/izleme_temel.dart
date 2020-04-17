import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/genel_ayarlar/izleme.dart';
import 'package:prokis/languages/select.dart';

class IzlemeTemel extends StatefulWidget {
  List<Map> gelenDBveri;
  IzlemeTemel(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return IzlemeTemelState(gelenDBveri);
  }
}
String initialVeri="1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*"
"0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*#4*0*0.0*0*158*142*23.0*27.5*24.0*26.0*0*0*0*0*0*0*0#100.0*63.5*63.5*0."
"0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*1*0*0*0*0*0*0*0*0*0*#1*1*1*1*0*0*0*0*0*0*0*1*1*1*0*1*0*0*#0.0*0.0";

class IzlemeTemelState extends State<IzlemeTemel> with TickerProviderStateMixin {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
  String fanAdet="0";
  String sensorBaglanti="0";
  String disNemVarMi="0";

  int unsurAdet = 0;
  int sutunSayisi;
  List<int> fanHaritaGrid = new List(121);
  List<String> fanNo = new List(121);

  List<String> klepeNo = new List(19);
  List<String> pedNo = new List(25);
  List<String> isisensorNo = new List(23);

  String airinletAdet="0";
  String bacaFanAdet="0";
  String isiticiAdet="0";
  String sirkFanAdet="1";

  bool bfanSurucu=false;


  

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IzlemeTemelState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
        
      }

      if (dbVeri[i]["id"] == 13) {
        disNemVarMi = dbVeri[i]["veri4"];
        disNemVarMi = "0";
        
      }

      if (dbVeri[i]["id"] ==  4) {
        fanAdet = dbVeri[i]["veri1"];
        var xx=dbVeri[i]["veri4"].split('#');
        sensorBaglanti=xx[1];
      }

      if (dbVeri[i]["id"] ==  24) {
        bfanSurucu = dbVeri[i]["veri4"]!="0" ? true : false;
      }

      if (dbVeri[i]["id"] ==  5) {
        bacaFanAdet = dbVeri[i]["veri1"];
        airinletAdet = dbVeri[i]["veri2"];
        isiticiAdet = dbVeri[i]["veri3"];
        
      }


      if (dbVeri[i]["id"] == 15) {
        var xx = dbVeri[i]["veri4"].split("*");
        var fanGrid = xx[0].split("#");
        sutunSayisi = int.parse(xx[1]);
        unsurAdet = int.parse(xx[2]);
        for (int i = 0; i < unsurAdet; i++) {
          fanHaritaGrid[i] = int.parse(fanGrid[i]);
        }
      }

      if (dbVeri[i]["id"] == 17) {
        String xx;
        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var klepeNolar = xx.split("#");
          for (int i = 1; i <= 18; i++) {
            klepeNo[i] = klepeNolar[i - 1];
          }
        }
      }

      if (dbVeri[i]["id"] == 19) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var pedNolar = xx.split("#");
          for (int i = 1; i <= 24; i++) {
            pedNo[i] = pedNolar[i - 1];
          }
        }
      }


      if (dbVeri[i]["id"] == 21) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var isisensorNolar = xx.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorNo[i] = isisensorNolar[i - 1];
          }

        }
      }


      if (dbVeri[i]["id"] == 15) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var fanNolar = xx.split("#");
          for (int i = 1; i <= 120; i++) {
            fanNo[i] = fanNolar[i - 1];
          }
        }
      }

    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------



int sayac=0;

  @override
  Widget build(BuildContext context) {

    if(sayac==0){
      _takipEt(dilSecimi, fanAdet, context, sensorBaglanti);
      sayac++;
    }
    

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv598'),
        floatingActionButton: Opacity(
          opacity: 0.4,
          child: Container(
            width: 56 * oran,
            height: 56 * oran,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Izleme(dbVeriler)),
                  );
                },
                backgroundColor: Colors.blue[700],
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
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
              flex: 40,
              child: Row(
                children: <Widget>[
                  //Tünel Fanları-BFan-AirInlet-Isıtıcı-SirkFan-Sıcaklıklar- MOD
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        
                        //Fan Harita Bölümü
                        FanStreamBuilder(sutunSayisi,unsurAdet,fanHaritaGrid,fanNo,dilSecimi,fanAdet,sensorBaglanti).build(context),

                        //Aktfi Mod | Air inlet - Bacafan - Isıtıcı - Sıcaklıklar
                        DigerStreamBuilder1(dilSecimi,airinletAdet, bacaFanAdet , isiticiAdet, sirkFanAdet).build(context)
                        
                        
                        ],
                    ),
                  ),
                  //Diğer unsurlar bölümü
                  DigerStreamBuilder2(dilSecimi, klepeNo, pedNo, isisensorNo,fanAdet,sensorBaglanti,disNemVarMi).build(context),
                ],
              ),
            )
          ],
        ));
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


class FanStreamBuilder extends State<IzlemeTemel> with TickerProviderStateMixin{

  
  int sutunSayisi;
  int unsurAdet;
  List<int> fanHaritaGrid = new List(121);
  List<String> fanNo = new List(121);
  String dilSecimi="TR";
  String fanAdet="0";

  String sensorBaglantiTuru="1";

  List<bool> fanDurum = new List.filled(121,false);

  AnimationController _controller1;
  AnimationController _controller2;

  bool otoFan=false;

  FanStreamBuilder(int sutunSay, int unsurAd,List<int> fanHarGrid, List<String> fNo, String dilSecim, String fanAdedi, String sensorBaglanti) {
    sutunSayisi=sutunSay;
    unsurAdet=unsurAd;
    fanHaritaGrid=fanHarGrid;
    fanNo=fNo;
    dilSecimi=dilSecim;
    fanAdet=fanAdedi;
    sensorBaglantiTuru=sensorBaglanti;
  }
  
  @override
  Widget build(BuildContext context) {

    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 1000),);
    _controller2 = AnimationController(vsync: this,duration: Duration(milliseconds: 1000),);
    //
    _controller1.repeat();
    _controller2.stop();
    //print("object");

    var oran = MediaQuery.of(context).size.width / 731.4;

    return StreamBuilder(
      initialData: initialVeri,
      stream: _someData(dilSecimi,fanAdet,context,sensorBaglantiTuru),
      builder: (context, snapshot) {

        var xx = snapshot.data.split("#");
        var fanDegerler = xx[0].split("*");

        for(int i=1; i<=unsurAdet ; i++){
          if(fanNo[i]!="0"){
            fanDurum[i-1]=fanDegerler[int.parse(fanNo[i])-1]=='1' ? true : false;
          }
        }

        var yy = snapshot.data.split("#");
        otoFan = yy[3].split("*")[0]=="1" ? true : false;

        return Expanded(flex: 7,
                  child: Column(
            children: <Widget>[
              //Çatı resmi
                        Expanded(
                          child: Stack(fit: StackFit.expand,
                            children: <Widget>[
                              
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image:
                                        AssetImage('assets/images/cati_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(),
                                  Expanded(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Spacer(flex: 5,),
                                        Expanded(flex: 4,
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv570"),
                                                style: TextStyle(
                                                    fontSize: 50.0,
                                                    fontFamily:
                                                        'Kelly Slab',
                                                        color: Colors.white
                                                    ),
                                                maxLines: 1,
                                                minFontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 2,
                                          child: autoManGosterge(otoFan, oran, dilSecimi)),

                                        Spacer(flex: 5,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
              //Fanlar       
              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.0 * oran,
                                      right: 5.0 * oran,
                                      bottom: 5.0 * oran),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 3 * oran)),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: seciliHaritaGrid(
                                                  oran
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
            ],
          ),
        );
                        
      },
    );
  }


  Widget seciliHaritaGrid(double oran) {
    return GridView.count(
      //maxCrossAxisExtent: oranHarita/sutunSayisi,
      //childAspectRatio:2,
      crossAxisCount: sutunSayisi,
      children: List.generate(unsurAdet, (index) {
        return Center(child: _fanIzlemeUnsur(oran, index));
      }),
    );
  }

  Widget _fanIzlemeUnsur(double oran, int index) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Container(decoration: BoxDecoration(border: Border.all(width: fanHaritaGrid[index] == 2 ? 1*oran :  0,color: Colors.red[800])),
              child: AnimatedBuilder(animation: fanDurum[index] ? _controller1 : _controller2,
              builder: (context, child) => 
                              RotationTransition(
                  turns:  fanDurum[index] ? _controller1 : _controller2,
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.0).animate(
                        fanDurum[index] ? _controller1 : _controller2,
                        ),
                    child: Image.asset(
                      fanHaritaGrid[index] == 2
                          ? "assets/images/giris_rotate_icon.png"
                          : "assets/images/duvar_icon.png",
                      scale: 1.5 / oran,
                    ),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: fanHaritaGrid[index] == 2 ? true : false,
              child: Padding(
                padding: EdgeInsets.only(left: 2 * oran),
                child: Text(
                  fanNo[index+1],
                  style: TextStyle(),
                  textScaleFactor: oran,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class DigerStreamBuilder1 extends State<IzlemeTemel> with TickerProviderStateMixin{

  AnimationController _controller1;
  AnimationController _controller2;
  String dilSecimi="TR";
  int sistemModu=0;
  int nemDurum=0;
  String fasilaVeyaHizAktuelDeger="";
  bool bfanSurucu=false;
  int calismaSuresi=0;
  int durmaSuresi=0;
  String setSicakligi="";
  String ortSicaklik="";
  String dogBolgeBitis="";
  String capBolgeBitis="";
  String airinletAdet="";
  String bacaFanAdet="";
  String isiticiAdet="";
  String sirkFanAdet="";
  String airInlet1Durum="0";
  String airInlet2Durum="0";
  bool sirkFanDurum=false;
  bool bacafanDurum=false;
  bool isiticiGr1Durum=false;
  bool isiticiGr2Durum=false;
  bool isiticiGr3Durum=false;

  String fanAdet="0";

  bool otoBfa=false;
  bool otoAir1=false;
  bool otoAir2=false;
  bool otoIst=false;
  bool otoSrk=false;

  DigerStreamBuilder1(String dilSecim, String airAdet, String bfanAdet, String istcAdet,String sirFAdet) {
    dilSecimi=dilSecim;
    airinletAdet=airAdet;
    bacaFanAdet=bfanAdet;
    isiticiAdet=istcAdet;
    sirkFanAdet=sirFAdet;
  }

  

  
  @override
  Widget build(BuildContext context) {

    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 1000),);
    _controller2 = AnimationController(vsync: this,duration: Duration(milliseconds: 1000),);
    _controller1.repeat();
    _controller2.stop();
    

    var oran = MediaQuery.of(context).size.width / 731.4;

    return StreamBuilder(
      initialData: initialVeri,
      stream: _someData2(),//_someData(dilSecimi,fanAdet,context),
      builder: (context, snapshot) {
          var xx = snapshot.data.split("#");
          var fanAltiDegerler = xx[1].split("*");

          sistemModu=int.parse(fanAltiDegerler[0]);
          nemDurum=int.parse(fanAltiDegerler[1]);
          fasilaVeyaHizAktuelDeger=fanAltiDegerler[2];
          bfanSurucu=fanAltiDegerler[3]=="1" ? true : false;
          calismaSuresi=int.parse(fanAltiDegerler[4]);
          durmaSuresi=int.parse(fanAltiDegerler[5]);
          setSicakligi=fanAltiDegerler[6];
          ortSicaklik=fanAltiDegerler[7];
          dogBolgeBitis=fanAltiDegerler[8];
          capBolgeBitis=fanAltiDegerler[9];
          airInlet1Durum=fanAltiDegerler[10];
          airInlet2Durum=fanAltiDegerler[11];
          sirkFanDurum=fanAltiDegerler[12]=="1" ? true : false;
          bacafanDurum=fanAltiDegerler[13]=="1" ? true : false;
          isiticiGr1Durum=fanAltiDegerler[14]=="1" ? true : false;
          isiticiGr2Durum=fanAltiDegerler[15]=="1" ? true : false;
          isiticiGr3Durum=fanAltiDegerler[16]=="1" ? true : false;

          var yy = snapshot.data.split("#");
          otoBfa = yy[3].split("*")[15]=="1" ? true : false;
          otoAir1 = yy[3].split("*")[11]=="1" ? true : false;
          otoAir2 = yy[3].split("*")[12]=="1" ? true : false;
          otoIst = yy[3].split("*")[16]=="1" ? true : false;
          otoSrk = yy[3].split("*")[17]=="1" ? true : false;


        return Expanded(flex: 4,
                          child: Column(
                            children: <Widget>[
                              //Aktif Mod Bölümü
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5*oran,right: 5*oran),
                                  child: Container(
                                    color: Colors.blue[900],
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv571")+" "+sistemModu.toString()+": "+sistemModMetni(sistemModu,nemDurum),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab'),
                                          maxLines: 1,
                                          minFontSize: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //Air inlet - Bacafan - Isıtıcı - Sıcaklıklar
                              Expanded(flex: 6,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    //Bacafan - Sirkülasyon Fan
                                    Expanded(child: Container(
                                      child:Column(
                                              children: <Widget>[
                                                //Bacafan
                                                Expanded(flex: 9,
                                                  child: Visibility(visible: bacaFanAdet!="0" ? true : false, 
                                                    child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Spacer(),
                                                              Expanded(flex: 20,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    padding: EdgeInsets.only(left: 1*oran),
                                                                    child: AutoSizeText(
                                                                      Dil().sec(dilSecimi, "tv495"),
                                                                      textAlign:
                                                                          TextAlign.left,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:'Kelly Slab',
                                                                          ),
                                                                      maxLines: 1,
                                                                      minFontSize: 5,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(flex: 6,),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(flex: 5,
                                                          child: Stack(fit: StackFit.expand,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Spacer(flex: 1,),
                                                                  Expanded(flex: 20,
                                                                    child: Stack(fit: StackFit.expand,
                                                                      children: <Widget>[
                                                                        
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            image: DecorationImage(
                                                                              alignment: Alignment.center,
                                                                              image: AssetImage(
                                                                                  "assets/images/harita_bacafan_icon.png"),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),

                                                                        ),
                                                                        Column(
                                                                          children: <Widget>[
                                                                            Spacer(flex: 2,),
                                                                            Expanded(flex:4,
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  fasilaVeyaHizAktuelDeger,
                                                                                  textScaleFactor: oran,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Kelly Slab',
                                                                                    fontSize: 9,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Spacer(flex: 3,),
                                                                            Expanded(flex: 6,
                                                                              child: RotationTransition(
                                                                                turns:bacafanDurum ?  _controller1 : _controller2,
                                                                                child: RotationTransition(
                                                                                  turns: Tween(begin: 0.0, end: 0.0).animate(
                                                                                    bacafanDurum ?  _controller1 : _controller2,
                                                                                  ),
                                                                                  child: Image.asset("assets/images/bfan_rotate_icon.png",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  Spacer(flex:6,)
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Spacer(flex:11),
                                                                  Expanded(flex:27,child: Container()),
                                                                  Expanded(flex:22,
                                                                    child: Visibility(visible: !bfanSurucu,
                                                                      child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: <Widget>[
                                                                          Expanded(
                                                                            flex: 7,
                                                                            child: Column(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Expanded(flex: 3,
                                                                                        child: autoManGosterge(otoBfa, oran, dilSecimi)
                                                                                      ),
                                                                                      Spacer(flex: 2,)
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                Spacer()
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(flex: 3,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  Dil().sec(dilSecimi, "tv579"), //Çal.
                                                                                  textAlign:
                                                                                      TextAlign.left,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(flex: 3,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  calismaSuresi.toString()+" "+Dil().sec(dilSecimi, "tv238"),
                                                                                  textAlign:
                                                                                      TextAlign.left,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      fontWeight: FontWeight.bold
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(flex: 3,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  Dil().sec(dilSecimi, "tv580"),
                                                                                  textAlign:
                                                                                      TextAlign.left,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(flex: 3,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  durmaSuresi.toString()+" "+ Dil().sec(dilSecimi, "tv238"),
                                                                                  textAlign:
                                                                                      TextAlign.left,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      fontWeight: FontWeight.bold
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Sirk Fan
                                                Expanded(flex: 5,
                                                  child: Visibility(visible: sirkFanAdet!="0" ? true : false,
                                                    child: Stack(fit: StackFit.expand,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Spacer(),
                                                          Expanded(flex: 12,
                                                                                                                      child: Column(
                                                              children: <Widget>[
                                                                Spacer(flex: 2,),
                                                                Expanded(flex: 10,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                        alignment: Alignment.center,
                                                                        image: AssetImage(
                                                                            "assets/images/kurulum_sirkfan_kucuk_icon.png"),
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer()
                                                              ],
                                                            ),
                                                          ),
                                                          Spacer(flex: 8,)
                                                        ],
                                                      ),
                                                      
                                                      Column(
                                                        children: <Widget>[
                                                          Expanded(child: Row(
                                                            children: <Widget>[
                                                              Spacer(flex: 22,),
                                                              Expanded(flex:7,
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    Spacer(),
                                                                    Expanded(flex: 2,
                                                                      child: autoManGosterge(otoSrk, oran, dilSecimi)
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                              Spacer(flex: 3,)
                                                            ],
                                                          )),
                                                          Expanded(
                                                            child: Row(
                                                              children: <Widget>[
                                                                Spacer(flex: 4,),
                                                                Expanded(flex:6,
                                                                  child: SizedBox(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    padding: EdgeInsets.only(left: 1*oran),
                                                                    child: AutoSizeText(
                                                                      Dil().sec(dilSecimi, "tv581"),
                                                                      textAlign:
                                                                          TextAlign.left,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:'Kelly Slab',
                                                                          ),
                                                                      maxLines: 1,
                                                                      minFontSize: 5,
                                                                    ),
                                                                  ),
                                                                  ),
                                                                ),
                                                                
                                                                Expanded(flex: 2,
                                                                  child: Container(
                                                                    child:LayoutBuilder(builder:
                                                                      (context,
                                                                          constraint) {
                                                                    return Icon(
                                                                      Icons
                                                                          .check_circle_outline,
                                                                      size: constraint
                                                                          .biggest
                                                                          .width,
                                                                      color: Colors
                                                                          .green[600],
                                                                    );
                                                                  }),
                                                                  ),
                                                                ),
                                                                Spacer(flex:2,)
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      
                                                    ],
                                                    ),
                                                  ),
                                                ),
                                                ],
                                            ),

                                    )),
                                    //Sıcaklıklar
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          //Set Sıcaklığı
                                          Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Spacer(flex: 2,),
                                              Expanded(flex: 2,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    padding: EdgeInsets.only(left: 1*oran),
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv582"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.red[800]
                                                          ),
                                                      maxLines: 2,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(flex: 6,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      setSicakligi,
                                                      textAlign:TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold
                                                          ),
                                                      maxLines: 2,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(flex: 2,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(right: 2*oran),
                                                    child: AutoSizeText(
                                                      "°C",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          color: Colors.red[800]
                                                          ),
                                                      maxLines: 1,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(flex: 2,)
                                          ],
                                          )),
                                          
                                          //Ortalama Sıcaklık Bölümü
                                          Expanded(child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[600],
                                              borderRadius: BorderRadius.circular(5*oran)
                                            ),
                                            
                                            child:Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[

                                                Expanded(flex: 1,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.centerRight,
                                                      padding: EdgeInsets.only(left: 1*oran),
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv583"),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 50.0,
                                                            fontFamily:'Kelly Slab',
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[200]
                                                            ),
                                                        maxLines: 2,
                                                        minFontSize: 5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(flex: 3,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: AutoSizeText(
                                                        ortSicaklik,
                                                        textAlign:TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 50.0,
                                                            fontFamily:'Kelly Slab',
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold
                                                            ),
                                                        maxLines: 2,
                                                        minFontSize: 5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      padding: EdgeInsets.only(right: 2*oran),
                                                      child: AutoSizeText(
                                                        "°C",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 50.0,
                                                            fontFamily:'Kelly Slab',
                                                            color: Colors.grey[200]
                                                            ),
                                                        maxLines: 1,
                                                        minFontSize: 5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )
                                          )),
                                          //Doğal Bölge Çapraz Bölge
                                          Expanded(
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Spacer(flex: 3,),
                                                      Expanded(flex: 10,
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.center,
                                                           padding: EdgeInsets.only(left: 1*oran),
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv584"),
                                                             textAlign:
                                                                 TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily:'Kelly Slab',
                                                                 color: Colors.red[800]
                                                                 ),
                                                             maxLines: 3,
                                                             minFontSize: 5,
                                                           ),
                                                         ),
                                                       ),
                                                   ),
                                                      Expanded(flex: 17,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Spacer(flex: 1,),
                                                            Expanded(flex: 4,
                                                             child: SizedBox(
                                                               child: Container(
                                                                 alignment: Alignment.centerRight,
                                                                 child: AutoSizeText(
                                                                   dogBolgeBitis,
                                                                   textAlign:TextAlign.center,
                                                                   style: TextStyle(
                                                                       fontSize: 50.0,
                                                                       fontFamily:'Kelly Slab',
                                                                       color: Colors.black,
                                                                       fontWeight: FontWeight.bold
                                                                       ),
                                                                   maxLines: 2,
                                                                   minFontSize: 5,
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                            Expanded(flex: 2,
                                                             child: SizedBox(
                                                               child: Container(
                                                                 alignment: Alignment.centerLeft,
                                                                 padding: EdgeInsets.only(right: 2*oran),
                                                                 child: AutoSizeText(
                                                                   "°C",
                                                                   textAlign:
                                                                       TextAlign.center,
                                                                   style: TextStyle(
                                                                       fontSize: 50.0,
                                                                       fontFamily:'Kelly Slab',
                                                                       color: Colors.red[800]
                                                                       ),
                                                                   maxLines: 1,
                                                                   minFontSize: 5,
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                            Spacer(flex: 1,)
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Spacer(flex: 3,),
                                                      Expanded(flex: 10,
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.center,
                                                           padding: EdgeInsets.only(left: 1*oran),
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv585"),
                                                             textAlign:
                                                                 TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily:'Kelly Slab',
                                                                 color: Colors.red[800]
                                                                 ),
                                                             maxLines: 3,
                                                             minFontSize: 5,
                                                           ),
                                                         ),
                                                       ),
                                                   ),
                                                      Expanded(flex: 17,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Spacer(flex: 1,),
                                                            Expanded(flex: 4,
                                                             child: SizedBox(
                                                               child: Container(
                                                                 alignment: Alignment.centerRight,
                                                                 child: AutoSizeText(
                                                                   capBolgeBitis,
                                                                   textAlign:TextAlign.center,
                                                                   style: TextStyle(
                                                                       fontSize: 50.0,
                                                                       fontFamily:'Kelly Slab',
                                                                       color: Colors.black,
                                                                       fontWeight: FontWeight.bold
                                                                       ),
                                                                   maxLines: 2,
                                                                   minFontSize: 5,
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                            Expanded(flex: 2,
                                                             child: SizedBox(
                                                               child: Container(
                                                                 alignment: Alignment.centerLeft,
                                                                 padding: EdgeInsets.only(right: 2*oran),
                                                                 child: AutoSizeText(
                                                                   "°C",
                                                                   textAlign:
                                                                       TextAlign.center,
                                                                   style: TextStyle(
                                                                       fontSize: 50.0,
                                                                       fontFamily:'Kelly Slab',
                                                                       color: Colors.red[800]
                                                                       ),
                                                                   maxLines: 1,
                                                                   minFontSize: 5,
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                            Spacer(flex: 1,)
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                
                                            ],
                                          )),
                                          
                                        ],
                                      )
                                    ),
                                    //Air inlet ve Isıtıcı
                                    Expanded(child: Container(
                                      child:Column(
                                              children: <Widget>[
                                                //Air Inlet
                                                Expanded(flex: 16,
                                                  child: Visibility(visible: airinletAdet!="0" ? true : false,
                                                    child: Column(
                                                      children: <Widget>[
                                                        //Başlık
                                                        Expanded(flex: 1,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Spacer(flex: 6,),
                                                              Expanded(flex: 20,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    padding: EdgeInsets.only(left: 1*oran),
                                                                    child: AutoSizeText(
                                                                      Dil().sec(dilSecimi, "tv586"),
                                                                      textAlign:
                                                                          TextAlign.left,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:'Kelly Slab',
                                                                          ),
                                                                      maxLines: 1,
                                                                      minFontSize: 5,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(flex: 1,),
                                                            ],
                                                          ),
                                                        ),
                                                        //Gövde
                                                        Expanded(flex: 5,
                                                          child: Stack(fit: StackFit.expand,
                                                            children: <Widget>[
                                                              Column(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(flex:2,
                                                                          child: Visibility(visible: airinletAdet=="2" ? true : false,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  "1:",
                                                                                  textAlign:
                                                                                      TextAlign.left,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(flex: 6,
                                                                          child: autoManGosterge(otoAir1, oran, dilSecimi),
                                                                        ),
                                                                        Expanded(flex:3,
                                                                          child: Visibility(visible: airinletAdet=="2" ? true : false,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  "2:",
                                                                                  textAlign:
                                                                                      TextAlign.left,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(flex: 6,
                                                                          child: Visibility(visible: airinletAdet=="2" ? true : false,
                                                                            child: autoManGosterge(otoAir2, oran, dilSecimi)),
                                                                        ),
                                                                        Spacer(flex: 13,)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(flex: 4,)
                                                                ],
                                                              ),
                                                              //Air inlet Resim
                                                              Row(
                                                                children: <Widget>[
                                                                  Spacer(flex: 8,),
                                                                  Expanded(flex: 18,
                                                                    child: Stack(fit: StackFit.expand,
                                                                      children: <Widget>[
                                                                        
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            image: DecorationImage(
                                                                              alignment: Alignment.center,
                                                                              image: AssetImage(
                                                                                  "assets/images/kurulum_airinlet_icon.png"),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),

                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  Spacer(flex:1,)
                                                                ],
                                                              ),
                                                              //Air inlet Durumları
                                                              Row(
                                                                children: <Widget>[
                                                                  Expanded(flex:2,
                                                                    child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: <Widget>[
                                                                        Spacer(flex: 3,),
                                                                        Expanded(flex: 3,
                                                                          child: SizedBox(
                                                                            child: Container(
                                                                              alignment: Alignment.centerRight,
                                                                              padding: EdgeInsets.only(left: 1*oran),
                                                                              child: AutoSizeText(
                                                                                airinletAdet=="0" ? "" : (airinletAdet=="1" ? 
                                                                                Dil().sec(dilSecimi, "tv589") : Dil().sec(dilSecimi, "tv587")),
                                                                                textAlign:
                                                                                    TextAlign.left,
                                                                                style: TextStyle(
                                                                                    fontSize: 50.0,
                                                                                    fontFamily:'Kelly Slab',
                                                                                    ),
                                                                                maxLines: 1,
                                                                                minFontSize: 5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(flex: 3,
                                                                          child: SizedBox(
                                                                            child: Container(
                                                                              alignment: Alignment.centerRight,
                                                                              padding: EdgeInsets.only(left: 1*oran),
                                                                              child: AutoSizeText(
                                                                                airInletDurum(airInlet1Durum),
                                                                                textAlign:
                                                                                    TextAlign.left,
                                                                                style: TextStyle(
                                                                                    fontSize: 50.0,
                                                                                    fontFamily:'Kelly Slab',
                                                                                    fontWeight: FontWeight.bold
                                                                                    ),
                                                                                maxLines: 1,
                                                                                minFontSize: 5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(flex: 3,
                                                                          child: SizedBox(
                                                                            child: Container(
                                                                              alignment: Alignment.centerRight,
                                                                              padding: EdgeInsets.only(left: 1*oran),
                                                                              child: AutoSizeText(
                                                                                airinletAdet=="2" ? Dil().sec(dilSecimi, "tv588") : "",
                                                                                textAlign:
                                                                                    TextAlign.left,
                                                                                style: TextStyle(
                                                                                    fontSize: 50.0,
                                                                                    fontFamily:'Kelly Slab',
                                                                                    ),
                                                                                maxLines: 1,
                                                                                minFontSize: 5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(flex: 3,
                                                                          child: SizedBox(
                                                                            child: Container(
                                                                              alignment: Alignment.centerRight,
                                                                              padding: EdgeInsets.only(left: 1*oran),
                                                                              child: AutoSizeText(
                                                                                airInletDurum(airInlet2Durum),
                                                                                textAlign:
                                                                                    TextAlign.left,
                                                                                style: TextStyle(
                                                                                    fontSize: 50.0,
                                                                                    fontFamily:'Kelly Slab',
                                                                                    fontWeight: FontWeight.bold
                                                                                    ),
                                                                                maxLines: 1,
                                                                                minFontSize: 5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                 
                                                                  Spacer(flex:5),
                                                                  ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                //Isıtıcı
                                                Expanded(flex: 10,
                                                  child: Visibility(visible: isiticiAdet!="0" ? true : false,
                                                    child: Stack(fit: StackFit.expand,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Spacer(),
                                                            Expanded(flex: 8,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Spacer(flex: 2,),
                                                                        Expanded(flex: 3,
                                                                                                                                              child: SizedBox(
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            padding: EdgeInsets.only(left: 1*oran),
                                                                            child: AutoSizeText(
                                                                              Dil().sec(dilSecimi, "tv592"),
                                                                              textAlign:
                                                                                  TextAlign.left,
                                                                              style: TextStyle(
                                                                                  fontSize: 50.0,
                                                                                  fontFamily:'Kelly Slab',
                                                                                  ),
                                                                              maxLines: 1,
                                                                              minFontSize: 5,
                                                                            ),
                                                                          ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(flex: 2,
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                          alignment: Alignment.center,
                                                                          image: AssetImage(
                                                                              "assets/images/kurulum_isitici_kucuk_icon.png"),
                                                                          fit: BoxFit.fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            
                                                            Expanded(flex: 6,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(flex: 3,
                                                                          child: SizedBox(
                                                                            child: Container(
                                                                              alignment: Alignment.centerRight,
                                                                              padding: EdgeInsets.only(left: 1*oran),
                                                                              child: AutoSizeText(
                                                                                Dil().sec(dilSecimi, "tv593"),
                                                                                textAlign:
                                                                                    TextAlign.right,
                                                                                style: TextStyle(
                                                                                    fontSize: 50.0,
                                                                                    fontFamily:'Kelly Slab',
                                                                                    ),
                                                                                maxLines: 1,
                                                                                minFontSize: 5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(flex:2,child: Container(
                                                                          child:LayoutBuilder(builder:
                                                                            (context,
                                                                                constraint) {
                                                                          return Icon(
                                                                            isiticiGr1Durum ? Icons.check_circle_outline : Icons.remove_circle_outline,
                                                                            size: constraint
                                                                                .biggest
                                                                                .height,
                                                                            color: isiticiGr1Durum ? Colors.green[600] : Colors.red,
                                                                          );
                                                                        }),
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Visibility(visible: int.parse(isiticiAdet)>=2 ? true : false,
                                                                      child: Row(
                                                                        children: <Widget>[
                                                                          Expanded(flex: 3,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  Dil().sec(dilSecimi, "tv594"),
                                                                                  textAlign:
                                                                                      TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(flex:2,
                                                                          child: Container(
                                                                            child:LayoutBuilder(builder:
                                                                              (context,
                                                                                  constraint) {
                                                                            return Icon(
                                                                              isiticiGr2Durum ? Icons.check_circle_outline : Icons.remove_circle_outline,
                                                                              size: constraint
                                                                                  .biggest
                                                                                  .height,
                                                                              color: isiticiGr2Durum ? Colors.green[600] : Colors.red,
                                                                            );
                                                                          }),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Visibility(visible: int.parse(isiticiAdet)==3 ? true : false,
                                                                      child: Row(
                                                                        children: <Widget>[
                                                                          Expanded(flex: 3,
                                                                            child: SizedBox(
                                                                              child: Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: EdgeInsets.only(left: 1*oran),
                                                                                child: AutoSizeText(
                                                                                  Dil().sec(dilSecimi, "tv595"),
                                                                                  textAlign:
                                                                                      TextAlign.right,
                                                                                  style: TextStyle(
                                                                                      fontSize: 50.0,
                                                                                      fontFamily:'Kelly Slab',
                                                                                      ),
                                                                                  maxLines: 1,
                                                                                  minFontSize: 5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(flex: 2,
                                                                            child: Container(
                                                                              child:LayoutBuilder(builder:
                                                                                (context,
                                                                                    constraint) {
                                                                              return Icon(
                                                                                isiticiGr3Durum ? Icons.check_circle_outline : Icons.remove_circle_outline,
                                                                                size: constraint
                                                                                    .biggest
                                                                                    .height,
                                                                                color: isiticiGr3Durum ? Colors.green[600] : Colors.red,
                                                                              );
                                                                            }),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: <Widget>[
                                                            Spacer(flex: 6,),
                                                            Expanded(flex: 11,
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Spacer(flex: 1,),
                                                                  Expanded(flex: 4,
                                                                    child: autoManGosterge(otoIst, oran, dilSecimi),
                                                                  ),
                                                                  Spacer(flex: 12,)
                                                                    
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer(flex: 19,)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),

                                    )),
                                    

                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        


      },
    );
  }

  String sistemModMetni(int modNo, int nemDurum){
    String xx="";
    String yy=nemDurum==1 ? " - "+Dil().sec(dilSecimi, "tv577") : 
    (nemDurum==2 ? " - "+Dil().sec(dilSecimi, "tv578") : "");

    
    if(modNo==0){
      xx=Dil().sec(dilSecimi, "tv572");
    }else if(modNo==1){
      xx=Dil().sec(dilSecimi, "tv573");
    }else if(modNo==2){
      xx=Dil().sec(dilSecimi, "tv574");
    }else if(modNo==3){
      xx=Dil().sec(dilSecimi, "tv575")+yy;
    }else if(modNo==4){
      xx=Dil().sec(dilSecimi, "tv576")+yy;
    }

    return xx;

  }

  String airInletDurum(String durum){
    
    String xx="";
    if(durum=="0"){
      xx=Dil().sec(dilSecimi, "tv591");
    }else if(durum=="1"){
      xx=Dil().sec(dilSecimi, "tv590");
    }else if(durum=="2"){
      xx=Dil().sec(dilSecimi, "tv596");
    }else if(durum=="3"){
      xx=Dil().sec(dilSecimi, "tv597");
    }else{
      xx=Dil().sec(dilSecimi, "tv591");
    }

    return xx;

  }


}

class DigerStreamBuilder2 extends State<IzlemeTemel> with TickerProviderStateMixin{

  String dilSecimi="TR";
  List<String> klepeNo = new List.filled(19,"0");
  List<bool> otoKlp = new List.filled(11,false);
  List<String> pedNo = new List.filled(25,"0");
  List<String> isisensorNo = new List.filled(23,"0");

  List<String> klepeAciklik = new List.filled(11,"0.0");
  List<bool> pedDurum = new List.filled(11,false);
  List<String> isisensorDeger = new List.filled(16,"0.0");

  String fanAdet="0";
  String sensorBaglanti="0";

  bool otoPed=false;

  String icNem="0.0";
  String disNem="0.0";
  String disNemVarMi="0";

  String pedFasilaAktuel="0";

  DigerStreamBuilder2(String dilSecim,List<String> klpNo,List<String> pNo,List<String> isiSensNo, String fAdet, String sensBaglanti, String disNemVarDurum) {
    dilSecimi=dilSecim;
    klepeNo=klpNo;
    pedNo=pNo;
    isisensorNo=isiSensNo;
    fanAdet=fAdet;
    sensorBaglanti=sensBaglanti;
    disNemVarMi=disNemVarDurum;
  }

  

  
  @override
  Widget build(BuildContext context) {

    _takipEt(dilSecimi, fanAdet, context, sensorBaglanti);
    int sayac=0;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return StreamBuilder(
      initialData: initialVeri,
      stream: _someData2(),//_someData(dilSecimi,fanAdet,context),
      builder: (context, snapshot) {
          var xx = snapshot.data.split("#");
          var fanSagiDegerler = xx[2].split("*");

          for (var i = 1; i < 11; i++) {
            klepeAciklik[i]=fanSagiDegerler[i-1];
          }

          for (var i = 1; i < 16; i++) {
            isisensorDeger[i]=fanSagiDegerler[i-1+10];
          }

          for (var i = 1; i < 11; i++) {
            pedDurum[i]=fanSagiDegerler[i-1+25]=="1" ? true : false;
          }

          pedFasilaAktuel = fanSagiDegerler[35];

          var yy = snapshot.data.split("#");
          for (var i = 1; i < 11; i++) {
            otoKlp[i] = yy[3].split("*")[i]=="1" ? true : false;
          }

          otoPed = yy[3].split("*")[13]=="1" ? true : false;
          

          


          
          var nemDegerler = xx[4].split("*");
          icNem=nemDegerler[0];
          disNem=nemDegerler[1];


        return Expanded(
                    flex: 7,
                    child: Column(
                      children: <Widget>[
                        //Klepe
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: 5*oran),
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                //Klepe Sol Duvar
                                Expanded(
                                  flex: 32,
                                  child: Column(
                                    children: <Widget>[
                                      //Başlık
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 1*oran),
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv56"),
                                              textAlign:
                                                  TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 50.0,
                                                  fontFamily:'Kelly Slab',
                                                  ),
                                              maxLines: 1,
                                              minFontSize: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Duvar
                                      Expanded(flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[13]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[10]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[14]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[11]),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[15]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[12]),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Klepe Ön Duvar
                                Expanded(
                                  flex: 16,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 1*oran),
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv53"),
                                              textAlign:
                                                  TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 50.0,
                                                  fontFamily:'Kelly Slab',
                                                  ),
                                              maxLines: 1,
                                              minFontSize: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[1]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[2]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[3]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Klepe Sağ Duvar
                                Expanded(
                                  flex: 32,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 1*oran),
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv54"),
                                              textAlign:
                                                  TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 50.0,
                                                  fontFamily:'Kelly Slab',
                                                  ),
                                              maxLines: 1,
                                              minFontSize: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[4]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[7]),
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[5]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[8]),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[6]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[9]),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        //Isı sensor
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5*oran),
                            child: Stack(fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10*oran)
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv57"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 40,
                                                  ),
                                                  maxLines: 1,
                                                  minFontSize: 5,
                                                ),
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Spacer(),
                                                      Expanded(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Spacer(flex: 7,),
                                                            Expanded(flex: 4,
                                                                                                        child: RotatedBox(
                                                                quarterTurns: -45,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                      Dil()
                                                                          .sec(dilSecimi, "tv58"),
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 40,
                                                                      ),
                                                                      maxLines: 1,
                                                                      minFontSize: 5,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      _isisensorHaritaUnsur(oran,isisensorNo[22]),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 25,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              alignment: Alignment.center,
                                                              image: AssetImage(
                                                                  "assets/images/bina_catisiz_ust_gorunum.png"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: <Widget>[
                                                            Spacer(),
                                                            Expanded(
                                                              flex: 10,
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Spacer(),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[1]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[2]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[3]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[4]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[5]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[6]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[7]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[8]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[9]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[10]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[11]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[12]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[13]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[14]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[15]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[16]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[17]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[18]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[19]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[20]),
                                                                        _isisensorHaritaUnsur(oran,isisensorNo[21]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer()
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer()
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: RotatedBox(
                                                    quarterTurns: -45,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: AutoSizeText(
                                                          Dil()
                                                              .sec(dilSecimi, "tv59"),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 40,
                                                          ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              
                                Row(
                                  children: <Widget>[
                                    Expanded(flex: 3,
                                      child: Column(
                                        children: <Widget>[
                                          //İç nem Dış Nem
                                          Expanded(flex: 3,
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  //İç Nem
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        //Spacer(flex: 2,),
                                                        Expanded(flex: 7,
                                                         child: SizedBox(
                                                           child: Container(
                                                             alignment: Alignment.center,
                                                             padding: EdgeInsets.only(left: 1*oran),
                                                             child: AutoSizeText(
                                                               Dil().sec(dilSecimi, "tv618"),
                                                               textAlign:
                                                                   TextAlign.center,
                                                               style: TextStyle(
                                                                   fontSize: 50.0,
                                                                   fontFamily:'Kelly Slab',
                                                                   color: Colors.red[800]
                                                                   ),
                                                               maxLines: 1,
                                                               minFontSize: 5,
                                                             ),
                                                           ),
                                                         ),
                                                     ),
                                                        Expanded(flex: 11,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Spacer(flex: 1,),
                                                              Expanded(flex: 4,
                                                               child: SizedBox(
                                                                 child: Container(
                                                                   alignment: Alignment.centerRight,
                                                                   child: AutoSizeText(
                                                                     icNem,
                                                                     textAlign:TextAlign.center,
                                                                     style: TextStyle(
                                                                         fontSize: 50.0,
                                                                         fontFamily:'Kelly Slab',
                                                                         color: Colors.black,
                                                                         fontWeight: FontWeight.bold
                                                                         ),
                                                                     maxLines: 1,
                                                                     minFontSize: 5,
                                                                   ),
                                                                 ),
                                                               ),
                                                             ),
                                                              Expanded(flex: 2,
                                                               child: SizedBox(
                                                                 child: Container(
                                                                   alignment: Alignment.centerLeft,
                                                                   padding: EdgeInsets.only(right: 2*oran),
                                                                   child: AutoSizeText(
                                                                     "%",
                                                                     textAlign:
                                                                         TextAlign.center,
                                                                     style: TextStyle(
                                                                         fontSize: 50.0,
                                                                         fontFamily:'Kelly Slab',
                                                                         color: Colors.red[800]
                                                                         ),
                                                                     maxLines: 1,
                                                                     minFontSize: 5,
                                                                   ),
                                                                 ),
                                                               ),
                                                             ),
                                                              Spacer(flex: 1,)
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(flex: 1,)
                                                      ],
                                                    ),
                                                  ),
                                                  //Dış Nem
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        //Spacer(flex: 2,),
                                                        Expanded(flex: 7,
                                                         child: SizedBox(
                                                           child: Container(
                                                             alignment: Alignment.center,
                                                             padding: EdgeInsets.only(left: 1*oran),
                                                             child: AutoSizeText(
                                                               Dil().sec(dilSecimi, "tv619"),
                                                               textAlign:
                                                                   TextAlign.center,
                                                               style: TextStyle(
                                                                   fontSize: 50.0,
                                                                   fontFamily:'Kelly Slab',
                                                                   color: Colors.red[800]
                                                                   ),
                                                               maxLines: 1,
                                                               minFontSize: 5,
                                                             ),
                                                           ),
                                                         ),
                                                     ),
                                                        Expanded(flex: 11,
                                                          child: Stack(fit: StackFit.expand,
                                                            children: <Widget>[
                                                              Visibility(visible: disNemVarMi=="0" ? false: true,
                                                                                                                          child: Row(
                                                                  children: <Widget>[
                                                                    Spacer(flex: 1,),
                                                                    Expanded(flex: 4,
                                                                     child: SizedBox(
                                                                       child: Container(
                                                                         alignment: Alignment.centerRight,
                                                                         child: AutoSizeText(
                                                                           disNem,
                                                                           textAlign:TextAlign.center,
                                                                           style: TextStyle(
                                                                               fontSize: 50.0,
                                                                               fontFamily:'Kelly Slab',
                                                                               color: Colors.black,
                                                                               fontWeight: FontWeight.bold
                                                                               ),
                                                                           maxLines: 1,
                                                                           minFontSize: 5,
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                    Expanded(flex: 2,
                                                                     child: SizedBox(
                                                                       child: Container(
                                                                         alignment: Alignment.centerLeft,
                                                                         padding: EdgeInsets.only(right: 2*oran),
                                                                         child: AutoSizeText(
                                                                           "%",
                                                                           textAlign:
                                                                               TextAlign.center,
                                                                           style: TextStyle(
                                                                               fontSize: 50.0,
                                                                               fontFamily:'Kelly Slab',
                                                                               color: Colors.red[800]
                                                                               ),
                                                                           maxLines: 1,
                                                                           minFontSize: 5,
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                    Spacer(flex: 1,)
                                                                  ],
                                                                ),
                                                              ),
                                                              Visibility(visible: disNemVarMi=="0"? true : false,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                      Dil().sec(dilSecimi, "tv237"),
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:'Kelly Slab',
                                                                          fontWeight:FontWeight.bold,
                                                                          color: Colors.grey[500],
                                                                          ),
                                                                      maxLines: 4,
                                                                      minFontSize: 8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(flex: 1,),
                                                      ],
                                                    ),
                                                  ),
                                                  
                                              ],
                                          ),
                                            )
                                          ),
                                          Spacer(flex: 4,)
                                        ],
                                      ),
                                    ),
                                    Spacer(flex: 26,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),                     
                        //Ped
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5*oran),
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                //Ped Sol Duvar
                                Expanded(
                                  flex: 33,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(flex: 1,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(flex: 4,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv45"),
                                                              textAlign:
                                                                  TextAlign.left,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                     Expanded(flex: 5,
                                                       child: autoManGosterge(otoPed, oran, dilSecimi)
                                                      ),
                                                      Spacer(flex:2)
                                                    ],
                                                  ),
                                                ),
                                            Expanded(
                                              child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv56"),
                                                              textAlign:
                                                                  TextAlign.left,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[19]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[16]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[13]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[20]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[17]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[14]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[21]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[18]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[15]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Ped Ön Duvar
                                Expanded(
                                  flex: 14,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(left: 1*oran),
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv53"),
                                              textAlign:
                                                  TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 50.0,
                                                  fontFamily:'Kelly Slab',
                                                  ),
                                              maxLines: 1,
                                              minFontSize: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              _pedIzlemeUnsur(oran, pedNo[1]),
                                              Spacer(),
                                              _pedIzlemeUnsur(oran, pedNo[2]),
                                              Spacer(),
                                              _pedIzlemeUnsur(oran, pedNo[3]),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Ped Sağ Duvar
                                Expanded(
                                  flex: 33,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Spacer(),
                                            Expanded(
                                              child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv54"),
                                                              textAlign:
                                                                  TextAlign.left,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                            Expanded(flex: 1,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Spacer(flex:2),
                                                      Expanded(flex: 4,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              pedFasilaAktuel,
                                                              textAlign:
                                                                  TextAlign.left,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                     
                                                    ],
                                                  ),
                                                ),
                                            
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[4]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[7]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[10]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[5]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[8]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[11]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[6]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[9]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[12]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                          
      

      },
    );
  }

  

  
  
  Widget _klepeIzlemeUnsurOnSol(double oran, String klpNo){

    String aciklik=klepeAciklik[int.parse(klpNo)];
    bool otoDurum=otoKlp[int.parse(klpNo)];

    double klpSkewKatsayi=(double.parse(aciklik)/100)*0.8;
    int ustSeviye=((double.parse(aciklik)/100)*8).round();

    
    return Expanded(
            flex: klpNo=="0" ? 2 : 8,
            child: Visibility(visible: klpNo=="0" ? false : true,
                          child: RotatedBox(
                quarterTurns: -2,
                child: Stack(
                  alignment:
                      Alignment.topCenter,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1 *
                                  oran,
                              color: Colors
                                  .black),
                          color: Colors
                              .white),
                    ),
                    Transform(
                      transform:
                          Matrix4.skewX(
                              klpSkewKatsayi),
                      child: Padding(
                        padding: EdgeInsets
                            .only(
                                bottom: ustSeviye *
                                    oran),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1 *
                                      oran),
                              color: otoDurum ? Colors.green : Colors.yellow,
                                      ),
                          alignment:
                              Alignment
                                  .center,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child:
                              RotatedBox(
                            quarterTurns:
                                -2,
                            child:
                                SizedBox(
                              child:
                                  Container(
                                padding: EdgeInsets.only(
                                    left: 2 *
                                        oran),
                                alignment:
                                    Alignment
                                        .bottomLeft,
                                child:
                                    AutoSizeText(
                                  "K$klpNo: $aciklik%",
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        'Kelly Slab',
                                    color: otoDurum ? Colors.white : Colors.black,
                                    fontSize:
                                        60,
                                  ),
                                  maxLines:
                                      1,
                                  minFontSize:
                                      8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );


  }

  Widget _klepeIzlemeUnsurSag(double oran, String klpNo){

    String aciklik=klepeAciklik[int.parse(klpNo)];
    bool otoDurum=otoKlp[int.parse(klpNo)];

    double klpSkewKatsayi=(double.parse(aciklik)/100)*0.8;
    int ustSeviye=((double.parse(aciklik)/100)*8).round();

    
    return Expanded(
            flex: klpNo=="0" ? 2 : 8,
            child: Visibility(visible: klpNo=="0" ? false : true,
                          child: RotatedBox(
                quarterTurns: -2,
                child: Stack(
                  alignment:
                      Alignment.topCenter,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1 *
                                  oran,
                              color: Colors
                                  .black),
                          color: Colors
                              .white),
                    ),
                    Transform(
                      transform:
                          Matrix4.skewX(
                              -klpSkewKatsayi),
                      child: Padding(
                        padding: EdgeInsets
                            .only(
                                bottom: ustSeviye *
                                    oran),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1 *
                                      oran),
                              color: otoDurum ? Colors.green : Colors.yellow,
                            ),
                          alignment:
                              Alignment
                                  .center,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child:
                              RotatedBox(
                            quarterTurns:
                                -2,
                            child:
                                SizedBox(
                              child:
                                  Container(
                                padding: EdgeInsets.only(
                                    right: 2 *
                                        oran),
                                alignment:
                                    Alignment
                                        .bottomRight,
                                child:
                                    AutoSizeText(
                                  "K$klpNo: $aciklik%",
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        'Kelly Slab',
                                    color: otoDurum ? Colors.white : Colors.black,
                                    fontSize:
                                        60,
                                  ),
                                  maxLines:
                                      1,
                                  minFontSize:
                                      8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );


  }


  Widget _pedIzlemeUnsur(double oran, String pedNo){

    bool durum=pedDurum[int.parse(pedNo)];

    return Expanded(
            flex: 4,
            child: Visibility(visible: pedNo=="0" ? false : true,
                          child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration:
                          BoxDecoration(
                        image:
                            DecorationImage(
                          alignment: Alignment
                              .centerRight,
                          image: AssetImage(
                              durum ? 'assets/images/ped_izleme_icon_on.png' : 'assets/images/ped_izleme_icon_off.png'),
                          fit: BoxFit
                              .contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      pedNo,
                      textScaleFactor:
                          oran,
                    ),
                  )
                ],
              ),
            ),
          );
                                            
  }


  Widget _isisensorHaritaUnsur(double oran, String isiSensNo) {

    String sensDeger=isisensorDeger[int.parse(isiSensNo)];


    return Expanded(
      child: Visibility(

        visible: isiSensNo=="0" ? false : true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(flex: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 5,
                  child:SizedBox(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        "S" +isiSensNo,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: 'Kelly Slab'),
                        maxLines: 1,
                        minFontSize: 5,
                      ),
                    ),
                  ),
                           
                ),
                    Expanded(flex: 6,
                  child:SizedBox(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        "$sensDeger",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: 'Kelly Slab'),
                        maxLines: 1,
                        minFontSize: 5,
                      ),
                    ),
                  ),
                           
                ),
                    Spacer(flex: 4,)
            
                    
                  ],
                ),
              ),
              Expanded(flex: 3,
                                          child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      'assets/images/harita_isi_sensor_kucuk_icon.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                    ),
                    
            Spacer()
            ],
        ),
      ),
    );
  }


}




bool baglanti=false;
int sec=0;
int mSec=100;
Stream<String> _someData(String dilSecimi, String fanAdet, BuildContext context, String sensorBaglanti) async* {
  
  yield*Stream.periodic(Duration(seconds: 2), (int a) {
    if(!baglanti){
      baglanti=true;
      _takipEt(dilSecimi, fanAdet, context, sensorBaglanti);
    }
    
    return initialVeri;
  }
  );
}

Stream<String> _someData2() async* {
  
  yield* Stream.periodic(Duration(seconds:2), (int a) {
    
    
    return initialVeri;
  });
  
}


_takipEt(String dilSecimi, String fanAdet, BuildContext context, String sensorBaglanti) async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2237).then((socket) {
        socket.add(utf8.encode('1*$fanAdet*$sensorBaglanti'));

        socket.listen(
          (List<int> event) {

            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {

              initialVeri=gelenMesaj;
              print(initialVeri);
              print(fanAdet);

            }

          },
          onDone: () {
            baglanti = false;
            socket.close();
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,duration: 3);
      baglanti = false;
    }
  }


  Widget autoManGosterge(bool deger, double oran, String dilSecimi){
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4*oran),
          color:deger ? Colors.green : Colors.yellow,
        ),
        alignment: Alignment.center,
        child: AutoSizeText(
          deger ? Dil().sec(dilSecimi, "tv455") : Dil().sec(dilSecimi, "tv456"),
          style: TextStyle(
              fontSize: 50.0,
              fontFamily:
                  'Kelly Slab',
                  color: deger ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold
              ),
          maxLines: 1,
          minFontSize: 8,
        ),
      ),
    );
  }


