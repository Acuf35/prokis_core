import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'fan_haritasi.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'klp_yontemi.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class UzDebiNem extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  UzDebiNem(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum=durum;
  }

  @override
  State<StatefulWidget> createState() {
    return UzDebiNemState(gelenDBveri,gelenDurum);
  }
}

class UzDebiNemState extends State<UzDebiNem> {
//++++++++++++++++++++++++++DATABASE ve DİĞER DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  bool disNem = false;
  int klepeAdet = 0;
  int bacaFanAdet = 0;
  String klepeNo = "";
  String xM = "";
  String yM = "";
  String aM = "";
  String bM = "";
  String cM = "";
  String tunelFanDebi = "";
  String bacaFanDebi = "";
  String hacimOrani = "";
  String k1x = "0.0";
  String k2x = "0.0";
  String k3x = "0.0";
  String k4x = "0.0";
  String k5x = "0.0";
  String k6x = "0.0";
  String k7x = "0.0";
  String k8x = "0.0";
  String k9x = "0.0";
  String k10x = "0.0";
  String k1y = "0.0";
  String k2y = "0.0";
  String k3y = "0.0";
  String k4y = "0.0";
  String k5y = "0.0";
  String k6y = "0.0";
  String k7y = "0.0";
  String k8y = "0.0";
  String k9y = "0.0";
  String k10y = "0.0";

  bool durum;

  final FocusNode _focusNodeAm = FocusNode();
  final FocusNode _focusNodeBm = FocusNode();
  final FocusNode _focusNodeCm = FocusNode();
  final FocusNode _focusNodeTfanDebi = FocusNode();
  final FocusNode _focusNodeBfanDebi = FocusNode();
  final FocusNode _focusNodeHacimOrani = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _focusNodeAm.addListener(() {
      if (!_focusNodeAm.hasFocus) {
        dbHelper.veriYOKSAekleVARSAguncelle(12, aM, bM, cM, "0");
        _veriGonder("10", "16", aM, bM, cM, "0");
      }
    });
    _focusNodeBm.addListener(() {
      if (!_focusNodeBm.hasFocus) {
        dbHelper.veriYOKSAekleVARSAguncelle(12, aM, bM, cM, "0");
        _veriGonder("10", "16", aM, bM, cM, "0");
      }
    });
    _focusNodeCm.addListener(() {
      if (!_focusNodeCm.hasFocus) {
        dbHelper.veriYOKSAekleVARSAguncelle(12, aM, bM, cM, "0");
        _veriGonder("10", "16", aM, bM, cM, "0");
      }
    });
    _focusNodeTfanDebi.addListener(() {
      if (!_focusNodeTfanDebi.hasFocus) {
        dbHelper.veriYOKSAekleVARSAguncelle(13, tunelFanDebi, bacaFanDebi,
            hacimOrani, disNem == true ? "1" : "0");
        _veriGonder("11", "18", tunelFanDebi, bacaFanDebi, hacimOrani,
            disNem == true ? "1" : "0");
      }
    });
    _focusNodeBfanDebi.addListener(() {
      if (!_focusNodeBfanDebi.hasFocus) {
        dbHelper.veriYOKSAekleVARSAguncelle(13, tunelFanDebi, bacaFanDebi,
            hacimOrani, disNem == true ? "1" : "0");
        _veriGonder("11", "18", tunelFanDebi, bacaFanDebi, hacimOrani,
            disNem == true ? "1" : "0");
      }
    });
    _focusNodeHacimOrani.addListener(() {
      if (!_focusNodeHacimOrani.hasFocus) {
        dbHelper.veriYOKSAekleVARSAguncelle(13, tunelFanDebi, bacaFanDebi,
            hacimOrani, disNem == true ? "1" : "0");
        _veriGonder("11", "18", tunelFanDebi, bacaFanDebi, hacimOrani,
            disNem == true ? "1" : "0");
      }
    });

    super.initState();
  }

