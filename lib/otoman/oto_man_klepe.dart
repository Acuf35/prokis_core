import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';

class OtoManKlepe extends StatefulWidget {
  List<Map> gelenDBveri;
  OtoManKlepe(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return OtoManKlepeState(gelenDBveri);
  }
}

class OtoManKlepeState extends State<OtoManKlepe> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String klepeAdet = "0";

  
  int _onlar = 0;
  int _birler = 0;
  int _ondalik= 0;
  int _index = 0;

  List<bool> otoKLPE = new List(11);
  List<bool> klpManAc = new List(11);
  List<bool> klpManKp = new List(11);
  List<bool> timerCancelKlp = new List(11);
  List<bool> baglantiKlp = new List(11);
  List<int> yazmaSonrasiGecikmeSayaciKLP = new List(11);

  String klpHareketSuresi="2.0";

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;
  bool takipEtiGeciciDurdur=false;

  String baglantiDurum="";
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  OtoManKlepeState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 37) {
        klepeAdet = dbVeri[i]["veri1"];
      }

    }

    

    for(int i=1; i<=10;i++){
      otoKLPE[i]=false;
      klpManAc[i]=false;
      klpManKp[i]=false;
      timerCancelKlp[i]=false;
      baglantiKlp[i]=false;
      yazmaSonrasiGecikmeSayaciKLP[i]=8;
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

@override
  void dispose() {
    timerCancel=true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
final dbProkis = Provider.of<DBProkis>(context);

    if (timerSayac == 0) {

      Metotlar().takipEt('23*$klepeAdet', 2236).then((veri){
            
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri,'23*$klepeAdet');
              baglantiDurum="";
            }
        });

      Timer.periodic(Duration(seconds: 2), (timer) {
        if(!takipEtiGeciciDurdur)
          yazmaSonrasiGecikmeSayaci++;

        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3 && !takipEtiGeciciDurdur) {
          baglanti = true;

          Metotlar().takipEt('23*$klepeAdet', 2236).then((veri){
              
              if(veri.split("*")[0]=="error"){
                baglanti=false;
                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                setState(() {});
              }else{
                takipEtVeriIsleme(veri,'23*$klepeAdet');
                baglantiDurum="";
              }
          });

        }
      });
    }

    timerSayac++;




