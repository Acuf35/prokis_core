import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/kontrol/yrd_opsiyon.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x0.dart';
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';

class KlepeProbKontrol extends StatefulWidget {
  List<Map> gelenDBveri;
  KlepeProbKontrol(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KlepeProbKontrolState(gelenDBveri);
  }
}

class KlepeProbKontrolState extends State<KlepeProbKontrol> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String klepeAdet = "0";
  String isisensorAdet = "0";
  String disIsiSensorNo = "0";

  
  
  int _onlar = 0;
  int _birler = 0;
  int _ondalik= 0;
  int _index = 0;

  List<bool> probKontAktif = new List(11);
  List<String> sicaklikFarki = new List(11);
  List<String> sensorA = new List(11);
  List<String> sensorB = new List(11);


  String klpHareketSuresi="2.0";

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;
  bool takipEtiGeciciDurdur=false;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KlepeProbKontrolState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        isisensorAdet = dbVeri[i]["veri4"].split('#')[0];
      }

      if (dbVeri[i]["id"] == 37) {
        klepeAdet = dbVeri[i]["veri1"];
      }

    }

    

    for(int i=1; i<=10;i++){
      probKontAktif[i]=false;
      sicaklikFarki[i]="0.0";
      sensorA[i]="0";
      sensorB[i]="0";
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

    if (timerSayac == 0) {
      _takipEt("28*$klepeAdet");

      Timer.periodic(Duration(seconds: 2), (timer) {
        if(!takipEtiGeciciDurdur)
          yazmaSonrasiGecikmeSayaci++;

        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3 && !takipEtiGeciciDurdur) {
          baglanti = true;
          _takipEt("28*$klepeAdet");
        }
      });
    }

    timerSayac++;




