import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0ve2xQ.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0veQ.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x2x2x0.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:prokis/sistem/kurulum/ped_haritasi.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/fan_haritasi.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';



class KlepeHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  KlepeHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  bool timerCancel=false;
  int sayac=0;
  int sayac2=0;
  bool yuklemeGecikme=false;

  @override
  Widget build(BuildContext context) {
    
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;

    return ChangeNotifierProvider<KlepeHaritasiProvider>(
      create: (context) => KlepeHaritasiProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context,constraints){
              final provider = Provider.of<KlepeHaritasiProvider>(context);

              if(sayac2==0){
                new Timer(Duration(seconds: 0, milliseconds: 1000), (){
                  provider.setsayac=1;
                  sayac2++;
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
                  Expanded(
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
                                Dil().sec(dilSecimi, "tv38"),
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
                  //klepe Harita Oluşturma Bölümü
                  Expanded(
                    flex: 9,
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Tüm duvarlar Klepe görünümü
                          Spacer(
                            flex: 1,
                          ),
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
                                              Column(
                                                children: <Widget>[
                                                  _klepeHaritaUnsur(1,provider,context),
                                                  _klepeHaritaUnsur(2,provider,context),
                                                  _klepeHaritaUnsur(3,provider,context),
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
                                                        _klepeHaritaUnsur(4,provider,context),
                                                        _klepeHaritaUnsur(5,provider,context),
                                                        _klepeHaritaUnsur(6,provider,context),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        _klepeHaritaUnsur(7,provider,context),
                                                        _klepeHaritaUnsur(8,provider,context),
                                                        _klepeHaritaUnsur(9,provider,context),
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
                                              Column(
                                                children: <Widget>[
                                                  _klepeHaritaUnsur(16,provider,context),
                                                  _klepeHaritaUnsur(17,provider,context),
                                                  _klepeHaritaUnsur(18,provider,context),
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
                                                        _klepeHaritaUnsur(10,provider,context),
                                                        _klepeHaritaUnsur(11,provider,context),
                                                        _klepeHaritaUnsur(12,provider,context),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        _klepeHaritaUnsur(13,provider,context),
                                                        _klepeHaritaUnsur(14,provider,context),
                                                        _klepeHaritaUnsur(15,provider,context),
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
                          Spacer(
                            flex: 1,
                          ),
                          
                          Metotlar().cikislariGetir(provider.gettumCikislar, oranOzel, oran, 24,provider.getharitaOnay,provider.getsayac,dilSecimi),
                        
                        
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
                                  visible: !provider.getharitaOnay,
                                  maintainState: true,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  child: FlatButton(
                                    onPressed: () {
                                      int sayac = 0;

                                      for (int i = 1; i <= 18; i++) {
                                        if (provider.getklepeHarita[i] == 1) {
                                          sayac++;
                                        }
                                      }

                                      if (sayac < provider.getklepeAdet) {
                                        //Haritada seçilen klepe sayısı eksik
                                        Toast.show(
                                            Dil()
                                                .sec(dilSecimi, "toast29"),
                                            context,
                                            duration: 3);
                                      } else if (sayac > provider.getklepeAdet) {
                                        //Haritada seçilen klepe sayısı yüksek
                                        Toast.show(
                                            Dil()
                                                .sec(dilSecimi, "toast30"),
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

                                        for (int i = 1; i <= 18; i++) {
                                          if (provider.getklepeHarita[i] != 0) {
                                            provider.listIslem(provider.getklepeVisibility, null, 3, i, true, 19);
                                          } else {
                                            provider.listIslem(provider.getklepeVisibility, null, 3, i, false, 19);
                                          }
                                        }

                                        String veri = "";

                                        for (int i = 1; i <= 18; i++) {
                                          veri = veri + provider.getklepeHarita[i].toString() + "#";
                                        }

                                        Metotlar().veriGonder("15*21*$veri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                          if(value=="ok"){
                                            dbProkis.dbSatirEkleGuncelle(16, "ok", veri, "0", "0");
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
                                      bool klepeNOyuksek = false;
                                      String cikisVeriAc = "";
                                      String cikisVeriKapa = "";
                                      String noVeri = "";
                                      String tumCikislarVeri = "";
                                      for (int i = 1; i <= 18; i++) {
                                        if (provider.getklepeHarita[i] == 1) {
                                          if (provider.getklepeNo[i] == 0 ||
                                              provider.getcikisNoAc[i] == 0 ||
                                              provider.getcikisNoKapa[i] == 0) {
                                            noKontrol = true;
                                          }

                                          if (provider.getklepeNo[i] > provider.getklepeAdet) {
                                            klepeNOyuksek = true;
                                          }
                                        }
                                        cikisVeriAc =
                                            cikisVeriAc + provider.getcikisNoAc[i].toString() + "#";
                                        cikisVeriKapa = cikisVeriKapa +
                                            provider.getcikisNoKapa[i].toString() +
                                            "#";
                                        noVeri = noVeri + provider.getklepeNo[i].toString() + "#";
                                      }

                                      for (int i = 1; i <= 18; i++) {
                                        if (provider.getcikisNoGeciciAc[i] != provider.getcikisNoAc[i]) {
                                          if (provider.gettumCikislar[provider.getcikisNoAc[i]] == 0) {
                                            provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNoGeciciAc[i], 0, null);
                                          } else {
                                            cikisKullanimda = true;
                                          }
                                        }

                                        if (provider.getcikisNoGeciciKapa[i] != provider.getcikisNoKapa[i]) {
                                          if (provider.gettumCikislar[provider.getcikisNoKapa[i]] == 0) {
                                            provider.listIslem(provider.gettumCikislar, null, 3, provider.cikisNoGeciciKapa[i], 0, null);
                                          } else {
                                            cikisKullanimda = true;
                                          }
                                        }
                                      }

                                      if (noKontrol) {
                                        Toast.show(
                                            Dil()
                                                .sec(dilSecimi, "toast37"),
                                            context,
                                            duration: 3);
                                      } else if (klepeNOyuksek) {
                                        Toast.show(
                                            Dil()
                                                .sec(dilSecimi, "toast46"),
                                            context,
                                            duration: 3);
                                      } else if (provider.getklepeNoTekerrur) {
                                        Toast.show(
                                            Dil()
                                                .sec(dilSecimi, "toast28"),
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

                                        for (int i = 1; i <= 18; i++) {
                                          if (provider.getcikisNoAc[i] != 0) {
                                            provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNoAc[i], 1, null);
                                          }
                                          if (provider.getcikisNoKapa[i] != 0) {
                                            provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNoKapa[i], 1, null);
                                          }
                                        }
                                        
                                        for (int i = 1; i <= 110; i++) {
                                          tumCikislarVeri = tumCikislarVeri +
                                              provider.gettumCikislar[i].toString() +
                                              "#";
                                        }
                                        provider.setveriGonderildi = true;
                                        String komut="16*22*$noVeri*$cikisVeriAc*$cikisVeriKapa*0";
                                        Metotlar().veriGonder(komut, context, 2233, "toast8", dilSecimi).then((value){
                                          if(value=="ok"){
                                            Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                              if(value=="ok"){
                                                dbProkis.dbSatirEkleGuncelle(17, "ok", noVeri, cikisVeriAc, cikisVeriKapa);
                                                dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
                                              }
                                            });
                                          }
                                        });

                                        provider.listIslem(null, null, 6, null, null, 19);
                                        provider.listIslem(null, null, 6, null, null, 19);

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
                                                            builder: (context) =>
                                                                FanHaritasi(true)));
                                    
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
                                            builder: (context) => PedHaritasi(true)),
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
              )
            );

            },
                    
          ),
    );
  }

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/klepe_harita_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Widget _klepeHaritaUnsur(int indexNo, KlepeHaritasiProvider provider, BuildContext context) {
    return Expanded(
      child: Visibility(visible:provider.getklepeVisibility[indexNo] ? true : false,
              child: RawMaterialButton(
                  onPressed: () {



                    if (provider.getharitaOnay) {

                      int sayi = provider.getklepeNo[indexNo];
                      int kOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                      int kBirler = sayi % 10;

                      String outAcNoMetin = provider.getcikisNoAc[indexNo] == 0
                          ? "Q0.0"
                          : Metotlar()
                              .outConvSAYItoQ(provider.getcikisNoAc[indexNo]);

                      String outKapaNoMetin = provider.getcikisNoKapa[indexNo] == 0
                          ? "Q0.0"
                          : Metotlar()
                              .outConvSAYItoQ(provider.getcikisNoKapa[indexNo]);

                      int qByteOnlarAc = int.parse(outAcNoMetin.length > 4
                          ? outAcNoMetin.substring(1, 2)
                          : "0");
                      int qByteBirlerAc = int.parse(outAcNoMetin.length > 4
                          ? outAcNoMetin.substring(2, 3)
                          : outAcNoMetin.substring(1, 2));
                      int qBitAc =
                          int.parse(outAcNoMetin.substring(outAcNoMetin.length - 1));

                      int qByteOnlarKapa = int.parse(outKapaNoMetin.length > 4
                          ? outKapaNoMetin.substring(1, 2)
                          : "0");
                      int qByteBirlerKapa = int.parse(outKapaNoMetin.length > 4
                          ? outKapaNoMetin.substring(2, 3)
                          : outKapaNoMetin.substring(1, 2));
                      int qBitKapa =
                          int.parse(outKapaNoMetin.substring(outKapaNoMetin.length - 1));

                      MyshowModalBottomSheet2x0ve2xQ(dilSecimi, context, oran,
                              qByteOnlarAc, qByteBirlerAc, qBitAc, qByteOnlarKapa, qByteBirlerKapa, qBitKapa, kOnlar, kBirler, "tv40", "tv41", "tv42")
                          .then((value) {

                            print(value);

                                bool gelenVeri=value==null ? false : value[0];

                                if (gelenVeri) {

                                  outAcNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                                  outKapaNoMetin = "Q" + (value[4] == 0 ? "" : value[4].toString()) + value[5].toString() + "." + value[6].toString();
                                  int cikisNoAc = Metotlar().outConvQtoSAYI(outAcNoMetin);
                                  int cikisNoKapa = Metotlar().outConvQtoSAYI(outKapaNoMetin);



                                  if (cikisNoAc == 0 || cikisNoKapa==0) {
                                    Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                                  } else {

                                    sayi =value[7] * 10 + value[8];
                                    provider.listIslem(provider.getklepeNo, null, 3, indexNo, sayi, null);
print(cikisNoAc);
print(cikisNoKapa);
                                   
                                    provider.listIslem(provider.getcikisNoAc, null, 3, indexNo, cikisNoAc, null);
                                    provider.listIslem(provider.getcikisNoKapa, null, 3, indexNo, cikisNoKapa, null);

                                  }
                                }
                      });

                    
                    } else {

                      List<int> xx = provider.getklepeHarita;
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
                    child: Visibility(visible: provider.getharitaOnay && provider.getklepeHarita[indexNo]==1,
                                            child: Column(
                        children: <Widget>[
                          Spacer(),
                          Expanded(flex: 5,
                           child: Row(
                              children: <Widget>[
                                //KlepeNo
                                Expanded(
                                  child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv72")+"\n"+
                                      provider.getklepeNo[indexNo].toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,),
                                      maxLines: 2,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                                ),
                                

                                //AC Çıkış
                                Expanded(
                                  child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv43")+"\n"+
                                      Metotlar().outConvSAYItoQ(provider.getcikisNoAc[indexNo]),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,),
                                      maxLines: 2,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                                ),


                                //KAPA ÇIKIŞ
                                Expanded(
                                  child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv44")+"\n"+
                                      Metotlar().outConvSAYItoQ(provider.getcikisNoKapa[indexNo]),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,),
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
                        ],
                      ),
                    ),
                  
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage(imageGetir(provider.getklepeHarita[indexNo])),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )),
      ),
    );
  }


  Future _resetAlert(String x, BuildContext context, KlepeHaritasiProvider provider, DBProkis dbProkis) async {
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

        //tüm çıkışlardaki klepeCıkısNo'lara ait tüm çıkışları sıfırlar
        provider.listIslem(provider.tumCikislar, provider.getcikisNoAc, 4, 0, 0, 19);
        provider.listIslem(provider.tumCikislar, provider.getcikisNoKapa, 4, 0, 0, 19);

        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + provider.gettumCikislar[i].toString() + "#";
        }

        provider.listIslem(provider.getklepeHarita, null, 2, 0, 0, 19);
        provider.listIslem(provider.getklepeNo, null, 2, 0, 0, 19);
        provider.listIslem(provider.getcikisNoAc, null, 2, 0, 0, 19);
        provider.listIslem(provider.getcikisNoKapa, null, 2, 0, 0, 19);
        provider.listIslem(provider.getklepeVisibility, null, 2, 0, true, 19);

        provider.setharitaOnay = false;

        Metotlar()
            .veriGonder("17*0*0*0*0*0", context, 2233, "toast8", dilSecimi)
            .then((value) {
          Metotlar()
              .veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233,
                  "toast8", dilSecimi)
              .then((value) {
            dbProkis.dbSatirEkleGuncelle(16, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(17, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
          });
        });
      }
    });
  }

  Future _sayfaGeriAlert(String dilSecimi, String uyariMetni, BuildContext context) async {
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


class KlepeHaritasiProvider with ChangeNotifier {
  String _dilSecimi;
  int sayac=0;

  List<int> klepeHarita = new List.filled(19,0);
  List<bool> klepeVisibility = new List.filled(19,true);
  List<int> klepeNo = new List.filled(19,0);
  List<int> cikisNoAc = new List.filled(19,0);
  List<int> cikisNoGeciciAc = new List.filled(19,0);
  List<int> cikisNoKapa = new List.filled(19,0);
  List<int> cikisNoGeciciKapa = new List.filled(19,0);
  bool haritaOnay = false;
  int klepeAdet = 0;

  bool veriGonderildi = false;
  bool klepeNoTekerrur = false;
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
      klepeNoTekerrur = false;
      cikisNoTekerrur = false;

      for (int i = 1; i <= 18; i++) {
        for (int k = 1; k <= 18; k++) {
          if (i != k &&
              klepeNo[i] == klepeNo[k] &&
              klepeNo[i] != 0 &&
              klepeNo[k] != 0) {
            if (cikisNoAc[i] != cikisNoAc[k] ||
                cikisNoKapa[i] != cikisNoKapa[k]) {
              klepeNoTekerrur = true;
            }

            break;
          }
          if (klepeNoTekerrur) {
            break;
          }
          if (i != k &&
              cikisNoAc[i] == cikisNoAc[k] &&
              cikisNoAc[i] != 0 &&
              cikisNoAc[k] != 0) {
            if (klepeNo[i] != klepeNo[k]) {
              cikisNoTekerrur = true;
            }

            break;
          }

          if (i != k &&
              cikisNoKapa[i] == cikisNoKapa[k] &&
              cikisNoKapa[i] != 0 &&
              cikisNoKapa[k] != 0) {
            if (klepeNo[i] != klepeNo[k]) {
              cikisNoTekerrur = true;
            }
            break;
          }
          if (cikisNoAc[i] == cikisNoKapa[k] &&
              cikisNoAc[i] != 0 &&
              cikisNoKapa[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      break;
      case 6:
      for (int i = 0; i < listLenght; i++) {
        cikisNoGeciciAc[i]=cikisNoAc[i];
        cikisNoGeciciKapa[i]=cikisNoKapa[i];
      }
      break;

    }
    
    notifyListeners();
  }

  dinlemeyiTetikle(){
    notifyListeners();
  }




  List<int> get getklepeHarita => klepeHarita;
  List<bool> get getklepeVisibility => klepeVisibility;
  List<int> get getklepeNo => klepeNo;
  List<int> get getcikisNoAc => cikisNoAc;
  List<int> get getcikisNoGeciciAc => cikisNoGeciciAc;
  List<int> get getcikisNoKapa => cikisNoKapa;
  List<int> get getcikisNoGeciciKapa => cikisNoGeciciKapa;
  List<int> get gettumCikislar => tumCikislar;

  int get getsayac => sayac;

  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }

  bool get getharitaOnay => haritaOnay;

  set setharitaOnay(bool value) {
    haritaOnay = value;
    notifyListeners();
  }

  int get getklepeAdet => klepeAdet;

  set setklepeAdet(int value) {
    klepeAdet = value;
    notifyListeners();
  }

  bool get getveriGonderildi => veriGonderildi;

  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }

  bool get getklepeNoTekerrur => klepeNoTekerrur;

  set setklepeNoTekerrur(bool value) {
    klepeNoTekerrur = value;
    notifyListeners();
  }

  bool get getcikisNoTekerrur => cikisNoTekerrur;

  set setcikisNoTekerrur(bool value) {
    cikisNoTekerrur = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  KlepeHaritasiProvider(this.context, this.dbProkis) {
    _dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");

    klepeAdet = int.parse(dbProkis.dbVeriGetir(4, 2, "1"));
    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(16, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(17, 1, "");
    var tcikislar;
    var fHaritalar;
    var fanNolar;
    var cikisNolarAc;
    var cikisNolarKapa;

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(16, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      fanNolar = dbProkis.dbVeriGetir(17, 2, "").split("#");
      cikisNolarAc = dbProkis.dbVeriGetir(17, 3, "").split("#");
      cikisNolarKapa = dbProkis.dbVeriGetir(17, 4, "").split("#");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i - 1]);
      }
    }

    for (var i = 1; i <= 18; i++) {

      if (haritaKAYIT == "ok") {
        klepeHarita[i] = int.parse(fHaritalar[i - 1]);
        if (klepeHarita[i] != 0) {
          haritaOnay = true;
          klepeVisibility[i] = true;
        }else{
          klepeVisibility[i] = false;
        }
      }

      if (cikisKAYIT == "ok") {
        klepeNo[i] = int.parse(fanNolar[i - 1]);
        cikisNoAc[i] = int.parse(cikisNolarAc[i - 1]);
        cikisNoGeciciAc[i] = cikisNoAc[i];
        cikisNoKapa[i] = int.parse(cikisNolarKapa[i - 1]);
        cikisNoGeciciKapa[i] = cikisNoKapa[i];
      }
    }
  }
}

