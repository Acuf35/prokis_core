import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_1x2.dart';
import 'package:prokis/yardimci/deger_giris_6x0.dart';
import 'package:prokis/languages/select.dart';

class SuruBilgisi extends StatefulWidget {
  List<Map> gelenDBveri;
  SuruBilgisi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SuruBilgisiState(gelenDBveri);
  }
}

class SuruBilgisiState extends State<SuruBilgisi> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String kumesTuru = "1";
  List<Map> dbVeriler;

  DateTime suruDogumTarihi = DateTime(2020, 1, 1);
  DateTime suruGirisTarihi = DateTime(2020, 1, 1);
  String suruGirisSayisi = "70000";
  String toplamOluSayisi = "0";
  String olum1hastalikNedeniyleOluSayisi = "0";
  String olum2ekipmanDeformasyonuKaynakliOluSayisi = "0";
  String olum3digerHayvanSaldirilariKaynakliOluSayisi = "0";
  String olum4havalandirmaKaynakliOluSayisi = "0";
  String olum5yemKaynakliOluSayisi = "0";
  String olum6suKaynakliOluSayisi = "0";
  String olumOrani = "1.35";
  String guncelHayvanSayisi = "120000";
  String suruYasiGunluk = "140";
  String suruYasiHaftalik = "20.0";

  int _yuzBinler = 0;
  int _onBinler = 0;
  int _binler = 0;
  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _ondalikOnlar = 0;
  int _ondalikBirler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  

  String gunluk_1_7 = "0.16";
  String gunluk_8_14 = "0.42";
  String gunluk_15_21 = "0.59";
  String gunluk_22_28 = "0.84";
  String gunluk_29_35 = "0.93";
  String gunluk_36_42 = "1.18";
  String gunluk_43_49 = "1.35";
  String gunluk_50veSonrasi = "1.52";

  String haftalik_7_20 = "0.16";
  String haftalik_21_52 = "0.42";
  String haftalik_53veSonrasi = "0.59";

  String baglantiDurum="";
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SuruBilgisiState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 3) {
        kumesTuru = dbVeri[i]["veri1"];
        kumesTuru = "2";
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

@override
  void dispose() {
    timerCancel=true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {

      Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;


          Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){

            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }

        });


        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv414',baglantiDurum, alarmDurum),
        body: Column(
          children: <Widget>[
            //Saat ve Tarih
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.grey[300],
                    padding: EdgeInsets.only(left: 10 * oran),
                    child: TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      return Text(
                        Metotlar().getSystemTime(dbVeriler),
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontFamily: 'Kelly Slab',
                            fontSize: 12 * oran,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.grey[300],
                    padding: EdgeInsets.only(right: 10 * oran),
                    child: TimerBuilder.periodic(Duration(seconds: 1),
                        builder: (context) {
                      return Text(
                        Metotlar().getSystemDate(dbVeriler),
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontFamily: 'Kelly Slab',
                            fontSize: 12 * oran,
                            fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 10 * oran,
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              //Sürü Doğum Tarihi
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv415"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 50.0,
                                                fontFamily: 'Kelly Slab',
                                              ),
                                              maxLines: 2,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.cyan[700],
                                        padding: EdgeInsets.all(5 * oran),
                                        child: RawMaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(
                                                    DateTime.now().year - 1,
                                                    1,
                                                    1),
                                                maxTime: DateTime(
                                                    DateTime.now().year + 1,
                                                    12,
                                                    31),
                                                theme: DatePickerTheme(
                                                    headerColor:
                                                        Colors.orange[700],
                                                    backgroundColor:
                                                        Colors.white,
                                                    itemStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontSize: 18 * oran),
                                                    doneStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14 * oran,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    cancelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14 * oran,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onChanged: (date) {

                                            }, onConfirm: (date) {
                                              
                                              _index=8;
                                              if (date.compareTo(DateTime.now())<=0){
                                                suruDogumTarihi = date;
                                                String gun=date.day.toString();
                                                String ayy=date.month.toString();
                                                String yil=date.year.toString();
                                                
                                                yazmaSonrasiGecikmeSayaci = 0;
                                                String komut='16*$_index*$gun*$ayy*$yil';
                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                  if(value.split("*")[0]=="error"){
                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                  }else{
                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                    
                                                    baglanti = false;
                                                    Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
                                                        if(veri.split("*")[0]=="error"){
                                                          baglanti=false;
                                                          baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                                          setState(() {});
                                                        }else{
                                                          takipEtVeriIsleme(veri);
                                                          baglantiDurum="";
                                                        }
                                                    });
                                                  }
                                                });



                                              }else{
                                                Toast.show(Dil().sec(dilSecimi, "toas77"), context,duration: 3);
                                              }


                                              setState(() {});
                                            },
                                                //currentTime: DateTime.now(),
                                                currentTime: suruDogumTarihi,
                                                locale: LocaleType.tr);
                                          },
                                          fillColor: Colors.cyan[900],
                                          elevation: 16,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Container(width: 120*oran,alignment: Alignment.center,
                                                child: Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(suruDogumTarihi),
                                                  style: TextStyle(
                                                      fontSize: 20 * oran,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //Sürü Giriş Tarihi
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv416"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 50.0,
                                                fontFamily: 'Kelly Slab',
                                              ),
                                              maxLines: 2,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.cyan[700],
                                        padding: EdgeInsets.all(5 * oran),
                                        child: RawMaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(
                                                    DateTime.now().year - 1,
                                                    1,
                                                    1),
                                                maxTime: DateTime(
                                                    DateTime.now().year + 1,
                                                    12,
                                                    31),
                                                theme: DatePickerTheme(
                                                    headerColor:
                                                        Colors.orange[700],
                                                    backgroundColor:
                                                        Colors.white,
                                                    itemStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontSize: 18 * oran),
                                                    doneStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14 * oran,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    cancelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14 * oran,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onChanged: (date) {
                                              
                                            }, onConfirm: (date) {
                                              _index=9;
                                              if (date.compareTo(DateTime.now())<=0){
                                                suruGirisTarihi = date;
                                                String gun=date.day.toString();
                                                String ayy=date.month.toString();
                                                String yil=date.year.toString();
                                                
                                                yazmaSonrasiGecikmeSayaci = 0;
                                                String komut='16*$_index*$gun*$ayy*$yil';
                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                  if(value.split("*")[0]=="error"){
                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                  }else{
                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                    
                                                    baglanti = false;
                                                    Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
                                                        if(veri.split("*")[0]=="error"){
                                                          baglanti=false;
                                                          baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                                          setState(() {});
                                                        }else{
                                                          takipEtVeriIsleme(veri);
                                                          baglantiDurum="";
                                                        }
                                                    });
                                                  }
                                                });



                                              }else{
                                                Toast.show(Dil().sec(dilSecimi, "toas77"), context,duration: 3);
                                              }
                                              setState(() {});
                                            },
                                                //currentTime: DateTime.now(),
                                                currentTime: suruGirisTarihi,
                                                locale: LocaleType.tr);
                                          },
                                          fillColor: Colors.cyan[900],
                                          elevation: 16,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Container(width: 120*oran,alignment: Alignment.center,
                                                child: Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(suruGirisTarihi),
                                                  style: TextStyle(
                                                      fontSize: 20 * oran,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //Hayvan Sayısı (Girişte)
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv417"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 50.0,
                                                fontFamily: 'Kelly Slab',
                                              ),
                                              maxLines: 2,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.cyan[700],
                                        padding: EdgeInsets.all(5 * oran),
                                        child: RawMaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            int sayi =
                                                int.parse(suruGirisSayisi);
                                            _yuzBinler = sayi < 100000
                                                ? 0
                                                : (sayi ~/ 100000).toInt();
                                            _onBinler = sayi < 10000
                                                ? 0
                                                : ((sayi % 100000) ~/ 10000)
                                                    .toInt();
                                            _binler = sayi < 1000
                                                ? 0
                                                : ((sayi % 10000) ~/ 1000)
                                                    .toInt();
                                            _yuzler = sayi < 100
                                                ? 0
                                                : ((sayi % 1000) ~/ 100)
                                                    .toInt();
                                            _onlar = sayi < 10
                                                ? 0
                                                : ((sayi % 100) ~/ 10).toInt();
                                            _birler = sayi % 10;
                                            _index = 1;

                                            _degergiris6X0(
                                                _yuzBinler,
                                                _onBinler,
                                                _binler,
                                                _yuzler,
                                                _onlar,
                                                _birler,
                                                _index,
                                                oran,
                                                dilSecimi,
                                                "tv417",
                                                "");
                                          },
                                          fillColor: Colors.cyan[900],
                                          elevation: 16,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10 * oran,
                                                    left: 10 * oran),
                                                child: Container(width: 100*oran,alignment: Alignment.center,
                                                  child: Text(
                                                    suruGirisSayisi,
                                                    style: TextStyle(
                                                        fontSize: 20 * oran,
                                                        fontFamily: 'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              //Ölü Hayvan Sayısı
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv418"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 50.0,
                                                fontFamily: 'Kelly Slab',
                                              ),
                                              maxLines: 2,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.cyan[700],
                                        padding: EdgeInsets.all(5 * oran),
                                        child: RawMaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                          onPressed: () {

                                            showModalBottomSheet<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (context, state) {
                                                      return Container(
                                                        color: Colors.orange,
                                                        height: double.infinity,
                                                        child: Column(
                                                          children: <Widget>[
                                                            //Başlık bölümü
                                                            Expanded(
                                                              flex: 1,
                                                              child: Center(
                                                                  child: Text(
                                                                Dil().sec(
                                                                    dilSecimi,
                                                                    "tv419"),
                                                                textScaleFactor:
                                                                    oran,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Kelly Slab',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                            ),
                                                            //Klasik Klepe Yönteminin parametre giriş  bölümü
                                                            Expanded(
                                                              flex: 10,
                                                              child: Container(
                                                                color: Colors
                                                                    .white,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  Dil().sec(dilSecimi, "tv420"),
                                                                                  style: TextStyle(fontFamily: "Kelly Slab"),
                                                                                  textScaleFactor: oran,
                                                                                ),
                                                                                RaisedButton(
                                                                                  elevation: 16,
                                                                                  onPressed: () {
                                                                                    int sayi = int.parse(olum1hastalikNedeniyleOluSayisi);
                                                                                    _yuzBinler = sayi < 100000 ? 0 : (sayi ~/ 100000).toInt();
                                                                                    _onBinler = sayi < 10000 ? 0 : ((sayi % 100000) ~/ 10000).toInt();
                                                                                    _binler = sayi < 1000 ? 0 : ((sayi % 10000) ~/ 1000).toInt();
                                                                                    _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                                                                                    _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                                                                                    _birler = sayi % 10;
                                                                                    _index = 2;

                                                                                    _degergiris6X0(_yuzBinler, _onBinler, _binler, _yuzler, _onlar, _birler, _index, oran, dilSecimi, "tv399", "").then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                                  },
                                                                                  color: Colors.blue[700],
                                                                                  child: Container(width: 100*oran,alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      olum1hastalikNedeniyleOluSayisi,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kelly Slab', fontSize: 25, color: Colors.white),
                                                                                      textScaleFactor: oran,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  Dil().sec(dilSecimi, "tv421"),
                                                                                  style: TextStyle(fontFamily: "Kelly Slab"),
                                                                                  textScaleFactor: oran,
                                                                                ),
                                                                                RaisedButton(
                                                                                  elevation: 16,
                                                                                  onPressed: () {
                                                                                    int sayi = int.parse(olum2ekipmanDeformasyonuKaynakliOluSayisi);
                                                                                    _yuzBinler = sayi < 100000 ? 0 : (sayi ~/ 100000).toInt();
                                                                                    _onBinler = sayi < 10000 ? 0 : ((sayi % 100000) ~/ 10000).toInt();
                                                                                    _binler = sayi < 1000 ? 0 : ((sayi % 10000) ~/ 1000).toInt();
                                                                                    _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                                                                                    _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                                                                                    _birler = sayi % 10;
                                                                                    _index = 3;

                                                                                    _degergiris6X0(_yuzBinler, _onBinler, _binler, _yuzler, _onlar, _birler, _index, oran, dilSecimi, "tv399", "").then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                                  },
                                                                                  color: Colors.blue[700],
                                                                                  child: Container(width: 100*oran,alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      olum2ekipmanDeformasyonuKaynakliOluSayisi,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kelly Slab', fontSize: 25, color: Colors.white),
                                                                                      textScaleFactor: oran,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  Dil().sec(dilSecimi, "tv422"),
                                                                                  style: TextStyle(fontFamily: "Kelly Slab"),
                                                                                  textScaleFactor: oran,
                                                                                ),
                                                                                RaisedButton(
                                                                                  elevation: 16,
                                                                                  onPressed: () {
                                                                                    int sayi = int.parse(olum3digerHayvanSaldirilariKaynakliOluSayisi);
                                                                                    _yuzBinler = sayi < 100000 ? 0 : (sayi ~/ 100000).toInt();
                                                                                    _onBinler = sayi < 10000 ? 0 : ((sayi % 100000) ~/ 10000).toInt();
                                                                                    _binler = sayi < 1000 ? 0 : ((sayi % 10000) ~/ 1000).toInt();
                                                                                    _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                                                                                    _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                                                                                    _birler = sayi % 10;
                                                                                    _index = 4;

                                                                                    _degergiris6X0(_yuzBinler, _onBinler, _binler, _yuzler, _onlar, _birler, _index, oran, dilSecimi, "tv399", "").then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                                  },
                                                                                  color: Colors.blue[700],
                                                                                  child: Container(width: 100*oran,alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      olum3digerHayvanSaldirilariKaynakliOluSayisi,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kelly Slab', fontSize: 25, color: Colors.white),
                                                                                      textScaleFactor: oran,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  Dil().sec(dilSecimi, "tv423"),
                                                                                  style: TextStyle(fontFamily: "Kelly Slab"),
                                                                                  textScaleFactor: oran,
                                                                                ),
                                                                                RaisedButton(
                                                                                  elevation: 16,
                                                                                  onPressed: () {
                                                                                    int sayi = int.parse(olum4havalandirmaKaynakliOluSayisi);
                                                                                    _yuzBinler = sayi < 100000 ? 0 : (sayi ~/ 100000).toInt();
                                                                                    _onBinler = sayi < 10000 ? 0 : ((sayi % 100000) ~/ 10000).toInt();
                                                                                    _binler = sayi < 1000 ? 0 : ((sayi % 10000) ~/ 1000).toInt();
                                                                                    _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                                                                                    _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                                                                                    _birler = sayi % 10;
                                                                                    _index = 5;

                                                                                    _degergiris6X0(_yuzBinler, _onBinler, _binler, _yuzler, _onlar, _birler, _index, oran, dilSecimi, "tv399", "").then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                                  },
                                                                                  color: Colors.blue[700],
                                                                                  child: Container(width: 100*oran,alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      olum4havalandirmaKaynakliOluSayisi,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kelly Slab', fontSize: 25, color: Colors.white),
                                                                                      textScaleFactor: oran,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  Dil().sec(dilSecimi, "tv424"),
                                                                                  style: TextStyle(fontFamily: "Kelly Slab"),
                                                                                  textScaleFactor: oran,
                                                                                ),
                                                                                RaisedButton(
                                                                                  elevation: 16,
                                                                                  onPressed: () {
                                                                                    int sayi = int.parse(olum5yemKaynakliOluSayisi);
                                                                                    _yuzBinler = sayi < 100000 ? 0 : (sayi ~/ 100000).toInt();
                                                                                    _onBinler = sayi < 10000 ? 0 : ((sayi % 100000) ~/ 10000).toInt();
                                                                                    _binler = sayi < 1000 ? 0 : ((sayi % 10000) ~/ 1000).toInt();
                                                                                    _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                                                                                    _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                                                                                    _birler = sayi % 10;
                                                                                    _index = 6;

                                                                                    _degergiris6X0(_yuzBinler, _onBinler, _binler, _yuzler, _onlar, _birler, _index, oran, dilSecimi, "tv399", "").then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                                  },
                                                                                  color: Colors.blue[700],
                                                                                  child: Container(width: 100*oran,alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      olum5yemKaynakliOluSayisi,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kelly Slab', fontSize: 25, color: Colors.white),
                                                                                      textScaleFactor: oran,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  Dil().sec(dilSecimi, "tv425"),
                                                                                  style: TextStyle(fontFamily: "Kelly Slab"),
                                                                                  textScaleFactor: oran,
                                                                                ),
                                                                                RaisedButton(
                                                                                  elevation: 16,
                                                                                  onPressed: () {
                                                                                    int sayi = int.parse(olum6suKaynakliOluSayisi);
                                                                                    _yuzBinler = sayi < 100000 ? 0 : (sayi ~/ 100000).toInt();
                                                                                    _onBinler = sayi < 10000 ? 0 : ((sayi % 100000) ~/ 10000).toInt();
                                                                                    _binler = sayi < 1000 ? 0 : ((sayi % 10000) ~/ 1000).toInt();
                                                                                    _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                                                                                    _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                                                                                    _birler = sayi % 10;
                                                                                    _index = 7;

                                                                                    _degergiris6X0(_yuzBinler, _onBinler, _binler, _yuzler, _onlar, _birler, _index, oran, dilSecimi, "tv399", "").then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                                  },
                                                                                  color: Colors.blue[700],
                                                                                  child: Container(width: 100*oran,alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      olum6suKaynakliOluSayisi,
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kelly Slab', fontSize: 25, color: Colors.white),
                                                                                      textScaleFactor: oran,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          fillColor: Colors.cyan[900],
                                          elevation: 16,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10 * oran,
                                                    left: 10 * oran),
                                                child: Container(width: 100*oran,alignment: Alignment.center,
                                                  child: Text(
                                                    toplamOluSayisi,
                                                    style: TextStyle(
                                                        fontSize: 20 * oran,
                                                        fontFamily: 'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv426"),
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600]),
                                      textScaleFactor: oran, textAlign:TextAlign.center,
                                    ),
                                    Text(
                                      olumOrani,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.blue[200]),
                                      textScaleFactor: oran,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv427"),
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600]),
                                      textScaleFactor: oran,textAlign:TextAlign.center,
                                    ),
                                    Text(
                                      guncelHayvanSayisi,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.blue[200]),
                                      textScaleFactor: oran,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv428"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600]),
                                      textScaleFactor: oran,
                                    ),
                                    Text(
                                      suruYasiGunluk,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.blue[200]),
                                      textScaleFactor: oran,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv429"),
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600]),
                                      textScaleFactor: oran,textAlign:TextAlign.center,
                                    ),
                                    Text(
                                      suruYasiHaftalik,
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.blue[200]),
                                      textScaleFactor: oran,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1 * oran,
                    color: Colors.black,
                  ),
                  _minHavDefaultUnsur(kumesTuru, oran),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: Container(
          width: 56 * oran,
          height: 56 * oran,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GenelAyarlar(dbVeriler)),
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.arrow_back,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
        endDrawer: SizedBox(
        width: 320 * oran,
        child: Drawer(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      Dil().sec(dilSecimi, "tv414"), 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Kelly Slab',
                      ),
                      textScaleFactor: oran,
                    ),
                    color: Colors.yellow[700],
                  ),
                ),
                Expanded(
                  flex: 17,
                  child: Container(
                    color: Colors.yellow[100],
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          dense: false,
                          title: Text(
                            Dil().sec(dilSecimi, "tv186"),
                            textScaleFactor: oran,
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                //Giriş metni
                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info20"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv674")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info20a"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv675")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info20b"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv279")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info20c"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    
        
        );
  
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

  Future _degergiris6X0(
      int yuzBinlerUnsur,
      int onBinlerUnsur,
      int binlerUnsur,
      int yuzlerUnsur,
      int onlarUnsur,
      int birlerUnsur,
      int indexNo,
      double oran,
      String dil,
      String baslik,
      String onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris6X0.Deger(
            yuzBinlerUnsur,
            onBinlerUnsur,
            binlerUnsur,
            yuzlerUnsur,
            onlarUnsur,
            birlerUnsur,
            indexNo,
            oran,
            dil,
            baslik,
            onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_yuzBinler != val[0] ||
          _onBinler != val[1] ||
          _binler != val[2] ||
          _yuzler != val[3] ||
          _onlar != val[4] ||
          _birler != val[5]) {
        veriGonderilsinMi = false;
      }

      _yuzBinler = val[0];
      _onBinler = val[1];
      _binler = val[2];
      _yuzler = val[3];
      _onlar = val[4];
      _birler = val[5];
      _index = val[6];

      String veri="";

      if (_index == 1) {
        suruGirisSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();

            veri=suruGirisSayisi;
      }


      if (_index == 2) {
        olum1hastalikNedeniyleOluSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();
            veri=olum1hastalikNedeniyleOluSayisi;
      }

      if (_index == 3) {
        olum2ekipmanDeformasyonuKaynakliOluSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();
            veri=olum2ekipmanDeformasyonuKaynakliOluSayisi;
      }

      if (_index == 4) {
        olum3digerHayvanSaldirilariKaynakliOluSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();
            veri=olum3digerHayvanSaldirilariKaynakliOluSayisi;
      }

      if (_index == 5) {
        olum4havalandirmaKaynakliOluSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();
            veri=olum4havalandirmaKaynakliOluSayisi;
      }

      if (_index == 6) {
        olum5yemKaynakliOluSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();
            veri=olum5yemKaynakliOluSayisi;
      }

      if (_index == 7) {
        olum6suKaynakliOluSayisi = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();
            veri=olum6suKaynakliOluSayisi;
      }



      yazmaSonrasiGecikmeSayaci = 0;
      String komut='16*$_index*$veri';
      Metotlar().veriGonder(komut, 2235).then((value){
        if(value.split("*")[0]=="error"){
          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
        }else{
          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
          
          baglanti = false;
          Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
              if(veri.split("*")[0]=="error"){
                baglanti=false;
                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                setState(() {});
              }else{
                takipEtVeriIsleme(veri);
                baglantiDurum="";
              }
          });
        }
      });


      setState(() {});
    });
  }

  
  Future _degergiris1X2(
      int birler,
      int ondalikOnlar,
      int ondalikBirler,
      int index,
      double oran,
      String dil,
      String baslik,
      String onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris1X2.Deger(birler, ondalikOnlar, ondalikBirler, index,
            oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_birler != val[0] ||
          _ondalikOnlar != val[1] ||
          _ondalikBirler != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }

      _birler = val[0];
      _ondalikOnlar = val[1];
      _ondalikBirler = val[2];
      _index = val[3];

      if (index == 10) {
        gunluk_1_7 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri1 = gunluk_1_7;

      if (index == 11) {
        gunluk_8_14 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri2 = gunluk_8_14;

      if (index == 12) {
        gunluk_15_21 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri3 = gunluk_15_21;

      if (index == 13) {
        gunluk_22_28 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri4 = gunluk_22_28;

      if (index == 14) {
        gunluk_29_35 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri5 = gunluk_29_35;

      if (index == 15) {
        gunluk_36_42 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri6 = gunluk_36_42;

      if (index == 16) {
        gunluk_43_49 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri7 = gunluk_43_49;

      if (index == 17) {
        gunluk_50veSonrasi = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri8 = gunluk_50veSonrasi;

      if (index == 18) {
        haftalik_7_20 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri9 = haftalik_7_20;

      if (index == 19) {
        haftalik_21_52 = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri10 = haftalik_21_52;

      if (index == 20) {
        haftalik_53veSonrasi = _birler.toString() +
            "." +
            _ondalikOnlar.toString() +
            _ondalikBirler.toString();
      }
      String veri11 = haftalik_53veSonrasi;

      String veriX = "$veri1*$veri2*$veri3*$veri4*$veri5*$veri6*$veri7*$veri8";
      String veriY = "$veri9*$veri10*$veri11";

      String veri = kumesTuru == '1' ? veriY : veriX;

      if (veriGonderilsinMi) {

      yazmaSonrasiGecikmeSayaci = 0;
      String komut="16*$_index*$kumesTuru*$veri";
      Metotlar().veriGonder(komut, 2235).then((value){
        if(value.split("*")[0]=="error"){
          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
        }else{
          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
          
          baglanti = false;
          Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
              if(veri.split("*")[0]=="error"){
                baglanti=false;
                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                setState(() {});
              }else{
                takipEtVeriIsleme(veri);
                baglantiDurum="";
              }
          });
        }
      });


      }
    });
  }

  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('*');
    print(degerler);
    print(yazmaSonrasiGecikmeSayaci);

    suruGirisSayisi=degerler[0];
    olum1hastalikNedeniyleOluSayisi=degerler[1];
    olum2ekipmanDeformasyonuKaynakliOluSayisi=degerler[2];
    olum3digerHayvanSaldirilariKaynakliOluSayisi=degerler[3];
    olum4havalandirmaKaynakliOluSayisi=degerler[4];
    olum5yemKaynakliOluSayisi=degerler[5];
    olum6suKaynakliOluSayisi=degerler[6];
              
    suruDogumTarihi=DateTime(int.parse(degerler[9]),int.parse(degerler[8]), int.parse(degerler[7]));
    suruGirisTarihi=DateTime(int.parse(degerler[12]),int.parse(degerler[11]), int.parse(degerler[10]));

    guncelHayvanSayisi=degerler[13];
    suruYasiGunluk=degerler[14];
    suruYasiHaftalik=degerler[15];
    olumOrani=degerler[16];
    


              

    if (kumesTuru == '1') {
      haftalik_7_20 = degerler[17];
      haftalik_21_52 = degerler[18];
      haftalik_53veSonrasi = degerler[19];
      alarmDurum=degerler[20];
    } else {
      gunluk_1_7 = degerler[17];
      gunluk_8_14 = degerler[18];
      gunluk_15_21 = degerler[19];
      gunluk_22_28 = degerler[20];
      gunluk_29_35 = degerler[21];
      gunluk_36_42 = degerler[22];
      gunluk_43_49 = degerler[23];
      gunluk_50veSonrasi = degerler[24];
      alarmDurum=degerler[25];
    }


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 
  Widget _minHavDefaultUnsur(String kTuru, double oran) {
    Widget widget;

    if (kTuru == "1") {
      widget = Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 3 * oran),
                child: Text(
                  Dil().sec(dilSecimi, "tv279"),
                  textScaleFactor: oran,
                  style:
                      TextStyle(fontFamily: 'Kelly Slab', color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3 * oran, top: 3 * oran),
                child: Container(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv290"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 18;

                                  _birler =
                                      int.parse(haftalik_7_20.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(haftalik_7_20.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(haftalik_7_20.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv290",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      haftalik_7_20,
                                      style: TextStyle(
                                          fontSize: 25 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv291"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 19;

                                  _birler =
                                      int.parse(haftalik_21_52.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(haftalik_21_52.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(haftalik_21_52.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv291",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      haftalik_21_52,
                                      style: TextStyle(
                                          fontSize: 25 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv292"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 20;

                                  _birler = int.parse(
                                          haftalik_53veSonrasi.split(".")[0]) %
                                      10;
                                  _ondalikOnlar = int.parse(
                                          haftalik_53veSonrasi.split(".")[1]) ~/
                                      10;
                                  _ondalikBirler = int.parse(
                                          haftalik_53veSonrasi.split(".")[1]) %
                                      10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv292",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      haftalik_53veSonrasi,
                                      style: TextStyle(
                                          fontSize: 25 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    Expanded(
                      flex: 8,
                      child: RaisedButton(
                        onPressed: () {

                          yazmaSonrasiGecikmeSayaci = 0;
                          String komut="16*21*$kumesTuru*0.95*1.10*1.20";
                          Metotlar().veriGonder(komut, 2235).then((value){
                            if(value.split("*")[0]=="error"){
                              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                              
                              baglanti = false;
                              Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
                                  if(veri.split("*")[0]=="error"){
                                    baglanti=false;
                                    baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                    setState(() {});
                                  }else{
                                    takipEtVeriIsleme(veri);
                                    baglantiDurum="";
                                  }
                              });
                            }
                          });


                        },
                        child: Text(
                          Dil().sec(dilSecimi, "tv288"),
                          textScaleFactor: oran,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.cyan,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    )
                  ],
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ));
    } else {
      widget = Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 3 * oran),
                child: Text(
                  Dil().sec(dilSecimi, "tv279"),
                  textScaleFactor: oran,
                  style:
                      TextStyle(fontFamily: 'Kelly Slab', color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3 * oran, top: 3 * oran),
                child: Container(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv280"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 10;

                                  _birler =
                                      int.parse(gunluk_1_7.split(".")[0]) % 10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_1_7.split(".")[1]) ~/ 10;
                                  _ondalikBirler =
                                      int.parse(gunluk_1_7.split(".")[1]) % 10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv280",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_1_7,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv281"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 11;

                                  _birler =
                                      int.parse(gunluk_8_14.split(".")[0]) % 10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_8_14.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(gunluk_8_14.split(".")[1]) % 10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv281",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_8_14,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv282"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 12;

                                  _birler =
                                      int.parse(gunluk_15_21.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_15_21.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(gunluk_15_21.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv282",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_15_21,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3 * oran, top: 3 * oran),
                child: Container(height: 1),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv283"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 13;

                                  _birler =
                                      int.parse(gunluk_22_28.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_22_28.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(gunluk_22_28.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv283",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_22_28,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv284"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 14;

                                  _birler =
                                      int.parse(gunluk_29_35.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_29_35.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(gunluk_29_35.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv284",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_29_35,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv285"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 15;

                                  _birler =
                                      int.parse(gunluk_36_42.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_36_42.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(gunluk_36_42.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv285",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_36_42,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3 * oran, top: 3 * oran),
                child: Container(height: 1),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv286"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 16;

                                  _birler =
                                      int.parse(gunluk_43_49.split(".")[0]) %
                                          10;
                                  _ondalikOnlar =
                                      int.parse(gunluk_43_49.split(".")[1]) ~/
                                          10;
                                  _ondalikBirler =
                                      int.parse(gunluk_43_49.split(".")[1]) %
                                          10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv286",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_43_49,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv287"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _index = 17;

                                  _birler = int.parse(
                                          gunluk_50veSonrasi.split(".")[0]) %
                                      10;
                                  _ondalikOnlar = int.parse(
                                          gunluk_50veSonrasi.split(".")[1]) ~/
                                      10;
                                  _ondalikBirler = int.parse(
                                          gunluk_50veSonrasi.split(".")[1]) %
                                      10;

                                  _degergiris1X2(
                                      _birler,
                                      _ondalikOnlar,
                                      _ondalikBirler,
                                      _index,
                                      oran,
                                      dilSecimi,
                                      "tv287",
                                      "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraint) {
                                      return Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: Colors.blue[700],
                                      );
                                    }),
                                    Text(
                                      gunluk_50veSonrasi,
                                      style: TextStyle(
                                          fontSize: 20 * oran,
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Expanded(
                      flex: 8,
                      child: RaisedButton(
                        onPressed: () {
                          yazmaSonrasiGecikmeSayaci = 0;
                          String komut="16*21*$kumesTuru*0.16*0.42*0.59*0.84*0.93*1.18*1.35*1.52";
                          Metotlar().veriGonder(komut, 2235).then((value){
                            if(value.split("*")[0]=="error"){
                              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                              
                              baglanti = false;
                              Metotlar().takipEt('15*$kumesTuru', 2236).then((veri){
                                  if(veri.split("*")[0]=="error"){
                                    baglanti=false;
                                    baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                    setState(() {});
                                  }else{
                                    takipEtVeriIsleme(veri);
                                    baglantiDurum="";
                                  }
                              });
                            }
                          });
                        },
                        child: Text(
                          Dil().sec(dilSecimi, "tv288"),
                          textScaleFactor: oran,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.cyan,
                      ),
                    ),
                    Spacer(
                      flex: 4,
                    )
                  ],
                ),
              ),
            ],
          ));
    }

    return widget;
  }

Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  //--------------------------METOTLAR--------------------------------

}
