import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'genel/alert_reset.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'genel/deger_giris_3x0.dart';
import 'klepe_haritasi.dart';
import 'languages/select.dart';

class FanHaritasi extends StatefulWidget {
  String gelenDil;

  FanHaritasi(String dil) {
    gelenDil = dil;
  }
  @override
  State<StatefulWidget> createState() {
    return FanHaritasiState(gelenDil);
  }
}

class FanHaritasiState extends State<FanHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> fanHarita = new List(121);
  List<bool> fanVisibility = new List(121);
  List<int> fanNo = new List(121);
  List<int> cikisNo = new List(121);
  List<bool> sutun = new List(13);
  bool haritaOnay = false;
  int fanAdet = 0;

  int _onlarFan=1;
  int _birlerFan=0;
  int _onlarOut=3;
  int _birlerOut=3;
  int _degerNo=0;

  double _oran1;
  bool veriGonderildi=false;
  bool fanNoTekerrur=false;
  bool cikisNoTekerrur=false;


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++

  FanHaritasiState(String dil) {
    for (int i = 1; i <= 120; i++) {
      fanHarita[i] = 0;
      fanNo[i] = 0;
      cikisNo[i] = 0;
      fanVisibility[i] = true;
    }

    for (int i = 1; i <= 12; i++) {
      sutun[i] = true;
    }
    
    dilSecimi = dil;
  }

  //--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    
//++++++++++++++++++++++++++DATABASE'den SATIRLARI ÇEKME+++++++++++++++++++++++++++++++
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      if (dbSayac == 0) {
        dbSatirlar.then((List<Map> satir) => _satirlar(satir));
        dbSayac++;
      }
    });
