import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet4x0.dart';
import 'package:prokis/mywidgets/showModalBottomSheetQ%20.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sabitVeriler.dart';
import 'package:prokis/sistem/kurulum/girisler.dart';
import 'package:prokis/sistem/kurulum/isitici_haritasi.dart';
import 'package:prokis/sistem/kurulum/silo_haritasi.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/bacafan_haritasi.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';

class DigerCikislar extends StatelessWidget {
  bool ilkKurulumMu = true;
  DigerCikislar(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  int sayac=0;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;

    return ChangeNotifierProvider<DigerCikislarProvider>(
          create: (context) => DigerCikislarProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){

              final provider = Provider.of<DigerCikislarProvider>(context);

              if(sayac==0){
                new Timer(Duration(seconds: 0, milliseconds: 1000), (){
                  provider.setsayac=1;
                  sayac++;
                });
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
            child: SizedBox(
              child: Container(
                color: Colors.grey.shade600,
                alignment: Alignment.center,
                child: AutoSizeText(
                  Dil().sec(dilSecimi, "tv85"),
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
            )),
        //aluyay Harita Oluşturma Bölümü
        Expanded(
          flex: 9,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
                Expanded(flex:5,child: _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv398"),
                            oran,
                            provider.sayacAdet,
                            SabitVeriler().adetOdan12ye,
                            1,provider,context)
                            ),
                
                //Çıkışların olduğu bölüm
                Expanded(
                  flex: 21,
                  child: Column(
                    children: <Widget>[
                      
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _alarmVeUyariUnsur(1, oran,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _alarmVeUyariUnsur(2, oran,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                    children: <Widget>[
                                      _aydinlatmaUnsur(3, oran,provider,context),
                                    ],
                                  ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi,"tv334"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),
                            Expanded(flex: 2,
                              child: RawMaterialButton(
                                        onPressed: () {
                                          if (provider.dimmer) {
                                            provider.setdimmer = false;
                                          } else {
                                            provider.setdimmer = true;
                                            
                                            provider.cikisAluyayNo[3]=0;
                                          }
                                          if(provider.dimmer!=provider.yrd[4]){
                                            provider.setveriGonderildi=false;
                                          }
                                        },
                                        child: Icon(
                                          provider.dimmer == true
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: provider.dimmer == true
                                              ? Colors.green[600]
                                              : Colors.black,
                                          size: 25 * oran,
                                        ),
                                        padding: EdgeInsets.all(0),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        constraints: BoxConstraints(),
                                      ),
                            ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      Dil()
                                          .sec(dilSecimi, "tv95"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (provider.yem1Aktif) {
                                          provider.setyem1Aktif = false;
                                        } else {
                                          provider.setyem1Aktif = true;
                                        }
                                        if(provider.yem1Aktif!=provider.yrd[1]){
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                        provider.yem1Aktif == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: provider.yem1Aktif == true
                                            ? Colors.green[600]
                                            : Colors.black,
                                        size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      Dil()
                                          .sec(dilSecimi, "tv96"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (provider.yem2Aktif) {
                                          provider.setyem2Aktif = false;
                                        } else {
                                          provider.setyem2Aktif = true;
                                        }
                                        if(provider.yem2Aktif!=provider.yrd[2]){
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                        provider.yem2Aktif == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: provider.yem2Aktif == true
                                            ? Colors.green[600]
                                            : Colors.black,
                                        size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      Dil()
                                          .sec(dilSecimi, "tv97"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (provider.yem3Aktif) {
                                          provider.setyem3Aktif = false;
                                        } else {
                                          provider.setyem3Aktif = true;
                                        }
                                        if(provider.yem3Aktif!=provider.yrd[3]){
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                        provider.yem3Aktif == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: provider.yem3Aktif == true
                                            ? Colors.green[600]
                                            : Colors.black,
                                        size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(flex: 2,),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem1(1, oran, provider.yem1Aktif,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem2(1, oran, provider.yem2Aktif,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem3(1, oran, provider.yem3Aktif,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(flex: 2,),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem1(2, oran, provider.yem1Aktif,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem2(2, oran, provider.yem2Aktif,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem3(2, oran, provider.yem3Aktif,provider,context),
                                  ],
                                ),
                              ),
                              Spacer(flex: 2,),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
                Metotlar().cikislariGetir(provider.tumCikislar, oranOzel, oran, 11, true, sayac, dilSecimi)
              ],
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey.shade600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Verileri Gönder Bölümü
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Verileri Gönder Butonu
                      FlatButton(
                        onPressed: () {
                          
                          String cikisVeri1 = "";
                          String cikisVeri2 = "";
                          String cikisVeri3 = "";
                          String cikisVeri4 = "";
                          String cikisVeri5 = "";

                          String tumCikislarVeri = "";
                          bool cikisSifirMi = false;
                          bool cikisKullanimda = false;

                          for (int i = 1; i <= 3; i++) {
                            if (provider.cikisAluyayNo[i] == 0) {
                              if(i==3 && provider.dimmer){

                              }else{
                                cikisSifirMi = true;
                              }
                            }
                            cikisVeri1 =
                                cikisVeri1 + provider.cikisAluyayNo[i].toString() + "#";
                          }


                          for (int i = 1; i <= 2; i++) {
                            if (provider.cikisYem1No[i] == 0 && provider.yem1Aktif) {
                              cikisSifirMi = true;
                            }
                            if (provider.cikisYem2No[i] == 0 && provider.yem2Aktif) {
                              cikisSifirMi = true;
                            }
                            if (provider.cikisYem3No[i] == 0 && provider.yem3Aktif) {
                              cikisSifirMi = true;
                            }
                            cikisVeri2 =
                                cikisVeri2 + (provider.yem1Aktif ? provider.cikisYem1No[i].toString() : "0") + "#";
                            cikisVeri3 =
                                cikisVeri3 + (provider.yem2Aktif ? provider.cikisYem2No[i].toString() : "0") + "#";
                            cikisVeri4 =
                                cikisVeri4 + (provider.yem3Aktif ? provider.cikisYem3No[i].toString() : "0") + "#";
                          }

                          cikisVeri5 = (provider.yem1Aktif ? "1" : "0") +
                              "#" +
                              (provider.yem2Aktif ? "1" : "0") +
                              "#" +
                              (provider.yem3Aktif ? "1" : "0");


                          for (int i = 1; i <= 3; i++) {
                            if (provider.cikisAluyayNoGecici[i] != provider.cikisAluyayNo[i]) {
                              if (provider.tumCikislar[provider.cikisAluyayNo[i]] == 0) {
                                
                                provider.tumCikislar[provider.cikisAluyayNoGecici[i]]=0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }

                          }

                          for (int i = 1; i <= 2; i++) {
                            if (provider.cikisYem1NoGecici[i] != provider.cikisYem1No[i]) {
                              if (provider.tumCikislar[provider.cikisYem1No[i]] == 0) {
                                
                                provider.tumCikislar[provider.cikisYem1NoGecici[i]]=0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }

                            if (provider.cikisYem2NoGecici[i] != provider.cikisYem2No[i]) {
                              if (provider.tumCikislar[provider.cikisYem2No[i]] == 0) {
                                
                                provider.tumCikislar[provider.cikisYem2NoGecici[i]]=0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }

                            if (provider.cikisYem3NoGecici[i] != provider.cikisYem3No[i]) {
                              if (provider.tumCikislar[provider.cikisYem3No[i]] == 0) {
                                provider.tumCikislar[provider.cikisYem3NoGecici[i]]=0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }
                          }
                          

                          if (cikisSifirMi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast97"),
                                context,
                                duration: 3);
                          } else if (provider.cikisNoTekerrur) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast26"),
                                context,
                                duration: 3);
                          } else {


                            for (int i = 1; i <= 3; i++) {
                              if (provider.cikisAluyayNo[i] != 0) {
                                provider.tumCikislar[provider.cikisAluyayNo[i]]=1;
                              }
                            }

                            for (int i = 1; i <= 2; i++) {
                              if (provider.cikisYem1No[i] != 0) {
                                provider.tumCikislar[provider.cikisYem1No[i]]=1;
                              }
                              if (provider.cikisYem2No[i] != 0) {
                                provider.tumCikislar[provider.cikisYem2No[i]]=1;
                              }
                              if (provider.cikisYem3No[i] != 0) {
                                provider.tumCikislar[provider.cikisYem3No[i]]=1;
                              }
                            }


                            for (int i = 1; i <= 2; i++) {
                            if (!provider.yem1Aktif) {
                              provider.tumCikislar[provider.cikisYem1NoGecici[i]]=0;
                              provider.cikisYem1No[i]=0;
                            }
                            if (!provider.yem2Aktif) {
                              provider.tumCikislar[provider.cikisYem2NoGecici[i]]=0;
                              provider.cikisYem2No[i]=0;
                            }
                            if (!provider.yem3Aktif) {
                              provider.tumCikislar[provider.cikisYem3NoGecici[i]]=0;
                              provider.cikisYem3No[i]=0;
                            }
                          }

                            for (int i = 1; i <= 110; i++) {
                              tumCikislarVeri = tumCikislarVeri +
                                  provider.tumCikislar[i].toString() +
                                  "#";
                            }
                            provider.setveriGonderildi = true;
                            bool xx=provider.dimmer;
                            String yy= xx ? "1" : "0";
                            String komut="38*36*"+cikisVeri1+cikisVeri2+cikisVeri3+cikisVeri4+"*"+cikisVeri5+"*"+yy+"*"+provider.sayacAdet+"#"+ provider.palsBasinaLitre+"#"+ (provider.suAlarm==true ? "1" : "0");
                            Metotlar().veriGonder(komut, 2233).then((value){
                              if(value.split("*")[0]=="error"){
                                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                              }else{
                                 Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", 2233).then((value){
                                    if(value.split("*")[0]=="error"){
                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                    }else{
                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                      String veri=cikisVeri1+cikisVeri2+cikisVeri3+cikisVeri4;
                                      dbProkis.dbSatirEkleGuncelle(31, "ok", veri, cikisVeri5 , yy );
                                      dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0" , "0" );
                                      dbProkis.dbSatirEkleGuncelle(33, provider.sayacAdet, provider.palsBasinaLitre, (provider.suAlarm ? "1" : "0") , "0" );
                                    }

                                 });
                              }
                            });

                            for (int i = 1; i <= 3; i++) {
                              provider.cikisAluyayNoGecici[i] = provider.cikisAluyayNo[i];
                            }

                            for (int i = 1; i <= 2; i++) {
                              provider.cikisYem1NoGecici[i] = provider.cikisYem1No[i];
                              provider.cikisYem2NoGecici[i] = provider.cikisYem2No[i];
                              provider.cikisYem3NoGecici[i] = provider.cikisYem3No[i];
                            }
                            provider.yrd[1]=provider.yem1Aktif;
                            provider.yrd[2]=provider.yem2Aktif;
                            provider.yrd[3]=provider.yem3Aktif;
                            provider.yrd[4]=provider.dimmer;

                            provider.setveriGonderildi = true;
                            
                          }
                          
                        },
                        highlightColor: Colors.green,
                        splashColor: Colors.red,
                        color: provider.veriGonderildi ? Colors.green[500] : Colors.blue,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.send,
                              size: 30 * oran,
                            ),
                            Text(
                              Dil().sec(dilSecimi, "btn6"),
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

                          if(provider.siloAdet!="0"){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SiloHaritasi(true)),
                              );
                            }else if(provider.isiticiAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiticiHaritasi(true)),
                              );
                            }else if(provider.airinletAdet!='0' || provider.sirkfanVarMi){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AirInletVeSirkFan(true)),
                              );
                            }else if(provider.bacafanAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BacafanHaritasi(true)),
                              );
                            }else{

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiSensorHaritasi(true)),
                              );
                            }
                          
                          //Navigator.pop(context, tumCikislar);
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
                          if (!provider.veriGonderildi) {
                            Toast.show(
                                Dil().sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);


                          } else {

                            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Girisler(true)),
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
    ));


            }
          )
    );
  }


