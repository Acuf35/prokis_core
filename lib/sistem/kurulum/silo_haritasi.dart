import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet1x0.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/bacafan_haritasi.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'isitici_haritasi.dart';

class SiloHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  SiloHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  int sayac=0;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;
    
    return ChangeNotifierProvider<SiloHaritasiProvider>(
          create: (context) => SiloHaritasiProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){
              final provider = Provider.of<SiloHaritasiProvider>(context);



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
                          Dil().sec(dilSecimi, "tv84"),
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
        //silo Harita Oluşturma Bölümü
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
                    flex: 8,
                    child: Column(
                      children: <Widget>[
                        Expanded(
          flex: 7,
          child: Row(
            children: <Widget>[
              Spacer(
                flex: 6,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(7, oran, "tv83", provider, context),
                    _siloHaritaUnsur(6, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    _siloHaritaUnsur(8, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    _siloHaritaUnsur(9, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(11, oran, "tv83", provider, context),
                    _siloHaritaUnsur(10, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    _siloHaritaUnsur(12, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    _siloHaritaUnsur(13, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(15, oran, "tv83", provider, context),
                    _siloHaritaUnsur(14, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Spacer(
                flex: 6,
              ),
            ],
          ),
                        ),
                        Expanded(
          flex: 13,
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
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _siloHaritaUnsur(4, oran, "tv83", provider, context),
                          _siloHaritaUnsur(3, oran, "tv83", provider, context),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          _siloHaritaUnsur(3, oran, "tv83", provider, context),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _siloHaritaUnsur(2, oran, "tv83", provider, context),
                          _siloHaritaUnsur(1, oran, "tv83", provider, context),
                        ],
                      ),
                    ),
                  ],
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
                                "assets/images/bina_catili_ust_gorunum.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Spacer(
                            flex: 7,
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(
                                                dilSecimi,
                                                "tv57"),
                                        textAlign:
                                            TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
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
                            ),
                          ),
                          Spacer(
                            flex: 7,
                          )
                        ],
                      )
                    ],
                  )),
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _siloHaritaUnsur(16, oran, "tv83", provider, context),
                          _siloHaritaUnsur(17, oran, "tv83", provider, context),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _siloHaritaUnsur(18, oran, "tv83", provider, context),
                          Spacer()
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _siloHaritaUnsur(19, oran, "tv83", provider, context),
                          _siloHaritaUnsur(20, oran, "tv83", provider, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                        Expanded(
          flex: 7,
          child: Row(
            children: <Widget>[
              Spacer(
                flex: 6,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(29, oran, "tv83", provider, context),
                    _siloHaritaUnsur(30, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(28, oran, "tv83", provider, context),
                    Spacer()
                  ],
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(27, oran, "tv83", provider, context),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(25, oran, "tv83", provider, context),
                    _siloHaritaUnsur(26, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(24, oran, "tv83", provider, context),
                    Spacer()
                  ],
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(23, oran, "tv83", provider, context),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    _siloHaritaUnsur(21, oran, "tv83", provider, context),
                    _siloHaritaUnsur(22, oran, "tv83", provider, context),
                  ],
                ),
              ),
              Spacer(
                flex: 6,
              ),
            ],
          ),
                        ),
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

                            for (int i = 1; i <=30; i++) {
                              if (provider.siloHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < provider.siloAdet) {
                              //Haritada seçilen silo sayısı eksik
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast54"),
                                  context,
                                  duration: 3);
                            } else if (sayac > provider.siloAdet) {
                              //Haritada seçilen silo sayısı yüksek
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast55"),
                                  context,
                                  duration: 3);
                            } else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              provider.setharitaOnay = true;

                              for (int i = 1; i <=30; i++) {
                                if (provider.siloHarita[i] != 0) {
                                  
                                  provider.siloVisibility[i]=true;
                                } else {
                                  
                                  provider.siloVisibility[i]=false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <=30; i++) {
                                veri = veri + provider.siloHarita[i].toString() + "#";
                              }

                              Metotlar().veriGonder("35*34*$veri*0*0*0", 2233).then((value){
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                }else{
                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                  dbProkis.dbSatirEkleGuncelle(29, "ok", veri, "0", "0");
                                }
                              });
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
                            _resetAlert(dilSecimi,context, provider, dbProkis);
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
                            bool noKontrol = false;
                            bool sensSayYukNo = false;
                            String noVeri = "";
                            for (int i = 1; i <=30; i++) {
                              if (provider.siloHarita[i] == 1) {
                                if (provider.siloNo[i] == 0) {
                                  noKontrol = true;
                                }
                                if (provider.siloNo[i] > provider.siloAdet) {
                                  sensSayYukNo = true;
                                }
                              }
                              noVeri = noVeri + provider.siloNo[i].toString() + "#";
                            }

                            if (noKontrol) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast56"),
                                  context,
                                  duration: 3);
                            } else if (sensSayYukNo) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast57"),
                                  context,
                                  duration: 3);
                            } else if (provider.siloNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast58"),
                                  context,
                                  duration: 3);
                            } else {
                              provider.setveriGonderildi = true;

                              Metotlar().veriGonder("36*35*$noVeri*0*0*0", 2233).then((value){
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                }else{
                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                  dbProkis.dbSatirEkleGuncelle(30, "ok", noVeri, "0", "0");
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

                          if(provider.isiticiAdet!='0'){

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
                          }else if (!provider.veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DigerCikislar(true)),
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
                            Dil().sec(dilSecimi, "tv84"), 
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
                                        text: Dil().sec(dilSecimi, "info43"),
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
  
  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/silo_harita.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Widget _siloHaritaUnsur(
      int indexNo, double oran, String baslik, SiloHaritasiProvider provider, BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: provider.siloVisibility[indexNo] ? true : false,
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

                      int sayi = provider.siloNo[indexNo];
                      int pBirler = sayi % 10;

                      MyshowModalBottomSheet1x0(dilSecimi, context, oran, pBirler,"tv49","tv35",4)
                          .then((value) {

                                bool gelenVeri=value==null ? false : value[0];

                                if (gelenVeri) {
                                    
                                    provider.siloNo[indexNo]=value[1];
                                    provider.dinlemeyiTetikle();
                                }

                      });





                    } else {

                      var xx=provider.siloHarita;
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
                  child: Stack(fit: StackFit.expand,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Visibility(visible: !provider.haritaOnay && provider.siloHarita[indexNo]==0 ? false: true,
                            child: Spacer()),
                          Expanded(flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.pink,
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage(imageGetir(provider.siloHarita[indexNo])),
                                  fit: provider.siloHarita[indexNo]==1 ? BoxFit.fill : BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Visibility(visible: !provider.haritaOnay && provider.siloHarita[indexNo]==0 ? false: true,
                            child: Spacer())
                        ],
                      ),
                      Visibility(
                        visible: provider.haritaOnay && provider.siloHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 2,
                            ),
                            //silo No
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: <Widget>[
                                  Spacer(flex: 3,),
                                  Expanded(
                                    flex: 12,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                              provider.siloNo[indexNo].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Kelly Slab'),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(flex: 5,)
                                ],
                              ),
                            ),
                            Spacer(flex: 2,),
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

  Future _resetAlert(String x, BuildContext context, SiloHaritasiProvider provider, DBProkis dbProkis) async {
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

        for (int i = 0; i < 31; i++) {
          provider.siloHarita[i]=0;
          provider.siloNo[i]=0;
          provider.siloVisibility[i]=true;
        }

        provider.setharitaOnay = false;

        Metotlar().veriGonder("37*0*0*0*0*0", 2233).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            dbProkis.dbSatirEkleGuncelle(29, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(30, "0", "0", "0", "0");
          }
        });

      }
    });
  }


}

