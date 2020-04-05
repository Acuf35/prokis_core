import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/dil_secimi.dart';
import 'package:toast/toast.dart';
import 'adetler.dart';
import 'genel/database_helper.dart';
import 'genel/sayfa_geri_alert.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class TemelAyarlar extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  TemelAyarlar(List<Map> dbVeriler, bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum =durum;
  }

  @override
  State<StatefulWidget> createState() {
    return TemelAyarlarState(gelenDBveri,gelenDurum);
  }
}

class TemelAyarlarState extends State<TemelAyarlar> {
//++++++++++++++++++++++++++DATABASE ve DİĞER DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int sayacFirstCycle = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  String kumesTuru;
  int kumesTuruIndex;
  String kumesNo = "1";
  int kumesIsimLimit = 15;
  int adminSifreLimit1 = 4;
  int adminSifreLimit2 = 4;
  bool sifreGor1 = false;
  bool sifreGor2 = false;

  String kumesIsmi = "";
  String sifreAna = "";
  String sifreAnaGecici = "";
  String sifreTekrar = "";
  String sifreTekrarGecici = "";
  bool sifreUyusma = false;
  bool sifreOnaylandi = false;

  final FocusNode _focusNodeKumesIsmi = FocusNode();

  bool durum;
  

//--------------------------DATABASE ve DİĞER DEĞİŞKENLER--------------------------------

