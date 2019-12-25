import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'fan_yontemi.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';

class Adetler extends StatefulWidget {
  String gelenDil;
    
    Adetler(String dil){
      gelenDil=dil;
    }

  @override
  State<StatefulWidget> createState() {
    return AdetlerState(gelenDil);
  }
}

class AdetlerState extends State<Adetler> {
  String gelenDil;
  AdetlerState(String dil){
    gelenDil=dil;
  }
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
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
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  @override
  Widget build(BuildContext context) {
    dilSecimi = gelenDil;

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
    return Scaffold(
        body: Column(
      children: <Widget>[

        //Başlık Bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Text(
            SelectLanguage().selectStrings(dilSecimi, "tv11"), // Adetler
            style: TextStyle(
                fontFamily: 'Kelly Slab',
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
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
                  Expanded(flex: 1,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //Fan Sayısı
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv12"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_fan_icon.png',
                                  scale: 5,
                                ),
                                DropdownButton<String>(
                                  value: fanAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    fanAdet = newValue;
                                    _veriGonder("2","4", fanAdet, klepeAdet, pedAdet, isiSensAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(4, fanAdet, klepeAdet, pedAdet, isiSensAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
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
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
                            //Klepe Sayısı
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv13"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_klepe_icon.png',
                                  scale: 5,
                                ),
                                DropdownButton<String>(
                                  value: klepeAdet ,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    klepeAdet = newValue;
                                    _veriGonder("2","4", fanAdet, klepeAdet, pedAdet, isiSensAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(4, fanAdet, klepeAdet, pedAdet, isiSensAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
                          ],
                        ),
                  ),
                  //Ped pompa Sayisi ve ısı sensor sayısı bölümü
                  Expanded(flex: 1,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //Ped Pompa                            
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv14"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_ped_icon.png',
                                  scale: 5,
                                ),
                                DropdownButton<String>(
                                  value: pedAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    pedAdet = newValue;
                                    _veriGonder("2","4", fanAdet, klepeAdet, pedAdet, isiSensAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(4, fanAdet, klepeAdet, pedAdet, isiSensAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
                            //Isı Sensör
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv15"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_isisensor_icon.png',
                                  scale: 5,
                                ),
                                DropdownButton<String>(
                                  value: isiSensAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    isiSensAdet = newValue;
                                    _veriGonder("2","4", fanAdet, klepeAdet, pedAdet, isiSensAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(4, fanAdet, klepeAdet, pedAdet, isiSensAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
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
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
                          ],
                        ),
                  ),
                  //Bacafan Sayısı ve Air inlet Motor sayısı
                  Expanded(flex: 1,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //Bacafan
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv16"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_bacafan_icon.png',
                                  scale: 5,
                                ),
                                DropdownButton<String>(
                                  value: bacafanAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    bacafanAdet = newValue;
                                    _veriGonder("3","6", bacafanAdet, airinletAdet, isiticiAdet, siloAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(5, bacafanAdet, airinletAdet, isiticiAdet, siloAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
                                    '0',
                                    '1',
                                    '2',
                                    '3'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      
                      ],
                    ),
                              ],
                            ),
                            //Air inlet
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv17"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_airinlet_icon.png',
                                  scale: 5,
                                ),
                                DropdownButton<String>(
                                  value: airinletAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    airinletAdet = newValue;
                                    _veriGonder("3","6", bacafanAdet, airinletAdet, isiticiAdet, siloAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(5, bacafanAdet, airinletAdet, isiticiAdet, siloAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
                                    '0',
                                    '1',
                                    '2'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
                          ],
                        ),
                  ),
                  //Isıtıcı Sayısı ve Silo Sayısı
                  Expanded(flex: 1,
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //Isıtıcı
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv18"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_isitici_icon.png',
                                  scale: 4,
                                ),
                                DropdownButton<String>(
                                  value: isiticiAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    isiticiAdet = newValue;
                                    _veriGonder("3","6", bacafanAdet, airinletAdet, isiticiAdet, siloAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(5, bacafanAdet, airinletAdet, isiticiAdet, siloAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
                                    '0',
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
                            //Silo
                            Column(
                              children: <Widget>[
                                Text(SelectLanguage().selectStrings(dilSecimi, "tv19"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                Image.asset(
                                  'assets/images/kurulum_silo_icon.png',
                                  scale: 4,
                                ),
                                DropdownButton<String>(
                                  value: siloAdet,
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: 40*oran,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: 25*oran,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey.shade600,
                                  ),
                                  onChanged: (String newValue) {
                                    siloAdet = newValue;
                                    _veriGonder("3","6", bacafanAdet, airinletAdet, isiticiAdet, siloAdet);
                                    dbHelper.veriYOKSAekleVARSAguncelle(5, bacafanAdet, airinletAdet, isiticiAdet, siloAdet);

                                    setState(() {});
                                  },
                                  items: <String>[
                                    '0',
                                    '1',
                                    '2',
                                    '3',
                                    '4'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
                                        color: Colors.white  ,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5, top: 5),
                                      ),
                                    );
                                  }).toList(),
                                )
                      ],
                    ),
                              ],
                            ),
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
                      iconSize: 50*oran,
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
                      iconSize: 50*oran,
                      onPressed: () {

                        Navigator.push(context,MaterialPageRoute(builder: (context) => FanYontemi(dilSecimi)),);
                        
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
        fanAdet = satirlar[i]["veri1"];
        klepeAdet = satirlar[i]["veri2"];
        pedAdet = satirlar[i]["veri3"];
        isiSensAdet = satirlar[i]["veri4"];
      }

      if(satirlar[i]["id"]==5){
        bacafanAdet = satirlar[i]["veri1"];
        airinletAdet = satirlar[i]["veri2"];
        isiticiAdet = satirlar[i]["veri3"];
        siloAdet = satirlar[i]["veri4"];
      }



    }



    print(satirlar);
    setState(() {});
  }

  _veriGonder(String dbKod,String id, String v1, String v2, String v3, String v4) async {
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


//--------------------------METOTLAR--------------------------------

}
