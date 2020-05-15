import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/sistem/kurulum/girisler.dart';
import 'package:prokis/sistem/kurulum/klepe_yontemi.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/fan_haritasi.dart';

import 'kurulumu_tamamla.dart';



class UzDebiNem extends StatelessWidget {
  bool ilkKurulumMu = true;
  UzDebiNem(this.ilkKurulumMu);
  String dilSecimi = "EN";


  final FocusNode _focusNodeAm = FocusNode();
  final FocusNode _focusNodeBm = FocusNode();
  final FocusNode _focusNodeCm = FocusNode();
  final FocusNode _focusNodeTfanDebi = FocusNode();
  final FocusNode _focusNodeBfanDebi = FocusNode();
  final FocusNode _focusNodeHacimOrani = FocusNode();

  int sayac = 0;

  @override
  Widget build(BuildContext context) {
    
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1,"TR");
    var oran = MediaQuery.of(context).size.width / 731.4;
    
    return ChangeNotifierProvider<UzDebiNemProvider>(
      create: (context) => UzDebiNemProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {

              final provider = Provider.of<UzDebiNemProvider>(context);

              TextEditingController tec1 = new TextEditingController(text: provider.getklepeNo==null ? "" : provider.getklepeNo);
              TextEditingController tec2 = new TextEditingController(text: provider.getxM==null ? "" : provider.getxM);
              TextEditingController tec3 = new TextEditingController(text: provider.getyM==null ? "" : provider.getyM);
              TextEditingController tec4 = new TextEditingController(text: provider.getaM==null ? "" : provider.getaM);
              TextEditingController tec5 = new TextEditingController(text: provider.getbM==null ? "" : provider.getbM);
              TextEditingController tec6 = new TextEditingController(text: provider.getcM==null ? "" : provider.getcM);
              TextEditingController tec7 = new TextEditingController(text: provider.gettunelFanDebi==null ? "" : provider.gettunelFanDebi);
              TextEditingController tec8 = new TextEditingController(text: provider.getbacaFanDebi==null ? "" : provider.getbacaFanDebi);
              TextEditingController tec9 = new TextEditingController(text: provider.gethacimOrani==null ? "" : provider.gethacimOrani);

              _textFieldCursorPosition(tec1, provider.getklepeNo==null ? "" : provider.getklepeNo);
              _textFieldCursorPosition(tec2, provider.getxM==null ? "" : provider.getxM);
              _textFieldCursorPosition(tec3, provider.getyM==null ? "" : provider.getyM);
              _textFieldCursorPosition(tec4, provider.getaM==null ? "" : provider.getaM);
              _textFieldCursorPosition(tec5, provider.getbM==null ? "" : provider.getbM);
              _textFieldCursorPosition(tec6, provider.getcM==null ? "" : provider.getcM);
              _textFieldCursorPosition(tec7, provider.gettunelFanDebi==null ? "" : provider.gettunelFanDebi);
              _textFieldCursorPosition(tec8, provider.getbacaFanDebi==null ? "" : provider.getbacaFanDebi);
              _textFieldCursorPosition(tec9, provider.gethacimOrani==null ? "" : provider.gethacimOrani);


              _focusNodeAm.addListener(() {

                if (!_focusNodeAm.hasFocus && sayac==0) {
                  print("içerde sayac: $sayac");

                  String v1=provider.getaM=="" ? "0" : provider.getaM;
                  String v2=provider.getbM=="" ? "0" : provider.getbM;
                  String v3=provider.getcM=="" ? "0" : provider.getcM;
                  String komut="10*16*"+v1+"*"+v2+"*"+v3;
                  if(provider.getaM!=""){
                    Metotlar().veriGonder(komut, 2233).then((value) {
                      if(value.split("*")[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(12, v1, v2, v3, "0");
                      }
                    });
                    sayac++;
                  }
                  
                }
                print("dışarıda sayac: $sayac");

                

              });

              _focusNodeBm.addListener(() {

                if (!_focusNodeBm.hasFocus && sayac==0) {

                  String v1=provider.getaM=="" ? "0" : provider.getaM;
                  String v2=provider.getbM=="" ? "0" : provider.getbM;
                  String v3=provider.getcM=="" ? "0" : provider.getcM;
                  String komut="10*16*"+v1+"*"+v2+"*"+v3;
                  if(provider.getbM!=""){
                    Metotlar().veriGonder(komut, 2233).then((value) {
                      if(value.split("*")[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(12, v1, v2, v3, "0");
                      }
                    });
                    sayac++;
                  }
                }
                

              });

              _focusNodeCm.addListener(() {

                if (!_focusNodeCm.hasFocus && sayac==0) {

                  String v1=provider.getaM=="" ? "0" : provider.getaM;
                  String v2=provider.getbM=="" ? "0" : provider.getbM;
                  String v3=provider.getcM=="" ? "0" : provider.getcM;
                  String komut="10*16*"+v1+"*"+v2+"*"+v3;
                  if(provider.getcM!=""){
                    Metotlar().veriGonder(komut, 2233).then((value) {
                      if(value.split("*")[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(12, v1, v2, v3, "0");
                      }
                    });
                    sayac++;
                  }
                }
                

              });

              _focusNodeTfanDebi.addListener(() {

                if (!_focusNodeTfanDebi.hasFocus && sayac==0) {
                  String v1=provider.tunelFanDebi=="" ? "0" : provider.tunelFanDebi;
                  String v2=provider.bacaFanDebi=="" ? "0" : provider.bacaFanDebi;
                  String v3=provider.hacimOrani=="" ? "0" : provider.hacimOrani;
                  String v4=provider.disNem == true ? "1" : "0";
                  String komut="11*18*"+v1+"*"+v2+"*"+v3+"*"+v4;
                  if(provider.gettunelFanDebi!=""){
                    Metotlar().veriGonder(komut, 2233).then((value) {
                      if(value.split("*")[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(13, v1, v2, v3, v4);
                      }
                    });
                    sayac++;
                  }
                }
                

              });

              _focusNodeBfanDebi.addListener(() {

                if (!_focusNodeBfanDebi.hasFocus && sayac==0) {

                  String v1=provider.tunelFanDebi=="" ? "0" : provider.tunelFanDebi;
                  String v2=provider.bacaFanDebi=="" ? "0" : provider.bacaFanDebi;
                  String v3=provider.hacimOrani=="" ? "0" : provider.hacimOrani;
                  String v4=provider.disNem == true ? "1" : "0";
                  String komut="11*18*"+v1+"*"+v2+"*"+v3+"*"+v4;
                  if(provider.getbacaFanDebi!=""){
                    Metotlar().veriGonder(komut, 2233).then((value) {
                      if(value.split("*")[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(13, v1, v2, v3, v4);
                      }
                    });
                    sayac++;
                  }
                }
                

              });

              _focusNodeHacimOrani.addListener(() {

                if (!_focusNodeHacimOrani.hasFocus && sayac==0) {

                  String v1=provider.tunelFanDebi=="" ? "0" : provider.tunelFanDebi;
                  String v2=provider.bacaFanDebi=="" ? "0" : provider.bacaFanDebi;
                  String v3=provider.hacimOrani=="" ? "0" : provider.hacimOrani;
                  String v4=provider.disNem == true ? "1" : "0";
                  String komut="11*18*"+v1+"*"+v2+"*"+v3+"*"+v4;
                  if(provider.gethacimOrani!=""){
                    Metotlar().veriGonder(komut, 2233).then((value) {
                      if(value.split("*")[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                      }else{
                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                        dbProkis.dbSatirEkleGuncelle(13, v1, v2, v3, v4);
                      }
                    });
                    sayac++;
                  }
                }
                

              });

              return Scaffold(
                  floatingActionButton: MyFloatingActionBackButton(
                  !ilkKurulumMu,
                  false,
                  oran,
                  40,
                  Colors.white,
                  Colors.grey[700],
                  Icons.arrow_back,
                  1,
                  "tv564"),
    
            body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Başlık Bölümü
                  Expanded(
                      child: Container(
                    color: Colors.grey[600],
                    child: Text(
                      Dil().sec(dilSecimi, "tv29"),
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                      textScaleFactor: oran,
                    ),
                    alignment: Alignment.center,
                  )),
                  // Ayarlar Bölümü
                  Expanded(
                    flex: 3, //4~/oran,
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          //Kümes Bina Uzunlukları bölümü
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //A(m) , B(m) , C(m) girdileri bölümü
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //A(m)
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        focusNode: _focusNodeAm,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec4,
                                        onTap: () {
                                                sayac = 0;
                                              },
                                        onChanged: (String metin) {
                                          provider.setaM = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeAm.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: "A(m)"),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //B(m)
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        focusNode: _focusNodeBm,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec5,
                                        onTap: () {
                                                sayac = 0;
                                              },
                                        onChanged: (String metin) {
                                          provider.setbM = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeBm.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: "B(m)"),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //C(m)
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        focusNode: _focusNodeCm,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec6,
                                        
                                        onTap: () {
                                                sayac = 0;
                                              },
                                        onChanged: (String metin) {
                                          provider.setcM = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeCm.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: "C(m)"),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                //Tünel Fan Debi ve Baca Fan Debi Bölümü
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Tunel Fan Debi
                                    Expanded(
                                      flex: 6,
                                      child: TextField(
                                        focusNode: _focusNodeTfanDebi,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600],
                                            fontSize: 20 * oran),
                                        textAlign: TextAlign.center,
                                        controller: tec7,
                                        onTap: () {
                                                sayac = 0;
                                              },
                                        onChanged: (String metin) {
                                          provider.settunelFanDebi = metin;
                                        },
                                        onSubmitted: (String metin) {
                                          _focusNodeTfanDebi.unfocus();
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                            helperText: Dil()
                                                .sec(
                                                    dilSecimi, "tfhp1"),
                                            helperStyle: TextStyle(
                                                fontSize: 14 * oran,
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.blue[800]),
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15 * oran,
                                                fontWeight: FontWeight.bold),
                                            labelText: Dil()
                                                .sec(
                                                    dilSecimi, "tflb1")),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Baca Fan Debi
                                    Expanded(
                                      flex: 6,
                                      child: Visibility(
                                        visible: provider.getbacaFanAdet > 0 ? true : false,
                                        child: TextField(
                                          focusNode: _focusNodeBfanDebi,
                                          style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              color: Colors.grey[600],
                                              fontSize: 20 * oran),
                                          textAlign: TextAlign.center,
                                          controller: tec8,
                                          onTap: () {
                                                sayac = 0;
                                              },
                                          onChanged: (String metin) {
                                            provider.setbacaFanDebi = metin;
                                          },
                                          onSubmitted: (String metin) {
                                            _focusNodeBfanDebi.unfocus();
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              helperText: Dil()
                                                  .sec(
                                                      dilSecimi, "tfhp1"),
                                              helperStyle: TextStyle(
                                                  fontSize: 14 * oran,
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.blue[800]),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 15 * oran,
                                                  fontWeight: FontWeight.bold),
                                              labelText: Dil()
                                                  .sec(
                                                      dilSecimi, "tflb2")),
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                //Hacim oranı ve Dış Nm Bölümü
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Hacim Yüzdesi
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 10 * oran),
                                        child: TextField(
                                          focusNode: _focusNodeHacimOrani,
                                          style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              color: Colors.grey[600],
                                              fontSize: 20 * oran),
                                          textAlign: TextAlign.center,
                                          controller: tec9,
                                          onTap: () {
                                                sayac = 0;
                                              },
                                          onChanged: (String metin) {
                                            provider.sethacimOrani = metin;
                                          },
                                          onSubmitted: (String metin) {
                                            _focusNodeHacimOrani.unfocus();
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16 * oran,
                                                  fontWeight: FontWeight.bold),
                                              labelText: Dil()
                                                  .sec(
                                                      dilSecimi, "tflb3")),
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Dış nem Aktif-Pasif Seçimi
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              Dil().sec(
                                                  dilSecimi, "tv30"),
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              textScaleFactor: oran,
                                            ),
                                            RawMaterialButton(
                                              onPressed: () {
                                                if (provider.getdisNem) {
                                                  provider.setdisNem = false;
                                                } else {
                                                  provider.setdisNem = true;
                                                }
                                                String v1=provider.tunelFanDebi=="" ? "0" : provider.tunelFanDebi;
                                                String v2=provider.bacaFanDebi=="" ? "0" : provider.bacaFanDebi;
                                                String v3=provider.hacimOrani=="" ? "0" : provider.hacimOrani;
                                                String v4=provider.disNem == true ? "1" : "0";
                                                String komut="11*18*"+v1+"*"+v2+"*"+v3+"*"+v4;

                                                Metotlar().veriGonder(komut, 2233).then((value) {
                                                  if(value.split("*")[0]=="error"){
                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                  }else{
                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                    dbProkis.dbSatirEkleGuncelle(13, v1, v2, v3, v4);
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                provider.getdisNem == true
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: provider.getdisNem == true
                                                    ? Colors.green[600]
                                                    : Colors.black,
                                                size: 25 * oran,
                                              ),
                                              padding: EdgeInsets.all(0),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              constraints: BoxConstraints(),
                                            )
                                          ],
                                        )),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Referans bina resmi bölümü
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          'assets/images/kumes_bina_uzunluk_icon.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              
                            ],
                          )),
                          //Klepe uzunluk girişi
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              //Klepe Uzunluk girişi(KlepeNO, x(m), Y(m))
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //Klepe No

                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600],
                                          fontSize: 20 * oran),
                                      textAlign: TextAlign.center,
                                      maxLength: 2,
                                      controller: tec1,
                                      onSubmitted: (String metin) {
                                        provider.setklepeNo = metin;
                                      },
                                      onChanged: (String metin) {
                                        provider.setklepeNo = metin;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16 * oran,
                                              fontWeight: FontWeight.bold),
                                          counterStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily: 'Kelly Slab',
                                              fontSize: 12 * oran),
                                          labelText: "Klepe No"),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //X(m)
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600],
                                          fontSize: 20 * oran),
                                      textAlign: TextAlign.center,
                                      maxLength: 4,
                                      controller: tec2,
                                      onSubmitted: (String metin) {
                                        provider.setxM = metin;
                                      },
                                      onChanged: (String metin) {
                                        provider.setxM = metin;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16 * oran,
                                              fontWeight: FontWeight.bold),
                                          counterStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily: 'Kelly Slab',
                                              fontSize: 12 * oran),
                                          labelText: "X(m)"),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //Y(m)
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.grey[600],
                                          fontSize: 20 * oran),
                                      textAlign: TextAlign.center,
                                      maxLength: 5,
                                      controller: tec3,
                                      onSubmitted: (String metin) {
                                        provider.setyM = metin;
                                      },
                                      onChanged: (String metin) {
                                        provider.setyM = metin;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16 * oran,
                                              fontWeight: FontWeight.bold),
                                          labelText: "Y(m)"),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ),
                              //Atama Onay Butonu
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: SizedBox(
                                      height: 40 * oran,
                                      child: RaisedButton(
                                        color: Colors.blue[800],
                                        elevation: 16,
                                        onPressed: () {
                                          print(provider.getklepeNo);
                                          double x;
                                          double y;
                                          bool formatHata = false;
                                          int klpNo;

                                          try {
                                            klpNo = int.parse(provider.getklepeNo);
                                          } catch (e) {
                                            formatHata = true;
                                          }

                                          try {
                                            x = double.parse(provider.getxM);
                                          } catch (e) {
                                            formatHata = true;
                                          }

                                          try {
                                            y = double.parse(provider.getyM);
                                          } catch (e) {
                                            formatHata = true;
                                          }

                                          if (provider.getxM != null &&
                                              provider.getyM != null &&
                                              provider.getklepeNo != null &&
                                              provider.getklepeNo != "" &&
                                              provider.getxM != "" &&
                                              provider.getyM != "") {
                                            if (!formatHata && x > 0 && y > 0) {

                                              if (klpNo <= provider.getklepeAdet) {

                                                if (klpNo == 1) {
                                                  provider.setk1x = provider.getxM;
                                                  provider.setk1y = provider.getyM;
                                                }

                                                if (klpNo == 2) {
                                                  provider.setk2x = provider.getxM;
                                                  provider.setk2y = provider.getyM;
                                                }

                                                if (klpNo == 3) {
                                                  provider.setk3x = provider.getxM;
                                                  provider.setk3y = provider.getyM;
                                                }

                                                if (klpNo == 4) {
                                                  provider.setk4x = provider.getxM;
                                                  provider.setk4y = provider.getyM;
                                                }

                                                if (klpNo == 5) {
                                                  provider.setk5x = provider.getxM;
                                                  provider.setk5y = provider.getyM;
                                                }

                                                if (klpNo == 6) {
                                                  provider.setk6x = provider.getxM;
                                                  provider.setk6y = provider.getyM;
                                                }

                                                if (klpNo == 7) {
                                                  provider.setk7x = provider.getxM;
                                                  provider.setk7y = provider.getyM;
                                                }

                                                if (klpNo == 8) {
                                                  provider.setk8x = provider.getxM;
                                                  provider.setk8y = provider.getyM;
                                                }

                                                if (klpNo == 9) {
                                                  provider.setk9x = provider.getxM;
                                                  provider.setk9y = provider.getyM;
                                                }

                                                if (klpNo == 10) {
                                                  provider.setk10x = provider.getxM;
                                                  provider.setk10y = provider.getyM;
                                                }

                                                Toast.show(
                                                    Dil()
                                                        .sec(
                                                            dilSecimi,
                                                            "toast8"),
                                                    context,
                                                    duration: 2);

                                                if (klpNo < 5) {
                                                  String v1x=provider.getk1x;
                                                  String v2x=provider.getk2x;
                                                  String v3x=provider.getk3x;
                                                  String v4x=provider.getk4x;
                                                  String v1y=provider.getk1y;
                                                  String v2y=provider.getk2y;
                                                  String v3y=provider.getk3y;
                                                  String v4y=provider.getk4y;
                                                  String komut="7*11"+"*"+v1x+"#"+v1y+"*"+v2x+"#"+v2y+"*"+v3x+"#"+v3y+"*"+v4x+"#"+v4y;

                                                  Metotlar().veriGonder(komut, 2233).then((value) {
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                      dbProkis.dbSatirEkleGuncelle(9, v1x+"*"+v1y, v2x+"*"+v2y, v3x+"*"+v3y, v4x+"*"+v4y);
                                                    }
                                                  });
                                                  
                                                } else if (klpNo < 9) {

                                                  String v1x=provider.getk5x;
                                                  String v2x=provider.getk6x;
                                                  String v3x=provider.getk7x;
                                                  String v4x=provider.getk8x;
                                                  String v1y=provider.getk5y;
                                                  String v2y=provider.getk6y;
                                                  String v3y=provider.getk7y;
                                                  String v4y=provider.getk8y;
                                                  String komut="8*13"+"*"+v1x+"#"+v1y+"*"+v2x+"#"+v2y+"*"+v3x+"#"+v3y+"*"+v4x+"#"+v4y;

                                                  Metotlar().veriGonder(komut, 2233).then((value) {
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                      dbProkis.dbSatirEkleGuncelle(10, v1x+"*"+v1y, v2x+"*"+v2y, v3x+"*"+v3y, v4x+"*"+v4y);
                                                    }
                                                  });

                                                  
                                                } else if (klpNo < 11) {

                                                  String v1x=provider.getk9x;
                                                  String v2x=provider.getk10x;
                                                  String v1y=provider.getk9y;
                                                  String v2y=provider.getk10y;
                                                  String komut="9*15"+"*"+v1x+"#"+v1y+"*"+v2x+"#"+v2y;

                                                  Metotlar().veriGonder(komut, 2233).then((value) {
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                      dbProkis.dbSatirEkleGuncelle(11, v1x+"*"+v1y, v2x+"*"+v2y, "0", "0");
                                                    }
                                                  });
                                                }
                                              
                                              } else {
                                                Toast.show(
                                                    Dil()
                                                        .sec(
                                                            dilSecimi,
                                                            "toast5"),
                                                    context,
                                                    duration: 3);
                                              }
                                            } else {
                                              Toast.show(
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "toast7"),
                                                  context,
                                                  duration: 3);
                                            }
                                          } else {
                                            Toast.show(
                                                Dil().sec(
                                                    dilSecimi, "toast6"),
                                                context,
                                                duration: 3);
                                          }

                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 50 * oran,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ),
                              //Atanan klepelerin gösterildiği bölüm
                              Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: provider.getklepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 0 ? true : false,
                                              child: Text(
                                                "K1: X=${provider.getk1x} , Y=${provider.getk1y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk1x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 5 ? true : false,
                                              child: Text(
                                                "K6: X=${provider.getk6x} , Y=${provider.getk6y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk6x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: provider.getklepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 1 ? true : false,
                                              child: Text(
                                                "K2: X=${provider.getk2x} , Y=${provider.getk2y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk2x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 6 ? true : false,
                                              child: Text(
                                                "K7: X=${provider.getk7x} , Y=${provider.getk7y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk7x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: provider.getklepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 2 ? true : false,
                                              child: Text(
                                                "K3: X=${provider.getk3x} , Y=${provider.getk3y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk3x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 7 ? true : false,
                                              child: Text(
                                                "K8: X=${provider.getk8x} , Y=${provider.getk8y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk8x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: provider.getklepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 3 ? true : false,
                                              child: Text(
                                                "K4: X=${provider.getk4x} , Y=${provider.getk4y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk4x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 8 ? true : false,
                                              child: Text(
                                                "K9: X=${provider.getk9x} , Y=${provider.getk9y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk9x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: provider.getklepeAdet < 6
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 4 ? true : false,
                                              child: Text(
                                                "K5: X=${provider.getk5x} , Y=${provider.getk5y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk5x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  provider.getklepeAdet > 9 ? true : false,
                                              child: Text(
                                                "K10: X=${provider.getk10x} , Y=${provider.getk10y}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.getk10x != "0.0"
                                                      ? Colors.blue[800]
                                                      : Colors.grey[600],
                                                ),
                                                textScaleFactor: oran,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  // Sayfa geçiş okları bölümü
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 15 * oran),
                      color: Colors.grey[600],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Spacer(
                            flex: 20,
                          ),
                          Expanded(
                              //geri OK
                              flex: 2,
                              child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
                                                              child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  iconSize: 50 * oran,
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Girisler(true)),
                                    );

                                    //Navigator.pop(context);
                                  },
                                  color: Colors.black,
                                ),
                              )),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                              //İleri OK
                              flex: 2,
                              child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
                                                              child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  iconSize: 50 * oran,
                                  onPressed: () {
                                    bool klepeTamam = true;
                                    bool aBos = false;
                                    bool bBos = false;
                                    bool cBos = false;
                                    bool tfdBos = false;
                                    bool bfdBos = false;
                                    bool hoBos = false;
                                    bool aTanimsiz = false;
                                    bool bTanimsiz = false;
                                    bool cTanimsiz = false;
                                    bool tfdTanimsiz = false;
                                    bool bfdTanimsiz = false;
                                    bool hoTanimsiz = false;
                                    double a;
                                    double b;
                                    double c;
                                    double tf;
                                    double bf;
                                    double ho;

                                    try {
                                      a = double.parse(provider.getaM);
                                    } catch (e) {
                                      aTanimsiz = true;
                                    }

                                    try {
                                      b = double.parse(provider.getbM);
                                    } catch (e) {
                                      bTanimsiz = true;
                                    }

                                    try {
                                      c = double.parse(provider.getcM);
                                    } catch (e) {
                                      cTanimsiz = true;
                                    }

                                    try {
                                      tf = double.parse(provider.gettunelFanDebi);
                                    } catch (e) {
                                      tfdTanimsiz = true;
                                    }

                                    try {
                                      bf = double.parse(provider.getbacaFanDebi);
                                    } catch (e) {
                                      if (provider.getbacaFanAdet > 0) {
                                        bfdTanimsiz = true;
                                      }
                                    }

                                    try {
                                      ho = double.parse(provider.gethacimOrani);
                                    } catch (e) {
                                      hoTanimsiz = true;
                                    }

                                    if (provider.getaM == "" || provider.getaM == null) {
                                      aBos = true;
                                    }

                                    if (provider.getbM == "" || provider.getbM == null) {
                                      bBos = true;
                                    }

                                    if (provider.getcM == "" || provider.getcM == null) {
                                      cBos = true;
                                    }

                                    if (provider.gettunelFanDebi == "" ||
                                        provider.gettunelFanDebi == null) {
                                      tfdBos = true;
                                    }

                                    if (provider.getbacaFanDebi == "" ||
                                        provider.getbacaFanDebi == null) {
                                      if (provider.getbacaFanAdet > 0) {
                                        bfdBos = true;
                                      }
                                    }

                                    if (provider.gethacimOrani == "" || provider.gethacimOrani == null) {
                                      hoBos = true;
                                    }

                                    if (provider.getklepeAdet > 0 && provider.getk1x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 1 && provider.getk2x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 2 && provider.getk3x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 3 && provider.getk4x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 4 && provider.getk5x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 5 && provider.getk6x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 6 && provider.getk7x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 7 && provider.getk8x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 8 && provider.getk9x == "0.0") {
                                      klepeTamam = false;
                                    } else if (provider.getklepeAdet > 9 && provider.getk10x == "0.0") {
                                      klepeTamam = false;
                                    }

                                    if (!klepeTamam) {
                                      Toast.show(
                                          Dil()
                                              .sec(dilSecimi, "toast9"),
                                          context,
                                          duration: 3);
                                    } else if (aBos || bBos || cBos) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast10"),
                                          context,
                                          duration: 3);
                                    } else if (tfdBos || bfdBos) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast11"),
                                          context,
                                          duration: 3);
                                    } else if (hoBos) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast12"),
                                          context,
                                          duration: 3);
                                    } else if (aTanimsiz ||
                                        bTanimsiz ||
                                        cTanimsiz) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast13"),
                                          context,
                                          duration: 3);
                                    } else if (tfdTanimsiz || bfdTanimsiz) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast14"),
                                          context,
                                          duration: 3);
                                    } else if (hoTanimsiz) {
                                      Toast.show(
                                          Dil().sec(
                                              dilSecimi, "toast15"),
                                          context,
                                          duration: 3);
                                    } else {

                                      Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      KurulumuTamamla(dbProkis.getDbVeri),
                                                      fullscreenDialog: true
                                                      
                                                      ));

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
              ),
            ),
          ),
        ));
      
      
            },
          )
    );
  }

  _textFieldCursorPosition(TextEditingController tec, String str) {
    tec
      ..text = str
      ..selection =
          TextSelection.collapsed(offset: str.length != null ? str.length : 0);
  }

}


