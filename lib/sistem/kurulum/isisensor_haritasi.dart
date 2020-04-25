import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/sistem/kurulum/ped_haritasi.dart';
import 'package:prokis/sistem/kurulum/silo_haritasi.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/bacafan_haritasi.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'isitici_haritasi.dart';



class IsiSensorHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  IsiSensorHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;

    return ChangeNotifierProvider<IsisensorHaritasiProvider>(
          create: (context) => IsisensorHaritasiProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){
              final provider = Provider.of<IsisensorHaritasiProvider>(context);



              if (provider.sayac == 0) {
                if(provider.isisensorBaglanti==1){
                  Metotlar().takipEt("24a*", context, 2233, dilSecimi).then((veri){
                    takipEtWifiIsleme(veri, provider);
                  });
                }else{
                  Metotlar().takipEt("24b*", context, 2233, dilSecimi).then((veri){
                    takipEtAnalogIsleme(veri, provider);
                  });
                }

                Timer.periodic(Duration(seconds: 5), (timer) {


                  if (!provider.baglanti && !provider.timerCancel) {
                    provider.setbaglanti = true;

                    if(provider.isisensorBaglanti==1){
                      Metotlar().takipEt("24a*", context, 2233, dilSecimi).then((veri){
                        takipEtWifiIsleme(veri, provider);
                      });
                    }else{
                      Metotlar().takipEt("24b*", context, 2233, dilSecimi).then((veri){
                        takipEtAnalogIsleme(veri, provider);
                      });
                    }
                  }

                  if (provider.timerCancel) {
                    timer.cancel();
                  }

                });
              provider.setsayac=provider.sayac+1;
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
                  Dil().sec(dilSecimi, "tv48"),
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
        //isisensor Harita Oluşturma Bölümü
        Expanded(
          flex: 9,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Spacer(flex: 5,),
                      Expanded(child: 
                      Row(
                        children: <Widget>[
                          Spacer(),
                          Expanded(flex: 4,
                                                      child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv70"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                          ),
                          Spacer()
                        ],
                      )
                      ,),
                      _isisensorHaritaUnsur(22, oran, "tv49", 1,provider,context),
                      Container(height: 5*oran,)
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      //Aktif Sensörler Bölümü
                      Expanded(
                          flex: 13,
                          child: Stack(
                            children: <Widget>[
                              Visibility(
                                visible: provider.isisensorBaglanti==2  ? false : (provider.aktifSenSay==0 ? true : false),
                                child: Center(
                                    child: Text(
                                  Dil()
                                      .sec(dilSecimi, "tv60"),
                                  style: TextStyle(
                                      fontSize: 20 * oran,
                                      fontFamily: "Kelly Slab",
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: oran,
                                )),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        //Aktif sensörler başlık
                                        Expanded(
                                          flex: 2,
                                          child: RotatedBox(
                                            quarterTurns: -45,
                                            child: SizedBox(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "tv51"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 40,
                                                  ),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Aktif Sensorler 1-2-3
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 1
                                              _aktifSensor(1, oran, provider,context),
                                              //Aktif sensör 2
                                              _aktifSensor(2, oran, provider,context),
                                              //Aktif sensör 3
                                              _aktifSensor(3, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 4-5-6
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 4
                                              _aktifSensor(4, oran, provider,context),
                                              //Aktif sensör 5
                                              _aktifSensor(5, oran, provider,context),
                                              //Aktif sensör 6
                                              _aktifSensor(6, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 7-8-9
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 7
                                              _aktifSensor(7, oran, provider,context),
                                              //Aktif sensör 8
                                              _aktifSensor(8, oran, provider,context),
                                              //Aktif sensör 9
                                              _aktifSensor(9, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 10-11-12
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 10
                                              _aktifSensor(10, oran, provider,context),
                                              //Aktif sensör 11
                                              _aktifSensor(11, oran, provider,context),
                                              //Aktif sensör 12
                                              _aktifSensor(12, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 13-14-15
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 13
                                              _aktifSensor(13, oran, provider,context),
                                              //Aktif sensör 14
                                              _aktifSensor(14, oran, provider,context),
                                              //Aktif sensör 15
                                              _aktifSensor(15, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Spacer(),
                      //Sensor Konumları Bölümü
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv57"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv58"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 27,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/bina_catisiz_ust_gorunum.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(
                                          flex: 10,
                                          child: Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        1, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        2, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        3, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        4, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        5, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        6, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        7, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        8, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        9, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        10, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        11, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        12, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        13, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        14, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        15, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        16, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        17, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        18, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        19, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        20, oran, "tv49", 1,provider,context),
                                                    _isisensorHaritaUnsur(
                                                        21, oran, "tv49", 1,provider,context),
                                                  ],
                                                ),
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv59"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                )
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
                //Spacer(),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Haritayı Onayla Butonu
                      Visibility(
                        visible: !provider.haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            int sayac = 0;

                            for (int i = 1; i <= 22; i++) {
                              if (provider.isisensorHarita[i] == 1) {
                                sayac++;
                                provider.isisensorNo[i]=sayac;
                              }
                              
                            }

                            if (sayac < provider.isisensorAdet) {
                              //Haritada seçilen isisensor sayısı eksik
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast51"),
                                  context,
                                  duration: 3);
                            } else if (sayac > provider.isisensorAdet) {
                              //Haritada seçilen isisensor sayısı yüksek
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast52"),
                                  context,
                                  duration: 3);
                            } else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              

                              for (int i = 1; i <= 22; i++) {
                                if (provider.isisensorHarita[i] != 0) {
                                  provider.isisensorVisibility[i]=true;
                                } else {
                                  provider.isisensorVisibility[i]=false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 22; i++) {
                                veri = veri + provider.isisensorHarita[i].toString() + "#";
                              }

                              Metotlar().veriGonder("21*25*$veri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                if(value=="ok"){
                                  dbProkis.dbSatirEkleGuncelle(20, "ok", veri, "0", "0");
                                }
                              });

                              provider.setharitaOnay = true;

                            }

                            //-------------------------ONAY BÖLÜMÜ--------------------------------------------------
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn4"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Haritayı Sıfırla Butonu
                      Visibility(
                        visible: provider.haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            _resetAlert(dilSecimi,context,provider,dbProkis);
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.refresh,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn5"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Verileri Gönder Butonu
                      Visibility(
                        visible: provider.haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            bool sifirNoVarMi = false;
                            bool enAzBirAtama = false;
                            bool sensSayYukNo = false;
                            String noVeri = "";
                            String noVeriAktif = "";
                            String idVeriAktif = "";
                            for (int i = 1; i <= 22; i++) {
                              if (provider.isisensorHarita[i] == 1) {
                                if (provider.isisensorNo[i] == 0) {
                                  sifirNoVarMi = true;
                                }
                                if (provider.isisensorNo[i] > provider.isisensorAdet) {
                                  sensSayYukNo = true;
                                }
                              }
                              noVeri = noVeri + provider.isisensorNo[i].toString() + "#";
                            }
                            for (int i = 1; i <= 15; i++) {
                              noVeriAktif = noVeriAktif + provider.aktifSensorNo[i].toString() + "#";
                              idVeriAktif = idVeriAktif + provider.aktifSensorID[i].toString() + "#";

                              if (provider.aktifSensorNo[i] != 0) {
                                enAzBirAtama = true;
                              }

                            }
                            if (sifirNoVarMi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast35"),
                                  context,
                                  duration: 3);
                            } else if (sensSayYukNo) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast40"),
                                  context,
                                  duration: 3);
                            } else if (provider.isisensorNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast31"),
                                  context,
                                  duration: 3);
                            } else if (!enAzBirAtama) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast34"),
                                  context,
                                  duration: 3);
                            } else if (!provider.atanacakSensorVarmi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast41"),//Aktif sensorlere numara verirken harita üzerindeki numaralar içinde var mı yok mu kontrol  eder. 
                                  context,
                                  duration: 3);
                            } else if (provider.aktifSensorNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast33"),
                                  context,
                                  duration: 3);
                            } else {
                              
                              String komut="22*26*"+noVeri+"*"+noVeriAktif+"*"+idVeriAktif+"*"+provider.isisensorNo[22].toString();
                              Metotlar().veriGonder(komut, context, 2233, "toast8", dilSecimi).then((value){
                                if(value=="ok"){
                                  dbProkis.dbSatirEkleGuncelle(21, "ok", noVeri, noVeriAktif, idVeriAktif);
                                }
                              });
                              provider.setveriGonderildi = true;
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
                          provider.settimerCancel = true;
                          
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PedHaritasi(true)),
                            );
                          
                          
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
                          print(provider.isisensorHarita);
                          if (!provider.veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {
                            provider.settimerCancel = true;


                            if(provider.bacafanAdet!="0"){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BacafanHaritasi(true)),
                              );
                            }else if(provider.airinletAdet!='0' || provider.sirkfanVarMi){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AirInletVeSirkFan(true)),
                              );
                            }else if(provider.isiticiAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiticiHaritasi(true)),
                              );
                            }else if(provider.siloAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SiloHaritasi(true)),
                              );
                            }else{

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DigerCikislar(true)),
                              );
                            }



                            
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

            },
          )

    );
  }

  takipEtWifiIsleme(String veri, IsisensorHaritasiProvider provider){

    var sensorler = veri.split('*');
    print(sensorler);
    provider.setaktifSenSay = (sensorler.length - 1).toInt();
  
    for (int i = 1; i <= 15; i++) {
      if (i <= provider.aktifSenSay) {
        provider.aktifSensorVisibility[i]=true;
      }
    }
    
    for(int i=0;i<=sensorler.length-2;i++){
      var deger=sensorler[i].split('+');
      provider.aktifSensorID[i+1]=deger[0];
      provider.aktifSensorValue[i+1]=deger[1];
      provider.aktifSensorDurum[i+1]=deger[2] == 'ok' ? true : false;
    }

    provider.setbaglanti = false;

  }

  takipEtAnalogIsleme(String veri, IsisensorHaritasiProvider provider){

    print(veri);

    List<bool> aktifSensorVisibility=provider.aktifSensorVisibility;
    List<bool> aktifSensorDurum=provider.aktifSensorDurum;
    List<String> aktifSensorID=provider.aktifSensorID;
    List<String> aktifSensorValue=provider.aktifSensorValue;
    int isisensorAdet=provider.isisensorAdet;

    var sensorler = veri.split('#');
    
        for (int i = 1; i <= 15; i++) {
          if (i%3 != 0) {
            aktifSensorVisibility[i] = true;
          }
        }
        aktifSensorVisibility[1] =  isisensorAdet>=1 ? true :false;
        aktifSensorVisibility[4] =  isisensorAdet>=2 ? true :false;
        aktifSensorVisibility[7] =  isisensorAdet>=3 ? true :false;
        aktifSensorVisibility[10] = isisensorAdet>=4 ? true :false;
        aktifSensorVisibility[13] = isisensorAdet>=5 ? true :false;
        aktifSensorVisibility[2] =  isisensorAdet>=6 ? true :false;
        aktifSensorVisibility[5] =  isisensorAdet>=7 ? true :false;
        aktifSensorVisibility[8] =  isisensorAdet>=8 ? true :false;
        aktifSensorVisibility[11] = isisensorAdet>=9 ? true :false;
        aktifSensorVisibility[14] = isisensorAdet>=10 ? true :false;
      
        aktifSensorID[1] = Dil().sec(dilSecimi, "tv443");
        aktifSensorID[4] = Dil().sec(dilSecimi, "tv444");
        aktifSensorID[7] = Dil().sec(dilSecimi, "tv445");
        aktifSensorID[10] = Dil().sec(dilSecimi, "tv446");
        aktifSensorID[13] = Dil().sec(dilSecimi, "tv447");
        aktifSensorID[2] = Dil().sec(dilSecimi, "tv448");
        aktifSensorID[5] = Dil().sec(dilSecimi, "tv449");
        aktifSensorID[8] = Dil().sec(dilSecimi, "tv450");
        aktifSensorID[11] = Dil().sec(dilSecimi, "tv451");
        aktifSensorID[14] = Dil().sec(dilSecimi, "tv452");
        aktifSensorValue[1]   = sensorler[0] ;
        aktifSensorValue[4]   = sensorler[1] ;
        aktifSensorValue[7]   = sensorler[2] ;
        aktifSensorValue[10]  = sensorler[3] ;
        aktifSensorValue[13]  = sensorler[4] ;
        aktifSensorValue[2]   = sensorler[5] ;
        aktifSensorValue[5]   = sensorler[6];
        aktifSensorValue[8]   = sensorler[7];
        aktifSensorValue[11]  = sensorler[8];
        aktifSensorValue[14]  = sensorler[9];
        aktifSensorDurum[1]   = sensorler[0]=="0.0" ? false : true ;
        aktifSensorDurum[4]   = sensorler[1]=="0.0" ? false : true ;
        aktifSensorDurum[7]   = sensorler[2]=="0.0" ? false : true ;
        aktifSensorDurum[10]  = sensorler[3]=="0.0" ? false : true ;
        aktifSensorDurum[13]  = sensorler[4]=="0.0" ? false : true ;
        aktifSensorDurum[2]   = sensorler[5]=="0.0" ? false : true ;
        aktifSensorDurum[5]   = sensorler[6]=="0.0" ? false : true;
        aktifSensorDurum[8]   = sensorler[7]=="0.0" ? false : true;
        aktifSensorDurum[11]  = sensorler[8]=="0.0" ? false : true;
        aktifSensorDurum[14]  = sensorler[9]=="0.0" ? false : true;

        provider.setbaglanti = false;

        
  }

  
  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/harita_isi_sensor_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }


  Widget _isisensorHaritaUnsur(
      int indexNo, double oran, String baslik, int degerGirisKodu, IsisensorHaritasiProvider provider, BuildContext context) {

        List<int> xx = provider.isisensorHarita;

    return Expanded(
      child: Visibility(
        visible: provider.isisensorVisibility[indexNo] ? true : false,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: RawMaterialButton(
                  onPressed: () {
                    if (provider.haritaOnay) {


                int sayi = provider.isisensorNo[indexNo];
                int pOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                int pBirler = sayi % 10;

                MyshowModalBottomSheet2x0(dilSecimi, context, oran,pOnlar, pBirler,"tv49","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {
                              sayi =value[1] * 10 + value[2];
                              provider.isisensorNo[indexNo]=sayi;
                              provider.tekerrurTespit(indexNo);
                          }

                });

                    } else {
                      if (xx[indexNo] == 0 ||
                          xx[indexNo] == null) {
                        xx[indexNo] = 1;
                        provider.dinlemeyiTetikle();
                      } else if (xx[indexNo] == 1) {
                        xx[indexNo] = 0;
                        provider.dinlemeyiTetikle();
                      }

                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          //color: Colors.pink,
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                imageGetir(provider.isisensorHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.haritaOnay && provider.isisensorHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 5,
                            ),
                            //isisensor No
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          Dil().sec(
                                                  dilSecimi, "tv50") +
                                              provider.isisensorNo[indexNo].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future _resetAlert(String x, BuildContext context, IsisensorHaritasiProvider provider, DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return ResetAlert.deger(x);
      },
    ).then((val) {
      if (val) {

        for (int i = 0; i < 23; i++) {
          provider.isisensorHarita[i]=0;
          provider.isisensorNo[i]=0;
          provider.isisensorVisibility[i]=true;
        }

        for (int i = 0; i < 16; i++) {
          provider.aktifSensorNo[i]=0;
        }

        provider.setveriGonderildi = false;
        provider.setharitaOnay = false;

        Metotlar().veriGonder("23*0*0*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
          if(value=="ok"){
            dbProkis.dbSatirEkleGuncelle(20, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(21, "0", "0", "0", "0");
          }
        });
      }
    });
  }
  
  Widget _aktifSensor(int index, double oran, IsisensorHaritasiProvider provider, BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: provider.aktifSensorVisibility[index],
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              Dil().sec(dilSecimi, "tv50") +
                  provider.aktifSensorNo[index].toString(),
              style: TextStyle(
                  fontSize: 14,
                  color: provider.aktifSensorNo[index] == 0
                      ? Colors.black
                      : Colors.blue[700],
                  fontWeight: provider.aktifSensorNo[index] == 0
                      ? FontWeight.normal
                      : FontWeight.bold),
              textScaleFactor: oran,
            ),
            Expanded(
              child: RawMaterialButton(
                onPressed: () {

                  int sayi = provider.aktifSensorNo[index];
                int pOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                int pBirler = sayi % 10;

                MyshowModalBottomSheet2x0(dilSecimi, context, oran,pOnlar, pBirler,"tv61","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {
                              sayi =value[1] * 10 + value[2];
                              provider.aktifSensorNo[index]=sayi;
                              provider.tekerrurTespit(index);
                          }

                });

                  


                },
                fillColor:
                    provider.aktifSensorDurum[index] ? Colors.green[300] : Colors.red,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: AutoSizeText(
                            provider.aktifSensorID[index] + " :",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.0,
                                fontFamily: 'Kelly Slab'),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: AutoSizeText(
                            provider.aktifSensorValue[index] + "°C",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
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
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(minWidth: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class IsisensorHaritasiProvider with ChangeNotifier {
  int sayac=0;

  List<int> isisensorHarita = new List.filled(23,0);
  List<bool> isisensorVisibility = new List.filled(23,true);
  List<int> isisensorNo = new List.filled(23,0);
  bool haritaOnay = false;
  String bacafanAdet = '0';
  String airinletAdet = '0';
  String isiticiAdet = '0';
  String siloAdet = '0';
  int isisensorAdet = 0;
  int isisensorBaglanti = 1;
  bool sirkfanVarMi = false;

  bool veriGonderildi = false;
  bool isisensorNoTekerrur = false;

  int sayacAktifSensor = 0;
  bool baglanti = true;
  bool timerCancel = false;

  List<bool> aktifSensorVisibility = new List.filled(16,false);
  List<int> aktifSensorNo = new List.filled(16,0);
  List<String> aktifSensorID = new List.filled(16,"");
  List<String> aktifSensorValue = new List.filled(16,"");
  List<bool> aktifSensorDurum = new List.filled(16,false);
  int aktifSenSay = 0;
  bool aktifSensorNoTekerrur = false;
  bool atanacakSensorVarmi = true;

  List<int> tumCikislar = new List.filled(111,0);

  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(int index){

    isisensorNoTekerrur = false;

      for (int i = 1; i <= 22; i++) {
        for (int k = 1; k <= 22; k++) {
          if (i != k &&
              isisensorNo[i] == isisensorNo[k] &&
              isisensorNo[i] != 0 &&
              isisensorNo[k] != 0) {
            isisensorNoTekerrur = true;
            break;
          }
          if (isisensorNoTekerrur) {
            break;
          }
        }
      }


    aktifSensorNoTekerrur = false;

      for (int i = 1; i <= 15; i++) {
        for (int k = 1; k <= 15; k++) {
          if (i != k &&
              aktifSensorNo[i] == aktifSensorNo[k] &&
              aktifSensorNo[i] != 0 &&
              aktifSensorNo[k] != 0) {
            aktifSensorNoTekerrur = true;
            break;
          }
          if (aktifSensorNoTekerrur) {
            break;
          }
        }
      }

      atanacakSensorVarmi = false;
      for (int i = 1; i <= 22; i++) {
        if (isisensorNo[i] != 0 && aktifSensorNo[index] == isisensorNo[i]) {
          atanacakSensorVarmi = true;
          break;
        }
      }
      notifyListeners();
  }



  set setsayac(int value) {
    sayac = value;
  }
  set setharitaOnay(bool value) {
    haritaOnay = value;
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
  set setisisensorAdet(int value) {
    isisensorAdet = value;
    notifyListeners();
  }
  set setisisensorBaglanti(int value) {
    isisensorBaglanti = value;
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
  set setisisensorNoTekerrur(bool value) {
    isisensorNoTekerrur = value;
    notifyListeners();
  }
  set setsayacAktifSensor(int value) {
    sayacAktifSensor = value;
    notifyListeners();
  }
  set setbaglanti(bool value) {
    baglanti = value;
    notifyListeners();
  }
  set settimerCancel(bool value) {
    timerCancel = value;
    notifyListeners();
  }
  set setaktifSenSay(int value) {
    aktifSenSay = value;
    notifyListeners();
  }
  set setaktifSensorNoTekerrur(bool value) {
    aktifSensorNoTekerrur = value;
    notifyListeners();
  }
  set setatanacakSensorVarmi(bool value) {
    atanacakSensorVarmi = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  IsisensorHaritasiProvider(this.context, this.dbProkis) {

    var xx=dbProkis.dbVeriGetir(4, 4, "1").split('#');
    isisensorAdet = int.parse(xx[0]);
    isisensorBaglanti=int.parse(xx[1]);

    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet=dbProkis.dbVeriGetir(5, 4, "0");


    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(20, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(21, 1, "");
    var tcikislar;
    var fHaritalar;
    var isisensorNolar;
    var aktifIsisensorNolar;
    var aktifIsisensorIDler;
    

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(20, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      isisensorNolar = dbProkis.dbVeriGetir(21, 2, "").split("#");
      aktifIsisensorNolar = dbProkis.dbVeriGetir(21, 3, "").split("#");
      aktifIsisensorIDler = dbProkis.dbVeriGetir(21, 4, "").split("#");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i - 1]);
      }
    }

    for (var i = 1; i <= 22; i++) {

      if (haritaKAYIT == "ok") {
        isisensorHarita[i] = int.parse(fHaritalar[i - 1]);
        if (fHaritalar[i - 1] != "0") {
          haritaOnay = true;
          isisensorVisibility[i] = true;
        }else{
          isisensorVisibility[i] = false;
        }
      }
      
      
    }

    for (var i = 1; i <= 22; i++) {
      if(cikisKAYIT == "ok"){
        isisensorNo[i] = int.parse(isisensorNolar[i - 1]);
      }
    }

    if(cikisKAYIT=="ok"){

      if (aktifIsisensorNolar.length > 2 && aktifIsisensorIDler.length > 2) {
        for (int i = 1; i <= 15; i++) {
          aktifSensorNo[i] = int.parse(aktifIsisensorNolar[i - 1]);
          aktifSensorID[i] = aktifIsisensorIDler[i - 1];
        }
      } else {
        for (int i = 1; i <= 15; i++) {
          aktifSensorNo[i] = 0;
        }
      }

    }

  }
  
}
