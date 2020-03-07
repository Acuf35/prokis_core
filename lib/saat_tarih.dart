import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:prokis/dil_secimi.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:prokis/kurulum_ayarlari.dart';
import 'package:prokis/sistem.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/metotlar.dart';
import 'languages/select.dart';

class SaatTarih extends StatefulWidget {
  List<Map> gelenDBveri;
  SaatTarih(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SaatTarihState(gelenDBveri);
  }
}

class SaatTarihState extends State<SaatTarih> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  String yil="2020";
  String ayy="1";
  String gun="1";
  String sat="12";
  String dkk="30";

  String yil_fark="0";
  String ayy_fark="0";
  String gun_fark="0";
  String sat_fark="0";
  String dkk_fark="0";

  bool format24saatlik=true;
  bool tarihFormati1=true;
  bool tarihFormati2=false;

  bool baglanti = false;

  List<String> adet15 = [
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
    '2033',
    '2034',
    '2035'
  ];
  List<String> adet12 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  List<String> adet24 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];
  List<String> adet31 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];
  List<String> adet60 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60'
  ];

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SaatTarihState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 34) {
        format24saatlik = dbVeri[i]["veri1"] =="1" ? true: false;
        tarihFormati1 = dbVeri[i]["veri2"] =="1" ? true: false;
        tarihFormati2 = dbVeri[i]["veri3"] =="1" ? true: false;
      }

      if (dbVeri[i]["id"] == 35) {
        gun_fark = dbVeri[i]["veri1"];
        ayy_fark = dbVeri[i]["veri2"];
        yil_fark = dbVeri[i]["veri3"];
      }

      if (dbVeri[i]["id"] == 36) {
        sat_fark = dbVeri[i]["veri1"];
        dkk_fark = dbVeri[i]["veri2"];
      }
    }

    yil=(DateTime.now().year+int.parse(yil_fark)).toString();
    gun=(DateTime.now().day+int.parse(gun_fark)).toString();
    ayy=(DateTime.now().month+int.parse(ayy_fark)).toString();
    sat=int.parse(Metotlar().getSystemTime(dbVeri).split(":")[0]).toString();
    dkk=(DateTime.now().minute+int.parse(dkk_fark)).toString();


    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv403',Colors.grey[600]),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
        child: FittedBox(
                    child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Sistem(dbVeriler)),
              );
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
    
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(dbVeriler),
                            style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
              
              Expanded(
                              child: Container(alignment: Alignment.centerRight,color: Colors.grey[300],padding: EdgeInsets.only(right: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemDate(dbVeriler),
                            style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
            ],
          ),
          
          Expanded(
            flex: 40,
            child: Column(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      //GÜN
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv406"),
                            oran,
                            gun,
                            adet31,
                            3,2),
                      //AY
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv405"),
                            oran,
                            ayy,
                            adet12,
                            2,2),
                      //YIL
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv404"),
                            oran,
                            yil,
                            adet15,
                            1,3),
                            Padding(
                              padding: EdgeInsets.only(top: 10*oran,bottom: 10*oran),
                              child: Container(width: 2,color: Colors.black,),
                            ),
                      //SAAT
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv407"),
                            oran,
                            sat,
                            format24saatlik ? adet24 : adet12,
                            4,2),
                      //DAKİKA
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv408"),
                            oran,
                            dkk,
                            adet60,
                            5,2),
                      
                    ],
                  ),
                ),
                Spacer(flex: 1,),
                Expanded(flex: 4,child: Container(color: Colors.yellow,
                child: Row(
                  children: <Widget>[
                    Expanded(flex: 7,
                                          child: RawMaterialButton(
                            onPressed: () {

                              
                              gun_fark=(int.parse(gun)-DateTime.now().day).toString();
                              ayy_fark=(int.parse(ayy)-DateTime.now().month).toString();
                              yil_fark=(int.parse(yil)-DateTime.now().year).toString();
                              dbHelper.veriYOKSAekleVARSAguncelle(35, gun_fark, ayy_fark, yil_fark, "0").then((value) => _dbVeriCekme());
                              _veriGonder("17*$gun*$ayy*$yil*$sat*$dkk");
                              setState(() {});
                              
                            },
                            fillColor: Colors.green[300],
                            child: Padding(
                              padding: EdgeInsets.all(3.0 * oran),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv413"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
                    Container(color: Colors.black,width: 2,),
                    Expanded(flex: 4,
                                          child: RawMaterialButton(
                            onPressed: () {

                              
                              sat_fark=(int.parse(sat)-DateTime.now().hour).toString();
                              dkk_fark=(int.parse(dkk)-DateTime.now().minute).toString();
                              dbHelper.veriYOKSAekleVARSAguncelle(36, sat_fark, dkk_fark, "0", "0").then((value) => _dbVeriCekme());
                              _veriGonder("17*$gun*$ayy*$yil*$sat*$dkk");
                              setState(() {});
                              
                            },
                            fillColor: Colors.green[300],
                            child: Padding(
                              padding: EdgeInsets.all(3.0 * oran),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv412"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
                ),),
                Spacer(flex: 1,),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Expanded(flex: 2,child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv409"),textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold),
                                            textScaleFactor: oran,
                                          ),
                                          RawMaterialButton(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              if (!format24saatlik) {
                                                format24saatlik = true;
                                                sat=(int.parse(sat)+12).toString();
                                              } else {
                                                format24saatlik = false;
                                                sat=(int.parse(sat)-12).toString();
                                              }
                                              String v1=format24saatlik ? "1" : "0";
                                              String v2=tarihFormati1 ? "1" : "0";
                                              String v3=tarihFormati2 ? "1" : "0";
                                               dbHelper.veriYOKSAekleVARSAguncelle(34, v1, v2, v3, "0").then((value) => _dbVeriCekme());
                                              setState(() {});
                                            },
                                            child: Icon(
                                                format24saatlik == true
                                                    ? Icons.check_box
                                                    : Icons.check_box_outline_blank,
                                                color: format24saatlik == true
                                                    ? Colors.green.shade500
                                                    : Colors.black,
                                                size: 30 * oran),
                                          ),
                                        ],
                                      ),
                              ),
                      Expanded(flex: 2,child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv410"),textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold),
                                            textScaleFactor: oran,
                                          ),
                                          RawMaterialButton(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              if (!tarihFormati1) {
                                                tarihFormati1 = true;
                                                tarihFormati2 = false;
                                              }
                                              String v1=format24saatlik ? "1" : "0";
                                              String v2=tarihFormati1 ? "1" : "0";
                                              String v3=tarihFormati2 ? "1" : "0";
                                               dbHelper.veriYOKSAekleVARSAguncelle(34, v1, v2, v3, "0").then((value) => _dbVeriCekme());
                                              setState(() {});
                                            },
                                            child: Icon(
                                                tarihFormati1 == true
                                                    ? Icons.check_box
                                                    : Icons.check_box_outline_blank,
                                                color: tarihFormati1 == true
                                                    ? Colors.green.shade500
                                                    : Colors.black,
                                                size: 30 * oran),
                                          ),
                                        ],
                                      ),
                              ),
                      Expanded(flex: 2,child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv411"),textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold),
                                            textScaleFactor: oran,
                                          ),
                                          RawMaterialButton(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              if (!tarihFormati2) {
                                                tarihFormati2 = true;
                                                tarihFormati1 = false;
                                              }
                                              String v1=format24saatlik ? "1" : "0";
                                              String v2=tarihFormati1 ? "1" : "0";
                                              String v3=tarihFormati2 ? "1" : "0";
                                               dbHelper.veriYOKSAekleVARSAguncelle(34, v1, v2, v3, "0").then((value) => _dbVeriCekme());
                                              setState(() {});
                                            },
                                            child: Icon(
                                                tarihFormati2 == true
                                                    ? Icons.check_box
                                                    : Icons.check_box_outline_blank,
                                                color: tarihFormati2 == true
                                                    ? Colors.green.shade500
                                                    : Colors.black,
                                                size: 30 * oran),
                                          ),
                                        ],
                                      ),
                              ),
                      Spacer(),      
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      )
      );
  }

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


