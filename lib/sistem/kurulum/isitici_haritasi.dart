import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0.dart';
import 'package:prokis/mywidgets/showModalBottomSheetQ%20.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:prokis/sistem/kurulum/silo_haritasi.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/bacafan_haritasi.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';

class IsiticiHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  IsiticiHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  int sayac=0;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;
    
    return ChangeNotifierProvider<IsiticiHaritasiProvider>(
          create: (context) => IsiticiHaritasiProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){

              final provider = Provider.of<IsiticiHaritasiProvider>(context);

              if(sayac==0){
                print(provider.sayac);
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
                  Dil().sec(dilSecimi, "tv76"),
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
        //isitici Harita Oluşturma Bölümü
        Expanded(
          flex: 9,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 12,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Spacer(),
                                    _isiticiGrupCikis(1, oran, provider, context),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Spacer(),
                                    _isiticiGrupCikis(2, oran, provider, context),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Spacer(),
                                    _isiticiGrupCikis(3, oran, provider, context),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),

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
                                                    _isiticiHaritaUnsur(
                                                        1, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        2, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        3, oran, "tv80", provider, context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isiticiHaritaUnsur(
                                                        4, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        5, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        6, oran, "tv80", provider, context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isiticiHaritaUnsur(
                                                        7, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        8, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        9, oran, "tv80", provider, context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isiticiHaritaUnsur(
                                                        10, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        11, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        12, oran, "tv80", provider, context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isiticiHaritaUnsur(
                                                        13, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        14, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        15, oran, "tv80", provider, context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isiticiHaritaUnsur(
                                                        16, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        17, oran, "tv80", provider, context),
                                                    Spacer(),
                                                    _isiticiHaritaUnsur(
                                                        18, oran, "tv80", provider, context),
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
                ),
                Metotlar().cikislariGetir(provider.tumCikislar, oranOzel, oran, 6, provider.haritaOnay, sayac, dilSecimi),
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
                            //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


                            bool enAzbirIsiticiIsaretliMi = false;

                            for (int i = 1; i <= 18; i++) {
                              if (provider.isiticiHarita[i] == 1) {
                                enAzbirIsiticiIsaretliMi=true;
                              }
                            }
                            

                            String veri = "";

                            for (int i = 1; i <= 18; i++) {
                              veri = veri + provider.isiticiHarita[i].toString() + "#";
                            }


                            if (!enAzbirIsiticiIsaretliMi) {
                              //Haritada seçilen ped sayısı eksik
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast48"),
                                  context,
                                  duration: 3);
                            } else {

                              for (int i = 1; i <= 18; i++) {
                              if (provider.isiticiHarita[i] != 1) {
                                provider.isiticiVisibility[i]=false;
                              }
                            }

                              Metotlar().veriGonder("32*32*$veri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                if(value=="ok"){
                                  dbProkis.dbSatirEkleGuncelle(27, "ok", veri, "0", "0");
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
                            _resetAlert(dilSecimi, context, provider, dbProkis);
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
                            bool noKontrol1 = false;
                            bool noKontrol2 = false;
                            bool cikisKullanimda = false;
                            String noVeri = "";
                            String cikisVeri = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 18; i++) {
                              if (provider.isiticiHarita[i] == 1) {
                                if (provider.isiticiNo[i] == 0) {
                                  noKontrol1 = true;
                                  print("GiRİYOR");
                                }
                              }
                              noVeri = noVeri + provider.isiticiNo[i].toString() + "#";
                            }
                            for (int i = 1; i <= 3; i++) {
                              if (provider.cikisNo[i] == 0 && provider.isiticiAdet >= i) {
                                noKontrol2 = true;
                              }

                              cikisVeri =
                                  cikisVeri + provider.cikisNo[i].toString() + "#";
                            }

                            for (int i = 1; i <= 3; i++) {
                              if (provider.cikisNoGecici[i] != provider.cikisNo[i]) {
                                if (provider.tumCikislar[provider.cikisNo[i]] == 0) {
                                  
                                  provider.tumCikislar[provider.cikisNoGecici[i]]=0;
                                } else {
                                  cikisKullanimda = true;
                                }
                              }
                            }

                            if (noKontrol1) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast90"),
                                  context,
                                  duration: 3);
                            }else if (noKontrol2) {
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
                            } else if (cikisKullanimda) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast38"),
                                  context,
                                  duration: 3);
                            } else {


                              for (int i = 1; i <= 3; i++) {
                                if (provider.cikisNo[i] != 0) {
                                  
                                  provider.tumCikislar[provider.cikisNo[i]]=1;
                                }
                              }
                              for(int i=1;i<=110;i++){
                                  tumCikislarVeri = tumCikislarVeri + provider.tumCikislar[i].toString() + "#";
                              }
                              
                              String komut="33*33*$noVeri*$cikisVeri*0*0";
                              Metotlar().veriGonder(komut, context, 2233, "toast8", dilSecimi).then((value){
                                if(value=="ok"){
                                  Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                    if(value=="ok"){
                                      dbProkis.dbSatirEkleGuncelle(28, "ok", noVeri, cikisVeri, "0");
                                      dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
                                    }
                                  });
                                }
                              });


                              for (int i = 0; i < 4; i++) {
                                provider.cikisNoGecici[i]=provider.cikisNo[i];
                              }

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
                          
                          if(provider.airinletAdet!='0' || provider.sirkfanVarMi){

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

                          if (!provider.haritaOnay) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast62"),
                                context,
                                duration: 3);
                          } else if (!provider.veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                            if(provider.siloAdet!='0'){

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
            }
          )
    );
  }


  
  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/kurulum_isitici_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Widget _isiticiHaritaUnsur(
      int indexNo, double oran, String baslik, IsiticiHaritasiProvider provider, BuildContext context) {
    return Expanded(flex: 3,
      child: Visibility(
        visible: provider.isiticiVisibility[indexNo] ? true : false,
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

                      int sayi = provider.isiticiNo[indexNo];
                      int pOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                      int pBirler = sayi % 10;

                      MyshowModalBottomSheet2x0(dilSecimi, context, oran,pOnlar, pBirler,"tv49","tv35")
                          .then((value) {
                          
                                bool gelenVeri=value==null ? false : value[0];

                                if (gelenVeri) {
                                    sayi =value[1] * 10 + value[2];
                                    provider.isiticiNo[indexNo]=sayi;
                                    provider.dinlemeyiTetikle();
                                }

                      });



                    } else {

                      List<int> xx = provider.isiticiHarita;
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
                      Row(
                        children: <Widget>[
                          Expanded(flex: 3,
                                                      child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      imageGetir(provider.isiticiHarita[indexNo])),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          //Spacer()
                        ],
                      ),
                      Visibility(
                        visible: provider.haritaOnay && provider.isiticiHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            //isitici No
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 3,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          Dil().sec(
                                                  dilSecimi, "tv63") +
                                              provider.isiticiNo[indexNo].toString(),
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
                            ),
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

  
  Future _resetAlert(String x, BuildContext context, IsiticiHaritasiProvider provider, DBProkis dbProkis) async {
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
        provider.setveriGonderildi = false;
        String tumCikislarVeri = "";

        for (int i = 0; i < 4; i++) {
          provider.cikisNo[i]=provider.cikisNoGecici[i];
        }


        for (int i = 1; i < 4; i++) {
          if (provider.cikisNo[i] != 0) {
            provider.tumCikislar[provider.cikisNo[i]] = 0;
          }
        }

        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + provider.tumCikislar[i].toString() + "#";
        }

        for (int i = 0; i < 19; i++) {
          provider.isiticiHarita[i]=0;
          provider.isiticiNo[i]=0;
          provider.isiticiVisibility[i]=true;
        }

        for (int i = 0; i < 4; i++) {
          provider.cikisNo[i]=0;
        }

        provider.setharitaOnay = false;

        Metotlar()
            .veriGonder("34*0*0*0*0*0", context, 2233, "toast8", dilSecimi)
            .then((value) {
          Metotlar()
              .veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233,
                  "toast8", dilSecimi)
              .then((value) {
            dbProkis.dbSatirEkleGuncelle(27, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(28, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
          });
        });
      }
    });
  }

  Widget _isiticiGrupCikis(int index, double oran, IsiticiHaritasiProvider provider, BuildContext context){
    return Expanded(
      flex: 2,
      child: Visibility(
        visible: provider.isiticiAdet >= index,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              Dil().sec(dilSecimi,
                  index == 1 ? "tv77" : (index == 2 ? "tv78" : "tv79")),
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kelly Slab',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textScaleFactor: oran,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Expanded(
                    flex: 4,
                    child: RawMaterialButton(
                      onPressed: () {


                 String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisNo[index]);
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

                              
                              provider.cikisNo[index]=cikisNo;
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
                                    Metotlar().outConvSAYItoQ(provider.cikisNo[index]),
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
      ),
    );
  }

}