//--------------------------DATABASE ve DİĞER DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  UzDebiNemState(List<Map> dbVeri,bool drm) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        klepeAdet = int.parse(dbVeri[i]["veri2"]);
      }

      if (dbVeri[i]["id"] == 5) {
        bacaFanAdet = int.parse(dbVeri[i]["veri1"]);
      }

      if (dbVeri[i]["id"] == 9) {
        var data1 = dbVeri[i]["veri1"].split("*");
        k1x = data1[0];
        data1.length > 1 ? k1y = data1[1] : k1y = "0";
        var data2 = dbVeri[i]["veri2"].split("*");
        k2x = data2[0];
        data2.length > 1 ? k2y = data2[1] : k2y = "0";
        var data3 = dbVeri[i]["veri3"].split("*");
        k3x = data3[0];
        data3.length > 1 ? k3y = data3[1] : k3y = "0";
        var data4 = dbVeri[i]["veri4"].split("*");
        k4x = data4[0];
        data4.length > 1 ? k4y = data4[1] : k4y = "0";
      }

      if (dbVeri[i]["id"] == 10) {
        var data1 = dbVeri[i]["veri1"].split("*");
        k5x = data1[0];
        data1.length > 1 ? k5y = data1[1] : k5y = "0";
        var data2 = dbVeri[i]["veri2"].split("*");
        k6x = data2[0];
        data2.length > 1 ? k6y = data2[1] : k6y = "0";
        var data3 = dbVeri[i]["veri3"].split("*");
        k7x = data3[0];
        data3.length > 1 ? k7y = data3[1] : k7y = "0";
        var data4 = dbVeri[i]["veri4"].split("*");
        k8x = data4[0];
        data4.length > 1 ? k8y = data4[1] : k8y = "0";
      }

      if (dbVeri[i]["id"] == 11) {
        var data1 = dbVeri[i]["veri1"].split("*");
        k9x = data1[0];
        data1.length > 1 ? k9y = data1[1] : k9y = "0";
        var data2 = dbVeri[i]["veri2"].split("*");
        k10x = data2[0];
        data2.length > 1 ? k10y = data2[1] : k10y = "0";
      }

      if (dbVeri[i]["id"] == 12) {
        aM = dbVeri[i]["veri1"];
        bM = dbVeri[i]["veri2"];
        cM = dbVeri[i]["veri3"];
      }

      if (dbVeri[i]["id"] == 13) {
        tunelFanDebi = dbVeri[i]["veri1"];
        bacaFanDebi = dbVeri[i]["veri2"];
        hacimOrani = dbVeri[i]["veri3"];
        disNem=dbVeri[i]["veri4"]=="1" ? true : false;

        
        //disNem = dbVeri[i]["veri4"] == "1" ? true : false;
      }
    }

    durum=drm;

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    TextEditingController tec1 = new TextEditingController(text: klepeNo);
    TextEditingController tec2 = new TextEditingController(text: xM);
    TextEditingController tec3 = new TextEditingController(text: yM);
    TextEditingController tec4 = new TextEditingController(text: aM);
    TextEditingController tec5 = new TextEditingController(text: bM);
    TextEditingController tec6 = new TextEditingController(text: cM);
    TextEditingController tec7 = new TextEditingController(text: tunelFanDebi);
    TextEditingController tec8 = new TextEditingController(text: bacaFanDebi);
    TextEditingController tec9 = new TextEditingController(text: hacimOrani);

    _textFieldCursorPosition(tec1, klepeNo);
    _textFieldCursorPosition(tec2, xM);
    _textFieldCursorPosition(tec3, yM);
    _textFieldCursorPosition(tec4, aM);
    _textFieldCursorPosition(tec5, bM);
    _textFieldCursorPosition(tec6, cM);
    _textFieldCursorPosition(tec7, tunelFanDebi);
    _textFieldCursorPosition(tec8, bacaFanDebi);
    _textFieldCursorPosition(tec9, hacimOrani);

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold(
          floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                  );
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
    
            body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Başlık Bölümü
                  Expanded(
                      child: Container(
                    color: Colors.grey[600],
                    child: Text(
                      Dil().sec(dilSecimi, "tv29"),
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                      textScaleFactor: oran,
                    ),
                    alignment: Alignment.center,
                  )),
                  // Ayarlar Bölümü
                  Expanded(
                    flex: 2, //4~/oran,
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          //Kümes Bina Uzunlukları bölümü
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //A(m) , B(m) , C(m) girdileri bölümü
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //A(m)
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        focusNode: _focusNodeAm,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec4,
                                        onChanged: (String metin) {
                                          aM = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeAm.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: "A(m)"),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //B(m)
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        focusNode: _focusNodeBm,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec5,
                                        onChanged: (String metin) {
                                          bM = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeBm.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: "B(m)"),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Y(m)
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        focusNode: _focusNodeCm,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec6,
                                        onChanged: (String metin) {
                                          cM = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeCm.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: "C(m)"),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                //Tünel Fan Debi ve Baca Fan Debi Bölümü
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Tunel Fan Debi
                                    Expanded(
                                      flex: 6,
                                      child: TextField(
                                        focusNode: _focusNodeTfanDebi,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec7,
                                        onChanged: (String metin) {
                                          tunelFanDebi = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeTfanDebi.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            helperText: Dil()
                                                .sec(
                                                    dilSecimi, "tfhp1"),
                                            helperStyle: TextStyle(
                                                fontSize: 14 * oran,
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.blue[800]),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: Dil()
                                                .sec(
                                                    dilSecimi, "tflb1")),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Baca Fan Debi
                                    Expanded(
                                      flex: 6,
                                      child: Visibility(
                                        visible: bacaFanAdet > 0 ? true : false,
                                        child: TextField(
                                          focusNode: _focusNodeBfanDebi,
                                          style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              color: Colors.grey[600],
                                              fontSize: 20 * oran),
                                          textAlign: TextAlign.center,
                                          controller: tec8,
                                          onChanged: (String metin) {
                                            bacaFanDebi = metin;
                                          },
                                          onSubmitted: (String metin) {
                                            _focusNodeBfanDebi.unfocus();
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              helperText: Dil()
                                                  .sec(
                                                      dilSecimi, "tfhp1"),
                                              helperStyle: TextStyle(
                                                  fontSize: 14 * oran,
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.blue[800]),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 15 * oran,
                                                  fontWeight: FontWeight.bold),
                                              labelText: Dil()
                                                  .sec(
                                                      dilSecimi, "tflb2")),
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                //Hacim oranı ve Dış Nm Bölümü
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Hacim Yüzdesi
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 10 * oran),
                                        child: TextField(
                                          focusNode: _focusNodeHacimOrani,
                                          style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              color: Colors.grey[600],
                                              fontSize: 20 * oran),
                                          textAlign: TextAlign.center,
                                          controller: tec9,
                                          onChanged: (String metin) {
                                            hacimOrani = metin;
                                          },
                                          onSubmitted: (String metin) {
                                            _focusNodeHacimOrani.unfocus();
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16 * oran,
                                                  fontWeight: FontWeight.bold),
                                              labelText: Dil()
                                                  .sec(
                                                      dilSecimi, "tflb3")),
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Dış nem Aktif-Pasif Seçimi
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              Dil().sec(
                                                  dilSecimi, "tv30"),
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              textScaleFactor: oran,
                                            ),
                                            RawMaterialButton(
                                              onPressed: () {
                                                if (disNem) {
                                                  disNem = false;
                                                } else {
                                                  disNem = true;
                                                }
                                                dbHelper
                                                    .veriYOKSAekleVARSAguncelle(
                                                        13,
                                                        tunelFanDebi,
                                                        bacaFanDebi,
                                                        hacimOrani,
                                                        disNem == true ? "1" : "0");
                                                _veriGonder(
                                                    "11",
                                                    "18",
                                                    tunelFanDebi,
                                                    bacaFanDebi,
                                                    hacimOrani,
                                                    disNem == true ? "1" : "0");

                                                setState(() {});
                                              },
                                              child: Icon(
                                                disNem == true
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: disNem == true
                                                    ? Colors.green[600]
                                                    : Colors.black,
                                                size: 25 * oran,
                                              ),
                                              padding: EdgeInsets.all(0),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              constraints: BoxConstraints(),
                                            )
                                          ],
                                        )),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Referans bina resmi bölümü
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          'assets/images/kumes_bina_uzunluk_icon.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              
                            ],
                          )),
                          //Klepe uzunluk girişi
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              //Klepe Uzunluk girişi(KlepeNO, x(m), Y(m))
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //Klepe No

                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600],
                                          fontSize: 20 * oran),
                                      textAlign: TextAlign.center,
                                      maxLength: 2,
                                      controller: tec1,
                                      onSubmitted: (String metin) {
                                        klepeNo = metin;
                                      },
                                      onChanged: (String metin) {
                                        klepeNo = metin;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16 * oran,
                                              fontWeight: FontWeight.bold),
                                          counterStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily: 'Kelly Slab',
                                              fontSize: 12 * oran),
                                          labelText: "Klepe No"),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //X(m)
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600],
                                          fontSize: 20 * oran),
                                      textAlign: TextAlign.center,
                                      maxLength: 4,
                                      controller: tec2,
                                      onSubmitted: (String metin) {
                                        xM = metin;
                                      },
                                      onChanged: (String metin) {
                                        xM = metin;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16 * oran,
                                              fontWeight: FontWeight.bold),
                                          counterStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily: 'Kelly Slab',
                                              fontSize: 12 * oran),
                                          labelText: "X(m)"),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //Y(m)
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600],
                                          fontSize: 20 * oran),
                                      textAlign: TextAlign.center,
                                      maxLength: 5,
                                      controller: tec3,
                                      onSubmitted: (String metin) {
                                        yM = metin;
                                      },
                                      onChanged: (String metin) {
                                        yM = metin;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16 * oran,
                                              fontWeight: FontWeight.bold),
                                          labelText: "Y(m)"),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ),
                              //Atama Onay Butonu
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: SizedBox(
                                      height: 40 * oran,
                                      child: RaisedButton(
                                        color: Colors.blue[800],
                                        elevation: 16,
                                        onPressed: () {
                                          double x;
                                          double y;
                                          bool formatHata = false;
                                          print(klepeNo);

                                          try {
                                            x = double.parse(xM);
                                          } catch (e) {
                                            formatHata = true;
                                          }

                                          try {
                                            y = double.parse(yM);
                                          } catch (e) {
                                            formatHata = true;
                                          }

                                          if (xM != null &&
                                              yM != null &&
                                              klepeNo != null &&
                                              klepeNo != "" &&
                                              xM != "" &&
                                              yM != "") {
                                            if (!formatHata && x > 0 && y > 0) {
                                              int klpNo = int.parse(klepeNo);

                                              if (klpNo <= klepeAdet) {
                                                if (klpNo == 1) {
                                                  k1x = xM;
                                                  k1y = yM;
                                                }

                                                if (klpNo == 2) {
                                                  k2x = xM;
                                                  k2y = yM;
                                                }

                                                if (klpNo == 3) {
                                                  k3x = xM;
                                                  k3y = yM;
                                                }

                                                if (klpNo == 4) {
                                                  k4x = xM;
                                                  k4y = yM;
                                                }

                                                if (klpNo == 5) {
                                                  k5x = xM;
                                                  k5y = yM;
                                                }

                                                if (klpNo == 6) {
                                                  k6x = xM;
                                                  k6y = yM;
                                                }

                                                if (klpNo == 7) {
                                                  k7x = xM;
                                                  k7y = yM;
                                                }

                                                if (klpNo == 8) {
                                                  k8x = xM;
                                                  k8y = yM;
                                                }

                                                if (klpNo == 9) {
                                                  k9x = xM;
                                                  k9y = yM;
                                                }

                                                if (klpNo == 10) {
                                                  k10x = xM;
                                                  k10y = yM;
                                                }

                                                Toast.show(
                                                    Dil()
                                                        .sec(
                                                            dilSecimi,
                                                            "toast8"),
                                                    context,
                                                    duration: 2);

                                                if (klpNo < 5) {
                                                  dbHelper
                                                      .veriYOKSAekleVARSAguncelle(
                                                          9,
                                                          k1x + "*" + k1y,
                                                          k2x + "*" + k2y,
                                                          k3x + "*" + k3y,
                                                          k4x + "*" + k4y);
                                                  _veriGonder(
                                                      "7",
                                                      "11",
                                                      k1x + "#" + k1y,
                                                      k2x + "#" + k2y,
                                                      k3x + "#" + k3y,
                                                      k4x + "#" + k4y);
                                                } else if (klpNo < 9) {
                                                  dbHelper
                                                      .veriYOKSAekleVARSAguncelle(
                                                          10,
                                                          k5x + "*" + k5y,
                                                          k6x + "*" + k6y,
                                                          k7x + "*" + k7y,
                                                          k8x + "*" + k8y);
                                                  _veriGonder(
                                                      "8",
                                                      "13",
                                                      k5x + "#" + k5y,
                                                      k6x + "#" + k6y,
                                                      k7x + "#" + k7y,
                                                      k8x + "#" + k8y);
                                                } else if (klpNo < 11) {
                                                  dbHelper
                                                      .veriYOKSAekleVARSAguncelle(
                                                          11,
                                                          k9x + "*" + k9y,
                                                          k10x + "*" + k10y,
                                                          "0",
                                                          "0");
                                                  _veriGonder(
                                                      "9",
                                                      "15",
                                                      k9x + "#" + k9y,
                                                      k10x + "#" + k10y,
                                                      "0",
                                                      "0");
                                                }
                                              } else {
                                                Toast.show(
                                                    Dil()
                                                        .sec(
                                                            dilSecimi,
                                                            "toast5"),
                                                    context,
                                                    duration: 3);
                                              }
                                            } else {
                                              Toast.show(
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "toast7"),
                                                  context,
                                                  duration: 3);
                                            }
                                          } else {
                                            Toast.show(
                                                Dil().sec(
                                                    dilSecimi, "toast6"),
                                                context,
                                                duration: 3);
                                          }

                                          setState(() {});
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 50 * oran,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ),
                              //Atanan klepelerin gösterildiği bölüm
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: klepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  klepeAdet > 0 ? true : false,
                                              child: Text(
                                                "K1: X=$k1x , Y=$k1y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k1x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  klepeAdet > 5 ? true : false,
                                              child: Text(
                                                "K6: X=$k6x , Y=$k6y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k6x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: klepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  klepeAdet > 1 ? true : false,
                                              child: Text(
                                                "K2: X=$k2x , Y=$k2y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k2x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  klepeAdet > 6 ? true : false,
                                              child: Text(
                                                "K7: X=$k7x , Y=$k7y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k7x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: klepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  klepeAdet > 2 ? true : false,
                                              child: Text(
                                                "K3: X=$k3x , Y=$k3y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k3x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  klepeAdet > 7 ? true : false,
                                              child: Text(
                                                "K8: X=$k8x , Y=$k8y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k8x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: klepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  klepeAdet > 3 ? true : false,
                                              child: Text(
                                                "K4: X=$k4x , Y=$k4y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k4x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  klepeAdet > 8 ? true : false,
                                              child: Text(
                                                "K9: X=$k9x , Y=$k9y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k9x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: klepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  klepeAdet > 4 ? true : false,
                                              child: Text(
                                                "K5: X=$k5x , Y=$k5y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k5x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  klepeAdet > 9 ? true : false,
                                              child: Text(
                                                "K10: X=$k10x , Y=$k10y",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: k10x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  // Sayfa geçiş okları bölümü
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 15 * oran),
                      color: Colors.grey[600],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Spacer(
                            flex: 20,
                          ),
                          Expanded(
                              //geri OK
                              flex: 2,
                              child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                                              child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  iconSize: 50 * oran,
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KlpYontemi(dbVeriler,true)),
                                    );

                                    //Navigator.pop(context);
                                  },
                                  color: Colors.black,
                                ),
                              )),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                              //İleri OK
                              flex: 2,
                              child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                                              child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  iconSize: 50 * oran,
                                  onPressed: () {
                                    bool klepeTamam = true;
                                    bool aBos = false;
                                    bool bBos = false;
                                    bool cBos = false;
                                    bool tfdBos = false;
                                    bool bfdBos = false;
                                    bool hoBos = false;
                                    bool aTanimsiz = false;
                                    bool bTanimsiz = false;
                                    bool cTanimsiz = false;
                                    bool tfdTanimsiz = false;
                                    bool bfdTanimsiz = false;
                                    bool hoTanimsiz = false;
                                    double a;
                                    double b;
                                    double c;
                                    double tf;
                                    double bf;
                                    double ho;

                                    try {
                                      a = double.parse(aM);
                                    } catch (e) {
                                      aTanimsiz = true;
                                    }

                                    try {
                                      b = double.parse(bM);
                                    } catch (e) {
                                      bTanimsiz = true;
                                    }

                                    try {
                                      c = double.parse(cM);
                                    } catch (e) {
                                      cTanimsiz = true;
                                    }

                                    try {
                                      tf = double.parse(tunelFanDebi);
                                    } catch (e) {
                                      tfdTanimsiz = true;
                                    }

                                    try {
                                      bf = double.parse(bacaFanDebi);
                                    } catch (e) {
                                      if (bacaFanAdet > 0) {
                                        bfdTanimsiz = true;
                                      }
                                    }

                                    try {
                                      ho = double.parse(hacimOrani);
                                    } catch (e) {
                                      hoTanimsiz = true;
                                    }

                                    if (aM == "" || aM == null) {
                                      aBos = true;
                                    }

                                    if (bM == "" || bM == null) {
                                      bBos = true;
                                    }

                                    if (cM == "" || cM == null) {
                                      cBos = true;
                                    }

                                    if (tunelFanDebi == "" ||
                                        tunelFanDebi == null) {
                                      tfdBos = true;
                                    }

                                    if (bacaFanDebi == "" ||
                                        bacaFanDebi == null) {
                                      if (bacaFanAdet > 0) {
                                        bfdBos = true;
                                      }
                                    }

                                    if (hacimOrani == "" || hacimOrani == null) {
                                      hoBos = true;
                                    }

                                    if (klepeAdet > 0 && k1x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 1 && k2x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 2 && k3x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 3 && k4x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 4 && k5x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 5 && k6x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 6 && k7x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 7 && k8x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 8 && k9x == "0.0") {
                                      klepeTamam = false;
                                    } else if (klepeAdet > 9 && k10x == "0.0") {
                                      klepeTamam = false;
                                    }

                                    if (!klepeTamam) {
                                      Toast.show(
                                          Dil()
                                              .sec(dilSecimi, "toast9"),
                                          context,
                                          duration: 3);
                                    } else if (aBos || bBos || cBos) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast10"),
                                          context,
                                          duration: 3);
                                    } else if (tfdBos || bfdBos) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast11"),
                                          context,
                                          duration: 3);
                                    } else if (hoBos) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast12"),
                                          context,
                                          duration: 3);
                                    } else if (aTanimsiz ||
                                        bTanimsiz ||
                                        cTanimsiz) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast13"),
                                          context,
                                          duration: 3);
                                    } else if (tfdTanimsiz || bfdTanimsiz) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast14"),
                                          context,
                                          duration: 3);
                                    } else if (hoTanimsiz) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast15"),
                                          context,
                                          duration: 3);
                                    } else {

                                      Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FanHaritasi(dbVeriler,true)));

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
              ),
            ),
          ),
        ));
      },
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

  _textFieldCursorPosition(TextEditingController tec, String str) {
    tec
      ..text = str
      ..selection =
          TextSelection.collapsed(offset: str.length != null ? str.length : 0);
  }

//--------------------------METOTLAR--------------------------------

}
