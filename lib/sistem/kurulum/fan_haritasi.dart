import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0veQ.dart';
import 'package:prokis/mywidgets/showModalBottomSheetQ%20.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/sistem/kurulum/uz_debi_nem.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'klepe_haritasi.dart';

class FanHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  FanHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  bool timerCancel=false;
  int sayac=0;
  int sayac2=0;
  int sayac3=0;
  int otoCikisAtamaBaslangicNo=1;

  

  @override
  Widget build(BuildContext context) {

    if(sayac2==0){
          new Timer(Duration(seconds: 0), (){
            showProgressDialog(context, Dil().sec(dilSecimi, "tv634"));
          });
    }


    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    var oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;



    return ChangeNotifierProvider<FanHaritasiProvider>(
      create: (context) => FanHaritasiProvider(context, dbProkis),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<FanHaritasiProvider>(context);

          

          if(sayac2==0){
            new Timer.periodic(Duration(seconds:0, milliseconds: provider.haritaOnay==true ? 100 : 1 ), (timer){
                
                int unsurAdet=provider.haritaOnay==true ? provider.unsurAdet : 120;

                if(provider.sayac<unsurAdet){
                  provider.setsayac=provider.sayac+1;
                }
                
                sayac=sayac+1;

                if(sayac==unsurAdet+1){
                  if(sayac3==0){
                  new Timer(Duration(seconds: 0, milliseconds: 600), (){
                    provider.setsayac1=1;
                    sayac3++;
                  });
                }

                timerCancel=true;
                Navigator.pop(context);
                provider.dinlemeyiTetikle();
              }

              if(timerCancel){
              timer.cancel();
            }
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
              body: Row(
                children: <Widget>[
                  //Fan Harita Bölümü
                  Expanded(
                    flex: 28,
                    child: Column(
                      children: <Widget>[
                        //Çatı resmi
                        Expanded(
                          child: Stack(fit: StackFit.expand,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image:
                                        AssetImage('assets/images/cati_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              //Otomatik çıkış atama
                                            Row(
                                              children: <Widget>[
                                                Spacer(flex: 7,),
                                                
                                                Expanded(
                                                  child: Visibility(
                                                    visible: provider.haritaOnay,
                                                    maintainState: true,
                                                    maintainSize: true,
                                                    maintainAnimation: true,
                                                    child: RawMaterialButton(
                                                      padding:
                                                          EdgeInsets.only(bottom: 2*oran, top: 1*oran),
                                                      onPressed: () {



                                                        
                    String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisNo[1]);
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
                        qByteOnlar, qByteBirler, qBit,"tv648","tv648")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);
                            int deger=0;



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              for (var i = cikisNo; i < cikisNo+provider.unsurAdet; i++) {

                                if(provider.fanHaritaGrid[i-1]==2){
                                  deger=deger+cikisNo;
                                  provider.cikisNo[i]=deger;
                                }

                              }
                              provider.tekerrurTespit();

                            }



                          }


                });
                                                        
                                                      },
                                                      highlightColor: Colors.green,
                                                      splashColor: Colors.red,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      constraints: BoxConstraints(),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv455"),
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Kelly Slab',
                                                                      color: Colors.blue,
                                                                      fontSize: 60,
                                                                      fontWeight: FontWeight.bold),
                                                                  maxLines: 1,
                                                                  minFontSize: 8,
                                                                ),
                                                              ),
                                                            )),
                                                          Expanded(
                                                            child: Icon(
                                                              Icons.queue,
                                                              size: 30 * oran,
                                                              color: Colors.blue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                            ],
                          ),
                        ),
                        //Fan Harita Bölümü
                        Expanded(
                          flex: 11,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 5.0 * oran,
                                right: 5.0 * oran,
                                bottom: 5.0 * oran),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 3 * oran)),
                              child: Row(
                                children: <Widget>[
                                  //Spacer(flex: 1,),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Spacer(
                                          flex: 2,
                                        ),
                                        Expanded(
                                          flex: provider.haritaFlex,

                                          child: provider.haritaOnay
                                              ? seciliHaritaGrid(
                                                  oran, context, provider)
                                              : defaultHaritaGrid(
                                                  oran, context, provider),
                                                  
                                        ),
                                        Spacer(
                                          flex: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                  //Spacer(flex: 1,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Çıkışlar ve butonlar bölümü
                  Expanded(
                    flex: 12,
                    child: Column(
                      children: <Widget>[
                        //Başlık bölümü
                        Expanded(
                            child: Container(
                              color: Colors.grey.shade600,
                              child: Row(
                                children: <Widget>[
                                  Expanded(flex: 4,
                                    child: SizedBox(
                                      child: Container(
                                        
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv31"),
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
  
                        //Çıkışlar
                        Metotlar().cikislariGetir(provider.tumCikislar, oranOzel, oran, 9,provider.haritaOnay,provider.sayac1,dilSecimi),

                        //ileri geri ok bölümü
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.grey.shade600,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //Onayla-sıfırla-gönder
                                Expanded(
                                  flex: 8,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      //Haritayı Onayla Butonu
                                      Padding(
                                        padding: EdgeInsets.all(8.0 * oran),
                                        child: Visibility(
                                          visible: !provider.haritaOnay,
                                          maintainState: true,
                                          maintainSize: true,
                                          maintainAnimation: true,
                                          child: FlatButton(
                                            onPressed: () async {

                                              int haritadakiFanAdet = 0;
                                              for (int i = 1; i <= 120; i++) {
                                                if (provider.fanHarita[i] == 2) {
                                                  haritadakiFanAdet++;
                                                }
                                              }

                                              if (haritadakiFanAdet <
                                                  provider.fanAdet) {
                                                //Haritada seçilen fan sayısı eksik
                                                Toast.show(
                                                    Dil().sec(
                                                        dilSecimi, "toast16"),
                                                    context,
                                                    duration: 3);
                                              } else if (haritadakiFanAdet >
                                                  provider.fanAdet) {
                                                //Haritada seçilen fan sayısı yüksek
                                                Toast.show(
                                                    Dil().sec(
                                                        dilSecimi, "toast17"),
                                                    context,
                                                    duration: 3);
                                              } else if (provider.dikdortgenHataVarMi()) {
                                                //Dikdörtgen seçim hatası
                                                Toast.show(
                                                    Dil().sec(
                                                        dilSecimi, "toast18"),
                                                    context,
                                                    duration: 3);
                                              } else {
                                                //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                
                                                

                                                int sayac = 0;
                                                int sayac2 = 0;
                                                bool xx = false;
                                                List<int> aa = provider.fanHarita;
                                                List<int> bb = provider.fanHaritaGrid;

                                                for (int i = 1; i <= 120; i++) {
                                                  if (aa[i] != 0) {

                                                    bb[sayac]=aa[i];
                                                    sayac++;
                                                    xx=true;
                                                    provider.setunsurAdet =provider.unsurAdet +1;
                                                    provider.setsayac=provider.unsurAdet;
                                                  }
                                                  if(xx){
                                                    if(aa[i] == 0){
                                                      sayac2++;
                                                    }
                                                    if(sayac2==0){
                                                      provider.setsutunSayisi =provider.sutunSayisi + 1;
                                                    }
                                                  }


                                                }

                                                if (provider.sutunSayisi == 1) {
                                                  provider.setharitaFlex = 1;
                                                } else if (provider.sutunSayisi == 2) {
                                                  provider.setharitaFlex = 2;
                                                }

                                                String veri = "";

                                                for (int i = 1;i <= 120; i++) {
                                                  veri = veri + aa[i] .toString() + "#";
                                                }

                                                Metotlar().veriGonder("12*19*$veri*0*0*0",2233).then((value) {
                                                  if(value.split("*")[0]=="error"){
                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                                  }else{
                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                    dbProkis.dbSatirEkleGuncelle(14,"ok",veri,"0","0");
                                                  }
                                                });
                                                provider.setharitaOnay = true;
                                                print(provider.cikisNo);
                                              }

                                              //-------------------------ONAY BÖLÜMÜ--------------------------------------------------
                                            },
                                            highlightColor: Colors.green,
                                            splashColor: Colors.red,
                                            color: Colors.white,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.map,
                                                  size: 30 * oran,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          //Haritayı Sıfırla Butonu
                                          Visibility(
                                            visible: provider.haritaOnay,
                                            maintainState: true,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            child: RawMaterialButton(
                                              padding:
                                                  EdgeInsets.all(3 * oran),
                                              onPressed: () {
                                                _resetAlert(
                                                    dilSecimi,
                                                    context,
                                                    provider,
                                                    dbProkis);
                                              },
                                              highlightColor: Colors.green,
                                              splashColor: Colors.red,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              constraints: BoxConstraints(),
                                              fillColor: Colors.white,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.refresh,
                                                    size: 30 * oran,
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
                                            child: RawMaterialButton(
                                              padding:
                                                  EdgeInsets.all(3 * oran),
                                              onPressed: () {
                                                bool sifirNoVarMi = false;
                                                bool cikisKullanimda = false;
                                                bool fanNoYuksek = false;
                                                String cikisVeri = "";
                                                String noVeri = "";
                                                String gridVeri = "";
                                                String gridHaritaVeri = "";
                                                String tumCikislarVeri = "";


                                                for (int i = 1;i <= 120;i++) {
                                                  if (provider.fanHaritaGrid[i-1] == 2) {
                                                    if (provider.fanNo[i] == 0) {
                                                      sifirNoVarMi = true;
                                                    }
                                                    if (provider.fanNo[i] > provider.fanAdet) {
                                                      fanNoYuksek = true;
                                                    }
                                                  }


                                                  if (provider.cikisNoGecici[i] !=provider.cikisNo[i]) {
                                                    if (provider.tumCikislar[provider.cikisNo[i]] ==0) {
                                                      
                                                      provider.tumCikislar[provider.cikisNoGecici[i]] = 0;

                                                    } else {
                                                      cikisKullanimda = true;
                                                    }
                                                  }

                                                  cikisVeri = cikisVeri + provider.cikisNo[i].toString() +"#";
                                                  noVeri = noVeri +provider.fanNo[i].toString() +"#";
                                                  gridHaritaVeri =gridHaritaVeri +provider.fanHaritaGrid[i-1].toString() +"#";
                                                }

                                                gridVeri = gridHaritaVeri +"*" +provider.sutunSayisi.toString() +"*" +provider.unsurAdet.toString();

                                                

                                                if (sifirNoVarMi) {
                                                  Toast.show(
                                                      Dil().sec(dilSecimi,
                                                          "toast24"),
                                                      context,
                                                      duration: 3);
                                                } else if (fanNoYuksek) {
                                                  Toast.show(
                                                      Dil().sec(dilSecimi,
                                                          "toast47"),
                                                      context,
                                                      duration: 3);
                                                } else if (provider
                                                    .fanNoTekerrur) {
                                                  Toast.show(
                                                      Dil().sec(dilSecimi,
                                                          "toast25"),
                                                      context,
                                                      duration: 3);
                                                } else if (provider
                                                    .cikisNoTekerrur) {
                                                  Toast.show(
                                                      Dil().sec(dilSecimi,
                                                          "toast26"),
                                                      context,
                                                      duration: 3);
                                                } else if (cikisKullanimda) {
                                                  Toast.show(
                                                      Dil().sec(dilSecimi,
                                                          "toast38"),
                                                      context,
                                                      duration: 3);
                                                } else {

                                                  List<int> aa =provider.tumCikislar;

                                                  for (int i = 1;i <= 120;i++) {
                                                    if (provider.cikisNo[i] !=0) {
                                                      aa[provider.cikisNo[i]] = 1;
                                                    }
                                                  }

                                                  for (int i = 1;
                                                      i <= 110;
                                                      i++) {
                                                    tumCikislarVeri =
                                                        tumCikislarVeri +
                                                            provider
                                                                .tumCikislar[
                                                                    i]
                                                                .toString() +
                                                            "#";
                                                  }

                                                  Metotlar().veriGonder("13*20*$noVeri*$cikisVeri*0*0",2233,).then((value) {
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                                    }else{
                                                      Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0",2233).then((value) {
                                                        if(value.split("*")[0]=="error"){
                                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                          dbProkis.dbSatirEkleGuncelle(15,"ok",noVeri,cikisVeri,gridVeri);
                                                          dbProkis.dbSatirEkleGuncelle(22,"ok",tumCikislarVeri,"0","0");
                                                        }
                                                      }).then((value){
                                                        dbProkis.dbVeriCekme();
                                                      });
                                                    }
                                                  });
                                                  

                                                  for (int i = 0; i < 121; i++) {
                                                    provider.cikisNoGecici[i]=provider.cikisNo[i];
                                                  }
                                                  provider.setveriGonderildi =true;


                                                }
                                              },
                                              highlightColor: Colors.green,
                                              splashColor: Colors.red,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              constraints: BoxConstraints(),
                                              fillColor:
                                                  provider.veriGonderildi
                                                      ? Colors.green[500]
                                                      : Colors.blue,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.send,
                                                    size: 30 * oran,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //geri ok
                                Expanded(
                                    flex: 4,
                                    child: Visibility(
                                      visible: ilkKurulumMu,
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back_ios),
                                        iconSize: 50 * oran,
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UzDebiNem(true)),
                                          );

                                        },
                                      ),
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                //ileri ok
                                Expanded(
                                    flex: 4,
                                    child: Visibility(
                                      visible: ilkKurulumMu,
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        iconSize: 50 * oran,
                                        onPressed: () {

                                          if (!provider.haritaOnay) {
                                            Toast.show(
                                                Dil().sec(dilSecimi, "toast62"),
                                                context,
                                                duration: 3);
                                          } else if (!provider
                                              .veriGonderildi) {
                                            Toast.show(
                                                Dil().sec(dilSecimi, "toast27"),
                                                context,
                                                duration: 3);
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      KlepeHaritasi(
                                                          true)),
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
                            Dil().sec(dilSecimi, "tv31"), 
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
                                        text: Dil().sec(dilSecimi, "info34"),
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
        },
      ),
    );
  }

  showProgressDialog(BuildContext context, String title) {
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
                            fontSize: 16, fontWeight: FontWeight.bold,
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

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/duvar_icon.png';
    } else if (deger == 2) {
      imagePath = 'assets/images/fan_on_gorunuz_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Widget _fanHaritaUnsur(int indexNo, double oran, BuildContext context,
      FanHaritasiProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: RawMaterialButton(
              onPressed: () {
                
                List<int> xx = provider.fanHarita;
                if (xx[indexNo + 1] == 0 || xx[indexNo + 1] == null) {
                    xx[indexNo + 1] = 1;
                    provider.dinlemeyiTetikle();
                } else if (xx[indexNo + 1] == 1) {
                  xx[indexNo + 1] = 2;
                  provider.dinlemeyiTetikle();
                } else if (xx[indexNo + 1] == 2) {
                  xx[indexNo + 1] = 0;
                  provider.dinlemeyiTetikle();
                }

                
              },
              child: Stack(
                children: <Widget>[
                  Opacity(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(
                              imageGetir(provider.fanHarita[indexNo + 1])),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    opacity: provider.fanHaritaGrid[indexNo + 1] == 2 &&
                            provider.haritaOnay
                        ? 0.6
                        : 1,
                  ),
                  Visibility(
                    visible: provider.haritaOnay &&
                            provider.fanHarita[indexNo + 1] != 0
                        ? true
                        : false,
                    child: Visibility(
                      visible: provider.haritaOnay &&
                              provider.fanHarita[indexNo + 1] == 2
                          ? true
                          : false,
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Spacer(),
                                //Fan No
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv32") +
                                                  provider.fanNo[indexNo + 1]
                                                      .toString(),
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
                                //Çıkış No
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv33") +
                                                  provider
                                                      .cikisNo[indexNo + 1]
                                                      .toString(),
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
                                Spacer()
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _fanHaritaUnsurSecili(int indexNo, double oran, BuildContext context,
      FanHaritasiProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: RawMaterialButton(
              onPressed: () {
                if (provider.haritaOnay) {
                  if (provider.fanHaritaGrid[indexNo] == 2) {
                    int sayi = provider.fanNo[indexNo + 1];
                    int fOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                    int fBirler = sayi % 10;
                    String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisNo[indexNo + 1]);
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
                    

                    MyshowModalBottomSheet2x0veQ(dilSecimi, context, oran,
                            qByteOnlar, qByteBirler, qBit, fOnlar, fBirler,"tv34","tv35")
                        .then((value) {

                              bool gelenVeri=value==null ? false : value[0];

                              if (gelenVeri) {

                                
                                outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                                int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);

                                sayi =value[4] * 10 + value[5];

                                if (cikisNo == 0) {
                                  Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                                } else {

                                  provider.fanNo[indexNo+1]=sayi;
                                  provider.cikisNo[indexNo+1]=cikisNo;
                                  provider.tekerrurTespit();

                                }



                              }


                    });
                  }
                }

              },
              child: Stack(
                children: <Widget>[
                  Opacity(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(
                              imageGetir(provider.fanHaritaGrid[indexNo])),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    opacity: provider.fanHaritaGrid[indexNo] == 2 &&
                            provider.haritaOnay
                        ? 0.6
                        : 1,
                  ),
                  Visibility(
                    visible: provider.haritaOnay &&
                            provider.fanHaritaGrid[indexNo] == 2
                        ? true
                        : false,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: <Widget>[
                              Spacer(),
                              //Fan No
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: AutoSizeText(
                                            Dil().sec(dilSecimi, "tv32") +
                                                provider.fanNo[indexNo + 1]
                                                    .toString(),
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
                              //Çıkış No
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          child: AutoSizeText(
                                            Dil().sec(dilSecimi, "tv33") +
                                                Metotlar().outConvSAYItoQ(provider.cikisNo[indexNo + 1]),
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
                              Spacer()
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
    );
  }

  Future _resetAlert(String x, BuildContext context,
      FanHaritasiProvider provider, DBProkis dbProkis) async {
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

        for (int i = 0; i < 121; i++) {
          provider.cikisNo[i]=provider.cikisNoGecici[i];
        }

        //tüm çıkışlardaki fanCıkısNo ya ait tüm çıkışları sıfırlar
        for (int i = 1; i < 121; i++) {
          if (provider.cikisNo[i] != 0) {
            provider.tumCikislar[provider.cikisNo[i]] = 0;
          }
        }

        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + provider.tumCikislar[i].toString() + "#";
        }

        for (var i = 0; i < 121; i++) {
          provider.fanHarita[i]=0;
          provider.fanNo[i]=0;
          provider.cikisNo[i]=0;
        }

        provider.setharitaOnay = false;
        provider.setunsurAdet = 0;
        provider.setsutunSayisi = 0;
        provider.setharitaFlex = 200;
        provider.setsayac=120;

        Metotlar().veriGonder("14*0*0*0*0*0", 2233).then((value) {
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
          }else{
            Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", 2233).then((value) {
              if(value.split("*")[0]=="error"){
                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
              }else{
                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                dbProkis.dbSatirEkleGuncelle(14, "0", "0", "0", "0");
                dbProkis.dbSatirEkleGuncelle(15, "0", "0", "0", "0");
                dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
              }
            });
          }
        });
        
      }
    });
  }

  Widget defaultHaritaGrid(
      double oran, BuildContext context, FanHaritasiProvider provider) {
    return GridView.count(
      padding: EdgeInsets.all(0),
      crossAxisCount: 12,
      //childAspectRatio: 1.4,
      children: List.generate(provider.sayac, (index) {
        return Center(child: _fanHaritaUnsur(index, oran, context, provider));
      }),
    );
  }

  Widget seciliHaritaGrid(
      double oran, BuildContext context, FanHaritasiProvider provider) {
        
    return GridView.count(
      padding: EdgeInsets.all(0),
      //maxCrossAxisExtent: oranHarita/sutunSayisi,
      //childAspectRatio:2,
      crossAxisCount: provider.sutunSayisi,
      children: List.generate(provider.sayac, (index) {
        return Center(
            child: _fanHaritaUnsurSecili(index, oran, context, provider));
      }),
    );
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }


}

class FanHaritasiProvider with ChangeNotifier {
  int sayac=0;
  int sayac1=0;

  List<int> fanHarita = new List.filled(121, 0);
  List<int> fanHaritaGrid = new List.filled(121, 0);
  List<int> fanNo = new List.filled(121, 0);
  List<int> cikisNo = new List.filled(121, 0);
  List<int> cikisNoGecici = new List.filled(121, 0);
  bool haritaOnay = false;
  int fanAdet = 0;

  int sutunSayisi = 0;
  int unsurAdet = 0;
  int haritaFlex = 200;

  double oran1;
  bool veriGonderildi = false;
  bool fanNoTekerrur = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List.filled(111, 0);

  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(){
    fanNoTekerrur = false;
      cikisNoTekerrur = false;

      for (int i = 1; i <= 120; i++) {
        for (int k = 1; k <= 120; k++) {
          if (i != k &&
              fanNo[i] == fanNo[k] &&
              fanNo[i] != 0 &&
              fanNo[k] != 0) {
                print("Giriyor");
            fanNoTekerrur = true;
            break;
          }
          if (i != k &&
              cikisNo[i] == cikisNo[k] &&
              cikisNo[i] != 0 &&
              cikisNo[k] != 0) {
                print("İ:$i   k:$k");
            cikisNoTekerrur = true;
            break;
          }
          
        } 
        if (cikisNoTekerrur || fanNoTekerrur) {
          break;
        }
      }
      notifyListeners();
  }

  cikislariDatabasedenGuncelle(DBProkis dbProkis){
    var cikisNolar;

    String cikisKAYIT = dbProkis.dbVeriGetir(15, 1, "");
    if(cikisKAYIT=="ok"){
      cikisNolar = dbProkis.dbVeriGetir(15, 3, "").split("#");
      for (var i = 1; i <= 3; i++) {
        cikisNo[i] = int.parse(cikisNolar[i - 1]);
        cikisNoGecici[i] = cikisNo[i];
      }
    }else{
      for (var i = 1; i <= 3; i++) {
        cikisNo[i] = 0;
        cikisNoGecici[i]=cikisNo[i];
      }
    }
    

  }

  bool dikdortgenHataVarMi(){

    List<int> satir = new List(11);
    bool dikdortgenHata = false;

    for (int i = 1; i <= 10; i++) {
      satir[i] = 0;
    }

    for (int i = 1; i <= 12; i++) {
      if (fanHarita[i] !=0) {
        satir[1]++;
      }
      if (fanHarita[i + 12] != 0) {
        satir[2]++;
      }
      if (fanHarita[
              i + 24] !=
          0) {
        satir[3]++;
      }
      if (fanHarita[
              i + 36] !=
          0) {
        satir[4]++;
      }
      if (fanHarita[
              i + 48] !=
          0) {
        satir[5]++;
      }
      if (fanHarita[
              i + 60] !=
          0) {
        satir[6]++;
      }
      if (fanHarita[
              i + 72] !=
          0) {
        satir[7]++;
      }
      if (fanHarita[
              i + 84] !=
          0) {
        satir[8]++;
      }
      if (fanHarita[
              i + 96] !=
          0) {
        satir[9]++;
      }
      if (fanHarita[
              i + 108] !=
          0) {
        satir[10]++;
      }
    }

    for (int i = 1; i <= 10; i++) {
      for (int k = 1;
          k <= 10;
          k++) {
        if (satir[i] != satir[k] &&
            satir[i] != 0 &&
            satir[k] != 0) {
          dikdortgenHata = true;
        }
      }
    }

    return dikdortgenHata;
  }

  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }

  set setsayac1(int value) {
    sayac1 = value;
    notifyListeners();
  }

  set setharitaOnay(bool value) {
    haritaOnay = value;
    notifyListeners();
  }

  set setfanAdet(int value) {
    fanAdet = value;
    notifyListeners();
  }

  set setsutunSayisi(int value) {
    sutunSayisi = value;
    notifyListeners();
  }

  set setunsurAdet(int value) {
    unsurAdet = value;
    notifyListeners();
  }

  set setharitaFlex(int value) {
    haritaFlex = value;
    notifyListeners();
  }

  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }

  set setfanNoTekerrur(bool value) {
    fanNoTekerrur = value;
    notifyListeners();
  }

  set setcikisNoTekerrur(bool value) {
    cikisNoTekerrur = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  FanHaritasiProvider(this.context, this.dbProkis) {

    fanAdet = int.parse(dbProkis.dbVeriGetir(4, 1, "1"));
    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(14, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(15, 1, "");
    var tcikislar;
    var fHaritalar;
    var fanNolar;
    var cikisNolar;

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(14, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      fanNolar = dbProkis.dbVeriGetir(15, 2, "").split("#");
      cikisNolar = dbProkis.dbVeriGetir(15, 3, "").split("#");
    }

    int sayac = 0;
    int sayac2 = 0;
    bool veri = false;
    for (var i = 1; i <= 120; i++) {

      if (tumCikislarKAYIT == "ok" && i<=110) {
        tumCikislar[i] = int.parse(tcikislar[i - 1]);
      }

      if (haritaKAYIT == "ok") {
        fanHarita[i] = int.parse(fHaritalar[i - 1]);
        if (fHaritalar[i - 1] != "0") {
          haritaOnay = true;

          fanHaritaGrid[sayac] = int.parse(fHaritalar[i - 1]);
          sayac++;
          veri = true;
          unsurAdet++;
        }

        if (veri) {
          if (fHaritalar[i - 1] == "0") {
            sayac2++;
          }
          if (sayac2 == 0) {
            sutunSayisi++;
          }
        }
      }

      if (cikisKAYIT == "ok") {
        fanNo[i] = int.parse(fanNolar[i - 1]);
        cikisNo[i] = int.parse(cikisNolar[i - 1]);
        cikisNoGecici[i] = cikisNo[i];
      }
    }
  }
}
