import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0veQ.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'klepe_haritasi.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';


class PedHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  PedHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  int sayac=0;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;

    return ChangeNotifierProvider<PedHaritasiProvider>(
          create: (context) => PedHaritasiProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){
              final provider = Provider.of<PedHaritasiProvider>(context);

              if(sayac==0){
                new Timer(Duration(seconds: 0, milliseconds: 1000), (){
                  provider.setsayac=1;
                  sayac++;
                });
              }

              return Scaffold(
                  floatingActionButton: MyFloatingActionBackButton(
                  !ilkKurulumMu,
                  !provider.getveriGonderildi,
                  oran,
                  40,
                  Colors.grey[700],
                  Colors.white,
                  Icons.arrow_back,
                  1,
                  "tv564"),
    
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(flex: 1,
            child: Container(
          color: Colors.grey.shade600,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      Dil().sec(dilSecimi, "tv47"),
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
            ],
          ),
          alignment: Alignment.center,
        )),
        //ped Harita Oluşturma Bölümü
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
                //Tüm duvarlar Ped görünümü
                Expanded(
                  flex: 54,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      //Ön ve Sağ Duvar
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Ön Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv53"),
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
                                flex: 8,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2*oran, color: Colors.black),
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/onarka_duvar_gri_icon1.jpg"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(1, oran, provider,context),
                                              _pedHaritaUnsur(2, oran, provider,context),
                                              _pedHaritaUnsur(3, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    )
                                  ],
                                )),
                            Spacer(),
                            //Sağ Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv54"),
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
                                flex: 16,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2*oran, color: Colors.black),
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/sagsol_duvar_gri_icon1.jpg"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(4, oran, provider,context),
                                              _pedHaritaUnsur(5, oran, provider,context),
                                              _pedHaritaUnsur(6, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(7, oran, provider,context),
                                              _pedHaritaUnsur(8, oran, provider,context),
                                              _pedHaritaUnsur(9, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(10, oran, provider,context),
                                              _pedHaritaUnsur(11, oran, provider,context),
                                              _pedHaritaUnsur(12, oran, provider,context),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Arka ve Sol Duvar
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Arka Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv55"),
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
                                flex: 8,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2*oran, color: Colors.black),
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/onarka_duvar_gri_icon1.jpg"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(22, oran, provider,context),
                                              _pedHaritaUnsur(23, oran, provider,context),
                                              _pedHaritaUnsur(24, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    )
                                  ],
                                )),
                            Spacer(),
                            //Sol Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv56"),
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
                                flex: 16,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2*oran, color: Colors.black),
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/sagsol_duvar_gri_icon1.jpg"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(13, oran, provider,context),
                                              _pedHaritaUnsur(14, oran, provider,context),
                                              _pedHaritaUnsur(15, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(16, oran, provider,context),
                                              _pedHaritaUnsur(17, oran, provider,context),
                                              _pedHaritaUnsur(18, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              _pedHaritaUnsur(19, oran, provider,context),
                                              _pedHaritaUnsur(20, oran, provider,context),
                                              _pedHaritaUnsur(21, oran, provider,context),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
                Metotlar().cikislariGetir(provider.gettumCikislar, oranOzel, oran, 24,provider.getharitaOnay,provider.getsayac,dilSecimi),
                
              ],
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(flex: 2,
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
                        visible: !provider.getharitaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            int sayac = 0;

                            for (int i = 1; i <= 24; i++) {
                              if (provider.getpedHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < provider.getpedAdet) {
                              //Haritada seçilen ped sayısı eksik
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast49"),
                                  context,
                                  duration: 3);
                            } else if (sayac > provider.getpedAdet) {
                              //Haritada seçilen ped sayısı yüksek
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast50"),
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

                              for (int i = 1; i <= 24; i++) {
                                if (provider.getpedHarita[i] != 0) {
                                  provider.listIslem(provider.getpedVisibility, null, 3, i, true, 19);
                                } else {
                                  provider.listIslem(provider.getpedVisibility, null, 3, i, false, 19);
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 24; i++) {
                                veri = veri + provider.getpedHarita[i].toString() + "#";
                              }

                              Metotlar().veriGonder("18*23*$veri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                          if(value=="ok"){
                                            dbProkis.dbSatirEkleGuncelle(18, "ok", veri, "0", "0");
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
                        visible: provider.getharitaOnay,
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
                        visible: provider.getharitaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            bool noKontrol = false;
                            bool cikisKullanimda = false;
                            bool pedNOyuksek = false;
                            String cikisVeri = "";
                            String noVeri = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 24; i++) {
                              if (provider.getpedHarita[i] == 1) {
                                if (provider.getpedNo[i] == 0 || provider.getcikisNo[i] == 0) {
                                  noKontrol = true;
                                }
                                if (provider.getpedNo[i] > provider.getpedAdet) {
                                  pedNOyuksek = true;
                                }
                              }
                              cikisVeri = cikisVeri + provider.getcikisNo[i].toString() + "#";
                              noVeri = noVeri + provider.getpedNo[i].toString() + "#";
                            }
                            print(provider.getcikisNoGecici);

                            for (int i = 1; i <= 24; i++) {
                              if (provider.getcikisNoGecici[i] != provider.getcikisNo[i]) {
                                if (provider.gettumCikislar[provider.getcikisNo[i]] == 0) {
                                  provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNoGecici[i], 0, 25);
                                } else {
                                  cikisKullanimda = true;
                                }
                              }
                            }

                            if (noKontrol) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast36"),
                                  context,
                                  duration: 3);
                            } else if (pedNOyuksek) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast45"),
                                  context,
                                  duration: 3);
                            } else if (provider.getpedNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast32"),
                                  context,
                                  duration: 3);
                            } else if (provider.getcikisNoTekerrur) {
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
                              for (int i = 1; i <= 24; i++) {
                                if (provider.getcikisNo[i] != 0) {
                                  provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNo[i], 1, null);
                                }
                              }
                              for (int i = 1; i <= 110; i++) {
                                tumCikislarVeri = tumCikislarVeri +
                                    provider.gettumCikislar[i].toString() +
                                    "#";
                              }
                              provider.setveriGonderildi = true;
                              provider.setveriGonderildi = true;
                                        String komut="19*24*$noVeri*$cikisVeri*0*0";
                                        Metotlar().veriGonder(komut, context, 2233, "toast8", dilSecimi).then((value){
                                          if(value=="ok"){
                                            Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                              if(value=="ok"){
                                                dbProkis.dbSatirEkleGuncelle(19, "ok", noVeri, cikisVeri, "0");
                                                dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
                                              }
                                            });
                                          }
                                        });

                                        provider.listIslem(null, null, 6, null, null, 25);
                            }
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color:
                              provider.getveriGonderildi ? Colors.green[500] : Colors.blue,
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
                          
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KlepeHaritasi(true)),
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
                          if (!provider.getharitaOnay) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast62"),
                                context,
                                duration: 3);
                          } else if (!provider.getveriGonderildi) {
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
                                      IsiSensorHaritasi(true)),
                            );


                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IsiSensorHaritasi(dbVeriler)),
                            ).then((onValue) {
                              _dbVeriCekme();
                              for (int i = 1; i <= 110; i++) {
                                tumCikislar[i] = onValue[i];
                              }
                            });
                            */
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
          ),
    );
  }


  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/ped_harita_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Widget _pedHaritaUnsur(int indexNo, double oran, PedHaritasiProvider provider, BuildContext context) {
    return Expanded(
      child: Visibility(visible:provider.getpedVisibility[indexNo] ? true : false,
              child: RawMaterialButton(
            onPressed: () {
              if (provider.getharitaOnay) {

                int sayi = provider.getpedNo[indexNo];
                int pOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                int pBirler = sayi % 10;
                String outNoMetin = provider.getcikisNo[indexNo] == 0
                    ? "Q0.0"
                    : Metotlar()
                        .outConvSAYItoQ(provider.getcikisNo[indexNo]);
                int qByteOnlar = int.parse(outNoMetin.length > 4
                    ? outNoMetin.substring(1, 2)
                    : "0");
                int qByteBirler = int.parse(outNoMetin.length > 4
                    ? outNoMetin.substring(2, 3)
                    : outNoMetin.substring(1, 2));
                int qBit =
                    int.parse(outNoMetin.substring(outNoMetin.length - 1));

                MyshowModalBottomSheet2x0veQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit, pOnlar, pBirler,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              sayi =value[4] * 10 + value[5];
                              provider.listIslem(provider.getpedNo, null, 3, indexNo, sayi, null);

                             
                              provider.listIslem(provider.getcikisNo, null, 3, indexNo, cikisNo, null);

                            }



                          }


                });

                


              } else {

                List<int> xx = provider.getpedHarita;
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
            child: Container(
              alignment: Alignment.center,
              child: Visibility(
            visible:
                provider.getharitaOnay && provider.getpedHarita[indexNo] == 1 ? true : false,
            child: Column(
              children: <Widget>[
                Spacer(flex: 4,),
                Expanded(flex: 23,
                                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 14,
                      ),
                      //ped No
                      Expanded(
                        flex: 10,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    " "+Dil().sec(
                                            dilSecimi, "tv72") +"\n"+
                                        provider.getpedNo[indexNo].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Çıkış No
                      Expanded(
                        flex: 10,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil().sec(
                                            dilSecimi, "tv33") +"\n"+
                                        Metotlar().outConvSAYItoQ(provider.getcikisNo[indexNo]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(flex: 4,)
                    ],
                  ),
                ),
                Spacer(flex: 7,)
              ],
            ),
            ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage(imageGetir(provider.getpedHarita[indexNo])),
                  fit: provider.getpedHarita[indexNo]==0 ? BoxFit.contain : BoxFit.fill,
                ),
              ),
            )),
      ),
    );
  }

  Future _resetAlert(String x, BuildContext context, PedHaritasiProvider provider, DBProkis dbProkis ) async {
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

        provider.listIslem(provider.tumCikislar, provider.getcikisNo, 4, 0, 0, 25);

        for (int i = 1; i <= 110; i++) {
          //tumCikislarVeri = tumCikislarVeri +provider.gettumCikislar[i].toString() + "#";
          tumCikislarVeri = tumCikislarVeri +"0" + "#";
        }

        provider.listIslem(provider.getpedHarita, null, 2, 0, 0, 25);
        provider.listIslem(provider.getpedNo, null, 2, 0, 0, 25);
        provider.listIslem(provider.getcikisNo, null, 2, 0, 0, 25);
        provider.listIslem(provider.getpedVisibility, null, 2, 0, true, 25);
        provider.setharitaOnay = false;

        Metotlar()
            .veriGonder("20*0*0*0*0*0", context, 2233, "toast8", dilSecimi)
            .then((value) {
          Metotlar()
              .veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233,
                  "toast8", dilSecimi)
              .then((value) {
            dbProkis.dbSatirEkleGuncelle(18, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(19, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
          });
        });
      }
    });
  }

    Future _sayfaGeriAlert(String dilSecimi, String uyariMetni, BuildContext context ) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SayfaGeriAlert.deger(dilSecimi,uyariMetni);
      },
    ).then((val) {
      if (val) {

        if(val){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KurulumAyarlari()),
          );

        }


      }
    });
  }

}



