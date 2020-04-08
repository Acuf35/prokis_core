import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'adetler.dart';
import 'genel/database_helper.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';
import 'mh_yontemi.dart';

class FanYontemi extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  FanYontemi(List<Map> dbVeriler, bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum=durum;
  }
  @override
  State<StatefulWidget> createState() {
    return FanYontemiState(gelenDBveri,gelenDurum);
  }
}

class FanYontemiState extends State<FanYontemi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  bool kyDurum = false;
  bool lyDurum = false;
  bool pyDurum = false;

  String bacafanAdet;
  String kumesTuru;

  bool durum;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  FanYontemiState(List<Map> dbVeri,bool drm) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 6) {
        if (dbVeri[i]["veri1"] == "1") {
          kyDurum = true;
          lyDurum = false;
          pyDurum = false;
        } else if (dbVeri[i]["veri1"] == "2") {
          kyDurum = false;
          lyDurum = true;
          pyDurum = false;
        } else if (dbVeri[i]["veri1"] == "3") {
          kyDurum = false;
          lyDurum = false;
          pyDurum = true;
        }
      }

      if (dbVeri[i]["id"] == 3) {
        kumesTuru = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        var xx=dbVeri[i]["veri1"].split('#'); 
        bacafanAdet = xx[0];
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
                    MaterialPageRoute(builder: (context) => KurulumAyarlari()),
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
                          Dil().sec(dilSecimi, "tv20"),
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
              )
              
              ),
        ),
        //Fan Yöntemi seçim bölümü
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                //Klasik Kontrol
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
                                  color: kumesTuru !='1' ? Colors.grey[700] : Colors.black,
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
                                  'assets/images/ky_tf_klasik_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {
                            if(kumesTuru=='1'){

                            if (!kyDurum) {
                              kyDurum = true;
                            }

                            if (kyDurum) {
                              lyDurum = false;
                              pyDurum = false;
                            }

                            dbHelper.veriYOKSAekleVARSAguncelle(
                                6, "1", "0", "0", "0");
                            _veriGonder("4", "7", "1", "0", "0", "0");
                            setState(() {});
                            }else{
                              Toast.show(Dil().sec(dilSecimi, 'toast65'), context,duration: 3);
                            }


                          },
                          icon: Icon(kyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: kumesTuru!='1' ? Colors.grey[600] : (kyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600),
                          iconSize: 30 * oran,
                        ),
                      )
                    ],
                  ),
                ),
                //Lineer Kontrol
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
                              Dil().sec(dilSecimi, "tv22"),
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
                                  'assets/images/ky_tf_lineer_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {
                            if (!lyDurum) {
                              lyDurum = true;
                            }

                            if (lyDurum == true) {
                              kyDurum = false;
                              pyDurum = false;
                            }

                            dbHelper.veriYOKSAekleVARSAguncelle(
                                6, "2", "0", "0", "0");
                            _veriGonder("4", "7", "2", "0", "0", "0");
                            setState(() {});
                          },
                          icon: Icon(lyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: lyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600,
                          iconSize: 30 * oran,
                        ),
                      )
                    ],
                  ),
                ),
                //PID Kontrol
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
                              Dil().sec(dilSecimi, "tv23"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Kelly Slab',
                                  color: kumesTuru!='1' && bacafanAdet=="0" ? Colors.grey[700] : Colors.black,
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
                                  'assets/images/ky_tf_pid_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {
                            if(kumesTuru!="1" && bacafanAdet=="0"){
                              Toast.show(Dil().sec(dilSecimi, 'toast66'), context,duration: 3);
                            }else{

                            if (!pyDurum) {
                              pyDurum = true;
                            }

                            if (pyDurum == true) {
                              kyDurum = false;
                              lyDurum = false;
                            }

                            dbHelper.veriYOKSAekleVARSAguncelle(
                                6, "2", "0", "0", "0");
                            _veriGonder("4", "7", "3", "0", "0", "0");
                            setState(() {});
                            }
                          },
                          icon: Icon(pyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: kumesTuru!='1' && bacafanAdet=='0' ? Colors.grey[700] : (pyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600),
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
                Spacer(flex: 20),
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
                                                        builder: (context) =>
                                                            Adetler(dbVeriler,true)));
                          
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
                          if (!kyDurum && !lyDurum && !pyDurum) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast4"),
                                context,
                                duration: 3);
                          } else {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MhYontemi(dbVeriler,true)),
                            );


                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MhYontemi(dbVeriler)),
                            ).then((onValue) {
                              _dbVeriCekme();
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