  Widget _alarmVeUyariUnsur(int index, double oran, DigerCikislarProvider provider, BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Expanded(child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi,
                                  index == 1 ? "tv86" : (index == 2 ? "tv87" : "tv88")),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),

          
          Expanded(flex: 2,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {

                    String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisAluyayNo[index]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(outNoMetin=="Q#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(2, 3)
                          : outNoMetin.substring(1, 2));
                      qBit =
                          int.parse(outNoMetin.substring(outNoMetin.length - 1));
                    }

                MyshowModalBottomSheetQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              
                              provider.cikisAluyayNo[index]=cikisNo;
                              provider.tekerrurTespit();

                            }



                          }


                });

                    },
                    fillColor: Colors.green[300],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Metotlar().outConvSAYItoQ(provider.cikisAluyayNo[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(minWidth: double.infinity),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aydinlatmaUnsur(int index, double oran, DigerCikislarProvider provider, BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Expanded(child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi,
                                  index == 1 ? "tv86" : (index == 2 ? "tv87" : "tv88")),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),

          
          Expanded(flex: 2,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {

                      if(provider.dimmer){
                        Toast.show(Dil().sec(dilSecimi, "toast75"), context,duration: 3);
                      }else{

                        String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisAluyayNo[index]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(outNoMetin=="Q#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(2, 3)
                          : outNoMetin.substring(1, 2));
                      qBit =
                          int.parse(outNoMetin.substring(outNoMetin.length - 1));
                    }

                MyshowModalBottomSheetQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              
                              provider.cikisAluyayNo[index]=cikisNo;
                              provider.tekerrurTespit();

                            }



                          }


                });




                      }

                    },
                    fillColor: provider.dimmer ? Colors.grey[600] : Colors.green[300],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Metotlar().outConvSAYItoQ(provider.cikisAluyayNo[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(minWidth: double.infinity),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _aluyayGrupCikisYem1(int index, double oran, bool aktif, DigerCikislarProvider provider, BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Expanded(child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil()
                .sec(dilSecimi, index == 1 ? "tv89" : "tv92"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),

          
          Expanded(flex: 2,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {

                      if (provider.yem1Aktif) {

                    String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisYem1No[index]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(outNoMetin=="Q#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(2, 3)
                          : outNoMetin.substring(1, 2));
                      qBit =
                          int.parse(outNoMetin.substring(outNoMetin.length - 1));
                    }

                MyshowModalBottomSheetQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              
                              provider.cikisYem1No[index]=cikisNo;
                              provider.tekerrurTespit();

                            }



                          }


                });



                        


                            
                      }










                    },
                    fillColor: aktif ? Colors.green[300] : Colors.grey[600],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Metotlar().outConvSAYItoQ(provider.cikisYem1No[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(minWidth: double.infinity),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aluyayGrupCikisYem2(int index, double oran, bool aktif, DigerCikislarProvider provider, BuildContext context ) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Expanded(child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil()
                .sec(dilSecimi, index == 1 ? "tv90" : "tv93"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),
          Expanded(flex: 2,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {


                      if (provider.yem2Aktif) {

                        String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisYem2No[index]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(outNoMetin=="Q#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(2, 3)
                          : outNoMetin.substring(1, 2));
                      qBit =
                          int.parse(outNoMetin.substring(outNoMetin.length - 1));
                    }

                MyshowModalBottomSheetQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              provider.cikisYem2No[index]=cikisNo;
                              provider.tekerrurTespit();
                            }



                          }


                });
                        


                            
                      }
                    },
                    fillColor: aktif ? Colors.green[300] : Colors.grey[600],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Metotlar().outConvSAYItoQ(provider.cikisYem2No[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(minWidth: double.infinity),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aluyayGrupCikisYem3(int index, double oran, bool aktif, DigerCikislarProvider provider, BuildContext context){
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Expanded(child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil()
                .sec(dilSecimi, index == 1 ? "tv91" : "tv94"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),
          Expanded(flex: 2,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (provider.yem3Aktif) {

                        String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisYem3No[index]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(outNoMetin=="Q#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(2, 3)
                          : outNoMetin.substring(1, 2));
                      qBit =
                          int.parse(outNoMetin.substring(outNoMetin.length - 1));
                    }

                MyshowModalBottomSheetQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              provider.cikisYem3No[index]=cikisNo;
                              provider.tekerrurTespit();

                            }



                          }


                });
                        







                      }
                    },
                    fillColor: aktif ? Colors.green[300] : Colors.grey[600],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Metotlar().outConvSAYItoQ(provider.cikisYem3No[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(minWidth: double.infinity),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sayacUnsur( double oran, DigerCikislarProvider provider, BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        children: <Widget>[
          Expanded(flex: 2,
            child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi,"tv399"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 2,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),

          
          Expanded(flex: 2,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {


                      int sayi = int.parse(provider.palsBasinaLitre);
                      int pBinler = sayi < 1000 ? 0 : (sayi ~/ 1000).toInt();
                      int pYuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                      int pOnlar = sayi < 10 ? 0 : (sayi%100) ~/ 10;
                      int pBirler = sayi % 10;

                MyshowModalBottomSheet4x0(dilSecimi, context, oran,pBinler, pYuzler,pOnlar, pBirler,"tv49","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {
                              sayi =value[1] * 1000 + value[2]*100+value[3]*10+value[4];
                              provider.setpalsBasinaLitre=sayi.toString();
                          }

                });
                      


                    },
                    fillColor: Colors.orange[700],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  provider.palsBasinaLitre.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(minWidth: double.infinity),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _unsurAdetWidget(String baslik, double oran,
      String dropDownValue, List<String> liste, int adetCode, DigerCikislarProvider provider, BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(flex: 1,),
        Expanded(
          flex: 2,
          child: SizedBox(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: AutoSizeText(
                baslik,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Kelly Slab',
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                minFontSize: 8,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[300],
            child: DropdownButton<String>(
              isDense: true,
              value: dropDownValue,
              elevation: 16,
              iconEnabledColor: Colors.black,
              iconSize: 40 * oran,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Kelly Slab',
                fontSize: 30 * oran,
                fontWeight: FontWeight.bold,
              ),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                  
                  if(provider.sayacAdet!=newValue){
                    provider.setveriGonderildi=false;
                  }
                  
                  provider.setsayacAdet = newValue;
              },
              items: liste.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(

                    child: Text(value),
                    padding: EdgeInsets.only(left: 10*oran, bottom: 0*oran, top: 0*oran),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Spacer(flex: 1,),
        _sayacUnsur(oran,provider, context),
        Spacer(flex: 1,),
        Expanded(flex: 2,
          child: 
          SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi,"tv637"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0,
                                      fontFamily: 'Kelly Slab'),
                                  maxLines: 2,
                                  minFontSize: 8,
                                ),
                              ),
                            ),),
        Expanded(flex: 1,
            child: RawMaterialButton(
                      onPressed: () {
                        if (provider.suAlarm) {
                          provider.setsuAlarm = false;
                        } else {
                          provider.setsuAlarm = true;
                        }

                        if(provider.suAlarm!=provider.yrd[4]){
                          provider.setveriGonderildi=false;
                        }
                      },
                      child: Icon(
                        provider.suAlarm == true
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: provider.suAlarm == true
                            ? Colors.green[600]
                            : Colors.black,
                        size: 25 * oran,
                      ),
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      constraints: BoxConstraints(),
                    ),
          ),
        Spacer()
      ],
    );
  }

 


}

