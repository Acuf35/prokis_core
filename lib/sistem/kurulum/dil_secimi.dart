import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/sistem/kurulum/bacafan_haritasi.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/isitici_haritasi.dart';
import 'package:prokis/sistem/kurulum/ped_haritasi.dart';
import 'package:provider/provider.dart';
import 'temel_ayarlar.dart';

class DilSecimi extends StatefulWidget{
  bool ilkKurulumMu = true;
  DilSecimi(this.ilkKurulumMu);

  @override
  _DilSecimiState createState() => _DilSecimiState();
}

class _DilSecimiState extends State<DilSecimi>{
  String dilSecimi = "EN";

  @override
  Widget build(BuildContext context) {

    final dbProkis = Provider.of<DBProkis>(context, listen: true);
    dilSecimi = dbProkis.dbVeriGetir(1, 1,"EN");
    var oran = MediaQuery.of(context).size.width / 731.4;


    return Scaffold(
      body: Column(
        children: <Widget>[
          //Başlık bölümü
          Expanded(
              child: Container(
            child: Column(
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv1"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Kelly Slab',
                            color: Colors.grey.shade600,
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
          //Dil seçim bölümü
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade600,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 10 * oran),
                            child:
                                LayoutBuilder(builder: (context, constraint) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  value:
                                      dilSecimi == "EN" ? "ENGLISH" : "TÜRKÇE",
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: constraint.biggest.height,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: constraint.biggest.height * 0.8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onChanged: (String newValue) {
                                    newValue == "ENGLISH"
                                        ? dilSecimi = "EN"
                                        : dilSecimi = "TR";
                                    newValue == "ENGLISH"
                                        ? dbProkis.dbSatirEkleGuncelle(
                                            1, "EN", "0", "0", "0")
                                        : dbProkis.dbSatirEkleGuncelle(
                                            1, "TR", "0", "0", "0");
                                  },
                                  items: <String>['ENGLISH', 'TÜRKÇE']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        )
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
          ),

          //ileri geri ok bölümü
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  
                  Spacer(
                    flex: 20,
                  ),
                  //geri ok
                  Expanded(
                    flex: 2,
                    child: Visibility(
                      visible: widget.ilkKurulumMu,
                      maintainState: true,
                      maintainSize: true,
                      maintainAnimation: true,
                      child: RawMaterialButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child:
                                  LayoutBuilder(builder: (context, constraint) {
                                return Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey.shade400,
                                  size: constraint.biggest.height,
                                );
                              }),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  //ileri ok
                  Expanded(
                    flex: 2,
                    child: Visibility(
                      visible: widget.ilkKurulumMu,
                      maintainState: true,
                      maintainSize: true,
                      maintainAnimation: true,
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TemelAyarlar(true)),
                          );
                          
                        },
                        child: Column(
                          children: <Widget>[
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child:
                                  LayoutBuilder(builder: (context, constraint) {
                                return Icon(
                                  Icons.arrow_forward_ios,
                                  size: constraint.biggest.height,
                                );
                              }),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),

                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: MyFloatingActionBackButton(!widget.ilkKurulumMu, false, oran, 40, Colors.grey[700], Colors.white, Icons.arrow_back,1,""),
    );
  }
}