Widget _unsurAdetWidget(String baslik, double oran,
      String dropDownValue, List<String> liste, int adetCode,int flexValue) {
    return Expanded(flex: flexValue,
      child: Column(
        children: <Widget>[
          Spacer(),
          Expanded(
            child: SizedBox(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: AutoSizeText(
                  baslik,
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Spacer(),
              Container(
                color: Colors.grey[300],
                child: DropdownButton<String>(
                  isDense: true,
                  value: dropDownValue,
                  elevation: 16,
                  iconEnabledColor: Colors.black,
                  iconSize: 40 * oran,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Audio Wide',
                    fontSize: 25 * oran,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  onChanged: (String newValue) {
                    if (adetCode == 1) {
                      yil = newValue;
                    } else if (adetCode == 2) {
                      ayy = newValue;
                    } else if (adetCode == 3) {
                      gun = newValue;
                    } else if (adetCode == 4) {
                      sat = newValue;
                    } else if (adetCode == 5) {
                      dkk = newValue;
                    }

                    /*
                    if (adetCode < 5) {
                      _veriGonder(
                          "2", "4", fanAdet, klepeAdet, pedAdet, isiSensAdet);
                      dbHelper.veriYOKSAekleVARSAguncelle(
                          4, fanAdet, klepeAdet, pedAdet, isiSensAdet+ (wifiOlcum==true ? "#1" : "#2")).then((onValue){
                            _dbVeriCekme();
                          });
                    } else {
                      _veriGonder("3", "6", bacafanAdet, airinletAdet,
                          isiticiAdet, siloAdet);
                      dbHelper.veriYOKSAekleVARSAguncelle(5, bacafanAdet,
                          airinletAdet, isiticiAdet, siloAdet).then((onValue){
                            _dbVeriCekme();
                          });
                    }

                    */

                    setState(() {});
                  },
                  items: liste.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        child: Text(value),
                        padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }


}
