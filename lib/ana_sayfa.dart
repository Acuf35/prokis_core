import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';
 

class AnaSayfa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnaSayfaState();
  }
}

class AnaSayfaState extends State<AnaSayfa> {
  final dbHelper = DatabaseHelper.instance;

  var satirlar;
  int satSay = 0;
  int sayac = 0;
  String dilSecimi = "TR";


  


  @override
  Widget build(BuildContext context) {

    /*

    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    progressDialog.style(
        message: SelectLanguage().selectStrings(dilSecimi, "pdiag1"));

        */

    satirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => satSay = satirSayisi);
    satirSayisi.whenComplete(() {
      if (sayac == 0) {
        //progressDialog.show();
        satirlar.then((List<Map> satir) => _satirlar(satir));
        sayac++;
      }
    });


    //Timer.periodic(Duration(seconds: 2), (timer) {});


   

    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;

    //region SCAFFOLD

    // TODO: implement build
    return Scaffold(

      body: Text("Dünya")

    );

    //endregion
  }

  _satirlar(List<Map> satirlar) {
    if (satSay > 0) {
      dilSecimi = satirlar[0]["veri1"];
    }
    if (satSay > 1) {
      //seriNo = satirlar[1]["veri1"];
      //sifre = satirlar[1]["veri2"];
    }

    if (satSay > 2) {
      //cikisIsmi1 = satirlar[2]["veri1"];
      //cikisIsmi2 = satirlar[2]["veri2"];
      //cikisIsmi3 = satirlar[2]["veri3"];
    }

    if (satSay > 3) {
      //aktivasyonDurum = satirlar[3]["veri1"];
    }

    print(satirlar);
    setState(() {});
  }

  _languageClick(BuildContext context) {
    dbHelper.veriYOKSAekleVARSAguncelle(1, dilSecimi, "0", "0", "0");
  }


}
