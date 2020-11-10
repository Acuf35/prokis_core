import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x2.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/sistem/kurulum/uz_debi_nem.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/sistem/kurulum/girisler.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'kurulumu_tamamla.dart';

class KwDegerleri extends StatefulWidget {
  bool ilkKurulumMu = true;
  KwDegerleri(this.ilkKurulumMu);

  @override
  _KwDegerleriState createState() => _KwDegerleriState();
}

class _KwDegerleriState extends State<KwDegerleri> {
  String dilSecimi = "EN";

  double oran;

  int sayac = 0;

  int _onlar = 0;

  int _birler = 0;

  int _ondalikOnlar = 0;

  int _ondalikBirler = 0;

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel = (MediaQuery.of(context).size.width / 60) * 3;

    return ChangeNotifierProvider<KwDegerleriProvider>(
        create: (context) =>
            KwDegerleriProvider(context, dbProkis, widget.ilkKurulumMu),
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<KwDegerleriProvider>(context);

          return Scaffold(
            floatingActionButton: MyFloatingActionBackButton(
                !widget.ilkKurulumMu,
                !provider.veriGonderildi,
                oran,
                40,
                Colors.white,
                Colors.grey[700],
                Icons.arrow_back,
                1,
                "tv564"),
            body: Column(
              children: <Widget>[
                //Başlık bölümü
                Expanded(
                    child: Container(
                  color: Colors.grey.shade600,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv664"),
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
                      ),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraint) {
                          return IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.info_outline,
                            ),
                            iconSize: constraint.biggest.height,
                            color: Colors.white,
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                          );
                        }),
                      ),
                    ],
                  ),
                )),
                //Kw Değerleri
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Spacer(),
                        //fan,ped,klepe,bfan
                        Expanded(flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //KW Tünel Fan
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
                                              Dil().sec(dilSecimi, "tv289"),
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
                                            _onlar = int.parse(
                                                    provider.kwFan.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwFan.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwFan.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwFan.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv289",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwFan =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWfan = provider.kwFan;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwFan,
                                                textAlign: TextAlign.center,
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
                              //KW Klepe Motor
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
                                              Dil().sec(dilSecimi, "tv305"),
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
                                            _onlar = int.parse(
                                                    provider.kwKlp.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwKlp.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwKlp.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwKlp.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv305",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwKlp =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWklp = provider.kwKlp;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwKlp,
                                                textAlign: TextAlign.center,
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
                              //KW Ped Pompa
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
                                              Dil().sec(dilSecimi, "tv342"),
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
                                            _onlar = int.parse(
                                                    provider.kwPed.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwPed.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwPed.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwPed.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv342",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwPed =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWped = provider.kwPed;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwPed,
                                                textAlign: TextAlign.center,
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
                              //KW Bfan Motor
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
                                              Dil().sec(dilSecimi, "tv350"),
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
                                            _onlar = int.parse(
                                                    provider.kwBfan.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwBfan.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwBfan.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwBfan.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv350",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwBfan =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWbfan = provider.kwBfan;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwBfan,
                                                textAlign: TextAlign.center,
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
                        Spacer(),
                        //air,ısıtıcı,sfan,ayd
                        Expanded(flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //KW Air inlet Fan
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
                                              Dil().sec(dilSecimi, "tv797"),
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
                                            _onlar = int.parse(
                                                    provider.kwAir.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwAir.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwAir.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwAir.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv797",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwAir =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWair = provider.kwAir;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwAir,
                                                textAlign: TextAlign.center,
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
                              //KW Isıtıcı fan
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
                                              Dil().sec(dilSecimi, "tv798"),
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
                                            _onlar = int.parse(
                                                    provider.kwIst.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwIst.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwIst.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwIst.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv798",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwIst =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWIst = provider.kwIst;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwIst,
                                                textAlign: TextAlign.center,
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
                              //KW Sirkülasyon Pompa 
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
                                              Dil().sec(dilSecimi, "tv799"),
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
                                            _onlar = int.parse(
                                                    provider.kwSfan.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwSfan.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwSfan.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwSfan.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv799",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwSfan =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWSfan = provider.kwSfan;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwSfan,
                                                textAlign: TextAlign.center,
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
                              //KW Aydınlatma
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
                                              Dil().sec(dilSecimi, "tv800"),
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
                                            _onlar = int.parse(
                                                    provider.kwAyd.split(".")[0]) ~/
                                                10;
                                            _birler = int.parse(
                                                    provider.kwAyd.split(".")[0]) %
                                                10;
                                            _ondalikOnlar = int.parse(
                                                    provider.kwAyd.split(".")[1]) ~/
                                                10;
                                            _ondalikBirler = int.parse(
                                                    provider.kwAyd.split(".")[1]) %
                                                10;

                                            MyshowModalBottomSheet2x2(
                                                    dilSecimi,
                                                    context,
                                                    oran,
                                                    _onlar,
                                                    _birler,
                                                    _ondalikOnlar,
                                                    _ondalikBirler,
                                                    "tv800",
                                                    "tv35")
                                                .then((value) {
                                              bool gelenVeri =
                                                  value == null ? false : value[0];

                                              if (gelenVeri) {
                                                provider.kwAyd =
                                                    (value[1] * 10 + value[2])
                                                            .toString() +
                                                        "." +
                                                        (value[3] * 10 + value[4])
                                                            .toString();
                                                provider.setKWayd = provider.kwAyd;
                                                provider.setveriGonderildi = false;
                                              }
                                            });
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
                                                provider.kwAyd,
                                                textAlign: TextAlign.center,
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
                        Spacer()

                      ],
                    ),
                  ),
                ),

                //ileri geri ok bölümü
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey.shade600,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //Verileri Gönder Bölümü
                        Expanded(
                          flex: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              //Verileri Gönder Butonu
                              FlatButton(
                                onPressed: () {
                                  String veri = provider.kwFan +
                                      "#" +
                                      provider.kwPed +
                                      "#" +
                                      provider.kwKlp +
                                      "#" +
                                      provider.kwBfan +
                                      "#" +
                                      provider.kwAir +
                                      "#" +
                                      provider.kwIst +
                                      "#" +
                                      provider.kwSfan +
                                      "#" +
                                      provider.kwAyd;

                                  String komut = "40*40*$veri*0*0";
                                  Metotlar()
                                      .veriGonder(komut, 2233)
                                      .then((value) {
                                    if (value.split("*")[0] == "error") {
                                      Toast.show(
                                          Dil().sec(dilSecimi, "toast101"),
                                          context,
                                          duration: 3);
                                    } else {
                                      Toast.show(Dil().sec(dilSecimi, "toast8"),
                                          context,
                                          duration: 3);
                                      dbProkis.dbSatirEkleGuncelle(
                                          49, "ok", veri, "0", "0");

                                      provider.setveriGonderildi = true;
                                    }
                                  });
                                },
                                highlightColor: Colors.green,
                                splashColor: Colors.red,
                                color: provider.veriGonderildi
                                    ? Colors.green[500]
                                    : Colors.blue,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.send,
                                      size: 30 * oran,
                                    ),
                                    Text(
                                      Dil().sec(dilSecimi, "btn6"),
                                      style: TextStyle(fontSize: 18),
                                      textScaleFactor: oran,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                        builder: (context) => UzDebiNem(true)),
                                  );

                                  //Navigator.pop(context, tumCikislar);
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
                                  if (!provider.veriGonderildi) {
                                    Toast.show(Dil().sec(dilSecimi, "toast27"),
                                        context,
                                        duration: 3);
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KurulumuTamamla(
                                                    dbProkis.getDbVeri),
                                            fullscreenDialog: true));
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
                            Dil().sec(dilSecimi, "tv85"),
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
                                  text: TextSpan(children: <TextSpan>[
                                    //Giriş metni
                                    TextSpan(
                                        text: Dil().sec(dilSecimi, "info57"),
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13 * oran)),
                                  ]),
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
        }));
  }
}

