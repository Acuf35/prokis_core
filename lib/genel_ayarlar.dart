import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/dil_secimi.dart';
import 'package:prokis/kontrol.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';

class GenelAyarlar extends StatefulWidget {
  List<Map> gelenDBveri;
  GenelAyarlar(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return GenelAyarlarState(gelenDBveri);
  }
}

class GenelAyarlarState extends State<GenelAyarlar> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  GenelAyarlarState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

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
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
            actions: [
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.ac_unit,
                      size: 40 * oran,
                    ),
                    onPressed: () {},
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      iconSize: 40 * oran,
                      icon: Icon(Icons.settings),
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
              SelectLanguage().selectStrings(dilSecimi, 'tv99'),
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
                Spacer(),
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  SelectLanguage().selectStrings(dilSecimi, 'tv100'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/izleme_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  SelectLanguage().selectStrings(dilSecimi, 'tv101'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/mancontrol_icon_red.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  SelectLanguage().selectStrings(dilSecimi, 'tv102'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Kontrol(dbVeriler)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/kontrol_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  SelectLanguage().selectStrings(dilSecimi, 'tv103'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/datalog_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  SelectLanguage().selectStrings(dilSecimi, 'tv104'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 2,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/alarm_ayarlari_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  SelectLanguage().selectStrings(dilSecimi, 'tv105'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 2,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DilSecimi(dbVeriler)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/settings_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
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
}
