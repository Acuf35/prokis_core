import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class Metotlar {

  Widget navigatorMenu(String dilSecimi, BuildContext context, double oran) {
    return SizedBox(
      width: 320 * oran,
      child: Drawer(
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Column(
            children: <Widget>[
              //Başlık Bölümü
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    Dil().sec(dilSecimi, "tv124"), //Navigatör Menü
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Kelly Slab',
                    ),
                    textScaleFactor: oran,
                  ),
                  color: Colors.blue[800],
                ),
              ),
              //Navigatör Bölümü
              Expanded(
                flex: 16,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Toast.show("Buton çalışıyor...", context, duration: 3);
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/izleme_icon_red.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "İZLEME",
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Toast.show("Buton çalışıyor...", context, duration: 3);
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/mancontrol_icon_red.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "OTO-MAN",
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ExpansionTile(
                      //leading: Icon(Icons.ac_unit),

                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/kontrol_icon_small.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      //backgroundColor: Colors.green,
                      title: Text(
                        "KONTROL",
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/tem_hum_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv107"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.centerLeft,
                                              image: AssetImage(
                                                  'assets/images/heating_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv111"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/aydinlatma_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv108"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/cooling_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv112"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/cooling_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv109"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/silo_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv113"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/minvent_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv110"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              flex: 14,
                              child: RawMaterialButton(
                                fillColor: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: 30 * oran,
                                        height: 30 * oran,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/wizard_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv114"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ListTile(
                      onTap: () {
                        Toast.show("Buton çalışıyor...", context, duration: 3);
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/datalog_icon_small.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "DATA LOG",
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Toast.show("Buton çalışıyor...", context, duration: 3);
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/alarm_ayarlari_icon_small.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "ALARM AYAR.",
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Toast.show("Buton çalışıyor...", context, duration: 3);
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/settings_icon_small.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "KURULUM",
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(String dilSecimi, BuildContext context, double oran, String baslik) {
    return PreferredSize(
      preferredSize: Size.fromHeight(30 * oran),
      child: AppBar(
        flexibleSpace: Row(
          children: <Widget>[
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                child: Icon(
                  Icons.menu,
                  size: 40 * oran,
                  color: Colors.white,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            )),
            Spacer(),
            Expanded(
              flex: 10,
              child: Center(
                child: Text(
                  Dil().sec(dilSecimi, baslik),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28 * oran,
                      fontFamily: 'Kelly Slab',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Spacer(),
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Icon(
                  Icons.info_outline,
                  size: 40 * oran,
                  color: Colors.yellow[700],
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            )),
          ],
        ),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  color: Colors.yellow[700],
                  iconSize: 40 * oran,
                  icon: Icon(null),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
          ),
        ],
        primary: false,
        automaticallyImplyLeading: false,
      ),
    );
  }

  Widget appBarSade(String dilSecimi, BuildContext context, double oran, String baslik, Color color) {
    return PreferredSize(
      preferredSize: Size.fromHeight(30 * oran),
      child: AppBar(
        flexibleSpace: Container(
          color: color,
          child: Row(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 10,
                child: Center(
                  child: Text(
                    Dil().sec(dilSecimi, baslik),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28 * oran,
                        fontFamily: 'Kelly Slab',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  color: Colors.yellow[700],
                  iconSize: 40 * oran,
                  icon: Icon(null),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
          ),
        ],
        primary: false,
        automaticallyImplyLeading: false,
      ),
    );
  }

  String getSystemTime(List<Map> dbVeri) {
    bool format24saatlik = true;
    int dkkFark = 0;
    int satFark = 0;

    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 34) {
        format24saatlik = dbVeri[i]["veri1"] == "1" ? true : false;
      }
      if (dbVeri[i]["id"] == 36) {
        satFark = int.parse(dbVeri[i]["veri1"]);
        dkkFark = int.parse(dbVeri[i]["veri2"]);
      }
    }

    var now = new DateTime.now();
    return new DateFormat(format24saatlik ? 'HH:mm:ss' : 'a hh:mm:ss').format(
        DateTime(now.year, now.month, now.day, now.hour + satFark,
            now.minute + dkkFark, now.second));
  }

  String getSystemDate(List<Map> dbVeri) {
    bool tarihFormati1 = true;

    int yilFark = 0;
    int ayyFark = 0;
    int gunFark = 0;

    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 34) {
        tarihFormati1 = dbVeri[i]["veri2"] == "1" ? true : false;
      }
      if (dbVeri[i]["id"] == 35) {
        gunFark = int.parse(dbVeri[i]["veri1"]);
        ayyFark = int.parse(dbVeri[i]["veri2"]);
        yilFark = int.parse(dbVeri[i]["veri3"]);
      }
    }

    var now = new DateTime.now();

    return new DateFormat(tarihFormati1 ? 'dd-MM-yyyy' : 'MM-dd-yyyy').format(
        DateTime(now.year + yilFark, now.month + ayyFark, now.day + gunFark));
  }

  Future sayfaGeriAlert(BuildContext context, String dilSecimi,String uyariMetni, int sayfaKodu) async {
    /*

    Sayfa Kodları:

    1: KurulumAyarları
    
    */

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SayfaGeriAlert.deger(dilSecimi, uyariMetni);
      },
    ).then((val) {
      if (val) {
        if (sayfaKodu == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KurulumAyarlari()),
          );
        }
      }
    });
  }


  //Eskitip veri gönderme
  Future<String> veriGonderEski(String komut, BuildContext context, int portNo, String toastMesaj, String dilSecimi, var provider) async {

    //final provider = Provider.of<TemelAyarlarProvider>(context,listen: false);

    String durum;

      await Socket.connect('192.168.1.110', portNo).then((socket) {

        bool gonderimDurumu = false;
        String gelenmsj="";

        socket.add(utf8.encode(komut));

        socket.listen(
          (List<int> event) {
            print(utf8.decode(event));
            gelenmsj=utf8.decode(event);
            gonderimDurumu = gelenmsj =="ok" ? true : false;

            if (gonderimDurumu) {
              Toast.show(Dil().sec(dilSecimi, toastMesaj), context, duration: 2);
              //durum=Future.value("1");
              //provider.setsifreOnaylandi=true;
              durum="1";
            } else {
              Toast.show(gelenmsj, context, duration: 2);
              //durum=Future.value("2");
              durum="2";
            }
          },
          onDone: () {
            socket.close();
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        //durum=Future.value("3");
        durum="3";
      });

    return durum;
     

/*
    return await Future.delayed(Duration(seconds: 3), (){
      return durum;
    });
    */
  }

  Future<String> veriGonder(String komut, BuildContext context, int portNo, String toastMesaj, String dilSecimi) async {

    String _donusDegeri;
    
    if (komut != null) {
        print("Request has data");

          // =============================================================
          Socket _socket;
          await Socket.connect("192.168.1.110", portNo,
          timeout: Duration(seconds: 5)
          
          ).then((Socket sock) {
            _socket = sock;
          }).then((_) {
            // SENT TO SERVER ************************
            _socket.write(komut);
            return _socket.first;
          }).then((data) {
            // GET FROM SERVER *********************
            _donusDegeri =  new String.fromCharCodes(data).trim();
            if(_donusDegeri=="ok"){
              Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);
            }
          }).catchError((error) {
            print(error);
            var xx=error.toString().split(",");
            _donusDegeri=xx[0].trim();
            if(_donusDegeri=="SocketException: Connection timed out"){
              Toast.show(Dil().sec(dilSecimi, "toast91"), context, duration: 3);
            }else if(_donusDegeri=="SocketException: OS Error: Connection refused"){
              Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
            }else{
              Toast.show(Dil().sec(dilSecimi, "toast20")+"\n"+error.toString(), context, duration: 3);
            }

            _socket.close();
            
          });
      // ==============================================================
      
    } else {
      Toast.show(Dil().sec(dilSecimi, "toast43"), context, duration: 3);
    }

  return _donusDegeri;
} 

  Future<String> takipEt(String komut, BuildContext context, int portNo, String dilSecimi) async {

    String _donusDegeri;
    
    if (komut != null) {
        print("Request has data");

          // =============================================================
          Socket _socket;
          await Socket.connect("192.168.1.110", portNo,
          timeout: Duration(seconds: 5)
          
          ).then((Socket sock) {
            _socket = sock;
          }).then((_) {
            // SENT TO SERVER ************************
            _socket.write(komut);
            return _socket.first;
          }).then((data) {
            // GET FROM SERVER *********************
            _donusDegeri =  new String.fromCharCodes(data).trim();
            
          }).catchError((error) {
            print("Giriyor1");
            var xx=error.toString().split(",");
            _donusDegeri=xx[0].trim();
            if(_donusDegeri=="SocketException: Connection timed out"){
              Toast.show(Dil().sec(dilSecimi, "toast91"), context, duration: 3);
            }else if(_donusDegeri=="SocketException: OS Error: Connection refused"){
              Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
            }else{
              Toast.show(Dil().sec(dilSecimi, "toast20")+"\n"+error.toString(), context, duration: 3);
            }
            
          });
      // ==============================================================
      
    } else {
      Toast.show(Dil().sec(dilSecimi, "toast43"), context, duration: 3);
    }

  return _donusDegeri;
} 


  String outConvSAYItoQ(int deger) {
    String sonuc = "Q#.#";

    if (deger == 1)
      sonuc = "Q0.0";
    else if (deger == 2)
      sonuc = "Q0.1";
    else if (deger == 3)
      sonuc = "Q0.2";
    else if (deger == 4)
      sonuc = "Q0.3";
    else if (deger == 5)
      sonuc = "Q0.4";
    else if (deger == 6)
      sonuc = "Q0.5";
    else if (deger == 7)
      sonuc = "Q0.6";
    else if (deger == 8)
      sonuc = "Q0.7";
    else if (deger == 9)
      sonuc = "Q1.0";
    else if (deger == 10)
      sonuc = "Q1.1";
    else if (deger == 11)
      sonuc = "Q2.0";
    else if (deger == 12)
      sonuc = "Q2.1";
    else if (deger == 13)
      sonuc = "Q2.2";
    else if (deger == 14)
      sonuc = "Q2.3";
    else if (deger == 15)
      sonuc = "Q2.4";
    else if (deger == 16)
      sonuc = "Q2.5";
    else if (deger == 17)
      sonuc = "Q2.6";
    else if (deger == 18)
      sonuc = "Q2.7";
    else if (deger == 19)
      sonuc = "Q3.0";
    else if (deger == 20)
      sonuc = "Q3.1";
    else if (deger == 21)
      sonuc = "Q3.2";
    else if (deger == 22)
      sonuc = "Q3.3";
    else if (deger == 23)
      sonuc = "Q3.4";
    else if (deger == 24)
      sonuc = "Q3.5";
    else if (deger == 25)
      sonuc = "Q3.6";
    else if (deger == 26)
      sonuc = "Q3.7";
    else if (deger == 27)
      sonuc = "Q4.0";
    else if (deger == 28)
      sonuc = "Q4.1";
    else if (deger == 29)
      sonuc = "Q4.2";
    else if (deger == 30)
      sonuc = "Q4.3";
    else if (deger == 31)
      sonuc = "Q4.4";
    else if (deger == 32)
      sonuc = "Q4.5";
    else if (deger == 33)
      sonuc = "Q4.6";
    else if (deger == 34)
      sonuc = "Q4.7";
    else if (deger == 35)
      sonuc = "Q5.0";
    else if (deger == 36)
      sonuc = "Q5.1";
    else if (deger == 37)
      sonuc = "Q5.2";
    else if (deger == 38)
      sonuc = "Q5.3";
    else if (deger == 39)
      sonuc = "Q5.4";
    else if (deger == 40)
      sonuc = "Q5.5";
    else if (deger == 41)
      sonuc = "Q5.6";
    else if (deger == 42)
      sonuc = "Q5.7";
    else if (deger == 43)
      sonuc = "Q6.0";
    else if (deger == 44)
      sonuc = "Q6.1";
    else if (deger == 45)
      sonuc = "Q6.2";
    else if (deger == 46)
      sonuc = "Q6.3";
    else if (deger == 47)
      sonuc = "Q6.4";
    else if (deger == 48)
      sonuc = "Q6.5";
    else if (deger == 49)
      sonuc = "Q6.6";
    else if (deger == 50)
      sonuc = "Q6.7";
    else if (deger == 51)
      sonuc = "Q7.0";
    else if (deger == 52)
      sonuc = "Q7.1";
    else if (deger == 53)
      sonuc = "Q7.2";
    else if (deger == 54)
      sonuc = "Q7.3";
    else if (deger == 55)
      sonuc = "Q7.4";
    else if (deger == 56)
      sonuc = "Q7.5";
    else if (deger == 57)
      sonuc = "Q7.6";
    else if (deger == 58)
      sonuc = "Q7.7";
    else if (deger == 59)
      sonuc = "Q8.0";
    else if (deger == 60)
      sonuc = "Q8.1";
    else if (deger == 61)
      sonuc = "Q8.2";
    else if (deger == 62)
      sonuc = "Q8.3";
    else if (deger == 63)
      sonuc = "Q8.4";
    else if (deger == 64)
      sonuc = "Q8.5";
    else if (deger == 65)
      sonuc = "Q8.6";
    else if (deger == 66)
      sonuc = "Q8.7";
    else if (deger == 67)
      sonuc = "Q9.0";
    else if (deger == 68)
      sonuc = "Q9.1";
    else if (deger == 69)
      sonuc = "Q9.2";
    else if (deger == 70)
      sonuc = "Q9.3";
    else if (deger == 71)
      sonuc = "Q9.4";
    else if (deger == 72)
      sonuc = "Q9.5";
    else if (deger == 73)
      sonuc = "Q9.6";
    else if (deger == 74)
      sonuc = "Q9.7";
    else if (deger == 75)
      sonuc = "Q10.0";
    else if (deger == 76)
      sonuc = "Q10.1";
    else if (deger == 77)
      sonuc = "Q10.2";
    else if (deger == 78)
      sonuc = "Q10.3";
    else if (deger == 79)
      sonuc = "Q10.4";
    else if (deger == 80)
      sonuc = "Q10.5";
    else if (deger == 81)
      sonuc = "Q10.6";
    else if (deger == 82)
      sonuc = "Q10.7";
    else if (deger == 83)
      sonuc = "Q11.0";
    else if (deger == 84)
      sonuc = "Q11.1";
    else if (deger == 85)
      sonuc = "Q11.2";
    else if (deger == 86)
      sonuc = "Q11.3";
    else if (deger == 87)
      sonuc = "Q11.4";
    else if (deger == 88)
      sonuc = "Q11.5";
    else if (deger == 89)
      sonuc = "Q11.6";
    else if (deger == 90)
      sonuc = "Q11.7";
    else if (deger == 91)
      sonuc = "Q12.0";
    else if (deger == 92)
      sonuc = "Q12.1";
    else if (deger == 93)
      sonuc = "Q12.2";
    else if (deger == 94)
      sonuc = "Q12.3";
    else if (deger == 95)
      sonuc = "Q12.4";
    else if (deger == 96)
      sonuc = "Q12.5";
    else if (deger == 97)
      sonuc = "Q12.6";
    else if (deger == 98)
      sonuc = "Q12.7";
    else if (deger == 99)
      sonuc = "Q13.0";
    else if (deger == 100)
      sonuc = "Q13.1";
    else if (deger == 101)
      sonuc = "Q13.2";
    else if (deger == 102)
      sonuc = "Q13.3";
    else if (deger == 103)
      sonuc = "Q13.4";
    else if (deger == 104)
      sonuc = "Q13.5";
    else if (deger == 105)
      sonuc = "Q13.6";
    else if (deger == 106)
      sonuc = "Q13.7";
    else if (deger == 107)
      sonuc = "Q14.0";
    else if (deger == 108)
      sonuc = "Q14.1";
    else if (deger == 109)
      sonuc = "Q14.2";
    else if (deger == 110)
      sonuc = "Q14.3";
    else if (deger == 111)
      sonuc = "Q14.4";
    else if (deger == 112)
      sonuc = "Q14.5";
    else if (deger == 113)
      sonuc = "Q14.6";
    else if (deger == 114)
      sonuc = "114.7";
    else if (deger == 115)
      sonuc = "Q15.0";
    else if (deger == 116)
      sonuc = "Q15.1";
    else if (deger == 117)
      sonuc = "Q15.2";
    else if (deger == 118)
      sonuc = "Q15.3";
    else if (deger == 119)
      sonuc = "Q15.4";
    else if (deger == 120)
      sonuc = "Q15.5";
    else if (deger == 121)
      sonuc = "Q15.6";
    else if (deger == 122)
      sonuc = "Q15.7";
    else if (deger == 123)
      sonuc = "Q16.0";
    else {
      sonuc = "Q#.#";
    }

    return sonuc;
  }

  int outConvQtoSAYI(String deger) {
    int sonuc = 0;

    if (deger == "Q0.0")
      sonuc = 1;
    else if (deger == "Q0.1")
      sonuc = 2;
    else if (deger == "Q0.2")
      sonuc = 3;
    else if (deger == "Q0.3")
      sonuc = 4;
    else if (deger == "Q0.4")
      sonuc = 5;
    else if (deger == "Q0.5")
      sonuc = 6;
    else if (deger == "Q0.6")
      sonuc = 7;
    else if (deger == "Q0.7")
      sonuc = 8;
    else if (deger == "Q1.0")
      sonuc = 9;
    else if (deger == "Q1.1")
      sonuc = 10;
    else if (deger == "Q2.0")
      sonuc = 11;
    else if (deger == "Q2.1")
      sonuc = 12;
    else if (deger == "Q2.2")
      sonuc = 13;
    else if (deger == "Q2.3")
      sonuc = 14;
    else if (deger == "Q2.4")
      sonuc = 15;
    else if (deger == "Q2.5")
      sonuc = 16;
    else if (deger == "Q2.6")
      sonuc = 17;
    else if (deger == "Q2.7")
      sonuc = 18;
    else if (deger == "Q3.0")
      sonuc = 19;
    else if (deger == "Q3.1")
      sonuc = 20;
    else if (deger == "Q3.2")
      sonuc = 21;
    else if (deger == "Q3.3")
      sonuc = 22;
    else if (deger == "Q3.4")
      sonuc = 23;
    else if (deger == "Q3.5")
      sonuc = 24;
    else if (deger == "Q3.6")
      sonuc = 25;
    else if (deger == "Q3.7")
      sonuc = 26;
    else if (deger == "Q4.0")
      sonuc = 27;
    else if (deger == "Q4.1")
      sonuc = 28;
    else if (deger == "Q4.2")
      sonuc = 29;
    else if (deger == "Q4.3")
      sonuc = 30;
    else if (deger == "Q4.4")
      sonuc = 31;
    else if (deger == "Q4.5")
      sonuc = 32;
    else if (deger == "Q4.6")
      sonuc = 33;
    else if (deger == "Q4.7")
      sonuc = 34;
    else if (deger == "Q5.0")
      sonuc = 35;
    else if (deger == "Q5.1")
      sonuc = 36;
    else if (deger == "Q5.2")
      sonuc = 37;
    else if (deger == "Q5.3")
      sonuc = 38;
    else if (deger == "Q5.4")
      sonuc = 39;
    else if (deger == "Q5.5")
      sonuc = 40;
    else if (deger == "Q5.6")
      sonuc = 41;
    else if (deger == "Q5.7")
      sonuc = 42;
    else if (deger == "Q6.0")
      sonuc = 43;
    else if (deger == "Q6.1")
      sonuc = 44;
    else if (deger == "Q6.2")
      sonuc = 45;
    else if (deger == "Q6.3")
      sonuc = 46;
    else if (deger == "Q6.4")
      sonuc = 47;
    else if (deger == "Q6.5")
      sonuc = 48;
    else if (deger == "Q6.6")
      sonuc = 49;
    else if (deger == "Q6.7")
      sonuc = 50;
    else if (deger == "Q7.0")
      sonuc = 51;
    else if (deger == "Q7.1")
      sonuc = 52;
    else if (deger == "Q7.2")
      sonuc = 53;
    else if (deger == "Q7.3")
      sonuc = 54;
    else if (deger == "Q7.4")
      sonuc = 55;
    else if (deger == "Q7.5")
      sonuc = 56;
    else if (deger == "Q7.6")
      sonuc = 57;
    else if (deger == "Q7.7")
      sonuc = 58;
    else if (deger == "Q8.0")
      sonuc = 59;
    else if (deger == "Q8.1")
      sonuc = 60;
    else if (deger == "Q8.2")
      sonuc = 61;
    else if (deger == "Q8.3")
      sonuc = 62;
    else if (deger == "Q8.4")
      sonuc = 63;
    else if (deger == "Q8.5")
      sonuc = 64;
    else if (deger == "Q8.6")
      sonuc = 65;
    else if (deger == "Q8.7")
      sonuc = 66;
    else if (deger == "Q9.0")
      sonuc = 67;
    else if (deger == "Q9.1")
      sonuc = 68;
    else if (deger == "Q9.2")
      sonuc = 69;
    else if (deger == "Q9.3")
      sonuc = 70;
    else if (deger == "Q9.4")
      sonuc = 71;
    else if (deger == "Q9.5")
      sonuc = 72;
    else if (deger == "Q9.6")
      sonuc = 73;
    else if (deger == "Q9.7")
      sonuc = 74;
    else if (deger == "Q10.0")
      sonuc = 75;
    else if (deger == "Q10.1")
      sonuc = 76;
    else if (deger == "Q10.2")
      sonuc = 77;
    else if (deger == "Q10.3")
      sonuc = 78;
    else if (deger == "Q10.4")
      sonuc = 79;
    else if (deger == "Q10.5")
      sonuc = 80;
    else if (deger == "Q10.6")
      sonuc = 81;
    else if (deger == "Q10.7")
      sonuc = 82;
    else if (deger == "Q11.0")
      sonuc = 83;
    else if (deger == "Q11.1")
      sonuc = 84;
    else if (deger == "Q11.2")
      sonuc = 85;
    else if (deger == "Q11.3")
      sonuc = 86;
    else if (deger == "Q11.4")
      sonuc = 87;
    else if (deger == "Q11.5")
      sonuc = 88;
    else if (deger == "Q11.6")
      sonuc = 89;
    else if (deger == "Q11.7")
      sonuc = 90;
    else if (deger == "Q12.0")
      sonuc = 91;
    else if (deger == "Q12.1")
      sonuc = 92;
    else if (deger == "Q12.2")
      sonuc = 93;
    else if (deger == "Q12.3")
      sonuc = 94;
    else if (deger == "Q12.4")
      sonuc = 95;
    else if (deger == "Q12.5")
      sonuc = 96;
    else if (deger == "Q12.6")
      sonuc = 97;
    else if (deger == "Q12.7")
      sonuc = 98;
    else if (deger == "Q13.0")
      sonuc = 99;
    else if (deger == "Q13.1")
      sonuc = 100;
    else if (deger == "Q13.2")
      sonuc = 101;
    else if (deger == "Q13.3")
      sonuc = 102;
    else if (deger == "Q13.4")
      sonuc = 103;
    else if (deger == "Q13.5")
      sonuc = 104;
    else if (deger == "Q13.6")
      sonuc = 105;
    else if (deger == "Q13.7")
      sonuc = 106;
    else if (deger == "Q14.0")
      sonuc = 107;
    else if (deger == "Q14.1")
      sonuc = 108;
    else if (deger == "Q14.2")
      sonuc = 109;
    else if (deger == "Q14.3")
      sonuc = 110;
    else if (deger == "Q14.4")
      sonuc = 111;
    else if (deger == "Q14.5")
      sonuc = 112;
    else if (deger == "Q14.6")
      sonuc = 113;
    else if (deger == "114.7")
      sonuc = 114;
    else if (deger == "Q15.0")
      sonuc = 115;
    else if (deger == "Q15.1")
      sonuc = 116;
    else if (deger == "Q15.2")
      sonuc = 117;
    else if (deger == "Q15.3")
      sonuc = 118;
    else if (deger == "Q15.4")
      sonuc = 119;
    else if (deger == "Q15.5")
      sonuc = 120;
    else if (deger == "Q15.6")
      sonuc = 121;
    else if (deger == "Q15.7")
      sonuc = 122;
    else if (deger == "Q16.0")
      sonuc = 122;
    else {
      sonuc = 0;
    }

    return sonuc;
  }


  Widget cikislariGetir(List<int> tumCikislar, double oranOzel, double oran, int flex, bool haritaOnay, int sayac, String dilSecimi){


    return Expanded(
            flex: flex,
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(flex: 20,
                  child: Stack(fit: StackFit.expand,
                    children: <Widget>[
                      Visibility(visible: haritaOnay && sayac==1 ? true : false, 
                          child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil()
                                        .sec(dilSecimi, "tv62"),
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
                            Expanded(flex: 20,
                              child: GridView.extent(
                            padding: EdgeInsets.all(0),
                            
                            maxCrossAxisExtent: oranOzel,
                            childAspectRatio: 2.3,
                            

                            children: List.generate(110, (index){
                              return SizedBox(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(2 * oran),
                                      child: Container(height: 10*oran,
                                        color: tumCikislar[index+1] == 0
                                            ? Colors.grey[300]
                                            : (tumCikislar[index+1] == 1
                                                ? Colors.blue[200]
                                                : Colors.grey[300]),
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Metotlar().outConvSAYItoQ(index+1),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                              );
                      

                            })),
                        )

                      ],
                  ),
                ),
                      Visibility(visible: haritaOnay && sayac==0 ? true : false, 
                  child: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(width: 10*oran,),
                      Text(
                        Dil().sec(dilSecimi, "tv636"),
                        style: TextStyle(
                          color: Colors.grey[600]
                        ),
                        textScaleFactor: oran,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
                Spacer(),
        ],
      ),
    );
     
  }


  String inputConvSAYItoI(int deger) {
    String sonuc = "I#.#";

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
    else if (deger == 47)
      sonuc = "I6.0";
    else {
      sonuc = "I#.#";
    }

    return sonuc;
  }

  int inputConvItoSAYI(String deger) {
    int sonuc = 0;

    if (deger == "I0.0")
      sonuc = 1;
    else if (deger == "I0.1")
      sonuc = 2;
    else if (deger == "I0.2")
      sonuc = 3;
    else if (deger == "I0.3")
      sonuc = 4;
    else if (deger == "I0.4")
      sonuc = 5;
    else if (deger == "I0.5")
      sonuc = 6;
    else if (deger == "I0.6")
      sonuc = 7;
    else if (deger == "I0.7")
      sonuc = 8;
    else if (deger == "I1.0")
      sonuc = 9;
    else if (deger == "I1.1")
      sonuc = 10;
    else if (deger == "I1.2")
      sonuc = 11;
    else if (deger == "I1.3")
      sonuc = 12;
    else if (deger == "I1.4")
      sonuc = 13;
    else if (deger == "I1.5")
      sonuc = 14;
    else if (deger == "I2.0")
      sonuc = 15;
    else if (deger == "I2.1")
      sonuc = 16;
    else if (deger == "I2.2")
      sonuc = 17;
    else if (deger == "I2.3")
      sonuc = 18;
    else if (deger == "I2.4")
      sonuc = 19;
    else if (deger == "I2.5")
      sonuc = 20;
    else if (deger == "I2.6")
      sonuc = 21;
    else if (deger == "I2.7")
      sonuc = 22;
    else if (deger == "I3.0")
      sonuc = 23;
    else if (deger == "I3.1")
      sonuc = 24;
    else if (deger == "I3.2")
      sonuc = 25;
    else if (deger == "I3.3")
      sonuc = 26;
    else if (deger == "I3.4")
      sonuc = 27;
    else if (deger == "I3.5")
      sonuc = 28;
    else if (deger == "I3.6")
      sonuc = 29;
    else if (deger == "I3.7")
      sonuc = 30;
    else if (deger == "I4.0")
      sonuc = 31;
    else if (deger == "I4.1")
      sonuc = 32;
    else if (deger == "I4.2")
      sonuc = 33;
    else if (deger == "I4.3")
      sonuc = 34;
    else if (deger == "I4.4")
      sonuc = 35;
    else if (deger == "I4.5")
      sonuc = 36;
    else if (deger == "I4.6")
      sonuc = 37;
    else if (deger == "I4.7")
      sonuc = 38;
    else if (deger == "I5.0")
      sonuc = 39;
    else if (deger == "I5.1")
      sonuc = 40;
    else if (deger == "I5.2")
      sonuc = 41;
    else if (deger == "I5.3")
      sonuc = 42;
    else if (deger == "I5.4")
      sonuc = 43;
    else if (deger == "I5.5")
      sonuc = 44;
    else if (deger == "I5.6")
      sonuc = 45;
    else if (deger == "I5.7")
      sonuc = 46;
    else if (deger == "I6.0")
      sonuc = 47;
    else {
      sonuc = 0;
    }

    return sonuc;
  }

  String saatGetir(int saatNo) {
    String veri = "tv640";

    if (saatNo == 1) {
      veri = 'tv506';
    }
    if (saatNo == 2) {
      veri = 'tv507';
    }
    if (saatNo == 3) {
      veri = 'tv508';
    }
    if (saatNo == 4) {
      veri = 'tv509';
    }
    if (saatNo == 5) {
      veri = 'tv510';
    }
    if (saatNo == 6) {
      veri = 'tv511';
    }
    if (saatNo == 7) {
      veri = 'tv512';
    }
    if (saatNo == 8) {
      veri = 'tv513';
    }
    if (saatNo == 9) {
      veri = 'tv514';
    }
    if (saatNo == 10) {
      veri = 'tv515';
    }
    if (saatNo == 11) {
      veri = 'tv516';
    }
    if (saatNo == 12) {
      veri = 'tv517';
    }
    if (saatNo == 13) {
      veri = 'tv518';
    }
    if (saatNo == 14) {
      veri = 'tv519';
    }
    if (saatNo == 15) {
      veri = 'tv520';
    }
    if (saatNo == 16) {
      veri = 'tv521';
    }
    if (saatNo == 17) {
      veri = 'tv522';
    }
    if (saatNo == 18) {
      veri = 'tv523';
    }
    if (saatNo == 19) {
      veri = 'tv524';
    }
    if (saatNo == 20) {
      veri = 'tv525';
    }
    if (saatNo == 21) {
      veri = 'tv526';
    }
    if (saatNo == 22) {
      veri = 'tv527';
    }
    if (saatNo == 23) {
      veri = 'tv528';
    }
    if (saatNo == 24) {
      veri = 'tv529';
    }
    if (saatNo == 25) {
      veri = 'tv530';
    }
    if (saatNo == 26) {
      veri = 'tv531';
    }
    if (saatNo == 27) {
      veri = 'tv532';
    }
    if (saatNo == 28) {
      veri = 'tv533';
    }
    if (saatNo == 29) {
      veri = 'tv534';
    }
    if (saatNo == 30) {
      veri = 'tv535';
    }
    if (saatNo == 31) {
      veri = 'tv536';
    }
    if (saatNo == 32) {
      veri = 'tv537';
    }
    if (saatNo == 33) {
      veri = 'tv538';
    }
    if (saatNo == 34) {
      veri = 'tv539';
    }
    if (saatNo == 35) {
      veri = 'tv540';
    }
    if (saatNo == 36) {
      veri = 'tv541';
    }
    if (saatNo == 37) {
      veri = 'tv542';
    }
    if (saatNo == 38) {
      veri = 'tv543';
    }
    if (saatNo == 39) {
      veri = 'tv544';
    }
    if (saatNo == 40) {
      veri = 'tv545';
    }
    if (saatNo == 41) {
      veri = 'tv546';
    }
    if (saatNo == 42) {
      veri = 'tv547';
    }
    if (saatNo == 43) {
      veri = 'tv548';
    }
    if (saatNo == 44) {
      veri = 'tv549';
    }
    if (saatNo == 45) {
      veri = 'tv550';
    }
    if (saatNo == 46) {
      veri = 'tv551';
    }
    if (saatNo == 47) {
      veri = 'tv552';
    }
    if (saatNo == 48) {
      veri = 'tv553';
    }

    return veri;
  }


}




