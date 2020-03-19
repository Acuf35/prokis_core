import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:prokis/languages/select.dart';
import 'package:timer_builder/timer_builder.dart';
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

  Widget appBar(
      String dilSecimi, BuildContext context, double oran, String baslik) {
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


  Widget appBarSade(
      String dilSecimi, BuildContext context, double oran, String baslik,Color color) {
    return PreferredSize(
      preferredSize: Size.fromHeight(30 * oran),
      child: AppBar(
        flexibleSpace: Container(color: color,
          child: Row(
            children: <Widget>[
              Spacer(flex: 2,),
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
              Spacer(flex: 2,),
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

/*
  String getSystemTime(dbVeriler) {
      var now = new DateTime.now();
      //return new DateFormat("H:m:s").format(now);
      return new DateFormat('dd-MM-yyyy hh:mm:ss ').format(DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second));
      //return DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
  }
  */

  String getSystemTime(List<Map> dbVeri) {
    
    bool format24saatlik=true;
    int dkkFark=0;
    int satFark=0;
    
    
    

    for (int i = 0; i <= dbVeri.length - 1; i++) {

      if (dbVeri[i]["id"] == 34) {
        format24saatlik = dbVeri[i]["veri1"] =="1" ? true: false;
      }
      if (dbVeri[i]["id"] == 36) {
        satFark = int.parse(dbVeri[i]["veri1"]);
        dkkFark = int.parse(dbVeri[i]["veri2"]);

      }
    }


      var now = new DateTime.now();
      return new DateFormat(
        format24saatlik ? 'HH:mm:ss' : 'a hh:mm:ss').format(DateTime(now.year,now.month,now.day,now.hour+satFark, now.minute+dkkFark, now.second));
  }

  String getSystemDate(List<Map> dbVeri) {

    bool tarihFormati1=true;

    int yilFark=0;
    int ayyFark=0;
    int gunFark=0;

    for (int i = 0; i <= dbVeri.length - 1; i++) {

      if (dbVeri[i]["id"] == 34) {
        tarihFormati1 = dbVeri[i]["veri2"] =="1" ? true: false;
      }
      if (dbVeri[i]["id"] == 35) {
        gunFark = int.parse(dbVeri[i]["veri1"]);
        ayyFark = int.parse(dbVeri[i]["veri2"]);
        yilFark = int.parse(dbVeri[i]["veri3"]);
        
      }
    }


      var now = new DateTime.now();
      
      return new DateFormat(tarihFormati1 ? 'dd-MM-yyyy' : 'MM-dd-yyyy').format(DateTime(now.year+yilFark, now.month+ayyFark, now.day+gunFark));
  }







}
