import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/diger_cikislar.dart';
import 'package:prokis/bacafan_haritasi.dart';
import 'package:toast/toast.dart';
import 'airinlet_haritasi.dart';
import 'genel/alert_reset.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'genel/sayfa_geri_alert.dart';
import 'isisensor_haritasi.dart';
import 'isitici_haritasi.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class SiloHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  SiloHaritasi(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum=durum;
  }
  @override
  State<StatefulWidget> createState() {
    return SiloHaritasiState(gelenDBveri,gelenDurum);
  }
}

class SiloHaritasiState extends State<SiloHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> siloHarita = new List(21);
  List<bool> siloVisibility = new List(21);
  List<int> siloNo = new List(21);
  bool haritaOnay = false;
  int siloAdet = 0;
  String bacafanAdet = '0';
  String airinletAdet = '0';
  String isiticiAdet = '0';

  int _onlarsilo = 0;
  int _birlersilo = 0;
  int _degerNo = 0;

  bool veriGonderildi = false;
  bool siloNoTekerrur = false;

  List<int> tumCikislar = new List(111);

  bool durum;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SiloHaritasiState(List<Map> dbVeri,bool drm) {
    bool siloHaritaOK = false;
    bool siloNoOK = false;
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        bacafanAdet = dbVeri[i]["veri1"];
        airinletAdet = dbVeri[i]["veri2"];
        isiticiAdet = dbVeri[i]["veri3"];
        siloAdet = int.parse(dbVeri[i]["veri4"]);
      }

      if (dbVeri[i]["id"] == 22) {
        if (dbVeri[i]["veri1"] == "ok") {
          tumCikislarVar = true;
          var tcikislar = dbVeri[i]["veri2"].split("#");

          for (int i = 1; i <= 110; i++) {
            tumCikislar[i] = int.parse(tcikislar[i - 1]);
          }
        }
      }

      if (dbVeri[i]["id"] == 29) {
        if (dbVeri[i]["veri1"] == "ok") {
          siloHaritaOK = true;
          String xx = dbVeri[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <= 20; i++) {
            siloHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              haritaOnay = true;
            }
          }

          for (int i = 1; i <= 20; i++) {
            if (siloHarita[i] != 0) {
              siloVisibility[i] = true;
            } else {
              siloVisibility[i] = false;
            }
          }
        }
      }

      if (dbVeri[i]["id"] == 30) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          siloNoOK = true;
          veriGonderildi = true;
          xx = dbVeri[i]["veri2"];
          var siloNolar = xx.split("#");
          for (int i = 1; i <= 20; i++) {
            siloNo[i] = int.parse(siloNolar[i - 1]);
          }
        }
      }
    }

    if (!siloHaritaOK) {
      for (int i = 1; i <= 20; i++) {
        siloHarita[i] = 0;
        siloVisibility[i] = true;
      }
    }

    if (!siloNoOK) {
      for (int i = 1; i <= 20; i++) {
        siloNo[i] = 0;
      }
    }

    if (!tumCikislarVar) {
      for (int i = 1; i <= 110; i++) {
        tumCikislar[i] = 0;
      }
    }
    durum=drm;
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  if(veriGonderildi){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                  );
                  }else{
                    _sayfaGeriAlert(dilSecimi, "tv564");
                  }
                  
                },
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
    ),
    
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      Dil().sec(dilSecimi, "tv84"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          alignment: Alignment.center,
        )),
        //silo Harita Oluşturma Bölümü
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
                  flex: 8,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 6,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  _siloHaritaUnsur(6, oran, "tv83", 1),
                                  _siloHaritaUnsur(5, oran, "tv83", 1),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 9,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  _siloHaritaUnsur(8, oran, "tv83", 1),
                                  _siloHaritaUnsur(7, oran, "tv83", 1),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 9,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  _siloHaritaUnsur(10, oran, "tv83", 1),
                                  _siloHaritaUnsur(9, oran, "tv83", 1),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 6,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 13,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
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
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        _siloHaritaUnsur(4, oran, "tv83", 1),
                                        _siloHaritaUnsur(3, oran, "tv83", 1),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        _siloHaritaUnsur(2, oran, "tv83", 1),
                                        _siloHaritaUnsur(1, oran, "tv83", 1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 27,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
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
                                        Spacer(
                                          flex: 7,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil()
                                                          .sec(
                                                              dilSecimi,
                                                              "tv57"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40,
                                                      ),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                        Spacer(
                                          flex: 7,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        _siloHaritaUnsur(11, oran, "tv83", 1),
                                        _siloHaritaUnsur(12, oran, "tv83", 1),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        _siloHaritaUnsur(13, oran, "tv83", 1),
                                        _siloHaritaUnsur(14, oran, "tv83", 1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 6,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  _siloHaritaUnsur(19, oran, "tv83", 1),
                                  _siloHaritaUnsur(20, oran, "tv83", 1),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 9,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  _siloHaritaUnsur(17, oran, "tv83", 1),
                                  _siloHaritaUnsur(18, oran, "tv83", 1),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 9,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  _siloHaritaUnsur(15, oran, "tv83", 1),
                                  _siloHaritaUnsur(16, oran, "tv83", 1),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 6,
                            ),
                          ],
                        ),
                      ),
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

                            for (int i = 1; i <= 20; i++) {
                              if (siloHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < siloAdet) {
                              //Haritada seçilen silo sayısı eksik
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast54"),
                                  context,
                                  duration: 3);
                            } else if (sayac > siloAdet) {
                              //Haritada seçilen silo sayısı yüksek
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast55"),
                                  context,
                                  duration: 3);
                            } else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              haritaOnay = true;

                              for (int i = 1; i <= 20; i++) {
                                if (siloHarita[i] != 0) {
                                  siloVisibility[i] = true;
                                } else {
                                  siloVisibility[i] = false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 20; i++) {
                                veri = veri + siloHarita[i].toString() + "#";
                              }

                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  29, "ok", veri, "0", "0");

                              _veriGonder("35", "34", veri, "0", "0", "0");

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
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn4"),
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
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn5"),
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
                            bool sensSayYukNo = false;
                            String noVeri = "";
                            for (int i = 1; i <= 20; i++) {
                              if (siloHarita[i] == 1) {
                                if (siloNo[i] == 0) {
                                  noKontrol = true;
                                }
                                if (siloNo[i] > siloAdet) {
                                  sensSayYukNo = true;
                                }
                              }
                              noVeri = noVeri + siloNo[i].toString() + "#";
                            }

                            if (noKontrol) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast56"),
                                  context,
                                  duration: 3);
                            } else if (sensSayYukNo) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast57"),
                                  context,
                                  duration: 3);
                            } else if (siloNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast58"),
                                  context,
                                  duration: 3);
                            } else {
                              veriGonderildi = true;

                              _veriGonder("36", "35", noVeri, "0", "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  30, "ok", noVeri, "0", "0");
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
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn6"),
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
                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 50 * oran,
                        onPressed: () {

                          if(isiticiAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiticiHaritasi(dbVeriler,true)),
                              );
                            }else if(airinletAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AirInletHaritasi(dbVeriler,true)),
                              );
                            }else if(bacafanAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BacafanHaritasi(dbVeriler,true)),
                              );
                            }else{

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiSensorHaritasi(dbVeriler,true)),
                                );
                              }
                        },
                      ),
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          if (!veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DigerCikislar(dbVeriler,true)),
                            );
                          }
                        },
                        color: Colors.black,
                      ),
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

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/silo_harita.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X0(int onlarX, birlerX, index, double oran, String dil,
      baslik, int degerGirisKodu) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(onlarX, birlerX, index, oran, dil, baslik);
      },
    ).then((val) {
      if (degerGirisKodu == 1) degerGiris2X0Yrd1(val);
    });
  }

  //Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd1(var val) {
    if (_onlarsilo != val[0] || _birlersilo != val[1]) {
      veriGonderildi = false;
    }

    _onlarsilo = val[0];
    _birlersilo = val[1];
    _degerNo = val[2];

    siloNo[_degerNo] =
        int.parse(_onlarsilo.toString() + _birlersilo.toString());
    siloNoTekerrur = false;

    for (int i = 1; i <= 20; i++) {
      for (int k = 1; k <= 20; k++) {
        if (i != k &&
            siloNo[i] == siloNo[k] &&
            siloNo[i] != 0 &&
            siloNo[k] != 0) {
          siloNoTekerrur = true;
          break;
        }
        if (siloNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

  Widget _siloHaritaUnsur(
      int indexNo, double oran, String baslik, int degerGirisKodu) {
    return Expanded(
      child: Visibility(
        visible: siloVisibility[indexNo] ? true : false,
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
                      _onlarsilo = siloNo[indexNo] < 10
                          ? 0
                          : (siloNo[indexNo] ~/ 10).toInt();
                      _birlersilo = siloNo[indexNo] % 10;
                      _degerNo = indexNo;
                      _degergiris2X0(_onlarsilo, _birlersilo, indexNo, oran,
                          dilSecimi, baslik, degerGirisKodu);
                    } else {
                      if (siloHarita[indexNo] == 0 ||
                          siloHarita[indexNo] == null) {
                        siloHarita[indexNo] = 1;
                      } else if (siloHarita[indexNo] == 1) {
                        siloHarita[indexNo] = 0;
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
                              image:
                                  AssetImage(imageGetir(siloHarita[indexNo])),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        opacity: siloVisibility[indexNo] &&
                                haritaOnay &&
                                siloHarita[indexNo] == 1
                            ? 1
                            : 1,
                      ),
                      Visibility(
                        visible: haritaOnay && siloHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 2,
                            ),
                            //silo No
                            Expanded(
                              flex: 8,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(
                                                  dilSecimi, "tv82") +
                                              siloNo[indexNo].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.bold,
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
                            Spacer(flex: 2,),
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
      socket = await Socket.connect('192.168.1.110', 2233);
      String gelen_mesaj = "";

      

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
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

        setState(() {});
      });

      socket.add(utf8.encode('$dbKod*$id*$v1*$v2*$v3*$v4'));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 5));

      // .. and close the socket
      socket.close();
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast20"), context,
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
        for (int i = 1; i <= 20; i++) {
          siloHarita[i] = 0;
          siloNo[i] = 0;
          siloVisibility[i] = true;
        }

        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(29, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(30, "0", "0", "0", "0");
        _veriGonder("37", "0", "0", "0", "0", "0");

        setState(() {});
      }
    });
  }

    Future _sayfaGeriAlert(String dilSecimi, String uyariMetni) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SayfaGeriAlert.deger(dilSecimi,uyariMetni);
      },
    ).then((val) {
      if (val) {

        if(val){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
          );

        }


      }
    });
  }


//--------------------------METOTLAR--------------------------------

}