//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv475',baglantiDurum, alarmDurum),
      body: Column(
        children: <Widget>[


          //Saat ve Tarih
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[300],
                    padding: EdgeInsets.only(left: 10 * oran),
                    child: TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      return Text(
                        Metotlar().getSystemTime(dbVeriler),
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontFamily: 'Kelly Slab',
                            fontSize: 12 * oran,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.grey[300],
                    padding: EdgeInsets.only(right: 10 * oran),
                    child: TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      return Text(
                        Metotlar().getSystemDate(dbVeriler),
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontFamily: 'Kelly Slab',
                            fontSize: 12 * oran,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                ),
              ],
            ),
          
          Expanded(
                        child: Container(color: Colors.white,
                          child: Row(
              children: <Widget>[
                Expanded(flex: 15,
                                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,1,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,2,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,3,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,4,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,5,dbProkis),
                            
                            
                           
                           
                          ],
                      ) 
                    ),
                    Container(height: 10*oran,),

                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,6,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,7,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,8,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,9,dbProkis),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,10,dbProkis),
                            
                            
                            
                            
                            
                          ],
                      ) 
                    ),

                  
                   
],
    ),
                ),
                Spacer()
              ],
            ),
                        ),
          ),
        ],
      ),  
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
          child: FittedBox(
                      child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pop(context);
                /*
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OtoMan1()),
                );
                */
              },
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.arrow_back,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      
      drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
      endDrawer: SizedBox(width: 320*oran,
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
                        Dil().sec(
                            dilSecimi, "tv81"), //Sıcaklık diyagramı
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
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          ListTile(
                            dense: false,
                            title: Text(Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                            subtitle: Text(
                              Dil().sec(dilSecimi, "info16_2"),
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
          ),
        )
        
    );
      
        

//--------------------------SCAFFOLD--------------------------------
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

  
  takipEtVeriIsleme(String gelenMesaj, String komut){
    
    var degerler = gelenMesaj.split('*');
    print(degerler);
    print(yazmaSonrasiGecikmeSayaci);
    //print(yazmaSonrasiGecikmeSayaciTFAN);
    //print(yazmaSonrasiGecikmeSayaciPED);
    print(yazmaSonrasiGecikmeSayaciKLP);

    

    if(komut.split("*")[0]=="23"){
      for(int i=1;i<=int.parse(klepeAdet);i++){
        otoKLPE[i]=degerler[i-1]=="True" ? true : false;
      }
      alarmDurum=degerler[degerler.length-1];
    }

    if(komut.split("*")[0]=="24"){
      for(int i=1;i<=int.parse(klepeAdet);i++){

        klpManAc[i]=degerler[i-1]=="True" ? true : false;
        klpManKp[i]=degerler[i-1+int.parse(klepeAdet)]=="True" ? true : false;

      }
      int x=degerler.length;
      klpHareketSuresi=degerler[x-1];
      alarmDurum=degerler[degerler.length-1];
    }


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  Widget _unsurOtoManWidget(String baslik, String imagePath, double oran,int index, DBProkis dbProkis) {
    return Visibility(visible: index<=int.parse(klepeAdet) || index>5,
          child: Expanded(
          child: Visibility(visible: index<=int.parse(klepeAdet),
                      child: Row(
      children: <Widget>[
        Spacer(),
        Expanded(flex: 10,
                      child: Column(
              children: <Widget>[
                Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    baslik+" $index",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        color: Colors.grey[500],
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                
                Expanded(
                        child: Column(
                        children: <Widget>[
                          //Oto Man Seçimi
                          Expanded(flex: 6,
                            child: Row(
                              children: <Widget>[
                                //Oto
                                Expanded(flex: 10,
                                  child:  RawMaterialButton(
                                    elevation: 8,
                                    onPressed: (){

                                     

                                      yazmaSonrasiGecikmeSayaci = 0;
                                      String komut="27*$index*1";
                                      Metotlar().veriGonder(komut, 2235).then((value){
                                        if(value.split("*")[0]=="error"){
                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                        }else{
                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                          
                                          baglanti = false;
                                          Metotlar().takipEt('23*$klepeAdet', 2236).then((veri){
                                              
                                              if(veri.split("*")[0]=="error"){
                                                baglanti=false;
                                                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                                                setState(() {});
                                              }else{
                                                takipEtVeriIsleme(veri,'23*$klepeAdet');
                                                baglantiDurum="";
                                              }
                                          });
                                        }
                                      });


                                      otoKLPE[index]=true;
                                      klpManAc[index]=false;
                                      klpManKp[index]=false;
                                    

                                      setState(() {
                                        
                                      });

                                    },
                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    fillColor: otoKLPE[index] ? Colors.green[400] : Colors.grey[400],
                                    child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv455"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                              ),
                            
                                    )),
                                Spacer(),
                                //MAN
                                Expanded(flex: 10,
                                  child: RawMaterialButton(
                                    elevation: 8,
                                    onPressed: (){

                                      yazmaSonrasiGecikmeSayaci = 0;
                                      String komut="27*$index*0";
                                      Metotlar().veriGonder(komut, 2235).then((value){
                                        if(value.split("*")[0]=="error"){
                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                        }else{
                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                          
                                          baglanti = false;
                                          Metotlar().takipEt('23*$klepeAdet', 2236).then((veri){
                                              
                                              if(veri.split("*")[0]=="error"){
                                                baglanti=false;
                                                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                                                setState(() {});
                                              }else{
                                                takipEtVeriIsleme(veri,'23*$klepeAdet');
                                                baglantiDurum="";
                                              }
                                          });
                                        }
                                      });

                                      otoKLPE[index]=false;

                                      setState(() {
                                        
                                      });
                                    },
                                    materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    fillColor: !otoKLPE[index] ? Colors.green[400] : Colors.grey[400],
                                    child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv456"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                              ),
                            
                                    )),
                                Spacer(),
                          
                          ],)),
                          
                      ],)),
            
                Expanded(flex: 4,
                            child: Column(
                            children: <Widget>[
                              
                              Spacer(),
                              Expanded(flex: 24,
                              child: Visibility(visible: !otoKLPE[index],
                                  child: RawMaterialButton(
                                    onPressed: (){


                                      takipEtiGeciciDurdur=true;

                                      
                                        timerCancelKlp[index]=false;
                                        Timer.periodic(Duration(seconds: 1), (timer) {
                                            yazmaSonrasiGecikmeSayaciKLP[index]++;
                                            if (timerCancelKlp[index]) {
                                              timer.cancel();
                                            }
                                            if(!baglantiKlp[index] && yazmaSonrasiGecikmeSayaciKLP[index]>1){
                                              baglantiKlp[index]=true;

                                              Metotlar().takipEt('24*$klepeAdet', 2236).then((veri){
                                                  
                                                  if(veri.split("*")[0]=="error"){
                                                    baglanti=false;
                                                    baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                                                    setState(() {});
                                                  }else{
                                                    takipEtVeriIsleme(veri,'24*$klepeAdet');
                                                    baglantiDurum="";
                                                  }
                                              });

                                            }
                                            
                                          });

                                          _manKontrolKLPE(oran,index,dbProkis).then((value){
                                          takipEtiGeciciDurdur=false;
                                          timerCancelKlp[index]=true;
                                        });
                                      
                                      
                                      


                                    },
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    constraints: BoxConstraints(),
                                    elevation: 8,
                                    child: Column(
                                      children: <Widget>[
                                      Expanded(
                                                            child: Container(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi, "tv457"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Kelly Slab',
                                      color: Colors.green,
                                      fontSize: 50,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                                      ),
                                      
                                      Expanded(
                                        flex: 4,
                                      child: Row(
                                        children: <Widget>[
                                          Spacer(),
                                          Expanded(flex: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  alignment: Alignment.center,
                                                  image: AssetImage(imagePath),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                    ),
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                      ),
                                      
  
                                    ],
                                      ),
                                    ),
                                ),
                              ),
                              Spacer(),
                            ],),
                ),
              ],
            ),
        ),
        Spacer()
      ],
            ),
          ),
        ),
    );
  
  }


  Future _manKontrolKLPE(double oran,int index, DBProkis dbProkis){

    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
                                                    return Container(
                                                      color: Colors.orange,
                                                      height: double.infinity,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //Başlık bölümü
                                                          Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                                child: Text(
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv471")+" - "+Dil().sec(dilSecimi, "tv108")+" "+index.toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Column(
                                                                        children: <Widget>[
                                                                          Text(
                                                                            Dil().sec(dilSecimi, "tv472"),
                                                                            textScaleFactor: oran,
                                                                            style: TextStyle(
                                                                              fontFamily: 'Kelly Slab'
                                                                            ),
                                                                            ),
                                                                          RaisedButton(
                                                                            onPressed: () {
                                                                              _index = index;
                                                                              _onlar = int.parse(
                                                                                          klpHareketSuresi.split(".")[0]) <
                                                                                      10
                                                                                  ? 0
                                                                                  : (int.parse(
                                                                                          klpHareketSuresi.split(".")[0]) ~/
                                                                                      10);
                                                                              _birler =
                                                                                  int.parse(klpHareketSuresi.split(".")[0]) %
                                                                                      10;
                                                                              _ondalik =
                                                                                  int.parse(klpHareketSuresi.split(".")[1]);
                                      
                                                                              _degergiris2X1(
                                                                                  _onlar,
                                                                                  _birler,
                                                                                  _ondalik,
                                                                                  _index,
                                                                                  oran,
                                                                                  dilSecimi,
                                                                                  "tv472",
                                                                                  "",dbProkis);
                                                                            },
                                                                            child: Container(
                                                                              color: Colors.blue[700],
                                                                              padding: EdgeInsets.only(top: 5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
                                                                              child: Text(
                                                                                klpHareketSuresi,
                                                                                textScaleFactor: oran,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 30,
                                                                                  color: Colors.white
                                                                                ),
                                                                                ),
                                                                            ),
                                                                            color: Colors.blue[700],
                                                                            elevation: 16,
                                                                            
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Spacer(flex: 3,),
                                                                          bottomDrawerManUnsur(index ,"tv473", klpManAc[index] , oran,dbProkis),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index+10 ,"tv474", klpManKp[index] , oran,dbProkis),
                                                                          Spacer(flex: 3,),
                                                                          
                                                                          //Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  

  Widget bottomDrawerManUnsur(int index, String isim, bool otoManDurum,double oran, DBProkis dbProkis){

    return Expanded(flex: 10,
      child: RawMaterialButton(
    fillColor: otoManDurum ? Colors.green[700] : Colors.grey[500],
    elevation: 8,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    constraints: BoxConstraints(),
             onPressed: (){


       String veri="0";
      bool acYapiyorKapaYapilamaz=false;
      bool kapaYapiyorAcYapilamaz=false;

      if(index>10 && klpManAc[index-10]){
        acYapiyorKapaYapilamaz=true;
      }

      if(index<11 && klpManKp[index]){
        kapaYapiyorAcYapilamaz=true;
      }

      if(acYapiyorKapaYapilamaz){
        Toast.show(Dil().sec(dilSecimi, "toast79"), context,duration: 3);
      }else if(kapaYapiyorAcYapilamaz){
        Toast.show(Dil().sec(dilSecimi, "toast78"), context,duration: 3);
      }else{

        if(otoManDurum){
          if(index>10){
            klpManKp[index-10]=false;
          }else{
            klpManAc[index]=false;
          }
          veri="0";
        }else{
          if(index>10){
            klpManKp[index-10]=true;
          }else{
            klpManAc[index]=true;
          }
          veri="1";
        }

        yazmaSonrasiGecikmeSayaciKLP[index>10 ? index-10 : index]=0;
        
        String komut="28*$index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('24*$klepeAdet', 2236).then((veri){
                
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                  setState(() {});
                }else{
                  takipEtVeriIsleme(veri,'24*$klepeAdet');
                  baglantiDurum="";
                }
            });
          }
        });

      }


             },
             child: Container(padding: EdgeInsets.only(top: 5*oran,bottom: 5*oran),
       child: Row(mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Text(Dil().sec(dilSecimi, isim),style: TextStyle(fontFamily: "Kelly Slab",
           color: otoManDurum ? Colors.white : Colors.black ,
           fontWeight: FontWeight.bold,
           fontSize: 16),
           textScaleFactor: oran,),
           
          
         ],
       ),
             ),
           ),
      );

  }

  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik, onBaslik, DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlar, birler, ondalik, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      String veri="";

        
      klpHareketSuresi=(_onlar*10+_birler).toString()+'.'+_ondalik.toString();
      veri=klpHareketSuresi;
        
      


      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="29*1*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('24*$klepeAdet', 2236).then((veri){
                
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                  setState(() {});
                }else{
                  takipEtVeriIsleme(veri,'24*$klepeAdet');
                  baglantiDurum="";
                }
            });
          }
        });

      }

      setState(() {});
    });
  }


  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }



//--------------------------METOTLAR--------------------------------

}