class UzDebiNemProvider with ChangeNotifier {
  bool disNem;
  int klepeAdet;
  int bacaFanAdet;
  String klepeNo;
  String xM="";
  String yM="";
  String aM;
  String bM;
  String cM;
  String tunelFanDebi;
  String bacaFanDebi;
  String hacimOrani;
  String k1x;
  String k2x;
  String k3x;
  String k4x;
  String k5x;
  String k6x;
  String k7x;
  String k8x;
  String k9x;
  String k10x;
  String k1y;
  String k2y;
  String k3y;
  String k4y;
  String k5y;
  String k6y;
  String k7y;
  String k8y;
  String k9y;
  String k10y;

 bool get getdisNem => disNem;

 set setdisNem(bool disNem)  {
   this.disNem = disNem;
   notifyListeners();
  }

 int get getklepeAdet => klepeAdet;

 set setklepeAdet(int klepeAdet)  {
   this.klepeAdet = klepeAdet;
   notifyListeners();
  }

 int get getbacaFanAdet => bacaFanAdet;

 set setbacaFanAdet(int bacaFanAdet)  {
   this.bacaFanAdet = bacaFanAdet;
   notifyListeners();
  }

 String get getklepeNo => klepeNo;

 set setklepeNo(String klepeNo)  {
   this.klepeNo = klepeNo;
   notifyListeners();
  }