class KwDegerleriProvider with ChangeNotifier {
  int sayac = 0;

  String kwFan = "1.5";
  String kwPed = "2.5";
  String kwKlp = "0.37";
  String kwBfan = "15.00";
  String kwAir = "0.37";
  String kwIst = "10.00";
  String kwSfan = "10.00";
  String kwAyd = "2.50";

  bool veriGonderildi = false;

  dinlemeyiTetikle() {
    notifyListeners();
  }

  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }

  set setKWfan(String value) {
    kwFan = value;
    notifyListeners();
  }

  set setKWped(String value) {
    kwPed = value;
    notifyListeners();
  }

  set setKWklp(String value) {
    kwKlp = value;
    notifyListeners();
  }

  set setKWbfan(String value) {
    kwBfan = value;
    notifyListeners();
  }

  set setKWair(String value) {
    kwAir = value;
    notifyListeners();
  }

  set setKWIst(String value) {
    kwIst = value;
    notifyListeners();
  }

  set setKWSfan(String value) {
    kwSfan = value;
    notifyListeners();
  }

  set setKWayd(String value) {
    kwAyd = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  KwDegerleriProvider(this.context, this.dbProkis, bool ilkKurulum) {
    veriGonderildi = ilkKurulum == false ? true : false;

    var veri = dbProkis
        .dbVeriGetir(49, 2, "1.5#2.5#0.37#15.0#0.37#10.0#10.0#2.5")
        .split('#');

    kwFan = veri[0];
    kwPed = veri[1];
    kwKlp = veri[2];
    kwBfan = veri[3];
    kwAir = veri[4];
    kwIst = veri[5];
    kwSfan = veri[6];
    kwAyd = veri[7];
  }
}