class DigerCikislarProvider with ChangeNotifier {
  int sayac=0;

  String sayacAdet = "0";
  String palsBasinaLitre = "0";
  String bacafanAdet = '0';
  String airinletAdet = '0';
  String isiticiAdet = '0';
  String siloAdet = '0';
  bool sirkfanVarMi = false;

  List<int> cikisAluyayNo = new List.filled(4,0);
  List<int> cikisAluyayNoGecici = new List.filled(4,0);
  List<int> cikisYem1No = new List.filled(3,0);
  List<int> cikisYem1NoGecici = new List.filled(3,0);
  List<int> cikisYem2No = new List.filled(3,0);
  List<int> cikisYem2NoGecici = new List.filled(3,0);
  List<int> cikisYem3No = new List.filled(3,0);
  List<int> cikisYem3NoGecici = new List.filled(3,0);

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;
  bool yem1Aktif = false;
  bool yem2Aktif = false;
  bool yem3Aktif = false;

  bool aluyayCikislarOK = false;

  List<int> tumCikislar = new List.filled(111,0);

  bool dimmer=false;
  bool suAlarm=false;

  List<bool> yrd = new List.filled(5,false);

  
  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(){
    cikisNoTekerrur = false;

    List<int> cikislar = new List.filled(10,0);

    cikislar[1]=cikisAluyayNo[1];
    cikislar[2]=cikisAluyayNo[2];
    cikislar[3]=cikisAluyayNo[3];
    cikislar[4]=cikisYem1No[1];
    cikislar[5]=cikisYem1No[2];
    cikislar[6]=cikisYem2No[1];
    cikislar[7]=cikisYem2No[2];
    cikislar[8]=cikisYem3No[1];
    cikislar[9]=cikisYem3No[2];

    for (int i = 1; i <= 9; i++) {
      for (int k = 1; k <= 9; k++) {
        if (i != k &&
            cikislar[i] == cikislar[k] &&
            cikislar[i] != 0 &&
            cikislar[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
    }
      notifyListeners();
  }


  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }
  set setsayacAdet(String value) {
    sayacAdet = value;
    notifyListeners();
  }
  set setpalsBasinaLitre(String value) {
    palsBasinaLitre = value;
    notifyListeners();
  }
  set setbacafanAdet(String value) {
    bacafanAdet = value;
    notifyListeners();
  }
  set setairinletAdet(String value) {
    airinletAdet = value;
    notifyListeners();
  }
  set setisiticiAdet(String value) {
    isiticiAdet = value;
    notifyListeners();
  }
  set setsiloAdet(String value) {
    siloAdet = value;
    notifyListeners();
  }
  set setsirkfanVarMi(bool value) {
    sirkfanVarMi = value;
    notifyListeners();
  }
  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }
  set setcikisNoTekerrur(bool value) {
    cikisNoTekerrur = value;
    notifyListeners();
  }
  set setyem1Aktif(bool value) {
    yem1Aktif = value;
    notifyListeners();
  }
  set setyem2Aktif(bool value) {
    yem2Aktif = value;
    notifyListeners();
  }
  set setyem3Aktif(bool value) {
    yem3Aktif = value;
    notifyListeners();
  }
  set setaluyayCikislarOK(bool value) {
    aluyayCikislarOK = value;
    notifyListeners();
  }
  set setdimmer(bool value) {
    dimmer = value;
    notifyListeners();
  }
  set setsuAlarm(bool value) {
    suAlarm = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  DigerCikislarProvider(this.context, this.dbProkis) {


    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet=dbProkis.dbVeriGetir(5, 4, "0");

    sayacAdet=dbProkis.dbVeriGetir(33, 1, "0");
    palsBasinaLitre=dbProkis.dbVeriGetir(33, 2, "0");
    suAlarm=dbProkis.dbVeriGetir(33, 3, false)=="1" ? true : false;


    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String aluyayKAYIT = dbProkis.dbVeriGetir(31, 1, "");
    var tcikislar;
    var aluyayNolar;
    var aktifYemCikislar;
    

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (aluyayKAYIT == "ok") {
      veriGonderildi=true;
      aluyayNolar = dbProkis.dbVeriGetir(31, 2, "").split("#");
      aktifYemCikislar = dbProkis.dbVeriGetir(31, 3, "").split("#");
      cikisAluyayNo[1] = int.parse(aluyayNolar[0]);
      cikisAluyayNo[2] = int.parse(aluyayNolar[1]);
      cikisAluyayNo[3] = int.parse(aluyayNolar[2]);
      cikisYem1No[1] = int.parse(aluyayNolar[3]);
      cikisYem1No[2] = int.parse(aluyayNolar[4]);
      cikisYem2No[1] = int.parse(aluyayNolar[5]);
      cikisYem2No[2] = int.parse(aluyayNolar[6]);
      cikisYem3No[1] = int.parse(aluyayNolar[7]);
      cikisYem3No[2] = int.parse(aluyayNolar[8]);
      yem1Aktif = aktifYemCikislar[0] == "1" ? true : false;
      yem2Aktif = aktifYemCikislar[1] == "1" ? true : false;
      yem3Aktif = aktifYemCikislar[2] == "1" ? true : false;
      dimmer=dbProkis.dbVeriGetir(31, 4, false)=='1' ? true : false;

    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i-1]);
      }
    }

    for (int i = 1; i <= 3; i++) {
      cikisAluyayNoGecici[i] = cikisAluyayNo[i];
    }

    for (int i = 1; i <= 2; i++) {
      cikisYem1NoGecici[i] = cikisYem1No[i];
      cikisYem2NoGecici[i] = cikisYem2No[i];
      cikisYem3NoGecici[i] = cikisYem3No[i];
    }

    yrd[1]=yem1Aktif;
    yrd[2]=yem2Aktif;
    yrd[3]=yem3Aktif;
    yrd[4]=dimmer;
    
  }
  
}
