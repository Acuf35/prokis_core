import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:prokis/diger_cikislar.dart';
import 'package:prokis/kurulum_ozet.dart';
import 'package:prokis/kurulumu_tamamla.dart';
import 'package:prokis/silo_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'genel/sayfa_geri_alert.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class Girisler extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  Girisler(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum = durum;
  }
  @override
  State<StatefulWidget> createState() {
    return GirislerState(gelenDBveri,gelenDurum);
  }
}

class GirislerState extends State<Girisler> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  String klepeAdet = "0";
  String sayacAdet = "0";
  String airInletAdet = "0";
  String bacafanAdet = "0";
  String isiticiAdet = "0";



  List<int> gercekGiris = new List(47);
  List<bool> gercekGirisRenk = new List(47);
  List<bool> girisGorunurluk = new List(47);

  int _onlar = 3;
  int _birler = 3;
  int _index = 0;

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;

  bool girislerOK = false;

  bool durum;

  ProgressDialog pr;


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  GirislerState(List<Map> dbVeri,bool drm) {
    bool tumGirislerVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        klepeAdet = dbVeri[i]["veri2"];
      }

      if (dbVeri[i]["id"] == 5) {
        bacafanAdet= dbVeri[i]["veri1"];
        airInletAdet= dbVeri[i]["veri2"];
        isiticiAdet= dbVeri[i]["veri3"];
      }

      if (dbVeri[i]["id"] == 33) {
        sayacAdet = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 32) {
        if (dbVeri[i]["veri1"] == "ok") {
          veriGonderildi=true;
          tumGirislerVar = true;
          var tgirisler = dbVeri[i]["veri2"].split("#");
          for (int i = 1; i <= 46; i++) {
            gercekGiris[i] = int.parse(tgirisler[i - 1]);
          }
        }
      }
    }

    if (!tumGirislerVar) {
      for(int i=1;i<=46;i++){
        gercekGiris[i]=0;
      }
    }

    _girisRenkAtama();

    durum=drm;

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------


  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context,isDismissible: true);
    pr.style(
  message: 'Downloading file...',
  borderRadius: 10.0,
  backgroundColor: Colors.white,
  progressWidget: CircularProgressIndicator(),
  elevation: 10.0,
  insetAnimCurve: Curves.easeInOut,
  progress: 0.0,
  maxProgress: 100.0,
  progressTextStyle: TextStyle(
     color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
  messageTextStyle: TextStyle(
     color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
  );

    _girisRenkAtama();

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  if(veriGonderildi){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                      );
                  }else{
                    _sayfaGeriAlert(dilSecimi, "tv564");
                  }
                },
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
    ),
    
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
                      Dil().sec(dilSecimi, "tv351"),
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
        //aluyay Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                //Girişların olduğu bölüm
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(1, oran,"tv352",true),
                                    Spacer(),
                                    _girisAtamaUnsur(2, oran,"tv353",true),
                                    Spacer(),
                                    _girisAtamaUnsur(3, oran,"tv354",true),
                                    Spacer(),
                                    _girisAtamaUnsur(4, oran,"tv355",true),
                                    Spacer(),
                                    _girisAtamaUnsur(5, oran,"tv356",true),
                                    Spacer(),
                                    _girisAtamaUnsur(6, oran,"tv357",true),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(7, oran,"tv358",int.parse(klepeAdet)>0),
                                    Spacer(),
                                    _girisAtamaUnsur(8, oran,"tv359",int.parse(klepeAdet)>1),
                                    Spacer(),
                                    _girisAtamaUnsur(9, oran,"tv360",int.parse(klepeAdet)>2),
                                    Spacer(),
                                    _girisAtamaUnsur(10, oran,"tv361",int.parse(klepeAdet)>3),
                                    Spacer(),
                                    _girisAtamaUnsur(11, oran,"tv362",int.parse(klepeAdet)>4),
                                    Spacer(),
                                    _girisAtamaUnsur(33, oran,"tv384",int.parse(isiticiAdet)>0),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(17, oran,"tv368",int.parse(klepeAdet)>0),
                                    Spacer(),
                                    _girisAtamaUnsur(18, oran,"tv369",int.parse(klepeAdet)>1),
                                    Spacer(),
                                    _girisAtamaUnsur(19, oran,"tv370",int.parse(klepeAdet)>2),
                                    Spacer(),
                                    _girisAtamaUnsur(20, oran,"tv371",int.parse(klepeAdet)>3),
                                    Spacer(),
                                    _girisAtamaUnsur(21, oran,"tv372",int.parse(klepeAdet)>4),
                                    Spacer(),
                                    _girisAtamaUnsur(34, oran,"tv385",true),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(12, oran,"tv363",int.parse(klepeAdet)>5),
                                    Spacer(),
                                    _girisAtamaUnsur(13, oran,"tv364",int.parse(klepeAdet)>6),
                                    Spacer(),
                                    _girisAtamaUnsur(14, oran,"tv365",int.parse(klepeAdet)>7),
                                    Spacer(),
                                    _girisAtamaUnsur(15, oran,"tv366",int.parse(klepeAdet)>8),
                                    Spacer(),
                                    _girisAtamaUnsur(16, oran,"tv367",int.parse(klepeAdet)>9),
                                    Spacer(),
                                    Spacer(flex: 5,),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(22, oran,"tv373",int.parse(klepeAdet)>5),
                                    Spacer(),
                                    _girisAtamaUnsur(23, oran,"tv374",int.parse(klepeAdet)>6),
                                    Spacer(),
                                    _girisAtamaUnsur(24, oran,"tv375",int.parse(klepeAdet)>7),
                                    Spacer(),
                                    _girisAtamaUnsur(25, oran,"tv376",int.parse(klepeAdet)>8),
                                    Spacer(),
                                    _girisAtamaUnsur(26, oran,"tv377",int.parse(klepeAdet)>9),
                                    Spacer(),
                                    Spacer(flex: 5,),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(27, oran,"tv378",int.parse(airInletAdet)>0),
                                    Spacer(),
                                    _girisAtamaUnsur(28, oran,"tv379",int.parse(airInletAdet)>1),
                                    Spacer(),
                                    _girisAtamaUnsur(29, oran,"tv380",int.parse(airInletAdet)>0),
                                    Spacer(),
                                    _girisAtamaUnsur(30, oran,"tv381",int.parse(airInletAdet)>1),
                                    Spacer(),
                                    _girisAtamaUnsur(31, oran,"tv382",int.parse(airInletAdet)>0),
                                    Spacer(),
                                    _girisAtamaUnsur(32, oran,"tv383",int.parse(bacafanAdet)>0),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(35, oran,"tv386",int.parse(sayacAdet)>0),
                                    Spacer(),
                                    _girisAtamaUnsur(36, oran,"tv387",int.parse(sayacAdet)>1),
                                    Spacer(),
                                    _girisAtamaUnsur(37, oran,"tv388",int.parse(sayacAdet)>2),
                                    Spacer(),
                                    _girisAtamaUnsur(38, oran,"tv389",int.parse(sayacAdet)>3),
                                    Spacer(),
                                    _girisAtamaUnsur(39, oran,"tv390",int.parse(sayacAdet)>4),
                                    Spacer(),
                                    _girisAtamaUnsur(40, oran,"tv391",int.parse(sayacAdet)>5),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                     
                      Spacer(),
                      Expanded(
                        flex: 22,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _girisAtamaUnsur(41, oran,"tv392",int.parse(sayacAdet)>6),
                                    Spacer(),
                                    _girisAtamaUnsur(42, oran,"tv393",int.parse(sayacAdet)>7),
                                    Spacer(),
                                    _girisAtamaUnsur(43, oran,"tv394",int.parse(sayacAdet)>8),
                                    Spacer(),
                                    _girisAtamaUnsur(44, oran,"tv395",int.parse(sayacAdet)>9),
                                    Spacer(),
                                    _girisAtamaUnsur(45, oran,"tv396",int.parse(sayacAdet)>10),
                                    Spacer(),
                                    _girisAtamaUnsur(46, oran,"tv397",int.parse(sayacAdet)>11),
                                  ],
                                ),
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                     ],
                  ),
                ),
                

                
                Spacer(),
                Expanded(
                  flex: 18,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv350"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                color: Colors.black,
                                fontSize: 60,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 60,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  _girislerUnsur(1, oran),
                                  _girislerUnsur(2, oran),
                                  _girislerUnsur(3, oran),
                                  _girislerUnsur(4, oran),
                                  _girislerUnsur(5, oran),
                                  _girislerUnsur(6, oran),
                                  _girislerUnsur(7, oran),
                                  _girislerUnsur(8, oran),
                                  _girislerUnsur(9, oran),
                                  _girislerUnsur(10, oran),
                                  _girislerUnsur(11, oran),
                                  _girislerUnsur(12, oran),
                                  _girislerUnsur(13, oran),
                                  _girislerUnsur(14, oran),
                                  _girislerUnsur(15, oran),
                                  Spacer()
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  _girislerUnsur(16, oran),
                                  _girislerUnsur(17, oran),
                                  _girislerUnsur(18, oran),
                                  _girislerUnsur(19, oran),
                                  _girislerUnsur(20, oran),
                                  _girislerUnsur(21, oran),
                                  _girislerUnsur(22, oran),
                                  _girislerUnsur(23, oran),
                                  _girislerUnsur(24, oran),
                                  _girislerUnsur(25, oran),
                                  _girislerUnsur(26, oran),
                                  _girislerUnsur(27, oran),
                                  _girislerUnsur(28, oran),
                                  _girislerUnsur(29, oran),
                                  _girislerUnsur(30, oran),
                                  Spacer()
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  _girislerUnsur(31, oran),
                                  _girislerUnsur(32, oran),
                                  _girislerUnsur(33, oran),
                                  _girislerUnsur(34, oran),
                                  _girislerUnsur(35, oran),
                                  _girislerUnsur(36, oran),
                                  _girislerUnsur(37, oran),
                                  _girislerUnsur(38, oran),
                                  _girislerUnsur(39, oran),
                                  _girislerUnsur(40, oran),
                                  _girislerUnsur(41, oran),
                                  _girislerUnsur(42, oran),
                                  _girislerUnsur(43, oran),
                                  _girislerUnsur(44, oran),
                                  _girislerUnsur(45, oran),
                                  _girislerUnsur(46, oran),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(
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
                      //Verileri Gönder Butonu
                      FlatButton(
                        onPressed: () {
                          String cikisVeri = "";
                          bool girisKontrol=false;

                          for (int i = 1; i <= 46; i++) {
                            cikisVeri=cikisVeri+gercekGiris[i].toString()+"#";

                            if(gercekGiris[i]==0 && girisGorunurluk[i]){
                              girisKontrol=true;
                            }
                          }

                          if(girisKontrol){
                            Toast.show(Dil().sec(dilSecimi, "toast76"), context,duration: 3);
                          }else{
                          veriGonderildi=true;

                          _veriGonder("39", "37", cikisVeri, "0", "0", "0");
                          dbHelper.veriYOKSAekleVARSAguncelle(32,"ok",cikisVeri,"0","0").then((value) => _dbVeriCekme());
                          }
                          


                        },
                        highlightColor: Colors.green,
                        splashColor: Colors.red,
                        color: veriGonderildi ? Colors.green[500] : Colors.blue,
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
                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DigerCikislar(dbVeriler,true)),
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
                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          if (!veriGonderildi) {
                            Toast.show(
                                Dil().sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);


                          } else {

                            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KurulumuTamamla(dbVeriler)),
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

  
  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int indexNo,
      double oran, String dil, String baslik, int degerGirisKodu) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(
            onlarUnsur, birlerUnsur, indexNo, oran, dil, baslik);
      },
    ).then((val) {

    if(val[3]=="1") {
      if (
          _onlar != val[0] ||
          _birler != val[1] ||
          _index != val[2]) {

          veriGonderildi=false;
      }

      _onlar = val[0];
      _birler = val[1];
      _index = val[2];

      bool mukerrerKayit=false;
      int deger=_onlar*10+_birler;

      for (int i = 1; i <= 46; i++) {
        if(deger==gercekGiris[i] && _index!=i && deger!=0){
          mukerrerKayit=true;
          Toast.show("Girmeye çalıştığınız giriş kullanımda!!", context,duration: 3);
          break;
        }
      }


        if(!mukerrerKayit){
          gercekGiris[_index]=_onlar*10+_birler;
        }
        

        if(!veriGonderildi && !mukerrerKayit){
        setState(() {
        });
        }

    }


    });



  }

  
  _veriGonder(String dbKod, String id, String v1, String v2, String v3,
      String v4) async {
    Socket socket;

    try {
      socket = await Socket.connect('192.168.1.110', 2233);
      String gelen_mesaj = "";

      

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
        print(utf8.decode(event));
        gelen_mesaj = utf8.decode(event);
        var gelen_mesaj_parcali = gelen_mesaj.split("*");

        if (gelen_mesaj_parcali[0] == 'ok') {
          Toast.show(
              Dil().sec(dilSecimi, "toast8"), context,
              duration: 2);
              
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
      Toast.show(Dil().sec(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

  Widget _girisAtamaUnsur(int index, double oran, String baslik,bool gorunurluk) {

    girisGorunurluk[index]=gorunurluk;


    return Expanded(
        flex:5,
        child: Visibility(visible: gorunurluk,maintainState: true,maintainSize: true,maintainAnimation: true,
                  child: Column(
    children: <Widget>[
      Expanded(child: 
      SizedBox(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: AutoSizeText(
                                Dil().sec(dilSecimi,baslik),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 150.0,
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

                    _onlar = gercekGiris[index] < 10
                        ? 0
                        : (gercekGiris[index] ~/ 10).toInt();
                    _birler = gercekGiris[index] % 10;
                    _index = index;

                    _degergiris2X0(
                        _onlar,
                        _birler,
                        index,
                        oran,
                        dilSecimi,
                        baslik,
                        1);

                    
                  },
                  fillColor: Colors.green[300],
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              gercekGiris[index].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 150.0,
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
              Spacer()
            ],
          ),
      ),
    ],
          ),
        ),
      );
  }

  Widget _girislerUnsur(int index, double oran) {
    return Expanded(
      child: SizedBox(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 2*oran,bottom: 2*oran,left: 4*oran,right: 4*oran),
              child: Container(
                color: gercekGirisRenk[index] ? Colors.blue[200] : Colors.grey[300],
                alignment: Alignment.center,
                child: AutoSizeText(
                  index.toString() + ": " + inConv(index),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Kelly Slab",
                      color: Colors.black,
                      fontSize: 25 * oran,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String inConv(int deger) {
    String sonuc = "";

    if (deger == 1)
      sonuc = "I0.0";
    else if (deger == 2)
      sonuc = "I0.1";
    else if (deger == 3)
      sonuc = "I0.2";
    else if (deger == 4)
      sonuc = "I0.3";
    else if (deger == 5)
      sonuc = "I0.4";
    else if (deger == 6)
      sonuc = "I0.5";
    else if (deger == 7)
      sonuc = "I0.6";
    else if (deger == 8)
      sonuc = "I0.7";
    else if (deger == 9)
      sonuc = "I1.0";
    else if (deger == 10)
      sonuc = "I1.1";
    else if (deger == 11)
      sonuc = "I1.2";
    else if (deger == 12)
      sonuc = "I1.3";
    else if (deger == 13)
      sonuc = "I1.4";
    else if (deger == 14)
      sonuc = "I1.5";
    else if (deger == 15)
      sonuc = "I2.0";
    else if (deger == 16)
      sonuc = "I2.1";
    else if (deger == 17)
      sonuc = "I2.2";
    else if (deger == 18)
      sonuc = "I2.3";
    else if (deger == 19)
      sonuc = "I2.4";
    else if (deger == 20)
      sonuc = "I2.5";
    else if (deger == 21)
      sonuc = "I2.6";
    else if (deger == 22)
      sonuc = "I2.7";
    else if (deger == 23)
      sonuc = "I3.0";
    else if (deger == 24)
      sonuc = "I3.1";
    else if (deger == 25)
      sonuc = "I3.2";
    else if (deger == 26)
      sonuc = "I3.3";
    else if (deger == 27)
      sonuc = "I3.4";
    else if (deger == 28)
      sonuc = "I3.5";
    else if (deger == 29)
      sonuc = "I3.6";
    else if (deger == 30)
      sonuc = "I3.7";
    else if (deger == 31)
      sonuc = "I4.0";
    else if (deger == 32)
      sonuc = "I4.1";
    else if (deger == 33)
      sonuc = "I4.2";
    else if (deger == 34)
      sonuc = "I4.3";
    else if (deger == 35)
      sonuc = "I4.4";
    else if (deger == 36)
      sonuc = "I4.5";
    else if (deger == 37)
      sonuc = "I4.6";
    else if (deger == 38)
      sonuc = "I4.7";
    else if (deger == 39)
      sonuc = "I5.0";
    else if (deger == 40)
      sonuc = "I5.1";
    else if (deger == 41)
      sonuc = "I5.2";
    else if (deger == 42)
      sonuc = "I5.3";
    else if (deger == 43)
      sonuc = "I5.4";
    else if (deger == 44)
      sonuc = "I5.5";
    else if (deger == 45)
      sonuc = "I5.6";
    else if (deger == 46)
      sonuc = "I5.7";
    else {
      sonuc = "";
    }

    return sonuc;
  }

  _girisRenkAtama(){

    for(int i =1 ; i<=46;i++) {
      gercekGirisRenk[i]=false;
    }

    for(int i=1;i<=46;i++){
      for(int j=1;j<=46;j++){
        if(gercekGiris[i]==j){
        gercekGirisRenk[j]=true;
        }
      }
    }

  }

    Future _sayfaGeriAlert(String dilSecimi, String uyariMetni) async {
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
            MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
          );

        }


      }
    });
  }


//--------------------------METOTLAR--------------------------------

}
