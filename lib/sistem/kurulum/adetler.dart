import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sabitVeriler.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'fan_yontemi.dart';
import 'temel_ayarlar.dart';

class Adetler extends StatefulWidget {
  bool ilkKurulumMu = true;
  Adetler(this.ilkKurulumMu);

  @override
  _AdetlerState createState() => _AdetlerState();
}

class _AdetlerState extends State<Adetler> {
  
  String dilSecimi = "EN";

  String fanAdet = "1";
  String klepeAdet = "1";
  String pedAdet = "1";
  String isiSensAdet = "1";
  String bacafanVarMi = "0";
  String sirkfanVarMi = "0";
  String airinletVarMi = "0";
  String isiticiAdet = "0";
  String siloAdet = "0";
  bool wifiOlcum = false;
  bool wifiOlcumGecici = false;
  bool analogOlcum = true;
  bool isiSensorOlcumTuruSecildi = false;

  double oran=1.0;



  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);

    final _blocSinif = AdetlerBloC(dbProkis);

    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    fanAdet =dbProkis.dbVeriGetir(4, 1, "1");
    klepeAdet = dbProkis.dbVeriGetir(4, 2, "1");
    pedAdet = dbProkis.dbVeriGetir(4, 3, "1");
    var xx = dbProkis.dbVeriGetir(4, 4, "7#1").split("#");
    isiSensAdet = xx[0];
    if (xx.length > 1) {
      wifiOlcum = xx[1]=="1" ? true : false;
      wifiOlcumGecici = xx[1]=="1" ? true : false;
      analogOlcum = xx[1]=="2" ? true : false;
    }
    var yy = dbProkis.dbVeriGetir(5, 1, "0#0").split("#");
    bacafanVarMi = yy[0];
    sirkfanVarMi = yy[1];
    airinletVarMi = dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet = dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet = dbProkis.dbVeriGetir(5, 4, "0");

    oran = MediaQuery.of(context).size.width / 731.4;

    return StreamBuilder(
      initialData: _blocSinif.blokVeriGetir(),
      stream: _blocSinif.bloCVeri,
      builder: (context, snapshot) {

        print(snapshot.data);


        fanAdet =snapshot.data["fanAdet"];
        klepeAdet = snapshot.data["klepeAdet"];
        pedAdet = snapshot.data["pedAdet"];
        isiSensAdet = snapshot.data["isiSensAdet"];
        wifiOlcum = snapshot.data["wifiOlcum"]=="1" ? true : false;
        wifiOlcumGecici = snapshot.data["wifiOlcumGecici"]=="1" ? true : false;
        analogOlcum = snapshot.data["analogOlcum"]=="2" ? true : false;
        bacafanVarMi=snapshot.data["bacafanVarMi"];
        sirkfanVarMi=snapshot.data["sirkfanVarMi"];
        airinletVarMi = snapshot.data["airinletVarMi"];
        isiticiAdet = snapshot.data["isiticiAdet"];
        siloAdet = snapshot.data["siloAdet"];



        return Scaffold(
            floatingActionButton: MyFloatingActionBackButton(
                !widget.ilkKurulumMu,
                false,
                oran,
                40,
                Colors.white,
                Colors.grey[700],
                Icons.arrow_back,
                1,
                "tv564"),
            body: Column(
              children: <Widget>[
                //Başlık Bölümü
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
                        child: Row(
                          children: <Widget>[
                            Spacer(flex: 3,),
                            Expanded(flex: 10,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv11"),
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
                            Spacer(flex: 2,),
                            Expanded(
                              child: LayoutBuilder(
                                  builder: (context, constraint) {
                                  return IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon:Icon(Icons.info_outline,),
                                  iconSize: constraint.biggest.height,
                                  color: Colors.white,
                                  onPressed: ()=>Scaffold.of(context).openEndDrawer(),
                                  );
                                }
                              ),
                            ),
                   
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      
          
                    ],
                  ),
                  alignment: Alignment.center,
                )),

                //Kontrol elemanları bölümü
                Expanded(
                  flex: 3,
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          //Fan Sayısı ve Klepe Sayısı Bölümü
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //Fan Sayısı
                                _unsurAdetWidget(
                                    Dil().sec(dilSecimi, "tv12"),
                                    'assets/images/kurulum_fan_icon.png',
                                    fanAdet,
                                    SabitVeriler().adet1den60a,
                                    1,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                                
                                //Klepe Sayısı
                                _unsurAdetWidget(
                                    Dil().sec(dilSecimi, "tv13"),
                                    'assets/images/kurulum_klepe_icon.png',
                                    klepeAdet,
                                    SabitVeriler().adet1den10a,
                                    2,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                              ],
                            ),
                          ),
                          //Ped pompa Sayisi ve ısı sensor sayısı bölümü
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //Ped Pompa
                                _unsurAdetWidget(
                                    Dil().sec(dilSecimi, "tv14"),
                                    'assets/images/kurulum_ped_icon.png',
                                    pedAdet,
                                    SabitVeriler().adet1den10a,
                                    3,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                                //Isı Sensör
                                _unsurAdetWidgetIsiSens(
                                    Dil().sec(dilSecimi, "tv15"),
                                    'assets/images/kurulum_isisensor_icon.png',
                                    wifiOlcum
                                        ? SabitVeriler().adet1den15e
                                        : SabitVeriler().adet1den10a,
                                    4,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                              ],
                            ),
                          ),
                          //Bacafan Sayısı ve Air inlet Motor sayısı
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //Bacafan
                                _unsurAdetWidgetBaca(
                                    Dil().sec(dilSecimi, "tv16"),
                                    'assets/images/kurulum_bacafan_icon.png',
                                    'assets/images/kurulum_sirkfan_icon.png',
                                    5,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                                //Air inlet
                                _unsurAdetWidgetAirveSirk(
                                    Dil().sec(dilSecimi, "tv17"),
                                    'assets/images/kurulum_airinlet_icon.png',
                                    'assets/images/kurulum_sirkfan_icon.png',
                                    6,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                              ],
                            ),
                          ),
                          //Isıtıcı Sayısı ve Silo Sayısı
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                //Isıtıcı
                                _unsurAdetWidget(
                                    Dil().sec(dilSecimi, "tv18"),
                                    'assets/images/kurulum_isitici_icon.png',
                                    isiticiAdet,
                                    SabitVeriler().adet0dan3e,
                                    7,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                                //Silo
                                _unsurAdetWidget(
                                    Dil().sec(dilSecimi, "tv19"),
                                    'assets/images/kurulum_silo_icon.png',
                                    siloAdet,
                                    SabitVeriler().adet0dan4e,
                                    8,
                                    context,
                                    _blocSinif,
                                    dbProkis),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),

                //ileri ve geri ok bölümü
                Expanded(
                  child: Container(
                    color: Colors.grey.shade600,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(flex: 20, child: Container()),
                        //geri ok
                        Expanded(
                            flex: 2,
                            child: Visibility(
                              visible: widget.ilkKurulumMu,
                              maintainState: true,
                              maintainSize: true,
                              maintainAnimation: true,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                iconSize: 50 * oran,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TemelAyarlar(true)),
                                    //MaterialPageRoute(builder: (context) => UzDebiNem(dbVeriler)),
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
                            child: Visibility(
                              visible: widget.ilkKurulumMu,
                              maintainState: true,
                              maintainSize: true,
                              maintainAnimation: true,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                iconSize: 50 * oran,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FanYontemi(true)),
                                  );
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
                            Dil().sec(dilSecimi, "tv11"), 
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
                                        text: Dil().sec(dilSecimi, "info30"),
                                        style: TextStyle(
                                          color: Colors.grey[700],
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
            
      },
    );
  }

  Widget _unsurAdetWidget(
      String baslik,
      String imagePath,
      String dropDownValue,
      List<String> liste,
      int adetCode,
      BuildContext context,
      AdetlerBloC _blocSinif,
      DBProkis dbProkis) {
    return Expanded(
      child: Column(
          children: <Widget>[
            Expanded(
      child: SizedBox(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: AutoSizeText(
            baslik,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Kelly Slab',
                color: Colors.black,
                fontSize: 50,
                fontWeight: FontWeight.bold),
            maxLines: 1,
            minFontSize: 8,
          ),
        ),
      ),
            ),
            Expanded(
      flex: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            color: Colors.grey[300],
            child: DropdownButton<String>(
              isDense: true,
              value: dropDownValue,
              elevation: 16,
              iconEnabledColor: Colors.black,
              iconSize: 40 * oran,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Audio Wide',
                fontSize: 30 * oran,
                fontWeight: FontWeight.bold,
              ),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                switch (adetCode) {
                  case 1:
                    _blocSinif.bloCVeriEventSink.add("fanAdet*$newValue");
                    fanAdet = newValue;
                    break;

                  case 2:
                    _blocSinif.bloCVeriEventSink
                        .add("klepeAdet*$newValue");
                    klepeAdet = newValue;
                    break;

                  case 3:
                    _blocSinif.bloCVeriEventSink.add("pedAdet*$newValue");
                    pedAdet = newValue;
                    break;

                  case 7:
                    _blocSinif.bloCVeriEventSink
                        .add("isiticiAdet*$newValue");
                    isiticiAdet = newValue;
                    break;

                  case 8:
                    _blocSinif.bloCVeriEventSink
                        .add("siloAdet*$newValue");
                    siloAdet = newValue;
                    break;
                }

                if (adetCode < 5) {
                  String x1 = fanAdet;
                  String x2 = klepeAdet;
                  String x3 = pedAdet;
                  String x4 = isiSensAdet;
                  String x5 = wifiOlcum == true ? "#1" : "#2";
                  String komut = "2*4*$x1*$x2*$x3*$x4$x5";

                  Metotlar()
                      .veriGonder( komut, 2233)
                      .then((value) {
                        if(value.split("*")[0]=="error"){
                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                        }else{
                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                          dbProkis.dbSatirEkleGuncelle(4, x1, x2, x3, x4 + x5);    
                  }

                  });

                  if (wifiOlcum != wifiOlcumGecici) {
                    Metotlar().veriGonder("23*0*0*0*0*0", 2233).then((value) {
                          if(value.split("*")[0]=="error"){
                            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                          }else{
                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                            dbProkis.dbSatirEkleGuncelle(20, "0", "0", "0", "0");
                            dbProkis.dbSatirEkleGuncelle(21, "0", "0", "0", "0");
                            wifiOlcumGecici = wifiOlcum;
                          }
                    });
                  }
                } else {
                  String x1 = bacafanVarMi;
                  String x2 = sirkfanVarMi;
                  String x3 = airinletVarMi;
                  String x4 = isiticiAdet;
                  String x5 = siloAdet;
                  String komut = "3*6*$x1#$x2*$x3*$x4*$x5";

                  Metotlar().veriGonder(komut, 2233).then((value) {

                        if(value.split("*")[0]=="error"){
                          Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                        }else{
                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                          dbProkis.dbSatirEkleGuncelle(5, x1 + "#" + x2, x3, x4, x5);
                        }
                  });
                }
              },
              items: liste.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    child: Text(value),
                    padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                  ),
                );
              }).toList(),
            ),
          ),
          Spacer(),
        ],
      ),
            ),
          ],
        ),
    );
  }

  Widget _unsurAdetWidgetBaca(
      String baslik,
      String imagePathBfan,
      String imagePathSirk,
      int adetCode,
      BuildContext context,
      AdetlerBloC _blocSinif,
      DBProkis dbProkis) {
    return Expanded(
      child: Column(
        children: <Widget>[
          //Başlık

          Expanded(
            child: SizedBox(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: AutoSizeText(
                  baslik,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Kelly Slab',
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 8,
                ),
              ),
            ),
          ),

          //Gövde

          Expanded(
            flex: 4,
            child: Row(
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage(imagePathBfan),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    child: RawMaterialButton(
                      onPressed: () {
                        if (bacafanVarMi == "1") {
                          _blocSinif.bloCVeriEventSink.add("bacafanVarMi*0");
                          bacafanVarMi="0";
                        } else {
                          _blocSinif.bloCVeriEventSink.add("bacafanVarMi*1");
                          bacafanVarMi="1";
                        }

                        String x1 = bacafanVarMi;
                        String x2 = sirkfanVarMi;
                        String x3 = airinletVarMi;
                        String x4 = isiticiAdet;
                        String x5 = siloAdet;
                        String komut = "3*6*$x1#$x2*$x3*$x4*$x5";

                        Metotlar()
                            .veriGonder(komut, 2233).then((value) {
                              if(value.split("*")[0]=="error"){
                                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                              }else{
                                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                dbProkis.dbSatirEkleGuncelle(5, x1 + "#" + x2, x3, x4, x5);
                              }
                          
                        });
                      },
                      child: Icon(
                        bacafanVarMi == "1"
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: bacafanVarMi == "1"
                            ? Colors.green[600]
                            : Colors.black,
                        size: 30 * oran,
                      ),
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _unsurAdetWidgetAirveSirk(
      String baslik,
      String imagePathBfan,
      String imagePathSirk,
      int adetCode,
      BuildContext context,
      AdetlerBloC _blocSinif,
      DBProkis dbProkis) {
    return Expanded(
      child: Column(
        children: <Widget>[
          //Başlık

          Expanded(
            child: SizedBox(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: AutoSizeText(
                  baslik,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Kelly Slab',
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 8,
                ),
              ),
            ),
          ),

          //Gövde

          Expanded(
            flex: 4,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(imagePathBfan),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (airinletVarMi == "1") {
                                _blocSinif.bloCVeriEventSink.add("airinletVarMi*0");
                                airinletVarMi="0";
                              } else {
                                _blocSinif.bloCVeriEventSink.add("airinletVarMi*1");
                                airinletVarMi="1";
                              }

                              String x1 = bacafanVarMi;
                              String x2 = sirkfanVarMi;
                              String x3 = airinletVarMi;
                              String x4 = isiticiAdet;
                              String x5 = siloAdet;
                              String komut = "3*6*$x1#$x2*$x3*$x4*$x5";

                              Metotlar().veriGonder(komut, 2233).then((value) {
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                }else{
                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                  dbProkis.dbSatirEkleGuncelle(5, x1 + "#" + x2, x3, x4, x5);
                                }
                                
                              });
                            },
                            child: Icon(
                              airinletVarMi == "1"
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: airinletVarMi == "1"
                                  ? Colors.green[600]
                                  : Colors.black,
                              size: 30 * oran,
                            ),
                            padding: EdgeInsets.all(0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    alignment: Alignment.center,
                                    image: AssetImage(imagePathSirk),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (sirkfanVarMi == "1") {
                                _blocSinif.bloCVeriEventSink.add("sirkfanVarMi*0");
                                sirkfanVarMi="0";
                              } else {
                                _blocSinif.bloCVeriEventSink.add("sirkfanVarMi*1");
                                sirkfanVarMi="1";
                              }

                              String x1 = bacafanVarMi;
                              String x2 =sirkfanVarMi;
                              String x3 = airinletVarMi;
                              String x4 = isiticiAdet;
                              String x5 = siloAdet;
                              String komut = "3*6*$x1#$x2*$x3*$x4*$x5";

                              Metotlar().veriGonder(komut, 2233).then((value) {
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                }else{
                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                  dbProkis.dbSatirEkleGuncelle(5, x1 + "#" + x2, x3, x4, x5);
                                }
                                
                              });
                            },
                            child: Icon(
                              sirkfanVarMi == "1"
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: sirkfanVarMi == "1"
                                  ? Colors.green[600]
                                  : Colors.black,
                              size: 30 * oran,
                            ),
                            padding: EdgeInsets.all(0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _unsurAdetWidgetIsiSens(
      String baslik,
      String imagePath,
      List<String> liste,
      int adetCode,
      BuildContext context,
      AdetlerBloC _blocSinif,
      DBProkis dbProkis) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        baslik,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Kelly Slab',
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (!wifiOlcum) {
                        _blocSinif.bloCVeriEventSink.add("wifiOlcum*1");
                        _blocSinif.bloCVeriEventSink.add("analogOlcum*0");
                        wifiOlcum=true;
                        analogOlcum=false;
                        

                        String x1 = fanAdet;
                        String x2 = klepeAdet;
                        String x3 = pedAdet;
                        String x4 = isiSensAdet;
                        String x5 =wifiOlcum == true ? "#1" : "#2";
                        String komut = "2*4*$x1*$x2*$x3*$x4$x5";

                        Metotlar().veriGonder(komut, 2233).then((value) {
                          if(value.split("*")[0]=="error"){
                              Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                              dbProkis.dbSatirEkleGuncelle(4, x1, x2, x3, x4 + x5);
                            }
                          
                        });

                        if (wifiOlcum && wifiOlcumGecici) {
                          Metotlar().veriGonder("23*0*0*0*0*0", 2233).then((value) {
                            if(value.split("*")[0]=="error"){
                              Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                              dbProkis.dbSatirEkleGuncelle(
                                  20, "0", "0", "0", "0");
                              dbProkis.dbSatirEkleGuncelle(
                                  21, "0", "0", "0", "0");
                              _blocSinif.bloCVeriEventSink.add("wifiOlcumGecici*1");
                            }
                            
                          });
                        }
                      } else {
                        Toast.show(Dil().sec(dilSecimi, "toast60"), context,
                            duration: 3);
                      }
                    },
                    child: Icon(
                      Icons.wifi,
                      color: wifiOlcum
                          ? Colors.green[600]
                          : Colors.black,
                      size: 25 * oran,
                    ),
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (!analogOlcum) {
                        _blocSinif.bloCVeriEventSink.add("analogOlcum*2");
                        _blocSinif.bloCVeriEventSink.add("wifiOlcum*0");
                        wifiOlcum=false;
                        analogOlcum=true;

                        String x1 = fanAdet;
                        String x2 = klepeAdet;
                        String x3 = pedAdet;
                        String x4 = isiSensAdet;
                        String x5 =wifiOlcum == true ? "#1" : "#2";
                        String komut = "2*4*$x1*$x2*$x3*$x4$x5";

                        Metotlar().veriGonder(komut, 2233).then((value) {
                          if(value.split("*")[0]=="error"){
                            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                          }else{
                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                            dbProkis.dbSatirEkleGuncelle(4, x1, x2, x3, x4 + x5);
                          }
                          
                        });

                        if (wifiOlcum && wifiOlcumGecici) {
                          Metotlar().veriGonder("23*0*0*0*0*0", 2233).then((value) {
                            if(value.split("*")[0]=="error"){
                              Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                              dbProkis.dbSatirEkleGuncelle(
                                  20, "0", "0", "0", "0");
                              dbProkis.dbSatirEkleGuncelle(
                                  21, "0", "0", "0", "0");
                              _blocSinif.bloCVeriEventSink.add("wifiOlcumGecici*1");
                                
                            }
                            
                          });
                        }
                      } else {
                        Toast.show(Dil().sec(dilSecimi, "toast61"), context,
                            duration: 3);
                      }
                    },
                    child: Icon(
                      Icons.slow_motion_video,
                      color: analogOlcum
                          ? Colors.green[500]
                          : Colors.black,
                      size: 25 * oran,
                    ),
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage(imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  color: Colors.grey[300],
                  child: DropdownButton<String>(
                    isDense: true,
                    value: isiSensAdet,
                    elevation: 16,
                    iconEnabledColor: Colors.black,
                    iconSize: 40 * oran,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Audio Wide',
                      fontSize: 30 * oran,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      _blocSinif.bloCVeriEventSink.add("isiSensAdet*$newValue");
                      isiSensAdet=newValue;

                      String x1 = fanAdet;
                      String x2 = klepeAdet;
                      String x3 = pedAdet;
                      String x4 = isiSensAdet;
                      String x5 = wifiOlcum == true ? "#1" : "#2";
                      String komut = "2*4*$x1*$x2*$x3*$x4$x5";

                      Metotlar().veriGonder(komut, 2233).then((value) {
                        if(value.split("*")[0]=="error"){
                          Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                        }else{
                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                          dbProkis.dbSatirEkleGuncelle(4, x1, x2, x3, x4 + x5);
                        }
                      });
                    },
                    items: liste.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          child: Text(value),
                          padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdetlerBloC {
  Map<String, String> veri = Map();

  Map<String, String> blokVeriGetir() {
    return veri;
  }

  //state için stream controller
  final _bloCVeriStateStreamController = StreamController<Map>();
  Stream<Map> get bloCVeri => _bloCVeriStateStreamController.stream;
  StreamSink<Map> get _bloCVeriStateSink => _bloCVeriStateStreamController.sink;

  //eventler için stream controller
  final _bloCVeriEventStreamController = StreamController<String>();
  Stream<String> get _bloCVeriEventStream => _bloCVeriEventStreamController.stream;
  StreamSink<String> get bloCVeriEventSink => _bloCVeriEventStreamController.sink;

  AdetlerBloC(DBProkis dbProkis) {

    veri["dilSecimi"] = dbProkis.dbVeriGetir(1, 1, "EN");
    veri["fanAdet"] = dbProkis.dbVeriGetir(4, 1, "1");
    veri["klepeAdet"] = dbProkis.dbVeriGetir(4, 2, "1");
    veri["pedAdet"] = dbProkis.dbVeriGetir(4, 3, "1");
    var xx = dbProkis.dbVeriGetir(4, 4, "7#1").split("#");
    veri["isiSensAdet"] = xx[0];
    if (xx.length > 1) {
      veri["wifiOlcum"] = xx[1];
      veri["wifiOlcumGecici"] = xx[1];
      veri["analogOlcum"] = xx[1];
    }
    var yy = dbProkis.dbVeriGetir(5, 1, "0#0").split("#");
    veri["bacafanVarMi"] = yy[0];
    veri["sirkfanVarMi"] = yy[1];
    veri["airinletVarMi"] = dbProkis.dbVeriGetir(5, 2, "0");
    veri["isiticiAdet"] = dbProkis.dbVeriGetir(5, 3, "0");
    veri["siloAdet"] = dbProkis.dbVeriGetir(5, 4, "0");


    _bloCVeriStateSink.add(veri);

    _bloCVeriEventStream.listen((event) {
      var xx = event.split("*");

      if (event != "" && event != null) {
        veri[xx[0]] = xx[1];
      }

      _bloCVeriStateSink.add(veri);
    });
  }
}
