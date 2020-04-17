


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';

class Girisler extends StatelessWidget {

  bool ilkKurulumMu=true;
  Girisler(this.ilkKurulumMu);


  String dilSecimi="";

  
  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(

      appBar: Metotlar().appBar(dilSecimi, context, oran, "tv351"),

      
    );
  }
}