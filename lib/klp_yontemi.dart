
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/uz_debi_nem.dart';
import 'package:toast/toast.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'languages/select.dart';
 

class KlpYontemi extends StatefulWidget {
  String gelenDil;
    
    KlpYontemi(String dil){
      gelenDil=dil;
    }
  @override
  State<StatefulWidget> createState() {
    return KlpYontemiState(gelenDil);
  }
}

class KlpYontemiState extends State<KlpYontemi> {
String gelenDil;
  KlpYontemiState(String dil){
    gelenDil=dil;
  }
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  bool kyDurum=false;
  bool tyDurum=true;
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

      body: Column(children: <Widget>[

        //Başlık bölümü
        Expanded(child: Container(color: Colors.grey.shade600,child: Text(SelectLanguage().selectStrings(dilSecimi, "tv27"), // Klepe Kontrol Yöntemi
        style: TextStyle(fontFamily: 'Kelly Slab', color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),textScaleFactor: oran,),
        alignment: Alignment.center,)),
        //Klepe yöntemi seçim bölümü
        Expanded(flex: 2,
        child: Container(color: Colors.white,alignment: Alignment.center,
        child: Row(children: <Widget>[

          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(SelectLanguage().selectStrings(dilSecimi, "tv21"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                Image.asset(
                    'assets/images/ky_klp_klasik_icon.png',
                     scale: 4,
                    ),
                
                IconButton(onPressed: (){
                  if(!kyDurum){
                    kyDurum=true;
                  }
                  
                  if(kyDurum){
                    tyDurum=false;
                  }
                  dbHelper.veriYOKSAekleVARSAguncelle(8, "1", "0", "0", "0");
                _veriGonder("6", "9", "1", "0", "0", "0");
                  setState(() {});
                }, icon: Icon(kyDurum==true ? Icons.check_box : Icons.check_box_outline_blank),
                color: kyDurum==true ? Colors.green.shade500 : Colors.blue.shade600,
                iconSize: 30*oran,
                )

          ],),),

          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(SelectLanguage().selectStrings(dilSecimi, "tv28"),textScaleFactor: oran,
                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),),
                Image.asset(
                    'assets/images/ky_klp_tunel_icon.png',
                     scale: 4,
                    ),
                
                IconButton(onPressed: (){

                  if(!tyDurum){
                    tyDurum=true;
                  }
                  
                  if(tyDurum==true){
                    kyDurum=false;
                  }
                  dbHelper.veriYOKSAekleVARSAguncelle(8, "2", "0", "0", "0");
                _veriGonder("6", "9", "2", "0", "0", "0");
                  setState(() {});
                }, icon: Icon(tyDurum==true ? Icons.check_box : Icons.check_box_outline_blank),
                color: tyDurum==true ? Colors.green.shade500 : Colors.blue.shade600,
                iconSize: 30*oran,
                )

          ],),),

        ],)
        ,),
        
        ),



        //ileri geri ok bölümü
        Expanded(child: 

          Container(color: Colors.grey.shade600 ,child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            Spacer(flex: 20,),
            //geri ok
            Expanded(flex:2,child: IconButton(icon: Icon(Icons.arrow_back_ios),iconSize: 50*oran,onPressed: (){
              Navigator.pop(context);
            },)),
            Spacer(flex: 1,),
            //ileri ok
            Expanded(flex: 2,child: IconButton(icon: Icon(Icons.arrow_forward_ios),iconSize: 50*oran,onPressed: (){
            
                if(!kyDurum && !tyDurum){
                  Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast23"), context,duration: 3);
                }else{
                Navigator.push(context,MaterialPageRoute(builder: (context) => UzDebiNem(dilSecimi)),);
                
                }
              
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

      if(satirlar[i]["id"]==8){
          if(satirlar[i]["veri1"]=="1"){
          kyDurum=true;
          tyDurum=false;
        }else if(satirlar[i]["veri1"]=="2"){
          kyDurum=false;
          tyDurum=true;
        }
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
