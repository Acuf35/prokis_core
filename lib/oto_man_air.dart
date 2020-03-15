import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/oto_man.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x1.dart';
import 'genel/deger_giris_3x0.dart';
import 'genel/metotlar.dart';
import 'languages/select.dart';

class OtoManAir extends StatefulWidget {
  List<Map> gelenDBveri;
  OtoManAir(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return OtoManAirState(gelenDBveri);
  }
}

class OtoManAirState extends State<OtoManAir> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String airInletAdet = "0";

  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  List<bool> otoAIR = new List(3);
  List<bool> airManAc = new List(3);
  List<bool> airManKp = new List(3);
  List<bool> timerCancelAir = new List(3);
  List<bool> baglantiAir = new List(3);
  List<int> yazmaSonrasiGecikmeSayaciAIR = new List(3);

  String airHareketSuresi = "2.0";

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;
  bool takipEtiGeciciDurdur = false;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  OtoManAirState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        airInletAdet = dbVeri[i]["veri2"];
      }
    }

    for (int i = 1; i <= 2; i++) {
      otoAIR[i] = false;
      airManAc[i] = false;
      airManKp[i] = false;
      timerCancelAir[i] = false;
      baglantiAir[i] = false;
      yazmaSonrasiGecikmeSayaciAIR[i] = 8;
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      _takipEt('25*$airInletAdet');

      Timer.periodic(Duration(seconds: 2), (timer) {
        if (!takipEtiGeciciDurdur) yazmaSonrasiGecikmeSayaci++;

        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti &&
            yazmaSonrasiGecikmeSayaci > 3 &&
            !takipEtiGeciciDurdur) {
          baglanti = true;
          _takipEt("25*$airInletAdet");
        }
      });
    }

    timerSayac++;

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv476'),
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
                            color: Colors.grey[700],
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
                            color: Colors.grey[700],
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
              child: Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 15,
                      child: Column(
                        children: <Widget>[
                          Container(height: 20*oran,),
                          Expanded(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  _unsurOtoManWidget(
                                      Dil().sec(dilSecimi, "tv460"),
                                      'assets/images/kurulum_airinlet_icon.png',
                                      oran,
                                      1),
                                  _unsurOtoManWidget(
                                      Dil().sec(dilSecimi, "tv460"),
                                      'assets/images/kurulum_airinlet_icon.png',
                                      oran,
                                      2),
                                ],
                              )),
                          Spacer()
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
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
                  MaterialPageRoute(builder: (context) => OtoMan(dbVeriler)),
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
                        Dil().sec(dilSecimi, "tv81"), //Sıcaklık diyagramı
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
                    flex: 170,
                    child: Container(
                      color: Colors.yellow[100],
                      child: ListView(
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          ListTile(
                            dense: false,
                            title: Text(
                              Dil().sec(dilSecimi, "tv186"),
                              textScaleFactor: oran,
                            ),
                            subtitle: Text(
                              Dil().sec(dilSecimi, "info16_3"),
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
        ));

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
              print(yazmaSonrasiGecikmeSayaciAIR);

              if (komut.split("*")[0] == "25") {
                for (int i = 1; i <= int.parse(airInletAdet); i++) {
                  otoAIR[i] = degerler[i - 1] == "True" ? true : false;
                }
              }

              if (komut.split("*")[0] == "26") {
                for (int i = 1; i <= int.parse(airInletAdet); i++) {
                  airManAc[i] = degerler[i - 1] == "True" ? true : false;
                  airManKp[i] =
                      degerler[i - 1 + int.parse(airInletAdet)] == "True"
                          ? true
                          : false;
                }
                int x = degerler.length;
                airHareketSuresi = degerler[x - 1];
              }

              socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            for (var i = 1; i <= 2; i++) {
              baglantiAir[i] = false;
            }

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
        for (var i = 1; i <= 2; i++) {
          baglantiAir[i] = false;
        }
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
      for (var i = 1; i <= 2; i++) {
        baglantiAir[i] = false;
      }
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
              Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 2);
            } else {
              Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (emir.split("*")[0] == '30') _takipEt("25*$airInletAdet");
            if (emir.split("*")[0] == '31') _takipEt("26*$airInletAdet");

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
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
    }
  }

  Widget _unsurOtoManWidget(
      String baslik, String imagePath, double oran, int index) {
    return Visibility(
      visible: index <= int.parse(airInletAdet) || index > 5,
      child: Expanded(
        child: Visibility(
          visible: index <= int.parse(airInletAdet),
          child: Row(
            children: <Widget>[
              Spacer(),
              Expanded(
                flex: 10,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: AutoSizeText(
                            baslik + " $index",
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
                        Expanded(
                            flex: 6,
                            child: Row(
                              children: <Widget>[
                                //Oto
                                Expanded(
                                    flex: 10,
                                    child: RawMaterialButton(
                                      elevation: 8,
                                      onPressed: () {
                                        yazmaSonrasiGecikmeSayaci = 0;
                                        _veriGonder("30*$index*1");

                                        otoAIR[index] = true;
                                        airManAc[index] = false;
                                        airManKp[index] = false;

                                        setState(() {});
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      fillColor: otoAIR[index]
                                          ? Colors.green[400]
                                          : Colors.grey[400],
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
                                Expanded(
                                    flex: 10,
                                    child: RawMaterialButton(
                                      elevation: 8,
                                      onPressed: () {
                                        yazmaSonrasiGecikmeSayaci = 0;
                                        _veriGonder("30*$index*0");

                                        otoAIR[index] = false;

                                        setState(() {});
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      fillColor: !otoAIR[index]
                                          ? Colors.green[400]
                                          : Colors.grey[400],
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
                              ],
                            )),
                      ],
                    )),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Expanded(
                            flex: 24,
                            child: Visibility(
                              visible: !otoAIR[index],
                              child: RawMaterialButton(
                                onPressed: () {
                                  takipEtiGeciciDurdur = true;

                                  timerCancelAir[index] = false;
                                  Timer.periodic(Duration(seconds: 1), (timer) {
                                    yazmaSonrasiGecikmeSayaciAIR[index]++;
                                    if (timerCancelAir[index]) {
                                      timer.cancel();
                                    }
                                    if (!baglantiAir[index] &&
                                        yazmaSonrasiGecikmeSayaciAIR[index] >
                                            7) {
                                      baglantiAir[index] = true;
                                      _takipEt("26*$airInletAdet");
                                    }
                                  });

                                  _manKontrolAIR(oran, index).then((value) {
                                    takipEtiGeciciDurdur = false;
                                    timerCancelAir[index] = true;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
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
                                          Expanded(
                                            flex: 4,
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
                        ],
                      ),
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

  Future _manKontrolAIR(double oran, int index) {
    bool bottomDrawerAktif = true;
    int sayac1 = 0;

    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, state) {
              if (sayac1 == 0) {
                Timer.periodic(Duration(seconds: 1), (timer) {
                  if (!bottomDrawerAktif) {
                    timer.cancel();
                  } else {
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
                        Dil().sec(dilSecimi, "tv471") +
                            " - " +
                            Dil().sec(dilSecimi, "tv460") +
                            " " +
                            index.toString(),
                        style: TextStyle(
                            fontFamily: 'Kelly Slab',
                            fontWeight: FontWeight.bold),
                        textScaleFactor: oran,
                      )),
                    ),
                    //Fan Set Sıcaklıkları giriş bölümü
                    Expanded(
                      flex: 10,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(dilSecimi, "tv477"),
                                        textScaleFactor: oran,
                                        style:
                                            TextStyle(fontFamily: 'Kelly Slab'),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          _index = index;
                                          _onlar = int.parse(airHareketSuresi
                                                      .split(".")[0]) <
                                                  10
                                              ? 0
                                              : (int.parse(airHareketSuresi
                                                      .split(".")[0]) ~/
                                                  10);
                                          _birler = int.parse(airHareketSuresi
                                                  .split(".")[0]) %
                                              10;
                                          _ondalik = int.parse(
                                              airHareketSuresi.split(".")[1]);

                                          _degergiris2X1(
                                              _onlar,
                                              _birler,
                                              _ondalik,
                                              _index,
                                              oran,
                                              dilSecimi,
                                              "tv477",
                                              "");
                                        },
                                        child: Container(
                                          color: Colors.blue[700],
                                          padding: EdgeInsets.only(
                                              top: 5 * oran,
                                              bottom: 5 * oran,
                                              left: 15 * oran,
                                              right: 15 * oran),
                                          child: Text(
                                            airHareketSuresi,
                                            textScaleFactor: oran,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                        ),
                                        color: Colors.blue[700],
                                        elevation: 16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 3,
                                      ),
                                      bottomDrawerManUnsur(index, "tv473",
                                          airManAc[index], oran),
                                      Spacer(),
                                      bottomDrawerManUnsur(index + 10, "tv474",
                                          airManKp[index], oran),
                                      Spacer(
                                        flex: 3,
                                      ),

                                      //Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).then((value) {
      bottomDrawerAktif = false;
    });
  }

  Widget bottomDrawerManUnsur(
      int index, String isim, bool otoManDurum, double oran) {
    return Expanded(
      flex: 10,
      child: RawMaterialButton(
        fillColor: otoManDurum ? Colors.green[700] : Colors.grey[500],
        elevation: 8,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        constraints: BoxConstraints(),
        onPressed: () {
          String veri = "0";
          bool acYapiyorKapaYapilamaz = false;
          bool kapaYapiyorAcYapilamaz = false;

          if (index > 10 && airManAc[index - 10]) {
            acYapiyorKapaYapilamaz = true;
          }

          if (index < 11 && airManKp[index]) {
            kapaYapiyorAcYapilamaz = true;
          }

          if (acYapiyorKapaYapilamaz) {
            Toast.show(Dil().sec(dilSecimi, "toast81"), context, duration: 3);
          } else if (kapaYapiyorAcYapilamaz) {
            Toast.show(Dil().sec(dilSecimi, "toast80"), context, duration: 3);
          } else {
            if (otoManDurum) {
              if (index > 10) {
                airManKp[index - 10] = false;
              } else {
                airManAc[index] = false;
              }
              veri = "0";
            } else {
              if (index > 10) {
                airManKp[index - 10] = true;
              } else {
                airManAc[index] = true;
              }
              veri = "1";
            }

            yazmaSonrasiGecikmeSayaciAIR[index > 10 ? index - 10 : index] = 0;
            _veriGonder("31*$index*$veri");
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 5 * oran, bottom: 5 * oran),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Dil().sec(dilSecimi, isim),
                style: TextStyle(
                    fontFamily: "Kelly Slab",
                    color: otoManDurum ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textScaleFactor: oran,
              ),
            ],
          ),
        ),
      ),
    );
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

      String veri = "";

      airHareketSuresi =
          (_onlar * 10 + _birler).toString() + '.' + _ondalik.toString();
      veri = airHareketSuresi;

      if (veriGonderilsinMi) {
        _veriGonder("29*1*$veri");
      }

      setState(() {});
    });
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

//--------------------------METOTLAR--------------------------------

}
