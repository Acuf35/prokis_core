import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'klp_yontemi.dart';
import 'languages/select.dart';

class MhYontemi extends StatefulWidget {
  List<Map> gelenDBveri;
  MhYontemi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return MhYontemiState(gelenDBveri);
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
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  MhYontemiState(List<Map> dbVeri) {
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
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
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
                          SelectLanguage().selectStrings(dilSecimi, "tv24"),
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
                              SelectLanguage().selectStrings(dilSecimi, "tv21"),
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
                                  'assets/images/ky_mh_klasik_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(
                          onPressed: () {
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
                          },
                          icon: Icon(kyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: kyDurum == true
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
                              SelectLanguage().selectStrings(dilSecimi, "tv25"),
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
                              SelectLanguage().selectStrings(dilSecimi, "tv26"),
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
                                  'assets/images/ky_mh_hacim_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(
                          onPressed: () {
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
                          },
                          icon: Icon(hyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: hyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600,
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
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        if (!kyDurum && !ayDurum && !hyDurum) {
                          Toast.show(
                              SelectLanguage()
                                  .selectStrings(dilSecimi, "toast22"),
                              context,
                              duration: 3);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KlpYontemi(dbVeriler)),
                          ).then((onValue) {
                            _dbVeriCekme();
                          });
                        }
                      },
                      color: Colors.black,
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
      socket = await Socket.connect('88.250.206.99', 2233);
      String gelen_mesaj = "";

      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
        print(utf8.decode(event));
        gelen_mesaj = utf8.decode(event);
        var gelen_mesaj_parcali = gelen_mesaj.split("*");

        if (gelen_mesaj_parcali[0] == 'ok') {
          Toast.show(
              SelectLanguage().selectStrings(dilSecimi, "toast8"), context,
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
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

//--------------------------METOTLAR--------------------------------

}
