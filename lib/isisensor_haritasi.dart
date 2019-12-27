import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'genel/alert_reset.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'languages/select.dart';

class IsiSensorHaritasi extends StatefulWidget {
  String gelenDil;

  IsiSensorHaritasi(String dil) {
    gelenDil = dil;
  }
  @override
  State<StatefulWidget> createState() {
    return IsiSensorHaritasiState(gelenDil);
  }
}

class IsiSensorHaritasiState extends State<IsiSensorHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> isisensorHarita = new List(23);
  List<bool> isisensorVisibility = new List(23);
  List<int> isisensorNo = new List(23);
  bool haritaOnay = false;
  int isisensorAdet = 0;

  int _onlarisisensor = 1;
  int _birlerisisensor = 0;
  int _onlarOut = 3;
  int _birlerOut = 3;
  int _degerNo = 0;

  double _oran1;
  bool veriGonderildi = false;
  bool isisensorNoTekerrur = false;
  bool cikisNoTekerrur = false;

  int sayacAktifSensor = 0;
  bool baglanti = false;
  bool timerCancel = false;

  List<bool> aktifSensorVisibility = new List(16);
  List<int> aktifSensorNo = new List(16);
  List<String> aktifSensorID = new List(16);
  List<String> aktifSensorValue = new List(16);
  List<bool> aktifSensorDurum = new List(16);
  int aktifSenSay=0;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++

  IsiSensorHaritasiState(String dil) {
    for (int i = 1; i <= 22; i++) {
      isisensorHarita[i] = 0;
      isisensorNo[i] = 0;
      isisensorVisibility[i] = true;
    }

    for (int i = 1; i <= 15; i++) {
      aktifSensorID[i] = "";
      aktifSensorValue[i] = "0.0";
      aktifSensorNo[i] = 0;
      aktifSensorVisibility[i] = false;
      aktifSensorDurum[i] = false;
    }

    dilSecimi = dil;
  }

  //--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++DATABASE'den SATIRLARI ÇEKME+++++++++++++++++++++++++++++++
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      if (dbSayac == 0) {
        dbSatirlar.then((List<Map> satir) => _satirlar(satir));
        dbSayac++;
      }
    });
