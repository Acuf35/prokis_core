import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheet2x0.dart';
import 'package:prokis/mywidgets/showModalBottomSheetQ%20.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/alert_reset.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sayfa_geri_alert.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'isitici_haritasi.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';
import 'silo_haritasi.dart';


class BacafanHaritasi extends StatelessWidget {
  bool ilkKurulumMu = true;
  BacafanHaritasi(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  int sayac=0;
  
  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;

    return ChangeNotifierProvider<BacafanHaritasiProvider>(
          create: (context) => BacafanHaritasiProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){

              final provider = Provider.of<BacafanHaritasiProvider>(context);

              if(sayac==0){
                new Timer(Duration(seconds: 0, milliseconds: 1000), (){
                  provider.setsayac=1;
                  sayac++;
                });
              }


              return Scaffold(
      floatingActionButton: MyFloatingActionBackButton(
      !ilkKurulumMu,
      !provider.getveriGonderildi,
      oran,
      40,
      Colors.grey[700],
      Colors.white,
      Icons.arrow_back,
      1,
      "tv564"),
    
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      Dil().sec(dilSecimi, "tv68"),
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
            ],
          ),
          alignment: Alignment.center,
        )),
        //bacafan Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 12,
                  child: Column(
                    children: <Widget>[
                      //Bacafan çıkış tercihleri bölümü
                      Expanded(
                        flex: 10,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv66"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        maxLines: 3,
                                                        minFontSize: 8,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(alignment: Alignment.topCenter,
                                                    child: RawMaterialButton(
                                                      
                                          onPressed: () {

                                            if (!provider.getdijitalCikis) {
                                              provider.setdijitalCikis=true;
                                              provider.setanalogCikis=false;
                                              provider.setveriGonderildi=false;
                                            }

                                          },
                                          child: Icon(
                                            provider.getdijitalCikis
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: provider.getdijitalCikis
                                                ? Colors.green[600]
                                                : Colors.blue[700],
                                            size: 30 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                  ),
                                                ),
                                                //Spacer(flex: 1,)
                                              ],
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv67"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        maxLines: 3,
                                                        minFontSize: 8,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(alignment: Alignment.topCenter,
                                                    child: RawMaterialButton(
                                                      
                                          onPressed: () {

                                            if (!provider.getanalogCikis) {
                                              provider.setdijitalCikis=false;
                                              provider.setanalogCikis=true;
                                              provider.listIslem(provider.getcikisNo, null, 3, 1, 0, 4);

                                              provider.setveriGonderildi=false;
                                            }

                                          },
                                          child: Icon(
                                            provider.getanalogCikis
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: provider.getanalogCikis
                                                ? Colors.green[600]
                                                : Colors.blue[700],
                                            size: 30 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                  ),
                                                ),
                                                //Spacer(flex: 1,)
                                              ],
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 4,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(flex: 2,
                                        child: Visibility(visible: provider.getanalogCikis,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.bottomCenter,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv492"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        color: Colors.grey[600],
                                                        fontSize: 60,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      maxLines: 3,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(alignment: Alignment.topCenter,
                                                  child: RawMaterialButton(
                                                    
                                      onPressed: () {

                                          if (provider.getcikisTur!="1") {
                                            provider.setcikisTur="1";
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                          provider.getcikisTur=="1"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: provider.getcikisTur=="1"
                                              ? Colors.green[600]
                                              : Colors.black,
                                          size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                                ),
                                              ),
                                              //Spacer(flex: 1,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    
                                    Expanded(flex: 2,
                                        child: Visibility(visible: provider.getanalogCikis,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.bottomCenter,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv493"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        color: Colors.grey[600],
                                                        fontSize: 60,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      maxLines: 3,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(alignment: Alignment.topCenter,
                                                  child: RawMaterialButton(
                                                    
                                      onPressed: () {

                                          if (provider.getcikisTur!="2") {
                                            provider.setcikisTur="2";
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                          provider.getcikisTur=="2"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: provider.getcikisTur=="2"
                                              ? Colors.green[600]
                                              : Colors.black,
                                          size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                                ),
                                              ),
                                              //Spacer(flex: 1,)
                                            ],
                                          ),
                                        ),
                                      ),
                              
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(flex: 6,
                                child: Visibility(visible: provider.getanalogCikis ? false: true,
                                                                  child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        _bacaFanGrupCikis(1, oran, provider, provider.getbacafanAdet==1, context),
                                        Spacer(),
                                      ],
                                    ),
                                ),
                              ),
                              Spacer(),
                              Expanded(flex: 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv624"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        maxLines: 3,
                                                        minFontSize: 6,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(alignment: Alignment.topCenter,
                                                    child: RawMaterialButton(
                                                      
                                          onPressed: () {

                                            if (!provider.getbacafanKapakVarMi) {
                                              provider.setbacafanKapakVarMi=true;
                                              provider.setveriGonderildi=false;
                                            }else{
                                              provider.setbacafanKapakVarMi=false;
                                              provider.listIslem(provider.getcikisNo, null, 3, 2, 0, 4);
                                              provider.listIslem(provider.getcikisNo, null, 3, 3, 0, 4);
                                            }
                                            
                                            
                                          },
                                          child: Icon(
                                            provider.getbacafanKapakVarMi
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: provider.getbacafanKapakVarMi
                                                ? Colors.green[600]
                                                : Colors.blue[700],
                                            size: 30 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                  ),
                                                ),
                                                //Spacer(flex: 1,)
                                              ],
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 6,
                                child: Visibility(visible: provider.getbacafanKapakVarMi,
                                  child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        _bacaFanGrupCikis(2, oran, provider, provider.bacafanKapakVarMi, context),
                                        Spacer(),
                                      ],
                                    ),
                                ),
                              ),
                              Spacer(),
                              Expanded(flex: 6,
                                child: Visibility(visible: provider.getbacafanKapakVarMi,
                                  child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        _bacaFanGrupCikis(3, oran, provider, provider.bacafanKapakVarMi, context),
                                        Spacer(),
                                      ],
                                    ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),

                      //Sensor Konumları Bölümü
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv57"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv58"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 27,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/bina_catili_ust_gorunum.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(
                                          flex: 10,
                                          child: Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        1, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        2, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        3, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        4, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        5, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        6, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        7, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        8, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        9, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        10, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        11, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        12, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        13, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        14, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        15, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        16, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        17, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        18, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        19, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        20, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        21, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        22, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        23, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        24, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        25, oran, "tv64", 1, provider,context),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        26, oran, "tv64", 1, provider,context),
                                                  ],
                                                ),
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv59"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                ),

                Metotlar().cikislariGetir(provider.gettumCikislar, oranOzel, oran, 6, provider.getharitaOnay, sayac, dilSecimi),
              
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
                      Visibility(
                        visible: !provider.getharitaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                            bool seciliHeaterVarmi = false;
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast8"),
                                context,
                                duration: 3);
                            provider.setharitaOnay = true;
                            int no=0;
                            for (int i = 1; i <= 26; i++) {
                              if (provider.getbacafanHarita[i] != 0) {
                                provider.listIslem(provider.getbacafanVisibility, null, 3, i, true, null);

                                seciliHeaterVarmi = true;
                                no++;
                                provider.listIslem(provider.getbacafanNo, null, 3, i, no, null);
                                
                              } else {
                                provider.listIslem(provider.getbacafanVisibility, null, 3, i, false, null);
                              }
                            }

                            String veri = "";

                            for (int i = 1; i <= 26; i++) {
                              veri = veri + provider.getbacafanHarita[i].toString() + "#";
                            }

                            if (!seciliHeaterVarmi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast53"),
                                  context,
                                  duration: 3);
                            } else {

                              Metotlar().veriGonder("26*28*$veri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                if(value=="ok"){
                                  dbProkis.dbSatirEkleGuncelle(23, "ok", veri, "0", "0");
                                }
                              });

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
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn4"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Haritayı Sıfırla Butonu
                      Visibility(
                        visible: provider.getharitaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            _resetAlert(dilSecimi,context,provider,dbProkis);
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.refresh,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn5"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Verileri Gönder Butonu
                      Visibility(
                        visible: provider.getharitaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            bool noKontrol1 = false;
                            bool noKontrol2 = false;
                            bool cikisKullanimda = false;
                            String noVeri = "";
                            String cikisNolar = "";
                            String cikisTurSecimi = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 26; i++) {
                              if (provider.getbacafanHarita[i] == 1) {
                                if (provider.getbacafanNo[i] == 0) {
                                  noKontrol1 = true;
                                }
                              }
                              noVeri = noVeri + provider.getbacafanNo[i].toString() + "#";
                            }
                            for (int i = 1; i <= 3; i++) {
                              if (provider.getcikisNo[i] == 0 && provider.getbacafanAdet >= i) {
                                if(i==1){
                                  if(!provider.getanalogCikis){
                                    noKontrol2 = true;
                                  }
                                  
                                }else if(i!=1 && provider.getbacafanKapakVarMi){
                                  noKontrol2 = true;
                                }

                              }

                              cikisNolar =
                                  cikisNolar + provider.getcikisNo[i].toString() + "#";
                            }

                            cikisTurSecimi=(provider.getdijitalCikis ? "1" : "0") + "*" + (provider.getanalogCikis ? "1" : "0")+"*"+provider.getcikisTur+"*"+(provider.getbacafanKapakVarMi ? "1" : "0");

                            for (int i = 1; i <= 3; i++) {
                              if (provider.getcikisNoGecici[i] != provider.getcikisNo[i]) {
                                if (provider.gettumCikislar[provider.getcikisNo[i]] == 0) {
                                  provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNoGecici[i], 0, null);
                                } else {
                                  cikisKullanimda = true;
                                }
                              }
                            }

                            if (noKontrol1) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast39"),
                                  context,
                                  duration: 3);
                            }
                            else if (noKontrol2) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast63"),
                                  context,
                                  duration: 3);
                            } else if (provider.getcikisNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast26"),
                                  context,
                                  duration: 3);
                            } else if (cikisKullanimda) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast38"),
                                  context,
                                  duration: 3);
                            } else {

                              for (int i = 1; i <= 3; i++) {
                                if (provider.getcikisNo[i] != 0) {
                                  provider.listIslem(provider.gettumCikislar, null, 3, provider.getcikisNo[i], 1, null);
                                }
                              }

                              for (int i = 1; i <= 110; i++) {
                                tumCikislarVeri = tumCikislarVeri +
                                    provider.gettumCikislar[i].toString() +
                                    "#";
                              }
                              provider.setveriGonderildi = true;
                              String komut="27*29*$noVeri*$cikisNolar*$cikisTurSecimi*0";
                              Metotlar().veriGonder(komut, context, 2233, "toast8", dilSecimi).then((value){
                                if(value=="ok"){
                                  Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233, "toast8", dilSecimi).then((value){
                                    if(value=="ok"){
                                      dbProkis.dbSatirEkleGuncelle(24, "ok", noVeri, cikisNolar, cikisTurSecimi);
                                      dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
                                    }
                                  });
                                }
                              });

                
                              provider.listIslem(null, null, 6, null, null, 4);
                            
                            }
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color:
                              provider.getveriGonderildi ? Colors.green[500] : Colors.blue,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.send,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn6"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
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
                    child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IsiSensorHaritasi(true)),
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
                    child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          if (!provider.getharitaOnay) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast62"),
                                context,
                                duration: 3);
                          } else if (!provider.getveriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                            if(provider.getairinletAdet!='0' || provider.getsirkfanVarMi){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AirInletVeSirkFan(true)),
                              );
                            }else if(provider.getisiticiAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiticiHaritasi(true)),
                              );
                            }else if(provider.getsiloAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SiloHaritasi(true)),
                              );
                            }else{

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DigerCikislar(true)),
                              );
                            }

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
    ));
            }
          )
    );
  }

  
  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/harita_bacafan_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Widget _bacafanHaritaUnsur(
      int indexNo, double oran, String baslik, int degerGirisKodu, BacafanHaritasiProvider provider, BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: provider.getbacafanVisibility[indexNo] ? true : false,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: RawMaterialButton(
                  onPressed: () {
                    if (provider.getharitaOnay) {

                int sayi = provider.getbacafanNo[indexNo];
                int pOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                int pBirler = sayi % 10;

                MyshowModalBottomSheet2x0(dilSecimi, context, oran,pOnlar, pBirler,"tv49","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {
                              sayi =value[1] * 10 + value[2];
                              provider.listIslem(provider.getbacafanNo, null, 3, indexNo, sayi, null);
                          }

                });


                    } else {

                      List<int> xx = provider.bacafanHarita;
                      if (xx[indexNo] == 0 ||
                          xx[indexNo] == null) {
                        xx[indexNo] = 1;
                        provider.dinlemeyiTetikle();
                      } else if (xx[indexNo] == 1) {
                        xx[indexNo] = 0;
                        provider.dinlemeyiTetikle();
                      }
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(
                                imageGetir(provider.getbacafanHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.getharitaOnay && provider.getbacafanHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            //bacafan No
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          Dil().sec(
                                                  dilSecimi, "tv72") +
                                              provider.getbacafanNo[indexNo].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab'),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
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
                  )),
            ),
          ],
        ),
      ),
    );
  }

  
  Future _resetAlert(String x,BuildContext context, BacafanHaritasiProvider provider, DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return ResetAlert.deger(x);
      },
    ).then((val) {
      if (val) {
        provider.setveriGonderildi = false;
        String tumCikislarVeri = "";

        provider.listIslem(provider.tumCikislar, provider.getcikisNo, 4, 0, 0, 4);


        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + provider.gettumCikislar[i].toString() + "#";
        }

        provider.listIslem(provider.getbacafanHarita, null, 2, 0, 0, 27);
        provider.listIslem(provider.getbacafanNo, null, 2, 0, 0, 27);
        provider.listIslem(provider.getcikisNo, null, 2, 0, 0, 4);
        provider.listIslem(provider.getbacafanVisibility, null, 2, 0, true, 27);
        provider.setharitaOnay = false;

        provider.setdijitalCikis=true;
        provider.setanalogCikis=false;
        provider.setbacafanKapakVarMi=false;
        provider.setcikisTur="1";

        Metotlar()
            .veriGonder("28*0*0*0*0*0", context, 2233, "toast8", dilSecimi)
            .then((value) {
          Metotlar()
              .veriGonder("25*27*$tumCikislarVeri*0*0*0", context, 2233,
                  "toast8", dilSecimi)
              .then((value) {
            dbProkis.dbSatirEkleGuncelle(23, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(24, "0", "0", "0", "0");
            dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
          });
        });
      }
    });
  }

  Widget _bacaFanGrupCikis(int index, double oran, BacafanHaritasiProvider provider, bool visible, BuildContext context) {
    return Expanded(
      flex: 4,
      child: Visibility(
        visible: visible,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Expanded(flex: 4,
              child: SizedBox(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: AutoSizeText(
                    Dil().sec(dilSecimi,
                  index == 1 ? "tv65" : (index == 2 ? "tv625" : "tv626")),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Kelly Slab',
                      color: Colors.grey[600],
                      fontSize: 60,
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 3,
                    minFontSize: 8,
                  ),
                ),
              ),
            ),
            Expanded(flex: 5,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: RawMaterialButton(
                      onPressed: () {

                String outNoMetin = provider.getcikisNo[index] == 0
                    ? "Q0.0"
                    : Metotlar()
                        .outConvSAYItoQ(provider.getcikisNo[index]);
                int qByteOnlar = int.parse(outNoMetin.length > 4
                    ? outNoMetin.substring(1, 2)
                    : "0");
                int qByteBirler = int.parse(outNoMetin.length > 4
                    ? outNoMetin.substring(2, 3)
                    : outNoMetin.substring(1, 2));
                int qBit =
                    int.parse(outNoMetin.substring(outNoMetin.length - 1));

                MyshowModalBottomSheetQ(dilSecimi, context, oran,
                        qByteOnlar, qByteBirler, qBit,"tv46","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {

                            
                            outNoMetin = "Q" + (value[1] == 0 ? "" : value[1].toString()) + value[2].toString() + "." + value[3].toString();
                            int cikisNo = Metotlar().outConvQtoSAYI(outNoMetin);



                            if (cikisNo == 0) {
                              Toast.show(Dil().sec(dilSecimi, "toast92"), context, duration: 3);
                            } else {

                              provider.listIslem(provider.getcikisNo, null, 3, index, cikisNo, null);

                            }



                          }


                });

                            
                      },
                      fillColor: Colors.green[300],
                      child: Padding(
                        padding: EdgeInsets.all(3.0 * oran),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Metotlar().outConvSAYItoQ(provider.getcikisNo[index]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab'),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      constraints: BoxConstraints(minWidth: double.infinity),
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


 Future _sayfaGeriAlert(String dilSecimi, String uyariMetni, BuildContext context) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SayfaGeriAlert.deger(dilSecimi,uyariMetni);
      },
    ).then((val) {
      if (val) {

        if(val){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KurulumAyarlari()),
          );

        }


      }
    });
  }



}

