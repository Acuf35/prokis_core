import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class Metotlar {


  
  Widget navigatorMenu(String dilSecimi, BuildContext context, double oran) {
    return Drawer(
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
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv124"), //Navigatör Menü
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
                            image:
                                AssetImage('assets/images/izleme_icon_red.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      "İZLEME",
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv107"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv111"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv108"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv112"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv109"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv113"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv110"),
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
                                      "  " +
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv114"),
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
    );
  }






}
