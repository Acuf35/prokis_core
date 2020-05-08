import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/oto_man_air.dart';
import 'package:prokis/otoman/oto_man_klepe.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';


class OtoMan1 extends StatelessWidget {
  String dilSecimi = "EN";
  double oran;
  int sayac=0;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  bool timerCancel = false;
  bool timerCancelFan = false;
  bool timerCancelPed = false;
  bool timerCancelAyd = false;
  bool timerCancelBfa = false;
  bool timerCancelIst = false;
  bool timerCancelYml = false;
  bool timerCancelSrk = false;
  int timerSayac = 0;
  bool baglanti = false;
  bool baglantiFan = false;
  bool baglantiPed = false;
  bool baglantiAyd = false;
  bool baglantiBfa = false;
  bool baglantiIst = false;
  bool baglantiYml = false;
  bool baglantiSrk = false;

  int yazmaSonrasiGecikmeSayaci = 4;
  int yazmaSonrasiGecikmeSayaciTFAN = 8;
  int yazmaSonrasiGecikmeSayaciPED = 8;
  int yazmaSonrasiGecikmeSayaciAYD = 8;
  int yazmaSonrasiGecikmeSayaciBFAN = 8;
  int yazmaSonrasiGecikmeSayaciISTC = 8;
  int yazmaSonrasiGecikmeSayaciYEML = 8;
  int yazmaSonrasiGecikmeSayaciSIRK = 8;
  bool takipEtiGeciciDurdur=false;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    
    return ChangeNotifierProvider<OtoMan1Provider>(
          create: (context) => OtoMan1Provider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){
              final provider = Provider.of<OtoMan1Provider>(context);

              if (timerSayac == 0) {
              Metotlar().takipEt('16*', 2236).then((value){

                var degerler = value.split('*');

                if(degerler[0]=="error"){
                  Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                }else{
                  provider.otoTFAN=degerler[0]=="True" ? true : false;
                  provider.otoPEDM=degerler[1]=="True" ? true : false;
                  provider.otoAYDL=degerler[2]=="True" ? true : false;
                  provider.otoBFAN=degerler[3]=="True" ? true : false;
                  provider.otoISTC=degerler[4]=="True" ? true : false;
                  provider.otoYEMA=degerler[5]=="True" ? true : false;
                  provider.otoSIRK=degerler[6]=="True" ? true : false;

                  if(!timerCancel){
                    provider.dinlemeyiTetikle();
                  }
                }
                
                
              });

              Timer.periodic(Duration(seconds: 2), (timer) {
                if(!takipEtiGeciciDurdur)
                  yazmaSonrasiGecikmeSayaci++;

                if (timerCancel) {
                  timer.cancel();
                }

                if (!baglanti && yazmaSonrasiGecikmeSayaci > 3 && !takipEtiGeciciDurdur) {
                  baglanti = true;
                  Metotlar().takipEt('16*', 2236).then((value){
                    
                var degerler = value.split('*');

                if(degerler[0]=="error"){
                  Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                }else{
                  provider.otoTFAN=degerler[0]=="True" ? true : false;
                  provider.otoPEDM=degerler[1]=="True" ? true : false;
                  provider.otoAYDL=degerler[2]=="True" ? true : false;
                  provider.otoBFAN=degerler[3]=="True" ? true : false;
                  provider.otoISTC=degerler[4]=="True" ? true : false;
                  provider.otoYEMA=degerler[5]=="True" ? true : false;
                  provider.otoSIRK=degerler[6]=="True" ? true : false;
                  baglanti=false;

                  if(!timerCancel){
                    provider.dinlemeyiTetikle();
                  }
                }
                

              });
                }
              });
            }

            timerSayac++;

              return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv454'),
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
                        Metotlar().getSystemTime(dbProkis.getDbVeri),
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
                        Metotlar().getSystemDate(dbProkis.getDbVeri),
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
                        child: Container(color: Colors.white,
                          child: Row(
              children: <Widget>[
                Expanded(flex: 20,
                                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv458"),'assets/images/kurulum_fan_icon.png',oran,provider.otoTFAN,1,context,provider),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  _unsurOtoManWidgetKlepeAir(Dil().sec(dilSecimi, "tv108"),'assets/images/kurulum_klepe_icon.png',oran,provider.otoKLPE,2,context,dbProkis,provider),
                                  _unsurOtoManWidgetKlepeAir(Dil().sec(dilSecimi, "tv460"),'assets/images/kurulum_airinlet_icon.png',oran,provider.otoAIRI,5,context,dbProkis,provider),
                                ],
                              ),
                            ),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv459"),'assets/images/kurulum_ped_icon.png',oran,provider.otoPEDM,3,context,provider),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv112"),'assets/images/kurulum_aydinlatma_icon1.png',oran,provider.otoAYDL,4,context,provider),
                          ],
                      ) 
                    ),
                    Container(height: 10*oran,),

                    Expanded(
                      child:Row(
                          children: <Widget>[
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv461"),'assets/images/kurulum_bacafan_icon.png',oran,provider.otoBFAN,6,context,provider),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv462"),'assets/images/kurulum_isitici_icon.png',oran,provider.otoISTC,7,context,provider),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv463"),'assets/images/kurulum_yemleme_icon.png',oran,provider.otoYEMA,8,context,provider),
                            _unsurOtoManWidget(Dil().sec(dilSecimi, "tv653"),'assets/images/kurulum_sirkfan_icon.png',oran,provider.otoSIRK,9,context,provider),
                          ],
                      ) 
                    ),

                  
                   
],
    ),
                ),
                Spacer()
              ],
            ),
                        ),
          ),
        ],
      ),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
          child: FittedBox(
                      child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GenelAyarlar(dbProkis.getDbVeri)),
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
      endDrawer: SizedBox(width: 320*oran,
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
                        Dil().sec(
                            dilSecimi, "tv81"), //Sıcaklık diyagramı
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
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          ListTile(
                            dense: false,
                            title: Text(Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                            subtitle: Text(
                              Dil().sec(dilSecimi, "info16_1"),
                              style: TextStyle(
                                fontSize: 13 * oran,
                              ),
                            ),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        
    );
 
            }
          )
    );
  }

  Widget _unsurOtoManWidget(String baslik, String imagePath, double oran, 
  bool otomanDurum,int index, BuildContext context, OtoMan1Provider provider){
    bool visible=true;
    String metin="";
    if(index==6){
      visible = provider.bacafanAdet == "1" ? true : false;
      metin = Dil().sec(dilSecimi, "tv657");
    }
    if(index==7){
      visible = provider.isiticiAdet != "0" ? true : false;
      metin = Dil().sec(dilSecimi, "tv658");
    }
    if(index==8){
      visible = provider.yemUnsurAdet != 0 ? true : false;
      metin = Dil().sec(dilSecimi, "tv659");
    }
    if(index==9){
      visible = provider.sirkFanVarMi == "1" ? true : false;
      metin = Dil().sec(dilSecimi, "tv660");
    }
    return Expanded(
      child: Row(
        children: <Widget>[
          Spacer(),
          Expanded(flex: 10,
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
                                        color: Colors.grey[500],
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                
                Expanded(flex: 5,
                  child: Stack(
                    children: <Widget>[
                      Visibility(visible: visible,

                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  //Oto
                                  Expanded(flex: 10,
                                    child:  RawMaterialButton(
                                      elevation: 8,
                                      onPressed: (){

                                       
                                        yazmaSonrasiGecikmeSayaci=0;
                                        Metotlar().veriGonder("20*$index*1", 2235).then((value){
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            Metotlar().takipEt("16*", 2236).then((value){
                                              var degerler = value.split('*');

                                              if(degerler[0]=="error"){
                                                Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                              }else{
                                                provider.otoTFAN=degerler[0]=="True" ? true : false;
                                                provider.otoPEDM=degerler[1]=="True" ? true : false;
                                                provider.otoAYDL=degerler[2]=="True" ? true : false;
                                                provider.otoBFAN=degerler[3]=="True" ? true : false;
                                                provider.otoISTC=degerler[4]=="True" ? true : false;
                                                provider.otoYEMA=degerler[5]=="True" ? true : false;
                                                provider.otoSIRK=degerler[6]=="True" ? true : false;
                                                provider.dinlemeyiTetikle();
                                              }
                                            }); 
                                          }

                                          

                                        });

                                        if(index==1){
                                          provider.otoTFAN=true;
                                          for(int i=1;i<=int.parse(provider.fanAdet);i++){
                                            provider.fanMan[i]=false;
                                          }
                                        }else if(index==3){
                                          provider.otoPEDM=true;
                                          for(int i=1;i<=int.parse(provider.pedAdet);i++){
                                            provider.pedMan[i]=false;
                                          }
                                        }else if(index==4){
                                          provider.otoAYDL=true;
                                          provider.aydMan[1]=false;
                                        }else if(index==6){
                                          provider.otoBFAN=true;
                                          for(int i=1;i<=int.parse(provider.bacafanAdet);i++){
                                           provider.bfaMan[i]=false;
                                          }
                                        }else if(index==7){
                                          provider.otoISTC=true;
                                          for(int i=1;i<=int.parse(provider.isiticiAdet);i++){
                                            provider.istMan[i]=false;
                                          }
                                        }else if(index==8){
                                          provider.otoYEMA=true;
                                          for(int i=1;i<=6;i++){
                                            provider.yemMan[i]=false;
                                          }
                                        }else if(index==9){
                                          provider.otoSIRK=true;
                                          for(int i=1;i<=1;i++){
                                            provider.sirMan[i]=false;
                                          }
                                        }

                                        provider.dinlemeyiTetikle();

                                      },
                                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      fillColor: otomanDurum ? Colors.green[400] : Colors.grey[400],
                                      child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv455"),
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
                              
                                      )),
                                  Spacer(),
                                  //MAN
                                  Expanded(flex: 10,
                                    child: RawMaterialButton(
                                      elevation: 8,
                                      onPressed: (){
                                        yazmaSonrasiGecikmeSayaci=0;
                                        Metotlar().veriGonder("20*$index*0", 2235).then((value){

                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            Metotlar().takipEt("16*", 2236).then((value){
                                              var degerler = value.split('*');

                                              if(degerler[0]=="error"){
                                                Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                              }else{
                                                provider.otoTFAN=degerler[0]=="True" ? true : false;
                                                provider.otoPEDM=degerler[1]=="True" ? true : false;
                                                provider.otoAYDL=degerler[2]=="True" ? true : false;
                                                provider.otoBFAN=degerler[3]=="True" ? true : false;
                                                provider.otoISTC=degerler[4]=="True" ? true : false;
                                                provider.otoYEMA=degerler[5]=="True" ? true : false;
                                                provider.otoSIRK=degerler[6]=="True" ? true : false;
                                                provider.dinlemeyiTetikle();
                                              }
                                            });
                                          }


                                        });

                                        if(index==1){
                                          provider.otoTFAN=false;
                                        }else if(index==3){
                                          provider.otoPEDM=false;
                                        }else if(index==4){
                                          provider.otoAYDL=false;
                                        }else if(index==6){
                                          provider.otoBFAN=false;
                                        }else if(index==7){
                                          provider.otoISTC=false;
                                        }else if(index==8){
                                          provider.otoYEMA=false;
                                        }else if(index==9){
                                          provider.otoSIRK=false;
                                        }

                                        provider.dinlemeyiTetikle();
                                      },
                                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      fillColor: !otomanDurum ? Colors.green[400] : Colors.grey[400],
                                      child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv456"),
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
                              
                                      )),
                                  Spacer(),
                              
                              ],)),
            
                            Expanded(flex: 4,
                                  child: Column(
                                  children: <Widget>[
                                    
                                    Spacer(),
                                    Expanded(flex: 24,
                                    child: Visibility(visible: !otomanDurum,
                                        child: RawMaterialButton(
                                          onPressed: (){


                                            takipEtiGeciciDurdur=true;

                                            if(index==1){
                                              timerCancelFan=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciTFAN++;
                                                  if (timerCancelFan) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiFan && yazmaSonrasiGecikmeSayaciTFAN>7){
                                                    baglantiFan=true;
                                                    Metotlar().takipEt("17*${provider.fanAdet}", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        for(int i=1;i<=int.parse(provider.fanAdet);i++){
                                                          provider.fanMan[i]=degerler[i-1]=="True" ? true : false;
                                                        }
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolTFAN(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelFan=true;
                                              });
                                            }else if(index==3){
                                              timerCancelPed=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciPED++;
                                                  if (timerCancelPed) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiPed && yazmaSonrasiGecikmeSayaciPED>7){
                                                    baglantiPed=true;
                                                    Metotlar().takipEt("18*${provider.pedAdet}", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        for(int i=1;i<=int.parse(provider.pedAdet);i++){
                                                          provider.pedMan[i]=degerler[i-1]=="True" ? true : false;
                                                        }
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolPED(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelPed=true;
                                              });
                                            }else if(index==4){
                                              timerCancelAyd=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciAYD++;
                                                  if (timerCancelAyd) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiAyd && yazmaSonrasiGecikmeSayaciAYD>7){
                                                    baglantiAyd=true;
                                                    Metotlar().takipEt("19*", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        provider.manuelAydinlikYuzdesi=degerler[0];
                                                        provider.aydMan[1]=degerler[1]=="True" ? true : false;
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolAYD(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelAyd=true;
                                              });
                                            }
                                            
                                            else if(index==6){
                                              timerCancelBfa=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciBFAN++;
                                                  if (timerCancelBfa) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiBfa && yazmaSonrasiGecikmeSayaciBFAN>7){
                                                    baglantiAyd=true;
                                                    Metotlar().takipEt("20*${provider.bacafanAdet}", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        for(int i=1;i<=int.parse(provider.bacafanAdet);i++){
                                                          provider.bfaMan[i]=degerler[i-1]=="True" ? true : false;
                                                        }
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolBFAN(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelBfa=true;
                                              });
                                                }

                                              
                                            else if(index==7){
                                              timerCancelIst=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciISTC++;
                                                  if (timerCancelIst) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiIst && yazmaSonrasiGecikmeSayaciISTC>7){
                                                    baglantiIst=true;
                                                    Metotlar().takipEt("21*", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        for(int i=1;i<=int.parse(provider.isiticiAdet);i++){
                                                          provider.istMan[i]=degerler[i-1]=="True" ? true : false;
                                                        }
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolISTC(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelIst=true;
                                              });
                                            }
                                            
                                            
                                            else if(index==8){
                                              timerCancelYml=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciYEML++;
                                                  if (timerCancelYml) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiYml && yazmaSonrasiGecikmeSayaciYEML>7){
                                                    baglantiYml=true;
                                                    Metotlar().takipEt("22*", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        provider.yemMan[1]=degerler[0]=="True" ? true : false;
                                                        provider.yemMan[2]=degerler[1]=="True" ? true : false;
                                                        provider.yemMan[3]=degerler[2]=="True" ? true : false;
                                                        provider.yemMan[4]=degerler[3]=="True" ? true : false;
                                                        provider.yemMan[5]=degerler[4]=="True" ? true : false;
                                                        provider.yemMan[6]=degerler[5]=="True" ? true : false;
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolYEML(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelYml=true;
                                              });
                                            }


                                            else if(index==9){
                                              timerCancelSrk=false;
                                              Timer.periodic(Duration(seconds: 1), (timer) {
                                                  yazmaSonrasiGecikmeSayaciSIRK++;
                                                  if (timerCancelSrk) {
                                                    timer.cancel();
                                                  }
                                                  if(!baglantiSrk && yazmaSonrasiGecikmeSayaciSIRK>7){
                                                    baglantiSrk=true;
                                                    Metotlar().takipEt("22a*", 2236).then((value){
                                                      var degerler = value.split('*');

                                                      if(degerler[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                                                      }else{
                                                        provider.sirMan[1]=degerler[0]=="True" ? true : false;
                                                        provider.dinlemeyiTetikle();
                                                      }
                                                    });
                                                  }
                                                  
                                                });

                                                _manKontrolSIRK(oran,index,context,provider).then((value){
                                                takipEtiGeciciDurdur=false;
                                                timerCancelSrk=true;
                                              });
                                            }



                                          },
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                          elevation: 8,
                                          child: Column(
                                            children: <Widget>[
                                            Expanded(
                                                                  child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv457"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.green,
                                            fontSize: 50,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                            ),
                                            
                                            Expanded(
                                              flex: 4,
                                            child: Row(
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(flex: 4,
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
                                                Spacer()
                                              ],
                                            ),
                                            ),
                                            
  
                                          ],
                                            ),
                                          ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],),
                ),
              
                          ],
                        ),
                      ),
                      Visibility(visible: !visible,
                        child: SizedBox(
                          child: Container(
                            padding: EdgeInsets.all(20*oran),
                            child: AutoSizeText(
                              metin,
                              style: TextStyle(
                                fontFamily: 'Kelly Slab',
                                fontSize: 50,
                                color: Colors.red[300]
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              minFontSize: 2,
                              
                            ),
                          ),
                        ),
                      )
                    
                    ],
                  ),
                ),
      
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  Widget _unsurOtoManWidgetKlepeAir(String baslik, String imagePath, double oran, bool otomanDurum,int index
  , BuildContext context, DBProkis dbProkis, OtoMan1Provider provider) {
    bool visible=true;
    String metin="";
    if(index==5){
      visible = provider.airinletAdet =="1" ? true : false;
      metin = Dil().sec(dilSecimi, "tv656");
    }
    return Expanded(
      child: Row(
        children: <Widget>[
          Spacer(),
          Expanded(flex: 10,
                      child: Column(
              children: <Widget>[
                Expanded(
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    baslik,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        color: Colors.grey[500],
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                
                Expanded(flex: 2,
                        child: Column(
                        children: <Widget>[
                          //Oto Man Seçimi
                          Visibility(visible: visible,
                            child: Expanded(flex: 3,
                              child:  RawMaterialButton(
                                elevation: 8,
                                onPressed: (){
                                  if(index==2){
                                    timerCancel=true;
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtoManKlepe(dbProkis.getDbVeri)),
                                      );
                                  }

                                  if(index==5){
                                    timerCancel=true;
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtoManAir(dbProkis.getDbVeri)),
                                      );
                                  }

                                },
                                materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                constraints: BoxConstraints(),
                                fillColor: Colors.blue[700],
                                child: SizedBox(
                              child: Container(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi, "tv101"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Kelly Slab',
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                              ),
                              ),
                            
                                )),
                          ),
                          Visibility(visible: visible,
                            child: Spacer()),
                          Visibility(visible: !visible,
                            child: SizedBox(
                              child: Container(
                                child: AutoSizeText(
                                  metin,
                                  style: TextStyle(
                                    fontFamily: 'Kelly Slab',
                                    fontSize: 50,
                                    color: Colors.red[300]
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  minFontSize: 2,
                                  
                                ),
                              ),
                            ),
                          )
                    
                      ],)),
            
                ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  
  }
 
  Future _manKontrolTFAN(double oran, int index, BuildContext context, OtoMan1Provider provider){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv464"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", provider.fanMan[1], oran,1,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", provider.fanMan[2], oran,2,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", provider.fanMan[3], oran,3,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", provider.fanMan[4], oran,4,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv32", provider.fanMan[5], oran,5,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[6], oran,6,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[7], oran,7,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[8], oran,8,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[9], oran,9,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" ,  provider.fanMan[10], oran,10,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[11] , oran,11,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[12] , oran,12,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[13] , oran,13,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[14] , oran,14,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[15] , oran,15,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[16] , oran,16,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[17] , oran,17,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[18] , oran,18,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[19] , oran,19,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index , "tv32" , provider.fanMan[20] , oran,20,provider.fanAdet,context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Visibility(visible: int.parse(provider.fanAdet)>20,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[21], oran,21,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[22], oran,22,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[23], oran,23,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[24], oran,24,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[25], oran,25,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[26], oran,26,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[27], oran,27,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[28], oran,28,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[29], oran,29,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[30], oran,30,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(provider.fanAdet)>30,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[31], oran,31,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[32], oran,32,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[33], oran,33,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[34], oran,34,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[35], oran,35,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[36], oran,36,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[37], oran,37,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[38], oran,38,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[39], oran,39,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[40], oran,40,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(provider.fanAdet)>40,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[41], oran,41,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[42], oran,42,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[43], oran,43,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[44], oran,44,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[45], oran,45,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[46], oran,46,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[47], oran,47,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[48], oran,48,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[49], oran,49,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[50], oran,50,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(provider.fanAdet)>50,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[51], oran,51,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[52], oran,52,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[53], oran,53,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[54], oran,54,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[55], oran,55,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[56], oran,56,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[57], oran,57,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[58], oran,58,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[59], oran,59,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                            bottomDrawerManUnsur(index , "tv32" , provider.fanMan[60], oran,60,provider.fanAdet,context,provider),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolPED(double oran,int index,  BuildContext context, OtoMan1Provider provider){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv465"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[1] , oran,1,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[2] , oran,2,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[3] , oran,3,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[4] , oran,4,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[5] , oran,5,provider.pedAdet,context,provider),
                                                                          
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[6], oran,6,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[7], oran,7,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[8], oran,8,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[9], oran,9,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv45", provider.pedMan[10] , oran,10,provider.pedAdet,context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolAYD(double oran,int index, BuildContext context , OtoMan1Provider provider){

    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv466"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Visibility(visible: provider.dimmer=="1",
                                                                        child: Text(
                                                                          Dil().sec(dilSecimi, "tv470"),
                                                                          textScaleFactor: oran,
                                                                          style: TextStyle(
                                                                            fontFamily: 'Kelly Slab',
                                                                            fontWeight: FontWeight.bold,

                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(height: 5*oran,),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(flex: 3,),
                                                                          Visibility(visible: provider.dimmer!="1",
                                                                            child: bottomDrawerManUnsur(index ,"tv112", provider.aydMan[1] , oran,1,"1",context,provider)
                                                                            ),

                                                                          Visibility(visible: provider.dimmer=="1",
                                                                            child: Expanded(
                                                                            child: RawMaterialButton(
                                                                              onPressed: () {
                                                                                _index = 13;
                                                                                int sayi=int.parse(provider.manuelAydinlikYuzdesi);
                                                                                _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                                _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                                _birler=sayi%10;

                                                                                _degergiris3X0(
                                                                                    _yuzler,
                                                                                    _onlar,
                                                                                    _birler,
                                                                                    _index,
                                                                                    oran,
                                                                                    dilSecimi,
                                                                                    "tv340",
                                                                                    "",context,provider);
                                                                              },
                                                                              child: Container(
                                                                                color: Colors.blue[700],
                                                                                padding: EdgeInsets.only(top: 5*oran,bottom: 5*oran),
                                                                                child: Text(
                                                                                  provider.manuelAydinlikYuzdesi,
                                                                                  textScaleFactor: oran,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Kelly Slab',
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 20,
                                                                                    color: Colors.white
                                                                                  ),
                                                                                  ),
                                                                              ),
                                                                              fillColor: Colors.blue[700],
                                                                              elevation: 16,
                                                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                              constraints: BoxConstraints(),
                                                                              
                                                                              ),
                                                                        ),
                                                                          ),
                                              
                                                                          Spacer(flex: 3,),
                                                                          
                                                                          //Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolBFAN(double oran,int index,BuildContext context, OtoMan1Provider provider){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv467"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(flex: 11,),
                                                                          bottomDrawerManUnsur(index ,"tv495", provider.bfaMan[1] , oran,1,provider.bacafanAdet,context,provider),
                                                                          Spacer(flex: 11,),
                                                                          /*
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[2] , oran,2,bacafanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[3] , oran,3,bacafanAdet),
                                                                          Spacer(),
                                                                          */
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolISTC(double oran,int index, BuildContext context , OtoMan1Provider provider){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv468"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv80", provider.istMan[1] , oran,1,provider.isiticiAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv80", provider.istMan[2] , oran,2,provider.isiticiAdet,context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv80", provider.istMan[3] , oran,3,provider.isiticiAdet,context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolYEML(double oran,int index, BuildContext context, OtoMan1Provider provider ){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv469"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv89", provider.yemMan[1] , oran,1,provider.yemUnsurAdet.toString(),context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv92", provider.yemMan[2] , oran,2,provider.yemUnsurAdet.toString(),context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),

                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv90", provider.yemMan[3] , oran,3,provider.yemUnsurAdet.toString(),context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv93", provider.yemMan[4] , oran,4,provider.yemUnsurAdet.toString(),context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),

                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv91", provider.yemMan[5] , oran,5,provider.yemUnsurAdet.toString(),context,provider),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv94", provider.yemMan[6] , oran,6,provider.yemUnsurAdet.toString(),context,provider),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Future _manKontrolSIRK(double oran,int index, BuildContext context, OtoMan1Provider provider ){
    bool bottomDrawerAktif=true;
    int sayac1=0;

    return showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                   builder: (context, state) {

                                                      if(sayac1==0){

                                                       Timer.periodic(Duration(seconds: 1), (timer) {

                                                         if(!bottomDrawerAktif){
                                                           timer.cancel();
                                                         }else{
                                                           bottomDrawerIcindeGuncelle(state); 
                                                         }

                                
                                                     });
                                                     }


                                                     sayac1++;
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
                                                                  
                                                              Dil()
                                                                  .sec(
                                                                      dilSecimi,
                                                                      "tv654"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(flex: 11,),
                                                                          bottomDrawerManUnsur(index ,"tv581", provider.sirMan[1] , oran,1,provider.sirkFanVarMi,context,provider),
                                                                          Spacer(flex: 11,),
                                                                          /*
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[2] , oran,2,bacafanAdet),
                                                                          Spacer(),
                                                                          bottomDrawerManUnsur(index ,"tv495", bfaMan[3] , oran,3,bacafanAdet),
                                                                          Spacer(),
                                                                          */
                                                                        ],
                                                                      ),
                                                                      ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).then((value) {
                                                bottomDrawerAktif=false;
                                              });
                                        
  }

  Widget bottomDrawerManUnsur(int index, String isim, bool otoManDurum,double oran, int unsurNo, String adet, BuildContext context, OtoMan1Provider provider) {

    return Expanded(flex: 10,
      child: Visibility(visible: int.parse(adet)>=unsurNo, maintainAnimation: true,maintainState: true,maintainSize: true,
              child: RawMaterialButton(
    fillColor: otoManDurum ? Colors.green[700] : Colors.grey[500],
    elevation: 8,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    constraints: BoxConstraints(),
             onPressed: (){


               String veri="0";

              if(index==1){
                    if(otoManDurum){
                    veri="0";
                    provider.fanMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.fanMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciTFAN=0;
                Metotlar().veriGonder("21*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("17*${provider.fanAdet}", 2236).then((value){
                      var degerler = value.split('*');

                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        for(int i=1;i<=int.parse(provider.fanAdet);i++){
                          provider.fanMan[i]=degerler[i-1]=="True" ? true : false;
                        }
                        provider.dinlemeyiTetikle();
                      }
                    });
                  }
                });
              }

              if(index==3){
                    if(otoManDurum){
                    veri="0";
                    provider.pedMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.pedMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciPED=0;
                Metotlar().veriGonder("22*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("18*${provider.pedAdet}", 2236).then((value){
                      var degerler = value.split('*');
                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        for(int i=1;i<=int.parse(provider.pedAdet);i++){
                          provider.pedMan[i]=degerler[i-1]=="True" ? true : false;
                        }
                        provider.dinlemeyiTetikle();
                      }
                    });

                    }
                  });
              }

              if(index==4){
                    if(otoManDurum){
                    veri="0";
                    provider.aydMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.aydMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciAYD=0;
                Metotlar().veriGonder("23*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("19*}", 2236).then((value){
                      var degerler = value.split('*');

                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        provider.manuelAydinlikYuzdesi=degerler[0];
                        provider.aydMan[1]=degerler[1]=="True" ? true : false;
                        provider.dinlemeyiTetikle();
                      }
                    });

                    }
                });
              }

              if(index==6){
                    if(otoManDurum){
                    veri="0";
                    provider.bfaMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.bfaMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciBFAN=0;
                Metotlar().veriGonder("24*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("20*${provider.bacafanAdet}", 2236).then((value){
                      var degerler = value.split('*');
                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        for(int i=1;i<=int.parse(provider.bacafanAdet);i++){
                          provider.bfaMan[i]=degerler[i-1]=="True" ? true : false;
                        }
                        provider.dinlemeyiTetikle();
                      }
                    });

                  }
                });
              }


              if(index==7){
                    if(otoManDurum){
                    veri="0";
                    provider.istMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.istMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciISTC=0;
                Metotlar().veriGonder("25*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("21*${provider.isiticiAdet}", 2236).then((value){
                      var degerler = value.split('*');

                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        for(int i=1;i<=int.parse(provider.isiticiAdet);i++){
                          provider.istMan[i]=degerler[i-1]=="True" ? true : false;
                        }
                        provider.dinlemeyiTetikle();
                      }
                    });
                  }
                });
              }

              if(index==8){
                    if(otoManDurum){
                    veri="0";
                    provider.yemMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.yemMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciYEML=0;
                Metotlar().veriGonder("26*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("22*", 2236).then((value){
                      var degerler = value.split('*');

                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        provider.yemMan[1]=degerler[0]=="True" ? true : false;
                        provider.yemMan[2]=degerler[1]=="True" ? true : false;
                        provider.yemMan[3]=degerler[2]=="True" ? true : false;
                        provider.yemMan[4]=degerler[3]=="True" ? true : false;
                        provider.yemMan[5]=degerler[4]=="True" ? true : false;
                        provider.yemMan[6]=degerler[5]=="True" ? true : false;
                        provider.dinlemeyiTetikle();
                      }
                    });
                  }
                });
              }


              if(index==9){
                    if(otoManDurum){
                    veri="0";
                    provider.sirMan[unsurNo]=false;
                  }else{
                    veri="1";
                    provider.sirMan[unsurNo]=true;
                  }

                yazmaSonrasiGecikmeSayaciSIRK=0;
                Metotlar().veriGonder("26a*$unsurNo*$veri", 2235).then((value){

                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                    Metotlar().takipEt("22a*", 2236).then((value){
                      var degerler = value.split('*');
                      if(degerler[0]=="error"){
                        Toast.show(Metotlar().errorToastMesaj(degerler[1]), context, duration: 4);
                      }else{
                        provider.sirMan[1]=degerler[0]=="True" ? true : false;
                        provider.dinlemeyiTetikle();
                      }
                    });
                  }
                });
              }
                      

             },
             child: Container(padding: EdgeInsets.only(top: 5*oran,bottom: 5*oran),
               child: Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(Dil().sec(dilSecimi, isim)+(index==4 || index==8 || index==6  || index==9 ? "" : " $unsurNo"),style: TextStyle(fontFamily: "Kelly Slab",
                   color: otoManDurum ? Colors.white : Colors.black ,
                   fontWeight: FontWeight.bold,
                   fontSize: 16),
                   textScaleFactor: oran,),
                   
                  
                 ],
               ),
             ),
           ),
      ),
      );

  }

  Future _degergiris3X0(int yuzler , onlar , birler, index, double oran,
      String dil, baslik, onBaslik, BuildContext context, OtoMan1Provider provider) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris3X0.Deger(
            yuzler,onlar, birler, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_yuzler != val[0] ||
          _onlar != val[1] ||
          _birler != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _yuzler = val[0];
      _onlar = val[1];
      _birler = val[2];
      _index = val[3];


      String veri = '';

      if (index == 13) {
        provider.manuelAydinlikYuzdesi=(_yuzler*100+_onlar*10+_birler).toString();
        veri = provider.manuelAydinlikYuzdesi;
      }


      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaciYEML= 0;
        Metotlar().veriGonder("15*$_index*$veri", 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
          }
        });
      }

      provider.dinlemeyiTetikle();

    });
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

}


