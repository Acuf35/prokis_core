import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';

class SicVeNem extends StatefulWidget {
  List<Map> gelenDBveri;
  SicVeNem(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SicVeNemState(gelenDBveri);
  }
}

class SicVeNemState extends State<SicVeNem> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String kumesTuru;
  String bacaFanAdet;
  String fanYontemi;
  List<Map> dbVeriler;

  String diagramPath;
  String visibilityler;
  String harfMetinler;
  String infoNo;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SicVeNemState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 3) {
        kumesTuru = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        bacaFanAdet = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 6) {
        fanYontemi = dbVeri[i]["veri1"];
      }
    }

    if(fanYontemi=="2" && kumesTuru=="1" && bacaFanAdet!="0"){
      diagramPath='assets/images/diagram_lineer_capraz.jpg';
      visibilityler='A1*B1*C1*D1*E1*F1*G1*H1';
      harfMetinler='A*B*C*D*E*F*G*H';
      infoNo="info1";
    }else if(fanYontemi=="2" && kumesTuru!="1" && bacaFanAdet!="0"){
      diagramPath='assets/images/diagram_lineer_capraz_civbro.jpg';
      visibilityler='A1*B1*C1*D1*E1*F1*G1*H1';
      harfMetinler='A*A+B*A+C*D*E*F*G*H';
      infoNo="info2";
    }else if(fanYontemi=="2" && kumesTuru=="1" && bacaFanAdet=="0"){
      diagramPath='assets/images/diagram_lineer_normal.jpg';
      visibilityler='A1*B1*C0*D1*E0*F1*G1*H1';
      harfMetinler='A*B**D**F*G*H';
      infoNo="info3";
    }else if(fanYontemi=="2" && kumesTuru!="1" && bacaFanAdet=="0"){
      diagramPath='assets/images/diagram_lineer_normal_civbro.jpg';
      visibilityler='A1*B1*C0*D1*E0*F1*G1*H1';
      harfMetinler='A*B**D**F*G*H';
      infoNo="info4";
    }


    else if(fanYontemi=="1" && kumesTuru=="1" && bacaFanAdet=="0"){
      diagramPath='assets/images/diagram_klasik_normal.jpg';
      visibilityler='A1*B1*C0*D1*E0*F1*G1*H0';
      harfMetinler='A*B**D**F*G*';
      infoNo="info5";
    }else if(fanYontemi=="1" && kumesTuru=="1" && bacaFanAdet!="0"){
      diagramPath='assets/images/diagram_klasik_capraz.jpg';
      visibilityler='A1*B1*C1*D1*E1*F1*G1*H0';
      harfMetinler='A*B*C*D*E*F*G*';
      infoNo="info6";
    }



    else if(fanYontemi=="3" && kumesTuru=="1" && bacaFanAdet=="0"){
      diagramPath='assets/images/diagram_pid_normal.jpg';
      visibilityler='A1*B0*C0*D1*E0*F0*G1*H0';
      harfMetinler='A***D***G*';
      infoNo="info7";
    }else if(fanYontemi=="3" && kumesTuru=="1" && bacaFanAdet!="0"){
      diagramPath='assets/images/diagram_pid_capraz.jpg';
      visibilityler='A1*B0*C1*D1*E1*F0*G1*H0';
      harfMetinler='A**C*D*E**G*';
      infoNo="info8";
    }else if(fanYontemi=="3" && kumesTuru!="1" && bacaFanAdet!="0"){
      diagramPath='assets/images/diagram_pid_capraz_civbro.jpg';
      visibilityler='A1*B0*C1*D1*E1*F0*G1*H0';
      harfMetinler='A**A+C*D*E**G*';
      infoNo="info9";
    }





    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    /*

    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    progressDialog.style(
        message: SelectLanguage().selectStrings(dilSecimi, "pdiag1"));


    Timer.periodic(Duration(seconds: 2), (timer) {});
 */

    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30 * oran),
          child: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 40 * oran,
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
              actions: [
                Row(
                  children: <Widget>[
                    Builder(
                      builder: (context) => IconButton(
                        color: Colors.yellow[700],
                        iconSize: 40 * oran,
                        icon: Icon(Icons.info_outline),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      ),
                    ),
                  ],
                ),
              ],
              primary: false,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                "SICAKLIK SET ve FAN ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * oran,
                    fontFamily: 'Kelly Slab',
                    fontWeight: FontWeight.bold),
              )),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 40,
              child: Column(
                children: <Widget>[
                  
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Kontrol(dbVeriler)),
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.arrow_back,
            size: 50,
            color: Colors.white,
          ),
        ),
        drawer: Drawer(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  child: Text(
                    SelectLanguage()
                        .selectStrings(dilSecimi, "tv124"), //Sıcaklık diyagramı
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Kelly Slab',
                    ),
                    textScaleFactor: oran,
                  ),
                  color: Colors.blue[800],
                ),
                /*
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                leading: Icon(Icons.ac_unit),
                subtitle: Text(
                  "Deneme",
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
*/
                ListTile(
                  onTap: () {
                    Toast.show("DEneme", context, duration: 3);
                  },
                  leading: SizedBox(
                    width: 40 * oran,
                    height: 40 * oran,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image:
                              AssetImage('assets/images/izleme_icon_red.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "İZLEME",
                    style: TextStyle(
                        fontFamily: 'Audio wide', fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Toast.show("DEneme", context, duration: 3);
                  },
                  leading: SizedBox(
                    width: 40 * oran,
                    height: 40 * oran,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage(
                              'assets/images/mancontrol_icon_red.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "OTO-MAN",
                    style: TextStyle(
                        fontFamily: 'Audio wide', fontWeight: FontWeight.bold),
                  ),
                ),
                ExpansionTile(
                  //leading: Icon(Icons.ac_unit),

                  leading: SizedBox(
                    width: 40 * oran,
                    height: 40 * oran,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage(
                              'assets/images/kontrol_icon_small.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  //backgroundColor: Colors.green,
                  title: Text(
                    "KONTROL",
                    textScaleFactor: oran,
                    style: TextStyle(
                        fontFamily: 'Audio wide', fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/tem_hum_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv107"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.centerLeft,
                                          image: AssetImage(
                                              'assets/images/heating_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv111"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/aydinlatma_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv108"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/cooling_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv112"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/cooling_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv109"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/silo_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv113"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/minvent_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv110"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 14,
                          child: RawMaterialButton(
                            fillColor: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: 30 * oran,
                                    height: 30 * oran,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              'assets/images/wizard_icon.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "  " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv114"),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Toast.show("DEneme", context, duration: 3);
                  },
                  leading: SizedBox(
                    width: 40 * oran,
                    height: 40 * oran,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage(
                              'assets/images/datalog_icon_small.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "DATA LOG",
                    style: TextStyle(
                        fontFamily: 'Audio wide', fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Toast.show("DEneme", context, duration: 3);
                  },
                  leading: SizedBox(
                    width: 40 * oran,
                    height: 40 * oran,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage(
                              'assets/images/alarm_ayarlari_icon_small.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "ALARM AYAR.",
                    style: TextStyle(
                        fontFamily: 'Audio wide', fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Toast.show("DEneme", context, duration: 3);
                  },
                  leading: SizedBox(
                    width: 40 * oran,
                    height: 40 * oran,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage(
                              'assets/images/settings_icon_small.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "KURULUM",
                    style: TextStyle(
                        fontFamily: 'Audio wide', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        //endDrawer: _drawerSecimi('assets/images/diagram_pid_capraz_civbro.jpg','A1*B0*C1*D1*E1*F0*G1*H0','info11','A**A+C*D*E**G*',oran)
        endDrawer: _drawerSecimi(diagramPath,visibilityler,infoNo,harfMetinler,oran)
        
        );
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

  Widget _drawerSecimi2(
      String kafesTuru, bool bacafanVarMi, String fanYontemi, double oran) {
    Drawer drawer;

    if (kafesTuru == '1' && bacafanVarMi && fanYontemi == '2') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    SelectLanguage()
                        .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
                flex: 7,
                child: DrawerHeader(
                  padding: EdgeInsets.only(left: 10),
                  margin: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  'assets/images/diagram_lineer_capraz.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text("A"),
                                  Text("B"),
                                  Text("C"),
                                  Text("D"),
                                  Text("E"),
                                  Text("F"),
                                  Text("G"),
                                  Text("H"),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv115"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv116"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv117"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv118"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv119"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv120"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv121"),
                                  ),
                                  Text(
                                    " - " +
                                        SelectLanguage()
                                            .selectStrings(dilSecimi, "tv122"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(color: Colors.yellow[100],
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        dense: false,
                        title: Text('Açıklama'),
                        subtitle: Text(
                          SelectLanguage().selectStrings(dilSecimi, "info1"),
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
      );
    }

    if (kafesTuru != '1' && bacafanVarMi && fanYontemi == '2') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_lineer_capraz_civbro.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("A+B"),
                                Text("A+C"),
                                Text("D"),
                                Text("E"),
                                Text("F"),
                                Text("G"),
                                Text("H"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv117"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv119"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv122"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info2"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru == '1' && !bacafanVarMi && fanYontemi == '2') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_lineer_normal.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("B"),
                                Text("D"),
                                Text("F"),
                                Text("G"),
                                Text("H"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv122"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info3"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru != '1' && !bacafanVarMi && fanYontemi == '2') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_lineer_normal_civbro.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("A+B"),
                                Text("D"),
                                Text("F"),
                                Text("G"),
                                Text("H"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv122"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info4"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru == '1' && !bacafanVarMi && fanYontemi == '1') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_klasik_normal.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("B"),
                                Text("D"),
                                Text("F"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info5"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru != '1' && !bacafanVarMi && fanYontemi == '1') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_klasik_normal_civbro.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("A+B"),
                                Text("D"),
                                Text("F"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info6"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru == '1' && bacafanVarMi && fanYontemi == '1') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_klasik_capraz.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("B"),
                                Text("C"),
                                Text("D"),
                                Text("E"),
                                Text("F"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv117"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv119"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info7"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru != '1' && bacafanVarMi && fanYontemi == '1') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_klasik_capraz_civbro.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("A+B"),
                                Text("A+C"),
                                Text("D"),
                                Text("E"),
                                Text("F"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv116"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv117"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv119"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv120"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info8"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru == '1' && !bacafanVarMi && fanYontemi == '3') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_pid_normal.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("D"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info9"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru == '1' && bacafanVarMi && fanYontemi == '3') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_pid_capraz.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("C"),
                                Text("D"),
                                Text("E"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv117"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv119"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info10"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    if (kafesTuru != '1' && bacafanVarMi && fanYontemi == '3') {
      drawer = Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
              DrawerHeader(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                'assets/images/diagram_pid_capraz_civbro.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("A"),
                                Text("A+C"),
                                Text("D"),
                                Text("E"),
                                Text("G"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv115"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv117"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv118"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv119"),
                                ),
                                Text(
                                  " - " +
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv121"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                dense: false,
                title: Text('Açıklama'),
                subtitle: Text(
                  SelectLanguage().selectStrings(dilSecimi, "info11"),
                  style: TextStyle(fontSize: 13 * oran),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    }

    return drawer;
  }


Widget _drawerSecimi(String diagramPath, harfVisibility, info, harfMetin, oran){

  var visibilityler = harfVisibility.split('*');
  var metinler = harfMetin.split('*');

  return Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    SelectLanguage()
                        .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
                flex: 7,
                child: DrawerHeader(
                  padding: EdgeInsets.only(left: 10),
                  margin: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  diagramPath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(color: Colors.grey[100],
                                                  child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Visibility(child: Text(metinler[0]),visible: visibilityler[0]=="A1" ? true : false,),
                                    Visibility(child: Text(metinler[1]),visible: visibilityler[1]=="B1" ? true : false,),
                                    Visibility(child: Text(metinler[2]),visible: visibilityler[2]=="C1" ? true : false,),
                                    Visibility(child: Text(metinler[3]),visible: visibilityler[3]=="D1" ? true : false,),
                                    Visibility(child: Text(metinler[4]),visible: visibilityler[4]=="E1" ? true : false,),
                                    Visibility(child: Text(metinler[5]),visible: visibilityler[5]=="F1" ? true : false,),
                                    Visibility(child: Text(metinler[6]),visible: visibilityler[6]=="G1" ? true : false,),
                                    Visibility(child: Text(metinler[7]),visible: visibilityler[7]=="H1" ? true : false,),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Visibility(visible: visibilityler[0]=="A1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv115"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[1]=="B1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv116"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[2]=="C1" ? true : false,//maintainSize: true,maintainAnimation: true,maintainState: true,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv117"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[3]=="D1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv118"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[4]=="E1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv119"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[5]=="F1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv120"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[6]=="G1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv121"),
                                      ),
                                    ),
                                    Visibility(visible: visibilityler[7]=="H1" ? true : false,
                                                                        child: Text(
                                        " : " +
                                            SelectLanguage()
                                                .selectStrings(dilSecimi, "tv122"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(color: Colors.yellow[100],
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        dense: false,
                        title: Text('Açıklama'),
                        subtitle: Text(
                          SelectLanguage().selectStrings(dilSecimi, info),
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
      );

}


  //--------------------------METOTLAR--------------------------------
}