 String get getxM => xM;

 set setxM(String xM)  {
   this.xM = xM;
   notifyListeners();
  }

 String get getyM => yM;

 set setyM(String yM)  {
   this.yM = yM;
   notifyListeners();
  }

 String get getaM => aM;

 set setaM(String aM)  {
   this.aM = aM;
   notifyListeners();
  }

 String get getbM => bM;

 set setbM(String bM)  {
   this.bM = bM;
   notifyListeners();
  }

 String get getcM => cM;

 set setcM(String cM)  {
   this.cM = cM;
   notifyListeners();
  }

 String get gettunelFanDebi => tunelFanDebi;

 set settunelFanDebi(String tunelFanDebi)  {
   this.tunelFanDebi = tunelFanDebi;
   notifyListeners();
  }

 String get getbacaFanDebi => bacaFanDebi;

 set setbacaFanDebi(String bacaFanDebi)  {
   this.bacaFanDebi = bacaFanDebi;
   notifyListeners();
  }

 String get gethacimOrani => hacimOrani;

 set sethacimOrani(String hacimOrani)  {
   this.hacimOrani = hacimOrani;
   notifyListeners();
  }

 String get getk1x => k1x;

 set setk1x(String k1x)  {
   this.k1x = k1x;
   notifyListeners();
  }