class PedHaritasiProvider with ChangeNotifier {
  int sayac=0;

  List<int> pedHarita = new List.filled(25,0);
  List<bool> pedVisibility = new List.filled(25,true);
  List<int> pedNo = new List.filled(25,0);
  List<int> cikisNo = new List.filled(25,0);
  List<int> cikisNoGecici = new List.filled(25,0);
  bool haritaOnay = false;
  int pedAdet = 0;

  bool veriGonderildi = false;
  bool pedNoTekerrur = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List.filled(111,0);

  listIslem(List list, List<int> aktarilacaklist, int islemTuru, int index, var value, int listLenght) {

    switch(islemTuru){
      case 1:
      list=List.from(aktarilacaklist);
      break;
      case 2:
      for (int i = 0; i < listLenght; i++) {
        list[i]=value;
      }
      break;
      case 3:
      list[index]=value;
      break;
      case 4:
      for (int i = 1; i < listLenght; i++) {
          if (aktarilacaklist[i] != 0) {
            list[aktarilacaklist[i]] = 0;
          }
        }
      break;
      case 5:
      pedNoTekerrur = false;
      cikisNoTekerrur = false;

      for (int i = 1; i <= 24; i++) {
        for (int k = 1; k <= 24; k++) {
          if (i != k &&
              pedNo[i] == pedNo[k] &&
              pedNo[i] != 0 &&
              pedNo[k] != 0) {
            pedNoTekerrur = true;
            break;
          }
          if (pedNoTekerrur) {
            break;
          }
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
      break;
      case 6:
      for (int i = 0; i < listLenght; i++) {
        cikisNoGecici[i]=cikisNo[i];
      }
      break;

    }
    
    notifyListeners();
  }

  dinlemeyiTetikle(){
    notifyListeners();
  }

  int get getsayac => sayac;

  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }

  List<int> get getpedHarita => pedHarita;
  List<bool> get getpedVisibility => pedVisibility;
  List<int> get getpedNo => pedNo;
  List<int> get getcikisNo => cikisNo;
  List<int> get getcikisNoGecici => cikisNoGecici;
  List<int> get gettumCikislar => tumCikislar;

  bool get getharitaOnay => haritaOnay;

  set setharitaOnay(bool value) {
    haritaOnay = value;
    notifyListeners();
  }

  int get getpedAdet => pedAdet;

  set setfanAdet(int value) {
    pedAdet = value;
    notifyListeners();
  }

  bool get getveriGonderildi => veriGonderildi;

  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }

