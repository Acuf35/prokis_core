



import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prokis/genel_ayarlar/izleme.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:timer_builder/timer_builder.dart';

class IzlemeTemelFKSP extends StatefulWidget {
  List<Map> gelenDBveri;
  IzlemeTemelFKSP(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  _IzlemeTemelFKSPState createState() => _IzlemeTemelFKSPState(gelenDBveri);
}

class _IzlemeTemelFKSPState extends State<IzlemeTemelFKSP> with TickerProviderStateMixin{


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

  List<bool> fanDurum = new List.filled(121,false);

  AnimationController _controller1;
  AnimationController _controller2;

  bool otoFan=false;

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  String initialVeri="1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*1*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*"
"0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*0*#4*0*0.0*0*158*142*23.0*27.5*24.0*26.0*0*0*0*0*0*0*0#100.0*63.5*63.5*0."
"0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*0.0*1*0*0*0*0*0*0*0*0*0*#1*1*1*1*0*0*0*0*0*0*0*1*1*1*0*1*0*0*#0.0*0.0";


  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  _IzlemeTemelFKSPState(List<Map> dbVeri) {
    dbVeriler=dbVeri;
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

  }
//--------------------------CONSTRUCTER METHOD--------------------------------



  @override
  Widget build(BuildContext context) {

    oran = MediaQuery.of(context).size.width / 731.4;
    final _blocSinif = IzlemeTemelFKSPBloC();

    
    if (timerSayac == 0) {
      Metotlar().takipEt("1*60", context, 2237, dilSecimi).then((veri){
        _blocSinif.bloCVeriEventSink.add(veri);
        print(veri);
      });

      Timer.periodic(Duration(seconds: 5), (timer) {
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti) {
          baglanti = true;
          Metotlar().takipEt("1*60", context, 2237, dilSecimi).then((veri){
          _blocSinif.bloCVeriEventSink.add(veri);
          print(veri);
          baglanti = false;
          });
        }
      });
    }

    timerSayac++;

    

    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 1000),);
    _controller2 = AnimationController(vsync: this,duration: Duration(milliseconds: 1000),);
    //
    _controller1.repeat();
    _controller2.stop();
    //print("object");

    return StreamBuilder(
      initialData: initialVeri,
      stream: _blocSinif.bloCVeri,
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
                  timerCancel=true;
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
              child: Row(
                children: <Widget>[
                  //Tünel Fanları-BFan-AirInlet-Isıtıcı-SirkFan-Sıcaklıklar- MOD
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
                        ),
                 
                        //Aktfi Mod | Air inlet - Bacafan - Isıtıcı - Sıcaklıklar
                        Spacer(flex: 2,)
                        
                        
                        ],
                    ),
                  ),
                  //Diğer unsurlar bölümü
                  Spacer(flex: 7,)
                ],
              ),
            )
          ],
        ));
  
      });
  
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





}


class IzlemeTemelFKSPBloC {

  String veri="";


  //state için stream controller
  final _bloCVeriStateStreamController = StreamController<String>();
  Stream<String> get bloCVeri => _bloCVeriStateStreamController.stream;
  StreamSink<String> get _bloCVeriStateSink => _bloCVeriStateStreamController.sink;

  //eventler için stream controller
  final _bloCVeriEventStreamController = StreamController<String>();
  Stream<String> get _bloCVeriEventStream =>
      _bloCVeriEventStreamController.stream;
  StreamSink<String> get bloCVeriEventSink =>
      _bloCVeriEventStreamController.sink;

  IzlemeTemelFKSPBloC() {

    _bloCVeriEventStream.listen((event) {
      
      _bloCVeriStateSink.add(event);

    });
  }
}
