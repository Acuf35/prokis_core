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
  List<int> cikisNo = new List(23);
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

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++

  IsiSensorHaritasiState(String dil) {
    for (int i = 1; i <= 22; i++) {
      isisensorHarita[i] = 0;
      isisensorNo[i] = 0;
      cikisNo[i] = 0;
      isisensorVisibility[i] = true;
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
            SelectLanguage().selectStrings(dilSecimi, "tv48"), // isisensor Haritası
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
                //Isı sensor görünümü
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      //Ön ve Sağ Duvar
                      Expanded(flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Ön Duvar
                            Expanded(child: Center(child: RotatedBox(child: Text("Ön Duvar"),quarterTurns: -45,)),),
                            Expanded(flex: 8,
                              child: Stack(children: <Widget>[
                                Container(
                                decoration: BoxDecoration(
                                  //color: Colors.pink,
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: AssetImage(
                                        "assets/images/onarka_duvar_gri_icon.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                                Column(children: <Widget>[
                                  Visibility(child: _isisensorHaritaUnsur(1),visible: isisensorVisibility[1] ? true : false,),
                                  Visibility(child: _isisensorHaritaUnsur(2),visible: isisensorVisibility[2] ? true : false,),
                                  Visibility(child: _isisensorHaritaUnsur(3),visible: isisensorVisibility[3] ? true : false,),
                                ],)
                              ],)
                            ),
                            Spacer(),
                            //Sağ Duvar
                            Expanded(child: Center(child: RotatedBox(child: Text("Sağ Duvar"),quarterTurns: -45,)),),
                            Expanded(flex: 16,
                              child: Stack(children: <Widget>[
                                Container(
                                decoration: BoxDecoration(
                                  //color: Colors.pink,
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: AssetImage(
                                        "assets/images/sagsol_duvar_gri_icon.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                                Row(children: <Widget>[
                                  Expanded(
                                                                      child: Column(children: <Widget>[
                                    Visibility(child: _isisensorHaritaUnsur(4),visible: isisensorVisibility[4] ? true : false,),
                                    Visibility(child: _isisensorHaritaUnsur(5),visible: isisensorVisibility[5] ? true : false,),
                                    Visibility(child: _isisensorHaritaUnsur(6),visible: isisensorVisibility[6] ? true : false,),
                                ],),
                                  ),
                                Expanded(
                                                                  child: Column(children: <Widget>[
                                    Visibility(child: _isisensorHaritaUnsur(7),visible: isisensorVisibility[7] ? true : false,),
                                    Visibility(child: _isisensorHaritaUnsur(8),visible: isisensorVisibility[8] ? true : false,),
                                    Visibility(child: _isisensorHaritaUnsur(9),visible: isisensorVisibility[9] ? true : false,),
                                  ],),
                                ),
                                Expanded(
                                                                  child: Column(children: <Widget>[
                                    Visibility(child: _isisensorHaritaUnsur(10),visible: isisensorVisibility[10] ? true : false,),
                                    Visibility(child: _isisensorHaritaUnsur(11),visible: isisensorVisibility[11] ? true : false,),
                                    Visibility(child: _isisensorHaritaUnsur(12),visible: isisensorVisibility[12] ? true : false,),
                                  ],),
                                )

                                ],)
                              ],)
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Arka ve Sol Duvar
                      Expanded(flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Arka Duvar
                            Expanded(child: Center(child: RotatedBox(child: Text("Arka Duvar"),quarterTurns: -45,)),),
                            Expanded(flex: 8,
                              child: Stack(children: <Widget>[
                                Container(
                                decoration: BoxDecoration(
                                  //color: Colors.pink,
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: AssetImage(
                                        "assets/images/onarka_duvar_gri_icon.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                                Column(children: <Widget>[
                                  Visibility(child: _isisensorHaritaUnsur(22),visible: isisensorVisibility[22] ? true : false,),
                                  Visibility(child: _isisensorHaritaUnsur(23),visible: isisensorVisibility[23] ? true : false,),
                                  Visibility(child: _isisensorHaritaUnsur(24),visible: isisensorVisibility[24] ? true : false,),
                                ],)
                              ],)
                            ),
                            Spacer(),
                            //Sol Duvar
                            Expanded(child: Center(child: RotatedBox(child: Text("Sol Duvar"),quarterTurns: -45,)),),
                            Expanded(flex: 16,
                              child: Stack(children: <Widget>[
                                Container(
                                decoration: BoxDecoration(
                                  //color: Colors.pink,
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: AssetImage(
                                        "assets/images/sagsol_duvar_gri_icon.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _isisensorHaritaUnsur(13),visible: isisensorVisibility[13] ? true : false,),
                                        Visibility(child: _isisensorHaritaUnsur(14),visible: isisensorVisibility[14] ? true : false,),
                                        Visibility(child: _isisensorHaritaUnsur(15),visible: isisensorVisibility[15] ? true : false,),
                                      ],),
                                    ),
                                    Expanded(
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _isisensorHaritaUnsur(16),visible: isisensorVisibility[16] ? true : false,),
                                        Visibility(child: _isisensorHaritaUnsur(17),visible: isisensorVisibility[17] ? true : false,),
                                        Visibility(child: _isisensorHaritaUnsur(18),visible: isisensorVisibility[18] ? true : false,),
                                      ],),
                                    ),
                                    Expanded(
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _isisensorHaritaUnsur(19),visible: isisensorVisibility[19] ? true : false,),
                                        Visibility(child: _isisensorHaritaUnsur(20),visible: isisensorVisibility[20] ? true : false,),
                                        Visibility(child: _isisensorHaritaUnsur(21),visible: isisensorVisibility[21] ? true : false,),
                                      ],),
                                    ),
                                  ],
                                )
                              ],)
                            ),
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
                            }  else {
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
                                veri = veri + isisensorHarita[i].toString() + "#";
                              }
                              
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  18, "ok", veri, "0", "0");

                              _veriGonder("18", "23", veri, "0", "0", "0");
                              

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
                                style: TextStyle(fontSize: 18),textScaleFactor: oran,
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
                                style: TextStyle(fontSize: 18),textScaleFactor: oran,
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
                                if (isisensorNo[i] == 0 || cikisNo[i] == 0) {
                                  noKontrol = true;
                                }
                              }
                              cikisVeri =
                                  cikisVeri + cikisNo[i].toString() + "#";
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
                                  19, "ok", noVeri, cikisVeri, "0");
                                  
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
                                style: TextStyle(fontSize: 18),textScaleFactor: oran,
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
    for(int i=0;i<=dbSatirSayisi-1;i++){
      if(satirlar[i]["id"]==0){
        dilSecimi = satirlar[i]["veri1"];
      }

      if(satirlar[i]["id"]==1){
        kurulumDurum = satirlar[i]["veri1"];
      }

      if(satirlar[i]["id"]==4){
        isisensorAdet = int.parse(satirlar[i]["veri3"]);
      }

      if(satirlar[i]["id"]==18){
        if(satirlar[i]["veri1"]=="ok"){
        String xx=satirlar[i]["veri2"];
        var fHaritalar = xx.split("#");
        for(int i=1;i<=22;i++ ){
          isisensorHarita[i]=int.parse(fHaritalar[i-1]);
          if(fHaritalar[i-1]!="0"){
          haritaOnay=true;
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

    if(satirlar[i]["id"]==19){
        String xx;
        String yy;

        if(satirlar[i]["veri1"]=="ok"){
          veriGonderildi=true;
          xx=satirlar[i]["veri2"];
          yy=satirlar[i]["veri3"];
          var isisensorNolar=xx.split("#");
          var cikisNolar=yy.split("#");
          for(int i=1;i<=22;i++){
            isisensorNo[i]=int.parse(isisensorNolar[i-1]);
            cikisNo[i]=int.parse(cikisNolar[i-1]);
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
      imagePath = 'assets/images/isisensor_harita_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X2X0() async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X2X0.Deger(_onlarisisensor, _birlerisisensor, _onlarOut,
            _birlerOut, _degerNo, _oran1, dilSecimi,"tv46");
      },
    ).then((val) {
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
      cikisNo[_degerNo] =
          int.parse(_onlarOut.toString() + _birlerOut.toString());
      isisensorNoTekerrur = false;
      cikisNoTekerrur = false;

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
          if (i != k &&
              cikisNo[i] == cikisNo[k] &&
              cikisNo[i] != 0 &&
              cikisNo[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
          if (cikisNoTekerrur) {
            break;
          }
        }
      }

      setState(() {});
    });
  }

  Widget _isisensorHaritaUnsur(int indexNo) {
    return Expanded(
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
                    _onlarOut = cikisNo[indexNo] < 10
                        ? 0
                        : (cikisNo[indexNo] ~/ 10).toInt();
                    _birlerOut = cikisNo[indexNo] % 10;
                    _degerNo = indexNo;
                    _degergiris2X2X0();
                  } else {

                    if (isisensorHarita[indexNo] == 0 ||
                        isisensorHarita[indexNo] == null) {
                      isisensorHarita[indexNo] = 1;
                    }  else if (isisensorHarita[indexNo] == 1) {
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
                            image: AssetImage(imageGetir(isisensorHarita[indexNo])),
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
                      child: Visibility(
                        visible: haritaOnay && isisensorHarita[indexNo] == 1
                            ? true
                            : false,
                        child: Row(
                          children: <Widget>[
                            Spacer(flex: 5,),
                            //isisensor No
                            Expanded(flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv45") +
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
                            //Çıkış No
                            Expanded(flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv33") +
                                              cikisNo[indexNo].toString(),
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
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  _veriGonder(String dbKod, String id, String v1, String v2, String v3,String v4) async {
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
          cikisNo[i] = 0;
          isisensorVisibility[i] = true;
        }
        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(18, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(19, "0", "0", "0", "0");
        _veriGonder("20", "0", "0", "0", "0", "0");

        setState(() {});
      }
    });
  }

//--------------------------METOTLAR--------------------------------

}
