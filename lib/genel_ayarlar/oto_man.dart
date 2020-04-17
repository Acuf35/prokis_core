import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/oto_man_air.dart';
import 'package:prokis/otoman/oto_man_klepe.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';

class OtoMan extends StatefulWidget {
  List<Map> gelenDBveri;
  OtoMan(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return OtoManState(gelenDBveri);
  }
}

class OtoManState extends State<OtoMan> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String fanAdet = "0";
  String pedAdet = "0";
  String bacafanAdet = "0";
  String isiticiAdet = "0";
  int yemUnsurAdet = 0;
  String dimmer = "0";
  String manuelAydinlikYuzdesi = "50";

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  bool yem1Aktif = false;
  bool yem2Aktif = false;
  bool yem3Aktif = false;

  bool otoTFAN=false;
  bool otoBFAN=false;
  bool otoPEDM=false;
  bool otoAIRI=false;
  bool otoKLPE=false;
  bool otoISTC=false;
  bool otoYEMA=false;
  bool otoAYDL=false;

  List<bool> fanMan = new List(61);
  List<bool> pedMan = new List(11);
  List<bool> aydMan = new List(2);
  List<bool> bfaMan = new List(4);
  List<bool> istMan = new List(4);
  List<bool> yemMan = new List(7);

  bool timerCancel = false;
  bool timerCancelFan = false;
  bool timerCancelPed = false;
  bool timerCancelAyd = false;
  bool timerCancelBfa = false;
  bool timerCancelIst = false;
  bool timerCancelYml = false;
  int timerSayac = 0;
  bool baglanti = false;
  bool baglantiFan = false;
  bool baglantiPed = false;
  bool baglantiAyd = false;
  bool baglantiBfa = false;
  bool baglantiIst = false;
  bool baglantiYml = false;

  int yazmaSonrasiGecikmeSayaci = 4;
  int yazmaSonrasiGecikmeSayaciTFAN = 8;
  int yazmaSonrasiGecikmeSayaciPED = 8;
  int yazmaSonrasiGecikmeSayaciAYD = 8;
  int yazmaSonrasiGecikmeSayaciBFAN = 8;
  int yazmaSonrasiGecikmeSayaciISTC = 8;
  int yazmaSonrasiGecikmeSayaciYEML = 8;
  bool takipEtiGeciciDurdur=false;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  OtoManState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        fanAdet = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        pedAdet = dbVeri[i]["veri3"];
      }

      if (dbVeri[i]["id"] == 5) {
        var xx=dbVeri[i]["veri1"].split('#'); 
        bacafanAdet = xx[0];
        isiticiAdet = dbVeri[i]["veri3"];
      }

      if (dbVeri[i]["id"] == 31) {
        dimmer = dbVeri[i]["veri4"];
        String xx=dbVeri[i]["veri3"];
        yem1Aktif = xx.split("#")[0]=="1" ? true : false;
        yem2Aktif = xx.split("#")[1]=="1" ? true : false;
        yem3Aktif = xx.split("#")[2]=="1" ? true : false;
      }


    }

    for(int i=1; i<=60;i++){
      fanMan[i]=false;
    }

    for(int i=1; i<=10;i++){
      pedMan[i]=false;
    }

    aydMan[0]=false;
    aydMan[1]=false;

    for(int i=1; i<=3;i++){
      bfaMan[i]=false;
      istMan[i]=false;
    }

    for(int i=1; i<=6;i++){
      yemMan[i]=false;
    }

    if(yem1Aktif){
      yemUnsurAdet=yemUnsurAdet+2;
    }
    if(yem2Aktif){
      yemUnsurAdet=yemUnsurAdet+2;
    }
    if(yem3Aktif){
      yemUnsurAdet=yemUnsurAdet+2;
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

    if (timerSayac == 0) {
      _takipEt('16*');

      Timer.periodic(Duration(seconds: 2), (timer) {
        if(!takipEtiGeciciDurdur)
          yazmaSonrasiGecikmeSayaci++;

        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3 && !takipEtiGeciciDurdur) {
          baglanti = true;
          _takipEt("16*");
        }
      });
    }

    timerSayac++;




