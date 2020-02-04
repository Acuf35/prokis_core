import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel/metotlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x1.dart';
import 'languages/select.dart';

class Isitma extends StatefulWidget {
  List<Map> gelenDBveri;
  Isitma(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return IsitmaState(gelenDBveri);
  }
}

class IsitmaState extends State<Isitma> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String isiticiAdet = "0";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  
  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  List<String> calismaSicakligi = new List(4);
  List<String> calismaSicakligifark = new List(4);
  List<String> durmaSicakligi = new List(4);
  List<String> durmaSicakligiFark = new List(4);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IsitmaState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 4) {
        isiticiAdet = dbVeri[i]["veri3"];
      }
    }

    for (int i = 1; i <= 3; i++) {
      calismaSicakligi[i] = "0.0";
      calismaSicakligifark[i] = "0.0";
      durmaSicakligi[i] = "0.0";
      durmaSicakligiFark[i] = "0.0";
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      _takipEt();

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          _takipEt();
        }
      });
    }

    timerSayac++;

    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30 * oran),
          child: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 40 * oran,
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
              actions: [
                Row(
                  children: <Widget>[
                    Builder(
                      builder: (context) => IconButton(
                        color: Colors.yellow[700],
                        iconSize: 40 * oran,
                        icon: Icon(Icons.info_outline),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      ),
                    ),
                  ],
                ),
              ],
              primary: false,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                Dil().sec(dilSecimi, "tv263"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * oran,
                    fontFamily: 'Kelly Slab',
                    fontWeight: FontWeight.bold),
              )),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 10 * oran),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Spacer(flex: 3,),
                    Expanded(flex: 10,
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Expanded(flex: 5,child: Column(
                                  children: <Widget>[
                                    Spacer(flex: 1,),
                                    Expanded(flex:3,child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv245"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.red[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 60,),
                                              maxLines: 1,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),),
                                                                      ],
                                ),),
                                Expanded(flex: 6,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                                                              child: SizedBox(
                                          child: Container(color: Colors.grey[300],
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv268"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.black,
                                                  fontSize: 60,),
                                              maxLines: 1,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 4,
                                      child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv246"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.cyan[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 60,),
                                              maxLines: 1,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                                                              child: SizedBox(
                                          child: Container(color: Colors.grey[300],
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv269"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.black,
                                                  fontSize: 60,),
                                              maxLines: 1,
                                              minFontSize: 8,
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
                          Visibility(visible: int.parse(isiticiAdet)>0,child: _klepeKlasikUnsur(oran, 1)),
                          Visibility(visible: int.parse(isiticiAdet)>1,child: _klepeKlasikUnsur(oran, 2)),
                          Visibility(visible: int.parse(isiticiAdet)>2,child: _klepeKlasikUnsur(oran, 3)),
                          Spacer()
                        ],
                      ),
                    ),
                    Spacer(flex: 5,),
                    ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            timerCancel = true;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Kontrol(dbVeriler)),
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.arrow_back,
            size: 50,
            color: Colors.white,
          ),
        ),
        drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
        endDrawer: Drawer(
        child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  Dil()
                      .sec(dilSecimi, "tv264"), //Sıcaklık diyagramı
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
                padding: EdgeInsets.zero,
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage('assets/images/diagram_isitma.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    
                    Expanded(
                      flex: 4,
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
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("A",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("B",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("C",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("A-B",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("A-C",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("D",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("E",style: TextStyle(fontSize: 11*oran),))),
                                  Expanded(child: Container(alignment: Alignment.centerRight,child: Text("F",style: TextStyle(fontSize: 11*oran),))),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(alignment: Alignment.centerLeft,
                                      child: Text(" : " +Dil().sec(dilSecimi, "tv115"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),
                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv247"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),
                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv248"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),
                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv254"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),
                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv255"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),
                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv265"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),
                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv266"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
                                  ),

                                  Expanded(
                                                                      child: Container(alignment: Alignment.centerLeft,
                                                                        child: Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv267"),style: TextStyle(fontSize: 11*oran),
                                    ),
                                                                      ),
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
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      dense: false,
                      title: Text(Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                      subtitle: Text(
                        Dil().sec(dilSecimi, "info11"),
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
    )
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

  Future _degergiris2X1(int onlarUnsur, int birlerUnsur,int ondalikUnsur, int isiticiIndex,
      double oran, String dil, String baslik,String onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlarUnsur, birlerUnsur,ondalikUnsur, isiticiIndex, oran, dil, baslik,onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (
          _onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
          veriGonderilsinMi = true;
      }

      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      String veri='';


          if (_index == 1) {
            calismaSicakligifark[_index] = (_onlar == 0 ? "" : _onlar.toString()) +
                _birler.toString() +
                "." +
                _ondalik.toString();
                veri=calismaSicakligifark[_index];
          }

      
          if (_index == 2) {
            calismaSicakligifark[_index] = (_onlar == 0 ? "" : _onlar.toString()) +
                _birler.toString() +
                "." +
                _ondalik.toString();
                veri=calismaSicakligifark[_index];
          }

        
          if (_index == 3) {
            calismaSicakligifark[_index] = (_onlar == 0 ? "" : _onlar.toString()) +
                _birler.toString() +
                "." +
                _ondalik.toString();
                veri=calismaSicakligifark[_index];
          }



      
          if (_index == 4) {
            durmaSicakligiFark[_index-3] = (_onlar == 0 ? "" : _onlar.toString()) +
                _birler.toString() +
                "." +
                _ondalik.toString();
                veri=durmaSicakligiFark[_index-3];
          }

      
          if (_index == 5) {
            durmaSicakligiFark[_index-3] = (_onlar == 0 ? "" : _onlar.toString()) +
                _birler.toString() +
                "." +
                _ondalik.toString();
                veri=durmaSicakligiFark[_index-3];
          }

        
          if (_index == 6) {
            durmaSicakligiFark[_index-3] = (_onlar == 0 ? "" : _onlar.toString()) +
                _birler.toString() +
                "." +
                _ondalik.toString();
                veri=durmaSicakligiFark[_index-3];
          }
      


      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("11*$_index*$veri");
      }


    });
  }


  
  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
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
            _takipEt();
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

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {
        socket.add(utf8.encode('10*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              calismaSicakligifark[1]=degerler[0];
              calismaSicakligifark[2]=degerler[1];
              calismaSicakligifark[3]=degerler[2];
              durmaSicakligiFark[1]=degerler[3];
              durmaSicakligiFark[2]=degerler[4];
              durmaSicakligiFark[3]=degerler[5];

              calismaSicakligi[1]=degerler[6];
              calismaSicakligi[2]=degerler[7];
              calismaSicakligi[3]=degerler[8];
              durmaSicakligi[1]=degerler[9];
              durmaSicakligi[2]=degerler[10];
              durmaSicakligi[3]=degerler[11];




              


              //socket.add(utf8.encode('ok'));
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


  Widget _klepeKlasikUnsur(double oran, int isiticiNo) {
    return Expanded(
      flex: 5,
      child: Column(
        children: <Widget>[
          Expanded(child: Text(Dil().sec(dilSecimi, "tv262")+" "+isiticiNo.toString(),
          style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold),textScaleFactor: oran,),),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: RawMaterialButton(
                        onPressed: () {

                          _index = isiticiNo;
                                        _onlar = int.parse(
                                                    calismaSicakligifark[isiticiNo].split(".")[0]) <
                                                10
                                            ? 0
                                            : (int.parse(calismaSicakligifark[isiticiNo]
                                                    .split(".")[0]) ~/
                                                10);
                                        _birler = int.parse(
                                                calismaSicakligifark[isiticiNo].split(".")[0]) %
                                            10;
                                        _ondalik = int.parse(
                                            calismaSicakligifark[isiticiNo].split(".")[1]);

                                            _degergiris2X1(
                                            _onlar,
                                            _birler,
                                            _ondalik,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv247",
                                            Dil().sec(dilSecimi, "tv262")+" $isiticiNo ");

                          
                        
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            LayoutBuilder(builder: (context, constraint) {
                              return Icon(
                                Icons.brightness_1,
                                size: constraint.biggest.height,
                                color: Colors.red[800],
                              );
                            }),
                            Text(
                              calismaSicakligifark[isiticiNo],
                              style: TextStyle(
                                  fontSize: 20 * oran,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(flex: 1,
            child: Container(
              child: Text(calismaSicakligi[isiticiNo], textScaleFactor: oran),
              alignment: Alignment.center,
              color: Colors.grey[300],
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: RawMaterialButton(
                        onPressed: () {

                          _index = isiticiNo+3;
                                        _onlar = int.parse(
                                                    durmaSicakligiFark[isiticiNo].split(".")[0]) <
                                                10
                                            ? 0
                                            : (int.parse(durmaSicakligiFark[isiticiNo]
                                                    .split(".")[0]) ~/
                                                10);
                                        _birler = int.parse(
                                                durmaSicakligiFark[isiticiNo].split(".")[0]) %
                                            10;
                                        _ondalik = int.parse(
                                            durmaSicakligiFark[isiticiNo].split(".")[1]);

                                            _degergiris2X1(
                                            _onlar,
                                            _birler,
                                            _ondalik,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv248",
                                            Dil().sec(dilSecimi, "tv262")+" $isiticiNo ");



                          
                        
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            LayoutBuilder(builder: (context, constraint) {
                              return Icon(
                                Icons.brightness_1,
                                size: constraint.biggest.height,
                                color: Colors.cyan[800],
                              );
                            }),
                            Text(
                              durmaSicakligiFark[isiticiNo],
                              style: TextStyle(
                                  fontSize: 20 * oran,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(flex: 1,
            child: Container(
              child: Text(durmaSicakligi[isiticiNo], textScaleFactor: oran),
              alignment: Alignment.center,
              color: Colors.grey[300],
            ),
          ),
          
          
          
          
          ],
      ),
    );
  }
  //--------------------------METOTLAR--------------------------------

}