class BacafanHaritasiProvider with ChangeNotifier {
  int sayac=0;

 List<int> bacafanHarita = new List.filled(27,0);
  List<bool> bacafanVisibility = new List.filled(27,true);
  List<int> bacafanNo = new List.filled(27,0);
  List<int> cikisNo = new List.filled(4,0);
  List<int> cikisNoGecici = new List.filled(4,0);
  bool haritaOnay = false;
  int bacafanAdet = 0;
  bool sirkfanVarMi = false;
  String airinletAdet = '0';
  String isiticiAdet = '0';
  String siloAdet = '0';

  int bfanCikisNo=0;
  
  bool dijitalCikis=true;
  bool analogCikis=false;
  String cikisTur="1";    //1:0-10V   2:4-20mA
  bool bacafanKapakVarMi=false;

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List.filled(111,0);

  listIslem(List list, List<int> aktarilacaklist, int islemTuru, int index, var value, int listLenght) {

    switch(islemTuru){
      case 1:
      list=List.from(aktarilacaklist);
      break;
      case 2:
      for (int i = 0; i < listLenght; i++) {
        list[i]=value;
      }
      break;
      case 3:
      list[index]=value;
      break;
      case 4:
      for (int i = 1; i < listLenght; i++) {
          if (aktarilacaklist[i] != 0) {
            list[aktarilacaklist[i]] = 0;
          }
        }
      break;
      case 5:
      cikisNoTekerrur = false;

      for (int i = 1; i <= 3; i++) {
        for (int k = 1; k <= 3; k++) {
          if (i != k &&
              cikisNo[i] == cikisNo[k] &&
              cikisNo[i] != 0 &&
              cikisNo[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
          if (cikisNoTekerrur) {
            break;
          }
        }
      }
      break;
      case 6:
      for (int i = 0; i < listLenght; i++) {
        cikisNoGecici[i]=cikisNo[i];
      }
      break;

    }
    
    notifyListeners();
  }

  dinlemeyiTetikle(){
    notifyListeners();
  }

  int get getsayac => sayac;

  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }

  List<int> get getbacafanHarita => bacafanHarita;
  List<bool> get getbacafanVisibility => bacafanVisibility;
  List<int> get getbacafanNo => bacafanNo;
  List<int> get getcikisNo => cikisNo;
  List<int> get getcikisNoGecici => cikisNoGecici;
  List<int> get gettumCikislar => tumCikislar;

  bool get getharitaOnay => haritaOnay;

  set setharitaOnay(bool value) {
    haritaOnay = value;
    notifyListeners();
  }

  int get getbacafanAdet => bacafanAdet;

  set setbacafanAdet(int value) {
    bacafanAdet = value;
    notifyListeners();
  }

  String get getairinletAdet => airinletAdet;

  set setairinletAdet(String value) {
    airinletAdet = value;
    notifyListeners();
  }

  String get getisiticiAdet => isiticiAdet;

  set setisiticiAdet(String value) {
    isiticiAdet = value;
    notifyListeners();
  }

  String get getsiloAdet => siloAdet;

  set setsiloAdet(String value) {
    siloAdet = value;
    notifyListeners();
  }

  bool get getsirkfanVarMi => sirkfanVarMi;

  set setsirkfanVarMi(bool value) {
    sirkfanVarMi = value;
    notifyListeners();
  }

  bool get getveriGonderildi => veriGonderildi;

  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }

