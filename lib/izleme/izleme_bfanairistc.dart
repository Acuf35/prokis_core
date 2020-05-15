
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prokis/genel_ayarlar/izleme.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';

class IzlemeBfanAirIstc extends StatefulWidget {
  List<Map> gelenDBveri;
  IzlemeBfanAirIstc(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  _IzlemeBfanAirIstcState createState() => _IzlemeBfanAirIstcState(gelenDBveri);
}

class _IzlemeBfanAirIstcState extends State<IzlemeBfanAirIstc> with TickerProviderStateMixin{


  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
  var oran;

  List<int> bacafanHarita = new List.filled(27,0);
  List<bool> bacafanVisibility = new List.filled(27,true);
  List<int> bacafanNo = new List.filled(27,0);
  bool bacafanDurum=true;
  bool haritaOnayBacafan=false;

  List<int> isiticiHarita = new List.filled(19,0);
  List<bool> isiticiVisibility = new List.filled(19,true);
  List<int> isiticiNo = new List.filled(19,0);
  bool haritaOnayIsitici = false;
  int isiticiAdet = 0;

  int sistemModu=3;
  int nemDurum=0;

  AnimationController _controller1;
  AnimationController _controller2;


  bool otoBfa=false;
  bool otoAir=false;
  bool otoIst=false;
  bool otoSrk=false;


  String fasilaVeyaHizAktuelDeger="15";
  bool bfanSurucu=false;
  int calismaSuresi=240;
  int durmaSuresi=360;
  String setSicakligi="21.0";
  String ortSicaklik="25.6";
  String dogBolgeBitis="22.0";
  String capBolgeBitis="24.0";
  String airinletAdet="1";
  String bacaFanAdet="1";
  String sirkFanAdet="1";
  String airInlet1Durum="0";
  String airInlet2Durum="0";
  bool sirkFanDurum=false;
  bool isiticiGr1Durum=false;
  bool isiticiGr2Durum=false;
  bool isiticiGr3Durum=false;






  

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  _IzlemeBfanAirIstcState(List<Map> dbVeri) {
    dbVeriler=dbVeri;

    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }


      if (dbVeri[i]["id"] == 23) {
        var haritaKAYIT = dbVeri[i]["veri1"];
        var fHaritalar = dbVeri[i]["veri2"].split("#");

        for (var i = 1; i <= 26; i++) {

          if (haritaKAYIT == "ok") {
            bacafanHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              bacafanVisibility[i] = true;
              haritaOnayBacafan = true;
            }else{
              bacafanVisibility[i] = false;
            }
          }
        }
        
      }


      if (dbVeri[i]["id"] == 24) {
        var cikisKAYIT = dbVeri[i]["veri1"];
        var bacafanNolar = dbVeri[i]["veri2"].split("#");
        bfanSurucu = dbVeri[i]["veri4"].split("*")[1]=="1" ? true : false;

        for (var i = 1; i <= 26; i++) {

          if(cikisKAYIT=="ok"){
            bacafanNo[i] = int.parse(bacafanNolar[i - 1]);
          }
        }
      }





      if (dbVeri[i]["id"] == 27) {
        var haritaKAYIT = dbVeri[i]["veri1"];
        var fHaritalar = dbVeri[i]["veri2"].split("#");

        for (var i = 1; i <= 18; i++) {

          if (haritaKAYIT == "ok") {
            isiticiHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              isiticiVisibility[i] = true;
              haritaOnayIsitici= true;
            }else{
              isiticiVisibility[i] = false;
            }
          }
        }
        
      }


      if (dbVeri[i]["id"] == 28) {
        var cikisKAYIT = dbVeri[i]["veri1"];
        var isiticiNolar = dbVeri[i]["veri2"].split("#");

        for (var i = 1; i <= 18; i++) {

          if(cikisKAYIT=="ok"){
            isiticiNo[i] = int.parse(isiticiNolar[i - 1]);
          }
        }
      }






    }

  }
