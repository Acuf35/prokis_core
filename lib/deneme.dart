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
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';

class Deneme extends StatefulWidget {
  List<Map> gelenDBveri;
  Deneme(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return DenemeState(gelenDBveri);
  }
}

class DenemeState extends State<Deneme> {
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
  String sifreTekrar = "";
  bool sifreUyusma = false;
  bool sifreOnaylandi = false;

  final FocusNode _focusNodeKumesIsmi = FocusNode();
  

//--------------------------DATABASE ve DİĞER DEĞİŞKENLER--------------------------------


//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  DenemeState(List<Map> dbVeri) {
    
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++

/*
    var oran = MediaQuery.of(context).size.width / 731.4;

*/


    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = MediaQuery.of(context).size.width * MediaQuery.of(context).size.height;
    //var oran = carpim / 2073600.0;
    var ratio = MediaQuery.of(context).devicePixelRatio;
    var oran = carpim / 300930.612244898*(ratio/2.625);

    
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold(
            
            body: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(height: 900,width: 2,color: Colors.green,),
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("data",textScaleFactor: oran,style: TextStyle(fontSize: 50),),
                    RaisedButton(onPressed: (){
                      print(oran);
                      print(carpim);
                      print(MediaQuery.of(context).devicePixelRatio);
                      print(MediaQuery.of(context).size);
                      print(MediaQuery.of(context).size.width);
                      print(MediaQuery.of(context).textScaleFactor);
                    },color: Colors.yellow,
                    )
                  ],
                ),
              ],
            ),)
        );},
    );

//--------------------------SCAFFOLD--------------------------------

  

  }

//++++++++++++++++++++++++++METOTLAR+++++++++++++++++++++++++++++++



//--------------------------METOTLAR--------------------------------

}