//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv454'),
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
                        child: Container(color: Colors.white,
                          child: Row(
              children: <Widget>[
                Expanded(flex: 30,
                                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv458"),'assets/images/kurulum_fan_icon.png',oran,otoTFAN,1),
                            _unsurOtoManWidgetKlepeAir(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,otoKLPE,2),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv459"),'assets/images/kurulum_ped_icon.png',oran,otoPEDM,3),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv112"),'assets/images/kurulum_aydinlatma_icon1.png',oran,otoAYDL,4),
                          ],
                      ) 
                    ),
                    Container(height: 10*oran,),

                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv461"),'assets/images/kurulum_bacafan_icon.png',oran,otoBFAN,6),
                            _unsurOtoManWidgetKlepeAir(Dil().sec(dilSecimi, "tv460"),'assets/images/kurulum_airinlet_icon.png',oran,otoAIRI,5),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv462"),'assets/images/kurulum_isitici_icon.png',oran,otoISTC,7),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv463"),'assets/images/kurulum_yemleme_icon.png',oran,otoYEMA,8),
                          ],
                      ) 
                    ),

                  
                   
],
    ),
                ),
                Spacer()
              ],
            ),
                        ),
          ),
        ],
      ),  
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
          child: FittedBox(
                      child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GenelAyarlar(dbVeriler)),
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
                            dilSecimi, "tv81"), //Sıcaklık diyagramı
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
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          ListTile(
                            dense: false,
                            title: Text(Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                            subtitle: Text(
                              Dil().sec(dilSecimi, "info16_1"),
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
        )
        
    );
      
        

//--------------------------SCAFFOLD--------------------------------
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

  _takipEt(String komut) async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {
        socket.add(utf8.encode(komut));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);
              //print(yazmaSonrasiGecikmeSayaciTFAN);
              //print(yazmaSonrasiGecikmeSayaciPED);
              print(yazmaSonrasiGecikmeSayaciAYD);

              if(komut.split("*")[0]=="16"){
                otoTFAN=degerler[0]=="True" ? true : false;
                otoPEDM=degerler[1]=="True" ? true : false;
                otoAYDL=degerler[2]=="True" ? true : false;
                otoBFAN=degerler[3]=="True" ? true : false;
                otoISTC=degerler[4]=="True" ? true : false;
                otoYEMA=degerler[5]=="True" ? true : false;
              }

              if(komut.split("*")[0]=="17"){
                for(int i=1;i<=int.parse(fanAdet);i++){
                  fanMan[i]=degerler[i-1]=="True" ? true : false;
                }
              }

              if(komut.split("*")[0]=="18"){
                for(int i=1;i<=int.parse(pedAdet);i++){
                  pedMan[i]=degerler[i-1]=="True" ? true : false;
                }
              }

              if(komut.split("*")[0]=="19"){
                manuelAydinlikYuzdesi=degerler[0];
                aydMan[1]=degerler[1]=="True" ? true : false;
              }

              if(komut.split("*")[0]=="20"){
                for(int i=1;i<=int.parse(bacafanAdet);i++){
                  bfaMan[i]=degerler[i-1]=="True" ? true : false;
                }
              }

              if(komut.split("*")[0]=="21"){
                for(int i=1;i<=int.parse(isiticiAdet);i++){
                  istMan[i]=degerler[i-1]=="True" ? true : false;
                }
              }

              if(komut.split("*")[0]=="22"){
                if(yem1Aktif){
                  yemMan[1]=degerler[0]=="True" ? true : false;
                  yemMan[4]=degerler[3]=="True" ? true : false;
                }
                if(yem2Aktif){
                  yemMan[2]=degerler[1]=="True" ? true : false;
                  yemMan[5]=degerler[4]=="True" ? true : false;
                }
                if(yem3Aktif){
                  yemMan[3]=degerler[2]=="True" ? true : false;
                  yemMan[6]=degerler[5]=="True" ? true : false;
                }
              }

              socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            baglantiFan = false;
            baglantiPed = false;
            baglantiAyd = false;
            baglantiBfa = false;
            baglantiIst = false;
            baglantiYml = false;
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
        baglantiFan = false;
        baglantiPed = false;
        baglantiAyd = false;
        baglantiBfa = false;
        baglantiIst = false;
        baglantiYml = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
      baglantiFan = false;
      baglantiPed = false;
      baglantiAyd = false;
      baglantiBfa = false;
      baglantiIst = false;
      baglantiYml = false;
    }
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
              Toast.show(
                  Dil().sec(dilSecimi, "toast8"), context,
                  duration: 2);
            } else {
              Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if(emir.split("*")[0]=='20')
              _takipEt("16*");
            if(emir.split("*")[0]=='21')
              _takipEt("17*$fanAdet");
            if(emir.split("*")[0]=='22')
              _takipEt("18*$pedAdet");
            if(emir.split("*")[0]=='23')
              _takipEt("19*");
            if(emir.split("*")[0]=='24')
              _takipEt("20*$bacafanAdet");
            if(emir.split("*")[0]=='25')
              _takipEt("21*$isiticiAdet");
            if(emir.split("*")[0]=='26')
              _takipEt("22*");


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
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  Widget _unsurOtoManWidget(String baslik, String imagePath, double oran, bool otomanDurum,int index) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Spacer(),
          Expanded(flex: 10,
                      child: Column(
              children: <Widget>[
                Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    baslik,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        color: Colors.grey[500],
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                
                Expanded(
                        child: Column(
                        children: <Widget>[
                          //Oto Man Seçimi
                          Expanded(flex: 6,
                            child: Row(
                              children: <Widget>[
                                //Oto
                                Expanded(flex: 10,
                                  child:  RawMaterialButton(
                                    elevation: 8,
                                    onPressed: (){

                                     
                                      yazmaSonrasiGecikmeSayaci=0;
                                      _veriGonder("20*$index*1");

                                      if(index==1){
                                        otoTFAN=true;
                                        for(int i=1;i<=int.parse(fanAdet);i++){
                                          fanMan[i]=false;
                                        }
                                      }else if(index==3){
                                        otoPEDM=true;
                                        for(int i=1;i<=int.parse(pedAdet);i++){
                                          pedMan[i]=false;
                                        }
                                      }else if(index==4){
                                        otoAYDL=true;
                                        aydMan[1]=false;
                                      }else if(index==6){
                                        otoBFAN=true;
                                        for(int i=1;i<=int.parse(bacafanAdet);i++){
                                         bfaMan[i]=false;
                                        }
                                      }else if(index==7){
                                        otoISTC=true;
                                        for(int i=1;i<=int.parse(isiticiAdet);i++){
                                          istMan[i]=false;
                                        }
                                      }else if(index==8){
                                        otoYEMA=true;
                                        for(int i=1;i<=6;i++){
                                          yemMan[i]=false;
                                        }
                                      }

                                      setState(() {
                                        
                                      });

                                    },
                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    fillColor: otomanDurum ? Colors.green[400] : Colors.grey[400],
                                    child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv455"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                              ),
                            
                                    )),
                                Spacer(),
                                //MAN
                                Expanded(flex: 10,
                                  child: RawMaterialButton(
                                    elevation: 8,
                                    onPressed: (){
                                      yazmaSonrasiGecikmeSayaci=0;
                                      _veriGonder("20*$index*0");

                                      if(index==1){
                                        otoTFAN=false;
                                      }else if(index==3){
                                        otoPEDM=false;
                                      }else if(index==4){
                                        otoAYDL=false;
                                      }else if(index==6){
                                        otoBFAN=false;
                                      }else if(index==7){
                                        otoISTC=false;
                                      }else if(index==8){
                                        otoYEMA=false;
                                      }

                                      setState(() {
                                        
                                      });
                                    },
                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    fillColor: !otomanDurum ? Colors.green[400] : Colors.grey[400],
                                    child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv456"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                              ),
                            
                                    )),
                                Spacer(),
                          
                          ],)),
                          
                      ],)),
            
                Expanded(flex: 4,
                            child: Column(
                            children: <Widget>[
                              
                              Spacer(),
                              Expanded(flex: 24,
                              child: Visibility(visible: !otomanDurum,
                                  child: RawMaterialButton(
                                    onPressed: (){


                                      takipEtiGeciciDurdur=true;

                                      if(index==1){
                                        timerCancelFan=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciTFAN++;
                                            if (timerCancelFan) {
                                              timer.cancel();
                                            }
                                            if(!baglantiFan && yazmaSonrasiGecikmeSayaciTFAN>7){
                                              baglantiFan=true;
                                              _takipEt("17*$fanAdet");
                                            }
                                            
                                          });

                                          _manKontrolTFAN(oran,index).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelFan=true;
                                        });
                                      }else if(index==3){
                                        timerCancelPed=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciPED++;
                                            if (timerCancelPed) {
                                              timer.cancel();
                                            }
                                            if(!baglantiPed && yazmaSonrasiGecikmeSayaciPED>7){
                                              baglantiPed=true;
                                              _takipEt("18*$pedAdet");
                                            }
                                            
                                          });

                                          _manKontrolPED(oran,index).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelPed=true;
                                        });
                                      }else if(index==4){
                                        timerCancelAyd=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciAYD++;
                                            if (timerCancelAyd) {
                                              timer.cancel();
                                            }
                                            if(!baglantiAyd && yazmaSonrasiGecikmeSayaciAYD>7){
                                              baglantiAyd=true;
                                              _takipEt("19*");
                                            }
                                            
                                          });

                                          _manKontrolAYD(oran,index).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelAyd=true;
                                        });
                                      }
                                      
                                      else if(index==6){
                                        timerCancelBfa=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciBFAN++;
                                            if (timerCancelBfa) {
                                              timer.cancel();
                                            }
                                            if(!baglantiBfa && yazmaSonrasiGecikmeSayaciBFAN>7){
                                              baglantiAyd=true;
                                              _takipEt("20*$bacafanAdet");
                                            }
                                            
                                          });

                                          _manKontrolBFAN(oran,index).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelBfa=true;
                                        });
                                          }

                                        
                                      else if(index==7){
                                        timerCancelIst=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciISTC++;
                                            if (timerCancelIst) {
                                              timer.cancel();
                                            }
                                            if(!baglantiIst && yazmaSonrasiGecikmeSayaciISTC>7){
                                              baglantiIst=true;
                                              _takipEt("21*");
                                            }
                                            
                                          });

                                          _manKontrolISTC(oran,index).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelIst=true;
                                        });
                                      }
                                      
                                      
                                      else if(index==8){
                                        timerCancelYml=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciYEML++;
                                            if (timerCancelYml) {
                                              timer.cancel();
                                            }
                                            if(!baglantiYml && yazmaSonrasiGecikmeSayaciYEML>7){
                                              baglantiYml=true;
                                              _takipEt("22*");
                                            }
                                            
                                          });

                                          _manKontrolYEML(oran,index).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelYml=true;
                                        });
                                      }
                                      



                                    },
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    elevation: 8,
                                    child: Column(
                                      children: <Widget>[
                                      Expanded(
                                                            child: Container(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi, "tv457"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Kelly Slab',
                                      color: Colors.green,
                                      fontSize: 50,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                                      ),
                                      
                                      Expanded(
                                        flex: 4,
                                      child: Row(
                                        children: <Widget>[
                                          Spacer(),
                                          Expanded(flex: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  alignment: Alignment.center,
                                                  image: AssetImage(imagePath),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                    ),
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                      ),
                                      
  
                                    ],
                                      ),
                                    ),
                                ),
                              ),
                              Spacer(),
                            ],),
                ),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  
  }

  Widget _unsurOtoManWidgetKlepeAir(String baslik, String imagePath, double oran, bool otomanDurum,int index) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Spacer(),
          Expanded(flex: 10,
                      child: Column(
              children: <Widget>[
                Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    baslik,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        color: Colors.grey[500],
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                
                Expanded(flex: 5,
                        child: Column(
                        children: <Widget>[
                          //Oto Man Seçimi
                          Expanded(
                            child:  RawMaterialButton(
                              elevation: 8,
                              onPressed: (){
                                if(index==2){
                                  timerCancel=true;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtoManKlepe(dbVeriler)),
                                    );
                                }

                                if(index==5){
                                  timerCancel=true;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtoManAir(dbVeriler)),
                                    );
                                }

                              },
                              materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                              constraints: BoxConstraints(),
                              fillColor: Colors.blue[700],
                              child: SizedBox(
                            child: Container(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                Dil().sec(dilSecimi, "tv101"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Kelly Slab',
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                minFontSize: 8,
                              ),
                            ),
                            ),
                          
                              )),
                          Spacer()
                      ],)),
            
                ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  
  }
 
  Future _manKontrolTFAN(double oran, int index){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv464"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", fanMan[1], oran,1,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", fanMan[2], oran,2,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", fanMan[3], oran,3,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", fanMan[4], oran,4,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", fanMan[5], oran,5,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[6], oran,6,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[7], oran,7,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[8], oran,8,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[9], oran,9,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" ,  fanMan[10], oran,10,fanAdet),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[11] , oran,11,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[12] , oran,12,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[13] , oran,13,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[14] , oran,14,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[15] , oran,15,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[16] , oran,16,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[17] , oran,17,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[18] , oran,18,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[19] , oran,19,fanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , fanMan[20] , oran,20,fanAdet),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>20,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[21], oran,21,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[22], oran,22,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[23], oran,23,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[24], oran,24,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[25], oran,25,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[26], oran,26,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[27], oran,27,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[28], oran,28,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[29], oran,29,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[30], oran,30,fanAdet),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>30,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[31], oran,31,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[32], oran,32,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[33], oran,33,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[34], oran,34,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[35], oran,35,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[36], oran,36,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[37], oran,37,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[38], oran,38,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[39], oran,39,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[40], oran,40,fanAdet),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>40,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[41], oran,41,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[42], oran,42,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[43], oran,43,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[44], oran,44,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[45], oran,45,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[46], oran,46,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[47], oran,47,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[48], oran,48,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[49], oran,49,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[50], oran,50,fanAdet),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>50,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[51], oran,51,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[52], oran,52,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[53], oran,53,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[54], oran,54,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[55], oran,55,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[56], oran,56,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[57], oran,57,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[58], oran,58,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[59], oran,59,fanAdet),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , fanMan[60], oran,60,fanAdet),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolPED(double oran,int index){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv465"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[1] , oran,1,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[2] , oran,2,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[3] , oran,3,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[4] , oran,4,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[5] , oran,5,pedAdet),
                                                                          
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[6], oran,6,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[7], oran,7,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[8], oran,8,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[9], oran,9,pedAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", pedMan[10] , oran,10,pedAdet),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolAYD(double oran,int index){

    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv466"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Visibility(visible: dimmer=="1",
                                                                        child: Text(
                                                                          Dil().sec(dilSecimi, "tv470"),
                                                                          textScaleFactor: oran,
                                                                          style: TextStyle(
                                                                            fontFamily: 'Kelly Slab',
                                                                            fontWeight: FontWeight.bold,

                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(height: 5*oran,),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(flex: 3,),
                                                                          Visibility(visible: dimmer!="1",
                                                                            child: bottomDrawerManUnsur(index ,"tv112", aydMan[1] , oran,1,"1")
                                                                            ),

                                                                          Visibility(visible: dimmer=="1",
                                                                            child: Expanded(
                                                                            child: RawMaterialButton(
                                                                              onPressed: () {
                                                                                _index = 13;
                                                                                int sayi=int.parse(manuelAydinlikYuzdesi);
                                                                                _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                                _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                                _birler=sayi%10;

                                                                                _degergiris3X0(
                                                                                    _yuzler,
                                                                                    _onlar,
                                                                                    _birler,
                                                                                    _index,
                                                                                    oran,
                                                                                    dilSecimi,
                                                                                    "tv340",
                                                                                    "");
                                                                              },
                                                                              child: Container(
                                                                                color: Colors.blue[700],
                                                                                padding: EdgeInsets.only(top: 5*oran,bottom: 5*oran),
                                                                                child: Text(
                                                                                  manuelAydinlikYuzdesi,
                                                                                  textScaleFactor: oran,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Kelly Slab',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 20,
                                                                                    color: Colors.white
                                                                                  ),
                                                                                  ),
                                                                              ),
                                                                              fillColor: Colors.blue[700],
                                                                              elevation: 16,
                                                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                              constraints: BoxConstraints(),
                                                                              
                                                                              ),
                                                                        ),
                                                                          ),
                                              
                                                                          Spacer(flex: 3,),
                                                                          
                                                                          //Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolBFAN(double oran,int index){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv467"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(flex: 11,),
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[1] , oran,1,bacafanAdet),
                                                                          Spacer(flex: 11,),
                                                                          /*
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[2] , oran,2,bacafanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[3] , oran,3,bacafanAdet),
                                                                          Spacer(),
                                                                          */
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolISTC(double oran,int index){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv468"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv80", istMan[1] , oran,1,isiticiAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv80", istMan[2] , oran,2,isiticiAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv80", istMan[3] , oran,3,isiticiAdet),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolYEML(double oran,int index){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv469"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv89", yemMan[1] , oran,1,yemUnsurAdet.toString()),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv92", yemMan[4] , oran,4,yemUnsurAdet.toString()),
                                                                          Spacer(),
                                                                        ],
                                                                      ),

                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv90", yemMan[2] , oran,2,yemUnsurAdet.toString()),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv93", yemMan[5] , oran,5,yemUnsurAdet.toString()),
                                                                          Spacer(),
                                                                        ],
                                                                      ),

                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv91", yemMan[3] , oran,3,yemUnsurAdet.toString()),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv94", yemMan[6] , oran,6,yemUnsurAdet.toString()),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }


  Widget bottomDrawerManUnsur(int index, String isim, bool otoManDurum,double oran, int unsurNo, String adet){

    return Expanded(flex: 10,
      child: Visibility(visible: int.parse(adet)>=unsurNo, maintainAnimation: true,maintainState: true,maintainSize: true,
              child: RawMaterialButton(
    fillColor: otoManDurum ? Colors.green[700] : Colors.grey[500],
    elevation: 8,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    constraints: BoxConstraints(),
             onPressed: (){


               String veri="0";

              if(index==1){
                    if(otoManDurum){
                    veri="0";
                    fanMan[unsurNo]=false;
                  }else{
                    veri="1";
                    fanMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciTFAN=0;
                _veriGonder("21*$unsurNo*$veri");
              }

              if(index==3){
                    if(otoManDurum){
                    veri="0";
                    pedMan[unsurNo]=false;
                  }else{
                    veri="1";
                    pedMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciPED=0;
                _veriGonder("22*$unsurNo*$veri");
              }

              if(index==4){
                    if(otoManDurum){
                    veri="0";
                    aydMan[unsurNo]=false;
                  }else{
                    veri="1";
                    aydMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciAYD=0;
                _veriGonder("23*$unsurNo*$veri");
              }

              if(index==6){
                    if(otoManDurum){
                    veri="0";
                    bfaMan[unsurNo]=false;
                  }else{
                    veri="1";
                    bfaMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciBFAN=0;
                _veriGonder("24*$unsurNo*$veri");
              }


              if(index==7){
                    if(otoManDurum){
                    veri="0";
                    istMan[unsurNo]=false;
                  }else{
                    veri="1";
                    istMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciISTC=0;
                _veriGonder("25*$unsurNo*$veri");
              }

              if(index==8){
                    if(otoManDurum){
                    veri="0";
                    yemMan[unsurNo]=false;
                  }else{
                    veri="1";
                    yemMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciYEML=0;
                _veriGonder("26*$unsurNo*$veri");
              }
                      

             },
             child: Container(padding: EdgeInsets.only(top: 5*oran,bottom: 5*oran),
               child: Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(Dil().sec(dilSecimi, isim)+(index==4 || index==8 || index==6 ? "" : " $unsurNo"),style: TextStyle(fontFamily: "Kelly Slab",
                   color: otoManDurum ? Colors.white : Colors.black ,
                   fontWeight: FontWeight.bold,
                   fontSize: 16),
                   textScaleFactor: oran,),
                   
                  
                 ],
               ),
             ),
           ),
      ),
      );

  }

  Future _degergiris3X0(int yuzler , onlar , birler, index, double oran,
      String dil, baslik, onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris3X0.Deger(
            yuzler,onlar, birler, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_yuzler != val[0] ||
          _onlar != val[1] ||
          _birler != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _yuzler = val[0];
      _onlar = val[1];
      _birler = val[2];
      _index = val[3];


      String veri = '';

      if (index == 13) {
        manuelAydinlikYuzdesi=(_yuzler*100+_onlar*10+_birler).toString();
        veri = manuelAydinlikYuzdesi;
      }


      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaciYEML= 0;
        _veriGonder("15*$_index*$veri");
      }

      setState(() {});
    });
  }



  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }



//--------------------------METOTLAR--------------------------------

}
