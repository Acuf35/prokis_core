import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'adetler.dart';
import 'mh_yontemi.dart';

class FanYontemi extends StatelessWidget {
  bool ilkKurulumMu = true;
  FanYontemi(this.ilkKurulumMu);
  String dilSecimi = "EN";

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    var oran = MediaQuery.of(context).size.width / 731.4;

    return ChangeNotifierProvider<FanYontemiProvider>(
          create: (context) => FanYontemiProvider(context, dbProkis),
          child: LayoutBuilder(
        builder: (context, constraints) {

          final provider = Provider.of<FanYontemiProvider>(context);

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
              body: Column(
                children: <Widget>[
                  //Başlık bölümü
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
                                          Dil().sec(dilSecimi, "tv20"),
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
                            )
                          ],
                        )),
                  ),
                  //Fan Yöntemi seçim bölümü
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          //Klasik Kontrol
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv21"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: provider.getkumesTuru != '1'
                                                ? Colors.grey[700]
                                                : Colors.black,
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/ky_tf_klasik_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      if (provider.getkumesTuru == '1') {
                                        
                                        if (!provider.getkyDurum) {
                                          provider.setkyDurum = true;
                                          provider.setlyDurum = false;
                                          provider.setpyDurum = false;
                                        }

                                        Metotlar().veriGonder("4*7*1*0*0*0", 2233).then((value) {
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            dbProkis.dbSatirEkleGuncelle(6, "1", "0", "0", "0");
                                          }
                                        });

                                      } else {
                                        Toast.show(
                                            Dil().sec(dilSecimi, 'toast65'),
                                            context,
                                            duration: 3);
                                      }
                                    },
                                    icon: Icon(provider.getkyDurum == true
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                    color: provider.getkumesTuru != '1'
                                        ? Colors.grey[600]
                                        : (provider.getkyDurum == true
                                            ? Colors.green.shade500
                                            : Colors.blue.shade600),
                                    iconSize: 30 * oran,
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Lineer Kontrol
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv22"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/ky_tf_lineer_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      if (!provider.getlyDurum) {
                                        provider.setlyDurum = true;
                                        provider.setkyDurum = false;
                                        provider.setpyDurum = false;
                                      }

                                      Metotlar().veriGonder("4*7*2*0*0*0", 2233).then((value) {
                                        if(value.split("*")[0]=="error"){
                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                        }else{
                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                          dbProkis.dbSatirEkleGuncelle(6, "2", "0", "0", "0");
                                        }
                                      });

                                    },
                                    icon: Icon(provider.getlyDurum == true
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                    color: provider.getlyDurum == true
                                        ? Colors.green.shade500
                                        : Colors.blue.shade600,
                                    iconSize: 30 * oran,
                                  ),
                                )
                              ],
                            ),
                          ),
                          //PID Kontrol
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv23"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: provider.getkumesTuru != '1' &&
                                                    provider.getbacafanAdet == "0"
                                                ? Colors.grey[700]
                                                : Colors.black,
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/ky_tf_pid_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      if (provider.getkumesTuru != "1" &&
                                          provider.getbacafanAdet == "0") {
                                        Toast.show(
                                            Dil().sec(dilSecimi, 'toast66'),
                                            context,
                                            duration: 3);
                                      } else {
                                        if (!provider.getpyDurum) {
                                          provider.setpyDurum = true;
                                        }

                                        if (provider.getpyDurum == true) {
                                          provider.setkyDurum = false;
                                          provider.setlyDurum = false;
                                        }

                                        Metotlar().veriGonder("4*7*3*0*0*0", 2233).then((value) {
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            dbProkis.dbSatirEkleGuncelle(6, "3", "0", "0", "0");
                                          }
                                        });

                                      }
                                    },
                                    icon: Icon(provider.getpyDurum == true
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                    color:
                                        provider.getkumesTuru != '1' && provider.getbacafanAdet == '0'
                                            ? Colors.grey[700]
                                            : (provider.getpyDurum == true
                                                ? Colors.green.shade500
                                                : Colors.blue.shade600),
                                    iconSize: 30 * oran,
                                  ),
                                )
                              ],
                            ),
                          ),
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
                          Spacer(flex: 20),
                          //geri ok
                          Expanded(
                              flex: 2,
                              child: Visibility(
                                visible: ilkKurulumMu,
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
                                                Adetler(true)));
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
                                visible: ilkKurulumMu,
                                maintainState: true,
                                maintainSize: true,
                                maintainAnimation: true,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  iconSize: 50 * oran,
                                  onPressed: () {
                                    if (!provider.getkyDurum && !provider.getlyDurum && !provider.getpyDurum) {
                                      Toast.show(Dil().sec(dilSecimi, "toast4"),
                                          context,
                                          duration: 3);
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MhYontemi(true)),
                                      );
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
                            Dil().sec(dilSecimi, "tv20"), 
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
                                        text: Dil().sec(dilSecimi, "info35"),
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13*oran
                                        )
                                      ),


                                      TextSpan(
                                  text: Dil().sec(dilSecimi, "tv21")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info35a"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv22")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info35b"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv23")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info35c"),
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
        },
      ),
    );
  }
}


class FanYontemiProvider with ChangeNotifier {
  bool _kyDurum = false;
  bool _lyDurum = false;
  bool _pyDurum = false;

  String _bacafanAdet;
  String _kumesTuru;

  bool get getkyDurum => _kyDurum;

  set setkyDurum(bool value) {
    _kyDurum = value;
    notifyListeners();
  }

  bool get getlyDurum => _lyDurum;

  set setlyDurum(bool value) {
    _lyDurum = value;
    notifyListeners();
  }

  bool get getpyDurum => _pyDurum;

  set setpyDurum(bool value) {
    _pyDurum = value;
    notifyListeners();
  }

  String get getbacafanAdet => _bacafanAdet;

  set setbacafanAdet(String value) {
    _bacafanAdet = value;
    notifyListeners();
  }

  String get getkumesTuru => _kumesTuru;

  set setkumesTuru(String value) {
    _kumesTuru = value;
  }


  BuildContext context;
  DBProkis dbProkis;

  FanYontemiProvider(this.context, this.dbProkis) {

    String xx=dbProkis.dbVeriGetir(6, 1, "0");
    _kyDurum= xx=="1" ? true : false;
    _lyDurum= xx=="2" ? true : false;
    _pyDurum= xx=="3" ? true : false;

    _kumesTuru = dbProkis.dbVeriGetir(3, 1, "1");

    var yy =dbProkis.dbVeriGetir(5, 1, "1").split('#');
    _bacafanAdet = yy[0];

  }

}