//--------------------------DATABASE'den SATIRLARI ÇEKME--------------------------------

    if (sayacAktifSensor == 0) {
      print("İlk Takip Et çalıştırıldı!!!");
      _takipEt();

      Timer.periodic(Duration(seconds: 5), (timer) {
        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti) {
          baglanti = true;
          _takipEt();
        }
      });
    }

    sayacAktifSensor++;

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
    _oran1 = oran;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Text(
            SelectLanguage()
                .selectStrings(dilSecimi, "tv48"), // isisensor Haritası
            style: TextStyle(
                fontFamily: 'Kelly Slab',
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
          ),
          alignment: Alignment.center,
        )),
        //isisensor Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      //Aktif Sensörler Bölümü
                      Expanded(
                          flex: 13,
                          child: Stack(
                            children: <Widget>[
                              Visibility(visible: aktifSenSay==0 ? true : false,
                                                              child: Center(
                                    child: Text(
                                  "Sisteme bağlı aktif sensor yok...",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Kelly Slab",
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: oran,
                                )),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        //Aktif sensörler başlık
                                        Center(
                                            child: RotatedBox(
                                          child: Text(SelectLanguage()
                                              .selectStrings(
                                                  dilSecimi, "tv51")),
                                          quarterTurns: -45,
                                        )),
                                        //Aktif Sensorler 1-2-3
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 1
                                              _aktifSensor(1, oran),
                                              //Aktif sensör 2
                                              _aktifSensor(2, oran),
                                              //Aktif sensör 3
                                              _aktifSensor(3, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 4-5-6
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 4
                                              _aktifSensor(4, oran),
                                              //Aktif sensör 5
                                              _aktifSensor(5, oran),
                                              //Aktif sensör 6
                                              _aktifSensor(6, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 7-8-9
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 7
                                              _aktifSensor(7, oran),
                                              //Aktif sensör 8
                                              _aktifSensor(8, oran),
                                              //Aktif sensör 9
                                              _aktifSensor(9, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 10-11-12
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 10
                                              _aktifSensor(10, oran),
                                              //Aktif sensör 11
                                              _aktifSensor(11, oran),
                                              //Aktif sensör 12
                                              _aktifSensor(12, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 13-14-15
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 13
                                              _aktifSensor(13, oran),
                                              //Aktif sensör 14
                                              _aktifSensor(14, oran),
                                              //Aktif sensör 15
                                              _aktifSensor(15, oran),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Spacer(),
                      //Sensor Konumları Bölümü
                      Text(
                        "Bina Üst Görünüş",
                      ),
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Sağ Duvar
                            Center(
                                child: RotatedBox(
                              child: Text("Ön"),
                              quarterTurns: -45,
                            )),
                            Expanded(
                                flex: 16,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
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
                                                    _isisensorHaritaUnsur(
                                                        1, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        2, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        3, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        4, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        5, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        6, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        7, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        8, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        9, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        10, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        11, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        12, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        13, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        14, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        15, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        16, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        17, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        18, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        19, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        20, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        21, oran, "tv49", 1),
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
                            Center(
                                child: RotatedBox(
                              child: Text("Arka"),
                              quarterTurns: -45,
                            )),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(
          child: Container(
            color: Colors.grey.shade600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Spacer(),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Haritayı Onayla Butonu
                      Visibility(
                        visible: !haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            int sayac = 0;

                            for (int i = 1; i <= 22; i++) {
                              if (isisensorHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < isisensorAdet) {
                              //Haritada seçilen isisensor sayısı eksik
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast29"),
                                  context,
                                  duration: 3);
                            } else if (sayac > isisensorAdet) {
                              //Haritada seçilen isisensor sayısı yüksek
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast30"),
                                  context,
                                  duration: 3);
                            } else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              haritaOnay = true;

                              for (int i = 1; i <= 22; i++) {
                                if (isisensorHarita[i] != 0) {
                                  isisensorVisibility[i] = true;
                                } else {
                                  isisensorVisibility[i] = false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 22; i++) {
                                veri =
                                    veri + isisensorHarita[i].toString() + "#";
                              }

                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  20, "ok", veri, "0", "0");

                              _veriGonder("21", "25", veri, "0", "0", "0");

                              setState(() {});
                            }

                            //-------------------------ONAY BÖLÜMÜ--------------------------------------------------
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 30,
                              ),
                              Text(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn4"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Haritayı Sıfırla Butonu
                      Visibility(
                        visible: haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            _resetAlert(dilSecimi);
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.refresh,
                                size: 30,
                              ),
                              Text(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn5"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Verileri Gönder Butonu
                      Visibility(
                        visible: haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            bool noKontrol = false;
                            String cikisVeri = "";
                            String noVeri = "";
                            for (int i = 1; i <= 22; i++) {
                              if (isisensorHarita[i] == 1) {
                                if (isisensorNo[i] == 0) {
                                  noKontrol = true;
                                }
                              }
                              noVeri = noVeri + isisensorNo[i].toString() + "#";
                            }
                            if (noKontrol) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast24"),
                                  context,
                                  duration: 3);
                            } else if (isisensorNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast28"),
                                  context,
                                  duration: 3);
                            } else if (cikisNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast26"),
                                  context,
                                  duration: 3);
                            } else {
                              veriGonderildi = true;

                              _veriGonder(
                                  "19", "24", noVeri, cikisVeri, "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  21, "ok", noVeri, cikisVeri, "0");
                            }
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color:
                              veriGonderildi ? Colors.green[500] : Colors.blue,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.send,
                                size: 30,
                              ),
                              Text(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn6"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //geri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        timerCancel = true;
                        Navigator.pop(context);
                      },
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        if (!veriGonderildi) {
                          Toast.show(
                              SelectLanguage()
                                  .selectStrings(dilSecimi, "toast27"),
                              context,
                              duration: 3);
                        } else {
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MhYontemi(dilSecimi)),
                        );
*/

                        }
                      },
                      color: Colors.black,
                    )),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
//--------------------------SCAFFOLD--------------------------------
  }

//++++++++++++++++++++++++++METOTLAR+++++++++++++++++++++++++++++++

  _satirlar(List<Map> satirlar) {
    for (int i = 0; i <= dbSatirSayisi - 1; i++) {
      if (satirlar[i]["id"] == 0) {
        dilSecimi = satirlar[i]["veri1"];
      }

      if (satirlar[i]["id"] == 1) {
        kurulumDurum = satirlar[i]["veri1"];
      }

      if (satirlar[i]["id"] == 4) {
        isisensorAdet = int.parse(satirlar[i]["veri4"]);
      }

      if (satirlar[i]["id"] == 20) {
        if (satirlar[i]["veri1"] == "ok") {
          String xx = satirlar[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              haritaOnay = true;
            }
          }

          for (int i = 1; i <= 22; i++) {
            if (isisensorHarita[i] != 0) {
              isisensorVisibility[i] = true;
            } else {
              isisensorVisibility[i] = false;
            }
          }
        }
      }

      if (satirlar[i]["id"] == 21) {
        String xx;
        String yy;

        if (satirlar[i]["veri1"] == "ok") {
          veriGonderildi = true;
          xx = satirlar[i]["veri2"];
          yy = satirlar[i]["veri3"];
          var isisensorNolar = xx.split("#");
          var cikisNolar = yy.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorNo[i] = int.parse(isisensorNolar[i - 1]);
          }
        }
      }
    }

    print(satirlar);
    setState(() {});
  }

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/harita_isi_sensor_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X2X0(
      int onlarUnsur,
      int birlerUnsur,
      int onlarOut,
      int birlerOut,
      int indexNo,
      double oran,
      String dil,
      String baslik,
      int degerGirisKodu) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X2X0.Deger(onlarUnsur, birlerUnsur, onlarOut,
            birlerOut, indexNo, oran, dil, baslik);
      },
    ).then((val) {
      if (degerGirisKodu == 1) degerGiris2X2X0Yrd1(val);
    });
  }

  //Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X2X0Yrd1(var val) {
    if (_onlarisisensor != val[0] ||
        _birlerisisensor != val[1] ||
        _onlarOut != val[2] ||
        _birlerOut != val[3]) {
      veriGonderildi = false;
    }

    _onlarisisensor = val[0];
    _birlerisisensor = val[1];
    _onlarOut = val[2];
    _birlerOut = val[3];
    _degerNo = val[4];

    isisensorNo[_degerNo] =
        int.parse(_onlarisisensor.toString() + _birlerisisensor.toString());
    isisensorNoTekerrur = false;

    for (int i = 1; i <= 22; i++) {
      for (int k = 1; k <= 22; k++) {
        if (i != k &&
            isisensorNo[i] == isisensorNo[k] &&
            isisensorNo[i] != 0 &&
            isisensorNo[k] != 0) {
          isisensorNoTekerrur = true;
          break;
        }
        if (isisensorNoTekerrur) {
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

  Widget _isisensorHaritaUnsur(
      int indexNo, double oran, String baslik, int degerGirisKodu) {
    return Expanded(
      child: Visibility(
        visible: isisensorVisibility[indexNo] ? true : false,
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
                    if (haritaOnay) {
                      _onlarisisensor = isisensorNo[indexNo] < 10
                          ? 0
                          : (isisensorNo[indexNo] ~/ 10).toInt();
                      _birlerisisensor = isisensorNo[indexNo] % 10;
                      _degerNo = indexNo;
                      _degergiris2X2X0(_onlarisisensor, _birlerisisensor, 0, 0,
                          indexNo, oran, dilSecimi, baslik, degerGirisKodu);
                    } else {
                      if (isisensorHarita[indexNo] == 0 ||
                          isisensorHarita[indexNo] == null) {
                        isisensorHarita[indexNo] = 1;
                      } else if (isisensorHarita[indexNo] == 1) {
                        isisensorHarita[indexNo] = 0;
                      }

                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.pink,
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  imageGetir(isisensorHarita[indexNo])),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        opacity: isisensorVisibility[indexNo] &&
                                haritaOnay &&
                                isisensorHarita[indexNo] == 1
                            ? 1
                            : 1,
                      ),
                      Visibility(
                        visible: haritaOnay && isisensorHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 5,
                            ),
                            //isisensor No
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv50") +
                                              isisensorNo[indexNo].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab'),
                                          maxLines: 1,
                                          minFontSize: 8,
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
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _veriGonder(String dbKod, String id, String v1, String v2, String v3,
      String v4) async {
    Socket socket;

    try {
      socket = await Socket.connect('192.168.2.110', 2233);
      String gelen_mesaj = "";

      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
        print(utf8.decode(event));
        gelen_mesaj = utf8.decode(event);
        var gelen_mesaj_parcali = gelen_mesaj.split("*");

        if (gelen_mesaj_parcali[0] == 'ok') {
          Toast.show(
              SelectLanguage().selectStrings(dilSecimi, "toast8"), context,
              duration: 2);
        } else {
          Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
        }

        setState(() {});
      });

      socket.add(utf8.encode('$dbKod*$id*$v1*$v2*$v3*$v4'));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 5));

      // .. and close the socket
      socket.close();
    } catch (e) {
      print(e);
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

  Future _resetAlert(String x) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return ResetAlert.deger(x);
      },
    ).then((val) {
      if (val) {
        veriGonderildi = false;
        for (int i = 1; i <= 22; i++) {
          isisensorHarita[i] = 0;
          isisensorNo[i] = 0;
          isisensorVisibility[i] = true;
        }
        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(20, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(21, "0", "0", "0", "0");
        _veriGonder("23", "0", "0", "0", "0", "0");

        setState(() {});
      }
    });
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.2.110', 2233).then((socket) {
        /*
        socket.timeout(ReceiveTimeout,onTimeout: (deneme){
            Toast.show("Bağlantı zaman aşımına uğradı", context,duration: 3);
        });
        */

        socket.add(utf8.encode('24*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {
              var sensorler = gelenMesaj.split('*');
              print(sensorler);
              print(sensorler.length);
              aktifSenSay = ((sensorler.length - 1) ~/ 3).toInt();

              for (int i = 1; i <= 15; i++) {
                if (i <= aktifSenSay) {
                  aktifSensorVisibility[i] = true;
                }
              }
              int sayac = 0;
              for (int i = 0; i <= sensorler.length - 2; i++) {
                if (i % 3 == 0) {
                  sayac++;
                  aktifSensorID[sayac] = sensorler[i];
                  aktifSensorValue[sayac] = sensorler[i + 1];
                  aktifSensorDurum[sayac] =
                      sensorler[i + 2] == 'ok' ? true : false;
                }
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
        Toast.show("Bağlantı hatası!", context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  Widget _aktifSensor(int index, double oran) {
    return Expanded(
      child: Visibility(
        visible: aktifSensorVisibility[index],
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              SelectLanguage().selectStrings(dilSecimi, "tv50") +
                  aktifSensorNo[index].toString(),
              style: TextStyle(fontSize: 12),
            ),
            Expanded(
              child: RawMaterialButton(
                onPressed: () {
                  timerCancel = true;

                  Toast.show("Timer Durduruldu!!", context, duration: 3);
                },
                fillColor:
                    aktifSensorDurum[index] ? Colors.green[300] : Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(3.0 * oran),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              aktifSensorID[index] + " :",
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
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              aktifSensorValue[index] + "°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(minWidth: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }

//--------------------------METOTLAR--------------------------------

}
