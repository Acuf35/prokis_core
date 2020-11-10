


import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheetI.dart';
import 'package:prokis/sistem/kurulum/uz_debi_nem.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'diger_cikislar.dart';

class Girisler extends StatelessWidget {

  bool ilkKurulumMu = true;
  Girisler(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  

  int sayac=0;
  int sayac2=0;

  
  @override
  Widget build(BuildContext context) {

    oran = MediaQuery.of(context).size.width / 731.4;

    if(sayac2==0){
          new Timer(Duration(seconds: 0), (){
            showProgressDialog(context, Dil().sec(dilSecimi, "tv638"), oran);
          });
    }


    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    
    double oranOzel=(MediaQuery.of(context).size.width/10)*1;

    

    return ChangeNotifierProvider<GirislerProvider>(
            create: (context) => GirislerProvider(context, dbProkis),
            child: LayoutBuilder(
    builder: (context, constraints){

      final provider = Provider.of<GirislerProvider>(context);
      

      if(sayac2==0){
        Timer(Duration(milliseconds: 1500), (){
          if(provider.sayac==0)
            provider.setsayac=48;
            Navigator.pop(context);
        });
        sayac2++;
      }

      return Scaffold(
        floatingActionButton: MyFloatingActionBackButton(
        !ilkKurulumMu,
        !provider.veriGonderildi,
        oran,
        40,
        Colors.white,
        Colors.grey[700],
        Icons.arrow_back,
        1,
        "tv564"),
      
          body: Column(
        children: <Widget>[
          //Başlık bölümü
          Expanded(
            child: Container(
              color: Colors.grey.shade600,
              child: Row(
                children: <Widget>[
                  Spacer(flex: 3,),
                  Expanded(flex: 10,
                    child: SizedBox(
                      child: Container(
                        
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          Dil().sec(dilSecimi, "tv349"),
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
                  Spacer(flex: 2,),
                  Expanded(
                    child: LayoutBuilder(
                        builder: (context, constraint) {
                        return IconButton(
                        padding: EdgeInsets.all(0),
                        icon:Icon(Icons.info_outline,),
                        iconSize: constraint.biggest.height,
                        color: Colors.white,
                        onPressed: ()=>Scaffold.of(context).openEndDrawer(),
                        );
                      }
                    ),
                  ),
                     
                ],
              ),
            )),
          //Girişler Bölümü
          Expanded(
            flex: 9,
            child: Container(
            padding: EdgeInsets.only(left:8*oran, right: 8*oran),
            color: Colors.white,
            alignment: Alignment.center,
            child: GridView.extent(
                    padding: EdgeInsets.all(0),
                    
                    maxCrossAxisExtent: oranOzel,
                    childAspectRatio: 1.2,
                    

                    children: List.generate(provider.sayac, (index){
                      return girisUnsur(index, provider, context);

                    })),
            ),
          ),

          //ileri geri ok bölümü
          Expanded(flex:2 ,
            child: Container(
    color: Colors.grey.shade600,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            
              //Otomatik Sırasıyla giriş ata
              FlatButton(
                onPressed: () {

                  int syc=0;
                  List xx=provider.tumGirisler;

                  for (var i = 1; i < 49; i++) {
                    if(provider.visibleDurum[i-1]){
                      syc++;
                      xx[i]=syc;
                    }
                  }
                  provider.dinlemeyiTetikle();
                  Toast.show(Dil().sec(dilSecimi, "toast95"), context,duration: 3);
                  


                },
                highlightColor: Colors.green,
                splashColor: Colors.red,
                color: Colors.blue,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.queue,
                      size: 30 * oran,
                    ),
                    Text(
                      Dil()
                          .sec(dilSecimi, "btn11"),
                      style: TextStyle(fontSize: 18),
                      textScaleFactor: oran,
                    ),
                  ],
                ),
              ),
            
            


              //Verileri Gönder Butonu
              FlatButton(
                onPressed: () {


                  bool atanmamisInputVar=false;

                  for (var i = 1; i < 49; i++) {

                    if(provider.tumGirisler[i]==0 && provider.visibleDurum[i-1]){

                      atanmamisInputVar=true;
                      
                      break;
                    }
                    
                  }


                  if(atanmamisInputVar){
                    Toast.show(Dil().sec(dilSecimi, "toast76"), context,duration: 3);
                  }else if(provider.girisNoTekerrur){
                    Toast.show(Dil().sec(dilSecimi, "toast76"), context,duration: 3);
                  }else{

                    provider.setveriGonderildi=true;


                    String tumGirislerVeri="";

                    for (var i = 1; i < 49; i++) {

                      tumGirislerVeri= tumGirislerVeri + provider.tumGirisler[i].toString()+"#";
                      
                    }

                    Metotlar().veriGonder("39*37*$tumGirislerVeri*0*0", 2233).then((value){
                      if(value.split("*")[0]=="error"){
                        Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(32, "ok", tumGirislerVeri, "0", "0");
                      }
                    });

                  }
                  



                },
                highlightColor: Colors.green,
                splashColor: Colors.red,
                color:
                    provider.veriGonderildi ? Colors.green[500] : Colors.blue,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.send,
                      size: 30 * oran,
                    ),
                    Text(
                      Dil()
                          .sec(dilSecimi, "btn6"),
                      style: TextStyle(fontSize: 18),
                      textScaleFactor: oran,
                    ),
                  ],
                ),
              ),
            
              
            
            ],
          ),
        ),
        
        //geri ok
        Expanded(
            flex: 2,
            child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 50 * oran,
                onPressed: () {
                  
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DigerCikislar(true)),
                      );
                    
                  
                },
              ),
            )),
        Spacer(
          flex: 1,
        ),
        //ileri ok
        Expanded(
            flex: 2,
            child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
                                  child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                iconSize: 50 * oran,
                onPressed: () {

                  bool atanmamisInputVar=false;

                  for (var i = 1; i < 49; i++) {

                    if(provider.tumGirisler[i]==0 && provider.visibleDurum[i-1]){
                      atanmamisInputVar=true;
                      break;
                    }
                    
                  }

                  if(atanmamisInputVar){
                    Toast.show(Dil().sec(dilSecimi, "toast76"), context,duration: 3);
                  }else{

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UzDebiNem(true)),
                    );

                  }



                  


                },
                color: Colors.black,
              ),
            )),
        Spacer(
          flex: 1,
        ),
      ],
    ),
            ),
          ),
        ],
      ),

      endDrawer: SizedBox(
              width: 320 * oran,
              child: Drawer(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            Dil().sec(dilSecimi, "tv349"), 
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
                        flex: 17,
                        child: Container(
                          color: Colors.yellow[100],
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ListTile(
                                dense: false,
                                title: Text(
                                  Dil().sec(dilSecimi, "tv186"),
                                  textScaleFactor: oran,
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      //Giriş metni
                                      TextSpan(
                                        text: Dil().sec(dilSecimi, "info36"),
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13*oran
                                        )
                                      ),

                                      
                                    ]
                                  ),
                                ),
                              
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    
      
      
      );
    

    }
            )
      );
  }

  showProgressDialog(BuildContext context, String title, double oran) {
    try {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16*oran, fontWeight: FontWeight.bold,
                            fontFamily: 'Kelly Slab'
                            ),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }
  
  Widget girisUnsur(int index, GirislerProvider provider, BuildContext context){
    
    return Visibility(visible: provider.visibleDurum[index],
          child: Padding(
        padding: EdgeInsets.only(left:4*oran,right: 4*oran ),
        child: Column(
          children: <Widget>[
            Expanded(flex: 4,
              child: SizedBox(
                child: Container(
                  child: AutoSizeText(
                    Dil().sec(dilSecimi, baslikGetir(index)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'Kelly Slab',
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 2,
                    minFontSize: 2,
                  ),
                ),
              )
            ),
            Expanded(flex: 4,
                        child: RawMaterialButton(
                  onPressed: (){


                    String inputNoMetin = Metotlar().inputConvSAYItoI(provider.tumGirisler[index + 1]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(inputNoMetin=="I#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(inputNoMetin.length > 4
                          ? inputNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(inputNoMetin.length > 4
                          ? inputNoMetin.substring(2, 3)
                          : inputNoMetin.substring(1, 2));
                      qBit =
                          int.parse(inputNoMetin.substring(inputNoMetin.length - 1));
                    }

                MyshowModalBottomSheetI(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            inputNoMetin = "I" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int girisNo = Metotlar().inputConvItoSAYI(inputNoMetin);

                            bool secilenZatenVar=provider.tumGirisler.contains(girisNo);



                            if (girisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast93"), context, duration: 3);
                            }else if(secilenZatenVar){
                              Toast.show(Dil().sec(dilSecimi, "toast94"), context, duration: 3);
                            }else {
                              provider.tumGirisler[index+1]=girisNo;
                              provider.setveriGonderildi=false;
                            }



                          }


                });




                  },
                  fillColor: Colors.green,

                  child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            child: Container(
                              child: AutoSizeText(
                                Metotlar().inputConvSAYItoI(provider.tumGirisler[index+1]),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                                minFontSize: 2,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  
  
  }

 String baslikGetir(int index){

   String baslik;

   if(index==0 ) baslik="tv352";
   if(index==1 ) baslik="tv353";
   if(index==2 ) baslik="tv354";
   if(index==3 ) baslik="tv355";
   if(index==4 ) baslik="tv356";
   if(index==5 ) baslik="tv357";
   if(index==6 ) baslik="tv382";
   if(index==7 ) baslik="tv383";
   if(index==8 ) baslik="tv384";
   if(index==9 ) baslik="tv385";
   if(index==10) baslik="tv358";
   if(index==11) baslik="tv359";
   if(index==12) baslik="tv360";
   if(index==13) baslik="tv361";
   if(index==14) baslik="tv362";
   if(index==15) baslik="tv363";
   if(index==16) baslik="tv364";
   if(index==17) baslik="tv365";
   if(index==18) baslik="tv366";
   if(index==19) baslik="tv367";
   if(index==20) baslik="tv368";
   if(index==21) baslik="tv369";
   if(index==22) baslik="tv370";
   if(index==23) baslik="tv371";
   if(index==24) baslik="tv372";
   if(index==25) baslik="tv373";
   if(index==26) baslik="tv374";
   if(index==27) baslik="tv375";
   if(index==28) baslik="tv376";
   if(index==29) baslik="tv377";
   if(index==30) baslik="tv378";
   if(index==31) baslik="tv379";
   if(index==32) baslik="tv380";
   if(index==33) baslik="tv381";
   if(index==34) baslik="tv637";
   if(index==35) baslik="tv386";
   if(index==36) baslik="tv387";
   if(index==37) baslik="tv388";
   if(index==38) baslik="tv389";
   if(index==39) baslik="tv390";
   if(index==40) baslik="tv391";
   if(index==41) baslik="tv392";
   if(index==42) baslik="tv393";
   if(index==43) baslik="tv394";
   if(index==44) baslik="tv395";
   if(index==45) baslik="tv396";
   if(index==46) baslik="tv397";
   if(index==47) baslik="tv430";

   return baslik;

 }


}

class GirislerProvider with ChangeNotifier {
  int sayac=0;

  int klepeAdet=0;
  int airInletAdet=0;
  int bacafanAdet=0;
  bool sirkFanVarMi = false;
  bool suAlarm = false;
  int isiticiAdet = 0;
  int sayacAdet = 0;
  bool bacafanKapakVarMi=false;

  bool veriGonderildi = false;
  bool girisNoTekerrur = false;

  List<bool> visibleDurum=new List.filled(49,true);

  List<int> tumGirisler = new List.filled(49,0);

  
  dinlemeyiTetikle(){
    notifyListeners();
  }

  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }
  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  GirislerProvider(this.context, this.dbProkis) {


    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = int.parse(yy[0]);
    sirkFanVarMi = yy[1]=="1" ? true : false;
    airInletAdet=int.parse(dbProkis.dbVeriGetir(5, 2, "0"));
    isiticiAdet=int.parse(dbProkis.dbVeriGetir(5, 3, "0"));
    klepeAdet=int.parse(dbProkis.dbVeriGetir(4, 2, "0"));
    sayacAdet=int.parse(dbProkis.dbVeriGetir(33, 1, "0"));
    suAlarm=dbProkis.dbVeriGetir(33, 3, "0")=="1" ? true : false;
    bacafanKapakVarMi=dbProkis.dbVeriGetir(24, 4, "").split("*")[3]=="1" ? true : false;



    String tumGirislerKAYIT = dbProkis.dbVeriGetir(32, 1, "");
    var tgirisler;
    

    if (tumGirislerKAYIT == "ok") {
      tgirisler = dbProkis.dbVeriGetir(32, 2, "").split("#");
      veriGonderildi=true;
    }



    for (var i = 1; i <= 48; i++) {
      if (tumGirislerKAYIT == "ok") {
        tumGirisler[i] = int.parse(tgirisler[i-1]);
        
      }
    }

    for (var i = 0; i < 48; i++) {
      visibleDurum[i]=girisVisibility(i);
    }
    
  }


  bool girisVisibility(int index){

   bool baslik;

   if(index==0 ) baslik=true;
   if(index==1 ) baslik=true;
   if(index==2 ) baslik=true;
   if(index==3 ) baslik=true;
   if(index==4 ) baslik=true;
   if(index==5 ) baslik=true;

   if(index==6 ) baslik=airInletAdet!=0 ? true: false;
   if(index==7 ) baslik=bacafanAdet!=0 ? true: false;
   if(index==8 ) baslik=isiticiAdet!=0 ? true: false;
   if(index==9 ) baslik=sirkFanVarMi;

   if(index==10) baslik=klepeAdet>0 ? true: false;
   if(index==11) baslik=klepeAdet>1 ? true: false;
   if(index==12) baslik=klepeAdet>2 ? true: false;
   if(index==13) baslik=klepeAdet>3 ? true: false;
   if(index==14) baslik=klepeAdet>4 ? true: false;
   if(index==15) baslik=klepeAdet>5 ? true: false;
   if(index==16) baslik=klepeAdet>6 ? true: false;
   if(index==17) baslik=klepeAdet>7 ? true: false;
   if(index==18) baslik=klepeAdet>8 ? true: false;
   if(index==19) baslik=klepeAdet>9 ? true: false;

   if(index==20) baslik=klepeAdet>0 ? true: false;
   if(index==21) baslik=klepeAdet>1 ? true: false;
   if(index==22) baslik=klepeAdet>2 ? true: false;
   if(index==23) baslik=klepeAdet>3 ? true: false;
   if(index==24) baslik=klepeAdet>4 ? true: false;
   if(index==25) baslik=klepeAdet>5 ? true: false;
   if(index==26) baslik=klepeAdet>6 ? true: false;
   if(index==27) baslik=klepeAdet>7 ? true: false;
   if(index==28) baslik=klepeAdet>8 ? true: false;
   if(index==29) baslik=klepeAdet>9 ? true: false;

   if(index==30) baslik=airInletAdet!=0 ? true: false;
   if(index==31) baslik=airInletAdet!=0 ? true: false;
   if(index==32) baslik=bacafanKapakVarMi;
   if(index==33) baslik=bacafanKapakVarMi;
   if(index==34) baslik=suAlarm;
   if(index==35) baslik=sayacAdet>0 ? true: false;
   if(index==36) baslik=sayacAdet>1 ? true: false;
   if(index==37) baslik=sayacAdet>2 ? true: false;
   if(index==38) baslik=sayacAdet>3 ? true: false;
   if(index==39) baslik=sayacAdet>4 ? true: false;
   if(index==40) baslik=sayacAdet>5 ? true: false;
   if(index==41) baslik=sayacAdet>6 ? true: false;
   if(index==42) baslik=sayacAdet>7 ? true: false;
   if(index==43) baslik=sayacAdet>8 ? true: false;
   if(index==44) baslik=sayacAdet>9 ? true: false;
   if(index==45) baslik=sayacAdet>10 ? true: false;
   if(index==46) baslik=sayacAdet>11 ? true: false;
   if(index==47) baslik=true;

   return baslik;

 }



}
