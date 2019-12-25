import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'adetler.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';

class KumesOlustur extends StatefulWidget {
  String gelenDil;
  KumesOlustur(String dil) {
    gelenDil = dil;
  }

  @override
  State<StatefulWidget> createState() {
    return KumesOlusturState(gelenDil);
  }
}

class KumesOlusturState extends State<KumesOlustur> {
  String gelenDil;
  KumesOlusturState(String dil) {
    gelenDil = dil;
  }
//++++++++++++++++++++++++++DATABASE ve DİĞER DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
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
  String sifreTekrar = "";
  bool sifreUyusma = false;
  bool sifreOnaylandi = false;

//--------------------------DATABASE ve DİĞER DEĞİŞKENLER--------------------------------

  @override
  Widget build(BuildContext context) {
    if (sayacFirstCycle == 0) {
      kumesTuru = SelectLanguage().selectStrings(gelenDil, "dd1");
      sayacFirstCycle++;
    }

    dilSecimi = gelenDil;
    var tec1 = new TextEditingController(text: kumesIsmi);

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
                      SelectLanguage().selectStrings(dilSecimi, "tv2"),
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.grey.shade600,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textScaleFactor: oran,
                    ),
                    alignment: Alignment.center,
                  )),
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
                                        SelectLanguage().selectStrings(
                                            dilSecimi, "tv3"), //Kümes Türü
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        textScaleFactor: oran,
                                      ),
                                      Container(
                                        height: 5 * oran,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: DropdownButton<String>(
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
                                          underline: Container(
                                            height: 1,
                                            color: Colors.grey.shade600,
                                          ),
                                          onChanged: (String newValue) {
                                            kumesTuru = newValue;
                                            if (kumesTuru ==
                                                SelectLanguage().selectStrings(
                                                    dilSecimi, "dd1")) {
                                              kumesTuruIndex = 1;
                                            } else if (kumesTuru ==
                                                SelectLanguage().selectStrings(
                                                    dilSecimi, "dd2")) {
                                              kumesTuruIndex = 2;
                                            } else if (kumesTuru ==
                                                SelectLanguage().selectStrings(
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
                                            SelectLanguage().selectStrings(
                                                dilSecimi, "dd1"),
                                            SelectLanguage().selectStrings(
                                                dilSecimi, "dd2"),
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "dd3")
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
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv4"),
                                        textScaleFactor: oran,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        height: 5 * oran,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: DropdownButton<String>(
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
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv5"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textScaleFactor: oran,
                                      ),
                                      TextField(
                                        style: TextStyle(
                                            backgroundColor: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Audio wide'),
                                        textAlign: TextAlign.center,
                                        cursorColor: Colors.pink,
                                        maxLength: 15,
                                        controller: tec1,
                                        onChanged: (String metin) {
                                          kumesIsmi = metin;
                                        },
                                        onEditingComplete: () {

                                          if (kumesIsmi.length < 4) {
                                          //Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!
                                          Toast.show(
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast1"),
                                              context,
                                              duration: 2);
                                        }else{
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
                                          }
                                        },
                                        decoration: InputDecoration(
                                          counterStyle: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontFamily: 'Kelly Slab'),
                                          hintText: SelectLanguage()
                                              .selectStrings(dilSecimi, "tv6"),
                                          hintStyle: TextStyle(
                                              fontSize: 14 * oran,
                                              backgroundColor:
                                                  Colors.grey.shade400,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            SelectLanguage().selectStrings(
                                                dilSecimi, "tv8"),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textScaleFactor: oran,
                                          ),
                                          TextField(
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
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              counterStyle: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 12 * oran),
                                              hintText: SelectLanguage()
                                                  .selectStrings(
                                                      dilSecimi, "tv7"),
                                              hintStyle: TextStyle(
                                                  fontSize: 12 * oran,
                                                  backgroundColor:
                                                      Colors.grey.shade400,
                                                  fontFamily: 'Kelly Slab'),
                                            ),
                                          ),
                                        ],
                                      )),
                                  IconButton(
                                    icon: Icon(sifreGor1 == false
                                        ? Icons.lock_outline
                                        : Icons.lock_open),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            SelectLanguage().selectStrings(
                                                dilSecimi, "tv10"),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textScaleFactor: oran,
                                          ),
                                          TextField(
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
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              counterStyle: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 12 * oran),
                                              hintText: SelectLanguage()
                                                  .selectStrings(
                                                      dilSecimi, "tv9"),
                                              hintStyle: TextStyle(
                                                  fontSize: 12 * oran,
                                                  backgroundColor:
                                                      Colors.grey.shade400,
                                                  fontFamily: 'Kelly Slab'),

                                            ),
                                          ),
                                        ],
                                      )),
                                  IconButton(
                                    icon: Icon(sifreGor2 == false
                                        ? Icons.lock_outline
                                        : Icons.lock_open),
                                    onPressed: () {
                                      sifreGor2 == true
                                          ? sifreGor2 = false
                                          : sifreGor2 = true;
                                      setState(() {});
                                    },
                                    iconSize: 20,
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
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast3"),
                                              context,
                                              duration: 2);
                                        }else if (adminSifreLimit1 != 0) {
                                          //Lütfen 4 karakterlik bir şifre belirleyiniz!
                                          Toast.show(
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast2"),
                                              context,
                                              duration: 2);
                                        }else{


                                          _veriGonderSifre(
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
                                            
                                          

                                        }


                                          },
                                          fillColor: sifreOnaylandi ? Colors.green.shade400 : Colors.blue[300],
                                          child: Padding(
                                            padding: EdgeInsets.all(3.0 * oran),
                                            child: Text(
                                              SelectLanguage().selectStrings(dilSecimi, "btn1"),
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
                                          SelectLanguage().selectStrings(dilSecimi, "tv36"),
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
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      iconSize: 50 * oran,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: Colors.black,
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                //ileri OK
                                Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      iconSize: 50 * oran,
                                      onPressed: () {
                                        if (kumesIsmi.length < 4) {
                                          //Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!
                                          Toast.show(
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast1"),
                                              context,
                                              duration: 2);
                                        } else if (adminSifreLimit1 != 0) {
                                          //Lütfen 4 karakterlik bir şifre belirleyiniz!
                                          Toast.show(
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast2"),
                                              context,
                                              duration: 2);
                                        } else if (!sifreUyusma) {
                                          //Şifreler uyuşmuyor!
                                          Toast.show(
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast3"),
                                              context,
                                              duration: 2);
                                        }else if(!sifreOnaylandi){
                                          //Girilen Şifreyi onaylamadınız!
                                          Toast.show(
                                              SelectLanguage().selectStrings(
                                                  dilSecimi, "toast19"),
                                              context,
                                              duration: 2);


                                        } else {

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Adetler(dilSecimi)));
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

    for(int i=0;i<=dbSatirSayisi-1;i++){
      if(satirlar[i]["id"]==0){
        dilSecimi = satirlar[i]["veri1"];
      }

      if(satirlar[i]["id"]==1){
        kurulumDurum = satirlar[i]["veri1"];
      }

      if(satirlar[i]["id"]==3){
          satirlar[i]["veri1"] == "1"
            ? kumesTuru = SelectLanguage().selectStrings(dilSecimi, "dd1")
            : satirlar[i]["veri1"] == "2"
                ? kumesTuru = SelectLanguage().selectStrings(dilSecimi, "dd2")
                : satirlar[i]["veri1"] == "3"
                    ? kumesTuru = SelectLanguage().selectStrings(dilSecimi, "dd3")
                    : kumesTuru =
                        SelectLanguage().selectStrings(dilSecimi, "dd3");
        satirlar[i]["veri1"] == "1"
            ? kumesTuruIndex = 1
            : satirlar[i]["veri1"] == "2"
                ? kumesTuruIndex = 2
                : satirlar[i]["veri1"] == "3" ? kumesTuruIndex = 3 : 3;

        kumesNo = satirlar[i]["veri2"];
        kumesIsmi = satirlar[i]["veri3"];
        sifreAna = satirlar[i]["veri4"];
      }
  }
  
    setState(() {});
  }

  _languageClick(BuildContext context) {
    dbHelper.veriYOKSAekleVARSAguncelle(1, dilSecimi, "0", "0", "0");
  }

   _veriGonder(String id, String v1, String v2, String v3, String v4) async {
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
          Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast8"), context, duration: 2);
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
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

  _veriGonderSifre(String id, String v1, String v2, String v3, String v4) async {
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
          Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast21"), context, duration: 2);
          sifreOnaylandi=true;
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
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

//--------------------------METOTLAR--------------------------------

}