//--------------------------DATABASE'den SATIRLARI ÇEKME--------------------------------

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
    _oran1=oran;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Text(
            SelectLanguage()
                .selectStrings(dilSecimi, "tv31"), // Tünel Fan Haritası
            style: TextStyle(
                fontFamily: 'Kelly Slab',
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
          ),
          alignment: Alignment.center,
        )),
        //Fan Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                //Harita Satır ve sütunlar
                Expanded(
                  flex: 4,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Sütun 1
                      Visibility(visible: sutun[1],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*1
                              Visibility(child: _fanHaritaUnsur(1),visible: fanVisibility[1] ? true : false,),
                              //2*1
                              Visibility(child: _fanHaritaUnsur(13),visible: fanVisibility[13] ? true : false,),
                              //3*1
                              Visibility(child: _fanHaritaUnsur(25),visible: fanVisibility[25] ? true : false,),
                              //4*1
                              Visibility(child: _fanHaritaUnsur(37),visible: fanVisibility[37] ? true : false,),
                              //5*1
                              Visibility(child: _fanHaritaUnsur(49),visible: fanVisibility[49] ? true : false,),
                              //6*1
                              Visibility(child: _fanHaritaUnsur(61),visible: fanVisibility[61] ? true : false,),
                              //7*1
                              Visibility(child: _fanHaritaUnsur(73),visible: fanVisibility[73] ? true : false,),
                              //8*1
                              Visibility(child: _fanHaritaUnsur(85),visible: fanVisibility[85] ? true : false,),
                              //9*1
                              Visibility(child: _fanHaritaUnsur(97),visible: fanVisibility[97] ? true : false,),
                              //10*1
                              Visibility(child: _fanHaritaUnsur(109),visible: fanVisibility[109] ? true : false,),
                                        
                            ],
                          ),
                        ),
                      ),

                      //Sütun 2
                      Visibility(visible: sutun[2],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*2
                              Visibility(child: _fanHaritaUnsur(2),visible: fanVisibility[2] ? true : false,),
                              //2*2
                              Visibility(child: _fanHaritaUnsur(14),visible: fanVisibility[14] ? true : false,),
                              //3*2
                              Visibility(child: _fanHaritaUnsur(26),visible: fanVisibility[26] ? true : false,),
                              //4*2
                              Visibility(child: _fanHaritaUnsur(38),visible: fanVisibility[38] ? true : false,),
                              //5*2
                              Visibility(child: _fanHaritaUnsur(50),visible: fanVisibility[50] ? true : false,),
                              //6*2
                              Visibility(child: _fanHaritaUnsur(62),visible: fanVisibility[62] ? true : false,),
                              //7*2
                              Visibility(child: _fanHaritaUnsur(74),visible: fanVisibility[74] ? true : false,),
                              //8*2
                              Visibility(child: _fanHaritaUnsur(86),visible: fanVisibility[86] ? true : false,),
                              //9*2
                              Visibility(child: _fanHaritaUnsur(98),visible: fanVisibility[98] ? true : false,),
                              //10*2
                              Visibility(child: _fanHaritaUnsur(110),visible: fanVisibility[110] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),

                      //Sütun 3
                      Visibility(visible: sutun[3],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*3
                              Visibility(child: _fanHaritaUnsur(3),visible: fanVisibility[3] ? true : false,),
                              //2*3
                              Visibility(child: _fanHaritaUnsur(15),visible: fanVisibility[15] ? true : false,),
                              //3*3
                              Visibility(child: _fanHaritaUnsur(27),visible: fanVisibility[27] ? true : false,),
                              //4*3
                              Visibility(child: _fanHaritaUnsur(39),visible: fanVisibility[39] ? true : false,),
                              //5*3
                              Visibility(child: _fanHaritaUnsur(51),visible: fanVisibility[51] ? true : false,),
                              //6*3
                              Visibility(child: _fanHaritaUnsur(63),visible: fanVisibility[63] ? true : false,),
                              //7*3
                              Visibility(child: _fanHaritaUnsur(75),visible: fanVisibility[75] ? true : false,),
                              //8*3
                              Visibility(child: _fanHaritaUnsur(87),visible: fanVisibility[87] ? true : false,),
                              //9*3
                              Visibility(child: _fanHaritaUnsur(99),visible: fanVisibility[99] ? true : false,),
                              //10*3
                              Visibility(child: _fanHaritaUnsur(111),visible: fanVisibility[111] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 4
                      Visibility(visible: sutun[4],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*4
                              Visibility(child: _fanHaritaUnsur(4), visible: fanVisibility[4] ? true : false,),
                              //2*4 
                              Visibility(child: _fanHaritaUnsur(16) ,visible: fanVisibility[16] ? true : false,),
                              //3*4 
                              Visibility(child: _fanHaritaUnsur(28) ,visible: fanVisibility[28] ? true : false,),
                              //4*4 
                              Visibility(child: _fanHaritaUnsur(40) ,visible: fanVisibility[40] ? true : false,),
                              //5*4 
                              Visibility(child: _fanHaritaUnsur(52) ,visible: fanVisibility[52] ? true : false,),
                              //6*4 
                              Visibility(child: _fanHaritaUnsur(64) ,visible: fanVisibility[64] ? true : false,),
                              //7*4 
                              Visibility(child: _fanHaritaUnsur(76) ,visible: fanVisibility[76] ? true : false,),
                              //8*4 
                              Visibility(child: _fanHaritaUnsur(88) ,visible: fanVisibility[88] ? true : false,),
                              //9*4
                              Visibility(child: _fanHaritaUnsur(100),visible: fanVisibility[100] ? true : false,),
                              //10*4
                              Visibility(child: _fanHaritaUnsur(112),visible: fanVisibility[112] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 5
                      Visibility(visible: sutun[5],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*5
                              Visibility(child: _fanHaritaUnsur(5 ), visible: fanVisibility[5] ? true : false,),
                              //2*5 
                              Visibility(child: _fanHaritaUnsur(17) ,visible: fanVisibility[17] ? true : false,),
                              //3*5 
                              Visibility(child: _fanHaritaUnsur(29) ,visible: fanVisibility[29] ? true : false,),
                              //4*5 
                              Visibility(child: _fanHaritaUnsur(41) ,visible: fanVisibility[41] ? true : false,),
                              //5*5 
                              Visibility(child: _fanHaritaUnsur(53) ,visible: fanVisibility[53] ? true : false,),
                              //6*5 
                              Visibility(child: _fanHaritaUnsur(65) ,visible: fanVisibility[65] ? true : false,),
                              //7*5 
                              Visibility(child: _fanHaritaUnsur(77) ,visible: fanVisibility[77] ? true : false,),
                              //8*5 
                              Visibility(child: _fanHaritaUnsur(89) ,visible: fanVisibility[89] ? true : false,),
                              //9*5
                              Visibility(child: _fanHaritaUnsur(101),visible: fanVisibility[101] ? true : false,),
                              //10*5
                              Visibility(child: _fanHaritaUnsur(113),visible: fanVisibility[113] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 6
                      Visibility(visible: sutun[6],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*6
                              Visibility(child:  _fanHaritaUnsur(6 ),visible: fanVisibility[6] ? true : false,),
                              //2*6 
                              Visibility(child:  _fanHaritaUnsur(18),visible: fanVisibility[18] ? true : false,),
                              //3*6 
                              Visibility(child:  _fanHaritaUnsur(30),visible: fanVisibility[30] ? true : false,),
                              //4*6 
                              Visibility(child:  _fanHaritaUnsur(42),visible: fanVisibility[42] ? true : false,),
                              //5*6 
                              Visibility(child:  _fanHaritaUnsur(54),visible: fanVisibility[54] ? true : false,),
                              //6*6 
                              Visibility(child:  _fanHaritaUnsur(66),visible: fanVisibility[66] ? true : false,),
                              //7*6 
                              Visibility(child:  _fanHaritaUnsur(78),visible: fanVisibility[78] ? true : false,),
                              //8*6 
                              Visibility(child:  _fanHaritaUnsur(90),visible: fanVisibility[90] ? true : false,),
                              //9*6
                              Visibility(child: _fanHaritaUnsur(102),visible: fanVisibility[102] ? true : false,),
                              //10*6
                              Visibility(child: _fanHaritaUnsur(114),visible: fanVisibility[114] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 7
                      Visibility(visible: sutun[7],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*7
                              Visibility(child:  _fanHaritaUnsur(7 ),visible: fanVisibility[7 ] ? true : false,),
                              //2*7 
                              Visibility(child:  _fanHaritaUnsur(19),visible: fanVisibility[19] ? true : false,),
                              //3*7 
                              Visibility(child:  _fanHaritaUnsur(31),visible: fanVisibility[31] ? true : false,),
                              //4*7 
                              Visibility(child:  _fanHaritaUnsur(43),visible: fanVisibility[43] ? true : false,),
                              //5*7 
                              Visibility(child:  _fanHaritaUnsur(55),visible: fanVisibility[55] ? true : false,),
                              //6*7 
                              Visibility(child:  _fanHaritaUnsur(67),visible: fanVisibility[67] ? true : false,),
                              //7*7 
                              Visibility(child:  _fanHaritaUnsur(79),visible: fanVisibility[79] ? true : false,),
                              //8*7 
                              Visibility(child:  _fanHaritaUnsur(91),visible: fanVisibility[91] ? true : false,),
                              //9*7 
                              Visibility(child: _fanHaritaUnsur(103),visible: fanVisibility[103] ? true : false,),
                              //10*7
                              Visibility(child: _fanHaritaUnsur(115),visible: fanVisibility[115] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),

                      //Sütun 8
                      Visibility(visible: sutun[8],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*8
                              Visibility(child:  _fanHaritaUnsur(8 ),visible: fanVisibility[8 ] ? true : false,),
                              //2*8 
                              Visibility(child:  _fanHaritaUnsur(20),visible: fanVisibility[20] ? true : false,),
                              //3*8 
                              Visibility(child:  _fanHaritaUnsur(32),visible: fanVisibility[32] ? true : false,),
                              //4*8 
                              Visibility(child:  _fanHaritaUnsur(44),visible: fanVisibility[44] ? true : false,),
                              //5*8 
                              Visibility(child:  _fanHaritaUnsur(56),visible: fanVisibility[56] ? true : false,),
                              //6*8 
                              Visibility(child:  _fanHaritaUnsur(68),visible: fanVisibility[68] ? true : false,),
                              //7*8 
                              Visibility(child:  _fanHaritaUnsur(80),visible: fanVisibility[80] ? true : false,),
                              //8*8 
                              Visibility(child:  _fanHaritaUnsur(92),visible: fanVisibility[92] ? true : false,),
                              //9*8
                              Visibility(child: _fanHaritaUnsur(104),visible: fanVisibility[104] ? true : false,),
                              //10*8
                              Visibility(child: _fanHaritaUnsur(116),visible: fanVisibility[116] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 9
                      Visibility(visible: sutun[9],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*9
                              Visibility(child:  _fanHaritaUnsur(9),visible: fanVisibility[9] ? true : false,),
                              //2*9 
                              Visibility(child:  _fanHaritaUnsur(21),visible: fanVisibility[21] ? true : false,),
                              //3*9 
                              Visibility(child:  _fanHaritaUnsur(33),visible: fanVisibility[33] ? true : false,),
                              //4*9 
                              Visibility(child:  _fanHaritaUnsur(45),visible: fanVisibility[45] ? true : false,),
                              //5*9 
                              Visibility(child:  _fanHaritaUnsur(57),visible: fanVisibility[57] ? true : false,),
                              //6*9 
                              Visibility(child:  _fanHaritaUnsur(69),visible: fanVisibility[69] ? true : false,),
                              //7*9 
                              Visibility(child:  _fanHaritaUnsur(81),visible: fanVisibility[81] ? true : false,),
                              //8*9 
                              Visibility(child:  _fanHaritaUnsur(93),visible: fanVisibility[93] ? true : false,),
                              //9*9
                              Visibility(child: _fanHaritaUnsur(105),visible: fanVisibility[105] ? true : false,),
                              //10*9
                              Visibility(child: _fanHaritaUnsur(117),visible: fanVisibility[117] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 10
                      Visibility(visible: sutun[10],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*10
                              Visibility(child:  _fanHaritaUnsur(10),visible: fanVisibility[10] ? true : false,),
                              //2*10 
                              Visibility(child:  _fanHaritaUnsur(22),visible: fanVisibility[22] ? true : false,),
                              //3*10 
                              Visibility(child:  _fanHaritaUnsur(34),visible: fanVisibility[34] ? true : false,),
                              //4*10 
                              Visibility(child:  _fanHaritaUnsur(46),visible: fanVisibility[46] ? true : false,),
                              //5*10 
                              Visibility(child:  _fanHaritaUnsur(58),visible: fanVisibility[58] ? true : false,),
                              //6*10 
                              Visibility(child:  _fanHaritaUnsur(70),visible: fanVisibility[70] ? true : false,),
                              //7*10 
                              Visibility(child:  _fanHaritaUnsur(82),visible: fanVisibility[82] ? true : false,),
                              //8*10 
                              Visibility(child:  _fanHaritaUnsur(94),visible: fanVisibility[94] ? true : false,),
                              //9*10
                              Visibility(child: _fanHaritaUnsur(106),visible: fanVisibility[106] ? true : false,),
                              //10*10
                              Visibility(child: _fanHaritaUnsur(118),visible: fanVisibility[118] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),

                      //Sütun 11
                      Visibility(visible: sutun[11],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*11
                              Visibility(child:  _fanHaritaUnsur(11),visible: fanVisibility[11] ? true : false,),
                              //2*11 
                              Visibility(child:  _fanHaritaUnsur(23),visible: fanVisibility[23] ? true : false,),
                              //3*11 
                              Visibility(child:  _fanHaritaUnsur(35),visible: fanVisibility[35] ? true : false,),
                              //4*11 
                              Visibility(child:  _fanHaritaUnsur(47),visible: fanVisibility[47] ? true : false,),
                              //5*11 
                              Visibility(child:  _fanHaritaUnsur(59),visible: fanVisibility[59] ? true : false,),
                              //6*11 
                              Visibility(child:  _fanHaritaUnsur(71),visible: fanVisibility[71] ? true : false,),
                              //7*11 
                              Visibility(child:  _fanHaritaUnsur(83),visible: fanVisibility[83] ? true : false,),
                              //8*11 
                              Visibility(child:  _fanHaritaUnsur(95),visible: fanVisibility[95] ? true : false,),
                              //9*11
                              Visibility(child: _fanHaritaUnsur(107),visible: fanVisibility[107] ? true : false,),
                              //10*11
                              Visibility(child: _fanHaritaUnsur(119),visible: fanVisibility[119] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                      //Sütun 12
                      Visibility(visible: sutun[12],
                                              child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*12
                              Visibility(child:  _fanHaritaUnsur(12),visible: fanVisibility[12] ? true : false,),
                              //2*12 
                              Visibility(child:  _fanHaritaUnsur(24),visible: fanVisibility[24] ? true : false,),
                              //3*12 
                              Visibility(child:  _fanHaritaUnsur(36),visible: fanVisibility[36] ? true : false,),
                              //4*12 
                              Visibility(child:  _fanHaritaUnsur(48),visible: fanVisibility[48] ? true : false,),
                              //5*12 
                              Visibility(child:  _fanHaritaUnsur(60),visible: fanVisibility[60] ? true : false,),
                              //6*12 
                              Visibility(child:  _fanHaritaUnsur(72),visible: fanVisibility[72] ? true : false,),
                              //7*12 
                              Visibility(child:  _fanHaritaUnsur(84),visible: fanVisibility[84] ? true : false,),
                              //8*12 
                              Visibility(child:  _fanHaritaUnsur(96),visible: fanVisibility[96] ? true : false,),
                              //9*12
                              Visibility(child: _fanHaritaUnsur(108),visible: fanVisibility[108] ? true : false,),
                              //10*12
                              Visibility(child: _fanHaritaUnsur(120),visible: fanVisibility[120] ? true : false,),
                            
                            ],
                          ),
                        ),
                      ),
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                )
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
                //Spacer(),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Haritayı Onayla Butonu
                      Visibility(visible: !haritaOnay,
                      maintainState: true,
                      maintainSize: true,
                      maintainAnimation: true,
                          child: FlatButton(
                          onPressed: () {
                            int sayac = 0;
                            List<int> satir = new List(11);                         
                            bool dikdortgenHata = false;



                            for (int i = 1; i <= 10; i++) {
                              satir[i] = 0;
                            }
                            

                            for (int i = 1; i <= 12; i++) {
                              if (fanHarita[i] != 0) {
                                satir[1]++;
                              }
                              if (fanHarita[i + 12] != 0) {
                                satir[2]++;
                              }
                              if (fanHarita[i + 24] != 0) {
                                satir[3]++;
                              }
                              if (fanHarita[i + 36] != 0) {
                                satir[4]++;
                              }
                              if (fanHarita[i + 48] != 0) {
                                satir[5]++;
                              }
                              if (fanHarita[i + 60] != 0) {
                                satir[6]++;
                              }
                              if (fanHarita[i + 72] != 0) {
                                satir[7]++;
                              }
                              if (fanHarita[i + 84] != 0) {
                                satir[8]++;
                              }
                              if (fanHarita[i + 96] != 0) {
                                satir[9]++;
                              }
                              if (fanHarita[i + 108] != 0) {
                                satir[10]++;
                              }
                            }

                            for (int i = 1; i <= 10; i++) {
                              for (int k = 1; k <= 10; k++) {
                                if (satir[i] != satir[k] &&
                                    satir[i] != 0 &&
                                    satir[k] != 0) {
                                  dikdortgenHata = true;
                                }
                              }
                            }

                            for (int i = 1; i <= 120; i++) {
                              if (fanHarita[i] == 2) {
                                sayac++;
                              }
                            }

                            if (sayac < fanAdet) {
                              //Haritada seçilen fan sayısı eksik
                              Toast.show(
                                  SelectLanguage().selectStrings(dilSecimi, "toast16"), context,
                                  duration: 3);
                            } else if (sayac > fanAdet) {
                              //Haritada seçilen fan sayısı yüksek
                              Toast.show(
                                  SelectLanguage().selectStrings(dilSecimi, "toast18"), context,
                                  duration: 3);
                            } else if (dikdortgenHata) {
                              //Dikdörtgen seçim hatası
                              Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast17"), context,
                                  duration: 3);
                            } else {

                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast8"), context, duration: 3);
                              haritaOnay = true;

                              for (int i = 1; i <= 12; i++) {
                                sutun[i] = false;
                              }

                              for (int i = 1; i <= 120; i++) {
                                if (fanHarita[i] != 0) {
                                  fanVisibility[i] = true;
                                  if(i%12==1){
                                    sutun[1]=true;
                                  }else if(i%12==2){
                                    sutun[2]=true;
                                  }else if(i%12==3){
                                    sutun[3]=true;
                                  }else if(i%12==4){
                                    sutun[4]=true;
                                  }else if(i%12==5){
                                    sutun[5]=true;
                                  }else if(i%12==6){
                                    sutun[6]=true;
                                  }else if(i%12==7){
                                    sutun[7]=true;
                                  }else if(i%12==8){
                                    sutun[8]=true;
                                  }else if(i%12==9){
                                    sutun[9]=true;
                                  }else if(i%12==10){
                                    sutun[10]=true;
                                  }else if(i%12==11){
                                    sutun[11]=true;
                                  }else if(i%12==0){
                                    sutun[12]=true;
                                  }
                                } else {
                                  fanVisibility[i] = false;
                                }
                              }

                              String veri="";

                              for(int i=1;i<=120;i++){
                                veri=veri+fanHarita[i].toString()+"#";
                              }
                              dbHelper.veriYOKSAekleVARSAguncelle(14, "ok", veri, "0", "0");
                              
                              _veriGonder("12", "19", veri, "0", "0", "0");




                              setState(() {});
                            }

                            //-------------------------ONAY BÖLÜMÜ--------------------------------------------------
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 30,
                              ),
                              Text(
                                SelectLanguage().selectStrings(dilSecimi, "btn4"),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Haritayı Sıfırla Butonu
                      Visibility(visible: haritaOnay,
                      maintainState: true,
                      maintainSize: true,
                      maintainAnimation: true,
                                              child: FlatButton(
                          onPressed: () {

                            _resetAlert(dilSecimi);

                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.refresh,
                                size: 30,
                              ),
                              Text(
                                SelectLanguage().selectStrings(dilSecimi, "btn5"),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Verileri Gönder Butonu
                      Visibility(visible: haritaOnay,
                      maintainState: true,
                      maintainSize: true,
                      maintainAnimation: true,
                                              child: FlatButton(
                          onPressed: () {
                            bool noKontrol=false;
                            String cikisVeri="";
                            String noVeri="";
                            for(int i =1; i<=120; i++){
                              if(fanHarita[i]==2){
                                if(fanNo[i]==0 || cikisNo[i]==0){
                                  noKontrol=true;
                                }
                              }
                              cikisVeri=cikisVeri+cikisNo[i].toString()+"#";
                              noVeri=noVeri+fanNo[i].toString()+"#";
                            }
                            if(noKontrol){
                              Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast24"), context,duration: 3);
                            }else if(fanNoTekerrur){
                              Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast25"), context,duration: 3);

                            }else if(cikisNoTekerrur){
                              Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast26"), context,duration: 3);

                            }else{
                              veriGonderildi=true;
                              _veriGonder("13", "20", noVeri, cikisVeri, "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(15, "ok", noVeri, cikisVeri, "0");
                            }
                              

                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color:veriGonderildi ? Colors.green[500] : Colors.blue,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.send,
                                size: 30,
                              ),
                              Text(
                                SelectLanguage().selectStrings(dilSecimi, "btn6"),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

                        if(!veriGonderildi){
                          Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast27"), context,duration: 3);

                        }else{

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KlepeHaritasi(dilSecimi)),
                        );


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
    for(int i=0;i<=dbSatirSayisi-1;i++){
      if(satirlar[i]["id"]==0){
        dilSecimi = satirlar[i]["veri1"];
      }

      if(satirlar[i]["id"]==1){
        kurulumDurum = satirlar[i]["veri1"];
      }

      if(satirlar[i]["id"]==4){
        fanAdet = int.parse(satirlar[i]["veri1"]);
      }

      if(satirlar[i]["id"]==14){
        
      if(satirlar[i]["veri1"]=="ok"){
        String xx=satirlar[i]["veri2"];
        var fHaritalar = xx.split("#");
        for(int i=1;i<=120;i++ ){
          fanHarita[i]=int.parse(fHaritalar[i-1]);
          if(fHaritalar[i-1]!="0"){
          haritaOnay=true;
      }
      
    }

      for (int i = 1; i <= 12; i++) {
      sutun[i] = false;
    }

    for (int i = 1; i <= 120; i++) {
      if (fanHarita[i] != 0) {
        fanVisibility[i] = true;
        if(i%12==1){
          sutun[1]=true;
        }else if(i%12==2){
          sutun[2]=true;
        }else if(i%12==3){
          sutun[3]=true;
        }else if(i%12==4){
          sutun[4]=true;
        }else if(i%12==5){
          sutun[5]=true;
        }else if(i%12==6){
          sutun[6]=true;
        }else if(i%12==7){
          sutun[7]=true;
        }else if(i%12==8){
          sutun[8]=true;
        }else if(i%12==9){
          sutun[9]=true;
        }else if(i%12==10){
          sutun[10]=true;
        }else if(i%12==11){
          sutun[11]=true;
        }else if(i%12==0){
          sutun[12]=true;
        }
      } else {
        fanVisibility[i] = false;
      }
    }

    }
    
      }

      if(satirlar[i]["id"]==15){
        String xx;
      String yy;
      
      if(satirlar[i]["veri1"]=="ok"){
        veriGonderildi=true;
        xx=satirlar[i]["veri2"];
        yy=satirlar[i]["veri3"];
        var fanNolar=xx.split("#");
        var cikisNolar=yy.split("#");
        for(int i=1;i<=120;i++){
          fanNo[i]=int.parse(fanNolar[i-1]);
          cikisNo[i]=int.parse(cikisNolar[i-1]);
        }

      }
      }



    }
    

    

    print(satirlar);
    setState(() {});
  }

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/duvar_icon.png';
    } else if (deger == 2) {
      imagePath = 'assets/images/fan_on_gorunuz_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }


  Future _degergiris2X2X0() async {

    // flutter defined function

    await showDialog(
      barrierDismissible: false,

      context: context,

      builder: (BuildContext context) {

        // return object of type Dialog



        return DegerGiris2X2X0.Deger(_onlarFan,_birlerFan,_onlarOut,_birlerOut,_degerNo,_oran1,dilSecimi,"tv34");

      },

    ).then((val){
      if(_onlarFan!=val[0] || _birlerFan!=val[1] ||_onlarOut!=val[2] || _birlerOut!=val[3]){
        veriGonderildi=false;
      }
      _onlarFan=val[0];
      _birlerFan=val[1];
      _onlarOut=val[2];
      _birlerOut=val[3];
      _degerNo=val[4];

      
      fanNo[_degerNo]=int.parse(_onlarFan.toString()+_birlerFan.toString());  
      cikisNo[_degerNo]=int.parse(_onlarOut.toString()+_birlerOut.toString());
      fanNoTekerrur=false;
      cikisNoTekerrur=false;

      for(int i=1;i<=120;i++){
        
        for(int k=1;k<=120;k++){
          if(i!=k && fanNo[i]==fanNo[k] && fanNo[i]!=0 && fanNo[k]!=0){
            fanNoTekerrur=true;
            break;
          }
          if(fanNoTekerrur){
            break;
          }
          if(i!=k && cikisNo[i]==cikisNo[k] && cikisNo[i]!=0 && cikisNo[k]!=0){
            cikisNoTekerrur=true;
            break;
          }
          if(cikisNoTekerrur){
            break;
          }
        }
      }
      
      
      

      setState(() {

      });
    });

  }


  Widget _fanHaritaUnsur (int indexNo){

    return Expanded(
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[                    
                                    
                                    Expanded(flex: 6,
                                      child: RawMaterialButton(
                                        onPressed: () {

                                         

                                          if(haritaOnay){
                                            _onlarFan=fanNo[indexNo]<10 ? 0 : (fanNo[indexNo]~/10).toInt();
                                            _birlerFan=fanNo[indexNo]%10;
                                            _onlarOut=cikisNo[indexNo]<10 ? 0 : (cikisNo[indexNo]~/10).toInt();
                                            _birlerOut=cikisNo[indexNo]%10;
                                            _degerNo=indexNo;
                                            _degergiris2X2X0();
                                          }else{

                                            if (fanHarita[indexNo] == 0 ||
                                              fanHarita[indexNo] == null) {
                                            fanHarita[indexNo] = 1;
                                          } else if (fanHarita[indexNo] == 1) {
                                            fanHarita[indexNo] = 2;
                                          } else if (fanHarita[indexNo] == 2) {
                                            fanHarita[indexNo] = 0;
                                          }

                                          setState(() {});

                                          }

                                        

                                        },
                                        child: Stack(children: <Widget>[


                                          Opacity(
                                            child: Container(
                                            decoration: BoxDecoration(//color: Colors.pink,
                                              image: DecorationImage(
                                                alignment: Alignment.center,
                                                image: AssetImage(
                                                    imageGetir(fanHarita[indexNo])),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                        ),
                                         opacity: fanVisibility[indexNo] && haritaOnay && fanHarita[indexNo]==2 ? 0.6 : 1,
                                          ),
                                          
                                          Visibility(
                                          visible: haritaOnay && fanHarita[indexNo] !=0
                                              ? true
                                              : false,
                                          child: Visibility(
                                            visible: haritaOnay && fanHarita[indexNo] == 2
                                                ? true
                                                : false,
                                             child: Column(
                                              children: <Widget>[
                                                Spacer(),
                                                //Fan No
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.bottomCenter,
                                                            child: AutoSizeText(
                                                              SelectLanguage().selectStrings(dilSecimi, "tv32")+fanNo[indexNo].toString(),
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:
                                                                      'Kelly Slab'),
                                                              maxLines: 1,
                                                              minFontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),],
                                                  ),
                                                ),
                                                //Çıkış No
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.topCenter,
                                                            child: AutoSizeText(
                                                              SelectLanguage().selectStrings(dilSecimi, "tv33")+cikisNo[indexNo].toString(),
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:
                                                                      'Kelly Slab'),
                                                              maxLines: 1,
                                                              minFontSize: 8,
                                                            ),
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
                                   

                                        ],)
                                        
                                        
                                        ),
                                    ),
                                  ],
                                ),
                              )
                            ;

  }


_veriGonder(String dbKod,String id, String v1, String v2, String v3, String v4) async {
    Socket socket;

    try {
      socket = await Socket.connect('192.168.2.110', 2233);
      String gelen_mesaj = "";

      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
        print(utf8.decode(event));
        gelen_mesaj = utf8.decode(event);
        var gelen_mesaj_parcali = gelen_mesaj.split("*");

        if (gelen_mesaj_parcali[0] == 'ok') {
          Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast8"), context, duration: 2);
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


Future _resetAlert(String x) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return ResetAlert.deger(x);
      },
    ).then((val){

      if(val){
        

                            veriGonderildi=false;
                            for (int i = 1; i <= 120; i++) {
                              fanHarita[i] = 0;
                              fanNo[i]=0;
                              cikisNo[i]=0;
                              fanVisibility[i] = true;
                            }
                            for (int i = 1; i <= 12; i++) {
                                sutun[i] = true;
                              }
                            haritaOnay = false;

                            
                              dbHelper.veriYOKSAekleVARSAguncelle(14, "0", "0", "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(15, "0", "0", "0", "0");
                              _veriGonder("14", "0", "0", "0", "0", "0");

                          setState(() {});

                          
      }
      
    });
  }

//--------------------------METOTLAR--------------------------------

}
