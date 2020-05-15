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
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'isitici_haritasi.dart';
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
                  Spacer(flex: 2,),
                  Expanded(flex: 10,
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
            )),
        //bacafan Harita Oluşturma Bölümü
        Expanded(
          flex: 9,
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

                                            if (!provider.dijitalCikis) {
                                              provider.setdijitalCikis=true;
                                              provider.setanalogCikis=false;
                                              provider.setveriGonderildi=false;
                                            }

                                          },
                                          child: Icon(
                                            provider.dijitalCikis
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: provider.dijitalCikis
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

                                            if (!provider.analogCikis) {
                                              provider.setdijitalCikis=false;
                                              provider.setanalogCikis=true;
                                              provider.cikisNo[1]=0;
                                              provider.setveriGonderildi=false;
                                            }

                                          },
                                          child: Icon(
                                            provider.analogCikis
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: provider.analogCikis
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
                                        child: Visibility(visible: provider.analogCikis,
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

                                          if (provider.cikisTur!="1") {
                                            provider.setcikisTur="1";
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                          provider.cikisTur=="1"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: provider.cikisTur=="1"
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
                                        child: Visibility(visible: provider.analogCikis,
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

                                          if (provider.cikisTur!="2") {
                                            provider.setcikisTur="2";
                                            provider.setveriGonderildi=false;
                                          }
                                      },
                                      child: Icon(
                                          provider.cikisTur=="2"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: provider.cikisTur=="2"
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
                                child: Visibility(visible: provider.analogCikis ? false: true,
                                                                  child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        _bacaFanGrupCikis(1, oran, provider, provider.bacafanAdet==1, context),
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

                                            if (!provider.bacafanKapakVarMi) {
                                              provider.setbacafanKapakVarMi=true;
                                              provider.setveriGonderildi=false;
                                            }else{
                                              provider.setbacafanKapakVarMi=false;
                                              provider.cikisNo[2]=0;
                                              provider.cikisNo[3]=0;
                                            }
                                            
                                            
                                          },
                                          child: Icon(
                                            provider.bacafanKapakVarMi
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: provider.bacafanKapakVarMi
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
                                              ],
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 6,
                                child: Visibility(visible: provider.bacafanKapakVarMi,
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
                                child: Visibility(visible: provider.bacafanKapakVarMi,
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

                Metotlar().cikislariGetir(provider.tumCikislar, oranOzel, oran, 6, provider.haritaOnay, sayac, dilSecimi),
              
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
                //Spacer(),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Haritayı Onayla Butonu
                      Visibility(
                        visible: !provider.haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                            bool seciliHeaterVarmi = false;
                            
                            int no=0;
                            for (int i = 1; i <= 26; i++) {
                              if (provider.bacafanHarita[i] != 0) {
                                seciliHeaterVarmi = true;
                                break;
                              }
                            }


                            String veri = "";

                            for (int i = 1; i <= 26; i++) {
                              veri = veri + provider.bacafanHarita[i].toString() + "#";
                            }

                            if (!seciliHeaterVarmi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast53"),
                                  context,
                                  duration: 3);
                            } else {


                              for (int i = 1; i <= 26; i++) {
                                if (provider.bacafanHarita[i] != 0) {
                                  provider.bacafanVisibility[i]=true;
                                  no++;
                                  provider.bacafanNo[i]=no;
                                } else {
                                  provider.bacafanVisibility[i]=false;
                                }
                              }

                              provider.tekerrurTespit();

                              Metotlar().veriGonder("26*28*$veri*0*0*0", 2233).then((value){
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                }else{
                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                  dbProkis.dbSatirEkleGuncelle(23, "ok", veri, "0", "0");
                                }
                              });

                              provider.setharitaOnay = true;

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
                        visible: provider.haritaOnay,
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
                        visible: provider.haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            bool sifirNoVarMi = false;
                            bool atanmamisCikisVarMi = false;
                            bool cikisKullanimda = false;
                            String noVeri = "";
                            String cikisNolar = "";
                            String cikisTurSecimi = "";
                            String tumCikislarVeri = "";


                            for (int i = 1; i <= 26; i++) {
                              if (provider.bacafanHarita[i] == 1) {
                                if (provider.bacafanNo[i] == 0) {
                                  sifirNoVarMi = true;
                                }
                              }
                              noVeri = noVeri + provider.bacafanNo[i].toString() + "#";
                            }

                            if(provider.dijitalCikis && provider.cikisNo[1]==0){
                              atanmamisCikisVarMi=true;
                            }
                            if(provider.bacafanKapakVarMi){
                              if(provider.cikisNo[1]==0 || provider.cikisNo[2]==0){
                                atanmamisCikisVarMi=true;
                              }
                            }


                            for (int i = 1; i <= 3; i++) {
                              cikisNolar =
                                  cikisNolar + provider.cikisNo[i].toString() + "#";
                            }

                            cikisTurSecimi=(provider.dijitalCikis ? "1" : "0") + "*" + (provider.analogCikis ? "1" : "0")+"*"+provider.cikisTur+"*"+(provider.bacafanKapakVarMi ? "1" : "0");

                            for (int i = 1; i <= 3; i++) {
                              if (provider.cikisNoGecici[i] != provider.cikisNo[i]) {
                                if (provider.tumCikislar[provider.cikisNo[i]] == 0) {
                                  provider.tumCikislar[provider.cikisNoGecici[i]]=0;
                                } else {
                                  cikisKullanimda = true;
                                }
                              }
                            }

                            if (sifirNoVarMi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast39"),
                                  context,
                                  duration: 3);
                            }else if (atanmamisCikisVarMi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast97"),
                                  context,
                                  duration: 3);
                            }else if (provider.bacafanNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast96"),
                                  context,
                                  duration: 3);
                            } else if (provider.cikisNoTekerrur) {
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
                                if (provider.cikisNo[i] != 0) {
                                  provider.tumCikislar[provider.cikisNo[i]]=1;
                                }
                              }

                              for (int i = 1; i <= 110; i++) {
                                tumCikislarVeri = tumCikislarVeri +
                                    provider.tumCikislar[i].toString() +
                                    "#";
                              }
                              
                              String komut="27*29*$noVeri*$cikisNolar*$cikisTurSecimi*0";
                              Metotlar().veriGonder(komut, 2233).then((value){
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                }else{
                                  Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", 2233).then((value){
                                    if(value.split("*")[0]=="error"){
                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                    }else{
                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                      dbProkis.dbSatirEkleGuncelle(24, "ok", noVeri, cikisNolar, cikisTurSecimi);
                                      dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
                                    }
                                  });
                                }
                              });
                              
                              for (int i = 0; i < 4; i++) {
                                provider.cikisNoGecici[i]=provider.cikisNo[i];
                              }
                              provider.setveriGonderildi = true;

                            }
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color:
                              provider.veriGonderildi ? Colors.green[500] : Colors.blue,
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
                          if (!provider.haritaOnay) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast62"),
                                context,
                                duration: 3);
                          } else if (!provider.veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                            if(provider.airinletAdet!='0' || provider.sirkfanVarMi){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AirInletVeSirkFan(true)),
                              );
                            }else if(provider.isiticiAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiticiHaritasi(true)),
                              );
                            }else if(provider.siloAdet!='0'){

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
                            Dil().sec(dilSecimi, "tv68"), 
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
                                        text: Dil().sec(dilSecimi, "info32"),
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
        visible: provider.bacafanVisibility[indexNo] ? true : false,
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
                    if (provider.haritaOnay) {

                int sayi = provider.bacafanNo[indexNo];
                int pOnlar = sayi < 10 ? 0 : sayi ~/ 10;
                int pBirler = sayi % 10;

                MyshowModalBottomSheet2x0(dilSecimi, context, oran,pOnlar, pBirler,"tv49","tv35")
                    .then((value) {

                          bool gelenVeri=value==null ? false : value[0];

                          if (gelenVeri) {
                              sayi =value[1] * 10 + value[2];
                              provider.bacafanNo[indexNo]=sayi;
                              provider.tekerrurTespit();
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
                                imageGetir(provider.bacafanHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.haritaOnay && provider.bacafanHarita[indexNo] != 0
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
                                              provider.bacafanNo[indexNo].toString(),
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

        for (int i = 0; i < 4; i++) {
          provider.cikisNo[i]=provider.cikisNoGecici[i];
        }

        for (int i = 1; i < 4; i++) {
          if (provider.cikisNo[i] != 0) {
            provider.tumCikislar[provider.cikisNo[i]] = 0;
          }
        }


        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + provider.tumCikislar[i].toString() + "#";
        }

        for (int i = 0; i < 27; i++) {
          provider.bacafanHarita[i]=0;
          provider.bacafanNo[i]=0;
          provider.bacafanVisibility[i]=true;
        }

        for (int i = 1; i < 4; i++) {
          provider.cikisNo[i]=0;
        }

        provider.setharitaOnay = false;
        provider.setdijitalCikis=true;
        provider.setanalogCikis=false;
        provider.setbacafanKapakVarMi=false;
        provider.setcikisTur="1";

        Metotlar().veriGonder("28*0*0*0*0*0", 2233).then((value) {
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", 2233).then((value) {
              if(value.split("*")[0]=="error"){
                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
              }else{
                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                dbProkis.dbSatirEkleGuncelle(23, "0", "0", "0", "0");
                dbProkis.dbSatirEkleGuncelle(24, "0", "0", "0", "0");
                dbProkis.dbSatirEkleGuncelle(22, "ok", tumCikislarVeri, "0", "0");
              }
            });
          }
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

                    String outNoMetin = Metotlar().outConvSAYItoQ(provider.cikisNo[index]);
                    int qByteOnlar;
                    int qByteBirler;
                    int qBit;

                    if(outNoMetin=="Q#.#"){
                      qByteOnlar =0;
                      qByteBirler =0;
                      qBit =0;
                    }else{

                      qByteOnlar = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(1, 2)
                          : "0");
                      qByteBirler = int.parse(outNoMetin.length > 4
                          ? outNoMetin.substring(2, 3)
                          : outNoMetin.substring(1, 2));
                      qBit =
                          int.parse(outNoMetin.substring(outNoMetin.length - 1));
                    }

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

                              
                              provider.cikisNo[index]=cikisNo;
                              provider.tekerrurTespit();

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
                                    Metotlar().outConvSAYItoQ(provider.cikisNo[index]),
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
  bool bacafanNoTekerrur = false;

  BuildContext context;
  DBProkis dbProkis;

  List<int> tumCikislar = new List.filled(111,0);

  
  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(){
    cikisNoTekerrur = false;
      bacafanNoTekerrur = false;

      for (int i = 1; i <= 26; i++) {
        for (int k = 1; k <= 26; k++) {
          if (i != k &&
              bacafanNo[i] == bacafanNo[k] &&
              bacafanNo[i] != 0 &&
              bacafanNo[k] != 0) {
            bacafanNoTekerrur = true;
            break;
          }
        }
        if (bacafanNoTekerrur) {
            break;
          }
      }

      for (int i = 1; i <= 3; i++) {
        for (int k = 1; k <= 3; k++) {
          if (i != k &&
              cikisNo[i] == cikisNo[k] &&
              cikisNo[i] != 0 &&
              cikisNo[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
        }
        if (cikisNoTekerrur) {
            break;
          }
      }


      notifyListeners();
  }

  

  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }
  set setharitaOnay(bool value) {
    haritaOnay = value;
    notifyListeners();
  }
  set setbacafanAdet(int value) {
    bacafanAdet = value;
    notifyListeners();
  }
  set setairinletAdet(String value) {
    airinletAdet = value;
    notifyListeners();
  }
  set setisiticiAdet(String value) {
    isiticiAdet = value;
    notifyListeners();
  }
  set setsiloAdet(String value) {
    siloAdet = value;
    notifyListeners();
  }
  set setsirkfanVarMi(bool value) {
    sirkfanVarMi = value;
    notifyListeners();
  }
  set setveriGonderildi(bool value) {
    veriGonderildi = value;
    notifyListeners();
  }
  set setcikisNoTekerrur(bool value) {
    cikisNoTekerrur = value;
    notifyListeners();
  }
  set setbfanCikisNo(int value) {
    bfanCikisNo = value;
    notifyListeners();
  }
  set setdijitalCikis(bool value) {
    dijitalCikis = value;
    notifyListeners();
  }
  set setanalogCikis(bool value) {
    analogCikis = value;
    notifyListeners();
  }
  set setcikisTur(String value) {
    cikisTur = value;
    notifyListeners();
  }
  set setbacafanKapakVarMi(bool value) {
    bacafanKapakVarMi = value;
    notifyListeners();
  }

  

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