class OtoMan1Provider with ChangeNotifier {
  int sayac=0;

  String fanAdet = "0";
  String pedAdet = "0";
  String bacafanAdet = "0";
  String airinletAdet = "0";
  String sirkFanVarMi = "0";
  
  String isiticiAdet = "0";
  int yemUnsurAdet = 0;
  String dimmer = "0";
  String manuelAydinlikYuzdesi = "50";

  

  bool yem1Aktif = false;
  bool yem2Aktif = false;
  bool yem3Aktif = false;

  bool otoTFAN=false;
  bool otoBFAN=false;
  bool otoPEDM=false;
  bool otoAIRI=false;
  bool otoKLPE=false;
  bool otoISTC=false;
  bool otoYEMA=false;
  bool otoAYDL=false;
  bool otoSIRK=false;

 
  List<bool> fanMan = new List.filled(61,false);
  List<bool> pedMan = new List.filled(11,false);
  List<bool> aydMan = new List.filled(2,false);
  List<bool> bfaMan = new List.filled(4,false);
  List<bool> istMan = new List.filled(4,false);
  List<bool> yemMan = new List.filled(7,false);
  List<bool> sirMan = new List.filled(2,false);

  dinlemeyiTetikle(){
    notifyListeners();
  }


  BuildContext context;
  DBProkis dbProkis;

  OtoMan1Provider(this.context, this.dbProkis) {

    fanAdet = dbProkis.dbVeriGetir(4, 1, "1");
    pedAdet = dbProkis.dbVeriGetir(4, 3, "1");
    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkFanVarMi = yy[1];
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");

    if (dbProkis.dbVeriGetir(31, 1, "") == "ok") {
      var aktifYemCikislar;
      aktifYemCikislar = dbProkis.dbVeriGetir(31, 3, "").split("#");
      yem1Aktif = aktifYemCikislar[0] == "1" ? true : false;
      yem2Aktif = aktifYemCikislar[1] == "1" ? true : false;
      yem3Aktif = aktifYemCikislar[2] == "1" ? true : false;
      dimmer=dbProkis.dbVeriGetir(31, 4, false);
    }

    if(yem1Aktif){
      yemUnsurAdet=yemUnsurAdet+2;
    }
    if(yem2Aktif){
      yemUnsurAdet=yemUnsurAdet+2;
    }
    if(yem3Aktif){
      yemUnsurAdet=yemUnsurAdet+2;
    }
  }
  
}