  bool get getcikisNoTekerrur => cikisNoTekerrur;

  set setcikisNoTekerrur(bool value) {
    cikisNoTekerrur = value;
    notifyListeners();
  }

  int get getbfanCikisNo => bfanCikisNo;

  set setbfanCikisNo(int value) {
    bfanCikisNo = value;
    notifyListeners();
  }

  bool get getdijitalCikis => dijitalCikis;

  set setdijitalCikis(bool value) {
    dijitalCikis = value;
    notifyListeners();
  }

  bool get getanalogCikis => analogCikis;

  set setanalogCikis(bool value) {
    analogCikis = value;
    notifyListeners();
  }

  String get getcikisTur => cikisTur;

  set setcikisTur(String value) {
    cikisTur = value;
    notifyListeners();
  }

  bool get getbacafanKapakVarMi => bacafanKapakVarMi;

  set setbacafanKapakVarMi(bool value) {
    bacafanKapakVarMi = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  BacafanHaritasiProvider(this.context, this.dbProkis) {


    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = int.parse(yy[0]);
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet=dbProkis.dbVeriGetir(5, 4, "0");


    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String haritaKAYIT = dbProkis.dbVeriGetir(23, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(24, 1, "");
    var tcikislar;
    var fHaritalar;
    var bacafanNolar;
    var bacafanCikis;
    var bacafanAnalogVeKapakVeri;
    

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (haritaKAYIT == "ok") {
      fHaritalar = dbProkis.dbVeriGetir(23, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      bacafanNolar = dbProkis.dbVeriGetir(24, 2, "").split("#");
      bacafanCikis = dbProkis.dbVeriGetir(24, 3, "").split("#");
      bacafanAnalogVeKapakVeri = dbProkis.dbVeriGetir(24, 4, "").split("*");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i-1]);
      }
    }

    for (var i = 1; i <= 26; i++) {

      if (haritaKAYIT == "ok") {
        bacafanHarita[i] = int.parse(fHaritalar[i - 1]);
        if (fHaritalar[i - 1] != "0") {
          haritaOnay = true;
          bacafanVisibility[i] = true;
        }else{
          bacafanVisibility[i] = false;
        }
      }

      if(cikisKAYIT=="ok"){
        bacafanNo[i] = int.parse(bacafanNolar[i - 1]);
      }
    }

    if (cikisKAYIT == "ok") {
      for (var i = 1; i <= 3; i++) {
        cikisNo[i] = int.parse(bacafanCikis[i - 1]);
        cikisNoGecici[i]=cikisNo[i];
      }
      dijitalCikis=bacafanAnalogVeKapakVeri[0]=="1" ? true :false;
      analogCikis=bacafanAnalogVeKapakVeri[1]=="1" ? true :false;
      cikisTur=bacafanAnalogVeKapakVeri[2];
      bacafanKapakVarMi=bacafanAnalogVeKapakVeri[3]=="1" ? true :false;
    }
    

    
  }
  
}
