import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'fan_yontemi.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'kumes_olustur.dart';
import 'languages/select.dart';

class Adetler extends StatefulWidget {
  List<Map> gelenDBveri;
  Adetler(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return AdetlerState(gelenDBveri);
  }
}

class AdetlerState extends State<Adetler> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String fanAdet = "1";
  String klepeAdet = "1";
  String pedAdet = "1";
  String isiSensAdet = "1";
  String bacafanAdet = "0";
  String airinletAdet = "0";
  String isiticiAdet = "0";
  String siloAdet = "0";

  bool wifiOlcum = false;
  bool analogOlcum = true;

  List<String> adet2 = ['0', '1', '2'];
  List<String> adet3 = ['0', '1', '2', '3'];
  List<String> adet4 = ['0', '1', '2', '3', '4'];
  List<String> adet10 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  List<String> adet15 = [
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
    '15'
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
  AdetlerState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {

        fanAdet = dbVeri[i]["veri1"];
        klepeAdet = dbVeri[i]["veri2"];
        pedAdet = dbVeri[i]["veri3"];
        var xx=dbVeri[i]["veri4"].split('#');
        print(xx);
        isiSensAdet = xx[0];
        wifiOlcum = xx[1]=="1" ? true : false;
        analogOlcum = xx[1]=="2" ? true : false;
        
        
      }

      if (dbVeri[i]["id"] == 5) {
        bacafanAdet = dbVeri[i]["veri1"];
        airinletAdet = dbVeri[i]["veri2"];
        isiticiAdet = dbVeri[i]["veri3"];
        siloAdet = dbVeri[i]["veri4"];
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
        body: Column(
      children: <Widget>[
        //Başlık Bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Column(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      Dil().sec(dilSecimi, "tv11"),
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
              Spacer(
                flex: 2,
              )
            ],
          ),
          alignment: Alignment.center,
        )),

        //Kontrol elemanları bölümü
        Expanded(
          flex: 2,
          child: Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  //Fan Sayısı ve Klepe Sayısı Bölümü
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //Fan Sayısı
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv12"),
                            'assets/images/kurulum_fan_icon.png',
                            oran,
                            fanAdet,
                            adet60,
                            1),
                        //Klepe Sayısı
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv13"),
                            'assets/images/kurulum_klepe_icon.png',
                            oran,
                            klepeAdet,
                            adet10,
                            2),
                      ],
                    ),
                  ),
                  //Ped pompa Sayisi ve ısı sensor sayısı bölümü
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //Ped Pompa
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv14"),
                            'assets/images/kurulum_ped_icon.png',
                            oran,
                            pedAdet,
                            adet10,
                            3),
                        //Isı Sensör
                        _unsurAdetWidgetIsiSens(
                            Dil().sec(dilSecimi, "tv15"),
                            'assets/images/kurulum_isisensor_icon.png',
                            oran,
                            isiSensAdet,
                            wifiOlcum ==true ? adet15 : adet10,
                            4),
                      ],
                    ),
                  ),
                  //Bacafan Sayısı ve Air inlet Motor sayısı
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //Bacafan
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv16"),
                            'assets/images/kurulum_bacafan_icon.png',
                            oran,
                            bacafanAdet,
                            adet3,
                            5),
                        //Air inlet
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv17"),
                            'assets/images/kurulum_airinlet_icon.png',
                            oran,
                            airinletAdet,
                            adet2,
                            6),
                      ],
                    ),
                  ),
                  //Isıtıcı Sayısı ve Silo Sayısı
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //Isıtıcı
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv18"),
                            'assets/images/kurulum_isitici_icon.png',
                            oran,
                            isiticiAdet,
                            adet3,
                            7),
                        //Silo
                        _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv19"),
                            'assets/images/kurulum_silo_icon.png',
                            oran,
                            siloAdet,
                            adet4,
                            8),
                      ],
                    ),
                  ),
                ],
              )),
        ),

        //ileri ve geri ok bölümü
        Expanded(
          child: Container(
            color: Colors.grey.shade600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Spacer(
                  flex: 20,
                ),
                //geri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => KumesOlustur(dbVeriler)),
                          //MaterialPageRoute(builder: (context) => UzDebiNem(dbVeriler)),
                        );
                        
                        //Navigator.pop(context);
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

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FanYontemi(dbVeriler)),
                        );


                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FanYontemi(dbVeriler)),
                        ).then((onValue) {
                          _dbVeriCekme();
                        });
                        */

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

      print('connected');

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

  Widget _unsurAdetWidget(String baslik, String imagePath, double oran,
      String dropDownValue, List<String> liste, int adetCode) {
    return Expanded(
      child: Column(
        children: <Widget>[
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
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 5,
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
                      fontSize: 30 * oran,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      if (adetCode == 1) {
                        fanAdet = newValue;
                      } else if (adetCode == 2) {
                        klepeAdet = newValue;
                      } else if (adetCode == 3) {
                        pedAdet = newValue;
                      } else if (adetCode == 4) {
                        isiSensAdet = newValue;
                      } else if (adetCode == 5) {
                        bacafanAdet = newValue;
                      } else if (adetCode == 6) {
                        airinletAdet = newValue;
                      } else if (adetCode == 7) {
                        isiticiAdet = newValue;
                      } else if (adetCode == 8) {
                        siloAdet = newValue;
                      }
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
          ),
        ],
      ),
    );
  }

  Widget _unsurAdetWidgetIsiSens(String baslik, String imagePath, double oran,
      String dropDownValue, List<String> liste, int adetCode) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(flex: 2,
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
                Expanded(flex: 1,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (wifiOlcum == false) {
                        wifiOlcum = true;
                        analogOlcum = false;
                        Toast.show(Dil().sec(dilSecimi, "toast60"), context,duration: 3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast60"), context,duration: 3);
                      }

                      setState(() {});
                    },
                    child: Icon(
                      Icons.wifi,
                      color:
                          wifiOlcum == true ? Colors.green[600] : Colors.black,
                      size: 25 * oran,
                    ),
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                  ),
                ),
                Expanded(flex: 1,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (analogOlcum == false) {
                        analogOlcum = true;
                        wifiOlcum = false;
                      Toast.show(Dil().sec(dilSecimi, "toast61"), context,duration: 3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast61"), context,duration: 3);
                      }

                      setState(() {});
                    },
                    child: Icon(
                        Icons.slow_motion_video,
                        color: analogOlcum == true
                            ? Colors.green[500]
                            : Colors.black,
                        size: 25 * oran,
                      ),
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 5,
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
                      fontSize: 30 * oran,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      if (adetCode == 1) {
                        fanAdet = newValue;
                      } else if (adetCode == 2) {
                        klepeAdet = newValue;
                      } else if (adetCode == 3) {
                        pedAdet = newValue;
                      } else if (adetCode == 4) {
                        isiSensAdet = newValue;
                      } else if (adetCode == 5) {
                        bacafanAdet = newValue;
                      } else if (adetCode == 6) {
                        airinletAdet = newValue;
                      } else if (adetCode == 7) {
                        isiticiAdet = newValue;
                      } else if (adetCode == 8) {
                        siloAdet = newValue;
                      }
                      if (adetCode < 5) {
                        _veriGonder(
                            "2", "4", fanAdet, klepeAdet, pedAdet, isiSensAdet+ (wifiOlcum==true ? "#1" : "#2"));
                        dbHelper.veriYOKSAekleVARSAguncelle(
                            4, fanAdet, klepeAdet, pedAdet, isiSensAdet+ (wifiOlcum==true ? "#1" : "#2"));
                      } else {
                        _veriGonder("3", "6", bacafanAdet, airinletAdet,
                            isiticiAdet, siloAdet);
                        dbHelper.veriYOKSAekleVARSAguncelle(5, bacafanAdet,
                            airinletAdet, isiticiAdet, siloAdet);
                      }

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
          ),
        ],
      ),
    );
  }

//--------------------------METOTLAR--------------------------------

}