//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv500'),
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
                Expanded(flex: 18,
                                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,1),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,2),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,3),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,4),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,5),
                            
                            
                           
                           
                          ],
                      ) 
                    ),
                    Container(height: 10*oran,),

                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,6),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,7),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,8),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,9),
                            _unsurProbKontrolAktifWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,10),
                            
                            
                            
                            
                            
                          ],
                      ) 
                    ),

                  
                   
],
    ),
                ),
                Spacer(flex: 2,)
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
                  MaterialPageRoute(builder: (context) => YrdOpsiyon(dbVeriler)),
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
                            dilSecimi, "tv483"), //Sıcaklık diyagramı
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
                    flex: 7,
                    child: DrawerHeader(
                      padding: EdgeInsets.only(left: 10),
                      margin: EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      "assets/images/diagram_klepe_prob_kontrol.jpg"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.grey[100],
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "A",
                                          style: TextStyle(fontSize: 11 * oran),
                                        ),
                                        Text(
                                          "A-X",
                                          style: TextStyle(fontSize: 11 * oran),
                                        ),
                                        Text(
                                          "K",
                                          style: TextStyle(fontSize: 11 * oran),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex:6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv115"),
                                          style: TextStyle(fontSize: 12 * oran),
                                        ),
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv504"),
                                          style: TextStyle(fontSize: 12 * oran),
                                        ),
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv505"),
                                          style: TextStyle(fontSize: 12 * oran),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
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
                              Dil().sec(dilSecimi, "info15"),
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

  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int index,
      double oran, String dil, String baslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(
            onlarUnsur, birlerUnsur, index, oran, dil, baslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (
          _onlar != val[0] ||
          _birler != val[1] ||
          _index != val[2]) {
          veriGonderilsinMi = true;
      }

      _onlar = val[0];
      _birler = val[1];
      _index = val[2];

      int deger=_onlar*10+_birler;

      if (deger>int.parse(isisensorAdet)){

        Toast.show(Dil().sec(dilSecimi, "toast83")+" $deger", context,duration: 3);

      }else if(deger==int.parse(disIsiSensorNo)){

        Toast.show(Dil().sec(dilSecimi, "toast84"), context,duration: 3);

      }else{
          String veri="";

          for (int i = 1; i <= 10; i++) {
            if(index==i+20) {
            sensorA[i]=(_onlar*10+_birler).toString();
            veri=sensorA[i];
            break;
            }

            if(index==i+30) {
            sensorB[i]=(_onlar*10+_birler).toString();
            veri=sensorB[i];
            break;
            }
          }

          if (veriGonderilsinMi) {
            yazmaSonrasiGecikmeSayaci = 0;
            _veriGonder("33*$index*$veri");
          }

          setState(() {});
      }



      

      


    });
  }


  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik, onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlar, birler, ondalik, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      String veri="";

      for (int i = 1; i <= 10; i++) {
        if(index==i+10) {
        sicaklikFarki[i]=(_onlar*10+_birler).toString()+'.'+_ondalik.toString();
        veri=sicaklikFarki[i];
        break;
        }
      }
        
      


      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("33*$index*$veri");
      }

      setState(() {});


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
              var degerler = gelenMesaj.split('#');
              var xx=degerler[0].split('*');
              var yy=degerler[1].split('*');
              var zz=degerler[2].split('*');
              var tt=degerler[3].split('*');
              disIsiSensorNo=degerler[4];
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              for (var i = 0; i <= int.parse(klepeAdet)-1; i++) {
                probKontAktif[i+1]=xx[i]=="True" ? true : false;
                sicaklikFarki[i+1]=yy[i];
                sensorA[i+1]=zz[i];
                sensorB[i+1]=tt[i];
              }

              

              


              socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;

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
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
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
            _takipEt("28*$klepeAdet");
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

  Widget _unsurProbKontrolAktifWidget(String baslik, String imagePath, double oran,int index) {
    return Visibility(visible: index<=int.parse(klepeAdet) || index>5,
          child: Expanded(
          child: Visibility(visible: index<=int.parse(klepeAdet),
                      child: Row(
      children: <Widget>[
        Spacer(),
        Expanded(flex: 10,
                      child: Column(
              children: <Widget>[
                Expanded(flex: 2,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    baslik+" $index",
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
                
                Expanded(flex: 3,
                        child: Column(
                        children: <Widget>[
                          //AKTİF PASİFn Seçimi
                          Expanded(flex: 6,
                            child: Row(
                              children: <Widget>[
                                //AKTİF
                                Expanded(flex: 10,
                                  child:  RawMaterialButton(
                                    padding: EdgeInsets.all(3*oran),
                                    elevation: 8,
                                    onPressed: (){

                                     
                                      yazmaSonrasiGecikmeSayaci=0;
                                      _veriGonder("33*$index*1");


                                      probKontAktif[index]=true;
                                    

                                      setState(() {
                                        
                                      });

                                    },
                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    fillColor: probKontAktif[index] ? Colors.green[400] : Colors.grey[400],
                                    child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv236"),
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
                                //PASİf
                                Expanded(flex: 10,
                                  child: RawMaterialButton(
                                    padding: EdgeInsets.all(3*oran),
                                    elevation: 8,
                                    onPressed: (){
                                      yazmaSonrasiGecikmeSayaci=0;
                                      _veriGonder("33*$index*0");

                                      probKontAktif[index]=false;

                                      setState(() {
                                        
                                      });
                                    },
                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    fillColor: !probKontAktif[index] ? Colors.green[400] : Colors.grey[400],
                                    child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv237"),
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
            
                Expanded(flex: 12,
                            child: Column(
                            children: <Widget>[
                              
                              Spacer(),
                              Expanded(flex: 24,
                              child: Visibility(visible: probKontAktif[index],


                                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(flex: 14,
                                                                                child: Column(
                                          children: <Widget>[
                                            Text(Dil().sec(dilSecimi, "tv501"),
                                            textScaleFactor: oran,
                                            style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                            
                                            ),
                                            Expanded(
                                                child:  RawMaterialButton(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  elevation: 8,
                                                  onPressed: (){

                                                  _index = index+10;
                                                  _onlar = int.parse(
                                                              sicaklikFarki[index].split(".")[0]) <
                                                          10
                                                      ? 0
                                                      : (int.parse(
                                                              sicaklikFarki[index].split(".")[0]) ~/
                                                          10);
                                                  _birler =
                                                      int.parse(sicaklikFarki[index].split(".")[0]) %
                                                          10;
                                                  _ondalik =
                                                      int.parse(sicaklikFarki[index].split(".")[1]);
          
                                                  _degergiris2X1(
                                                      _onlar,
                                                      _birler,
                                                      _ondalik,
                                                      _index,
                                                      oran,
                                                      dilSecimi,
                                                      "tv501",
                                                      "");

                                                  },
                                                  materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                                  constraints: BoxConstraints(),
                                                  fillColor: Colors.cyan[700],
                                                  child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    sicaklikFarki[index],
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
                              
                                          ],
                                        ),
                                      ),
                                      Spacer(flex: 2,),

                                      Expanded(flex: 13,
                                        child: 
                                      
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[

                                            Expanded(flex: 10,
                                                                                                    child: Column(
                                                    children: <Widget>[
                                                      Text(Dil().sec(dilSecimi, "tv502"),textScaleFactor: oran,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                      Expanded(
                                                  child:  RawMaterialButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    elevation: 8,
                                                    onPressed: (){

                                                      _index =index+20;
                                                        int sayi=int.parse(sensorA[index]);
                                                        _onlar=sayi<10 ? 0 : sayi~/10;
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv502",);

                                                    

                                                    },
                                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                                    constraints: BoxConstraints(),
                                                    fillColor: Colors.brown[500],
                                                    child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      sensorA[index],
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
                              
                                                    ],
                                                  ),
                                                ),
                                            Spacer(),
                                            Expanded(flex: 10,
                                                                                            child: Column(
                                                children: <Widget>[
                                                  Text("Sens. No2",textScaleFactor: oran,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                  Expanded(
                                                  child:  RawMaterialButton(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    elevation: 8,
                                                    onPressed: (){

                                                    _index =index+30;
                                                        int sayi=int.parse(sensorB[index]);
                                                        _onlar=sayi<10 ? 0 : sayi~/10;
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv503",);

                                                    },
                                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                                    constraints: BoxConstraints(),
                                                    fillColor: Colors.brown[500],
                                                    child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      sensorB[index],
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
                              ],
                                              ),
                                            ),

                                              ],
                                            ),
                                          
                                      )
                                    ],
                                  )
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
          ),
        ),
    );
  
  }

 




//--------------------------METOTLAR--------------------------------

}
