import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prokis/genel_ayarlar/alarm_durum.dart';
import 'package:prokis/genel_ayarlar/baglanti_durum.dart';
import 'package:prokis/genel_ayarlar/izleme.dart';
import 'package:prokis/genel_ayarlar/kalibrasyon.dart';
import 'package:prokis/genel_ayarlar/oto_man.dart';
import 'package:prokis/genel_ayarlar/suru.dart';
import 'package:prokis/izleme/izleme_bfanairistc.dart';
import 'package:prokis/izleme/izleme_fanklpped.dart';
import 'package:prokis/izleme/izleme_yemsuayd.dart';
import 'package:prokis/kontrol/aydinlatma.dart';
import 'package:prokis/kontrol/isitma.dart';
import 'package:prokis/kontrol/klepe_klasik.dart';
import 'package:prokis/kontrol/klepe_tunel.dart';
import 'package:prokis/kontrol/min_hav_agirlik.dart';
import 'package:prokis/kontrol/min_hav_hacim.dart';
import 'package:prokis/kontrol/min_hav_klasik.dart';
import 'package:prokis/kontrol/sicvefan_klasik_capraz.dart';
import 'package:prokis/kontrol/sicvefan_klasik_normal.dart';
import 'package:prokis/kontrol/sicvefan_lineer_capraz.dart';
import 'package:prokis/kontrol/sicvefan_lineer_normal.dart';
import 'package:prokis/kontrol/sicvefan_pid_capraz.dart';
import 'package:prokis/kontrol/sicvefan_pid_normal.dart';
import 'package:prokis/kontrol/sogutma_nem.dart';
import 'package:prokis/kontrol/yemleme.dart';
import 'package:prokis/kontrol/yrd_opsiyon.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/sistem/saat_tarih.dart';
import 'package:prokis/sistem/sistem_start_stop.dart';
import 'package:prokis/sistem/yazilim.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/yardimci/sifre_giris_admin.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class Metotlar{

  Widget navigatorMenu(String dilSecimi, BuildContext context, double oran) {
    final dbProkis = Provider.of<DBProkis>(context);
    var xx=dbProkis.dbVeriGetir(5, 1, "0");
    String bacaFanAdet = xx[0];
    String fanYontemi = dbProkis.dbVeriGetir(6, 1, "0");
    String klepeYontemi = dbProkis.dbVeriGetir(8, 1, "0");
    String mhYontemi = dbProkis.dbVeriGetir(7, 1, "0");
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
                    //Kontrol
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
                                  'assets/images/kontrol_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      //backgroundColor: Colors.green,
                      title: Text(
                        Dil().sec(dilSecimi, "tv102"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //SIC. & FAN
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
                                onPressed: () {

                                  if(fanYontemi=="2" && bacaFanAdet!="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanLineerCapraz(dbProkis.getDbVeri)),
                                        );
                                    }

                                    if(fanYontemi=="2" && bacaFanAdet=="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanLineerNormal(dbProkis.getDbVeri)),
                                        );
                                    }

                                    if(fanYontemi=="1" && bacaFanAdet!="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanKlasikCapraz(dbProkis.getDbVeri)),
                                        );
                                    }

                                    if(fanYontemi=="1" && bacaFanAdet=="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanKlasikNormal(dbProkis.getDbVeri)),
                                        );
                                    }

                                    if(fanYontemi=="3" && bacaFanAdet!="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanPIDCapraz(dbProkis.getDbVeri)),
                                        );
                                    }

                                    if(fanYontemi=="3" && bacaFanAdet=="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanPIDNormal(dbProkis.getDbVeri)),
                                        );
                                    }


                                },
                              ),
                            ),
                            Spacer(),
                            //ISITMA
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
                                onPressed: () {
                                  Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Isitma(dbProkis.getDbVeri)),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //KLEPE
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
                                                  'assets/images/klepe_icon.png'),
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
                                onPressed: () {
                                  if(klepeYontemi=="1"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => KlepeKlasik(dbProkis.getDbVeri)),
                                        );

                                    }

                                    if(klepeYontemi=="2"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => KlepeTunel(dbProkis.getDbVeri)),
                                        );

                                    }
                                },
                              ),
                            ),
                            Spacer(),
                            //AYDINLATMA
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
                                        "  " + Dil().sec(dilSecimi, "tv112"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Aydinlatma(dbProkis.getDbVeri)),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //SOĞ. & NEM
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
                                onPressed: () {
                                  Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SogutmaNem(dbProkis.getDbVeri)),
                                        );
                                  
                                },
                              ),
                            ),
                            Spacer(),
                            //YEMLEME
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
                                                  'assets/images/feeding_icon.png'),
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
                                onPressed: () {
                                   Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Yemleme(dbProkis.getDbVeri)),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //MİN HAV
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
                                onPressed: () {
                                  if(mhYontemi=="1"){
                                      Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MinHavKlasik(dbProkis.getDbVeri)),
                                          );
                                    }
                                    
                                    if(mhYontemi=="2"){
                                      Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MinHavAgirlik(dbProkis.getDbVeri)),
                                          );
                                    }

                                    if(mhYontemi=="3"){
                                      Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MinHavHacim(dbProkis.getDbVeri)),
                                          );
                                    }
                                },
                              ),
                            ),
                            Spacer(),
                            //YRD OPS.
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
                                                  'assets/images/diger_ops_icon.png'),
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
                                onPressed: () {
                                  Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => YrdOpsiyon(dbProkis.getDbVeri)),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //İZLEME
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
                                  'assets/images/izleme_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      //backgroundColor: Colors.green,
                      title: Text(
                        Dil().sec(dilSecimi, "tv100"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //İZLEME
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
                                                  'assets/images/izleme_small_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv100"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Izleme(dbProkis.getDbVeri)),
                                    );
                                },
                              ),
                            ),
                            Spacer(),
                            //İZLEME 1
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
                                        child: Stack(
                                      alignment:
                                          Alignment.center,
                                      children: <Widget>[
                                        LayoutBuilder(builder:
                                            (context,
                                                constraint) {
                                          return Icon(
                                            Icons
                                                .brightness_1,
                                            size: constraint
                                                .biggest
                                                .height,
                                            color: Colors
                                                .blue[700],
                                          );
                                        }),

                                        RotatedBox(quarterTurns: 1,
                                          child: LayoutBuilder(builder:
                                              (context,
                                                  constraint) {
                                            return Icon(
                                              Icons
                                                  .search,
                                              size: constraint
                                                  .biggest
                                                  .width,
                                              color: Colors
                                                  .black,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv598"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                   Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IzlemeFanKlpPed(dbProkis.getDbVeri)),
                                      );
                                },
                              ),
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //İZLEME 2
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
                                        child: Stack(
                                      alignment:
                                          Alignment.center,
                                      children: <Widget>[
                                        LayoutBuilder(builder:
                                            (context,
                                                constraint) {
                                          return Icon(
                                            Icons
                                                .brightness_1,
                                            size: constraint
                                                .biggest
                                                .height,
                                            color: Colors
                                                .blue[700],
                                          );
                                        }),

                                        RotatedBox(quarterTurns: 1,
                                          child: LayoutBuilder(builder:
                                              (context,
                                                  constraint) {
                                            return Icon(
                                              Icons
                                                  .search,
                                              size: constraint
                                                  .biggest
                                                  .width,
                                              color: Colors
                                                  .black,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv599"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IzlemeBfanAirIstc(dbProkis.getDbVeri)),
                                    );
                                },
                              ),
                            ),
                            Spacer(),
                            //İZLEME 3
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
                                        child: Stack(
                                      alignment:
                                          Alignment.center,
                                      children: <Widget>[
                                        LayoutBuilder(builder:
                                            (context,
                                                constraint) {
                                          return Icon(
                                            Icons
                                                .brightness_1,
                                            size: constraint
                                                .biggest
                                                .height,
                                            color: Colors
                                                .blue[700],
                                          );
                                        }),

                                        RotatedBox(quarterTurns: 1,
                                          child: LayoutBuilder(builder:
                                              (context,
                                                  constraint) {
                                            return Icon(
                                              Icons
                                                  .search,
                                              size: constraint
                                                  .biggest
                                                  .width,
                                              color: Colors
                                                  .black,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv647"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IzlemeYemSuAyd(dbProkis.getDbVeri)),
                                    );
                                },
                              ),
                            ),
                            
                          ],
                        ),
                        
                      ],
                    ),
                    //OTO-MAN
                    ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtoMan1()),
                                    );
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
                        Dil().sec(dilSecimi, "tv101"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //ALARM AYARLARI
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
                                  'assets/images/alarm_ayarlari_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        Dil().sec(dilSecimi, "tv104"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //SÜRÜ
                    ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SuruBilgisi(dbProkis.getDbVeri)),
                                    );
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/suru_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        Dil().sec(dilSecimi, "tv347"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //KALİBRASYON
                    ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Kalibrasyon(dbProkis.getDbVeri)),
                                    );
                      },
                      leading: SizedBox(
                        width: 40 * oran,
                        height: 40 * oran,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage(
                                  'assets/images/kalibrasyon_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        Dil().sec(dilSecimi, "tv348"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //DATALOG
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
                                  'assets/images/datalog_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        Dil().sec(dilSecimi, "tv103"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //SİSTEM
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
                                  'assets/images/settings_small_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      //backgroundColor: Colors.green,
                      title: Text(
                        Dil().sec(dilSecimi, "tv105"),
                        textScaleFactor: oran,
                        style: TextStyle(
                            fontFamily: 'Audio wide',
                            fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //KURULUM
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
                                                  'assets/images/kurulum_small_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv400"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KurulumAyarlari()),
                                    );
                                },
                              ),
                            ),
                            Spacer(),
                            //SAAT & TARİH
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
                                                  'assets/images/saat_tarih_ayar_small_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv402"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SaatTarih (dbProkis.getDbVeri)),
                                    );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //YAZILIM
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
                                                  'assets/images/software_small_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv677"),
                                        textScaleFactor: oran,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Yazilim (dbProkis.getDbVeri)),
                                    );
                                },
                              ),
                            ),
                            Spacer(),
                            //SİSTEM START-STOP
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
                                                  'assets/images/sistem_start_stop_small_icon.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  " + Dil().sec(dilSecimi, "tv690"),
                                        textScaleFactor: oran,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  _sifreGiris(oran,dbProkis,context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ListTile(
                      leading: SizedBox(
                        height: 100 * oran,
                        
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

  Future _sifreGiris(double oran, DBProkis dbProkis, BuildContext context) async {
    // flutter defined function
    String sifre=dbProkis.dbVeriGetir(3, 4, "0");
    String dilSecimi=dbProkis.dbVeriGetir(1, 1, "0");

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SifreGirisAdmin.Deger(dilSecimi,oran);
      },
    ).then((val) {

      print('$sifre  ,  $val');

      if(sifre==val[1] && val[0]=='1'){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SistemStartStop(dbProkis.getDbVeri)),
        );


      }else if(sifre!=val[1] && val[0]=='1'){
        Toast.show("Yanlış şifre girdiniz!", context,duration: 3);
      }
      
    });
  }

  Widget appBarAlarm(String dilSecimi, BuildContext context, double oran, String baslik, String baglantiDurum, String alarmDurum) {
    final dbProkis = Provider.of<DBProkis>(context);
    bool alarmVar=false;
    bool uyariVar=false;

    if (dbProkis.dbVeriGetir(48, 1, "0")=="1"){

      for(int i=0;i<=59;i++){

        if(!alarmVar){
          alarmVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
        }

      }


      for(int i=60;i<=79;i++){
        
        if(!uyariVar){
          uyariVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
          
        }

      }

    }

    
    return PreferredSize(
      preferredSize: Size.fromHeight(30*oran),
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
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Stack(fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(flex: 2,
                          child: Container(
                          alignment: Alignment.topLeft,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.add_alert,
                                  size: constraint
                                      .biggest.height,
                                  color: alarmVar==false ? Colors.green[200] : Colors.red[500],
                                );
                              }),
                          ),
                        ),
                        Spacer(flex: 1,)
                      ],
                    ),
                      Column(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Container(
                          alignment: Alignment.bottomRight,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.warning,
                                  size: constraint
                                      .biggest.height,
                                  color: uyariVar==false ? Colors.green[200] : Colors.yellow[700],
                                );
                              }),
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  
                },
              ),
            )),
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
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Icon(
                  Icons.router,
                  size: 40 * oran,
                  color: baglantiDurum=="" ? Colors.green[200] : Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BaglantiDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
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

  Widget appBarBaglanti(String dilSecimi, BuildContext context, double oran, String baslik, String baglantiDurum, String alarmDurum) {
    final dbProkis = Provider.of<DBProkis>(context);
    bool alarmVar=false;
    bool uyariVar=false;

    if (dbProkis.dbVeriGetir(48, 1, "0")=="1"){

      for(int i=0;i<=59;i++){

        if(!alarmVar){
          alarmVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
        }

      }


      for(int i=60;i<=79;i++){
        
        if(!uyariVar){
          uyariVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
          
        }

      }

    }

    
    return PreferredSize(
      preferredSize: Size.fromHeight(30*oran),
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
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Stack(fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(flex: 2,
                          child: Container(
                          alignment: Alignment.topLeft,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.add_alert,
                                  size: constraint
                                      .biggest.height,
                                  color: alarmVar==false ? Colors.green[200] : Colors.red[500],
                                );
                              }),
                          ),
                        ),
                        Spacer(flex: 1,)
                      ],
                    ),
                      Column(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Container(
                          alignment: Alignment.bottomRight,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.warning,
                                  size: constraint
                                      .biggest.height,
                                  color: uyariVar==false ? Colors.green[200] : Colors.yellow[700],
                                );
                              }),
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  dbProkis.dbSatirEkleGuncelle(48, "1", "0", "0", "0");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlarmUyariDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
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
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Icon(
                  Icons.router,
                  size: 40 * oran,
                  color: baglantiDurum=="" ? Colors.green[200] : Colors.red,
                ),
                onPressed: () {

                },
              ),
            )),
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


  Widget appBar(String dilSecimi, BuildContext context, double oran, String baslik, String baglantiDurum, String alarmDurum) {
    final dbProkis = Provider.of<DBProkis>(context);
    bool alarmVar=false;
    bool uyariVar=false;
    
    if (dbProkis.dbVeriGetir(48, 2, "0")=="1"){

      for(int i=0;i<=59;i++){

        if(!alarmVar){
          alarmVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
        }

      }


      for(int i=60;i<=79;i++){
        
        if(!uyariVar){
          uyariVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
          
        }

      }

    }

    
    return PreferredSize(
      preferredSize: Size.fromHeight(30*oran),
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
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Stack(fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(flex: 2,
                          child: Container(
                          alignment: Alignment.topLeft,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.add_alert,
                                  size: constraint
                                      .biggest.height,
                                  color: alarmVar==false ? Colors.green[200] : Colors.red[500],
                                );
                              }),
                          ),
                        ),
                        Spacer(flex: 1,)
                      ],
                    ),
                      Column(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Container(
                          alignment: Alignment.bottomRight,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.warning,
                                  size: constraint
                                      .biggest.height,
                                  color: uyariVar==false ? Colors.green[200] : Colors.yellow[700],
                                );
                              }),
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  dbProkis.dbSatirEkleGuncelle(48, "1", "0", "0", "0");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlarmUyariDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
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
            Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Icon(
                  Icons.router,
                  size: 40 * oran,
                  color: baglantiDurum=="" ? Colors.green[200] : Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BaglantiDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
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

  Widget appBarBLOC(String dilSecimi, BuildContext context, double oran, String baslik, String baglantiDurum, String alarmDurum) {

    final dbProkis = Provider.of<DBProkis>(context);
    bool alarmVar=false;
    bool uyariVar=false;

    if (dbProkis.dbVeriGetir(48, 3, "0")=="1"){

      for(int i=0;i<=59;i++){

        if(!alarmVar){
          alarmVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
        }

      }


      for(int i=60;i<=79;i++){
        
        if(!uyariVar){
          uyariVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
          
        }

      }

    }

    return AppBar(
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
          Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Stack(fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(flex: 2,
                          child: Container(
                          alignment: Alignment.topLeft,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.add_alert,
                                  size: constraint
                                      .biggest.height,
                                  color: alarmVar==false ? Colors.green[200] : Colors.red[500],
                                );
                              }),
                          ),
                        ),
                        Spacer(flex: 1,)
                      ],
                    ),
                      Column(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Container(
                          alignment: Alignment.bottomRight,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.warning,
                                  size: constraint
                                      .biggest.height,
                                  color: uyariVar==false ? Colors.green[200] : Colors.yellow[700],
                                );
                              }),
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlarmUyariDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
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
          Expanded(
              child: Builder(
            builder: (context) => RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              constraints: BoxConstraints(),
              child: Icon(
                Icons.router,
                size: 40 * oran,
                color: baglantiDurum=="" ? Colors.green[200] : Colors.red,
              ),
              onPressed: () {
                dbProkis.dbSatirEkleGuncelle(48, "1", "0", "0", "0");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BaglantiDurum(dbProkis.getDbVeri)),
                  );
              },
            ),
          )),
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
    );
  
  }


  Widget appBarSade(String dilSecimi, BuildContext context, double oran, String baslik, Color color, String baglantiDurum, String alarmDurum) {

    final dbProkis = Provider.of<DBProkis>(context);
    bool alarmVar=false;
    bool uyariVar=false;

    if (dbProkis.dbVeriGetir(48, 4, "0")=="1"){

    
      for(int i=0;i<=59;i++){

        if(!alarmVar){
          alarmVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
        }

      }


      for(int i=60;i<=79;i++){
        
        if(!uyariVar){
          uyariVar = alarmDurum.substring(i,i+1)=="1" ? true : false;
        }

        if(alarmDurum.substring(i,i+1)=="1" && dbProkis.dbVeriGetir(100+i, 2, "0")=="0"){
          String zaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(100+i, "1", "1", zaman, "0");
          
        }

      }

    }


    return PreferredSize(
      preferredSize: Size.fromHeight(30 * oran),
      child: AppBar(
        flexibleSpace: Container(
          color: color,
          child: Row(
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
              Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Stack(fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(flex: 2,
                          child: Container(
                          alignment: Alignment.topLeft,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.add_alert,
                                  size: constraint
                                      .biggest.height,
                                  color: alarmVar==false ? Colors.green[200] : Colors.red[500],
                                );
                              }),
                          ),
                        ),
                        Spacer(flex: 1,)
                      ],
                    ),
                      Column(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Container(
                          alignment: Alignment.bottomRight,
                            child: LayoutBuilder(builder:
                                  (context, constraint) {
                                return Icon(
                                  Icons.warning,
                                  size: constraint
                                      .biggest.height,
                                  color: uyariVar==false ? Colors.green[200] : Colors.yellow[700],
                                );
                              }),
                          ),
                        ),
                        
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  dbProkis.dbSatirEkleGuncelle(48, "1", "0", "0", "0");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlarmUyariDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
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
              Expanded(
                child: Builder(
              builder: (context) => RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(),
                child: Icon(
                  Icons.router,
                  size: 40 * oran,
                  color: baglantiDurum=="" ? Colors.green[200] : Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BaglantiDurum(dbProkis.getDbVeri)),
                  );
                },
              ),
            )),
              Expanded(
                  child: Builder(
                builder: (context) => RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  constraints: BoxConstraints(),
                  child: Icon(
                    Icons.info_outline,
                    size: 40 * oran,
                    color: Colors.white,
                  ),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              )),
          
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

  Future<String> veriGonder(String komut, int portNo) async {

    String _donusDegeri;
    
    
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
            // GET FROM SERVER ********************
            
            _donusDegeri =  new String.fromCharCodes(data).trim()+"*";
            _socket.close();

          }).catchError((error) {

            _donusDegeri="error*"+error.toString().trim();
            //_socket.close();
            
          });
      // ==============================================================

  return _donusDegeri;
} 

  Future<String> takipEt(String komut, int portNo) async {

    String _donusDegeri;

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
            _socket.close();
            
          }).catchError((error) {

            _donusDegeri="error*"+error.toString().trim();

          });
      // ==============================================================

  return _donusDegeri;
} 



  String errorToastMesaj(String mesaj, DBProkis dbProkis){

    bool alarmTimedOutDurum=false;
    bool alarmTimedOut=false;
    String alarmTimedOutZaman="";
    int alarmTimedOutSayac=0;
    String alarmTimedOutHataKodu="0";

    bool alarmConnectionFailedDurum=false;
    bool alarmConnectionFailed=false;
    String alarmConnectionFailedZaman="";
    int alarmConnectionFailedSayac=0;
    String alarmConnectionFailedHataKodu="0";

    bool alarmConnectionRefusedDurum=false;
    bool alarmConnectionRefused=false;
    String alarmConnectionRefusedZaman="";
    int alarmConnectionRefusedSayac=0;
    String alarmConnectionRefusedHataKodu="0";

    bool alarmBilinmeyenDurum=false;
    bool alarmBilinmeyen=false;
    String alarmBilinmeyenZaman="";
    int alarmBilinmeyenSayac=0;
    String alarmBilinmeyenHataKodu="0";

    bool alarmResetByPeerDurum=false;
    bool alarmResetByPeer=false;
    String alarmResetByPeerZaman="";
    int alarmResetByPeerSayac=0;
    String alarmResetByPeerHataKodu="0";

    String sonuc="";
    

    alarmTimedOutDurum=dbProkis.dbVeriGetir(40, 2, "0")=="1" ? true : false;
    alarmTimedOut=dbProkis.dbVeriGetir(39, 2, "0")=="1" ? true : false;
    alarmTimedOutZaman=dbProkis.dbVeriGetir(41, 2, "0");
    alarmTimedOutSayac=int.parse(dbProkis.dbVeriGetir(38, 2, "0"));
    alarmTimedOutHataKodu=dbProkis.dbVeriGetir(42, 2, "0");

    alarmConnectionFailedDurum=dbProkis.dbVeriGetir(40, 1, "0")=="1" ? true : false;
    alarmConnectionFailed=dbProkis.dbVeriGetir(39, 1, "0")=="1" ? true : false;
    alarmConnectionFailedZaman=dbProkis.dbVeriGetir(41, 1, "0");
    alarmConnectionFailedSayac=int.parse(dbProkis.dbVeriGetir(38, 1, "0"));
    alarmConnectionFailedHataKodu=dbProkis.dbVeriGetir(42, 1, "0");

    alarmConnectionRefusedDurum=dbProkis.dbVeriGetir(40, 3, "0")=="1" ? true : false;
    alarmConnectionRefused=dbProkis.dbVeriGetir(39, 3, "0")=="1" ? true : false;
    alarmConnectionRefusedZaman=dbProkis.dbVeriGetir(41, 3, "0");
    alarmConnectionRefusedSayac=int.parse(dbProkis.dbVeriGetir(38, 3, "0"));
    alarmConnectionRefusedHataKodu=dbProkis.dbVeriGetir(42, 3, "0");

    alarmBilinmeyenDurum=dbProkis.dbVeriGetir(40, 4, "0")=="1" ? true : false;
    alarmBilinmeyen=dbProkis.dbVeriGetir(39, 4, "0")=="1" ? true : false;
    alarmBilinmeyenZaman=dbProkis.dbVeriGetir(41, 4, "0");
    alarmBilinmeyenSayac=int.parse(dbProkis.dbVeriGetir(38, 4, "0"));
    alarmBilinmeyenHataKodu=dbProkis.dbVeriGetir(42, 4, "0");


    alarmResetByPeerDurum=dbProkis.dbVeriGetir(45, 1, "0")=="1" ? true : false;
    alarmResetByPeer=dbProkis.dbVeriGetir(44, 1, "0")=="1" ? true : false;
    alarmResetByPeerZaman=dbProkis.dbVeriGetir(46, 1, "0");
    alarmResetByPeerSayac=int.parse(dbProkis.dbVeriGetir(43, 1, "0"));
    alarmResetByPeerHataKodu=dbProkis.dbVeriGetir(47, 1, "0");

    if(mesaj==""){
      String x1=dbProkis.dbVeriGetir(39, 1, "0");
      String x2=dbProkis.dbVeriGetir(39, 2, "0");
      String x3=dbProkis.dbVeriGetir(39, 3, "0");
      String x4=dbProkis.dbVeriGetir(39, 4, "0");
      if(x1!="0" || x2!="0" || x3!="0" || x4!="0"){
        dbProkis.dbSatirEkleGuncelle(39, "0", "0", "0", "0");
      }

      String y1=dbProkis.dbVeriGetir(38, 1, "0");
      String y2=dbProkis.dbVeriGetir(38, 2, "0");
      String y3=dbProkis.dbVeriGetir(38, 3, "0");
      String y4=dbProkis.dbVeriGetir(38, 4, "0");
      if(y1!="0" || y2!="0" || y3!="0" || y4!="0"){
        dbProkis.dbSatirEkleGuncelle(38, "0", "0", "0", "0");
      }

      String z1=dbProkis.dbVeriGetir(44, 1, "0");
      String z2=dbProkis.dbVeriGetir(44, 2, "0");
      String z3=dbProkis.dbVeriGetir(44, 3, "0");
      String z4=dbProkis.dbVeriGetir(44, 4, "0");
      if(z1!="0" || z2!="0" || z3!="0" || z4!="0"){
        dbProkis.dbSatirEkleGuncelle(44, "0", "0", "0", "0");
      }

      String t1=dbProkis.dbVeriGetir(43, 1, "0");
      String t2=dbProkis.dbVeriGetir(43, 2, "0");
      String t3=dbProkis.dbVeriGetir(43, 3, "0");
      String t4=dbProkis.dbVeriGetir(43, 4, "0");
      if(t1!="0" || t2!="0" || t3!="0" || t4!="0"){
        dbProkis.dbSatirEkleGuncelle(43, "0", "0", "0", "0");
      }
      
      

      return "";

    }else{


        if(mesaj.contains("Connection timed out") && alarmTimedOut==false){
          alarmTimedOutDurum=true;
          alarmTimedOut=true;
          alarmTimedOutHataKodu=mesaj;
          dbProkis.dbSatirEkleGuncelle(39, alarmConnectionFailed ? "1" :"0", alarmTimedOut ? "1" :"0", alarmConnectionRefused ? "1" :"0", alarmBilinmeyen ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" :"0", alarmTimedOutDurum ? "1" :"0", alarmConnectionRefusedDurum ? "1" :"0", alarmBilinmeyenDurum ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(42, alarmConnectionFailedHataKodu, mesaj, alarmConnectionRefusedHataKodu, alarmBilinmeyenHataKodu);
        }else if(mesaj.contains("Connection failed") && alarmConnectionFailed==false){
          alarmConnectionFailedDurum=true;
          alarmConnectionFailed=true;
          alarmConnectionFailedHataKodu=mesaj;
          dbProkis.dbSatirEkleGuncelle(39, alarmConnectionFailed ? "1" :"0", alarmTimedOut ? "1" :"0", alarmConnectionRefused ? "1" :"0", alarmBilinmeyen ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" :"0", alarmTimedOutDurum ? "1" :"0", alarmConnectionRefusedDurum ? "1" :"0", alarmBilinmeyenDurum ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(42, mesaj, alarmTimedOutHataKodu , alarmConnectionRefusedHataKodu, alarmBilinmeyenHataKodu);
        }else if(mesaj.contains("Connection refused") && alarmConnectionRefused==false){
          alarmConnectionRefusedDurum=true;
          alarmConnectionRefused=true;
          alarmConnectionRefusedHataKodu=mesaj;
          dbProkis.dbSatirEkleGuncelle(39, alarmConnectionFailed ? "1" :"0", alarmTimedOut ? "1" :"0", alarmConnectionRefused ? "1" :"0", alarmBilinmeyen ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" :"0", alarmTimedOutDurum ? "1" :"0", alarmConnectionRefusedDurum ? "1" :"0", alarmBilinmeyenDurum ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(42, alarmConnectionFailedHataKodu, alarmTimedOutHataKodu , mesaj, alarmBilinmeyenHataKodu);
        }else if(mesaj.contains("Connection reset by peer") && alarmResetByPeer==false){
          alarmResetByPeerDurum=true;
          alarmResetByPeer=true;
          alarmResetByPeerHataKodu=mesaj;
          dbProkis.dbSatirEkleGuncelle(44, alarmResetByPeer ? "1" :"0", "0", "0", "0");
          dbProkis.dbSatirEkleGuncelle(45, alarmResetByPeerDurum ? "1" :"0", "0", "0", "0");
          dbProkis.dbSatirEkleGuncelle(47, mesaj, "0" , "0", "0");
        }else if(alarmBilinmeyen==false && !mesaj.contains("Connection refused") && !mesaj.contains("Connection failed") && !mesaj.contains("Connection timed out") && !mesaj.contains("Connection reset by peer")){
          alarmBilinmeyenDurum=true;
          alarmBilinmeyen=true;
          alarmBilinmeyenHataKodu=mesaj;
          dbProkis.dbSatirEkleGuncelle(39, alarmConnectionFailed ? "1" :"0", alarmTimedOut ? "1" :"0", alarmConnectionRefused ? "1" :"0", alarmBilinmeyen ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(40, alarmConnectionFailedDurum ? "1" :"0", alarmTimedOutDurum ? "1" :"0", alarmConnectionRefusedDurum ? "1" :"0", alarmBilinmeyenDurum ? "1" :"0");
          dbProkis.dbSatirEkleGuncelle(42, alarmConnectionFailedHataKodu, alarmTimedOutHataKodu , alarmConnectionRefusedHataKodu, mesaj);
        }


        if(alarmConnectionFailed && alarmConnectionFailedDurum && alarmConnectionFailedSayac==0){
          alarmConnectionFailedSayac++;
          dbProkis.dbSatirEkleGuncelle(38, alarmConnectionFailedSayac.toString(), alarmTimedOutSayac.toString(), alarmConnectionRefusedSayac.toString(), "0");
          alarmConnectionFailedZaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(41, alarmConnectionFailedZaman, alarmTimedOutZaman, alarmConnectionRefusedZaman, alarmBilinmeyenZaman);
        }

        if(alarmTimedOut && alarmTimedOutDurum && alarmTimedOutSayac==0){
          alarmTimedOutSayac++;
          dbProkis.dbSatirEkleGuncelle(38, alarmConnectionFailedSayac.toString(), alarmTimedOutSayac.toString(), alarmConnectionRefusedSayac.toString(), "0");
          alarmTimedOutZaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(41, alarmConnectionFailedZaman, alarmTimedOutZaman, alarmConnectionRefusedZaman, alarmBilinmeyenZaman);
        }

        if(alarmConnectionRefused && alarmConnectionRefusedDurum && alarmConnectionRefusedSayac==0){
          alarmConnectionRefusedSayac++;
          dbProkis.dbSatirEkleGuncelle(38, alarmConnectionFailedSayac.toString(), alarmTimedOutSayac.toString(), alarmConnectionRefusedSayac.toString(), "0");
          alarmConnectionRefusedZaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(41, alarmConnectionFailedZaman, alarmTimedOutZaman, alarmConnectionRefusedZaman, alarmBilinmeyenZaman);
        }

        if(alarmBilinmeyen && alarmBilinmeyenDurum && alarmBilinmeyenSayac==0){
          alarmBilinmeyenSayac++;
          dbProkis.dbSatirEkleGuncelle(38, alarmConnectionFailedSayac.toString(), alarmTimedOutSayac.toString(), alarmConnectionRefusedSayac.toString(), alarmBilinmeyenSayac.toString());
          alarmBilinmeyenZaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(41, alarmConnectionFailedZaman, alarmTimedOutZaman, alarmConnectionRefusedZaman, alarmBilinmeyenZaman);
        }

        if(alarmResetByPeer && alarmResetByPeerDurum && alarmResetByPeerSayac==0){
          alarmResetByPeerSayac++;
          dbProkis.dbSatirEkleGuncelle(43, alarmResetByPeerSayac.toString(), "0", "0", "0");
          alarmResetByPeerZaman=Metotlar().getSystemDate(dbProkis.getDbVeri)+" - "+Metotlar().getSystemTime(dbProkis.getDbVeri);
          dbProkis.dbSatirEkleGuncelle(46, alarmResetByPeerZaman, "0", "0", "0");
        }

        String v1=alarmConnectionFailedDurum ? "1" : "0";
        String v2=alarmConnectionFailed ? "1" : "0";
        String v3=alarmConnectionFailedZaman;
        String v4=alarmConnectionFailedHataKodu;
        String v5=alarmTimedOutDurum ? "1" : "0";
        String v6=alarmTimedOut ? "1" : "0";
        String v7=alarmTimedOutZaman;
        String v8=alarmTimedOutHataKodu;
        String v9=alarmConnectionRefusedDurum ? "1" : "0";
        String v10=alarmConnectionRefused ? "1" : "0";
        String v11=alarmConnectionRefusedZaman;
        String v12=alarmConnectionRefusedHataKodu;
        String v13=alarmBilinmeyenDurum ? "1" : "0";
        String v14=alarmBilinmeyen ? "1" : "0";
        String v15=alarmBilinmeyenZaman;
        String v16=alarmBilinmeyenHataKodu;
        String v17=alarmResetByPeerDurum ? "1" : "0";
        String v18=alarmResetByPeer ? "1" : "0";
        String v19=alarmResetByPeerZaman;
        String v20=alarmResetByPeerHataKodu;

        sonuc = v1+"*"+v2+"*"+v3+"*"+v4+"*"+v5+"*"+v6+"*"+v7+"*"+v8+"*"+v9+"*"+v10+"*"+v11+"*"+v12+"*"+v13+"*"+v14+"*"+v15+"*"+v16+"*"+v17+"*"+v18+"*"+v19+"*"+v20;
    }


    

    
    return sonuc;
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
    else if (deger == 48)
      sonuc = "I6.1";
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
    else if (deger == "I6.1")
      sonuc = 48;
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