class IsiticiHaritasiProvider with ChangeNotifier {
  int sayac=0;

  List<int> isiticiHarita = new List.filled(19,0);
  List<bool> isiticiVisibility = new List.filled(19,true);
  List<int> isiticiNo = new List.filled(19,0);
  List<int> cikisNo = new List.filled(4,0);
  List<int> cikisNoGecici = new List.filled(4,0);
  bool haritaOnay = false;
  int isiticiAdet = 0;
  String bacafanAdet = '0';
  String airinletAdet = '0';
  String siloAdet = '0';
  bool sirkfanVarMi = false;

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;

  bool baglanti = false;
  bool timerCancel = false;

  List<int> tumCikislar = new List.filled(111,0);

  
  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(){
    cikisNoTekerrur = false;
      for (int i = 1; i <= 3; i++) {
        for (int k = 1; k <= 3; k++) {
          if (i != k &&
              cikisNo[i] == cikisNo[k] &&
              cikisNo[i] != 0 &&
              cikisNo[k] != 0) {
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
  set setisiticiAdet(int value) {
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
  set setbaglanti(bool value) {
    baglanti = value;
    notifyListeners();
  }
  set settimerCancel(bool value) {
    timerCancel = value;
    notifyListeners();
  }


  BuildContext context;
  DBProkis dbProkis;

  IsiticiHaritasiProvider(this.context, this.dbProkis) {


    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=int.parse(dbProkis.dbVeriGetir(5, 3, "0"));
    siloAdet=dbProkis.dbVeriGetir(5, 4, "0");


    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(27, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(28, 1, "");
    var tcikislar;
    var fHaritalar;
    var isiticiNolar;
    var isiticiCikis;
    

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(27, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      isiticiNolar = dbProkis.dbVeriGetir(28, 2, "").split("#");
      isiticiCikis = dbProkis.dbVeriGetir(28, 3, "").split("#");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i-1]);
      }
    }

    for (var i = 1; i <= 18; i++) {

      if (haritaKAYIT == "ok") {
        isiticiHarita[i] = int.parse(fHaritalar[i - 1]);
        if (fHaritalar[i - 1] != "0") {
          haritaOnay = true;
          isiticiVisibility[i] = true;
        }else{
          isiticiVisibility[i] = false;
        }
      }

      if(cikisKAYIT=="ok"){
        isiticiNo[i] = int.parse(isiticiNolar[i - 1]);
      }



    }

    if (cikisKAYIT == "ok") {
      for (var i = 1; i <= 3; i++) {
        cikisNo[i] = int.parse(isiticiCikis[i - 1]);
      }
    }
    

    
  }
  
}
