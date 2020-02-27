import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'fan_yontemi.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'klp_yontemi.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class MhYontemi extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  MhYontemi(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum=durum;
  }
  @override
  State<StatefulWidget> createState() {
    return MhYontemiState(gelenDBveri,gelenDurum);
  }
}

class MhYontemiState extends State<MhYontemi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  bool kyDurum = false;
  bool ayDurum = false;
  bool hyDurum = false;

  String bacafanAdet;
  String kumesTuru;

  bool durum;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  MhYontemiState(List<Map> dbVeri, bool drm) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 7) {
        if (dbVeri[i]["veri1"] == "1") {
          kyDurum = true;
          ayDurum = false;
          hyDurum = false;
        } else if (dbVeri[i]["veri1"] == "2") {
          kyDurum = false;
          ayDurum = true;
          hyDurum = false;
        } else if (dbVeri[i]["veri1"] == "3") {
          kyDurum = false;
          ayDurum = false;
          hyDurum = true;
        }
      }

      if (dbVeri[i]["id"] == 3) {
        kumesTuru = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        bacafanAdet = dbVeri[i]["veri1"];
      }
    }
    durum=drm;
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                  );
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
                  Spacer(
                    flex: 2,
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          Dil().sec(dilSecimi, "tv24"),
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
                  Spacer(
                    flex: 2,
                  )
                ],
              ),
          
          alignment: Alignment.center,
        )),
        //Mh yöntemi seçim bölümü
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv21"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Kelly Slab',
                                  color: kumesTuru=="1" && bacafanAdet=="0" ?  Colors.black : Colors.grey[700],
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  'assets/images/ky_mh_klasik_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(

                          onPressed: () {

                            if(kumesTuru!="1" || bacafanAdet!=0){
                              Toast.show(Dil().sec(dilSecimi, "toast67"), context,duration: 3);
                            }else{

                            
                            if (!kyDurum) {
                              kyDurum = true;
                            }

                            if (kyDurum) {
                              ayDurum = false;
                              hyDurum = false;
                            }

                            dbHelper.veriYOKSAekleVARSAguncelle(
                                7, "1", "0", "0", "0");
                            _veriGonder("5", "8", "1", "0", "0", "0");
                            setState(() {});
                            }
                          },
                          icon: Icon(kyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: kumesTuru=="1" && bacafanAdet=="0" ? (kyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600) : Colors.grey[700],
                          iconSize: 30 * oran,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv25"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Kelly Slab',
                                  color: Colors.black,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  'assets/images/ky_mh_agirlik_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(
                          onPressed: () {
                            if (!ayDurum) {
                              ayDurum = true;
                            }

                            if (ayDurum == true) {
                              kyDurum = false;
                              hyDurum = false;
                            }
                            dbHelper.veriYOKSAekleVARSAguncelle(
                                7, "2", "0", "0", "0");
                            _veriGonder("5", "8", "2", "0", "0", "0");
                            setState(() {});
                          },
                          icon: Icon(ayDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: ayDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600,
                          iconSize: 30 * oran,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv26"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Kelly Slab',
                                  color: kumesTuru=="1" ? Colors.black : Colors.grey[700],
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  'assets/images/ky_mh_hacim_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(


                          onPressed: () {

                            if(kumesTuru=="1"){
                            if (!hyDurum) {
                              hyDurum = true;
                            }

                            if (hyDurum == true) {
                              kyDurum = false;
                              ayDurum = false;
                            }
                            dbHelper.veriYOKSAekleVARSAguncelle(
                                7, "3", "0", "0", "0");
                            _veriGonder("5", "8", "3", "0", "0", "0");
                            setState(() {});
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast65"), context,duration: 3);
                            }
                          },
                          icon: Icon(hyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: kumesTuru=="1" ? (hyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600) : Colors.grey[700],
                          iconSize: 30 * oran,
                        ),
                      )
                    ],
                  ),
                ),
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
                Spacer(
                  flex: 20,
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
                                builder: (context) => FanYontemi(dbVeriler,true)),
                          );
                          
                          
                          //Navigator.pop(context);
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
                          if (!kyDurum && !ayDurum && !hyDurum) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast22"),
                                context,
                                duration: 3);
                          } else {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KlpYontemi(dbVeriler,true)),
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

//--------------------------METOTLAR--------------------------------

}