 String get getk2x => k2x;

 set setk2x(String k2x)  {
   this.k2x = k2x;
   notifyListeners();
  }

 String get getk3x => k3x;

 set setk3x(String k3x)  {
   this.k3x = k3x;
   notifyListeners();
  }

 String get getk4x => k4x;

 set setk4x(String k4x)  {
   this.k4x = k4x;
   notifyListeners();
  }

 String get getk5x => k5x;

 set setk5x(String k5x)  {
   this.k5x = k5x;
   notifyListeners();
  }

 String get getk6x => k6x;

 set setk6x(String k6x)  {
   this.k6x = k6x;
   notifyListeners();
  }

 String get getk7x => k7x;

 set setk7x(String k7x)  {
   this.k7x = k7x;
   notifyListeners();
  }

 String get getk8x => k8x;

 set setk8x(String k8x)  {
   this.k8x = k8x;
   notifyListeners();
  }

 String get getk9x => k9x;

 set setk9x(String k9x)  {
   this.k9x = k9x;
   notifyListeners();
  }

 String get getk10x => k10x;

 set setk10x(String k10x)  {
   this.k10x = k10x;
   notifyListeners();
  }

 String get getk1y => k1y;

 set setk1y(String k1y)  {
   this.k1y = k1y;
   notifyListeners();
  }