  @override
  void initState() {
    // TODO: implement initState
    _focusNodeKumesIsmi.addListener(() {
      if (!_focusNodeKumesIsmi.hasFocus) {
        if (kumesIsmi.length < 4) {
          //Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!
          Toast.show(
              Dil().sec(dilSecimi, "toast1"), context,
              duration: 2);
        } else {
          _veriGonder(
              "2", kumesTuruIndex.toString(), kumesNo, kumesIsmi, sifreAna);

          dbHelper.veriYOKSAekleVARSAguncelle(
              3, kumesTuruIndex.toString(), kumesNo, kumesIsmi, sifreAna);
        }
      }
    });
    
    super.initState();
  }

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  TemelAyarlarState(List<Map> dbVeri,bool drm) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 3) {
        dbVeri[i]["veri1"] == "1"
            ? kumesTuru = Dil().sec(dilSecimi, "dd1")
            : dbVeri[i]["veri1"] == "2"
                ? kumesTuru = Dil().sec(dilSecimi, "dd2")
                : dbVeri[i]["veri1"] == "3"
                    ? kumesTuru =
                        Dil().sec(dilSecimi, "dd3")
                    : kumesTuru =
                        Dil().sec(dilSecimi, "dd3");
        dbVeri[i]["veri1"] == "1"
            ? kumesTuruIndex = 1
            : dbVeri[i]["veri1"] == "2"
                ? kumesTuruIndex = 2
                : dbVeri[i]["veri1"] == "3"
                    ? kumesTuruIndex = 3
                    : kumesTuruIndex = 3;

        kumesNo = dbVeri[i]["veri2"];
        kumesIsmi = dbVeri[i]["veri3"];
        sifreAna = dbVeri[i]["veri4"];
        sifreAnaGecici = dbVeri[i]["veri4"];
        sifreTekrar = dbVeri[i]["veri4"];
        sifreTekrarGecici = dbVeri[i]["veri4"];
        sifreOnaylandi=true;
        sifreUyusma=true;
        adminSifreLimit1=0;
        adminSifreLimit2=0;
      }
    }

    if (dbVeri.length < 3) {
      kumesTuru = Dil().sec(dilSecimi, "dd1");
      kumesTuruIndex=1;
    }

    print("dbVeri uzunluğu: ");
    print(dbVeri.length);
    print(kumesTuru);
    print(kumesNo);
    print(kumesIsmi);

    durum=drm;

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

    TextEditingController tec1 = new TextEditingController(text: kumesIsmi);
    TextEditingController tec2 = new TextEditingController(text: sifreAna);
    TextEditingController tec3 = new TextEditingController(text: sifreTekrar);

    _textFieldCursorPosition(tec1, kumesIsmi);
    _textFieldCursorPosition(tec2, sifreAna);
    _textFieldCursorPosition(tec3, sifreTekrar);

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold(
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
                    child: Text(
                      Dil().sec(dilSecimi, "tv2"),
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.grey.shade600,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                      textScaleFactor: oran,
                    ),
                    alignment: Alignment.center,
                  ),),
                  // Ayarlar Bölümü
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.grey.shade600,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          //Kümes Türü ve Kümes No Bölümü
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                //Kümes Türü Bölümü
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(
                                            dilSecimi, "tv3"), //Kümes Türü
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[300]),
                                        textScaleFactor: oran,
                                      ),
                                      Container(
                                        height: 5 * oran,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          value: kumesTuru,
                                          elevation: 16,
                                          iconEnabledColor: Colors.black,
                                          iconSize: 40 * oran,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: 'Audio Wide',
                                            fontSize: 20 * oran,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          onChanged: (String newValue) {
                                            kumesTuru = newValue;
                                            if (kumesTuru ==
                                                Dil().sec(
                                                    dilSecimi, "dd1")) {
                                              kumesTuruIndex = 1;
                                            } else if (kumesTuru ==
                                                Dil().sec(
                                                    dilSecimi, "dd2")) {
                                              kumesTuruIndex = 2;
                                            } else if (kumesTuru ==
                                                Dil().sec(
                                                    dilSecimi, "dd3")) {
                                              kumesTuruIndex = 3;
                                            }

                                            _veriGonder(
                                                "2",
                                                kumesTuruIndex.toString(),
                                                kumesNo,
                                                kumesIsmi,
                                                sifreAna);

                                            dbHelper.veriYOKSAekleVARSAguncelle(
                                                3,
                                                kumesTuruIndex.toString(),
                                                kumesNo,
                                                kumesIsmi,
                                                sifreAna);

                                            setState(() {});
                                          },
                                          items: <String>[
                                            Dil().sec(
                                                dilSecimi, "tv627"),
                                            Dil().sec(
                                                dilSecimi, "dd1"),
                                            Dil().sec(
                                                dilSecimi, "dd2"),
                                            Dil()
                                                .sec(dilSecimi, "dd3")
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Container(
                                                child: Text(value),
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 0,
                                                    top: 0),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Kümes No Bölümü
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        Dil()
                                            .sec(dilSecimi, "tv4"),
                                        textScaleFactor: oran,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[300]),
                                      ),
                                      Container(
                                        height: 5 * oran,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: DropdownButton<String>(
                                        
                                          isDense: true,
                                          value: kumesNo,
                                          elevation: 16,
                                          iconEnabledColor: Colors.black,
                                          iconSize: 40 * oran,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontFamily: 'Audio Wide',
                                            fontSize: 30 * oran,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          underline: Container(
                                            height: 1,
                                            color: Colors.grey.shade600,
                                          ),
                                          onChanged: (String newValue) {
                                            kumesNo = newValue;
                                            _veriGonder(
                                                "2",
                                                kumesTuruIndex.toString(),
                                                kumesNo,
                                                kumesIsmi,
                                                sifreAna);
                                            setState(() {});

                                            dbHelper.veriYOKSAekleVARSAguncelle(
                                                3,
                                                kumesTuruIndex.toString(),
                                                kumesNo,
                                                kumesIsmi,
                                                sifreAna);
                                          },
                                          items: <String>[
                                            "1",
                                            "2",
                                            "3",
                                            "4",
                                            "5",
                                            "6",
                                            "7",
                                            "8",
                                            "9",
                                            "10"
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: SizedBox(
                                                  width: 50 * oran,
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.center,
                                                  )),
                                            );
                                          }).toList(),

                                        
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Kümes Adı Bölümü
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        Dil()
                                            .sec(dilSecimi, "tv5"),
                                        style: TextStyle(
                                            color: Colors.grey.shade300,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textScaleFactor: oran,
                                      ),
                                      TextField(
                                        focusNode: _focusNodeKumesIsmi,
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontSize: 22 * oran,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Audio wide'),
                                        textAlign: TextAlign.center,
                                        cursorColor: Colors.pink,
                                        maxLength: 15,
                                        controller: tec1,
                                        onChanged: (String metin) {
                                          kumesIsmi = metin;
                                        },
                                        onSubmitted: (metin) {
                                          _focusNodeKumesIsmi.unfocus();
                                        },
                                        
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              bottom: 2 * oran, top: 5 * oran),
                                          isDense: true,
                                          counterStyle: TextStyle(
                                              fontSize: 14 * oran,
                                              color: Colors.grey.shade300,
                                              fontFamily: 'Kelly Slab'),
                                          hintText: Dil()
                                              .sec(dilSecimi, "tv6"),
                                          hintStyle: TextStyle(
                                              fontSize: 14 * oran,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              fontFamily: 'Kelly Slab'),
                                        ),
                                      ),
                                    ],
                                  )),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          )),
                          //Yetki şifresi bölümü
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              //Admin Şifresi
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(
                                                dilSecimi, "tv8"),
                                            style: TextStyle(
                                                color: Colors.grey[300],
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textScaleFactor: oran,
                                          ),
                                          TextField(
                                            controller: tec2,
                                            style: TextStyle(
                                                fontFamily: 'Audio wide',
                                                color: Colors.white,
                                                fontSize: 20 * oran),
                                            textAlign: TextAlign.center,
                                            maxLength: 4,
                                            keyboardType: TextInputType.number,
                                            obscureText: sifreGor1 == true
                                                ? false
                                                : true,
                                            onChanged: (String metin) {


                                              adminSifreLimit1 =
                                                  4 - metin.length;
                                              sifreAna = metin;
                                              if (sifreAna != "" &&
                                                  sifreAna == sifreTekrar) {
                                                sifreUyusma = true;
                                              } else {
                                                sifreUyusma = false;
                                              }

                                              if(sifreAna==sifreTekrar && sifreAna!=sifreAnaGecici){
                                                sifreOnaylandi=false;
                                              }

                                              if(sifreAna==sifreTekrar && sifreAna==sifreAnaGecici){
                                                sifreOnaylandi=true;
                                              }



                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                  bottom: 3 * oran,
                                                  top: 3 * oran),
                                              counterStyle: TextStyle(
                                                  color: Colors.grey.shade300,
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 12 * oran),
                                              hintText: Dil()
                                                  .sec(
                                                      dilSecimi, "tv7"),
                                              hintStyle: TextStyle(
                                                  fontSize: 12 * oran,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  fontFamily: 'Kelly Slab'),
                                            ),
                                          ),
                                        ],
                                      )),
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(sifreGor1 == false
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      sifreGor1 == true
                                          ? sifreGor1 = false
                                          : sifreGor1 = true;
                                      setState(() {});
                                    },
                                    iconSize: 20 * oran,
                                  )
                                ],
                              ),
                              //Admin şifresi tekrar
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(
                                                dilSecimi, "tv10"),
                                            style: TextStyle(
                                                color: Colors.grey[300],
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textScaleFactor: oran,
                                          ),
                                          TextField(
                                            controller: tec3,
                                            style: TextStyle(
                                                fontFamily: 'Audio wide',
                                                color: Colors.white,
                                                fontSize: 20 * oran),
                                            textAlign: TextAlign.center,
                                            maxLength: 4,
                                            keyboardType: TextInputType.number,
                                            obscureText: sifreGor2 == true
                                                ? false
                                                : true,
                                            onChanged: (String metin) {
                                              adminSifreLimit2 =
                                                  4 - metin.length;
                                              sifreTekrar = metin;
                                              if (sifreAna != "" &&
                                                  sifreAna == sifreTekrar) {
                                                sifreUyusma = true;
                                              } else {
                                                sifreUyusma = false;
                                              }

                                              if(sifreAna==sifreTekrar && sifreTekrar!=sifreTekrarGecici){
                                                sifreOnaylandi=false;
                                              }

                                              if(sifreAna==sifreTekrar && sifreTekrar==sifreTekrarGecici){
                                                sifreOnaylandi=true;
                                              }


                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                  bottom: 3 * oran,
                                                  top: 3 * oran),
                                              counterStyle: TextStyle(
                                                  color: Colors.grey.shade300,
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 12 * oran),
                                              hintText: Dil()
                                                  .sec(
                                                      dilSecimi, "tv9"),
                                              hintStyle: TextStyle(
                                                  fontSize: 12 * oran,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  fontFamily: 'Kelly Slab'),
                                            ),
                                          ),
                                        ],
                                      )),
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(sifreGor2 == false
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      sifreGor2 == true
                                          ? sifreGor2 = false
                                          : sifreGor2 = true;
                                      setState(() {});
                                    },
                                    iconSize: 20 * oran,
                                  )
                                ],
                              ),
                              //Şifreleri kontrol
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(3 * oran),
                                      child: Visibility(
                                        visible: sifreUyusma,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        maintainSize: true,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            if (!sifreUyusma) {
                                              //Şifreler uyuşmuyor!
                                              Toast.show(
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "toast3"),
                                                  context,
                                                  duration: 2);
                                            } else if (adminSifreLimit1 != 0) {
                                              //Lütfen 4 karakterlik bir şifre belirleyiniz!
                                              Toast.show(
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "toast2"),
                                                  context,
                                                  duration: 2);
                                                  
                                            } else {
                                              _veriGonderSifre(
                                                  "2",
                                                  kumesTuruIndex.toString(),
                                                  kumesNo,
                                                  kumesIsmi,
                                                  sifreAna);

                                              setState(() {});

                                              dbHelper
                                                  .veriYOKSAekleVARSAguncelle(
                                                      3,
                                                      kumesTuruIndex.toString(),
                                                      kumesNo,
                                                      kumesIsmi,
                                                      sifreAna);
                                            }
                                          },
                                          fillColor: sifreOnaylandi
                                              ? Colors.green.shade400
                                              : Colors.blue[300],
                                          child: Padding(
                                            padding: EdgeInsets.all(3.0 * oran),
                                            child: Text(
                                              Dil().sec(
                                                  dilSecimi, "btn1"),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                              textScaleFactor: oran,
                                            ),
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          Dil()
                                              .sec(dilSecimi, "tv36"),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Kelly Slab',
                                              fontSize: 12),
                                          textScaleFactor: oran,
                                        ),
                                        Icon(
                                          sifreUyusma == true
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: sifreUyusma == true
                                              ? Colors.green.shade400
                                              : Colors.red,
                                          size: 17 * oran,
                                        ),
                                      ],
                                    ),
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
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Spacer(
                                  flex: 20,
                                ),
                                //geri OK
                                Expanded(
                                    flex: 2,
                                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                                                          child: IconButton(
                                        icon: Icon(Icons.arrow_back_ios),
                                        iconSize: 50*oran,
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DilSecimi(dbVeriler,true)));
                                          
                                          
                                        },
                                        color: Colors.black,
                                      ),
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                //ileri OK
                                Expanded(
                                    flex: 2,
                                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                                                          child: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          iconSize: 50 * oran,
                                          onPressed: () {
                                            if (kumesIsmi.length < 4) {
                                              //Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!
                                              Toast.show(
                                                  Dil().sec(
                                                      dilSecimi, "toast1"),
                                                  context,
                                                  duration: 2);
                                            } else if (adminSifreLimit1 != 0) {
                                              //Lütfen 4 karakterlik bir şifre belirleyiniz!
                                              Toast.show(
                                                  Dil().sec(
                                                      dilSecimi, "toast2"),
                                                  context,
                                                  duration: 2);
                                                  
                                            } else if (!sifreUyusma) {
                                              //Şifreler uyuşmuyor!
                                              Toast.show(
                                                  Dil().sec(
                                                      dilSecimi, "toast3"),
                                                  context,
                                                  duration: 2);
                                            } else if (!sifreOnaylandi) {
                                              //Girilen Şifreyi onaylamadınız!
                                              Toast.show(
                                                  Dil().sec(
                                                      dilSecimi, "toast19"),
                                                  context,
                                                  duration: 2);
                                            } else {

                                              Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Adetler(dbVeriler,true)));
                                              

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
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  if(sifreOnaylandi){

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                      );

                  }else{
                    _sayfaGeriAlert(dilSecimi,"tv563");
                  }


                },
                backgroundColor: Colors.grey[700],
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
    ),

        
        );
      
        
    
      
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

  _veriGonder(String id, String v1, String v2, String v3, String v4) async {
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

      socket.add(utf8.encode('1*$id*$v1*$v2*$v3*$v4'));

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

  _veriGonderSifre(
      String id, String v1, String v2, String v3, String v4) async {
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
              Dil().sec(dilSecimi, "toast21"), context,
              duration: 2);
          sifreOnaylandi = true;
          sifreAnaGecici=sifreAna;
          sifreTekrarGecici=sifreTekrar;
        } else {
          Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
        }

        setState(() {});
      });

      socket.add(utf8.encode('1*$id*$v1*$v2*$v3*$v4'));

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

  _textFieldCursorPosition(TextEditingController tec, String str){
    tec..text = str
                    ..selection = TextSelection.collapsed(offset: str.length!=null ? str.length : 0 );
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