//--------------------------CONSTRUCTER METHOD--------------------------------



  @override
  Widget build(BuildContext context) {

    final _blocSinif  = IzlemeBfanAirIstcBloC(context, dilSecimi, isiticiNo);

    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 1500),);
    _controller2 = AnimationController(vsync: this,duration: Duration(milliseconds: 1500),);
    //
    _controller1.repeat();
    _controller2.stop();

    oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv599'),
        floatingActionButton: Opacity(
          opacity: 1,
          child: Container(
            width: 56 * oran,
            height: 56 * oran,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _blocSinif.bloCVeriEventStreamControllerISITICIDURUM[0].sink.add("99");
                  _controller1.dispose();
                  _controller2.dispose();
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
            //SAAT TARİH ALANI
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
            //GÖVDE
            Expanded(
              child: Row(
                children: <Widget>[
                  Spacer(),
                  //BACAFANI VE ISITICI
                  Expanded(flex: 60,
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        //BACAFAN
                        Expanded(flex: 20,
                          child: Column(
                            children: <Widget>[
                                  //Başlık
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(flex:10,
                                          child: Row(
                                            children: <Widget>[
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
                                              Expanded(flex: 6,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 1*oran),
                                                    child: StreamBuilder<Object>(
                                                      initialData: "0",
                                                      stream: _blocSinif.bloCVeriStateStreamControllerBFANCALSUR.stream,
                                                      builder: (context, snapshot) {
                                                        calismaSuresi=int.parse(snapshot.data);
                                                        return AutoSizeText(
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
                                                        );
                                                      }
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
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
                                              Expanded(flex: 6,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 1*oran),
                                                    child: StreamBuilder<Object>(
                                                      initialData: "0",
                                                      stream: _blocSinif.bloCVeriStateStreamControllerBFANDURSUR.stream,
                                                      builder: (context, snapshot) {
                                                        durmaSuresi=int.parse(snapshot.data);
                                                        return AutoSizeText(
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
                                                        );
                                                      }
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            
                                            ],
                                          )
                                        ),
                                        Spacer(flex: 1,),
                                        Expanded(flex: 16,
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv649"),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40,
                                                ),
                                                maxLines: 1,
                                                minFontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 3,
                                                  child: StreamBuilder<Object>(
                                                      initialData: "0",
                                                      stream: _blocSinif.bloCVeriStateStreamControllerBfanOTO.stream,
                                                      builder: (context, snapshot) {
                                                      otoBfa=snapshot.data=="1" ? true : false;
                                                      return autoManGosterge(otoBfa, oran, dilSecimi);
                                                    }
                                                  ),
                                                ),
                                        Spacer(),
                                        Expanded(flex:7,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(flex: 3,
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, (bfanSurucu ? "tv651" : "tv652")),
                                                    maxLines: 1,
                                                    minFontSize: 2,
                                                    style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      fontSize: 60,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: StreamBuilder<Object>(
                                                    initialData: "0.0",
                                                    stream: _blocSinif.bloCVeriStateStreamControllerBFANAKTUEL.stream,
                                                    builder: (context, snapshot) {
                                                      String xx=snapshot.data;
                                                      String yy=bfanSurucu ? xx : xx.split(".")[0];
                                                    fasilaVeyaHizAktuelDeger=yy;
                                                      return AutoSizeText(
                                                        fasilaVeyaHizAktuelDeger,
                                                        maxLines: 1,
                                                        minFontSize: 2,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          fontSize: 60,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                                                            
                                      ],
                                    ),
                                  ),
                                  //Bacafan Harita
                                  Expanded(
                                    flex: 20,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  "assets/images/bina_catili_ust_gorunum.png"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Spacer(),
                                            Expanded(
                                              flex: 10,
                                              child: StreamBuilder<Object>(
                                                initialData: "0",
                                                    stream: _blocSinif.bloCVeriStateStreamControllerBFANDURUM.stream,
                                                    builder: (context, snapshot) {
                                                    bacafanDurum=snapshot.data =="1" ? true : false;
                                                  return Row(
                                                    children: <Widget>[
                                                      Spacer(),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                1, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                2, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                3, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                4, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                5, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                6, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                7, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                8, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                9, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                10, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                11, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                12, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                13, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                14, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                15, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                16, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                17, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                18, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                19, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                20, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                21, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                22, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                23, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                24, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            _bacafanHaritaUnsur(
                                                                25, oran, "tv64", 1,context),
                                                            Spacer(),
                                                            _bacafanHaritaUnsur(
                                                                26, oran, "tv64", 1,context),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer()
                                                    ],
                                                  );
                                                }
                                              ),
                                            ),
                                            Spacer()
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                               
                            ],
                          ),
                        ),
                        Spacer(),
                        //ISITICI
                        Expanded(flex: 20,
                        child: Column(
                          children: <Widget>[ 
                            //Başlık
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Spacer(flex: 11,),
                                  Expanded(flex: 16,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv650"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 3,
                                    child: StreamBuilder<Object>(
                                      initialData: "0",
                                      stream: _blocSinif.bloCVeriStateStreamControllerIstOTO.stream,
                                      builder: (context, snapshot) {
                                      otoIst=snapshot.data =="1" ? true : false;
                                        return autoManGosterge(otoIst, oran, dilSecimi);
                                      }
                                    ),
                                  ),
                                  Spacer(flex: 8,),
                                ],
                              ),
                            ),
                            //Isıtıcı Haritası
                            Expanded(
                              flex: 20,
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
                                                  _isiticiHaritaUnsur(
                                                      1, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      2, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      3, oran, "tv80", context, _blocSinif),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: <Widget>[
                                                  _isiticiHaritaUnsur(
                                                      4, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      5, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      6, oran, "tv80", context, _blocSinif),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: <Widget>[
                                                  _isiticiHaritaUnsur(
                                                      7, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      8, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      9, oran, "tv80", context, _blocSinif),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: <Widget>[
                                                  _isiticiHaritaUnsur(
                                                      10, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      11, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      12, oran, "tv80", context, _blocSinif),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: <Widget>[
                                                  _isiticiHaritaUnsur(
                                                      13, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      14, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      15, oran, "tv80", context, _blocSinif),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: <Widget>[
                                                  _isiticiHaritaUnsur(
                                                      16, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      17, oran, "tv80", context, _blocSinif),
                                                  Spacer(),
                                                  _isiticiHaritaUnsur(
                                                      18, oran, "tv80", context, _blocSinif),
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
                              ),
                            ),
                            
                          ],
                        ),
                      ),                
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                  //AKTİF MOD - AIR INLET - SİRKÜLASYON FAN - SICAKLIKLAR
                  Expanded(flex: 20,
                    child: Column(
                      children: <Widget>[
                        //AKtif MOD
                        Expanded(flex: 5,
                          child: Column(
                            children: <Widget>[
                              Spacer(),
                              Expanded(flex: 4,
                                child: Container(
                                  color: Colors.blue[900],
                                  child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: StreamBuilder<Object>(
                                        initialData: "3*1",
                                        stream: _blocSinif.bloCVeriStateStreamControllerMODveYNEM.stream,
                                        builder: (context, snapshot) {
                                          String xx=snapshot.data;
                                          var yy=xx.split("*");
                                          sistemModu=int.parse(yy[0]);
                                          nemDurum=int.parse(yy[1]);
                                          return AutoSizeText(
                                            Dil().sec(dilSecimi, "tv571")+" "+sistemModu.toString()+": "+sistemModMetni(sistemModu,nemDurum),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 50.0,
                                                fontFamily: 'Kelly Slab'),
                                            maxLines: 1,
                                            minFontSize: 5,
                                          );
                                        }
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),   
                        //Air inlet
                        Expanded(flex: 15,
                          child: Visibility(visible: airinletAdet!="0" ? true : false,
                            child: Column(
                              children: <Widget>[
                                //Başlık
                                Expanded(flex: 1,
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
                                            fontWeight: FontWeight.bold,
                                            fontFamily:'Kelly Slab',
                                            ),
                                        maxLines: 1,
                                        minFontSize: 5,
                                      ),
                                    ),
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
                                                Spacer(flex: 2,),
                                                Expanded(flex: 6,
                                                  child: StreamBuilder<Object>(
                                                    initialData: "0",
                                                    stream: _blocSinif.bloCVeriStateStreamControllerAirOTO.stream,
                                                    builder: (context, snapshot) {
                                                      otoAir = snapshot.data=="1" ? true :false;
                                                      return autoManGosterge(otoAir, oran, dilSecimi);
                                                    }
                                                  ),
                                                ),
                                                Spacer(flex: 17,)
                                              ],
                                            ),
                                          ),
                                          Spacer(flex: 3,)
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
                                        ],
                                      ),
                                      //Air inlet Durumları
                                      Row(
                                        children: <Widget>[
                                          Expanded(flex:2,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Spacer(flex: 9,),
                                                Expanded(flex: 3,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: 1*oran),
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv589"),
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
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: 1*oran),
                                                      child: StreamBuilder<Object>(
                                                        initialData: "0",
                                                        stream: _blocSinif.bloCVeriStateStreamControllerAIRDURUM.stream,
                                                        builder: (context, snapshot) {
                                                          airInlet1Durum = snapshot.data;
                                                          return AutoSizeText(
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
                                                          );
                                                        }
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
                        //Sirk. Fan
                        Expanded(flex: 15,
                          child: Visibility(visible: sirkFanAdet!="0" ? true : false,
                            child: Stack(fit: StackFit.expand,
                            children: <Widget>[
                              //Başlık
                              Column(
                                children: <Widget>[
                                  Expanded(flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.only(left: 1*oran),
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv581"),
                                          textAlign:
                                              TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:'Kelly Slab',
                                              ),
                                          maxLines: 1,
                                          minFontSize: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(flex: 5,)
                                ],
                              ),
                              //Sirkülasyon fan resmi
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
                              
                              StreamBuilder<Object>(
                                initialData: "0",
                                stream: _blocSinif.bloCVeriStateStreamControllerSirkOTO.stream,
                                builder: (context, snapshot) {
                                  otoSrk = snapshot.data == "1" ? true : false;
                                  return Column(
                                    children: <Widget>[
                                      Spacer(),
                                      Expanded(flex: 2,
                                        child: Row(
                                        children: <Widget>[
                                          Spacer(flex: 22,),
                                          Expanded(flex:7,
                                            child: Column(
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(flex: 2,
                                                  child: StreamBuilder<Object>(
                                                    stream: null,
                                                    builder: (context, snapshot) {
                                                      return autoManGosterge(otoSrk, oran, dilSecimi);
                                                    }
                                                  )
                                                ),
                                              ],
                                            )
                                          ),
                                          Spacer(flex: 3,)
                                        ],
                                      )),
                                      
                                      Expanded(flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Spacer(flex: 6,),
                                            Expanded(flex:4,
                                              child: SizedBox(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(left: 1*oran),
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv589"),
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
                                                  otoSrk ? Icons.check_circle : Icons.remove_circle,
                                                  size: constraint
                                                      .biggest
                                                      .width,
                                                  color: otoSrk ?  Colors.green[600] : Colors.red[600],
                                                );
                                              }),
                                              ),
                                            ),
                                            Spacer(flex:2,)
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  );
                                }
                              ),
                              
                            ],
                            ),
                          ),
                        ),
                        Spacer(),
                        //Sıcaklıklar
                        Expanded(flex: 15,
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    //Set Sıcaklığı
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                              child: StreamBuilder<Object>(
                                                initialData: "0.0",
                                                stream: _blocSinif.bloCVeriStateStreamControllerSET.stream,
                                                builder: (context, snapshot) {
                                                  setSicakligi = snapshot.data;
                                                  return AutoSizeText(
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
                                                  );
                                                }
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
                                    Expanded(
                                      child: Container(
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
                                                  child: StreamBuilder<Object>(
                                                    initialData: "0.0",
                                                    stream: _blocSinif.bloCVeriStateStreamControllerORT.stream,
                                                    builder: (context, snapshot) {
                                                      ortSicaklik = snapshot.data;
                                                      return AutoSizeText(
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
                                                      );
                                                    }
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
                                                           child: StreamBuilder<Object>(
                                                            initialData: "0.0",
                                                            stream: _blocSinif.bloCVeriStateStreamControllerDBB.stream,
                                                            builder: (context, snapshot) {
                                                              dogBolgeBitis = snapshot.data;
                                                               return AutoSizeText(
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
                                                               );
                                                             }
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
                                                           child: StreamBuilder<Object>(
                                                            initialData: "0.0",
                                                            stream: _blocSinif.bloCVeriStateStreamControllerCBB.stream,
                                                            builder: (context, snapshot) {
                                                              capBolgeBitis = snapshot.data;
                                                               return AutoSizeText(
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
                                                               );
                                                             }
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
                                ),
                              ),
                              Spacer(flex: 2,)
                            ],
                          )
                        ),
                                    
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            )
          ],
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
                      Dil().sec(dilSecimi, "tv599"), 
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
                                  text: Dil().sec(dilSecimi, "info27"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),



                                TextSpan(
                                  text: '\n\n'+Dil().sec(dilSecimi, "tv673"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text:'\n'+ Dil().sec(dilSecimi, "ksltm21")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm22")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm7")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm8")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm25")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm26")+'\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11*oran,
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

  String imageGetirBacafan(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/harita_bacafan_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  String imageGetirIsitici(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/kurulum_isitici_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
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


  Widget _bacafanHaritaUnsur(int indexNo, double oran, String baslik, int degerGirisKodu, BuildContext context) {
    return Expanded(flex: 3,
      child: Visibility(
        visible: bacafanVisibility[indexNo] ? true : false,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: RawMaterialButton(
                  onPressed: () {

                    
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.bottomCenter,
                            image: AssetImage(
                                imageGetirBacafan(bacafanHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedBuilder(animation: bacafanDurum ? _controller1 : _controller2,
                        builder: (context, child) => 
                                        RotationTransition(
                            turns:  bacafanDurum ? _controller1 : _controller2,
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.0).animate(
                                  bacafanDurum ? _controller1 : _controller2,
                                  ),
                              child: Image.asset("assets/images/bfan_rotate_icon.png",
                                scale: 1.5 / oran,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: bacafanHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Column(
                          children: <Widget>[
                            //bacafan No
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText(
                                    bacafanNo[indexNo].toString(),
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
                            Spacer(flex: 3,)
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _isiticiHaritaUnsur(int indexNo, double oran, String baslik, BuildContext context, IzlemeBfanAirIstcBloC _blocSinif) {
    return StreamBuilder<Object>(
      initialData: "0",
      stream: _blocSinif.bloCVeriStateStreamControllerISITICIDURUM[indexNo].stream,
      builder: (context, snapshot)
       {
        String xx= snapshot.data;
        bool durum=xx=="1" ? true : false;
        return Expanded(flex: 3,
          child: Visibility(
            visible: isiticiVisibility[indexNo] ? true : false,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: RawMaterialButton(
                      onPressed: () {
                        
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                image: AssetImage(
                                    imageGetirIsitici(isiticiHarita[indexNo])),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Visibility(visible: durum,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      'assets/images/fire_animation.gif'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Expanded(flex: 3,
                                child: LayoutBuilder(
                                   builder: (context, constraint) {
                                 return Icon(
                                   durum ? Icons.check_circle : Icons.remove_circle,
                                   size: constraint.biggest.height,
                                   color: durum ? Colors.green[700] : Colors.red[700],
                                 );
                         }),
                              ),
                              Spacer(flex: 2,)
                            ],
                          ),
                          Visibility(
                            visible: haritaOnayIsitici && isiticiHarita[indexNo] != 0
                                ? true
                                : false,
                            maintainState: true,
                            maintainSize: true,
                            maintainAnimation: true,
                            child: Row(
                              children: <Widget>[
                                //isitici No
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: <Widget>[
                                            Spacer(),
                                            Expanded(flex: 3,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    isiticiNo[indexNo].toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab'),
                                                    maxLines: 1,
                                                    minFontSize: 6,
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
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      }
    );
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


class IzlemeBfanAirIstcBloC {

  String veri="";

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  //Bacafan aktüel hıız veya fasıla değeri için SteateStream
  final bloCVeriStateStreamControllerBFANAKTUEL = StreamController<String>();
  //Bacafan çalıma süresi değeri için SteateStream
  final bloCVeriStateStreamControllerBFANCALSUR = StreamController<String>();
  //Bacafan durma süresi değeri için SteateStream
  final bloCVeriStateStreamControllerBFANDURSUR = StreamController<String>();
  //Bacafan çıkışı için SteateStream
  final bloCVeriStateStreamControllerBFANDURUM = StreamController<String>();
  //Isıtıcı çıkışları için SteateStream
  List<StreamController<String>> bloCVeriStateStreamControllerISITICIDURUM=new List(19);
  //Sistem Mod ve Yüksek nem için SteateStream
  final bloCVeriStateStreamControllerMODveYNEM = StreamController<String>();
  //Air inlet çıkışı için SteateStream
  final bloCVeriStateStreamControllerAIRDURUM = StreamController<String>();
  //Sirkülasyon çıkışı için SteateStream
  final bloCVeriStateStreamControllerSIRKDURUM = StreamController<String>();
  //Set Sıcaklığı için SteateStream
  final bloCVeriStateStreamControllerSET = StreamController<String>();
  //ortalama Sıcaklığı için SteateStream
  final bloCVeriStateStreamControllerORT = StreamController<String>();
  //Doğak Bölge Bitiş Sıcaklığı için SteateStream
  final bloCVeriStateStreamControllerDBB = StreamController<String>();
  //Capraz Bölge bitiş için SteateStream
  final bloCVeriStateStreamControllerCBB = StreamController<String>();
  //Bacafan Oto-man için SteateStream
  final bloCVeriStateStreamControllerBfanOTO = StreamController<String>();
  //Isıtıcı Oto-man için SteateStream
  final bloCVeriStateStreamControllerIstOTO = StreamController<String>();
  //Air inlet Oto-man için SteateStream
  final bloCVeriStateStreamControllerAirOTO = StreamController<String>();
  //Sirkülasyon fan Oto-man için SteateStream
  final bloCVeriStateStreamControllerSirkOTO = StreamController<String>();




  //Bacafan aktüel hıız veya fasıla değeri için EventStream
  final bloCVeriEventStreamControllerBFANAKTUEL = StreamController<String>();
  //Bacafan çalıma süresi değeri için EventStream
  final bloCVeriEventStreamControllerBFANCALSUR = StreamController<String>();
  //Bacafan durma süresi değeri için EventStream
  final bloCVeriEventStreamControllerBFANDURSUR = StreamController<String>();
  //Bacafan çıkışı için EventStream
  final bloCVeriEventStreamControllerBFANDURUM = StreamController<String>();
  //Isıtıcı çıkışları için EventStream
  List<StreamController<String>> bloCVeriEventStreamControllerISITICIDURUM=new List(19);
  //Sistem Mod ve Yüksek nem için EventStream
  final bloCVeriEventStreamControllerMODveYNEM = StreamController<String>();
  //Air inlet çıkışı için EventStream
  final bloCVeriEventStreamControllerAIRDURUM = StreamController<String>();
  //Sirkülasyon çıkışı için EventStream
  final bloCVeriEventStreamControllerSIRKDURUM = StreamController<String>();
  //Set Sıcaklığı EventStream
  final bloCVeriEventStreamControllerSET = StreamController<String>();
  //ortalama Sıcaklığı için EventStream
  final bloCVeriEventStreamControllerORT = StreamController<String>();
  //Doğak Bölge Bitiş Sıcaklığı için EventStream
  final bloCVeriEventStreamControllerDBB = StreamController<String>();
  //Capraz Bölge bitiş için EventStream
  final bloCVeriEventStreamControllerCBB = StreamController<String>();
  //Bacafan Oto-man için SteateStream
  final bloCVeriEventStreamControllerBfanOTO = StreamController<String>();
  //Isıtıcı Oto-man için SteateStream
  final bloCVeriEventStreamControllerIstOTO = StreamController<String>();
  //Air inlet Oto-man için SteateStream
  final bloCVeriEventStreamControllerAirOTO = StreamController<String>();
  //Sirkülasyon fan Oto-man için SteateStream
  final bloCVeriEventStreamControllerSirkOTO = StreamController<String>();


  String aktuelFasVeyaHizGecici="";
  String calismaSuresiGecici="";
  String durmaSuresiGecici="";
  String bacafanDurumGecici="";
  List<String> isiticiDurumlarGecici=new List.filled(4, "0");
  String sistemMODyukNEMGecici="";
  String airinletDurumGecici="";
  String sirkfanDurumGecici="";
  String setDegerGecici="";
  String ortDegerGecici="";
  String dbbDegerGecici="";
  String cbbDegerGecici="";
  String otoBFANGecici="";
  String otoISTCGecici="";
  String otoAIRIGecici="";
  String otoSIRKGecici="";

  IzlemeBfanAirIstcBloC(BuildContext context, String dilSecimi, List isiticiNo) {

    for (var i = 0; i < 19; i++) {
      bloCVeriStateStreamControllerISITICIDURUM[i]=StreamController<String>();
      bloCVeriEventStreamControllerISITICIDURUM[i]=StreamController<String>();
    }

    if (timerSayac == 0) {


      Metotlar().takipEt("3*0", 2237).then((veri){

        var degerler=veri.split("*");
        if(degerler[0]=="error"){
          Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
        }else{

          var kk=veri.split("#");
          var xx=kk[0].split("*");
          var yy=kk[1].split("*");

          String aktuelFasVeyaHiz=xx[0];
          if(aktuelFasVeyaHiz!=aktuelFasVeyaHizGecici){
            bloCVeriStateStreamControllerBFANAKTUEL.sink.add(aktuelFasVeyaHiz);
          }
          aktuelFasVeyaHizGecici=aktuelFasVeyaHiz;

          String calismaSuresi=xx[1];
          if(calismaSuresi!=calismaSuresiGecici){
            bloCVeriStateStreamControllerBFANCALSUR.sink.add(calismaSuresi);
          }
          calismaSuresiGecici=calismaSuresi;

          String durmaSuresi=xx[2];
          if(durmaSuresi!=durmaSuresiGecici){
            bloCVeriStateStreamControllerBFANDURSUR.sink.add(durmaSuresi);
          }
          durmaSuresiGecici=durmaSuresi;

          String bacafanDurum=xx[3];
          if(bacafanDurum!=bacafanDurumGecici){
            bloCVeriStateStreamControllerBFANDURUM.sink.add(bacafanDurum);
          }
          bacafanDurumGecici=bacafanDurum;


          List<String> isiticiDurumlar=new List.filled(4, "0");
          isiticiDurumlar[1]=xx[4];
          isiticiDurumlar[2]=xx[5];
          isiticiDurumlar[3]=xx[6];
            

          for (var i = 1; i < 19; i++) {
            if(isiticiNo[i]!="0"){

              if(isiticiDurumlar[isiticiNo[i]]!=isiticiDurumlarGecici[isiticiNo[i]]){
                bloCVeriStateStreamControllerISITICIDURUM[i].sink.add(isiticiDurumlar[isiticiNo[i]]);
              }
            }
          }
          isiticiDurumlarGecici=List.from(isiticiDurumlar);


          String sistemMODyukNEM=xx[7]+"*"+xx[8];
          if(sistemMODyukNEM!=sistemMODyukNEMGecici){
            bloCVeriStateStreamControllerMODveYNEM.sink.add(sistemMODyukNEM);
          }
          sistemMODyukNEMGecici=sistemMODyukNEM;


          String airinletDurum=xx[9];
          if(airinletDurum!=airinletDurumGecici){
            bloCVeriStateStreamControllerAIRDURUM.sink.add(airinletDurum);
          }
          airinletDurumGecici=airinletDurum;

          String sirkfanDurum=xx[10];
          if(sirkfanDurum!=sirkfanDurumGecici){
            bloCVeriStateStreamControllerSIRKDURUM.sink.add(sirkfanDurum);
          }
          sirkfanDurumGecici=sirkfanDurum;
          
          String setDeger=xx[11];
          if(setDeger!=setDegerGecici){
            bloCVeriStateStreamControllerSET.sink.add(setDeger);
          }
          setDegerGecici=setDeger;

          String ortDeger=xx[12];
          if(ortDeger!=ortDegerGecici){
            bloCVeriStateStreamControllerORT.sink.add(ortDeger);
          }
          ortDegerGecici=ortDeger;

          String dbbDeger=xx[13];
          if(dbbDeger!=dbbDegerGecici){
            bloCVeriStateStreamControllerDBB.sink.add(dbbDeger);
          }
          dbbDegerGecici=dbbDeger;

          String cbbDeger=xx[14];
          if(cbbDeger!=cbbDegerGecici){
            bloCVeriStateStreamControllerCBB.sink.add(cbbDeger);
          }
          cbbDegerGecici=cbbDeger;



          String otoBFAN=yy[0];
          if(otoBFAN!=otoBFANGecici){
            bloCVeriStateStreamControllerBfanOTO.sink.add(otoBFAN);
          }
          otoBFANGecici=otoBFAN;

          String otoISTC=yy[1];
          if(otoISTC!=otoISTCGecici){
            bloCVeriStateStreamControllerIstOTO.sink.add(otoISTC);
          }
          otoISTCGecici=otoISTC;

          String otoAIRI=yy[2];
          if(otoAIRI!=otoAIRIGecici){
            bloCVeriStateStreamControllerAirOTO.sink.add(otoAIRI);
          }
          otoAIRIGecici=otoAIRI;

          String otoSIRK=yy[3];
          if(otoSIRK!=otoSIRKGecici){
            bloCVeriStateStreamControllerSirkOTO.sink.add(otoSIRK);
          }
          otoSIRKGecici=otoSIRK;


          print(veri);
        }
      });




      Timer.periodic(Duration(seconds: 2), (timer) {

        if (timerCancel) {
          timer.cancel();
        }
        
        if (!baglanti) {
          baglanti = true;
          
          
         Metotlar().takipEt("3*0", 2237).then((veri){

        var degerler=veri.split("*");
        
        if(degerler[0]=="error"){
          Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
        }else{

            var kk=veri.split("#");
            var xx=kk[0].split("*");
            var yy=kk[1].split("*");

            String aktuelFasVeyaHiz=xx[0];
            if(aktuelFasVeyaHiz!=aktuelFasVeyaHizGecici){
              bloCVeriStateStreamControllerBFANAKTUEL.sink.add(aktuelFasVeyaHiz);
            }
            aktuelFasVeyaHizGecici=aktuelFasVeyaHiz;

            String calismaSuresi=xx[1];
            if(calismaSuresi!=calismaSuresiGecici){
              bloCVeriStateStreamControllerBFANCALSUR.sink.add(calismaSuresi);
            }
            calismaSuresiGecici=calismaSuresi;

            String durmaSuresi=xx[2];
            if(durmaSuresi!=durmaSuresiGecici){
              bloCVeriStateStreamControllerBFANDURSUR.sink.add(durmaSuresi);
            }
            durmaSuresiGecici=durmaSuresi;

            String bacafanDurum=xx[3];
            if(bacafanDurum!=bacafanDurumGecici){
              bloCVeriStateStreamControllerBFANDURUM.sink.add(bacafanDurum);
            }
            bacafanDurumGecici=bacafanDurum;


            List<String> isiticiDurumlar=new List.filled(4, "0");
            isiticiDurumlar[1]=xx[4];
            isiticiDurumlar[2]=xx[5];
            isiticiDurumlar[3]=xx[6];
              

            for (var i = 1; i < 19; i++) {
              if(isiticiNo[i]!="0"){

                if(isiticiDurumlar[isiticiNo[i]]!=isiticiDurumlarGecici[isiticiNo[i]]){
                  bloCVeriStateStreamControllerISITICIDURUM[i].sink.add(isiticiDurumlar[isiticiNo[i]]);
                }
              }
            }
            isiticiDurumlarGecici=List.from(isiticiDurumlar);


            String sistemMODyukNEM=xx[7]+"*"+xx[8];
            if(sistemMODyukNEM!=sistemMODyukNEMGecici){
              bloCVeriStateStreamControllerMODveYNEM.sink.add(sistemMODyukNEM);
            }
            sistemMODyukNEMGecici=sistemMODyukNEM;


            String airinletDurum=xx[9];
            if(airinletDurum!=airinletDurumGecici){
              bloCVeriStateStreamControllerAIRDURUM.sink.add(airinletDurum);
            }
            airinletDurumGecici=airinletDurum;

            String sirkfanDurum=xx[10];
            if(sirkfanDurum!=sirkfanDurumGecici){
              bloCVeriStateStreamControllerSIRKDURUM.sink.add(sirkfanDurum);
            }
            sirkfanDurumGecici=sirkfanDurum;
            
            String setDeger=xx[11];
            if(setDeger!=setDegerGecici){
              bloCVeriStateStreamControllerSET.sink.add(setDeger);
            }
            setDegerGecici=setDeger;

            String ortDeger=xx[12];
            if(ortDeger!=ortDegerGecici){
              bloCVeriStateStreamControllerORT.sink.add(ortDeger);
            }
            ortDegerGecici=ortDeger;

            String dbbDeger=xx[13];
            if(dbbDeger!=dbbDegerGecici){
              bloCVeriStateStreamControllerDBB.sink.add(dbbDeger);
            }
            dbbDegerGecici=dbbDeger;

            String cbbDeger=xx[14];
            if(cbbDeger!=cbbDegerGecici){
              bloCVeriStateStreamControllerCBB.sink.add(cbbDeger);
            }
            cbbDegerGecici=cbbDeger;



            String otoBFAN=yy[0];
            if(otoBFAN!=otoBFANGecici){
              bloCVeriStateStreamControllerBfanOTO.sink.add(otoBFAN);
            }
            otoBFANGecici=otoBFAN;

            String otoISTC=yy[1];
            if(otoISTC!=otoISTCGecici){
              bloCVeriStateStreamControllerIstOTO.sink.add(otoISTC);
            }
            otoISTCGecici=otoISTC;

            String otoAIRI=yy[2];
            if(otoAIRI!=otoAIRIGecici){
              bloCVeriStateStreamControllerAirOTO.sink.add(otoAIRI);
            }
            otoAIRIGecici=otoAIRI;

            String otoSIRK=yy[3];
            if(otoSIRK!=otoSIRKGecici){
              bloCVeriStateStreamControllerSirkOTO.sink.add(otoSIRK);
            }
            otoSIRKGecici=otoSIRK;


              print(veri);
              baglanti=false;

         }

            });
        }
      });


    }

    timerSayac++;

    bloCVeriEventStreamControllerISITICIDURUM[0].stream.listen((event) {
        timerCancel=true;
    });


  }


}

