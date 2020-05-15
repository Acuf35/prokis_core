import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/mywidgets/showModalBottomSheetQ%20.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/sistem/kurulum/silo_haritasi.dart';
import 'package:prokis/languages/select.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'bacafan_haritasi.dart';
import 'isitici_haritasi.dart';

class AirInletVeSirkFan extends StatelessWidget {
  bool ilkKurulumMu = true;
  AirInletVeSirkFan(this.ilkKurulumMu);
  String dilSecimi = "EN";
  double oran;
  int sayac=0;

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    oran = MediaQuery.of(context).size.width / 731.4;
    double oranOzel=(MediaQuery.of(context).size.width/60)*3;
    
    return ChangeNotifierProvider<AirInletVeSirkFanProvider>(
          create: (context) => AirInletVeSirkFanProvider(context, dbProkis),
          child: LayoutBuilder(
            builder: (context, constraints){

              final provider = Provider.of<AirInletVeSirkFanProvider>(context);

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
                  Spacer(flex: 3,),
                  Expanded(flex: 10,
                                    child: SizedBox(
                      child: Container(
                        
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          Dil().sec(dilSecimi, "tv71"),
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
        //airinlet Harita Oluşturma Bölümü
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
                //Air inlet ve Sirkülasyon fan
                Expanded(
                  flex: 12,
                  child: Row(
                    children: <Widget>[
                      //Air inlet
                      Expanded(flex: 8,
                        child: Stack(fit: StackFit.expand,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Spacer(flex: 2,),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.blue[300],
                                    alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv586"),
                                        textAlign: TextAlign.center,
                                        minFontSize: 8,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 50,
                                          fontFamily: 'Kelly Slab',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Air inlet Resmi
                                Expanded(flex: 4,
                                  child: Visibility(visible: provider.airinletAdet==0 ? false : true,
                                    child: Container(margin: EdgeInsets.only(top: 5*oran),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/kurulum_airinlet_icon.png"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Air Inlet Çıkışları
                                Expanded(flex: 4,
                                  child: Visibility(visible: provider.airinletAdet==0 ? false : true,
                                    child: Row(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(flex: 6,
                                          child: Column(
                                              children: <Widget>[
                                                Spacer(),
                                                _unsurCikis(1, oran,provider,context),
                                                Spacer(),
                                              ],
                                            ),
                                        ),
                                        Spacer(),
                                        Expanded(flex: 6,
                                          child: Column(
                                              children: <Widget>[
                                                Spacer(),
                                                _unsurCikis(2, oran,provider,context),
                                                Spacer(),
                                              ],
                                            ),
                                        ),
                                        Spacer(),
                                        
                                      ],
                                    ),
                                  ),
                                ),

                                Spacer(flex: 2,),
                              ],
                            ),
                            Visibility(visible: provider.airinletAdet==0 ? true : false,
                              child: Column(
                                children: <Widget>[
                                  Spacer(flex: 3,),
                                  Expanded(flex: 8,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv631"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 50,
                                            color: Colors.grey[600],

                                          ),
                                          minFontSize: 8,
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(flex: 2,)
                                ],
                              ),
                            )
                          
                          ],
                        ),
                      ),
                      Spacer(),
                      //sirk fan
                      Expanded(flex: 8,
                        child: Stack(fit: StackFit.expand,
                          children: <Widget>[
                            Column(
                                children: <Widget>[
                                  Spacer(flex: 2,),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(color: Colors.blue[300],
                                      alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv581"),
                                          textAlign: TextAlign.center,
                                          minFontSize: 8,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 50,
                                            fontFamily: 'Kelly Slab',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Sirkulasyon fan resmi
                                  Expanded(
                                    flex: 4,
                                    child: Visibility(
                                      visible: provider.sirkfanVarMi,
                                      child: Container(margin: EdgeInsets.only(top: 5*oran),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            alignment: Alignment.center,
                                            image: AssetImage(
                                                "assets/images/kurulum_sirkfan_icon.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Sirkülasyon fan çıkışları
                                  Expanded(
                                    flex: 4,
                                    child: Visibility(
                                      visible: provider.sirkfanVarMi,
                                      child: Row(
                                        children: <Widget>[
                                          Spacer(),
                                          Expanded(flex: 2,
                                            child: Column(
                                                children: <Widget>[
                                                  Spacer(),
                                                  _unsurCikis(3, oran,provider,context),
                                                  Spacer(),
                                                ],
                                              ),
                                          ),
                                          Spacer(),
                                          
                                        ],
                                      ),
                                    ),
                                  ),

                                  Spacer(flex: 2,),
                                ],
                              ),
                            Visibility(visible: !provider.sirkfanVarMi,
                              child: Column(
                                children: <Widget>[
                                  Spacer(flex: 3,),
                                  Expanded(flex: 8,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv630"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontSize: 50,
                                            color: Colors.grey[600],

                                          ),
                                          minFontSize: 8,
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(flex: 2,)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                //Tüm çıkışlar bölümü
                Metotlar().cikislariGetir(provider.tumCikislar, oranOzel, oran, 6, true, sayac, dilSecimi)
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
                    
                      //Verileri Gönder Butonu
                      FlatButton(
                        onPressed: () {
                          bool noKontrol2 = false;
                          bool cikisKullanimda = false;
                          String cikisNolar = "";
                          String tumCikislarVeri = "";

                          if(provider.airinletAdet!=0){
                            if(provider.cikisNo[1]==0 || provider.cikisNo[2]==0){
                              noKontrol2=true;
                            }

                          }

                          if(provider.sirkfanVarMi && provider.cikisNo[3]==0){
                            noKontrol2=true;
                          }

                          for (int i = 1; i <= 3; i++) {
                            if (provider.cikisNoGecici[i] != provider.cikisNo[i]) {
                              if (provider.tumCikislar[provider.cikisNo[i]] == 0) {
                                
                                provider.tumCikislar[provider.cikisNoGecici[i]]=0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }
                            
                            cikisNolar = cikisNolar + provider.cikisNo[i].toString() + "#";
                          }

                          if (noKontrol2) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast97"),
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
                                  provider.tumCikislar[i].toString() +"#";
                            }
                            
                            String komut="30*31*$cikisNolar*0*0*0";
                              Metotlar().veriGonder(komut, 2233).then((value){
                                if(value.split("*")[0]=="error"){
                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                }else{
                                    Metotlar().veriGonder("25*27*$tumCikislarVeri*0*0*0", 2233).then((value){
                                      if(value.split("*")[0]=="error"){
                                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                      }else{
                                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                        dbProkis.dbSatirEkleGuncelle(26, "ok", cikisNolar, "0", "0");
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

                          if(provider.bacafanAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BacafanHaritasi(true)),
                              );
                            }else{

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiSensorHaritasi(true)),
                                );
                              }
                              
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

                          if (!provider.veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                             if(provider.isiticiAdet!='0'){

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
                            Dil().sec(dilSecimi, "tv17"), 
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



            }
          )
    );
  }
  
 
  Widget _unsurCikis(int index, double oran, AirInletVeSirkFanProvider provider, BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        children: <Widget>[
          Expanded(flex: 4,
            child: SizedBox(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: AutoSizeText(
                  Dil().sec(dilSecimi,
                index == 1 ? "tv628" : (index == 2 ? "tv629" : "tv627")),
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
    );
  }


}

class AirInletVeSirkFanProvider with ChangeNotifier {
  int sayac=0;

 List<int> cikisNo = new List.filled(4,0);
  List<int> cikisNoGecici = new List.filled(4,0);
  int airinletAdet = 0;
  bool sirkfanVarMi = false;
  String bacafanAdet = '0';
  String isiticiAdet = '0';
  String siloAdet = '0';

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List.filled(111,0);

  dinlemeyiTetikle(){
    notifyListeners();
  }

  tekerrurTespit(){
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
      notifyListeners();
  }


  set setsayac(int value) {
    sayac = value;
    notifyListeners();
  }
  set setbacafanAdet(String value) {
    bacafanAdet = value;
    notifyListeners();
  }
  set setairinletAdet(int value) {
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


  BuildContext context;
  DBProkis dbProkis;

  AirInletVeSirkFanProvider(this.context, this.dbProkis) {


    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=int.parse(dbProkis.dbVeriGetir(5, 2, "0"));
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet=dbProkis.dbVeriGetir(5, 4, "0");


    String tumCikislarKAYIT = dbProkis.dbVeriGetir(22, 1, "");
    String cikisKAYIT = dbProkis.dbVeriGetir(26, 1, "");
    var tcikislar;
    var cikisNolar;
    

    if (tumCikislarKAYIT == "ok") {
      tcikislar = dbProkis.dbVeriGetir(22, 2, "").split("#");
    }

    if (cikisKAYIT == "ok") {
      veriGonderildi=true;
      cikisNolar = dbProkis.dbVeriGetir(26, 2, "").split("#");
    }

    for (var i = 1; i <= 110; i++) {
      if (tumCikislarKAYIT == "ok") {
        tumCikislar[i] = int.parse(tcikislar[i-1]);
      }
    }


    if (cikisKAYIT == "ok") {
      for (var i = 1; i <= 3; i++) {
        cikisNo[i] = int.parse(cikisNolar[i - 1]);
        cikisNoGecici[i]=cikisNo[i];
      }
    }
    
  }
  
}