class SiloHaritasiProvider with ChangeNotifier {
  int sayac=0;

  List<int> siloHarita = new List.filled(31,0);
  List<bool> siloVisibility = new List.filled(31,true);
  List<int> siloNo = new List.filled(31,0);
  bool haritaOnay = false;
  int siloAdet = 0;
  String bacafanAdet = '0';
  String airinletAdet = '0';
  String isiticiAdet = '0';
  bool sirkfanVarMi = false;

  bool veriGonderildi = false;
  bool siloNoTekerrur = false;

  List<int> tumCikislar = new List.filled(111,0);

  
  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(){
    siloNoTekerrur = false;

    for (int i = 1; i <=30; i++) {
      for (int k = 1; k <=30; k++) {
        if (i != k &&
            siloNo[i] == siloNo[k] &&
            siloNo[i] != 0 &&
            siloNo[k] != 0) {
          siloNoTekerrur = true;
          break;
        }
        if (siloNoTekerrur) {
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
  set setisiticiAdet(String value) {
    isiticiAdet = value;
    notifyListeners();
  }
  set setsiloAdet(int value) {
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
    siloNoTekerrur = value;
    notifyListeners();
  }

  
  BuildContext context;
  DBProkis dbProkis;

  SiloHaritasiProvider(this.context, this.dbProkis) {

    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet=int.parse(dbProkis.dbVeriGetir(5, 4, "0"));

    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(29, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(30, 1, "");
    var tcikislar;
    var fHaritalar;
    var siloNolar;

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(29, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      siloNolar = dbProkis.dbVeriGetir(30, 2, "").split("#");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i-1]);
      }
    }

    for (var i = 1; i <= 30; i++) {

      if (haritaKAYIT == "ok") {
        siloHarita[i] = int.parse(fHaritalar[i - 1]);
        if (fHaritalar[i - 1] != "0") {
          haritaOnay = true;
          siloVisibility[i] = true;
        }else{
          siloVisibility[i] = false;
        }
      }

      if(cikisKAYIT=="ok"){
        siloNo[i] = int.parse(siloNolar[i - 1]);
      }
    }
    
  }
  
}