 String get getk2y => k2y;

 set setk2y(String k2y)  {
   this.k2y = k2y;
   notifyListeners();
  }

 String get getk3y => k3y;

 set setk3y(String k3y)  {
   this.k3y = k3y;
   notifyListeners();
  }

 String get getk4y => k4y;

 set setk4y(String k4y)  {
   this.k4y = k4y;
   notifyListeners();
  }

 String get getk5y => k5y;

 set setk5y(String k5y)  {
   this.k5y = k5y;
   notifyListeners();
  }

 String get getk6y => k6y;

 set setk6y(String k6y)  {
   this.k6y = k6y;
   notifyListeners();
  }

 String get getk7y => k7y;

 set setk7y(String k7y)  {
   this.k7y = k7y;
   notifyListeners();
  }

 String get getk8y => k8y;

 set setk8y(String k8y)  {
   this.k8y = k8y;
   notifyListeners();
  }

 String get getk9y => k9y;

 set setk9y(String k9y)  {
   this.k9y = k9y;
   notifyListeners();
  }

 String get getk10y => k10y;

 set setk10y(String k10y)  {
   this.k10y = k10y;
   notifyListeners();
  }


  BuildContext context;
  DBProkis dbProkis;

  UzDebiNemProvider(this.context, this.dbProkis) {

    klepeAdet=int.parse(dbProkis.dbVeriGetir(37, 1, "1"));
    var xx=dbProkis.dbVeriGetir(5, 1, "0#0").split("#"); 
    bacaFanAdet = int.parse(xx[0]);

    var data1 = dbProkis.dbVeriGetir(9, 1, "0.0").split("*");
    k1x = data1[0];
    data1.length > 1 ? k1y = data1[1] : k1y = "0.0";
    var data2 = dbProkis.dbVeriGetir(9, 2, "0.0").split("*");
    k2x = data2[0];
    data2.length > 1 ? k2y = data2[1] : k2y = "0.0";
    var data3 = dbProkis.dbVeriGetir(9, 3, "0.0").split("*");
    k3x = data3[0];
    data3.length > 1 ? k3y = data3[1] : k3y = "0.0";
    var data4 = dbProkis.dbVeriGetir(9, 4, "0.0").split("*");
    k4x = data4[0];
    data4.length > 1 ? k4y = data4[1] : k4y = "0.0";

    var data11 = dbProkis.dbVeriGetir(10, 1, "0.0").split("*");
    k5x = data11[0];
    data11.length > 1 ? k5y = data11[1] : k5y = "00.0";
    var data22 = dbProkis.dbVeriGetir(10, 2, "0.0").split("*");
    k6x = data22[0];
    data22.length > 1 ? k6y = data22[1] : k6y = "0.0";
    var data33 = dbProkis.dbVeriGetir(10, 3, "0.0").split("*");
    k7x = data33[0];
    data33.length > 1 ? k7y = data33[1] : k7y = "0.0";
    var data44 =dbProkis.dbVeriGetir(10, 4, "0.0").split("*");
    k8x = data44[0];
    data44.length > 1 ? k8y = data44[1] : k8y = "0.0";

    var data51 = dbProkis.dbVeriGetir(11, 1, "0.0").split("*");
    k9x = data51[0];
    data51.length > 1 ? k9y = data51[1] : k9y = "0.0";
    var data52 = dbProkis.dbVeriGetir(11, 2, "0.0").split("*");
    k10x = data52[0];
    data52.length > 1 ? k10y = data52[1] : k10y = "0.0";
    
    aM = dbProkis.dbVeriGetir(12, 1, "0");
    bM = dbProkis.dbVeriGetir(12, 2, "0");
    cM = dbProkis.dbVeriGetir(12, 3, "0");

    tunelFanDebi = dbProkis.dbVeriGetir(13, 1, "0");
    bacaFanDebi = dbProkis.dbVeriGetir(13, 2, "0");
    hacimOrani = dbProkis.dbVeriGetir(13, 3, "0");
    disNem=dbProkis.dbVeriGetir(13, 4, "0")=="1" ? true : false;
  
  }
}
