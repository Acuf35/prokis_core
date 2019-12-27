
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/isisensor_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'kumes_olustur.dart';
import 'languages/select.dart';
 

class DilSecimi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DilSecimiState();
  }
}

class DilSecimiState extends State<DilSecimi> {

//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
//--------------------------DATABASE DEĞİŞKENLER--------------------------------





  @override
  Widget build(BuildContext context) {
    
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

      body: Column(children: <Widget>[

        //Başlık bölümü
        Expanded(child: Container(child: Text(SelectLanguage().selectStrings(dilSecimi, "tv1"), // Dil seçimi
        style: TextStyle(fontFamily: 'Kelly Slab', color: Colors.grey.shade600,fontSize: 30,fontWeight: FontWeight.bold),textScaleFactor: oran,),
        alignment: Alignment.center,)),
        //Dİl seçim bölümü
        Expanded(flex: 2,child: Container(color: Colors.grey.shade600,alignment: Alignment.center,
        child: DropdownButton<String>(
        value: dilSecimi == "EN" ? "ENGLISH" : "TÜRKÇE",
        elevation: 16,
        iconEnabledColor: Colors.white,
        iconSize: 40,
        style: TextStyle(
          color: Colors.grey.shade600,
          backgroundColor: Colors.white,
          fontFamily: 'Audio Wide',
          fontSize: 20,
          fontWeight: FontWeight.bold,

        ),
        
        underline: Container(
          height:1,
          color: Colors.grey.shade600,
        ),

        onChanged: (String newValue) {
           newValue=="ENGLISH" ? dilSecimi="EN" : dilSecimi="TR";
           newValue=="ENGLISH" ? dbHelper.veriYOKSAekleVARSAguncelle(1, "EN", "0", "0", "0") : dbHelper.veriYOKSAekleVARSAguncelle(1, "TR", "0", "0", "0");
           
          setState(() {});
        },
        items: <String>['ENGLISH','TÜRKÇE']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(child: Text(value),
              color: Colors.white,
              padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),),
            );
          })
          .toList(),
      )
        
        ,),),



        //ileri geri ok bölümü
        Expanded(child: 

          Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            Spacer(flex: 20,),
            //geri ok
            Expanded(flex:2,child: IconButton(icon: Icon(Icons.arrow_back_ios),iconSize: 50,onPressed: (){
              
              for(int i=1;i<=121;i++){
                                dbHelper.veriSil(i+1000);
                              }
                              Toast.show(dbSatirSayisi.toString(), context,duration: 3);
                              
            },color: Colors.grey.shade400,)),
            Spacer(flex: 1,),
            //ileri ok
            Expanded(flex: 2,child: IconButton(icon: Icon(Icons.arrow_forward_ios),iconSize: 50,onPressed: (){
              Navigator.push(
          context,
          //MaterialPageRoute(builder: (context) => KumesOlustur(dilSecimi)),
          MaterialPageRoute(builder: (context) => IsiSensorHaritasi(dilSecimi)),
        );
            },color: Colors.black,)),
            Spacer(flex: 1,),
          ],),
          
          ),
        
        ),


      ],)
      
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
  }

    print(satirlar);
    setState(() {});
  }
  

  _languageClick(BuildContext context) {
    dbHelper.veriYOKSAekleVARSAguncelle(1, dilSecimi, "0", "0", "0");
  }

  Future _cikisAlert(String x) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return CikisAlert.deger(x);
      },
    );
  }


//--------------------------METOTLAR--------------------------------

}
