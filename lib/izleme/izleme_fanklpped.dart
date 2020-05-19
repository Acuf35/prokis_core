



import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prokis/genel_ayarlar/izleme.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';

class IzlemeFanKlpPed extends StatefulWidget {
  List<Map> gelenDBveri;
  IzlemeFanKlpPed(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  _IzlemeFanKlpPedState createState() => _IzlemeFanKlpPedState(gelenDBveri);
}

class _IzlemeFanKlpPedState extends State<IzlemeFanKlpPed> with TickerProviderStateMixin{


  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
  var oran;
  String fanAdet="0";
  String sensorBaglanti="0";
  String disNemVarMi="0";

  int unsurAdet = 0;
  int sutunSayisi;
  List<int> fanHaritaGrid = new List.filled(121,0);
  List<String> fanNo = new List.filled(121,"0");

  List<String> klepeNo = new List(19);
  List<String> pedNo = new List(25);
  List<String> isisensorNo = new List(23);
  List<bool> otoKlp = new List.filled(11,false);

  List<String> klepeAciklik = new List.filled(11,"0.0");
  List<bool> pedDurum = new List.filled(11,false);
  List<String> isisensorDeger = new List.filled(16,"0.0");

  bool otoPed=false;

  String icNem="0.0";
  String disNem="0.0";

  String pedFasilaAktuel="0";

  String airinletAdet="0";
  String bacaFanAdet="0";
  String isiticiAdet="0";
  String sirkFanAdet="1";

  bool bfanSurucu=false;

  List<bool> fanDurum = new List.filled(121,false);

  AnimationController _controller1;
  AnimationController _controller2;

  bool otoFan=false;

  int sistemModu=0;
  int nemDurum=0;
  int calismaSuresi=0;
  int durmaSuresi=0;
  String setSicakligi="21.0";
  String ortSicaklik="26.4";
  String dogBolgeBitis="22.0";
  String capBolgeBitis="24.0";


  String initialVeri="1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*"
"0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*#4*0*0.0*0*158*142*23.0*27.5*24.0*26.0*0*0*0*0*0*0*0#100.0*63.5*63.5*0."
"0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*1*0*0*0*0*0*0*0*0*0*#1*1*1*1*0*0*0*0*0*0*0*1*1*1*0*1*0*0*#0.0*0.0";

  String baglantiDurum="";


  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  _IzlemeFanKlpPedState(List<Map> dbVeri) {
    dbVeriler=dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
        
      }

      if (dbVeri[i]["id"] == 13) {
        disNemVarMi = dbVeri[i]["veri4"];
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

  }
//--------------------------CONSTRUCTER METHOD--------------------------------