  bool get getpedNoTekerrur => pedNoTekerrur;

  set setpedNoTekerrur(bool value) {
    pedNoTekerrur = value;
    notifyListeners();
  }

  bool get getcikisNoTekerrur => cikisNoTekerrur;

  set setcikisNoTekerrur(bool value) {
    cikisNoTekerrur = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  PedHaritasiProvider(this.context, this.dbProkis) {

    pedAdet = int.parse(dbProkis.dbVeriGetir(4, 3, "1"));
    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(18, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(19, 1, "");
    var tcikislar;
    var fHaritalar;
    var pedNolar;
    var cikisNolar;
    

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(18, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      pedNolar = dbProkis.dbVeriGetir(19, 2, "").split("#");
      cikisNolar = dbProkis.dbVeriGetir(19, 3, "").split("#");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i-1]);
      }
    }

    for (var i = 1; i <= 24; i++) {

      if (haritaKAYIT == "ok") {
        pedHarita[i] = int.parse(fHaritalar[i - 1]);
        if (fHaritalar[i - 1] != "0") {
          haritaOnay = true;
          pedVisibility[i] = true;
        }else{
          pedVisibility[i] = false;
        }
      }

      if (cikisKAYIT == "ok") {
        pedNo[i] = int.parse(pedNolar[i - 1]);
        cikisNo[i] = int.parse(cikisNolar[i - 1]);
        cikisNoGecici[i] = cikisNo[i];
      }
    }
  }
  
}
