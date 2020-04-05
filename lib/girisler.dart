import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
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
  bool sirkFanVarMi = false;
  bool bacafanKapakVarMi = false;



  List<int> gercekGiris = new List.filled(49,0);
  List<bool> gercekGirisRenk = new List.filled(49,false);
  List<bool> girisGorunurluk = new List.filled(49,true);

  int _onlar = 3;
  int _birler = 3;
  int _index = 0;

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;

  bool girislerOK = false;

  bool durum=true;

  bool yem1Aktif = false;
  bool yem2Aktif = false;
  bool yem3Aktif = false;


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  GirislerState(List<Map> dbVeri,bool drm) {
/*
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        klepeAdet = dbVeri[i]["veri2"];
        //klepeAdet = "10";
      }

      if (dbVeri[i]["id"] == 5) {
        var xx=dbVeri[i]["veri1"].split('#'); 
        bacafanAdet = xx[0];
        sirkFanVarMi = xx[1]=="0" ? false : true;
        airInletAdet= dbVeri[i]["veri2"];
        //airInletAdet= "2";
        isiticiAdet= dbVeri[i]["veri3"];
      }

      if (dbVeri[i]["id"] == 33) {
        sayacAdet = dbVeri[i]["veri1"];
        //sayacAdet = "12";
      }

      if (dbVeri[i]["id"] == 32) {
        if (dbVeri[i]["veri1"] == "ok") {
          veriGonderildi=true;
          var tgirisler = dbVeri[i]["veri2"].split("#");
          for (int i = 1; i <= 46; i++) {
            gercekGiris[i] = int.parse(tgirisler[i - 1]);
          }
        }
      }

      if (dbVeri[i]["id"] == 24) {
        String zz;

        if (dbVeri[i]["veri1"] == "ok") {
          zz = dbVeri[i]["veri4"];
          var bacafanAnalogVeKapakVeri = zz.split("*");
          bacafanKapakVarMi=bacafanAnalogVeKapakVeri[3]=="1" ? true :false;
        }
      }

      if (dbVeri[i]["id"] == 31) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri3"];
          var aktifYemCikislar = xx.split("#");
          yem1Aktif = aktifYemCikislar[0] == "1" ? true : false;
          yem2Aktif = aktifYemCikislar[1] == "1" ? true : false;
          yem3Aktif = aktifYemCikislar[2] == "1" ? true : false;
        }
      }
    }





    if(bacafanAdet=="0") {
      girisGorunurluk[6]=false;
      if(!bacafanKapakVarMi){
        girisGorunurluk[32]=false;
        girisGorunurluk[33]=false;
      }
    }
    if(airInletAdet=="0") {
      girisGorunurluk[7]=false;
      girisGorunurluk[30]=false;
      girisGorunurluk[31]=false;

    }
    if(isiticiAdet=="0") girisGorunurluk[8]=false;
    if(!sirkFanVarMi) girisGorunurluk[9]=false;

    for (var i = 1; i < 11; i++) {
      if(int.parse(klepeAdet)+9<i+9) girisGorunurluk[i+9]=false;
      if(int.parse(klepeAdet)+19<i+19) girisGorunurluk[i+19]=false;
    }

    if(!yem1Aktif && !yem2Aktif && !yem3Aktif){
      girisGorunurluk[34]=false;
    }

    for (var i = 36; i < 48; i++) {

      if(int.parse(sayacAdet)<i-35){
        girisGorunurluk[i]=false;
      }
      
    }

    _girisRenkAtama();
*/
    durum=drm;

    _dbVeriCekme();

    
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

int sayac=0;
int timerSayac=0;
int unsurAdet=3;
  @override
  Widget build(BuildContext context) {

     if (timerSayac == 0) {
      //_takipEt();

      Timer.periodic(Duration(seconds: 0, milliseconds: 100), (timer) {
        
        timerSayac++;
if(timerSayac==1){
  setState(() {
    
  });
  
}

if(timerSayac==2){
  unsurAdet=6;
  setState(() {
    
  });
  
}

      });
    }

    

    if(sayac!=0){
      _girisRenkAtama();
      print("Giriyor bilee");
    }

    sayac++;
    

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
    var genislik=MediaQuery.of(context).size.width;
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
                Spacer(flex: 1,),
                //Girişların olduğu bölüm

                Expanded(flex: 80,
                  child: GridView.count(
                    //maxCrossAxisExtent: oranHarita/sutunSayisi,
                    //childAspectRatio:2,
                    crossAxisCount: 10,
                    padding: EdgeInsets.all(0),

                    //maxCrossAxisExtent: 60,
                    children: List.generate(unsurAdet, (index) {
                      return Center(
                        child: _girisAtamaUnsur(index, oran, timerSayac)

                      );
                    }),
                  ),
                ),
               
   /*             
              
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(1, oran,"tv352",true),
                      _girisAtamaUnsur(2, oran,"tv353",true),
                      _girisAtamaUnsur(3, oran,"tv354",true),
                      _girisAtamaUnsur(4, oran,"tv355",true),
                      _girisAtamaUnsur(5, oran,"tv356",true),
                      _girisAtamaUnsur(6, oran,"tv357",true),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(7, oran,"tv358",int.parse(klepeAdet)>0),
                      _girisAtamaUnsur(8, oran,"tv359",int.parse(klepeAdet)>1),
                      _girisAtamaUnsur(9, oran,"tv360",int.parse(klepeAdet)>2),
                      _girisAtamaUnsur(10, oran,"tv361",int.parse(klepeAdet)>3),
                      _girisAtamaUnsur(11, oran,"tv362",int.parse(klepeAdet)>4),
                      _girisAtamaUnsur(33, oran,"tv384",int.parse(isiticiAdet)>0),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(17, oran,"tv368",int.parse(klepeAdet)>0),
                      _girisAtamaUnsur(18, oran,"tv369",int.parse(klepeAdet)>1),
                      _girisAtamaUnsur(19, oran,"tv370",int.parse(klepeAdet)>2),
                      _girisAtamaUnsur(20, oran,"tv371",int.parse(klepeAdet)>3),
                      _girisAtamaUnsur(21, oran,"tv372",int.parse(klepeAdet)>4),
                      _girisAtamaUnsur(34, oran,"tv385",true),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(12, oran,"tv363",int.parse(klepeAdet)>5),
                      _girisAtamaUnsur(13, oran,"tv364",int.parse(klepeAdet)>6),
                      _girisAtamaUnsur(14, oran,"tv365",int.parse(klepeAdet)>7),
                      _girisAtamaUnsur(15, oran,"tv366",int.parse(klepeAdet)>8),
                      _girisAtamaUnsur(16, oran,"tv367",int.parse(klepeAdet)>9),
                      Spacer(flex: 5,),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(22, oran,"tv373",int.parse(klepeAdet)>5),
                      _girisAtamaUnsur(23, oran,"tv374",int.parse(klepeAdet)>6),
                      _girisAtamaUnsur(24, oran,"tv375",int.parse(klepeAdet)>7),
                      _girisAtamaUnsur(25, oran,"tv376",int.parse(klepeAdet)>8),
                      _girisAtamaUnsur(26, oran,"tv377",int.parse(klepeAdet)>9),
                      Spacer(flex: 5,),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(27, oran,"tv378",int.parse(airInletAdet)>0),
                      _girisAtamaUnsur(28, oran,"tv379",int.parse(airInletAdet)>1),
                      _girisAtamaUnsur(29, oran,"tv380",int.parse(airInletAdet)>0),
                      _girisAtamaUnsur(30, oran,"tv381",int.parse(airInletAdet)>1),
                      _girisAtamaUnsur(31, oran,"tv382",int.parse(airInletAdet)>0),
                      _girisAtamaUnsur(32, oran,"tv383",int.parse(bacafanAdet)>0),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(35, oran,"tv386",int.parse(sayacAdet)>0),
                      _girisAtamaUnsur(36, oran,"tv387",int.parse(sayacAdet)>1),
                      _girisAtamaUnsur(37, oran,"tv388",int.parse(sayacAdet)>2),
                      _girisAtamaUnsur(38, oran,"tv389",int.parse(sayacAdet)>3),
                      _girisAtamaUnsur(39, oran,"tv390",int.parse(sayacAdet)>4),
                      _girisAtamaUnsur(40, oran,"tv391",int.parse(sayacAdet)>5),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      _girisAtamaUnsur(41, oran,"tv392",int.parse(sayacAdet)>6),
                      _girisAtamaUnsur(42, oran,"tv393",int.parse(sayacAdet)>7),
                      _girisAtamaUnsur(43, oran,"tv394",int.parse(sayacAdet)>8),
                      _girisAtamaUnsur(44, oran,"tv395",int.parse(sayacAdet)>9),
                      _girisAtamaUnsur(45, oran,"tv396",int.parse(sayacAdet)>10),
                      _girisAtamaUnsur(46, oran,"tv397",int.parse(sayacAdet)>11),
                    ],
                  ),
                ),
                */

                
                Spacer(),
                
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

  Widget _girisAtamaUnsur(int index, double oran, int sayac) {

    
if(sayac==0){
  return Container();
}else{
  return Visibility(visible: girisGorunurluk[index],maintainState: true,maintainSize: true,maintainAnimation: true,
      child: Column(
          children: <Widget>[
            Spacer(),
            Expanded(flex: 8,
             child: SizedBox(
       child: Container(
         alignment: Alignment.bottomCenter,
         child: AutoSizeText(
           Dil().sec(dilSecimi,baslikGetir(index)),
           textAlign: TextAlign.center,
           style: TextStyle(
               color: Colors.black,
               fontWeight: FontWeight.bold,
               fontSize: 150.0,
               fontFamily: 'Kelly Slab'),
           maxLines: 2,
           minFontSize: 8,
         ),
       ),
             ),),
            Expanded(flex: 10,
        child: Row(
          children: <Widget>[
            Spacer(),
            Expanded(
      flex: 6,
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
              index+1,
              oran,
              dilSecimi,
              baslikGetir(index),
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
            Spacer()
    ],
        ),
    );
  
}

    
  
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

    gercekGirisRenk=new List.filled(49, false);

    print(gercekGiris);

    for(int i=1;i<=46;i++){
        gercekGirisRenk[gercekGiris[i]]=true;
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

  String baslikGetir(int index){

  String veri="none";

  if(index==0) veri="tv352";//Acil stop
  if(index==1) veri="tv353";//Faz Koruma
  if(index==2) veri="tv354";//Elk. Kesildi
  if(index==3) veri="tv355";//Fan Termik
  if(index==4) veri="tv356";//Klp Termik
  if(index==5) veri="tv357";//Ped Termik
  if(index==6) veri="tv383";//Bfan Termik
  if(index==7) veri="tv382";//Air Termik
  if(index==8) veri="tv384";//Istcı Termik
  if(index==9) veri="tv385";//Sirk F Termik
  if(index==10) veri="tv358";//Klp1 aç swc
  if(index==11) veri="tv359";//Klp2 aç swc
  if(index==12) veri="tv360";//Klp3 aç swc
  if(index==13) veri="tv361";//Klp4 aç swc
  if(index==14) veri="tv362";//Klp5 aç swc
  if(index==15) veri="tv363";//Klp6 aç swc
  if(index==16) veri="tv364";//Klp7 aç swc
  if(index==17) veri="tv365";//Klp8 aç swc
  if(index==18) veri="tv366";//Klp9 aç swc
  if(index==19) veri="tv367";//Klp10 aç swc
  if(index==20) veri="tv368";//Klp1 kapa swc
  if(index==21) veri="tv369";//Klp2 kapa swc
  if(index==22) veri="tv370";//Klp3 kapa swc
  if(index==23) veri="tv371";//Klp4 kapa swc
  if(index==24) veri="tv372";//Klp5 kapa swc
  if(index==25) veri="tv373";//Klp6 kapa swc
  if(index==26) veri="tv374";//Klp7 kapa swc
  if(index==27) veri="tv375";//Klp8 kapa swc
  if(index==28) veri="tv376";//Klp9 kapa swc
  if(index==29) veri="tv377";//Klp10 kapa swc
  if(index==30) veri="tv378";//Air Aç swc
  if(index==31) veri="tv379";//Air kapa swc
  if(index==32) veri="tv380";//Bfan damper Aç swc
  if(index==33) veri="tv381";//Bfan damper kapa swc
  if(index==34) veri="tv632";//YemAra Termik
  if(index==35) veri="tv633";//Ayd Sig Termik
  if(index==36) veri="tv386";//Su sayacı 1
  if(index==37) veri="tv387";//Su sayacı 2
  if(index==38) veri="tv388";//Su sayacı 3
  if(index==39) veri="tv389";//Su sayacı 4
  if(index==40) veri="tv390";//Su sayacı 5
  if(index==41) veri="tv391";//Su sayacı 6
  if(index==42) veri="tv392";//Su sayacı 7
  if(index==43) veri="tv393";//Su sayacı 8
  if(index==44) veri="tv394";//Su sayacı 9
  if(index==45) veri="tv395";//Su sayacı 10
  if(index==46) veri="tv396";//Su sayacı 11
  if(index==47) veri="tv397";//Su sayacı 12

  return veri;
}

//--------------------------METOTLAR--------------------------------

}