  @override
  Widget build(BuildContext context) {

    oran = MediaQuery.of(context).size.width / 731.4;
    final _blocSinif  = IzlemeFanKlpPedBloC(context, dilSecimi, fanNo, unsurAdet, klepeNo, isisensorNo, pedNo);

    
    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 1500),);
    _controller2 = AnimationController(vsync: this,duration: Duration(milliseconds: 1500),);
    //
    _controller1.repeat();
    _controller2.stop();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30*oran),
          child: StreamBuilder<Object>(
            initialData: "",
            stream: _blocSinif.bloCVeriStateStreamControllerBAGLANTIERROR.stream,
            builder: (context, snapshot) {
              baglantiDurum=snapshot.data;
              return Metotlar().appBarBLOC(dilSecimi, context, oran, 'tv598',baglantiDurum);
            }
          ),
        ),
        floatingActionButton: Opacity(
          opacity: 0.4,
          child: Container(
            width: 56 * oran,
            height: 56 * oran,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _blocSinif.bloCVeriEventStreamControllerFAN[1].sink.add("99");
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
                  //Tünel Fanları-Sıcaklıklar- MOD
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        
                        //Fan Harita Bölümü
                        Expanded(flex: 9,
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
                                          child: StreamBuilder<Object>(
                                            initialData: "0",
                                            stream: _blocSinif.bloCVeriStateStreamControllerFANotoman.stream,
                                            builder: (context, snapshot) {

                                              otoFan=snapshot.data=="1" ? true : false;

                                              return autoManGosterge(otoFan, oran, dilSecimi);
                                            }
                                          )),

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
                                                child: seciliHaritaGrid(oran, _blocSinif),
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
                        ),
                 
                        //Aktfi Mod | Sıcaklıklar
                        Expanded(flex: 2,
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
                                        child: StreamBuilder<Object>(
                                          initialData: "0",
                                          stream: _blocSinif.bloCVeriStateStreamControllerMOD.stream,
                                          builder: (context, snapshot) {
                                            
                                            String xx=snapshot.data;
                                            sistemModu=int.parse(xx);
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
                              ),
                              //Sıcaklıklar
                              Expanded(flex: 3,
                                child: Row(
                                  children: <Widget>[
                                    //Set Sıcaklığı
                                    Expanded(
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Spacer(flex: 2,),
                                        Expanded(flex: 4,
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
                                        Spacer(flex: 1,),
                                        Expanded(flex: 8,
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: StreamBuilder<Object>(
                                                initialData: "0.0",
                                                stream: _blocSinif.bloCVeriStateStreamControllerSET.stream,
                                                builder: (context, snapshot) {

                                                  setSicakligi=snapshot.data;

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
                                        Spacer(flex: 1,),
                                        Expanded(flex: 4,
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
                                      child: Column(
                                        children: <Widget>[
                                          Spacer(),
                                          Expanded(flex: 5,
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
                                                          
                                                          ortSicaklik=snapshot.data;
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
                                    ),
                                          ),
                                          Spacer()
                                        ],
                                      )),
                                    //Doğal Bölge Çapraz Bölge
                                    Expanded(
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
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
                                                      
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      //Spacer(flex: 1,),
                                                      Expanded(flex: 4,
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.center,
                                                           child: StreamBuilder<Object>(
                                                             initialData: "0.0",
                                                              stream: _blocSinif.bloCVeriStateStreamControllerDBB.stream,
                                                              builder: (context, snapshot) {
                                                                
                                                                dogBolgeBitis=snapshot.data;
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
                                                           alignment: Alignment.center,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
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
                                                    
                                                Expanded(
                                                  child: Row(
                                                    children: <Widget>[
                                                      //Spacer(flex: 1,),
                                                      Expanded(flex: 4,
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.center,
                                                           child: StreamBuilder<Object>(
                                                             initialData: "0.0",
                                                              stream: _blocSinif.bloCVeriStateStreamControllerCBB.stream,
                                                              builder: (context, snapshot) {
                                                                
                                                                capBolgeBitis=snapshot.data;
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
                                                           alignment: Alignment.center,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                      ],
                                    )),
                                    
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
               
                        
                        ],
                    ),
                  ),
                  //Diğer unsurlar bölümü
                  Expanded(
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
                                                        _klepeIzlemeUnsurOnSol(oran, 13,_blocSinif),
                                                        Spacer(
                                                          flex: 3,
                                                        ),
                                                        _klepeIzlemeUnsurOnSol(oran, 10,_blocSinif),
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
                                                        _klepeIzlemeUnsurOnSol(oran, 14,_blocSinif),
                                                        Spacer(
                                                          flex: 3,
                                                        ),
                                                        _klepeIzlemeUnsurOnSol(oran, 11,_blocSinif),
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
                                                        _klepeIzlemeUnsurOnSol(oran, 15,_blocSinif),
                                                        Spacer(
                                                          flex: 3,
                                                        ),
                                                        _klepeIzlemeUnsurOnSol(oran, 12,_blocSinif),
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
                                                        _klepeIzlemeUnsurOnSol(oran, 1,_blocSinif),
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
                                                        _klepeIzlemeUnsurOnSol(oran, 2,_blocSinif),
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
                                                        _klepeIzlemeUnsurOnSol(oran, 3,_blocSinif),
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
                                                        _klepeIzlemeUnsurSag(oran, 4,_blocSinif),
                                                        Spacer(
                                                          flex: 3,
                                                        ),
                                                        _klepeIzlemeUnsurSag(oran, 7,_blocSinif),
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
                                                        _klepeIzlemeUnsurSag(oran, 5,_blocSinif),
                                                        Spacer(
                                                          flex: 3,
                                                        ),
                                                        _klepeIzlemeUnsurSag(oran, 8,_blocSinif),
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
                                                        _klepeIzlemeUnsurSag(oran, 6,_blocSinif),
                                                        Spacer(
                                                          flex: 3,
                                                        ),
                                                        _klepeIzlemeUnsurSag(oran, 9,_blocSinif),
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
                                                      _isisensorHaritaUnsur(oran, 22, _blocSinif),
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
                                                                        _isisensorHaritaUnsur(oran, 1, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 2, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 3, _blocSinif),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran, 4, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 5, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 6, _blocSinif),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran, 7, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 8, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 9, _blocSinif),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran, 10, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 11, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 12, _blocSinif),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran, 13, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 14, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 15, _blocSinif),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran, 16, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 17, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 18, _blocSinif),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        _isisensorHaritaUnsur(oran, 19, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 20, _blocSinif),
                                                                        _isisensorHaritaUnsur(oran, 21, _blocSinif),
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
                                          StreamBuilder<Object>(
                                            initialData: "0.0*0.0",
                                            stream: _blocSinif.bloCVeriStateStreamControllerNEM.stream,
                                            builder: (context, snapshot) {

                                              String xx = snapshot.data;
                                              var nemDegerler=xx.split("*");
                                              icNem=nemDegerler[0];
                                              disNem=nemDegerler[1];

                                              return Expanded(flex: 3,
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
                                                                  Expanded(flex: 3,
                                                                   child: SizedBox(
                                                                     child: Container(
                                                                       alignment: Alignment.centerLeft,
                                                                       padding: EdgeInsets.only(right: 2*oran),
                                                                       child: AutoSizeText(
                                                                         " %",
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
                                                                        Expanded(flex: 3,
                                                                         child: SizedBox(
                                                                           child: Container(
                                                                             alignment: Alignment.centerLeft,
                                                                             padding: EdgeInsets.only(right: 2*oran),
                                                                             child: AutoSizeText(
                                                                               " %",
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
                                              );
                                            }
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
                                                           child: StreamBuilder<Object>(
                                                              initialData: "0",
                                                              stream: _blocSinif.bloCVeriStateStreamControllerPED2.stream,
                                                              builder: (context, snapshot) {
                                                                
                                                                String xx=snapshot.data;
                                                                otoPed=xx=="1" ? true : false;

                                                               return autoManGosterge(otoPed, oran, dilSecimi);
                                                             }
                                                           )
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
                                                        _pedIzlemeUnsur(oran, 19, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 16, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 13, _blocSinif),
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
                                                        _pedIzlemeUnsur(oran, 20, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 17, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 14, _blocSinif),
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
                                                        _pedIzlemeUnsur(oran, 21, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 18, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 15, _blocSinif),
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
                                                  _pedIzlemeUnsur(oran, 1, _blocSinif),
                                                  Spacer(),
                                                  _pedIzlemeUnsur(oran, 2, _blocSinif),
                                                  Spacer(),
                                                  _pedIzlemeUnsur(oran, 3, _blocSinif),
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
                                                          StreamBuilder<Object>(
                                                            initialData: "0",
                                                            stream: _blocSinif.bloCVeriStateStreamControllerPED3.stream,
                                                            builder: (context, snapshot) {
                                                              
                                                              String xx=snapshot.data;
                                                              pedFasilaAktuel=xx;

                                                              return Expanded(flex: 4,
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
                                                              );
                                                            }
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
                                                        _pedIzlemeUnsur(oran, 4, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 7, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 10, _blocSinif),
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
                                                        _pedIzlemeUnsur(oran, 5, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 8, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 11, _blocSinif),
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
                                                        _pedIzlemeUnsur(oran, 6, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 9, _blocSinif),
                                                        Spacer(
                                                          flex: 1,
                                                        ),
                                                        _pedIzlemeUnsur(oran, 12, _blocSinif),
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
                  ),
            
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
                      Dil().sec(dilSecimi, "tv598"), 
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
                                  text: Dil().sec(dilSecimi, "info26"),
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
                                  Dil().sec(dilSecimi, "ksltm26")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm23")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm24")+'\n',
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


  Widget seciliHaritaGrid(double oran, IzlemeFanKlpPedBloC _blocSinif) {
    return GridView.count(
      //maxCrossAxisExtent: oranHarita/sutunSayisi,
      //childAspectRatio:2,
      crossAxisCount: sutunSayisi,
      children: List.generate(unsurAdet, (index) {
        return Center(child: _fanIzlemeUnsur(oran, index, _blocSinif));
      }),
    );
  }

  Widget _fanIzlemeUnsur(double oran, int index, IzlemeFanKlpPedBloC _blocSinif) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            StreamBuilder<Object>(
              initialData: "0",
              stream: _blocSinif.bloCVeriStateStreamControllerFAN[index].stream,
              builder: (context, snapshot) {

                fanDurum[index]=snapshot.data=="1" ? true : false;

                return Container(decoration: BoxDecoration(border: Border.all(width: fanHaritaGrid[index] == 2 ? 1*oran :  0,color: Colors.red[800])),
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
                );
              }
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

  Widget _klepeIzlemeUnsurOnSol(double oran, int index, IzlemeFanKlpPedBloC _blocSinif){

    return StreamBuilder<Object>(
      initialData: "0*0.0",
      stream: _blocSinif.bloCVeriStateStreamControllerKLEPE[index].stream,
      builder: (context, snapshot) {



        String gelen=snapshot.data;


        String aciklik=gelen.split("*")[1];
        bool otoDurum=gelen.split("*")[0]=="1" ? true : false;

        double klpSkewKatsayi=(double.parse(aciklik)/100)*0.8;
        int ustSeviye=((double.parse(aciklik)/100)*8).round();





        return Expanded(
                flex: klepeNo[index]=="0" ? 2 : 8,
                child: Visibility(visible: klepeNo[index]=="0" ? false : true,
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
                                      "K${klepeNo[index]}: $aciklik%",
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
    );


  }

  Widget _klepeIzlemeUnsurSag(double oran, int index, IzlemeFanKlpPedBloC _blocSinif){

  

    
    return StreamBuilder<Object>(
      initialData: "0*0.0",
      stream: _blocSinif.bloCVeriStateStreamControllerKLEPE[index].stream,
      builder: (context, snapshot) {

        String gelen=snapshot.data;


        String aciklik=gelen.split("*")[1];
        bool otoDurum=gelen.split("*")[0]=="1" ? true : false;

        double klpSkewKatsayi=(double.parse(aciklik)/100)*0.8;
        int ustSeviye=((double.parse(aciklik)/100)*8).round();



        return Expanded(
                flex: klepeNo[index]=="0" ? 2 : 8,
                child: Visibility(visible: klepeNo[index]=="0" ? false : true,
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
                                      "K${klepeNo[index]}: $aciklik%",
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
    );


  }


  Widget _pedIzlemeUnsur(double oran, int index, IzlemeFanKlpPedBloC _blocSinif){

    

    return StreamBuilder<Object>(
      initialData: "0",
      stream: _blocSinif.bloCVeriStateStreamControllerPED[index].stream,
      builder: (context, snapshot)
       {
        String xx= snapshot.data;
        bool durum=xx=="1" ? true : false;
        
        return Expanded(
                flex: 4,
                child: Visibility(visible: pedNo[index]=="0" ? false : true,
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
                          pedNo[index],
                          textScaleFactor:
                              oran,
                        ),
                      )
                    ],
                  ),
                ),
              );
      }
    );
                                            
  }


  Widget _isisensorHaritaUnsur(double oran, int index, IzlemeFanKlpPedBloC _blocSinif) {

    


    return StreamBuilder<Object>(
      initialData: "0.0",
      stream: _blocSinif.bloCVeriStateStreamControllerISISENSOR[index].stream,
      builder: (context, snapshot) {


        String sensDeger=snapshot.data;


        return Expanded(
          child: Visibility(

            visible: isisensorNo[index]=="0" ? false : true,
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
                            "S" +isisensorNo[index],
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




}


class IzlemeFanKlpPedBloC {

  String veri="";

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;


  //Fan çıkışları için SteateStream
  List<StreamController<String>> bloCVeriStateStreamControllerFAN=new List(121);
  //Fan Oto-Man değeri için SteateStream
  final bloCVeriStateStreamControllerFANotoman = StreamController<String>();
  //Klepe Açıklıkları ve otoman değeri için SteateStream
  List<StreamController<String>> bloCVeriStateStreamControllerKLEPE=new List(16);
  //Isı sensör NO için SteateStream
  List<StreamController<String>> bloCVeriStateStreamControllerISISENSOR=new List(23);
  //Nem değeri için SteateStream
  final bloCVeriStateStreamControllerNEM = StreamController<String>();
  //Ped durum için SteateStream
  List<StreamController<String>> bloCVeriStateStreamControllerPED=new List(25);
  //Ped oto durum için SteateStream
  final bloCVeriStateStreamControllerPED2 = StreamController<String>();
  //Ped fasıla değeri için SteateStream
  final bloCVeriStateStreamControllerPED3 = StreamController<String>();
  //Set sıcaklığı için SteateStream
  final bloCVeriStateStreamControllerSET = StreamController<String>();
  //Ortalama Sıcaklık için SteateStream
  final bloCVeriStateStreamControllerORT = StreamController<String>();
  //Doğal bölge bitiş için SteateStream
  final bloCVeriStateStreamControllerDBB = StreamController<String>();
  //Çapraz bölge bitiş için SteateStream
  final bloCVeriStateStreamControllerCBB = StreamController<String>();
  //Sistem Modu için SteateStream
  final bloCVeriStateStreamControllerMOD = StreamController<String>();
  //Bağlantı hatası
  final bloCVeriStateStreamControllerBAGLANTIERROR = StreamController<String>();
  

  //Fan çıkışları için EventStream
  List<StreamController<String>> bloCVeriEventStreamControllerFAN=new List(121);
  //Fan Oto-Man değeri için EventStream
  final bloCVeriEventStreamControllerFANotoman = StreamController<String>();
  //Klepe Açıklıkları ve otoman değeri için EventStream
  List<StreamController<String>> bloCVeriEventStreamControllerKLEPE=new List(16);
  //Isı sensör NO için EventStream
  List<StreamController<String>> bloCVeriEventStreamControllerISISENSOR=new List(23);
  //Nem değeri için EventStream
  final bloCVeriEventStreamControllerNem = StreamController<String>();
  //Ped durum için EventStream
  List<StreamController<String>> bloCVeriEventStreamControllerPED=new List(25);
  //Ped oto durum için EventStream
  final bloCVeriEventStreamControllerPED2 = StreamController<String>();
  //Ped fasıla değeri için EventStream
  final bloCVeriEventStreamControllerPED3 = StreamController<String>();
  //Set sıcaklığı için SteateStream
  final bloCVeriEventStreamControllerSET = StreamController<String>();
  //Ortalama Sıcaklık için SteateStream
  final bloCVeriEventStreamControllerORT = StreamController<String>();
  //Doğal bölge bitiş için SteateStream
  final bloCVeriEventStreamControllerDBB = StreamController<String>();
  //Çapraz bölge bitiş için SteateStream
  final bloCVeriEventStreamControllerCBB = StreamController<String>();
  //Sistem Modu için SteateStream
  final bloCVeriEventStreamControllerMOD = StreamController<String>();
  //Bağlantı hatası
  final bloCVeriEventStreamControllerBAGLANTIERROR = StreamController<String>();








  int sayac=0;

  

  List<String> fanDurumlarGecici=new List.filled(60, "0");
  List<String> klepeDurumlarGecici=new List.filled(11, "0");
  List<String> sensorDegerlerGecici=new List.filled(16, "0");
  List<String> pedDurumlarGecici=new List.filled(11, "0");
  String nemDegerlerGecici="";
  String fanOtoManGecici="";
  String ped2DurumGecici="";
  String ped3DurumGecici="";
  String setDegerGecici="";
  String ortDegerGecici="";
  String dbbDegerGecici="";
  String cbbDegerGecici="";
  String modGecici="";
  String baglantiHatasiGecici="";

  IzlemeFanKlpPedBloC(BuildContext context, String dilSecimi, List fanNo, int unsurAdet, List klepeNo, List isisensorNo, List pedNo) {

    for (var i = 0; i < 121; i++) {
      bloCVeriStateStreamControllerFAN[i]=StreamController<String>();
      bloCVeriEventStreamControllerFAN[i]=StreamController<String>();
    }

    for (var i = 0; i < 16; i++) {
      bloCVeriStateStreamControllerKLEPE[i]=StreamController<String>();
      bloCVeriEventStreamControllerKLEPE[i]=StreamController<String>();
    }

    for (var i = 0; i < 23; i++) {
      bloCVeriStateStreamControllerISISENSOR[i]=StreamController<String>();
      bloCVeriEventStreamControllerISISENSOR[i]=StreamController<String>();
    }

    for (var i = 0; i < 25; i++) {
      bloCVeriStateStreamControllerPED[i]=StreamController<String>();
      bloCVeriEventStreamControllerPED[i]=StreamController<String>();
    }


    if (timerSayac == 0) {


      Metotlar().takipEt("i1*", 2236).then((veri){

        var degerler=veri.split("*");
        if(veri.split("*")[0]=="error"){
          String baglantiHatasi=Metotlar().errorToastMesaj(degerler[1]);
          if(baglantiHatasi!=baglantiHatasiGecici){
            bloCVeriStateStreamControllerBAGLANTIERROR.sink.add(baglantiHatasi);
          }
          baglantiHatasiGecici=baglantiHatasi;
        }else{

          var xx=veri.split("#");

          String baglantiHatasi="";
            if(baglantiHatasi!=baglantiHatasiGecici){
              bloCVeriStateStreamControllerBAGLANTIERROR.sink.add(baglantiHatasi);
            }
            baglantiHatasiGecici=baglantiHatasi;


    //******************************FAN ÇIKIŞ DURUMLARI*******************************/
            var fanDurumlar=xx[0].split("*");

            for (var i = 0; i < unsurAdet; i++) {
              if(fanNo[i+1]!="0"){
                
                if(fanDurumlar[int.parse(fanNo[i+1])-1]!=fanDurumlarGecici[int.parse(fanNo[i+1])-1]){
                  bloCVeriStateStreamControllerFAN[i].sink.add(fanDurumlar[int.parse(fanNo[i+1])-1]);
                  
                }
              }
            }
            fanDurumlarGecici=List.from(fanDurumlar);
    //******************************FAN ÇIKIŞ DURUMLARI*******************************/

            //Fan oto-man durum
            String fanOtoMan = xx[1].split("*")[0];
            if(fanOtoMan!=fanOtoManGecici){
              bloCVeriStateStreamControllerFANotoman.sink.add(fanOtoMan);
            }
            fanOtoManGecici=fanOtoMan;
            

            //Nem Değerler
            String nemDegerler = xx[4];
            if(nemDegerler!=nemDegerlerGecici){
              bloCVeriStateStreamControllerNEM.sink.add(nemDegerler);
            }
            nemDegerlerGecici=nemDegerler;


    //******************************KLEPE DURUMLARI*******************************/
            List<String> klepeDurumlar=new List.filled(11, "0*0.0");
            for (var i = 1; i <= 10; i++) {
              klepeDurumlar[i]=xx[1].split("*")[i]+"*"+xx[2].split("*")[i-1];
            }
            

            for (var i = 1; i < 16; i++) {
              if(klepeNo[i]!="0"){
                
                if(klepeDurumlar[int.parse(klepeNo[i])]!=klepeDurumlarGecici[int.parse(klepeNo[i])]){
                  bloCVeriStateStreamControllerKLEPE[i].sink.add(klepeDurumlar[int.parse(klepeNo[i])]);
                }
              }
            }
            klepeDurumlarGecici=List.from(klepeDurumlar);
    //******************************KLEPE DURUMLARI*******************************/



    //******************************SENSOR DEĞERLERİ*******************************/
            List<String> sensorDegerler=new List.filled(16, "0.0");
            for (var i = 1; i <= 15; i++) {
              sensorDegerler[i]=xx[3].split("*")[i-1];
            }

            for (var i = 1; i < 23; i++) {
              if(isisensorNo[i]!="0" && sensorDegerler[int.parse(isisensorNo[i])]!=null){
                
                if(sensorDegerler[int.parse(isisensorNo[i])]!=sensorDegerlerGecici[int.parse(isisensorNo[i])]){
                  bloCVeriStateStreamControllerISISENSOR[i].sink.add(sensorDegerler[int.parse(isisensorNo[i])]);
                }
              }
            }
            sensorDegerlerGecici=List.from(sensorDegerler);
    //******************************SENSOR DEĞERLERİ*******************************/


    //******************************PED DURUMLARI*******************************/
            List<String> pedDurumlar=new List.filled(11, "0.0");
            for (var i = 1; i <= 10; i++) {
              pedDurumlar[i]=xx[5].split("*")[i-1];
            }
            String otoPed=xx[1].split("*")[11];
            String fasilaPed=xx[5].split("*")[10];

            if(otoPed!=ped2DurumGecici){
              bloCVeriStateStreamControllerPED2.sink.add(otoPed);
            }
            ped2DurumGecici=otoPed;

            if(fasilaPed!=ped3DurumGecici){
              bloCVeriStateStreamControllerPED3.sink.add(fasilaPed);
            }
            ped3DurumGecici=fasilaPed;

            

            for (var i = 1; i < 25; i++) {
              if(pedNo[i]!="0" && pedDurumlar[int.parse(pedNo[i])]!=null){
                
                if(pedDurumlar[int.parse(pedNo[i])]!=pedDurumlarGecici[int.parse(pedNo[i])]){
                  bloCVeriStateStreamControllerPED[i].sink.add(pedDurumlar[int.parse(pedNo[i])]);
                }
              }
            }
            pedDurumlarGecici=List.from(pedDurumlar);
    //******************************PED DURUMLARI*******************************/




    //******************************SICAKLIKLAR*******************************/

            String setDeger=xx[6].split("*")[0];
            String ortDeger=xx[6].split("*")[1];
            String dbbDeger=xx[6].split("*")[2];
            String cbbDeger=xx[6].split("*")[3];
            String mod=xx[6].split("*")[4];

            if(setDeger!=setDegerGecici){
              bloCVeriStateStreamControllerSET.sink.add(setDeger);
            }
            setDegerGecici=setDeger;

            if(ortDeger!=ortDegerGecici){
              bloCVeriStateStreamControllerORT.sink.add(ortDeger);
            }
            ortDegerGecici=ortDeger;

            if(dbbDeger!=dbbDegerGecici){
              bloCVeriStateStreamControllerDBB.sink.add(dbbDeger);
            }
            dbbDegerGecici=dbbDeger;

            if(cbbDeger!=cbbDegerGecici){
              bloCVeriStateStreamControllerCBB.sink.add(cbbDeger);
            }
            cbbDegerGecici=cbbDeger;

            if(mod!=modGecici){
              bloCVeriStateStreamControllerMOD.sink.add(mod);
            }
            modGecici=mod;

    //******************************SICAKLIKLAR*******************************/

            print(veri);

      }
        
      });




      Timer.periodic(Duration(seconds: 2), (timer) {

        if (timerCancel) {
          timer.cancel();
        }
        
        if (!baglanti) {
          baglanti = true;
          
          Metotlar().takipEt("i1*", 2236).then((veri){

            var degerler=veri.split("*");
        if(veri.split("*")[0]=="error"){
          String baglantiHatasi=Metotlar().errorToastMesaj(degerler[1]);
          if(baglantiHatasi!=baglantiHatasiGecici){
            bloCVeriStateStreamControllerBAGLANTIERROR.sink.add(baglantiHatasi);
          }
          baglantiHatasiGecici=baglantiHatasi;
        }else{

              var xx=veri.split("#");

              String baglantiHatasi="";
              if(baglantiHatasi!=baglantiHatasiGecici){
                bloCVeriStateStreamControllerBAGLANTIERROR.sink.add(baglantiHatasi);
              }
              baglantiHatasiGecici=baglantiHatasi;

      //******************************FAN ÇIKIŞ DURUMLARI*******************************/
              var fanDurumlar=xx[0].split("*");

              for (var i = 0; i < unsurAdet; i++) {
                if(fanNo[i+1]!="0"){
                  
                  if(fanDurumlar[int.parse(fanNo[i+1])-1]!=fanDurumlarGecici[int.parse(fanNo[i+1])-1]){
                    bloCVeriStateStreamControllerFAN[i].sink.add(fanDurumlar[int.parse(fanNo[i+1])-1]);
                    print("GİRİYORFAN");
                  }
                }
              }
              fanDurumlarGecici=List.from(fanDurumlar);
      //******************************FAN ÇIKIŞ DURUMLARI*******************************/

              //Fan oto-man durum
              String fanOtoMan = xx[1].split("*")[0];
              if(fanOtoMan!=fanOtoManGecici){
                bloCVeriStateStreamControllerFANotoman.sink.add(fanOtoMan);
                print("GİRİYORFANOTO");
              }
              fanOtoManGecici=fanOtoMan;
              

              //Nem Değerler
              String nemDegerler = xx[4];
              if(nemDegerler!=nemDegerlerGecici){
                bloCVeriStateStreamControllerNEM.sink.add(nemDegerler);
                print("GİRİYORNEM");
              }
              nemDegerlerGecici=nemDegerler;

      //******************************KLEPE DURUMLARI*******************************/

              List<String> klepeDurumlar=new List.filled(11, "0*0.0");
              for (var i = 1; i <= 10; i++) {
                klepeDurumlar[i]=xx[1].split("*")[i]+"*"+xx[2].split("*")[i-1];
              }
              

              for (var i = 1; i < 16; i++) {
                if(klepeNo[i]!="0"){
                  
                  if(klepeDurumlar[int.parse(klepeNo[i])]!=klepeDurumlarGecici[int.parse(klepeNo[i])]){
                    bloCVeriStateStreamControllerKLEPE[i].sink.add(klepeDurumlar[int.parse(klepeNo[i])]);
                    print("GİRİYORKLEPE");
                  }
                }
              }
              klepeDurumlarGecici=List.from(klepeDurumlar);
      //******************************KLEPE DURUMLARI*******************************/


      //******************************SENSOR DEĞERLERİ*******************************/
              List<String> sensorDegerler=new List.filled(16, "0.0");
              for (var i = 1; i <= 15; i++) {
                sensorDegerler[i]=xx[3].split("*")[i-1];
              }
              
              

              for (var i = 1; i < 23; i++) {
                if(isisensorNo[i]!="0" && sensorDegerler[int.parse(isisensorNo[i])]!=null){
                  
                  if(sensorDegerler[int.parse(isisensorNo[i])]!=sensorDegerlerGecici[int.parse(isisensorNo[i])]){
                    bloCVeriStateStreamControllerISISENSOR[i].sink.add(sensorDegerler[int.parse(isisensorNo[i])]);
                    print("GİRİYORISISENSOR");
                  }
                }
              }
              sensorDegerlerGecici=List.from(sensorDegerler);
      //******************************SENSOR DEĞERLERİ*******************************/


      //******************************PED DURUMLARI*******************************/
              List<String> pedDurumlar=new List.filled(11, "0.0");
              for (var i = 1; i <= 10; i++) {
                pedDurumlar[i]=xx[5].split("*")[i-1];
              }
              String otoPed=xx[1].split("*")[11];
              String fasilaPed=xx[5].split("*")[10];

              if(otoPed!=ped2DurumGecici){
                bloCVeriStateStreamControllerPED2.sink.add(otoPed);
              }
              ped2DurumGecici=otoPed;

              if(fasilaPed!=ped3DurumGecici){
                bloCVeriStateStreamControllerPED3.sink.add(fasilaPed);
                print("GİRİYORPED2");
              }
              ped3DurumGecici=fasilaPed;

              for (var i = 1; i < 25; i++) {
                if(pedNo[i]!="0" && pedDurumlar[int.parse(pedNo[i])]!=null){
                  
                  if(pedDurumlar[int.parse(pedNo[i])]!=pedDurumlarGecici[int.parse(pedNo[i])]){
                    bloCVeriStateStreamControllerPED[i].sink.add(pedDurumlar[int.parse(pedNo[i])]);
                    print("GİRİYORPED1");
                  }
                }
              }
              pedDurumlarGecici=List.from(pedDurumlar);
      //******************************PED DURUMLARI*******************************/



      //******************************SICAKLIKLAR*******************************/

              String setDeger=xx[6].split("*")[0];
              String ortDeger=xx[6].split("*")[1];
              String dbbDeger=xx[6].split("*")[2];
              String cbbDeger=xx[6].split("*")[3];
              String mod=xx[6].split("*")[4];

              if(setDeger!=setDegerGecici){
                bloCVeriStateStreamControllerSET.sink.add(setDeger);
              }
              setDegerGecici=setDeger;

              if(ortDeger!=ortDegerGecici){
                bloCVeriStateStreamControllerORT.sink.add(ortDeger);
              }
              ortDegerGecici=ortDeger;

              if(dbbDeger!=dbbDegerGecici){
                bloCVeriStateStreamControllerDBB.sink.add(dbbDeger);
              }
              dbbDegerGecici=dbbDeger;

              if(cbbDeger!=cbbDegerGecici){
                bloCVeriStateStreamControllerCBB.sink.add(cbbDeger);
              }
              cbbDegerGecici=cbbDeger;

              if(mod!=modGecici){
                bloCVeriStateStreamControllerMOD.sink.add(mod);
              }
              modGecici=mod;

      //******************************SICAKLIKLAR*******************************/


              print(veri);
              baglanti=false;

          }

            });

        sayac++;
        print(sayac);

        }
      });

    }

    timerSayac++;

    bloCVeriEventStreamControllerFAN[1].stream.listen((event) {
        timerCancel=true;
    });


  }


}
