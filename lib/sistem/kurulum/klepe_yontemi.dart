import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/sistem/kurulum/fan_haritasi.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/sistem/kurulum/uz_debi_nem.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'mh_yontemi.dart';

class KlpYontemi extends StatelessWidget {
  bool ilkKurulumMu = true;
  KlpYontemi(this.ilkKurulumMu);
  String dilSecimi = "EN";

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    var oran = MediaQuery.of(context).size.width / 731.4;

    return ChangeNotifierProvider<KlpYontemiProvider>(
      create: (context) => KlpYontemiProvider(context, dbProkis),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<KlpYontemiProvider>(context);

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
                          child: SizedBox(
                            child: Container(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                Dil().sec(dilSecimi, "tv27"),
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
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                  )),
                  //Klepe yöntemi seçim bölümü
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
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
                                            'assets/images/ky_klp_klasik_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      if (!provider.getkyDurum) {
                                        provider.setkyDurum = true;
                                        provider.settyDurum = false;
                                      }

                                      Metotlar().veriGonder("6*9*1*0*0*0",2233).then((value) {
                                        if(value.split("*")[0]=="error"){
                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                        }else{
                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                          dbProkis.dbSatirEkleGuncelle(8, "1", "0", "0", "0");
                                        }
                                      });
                                    },
                                    icon: Icon(provider.getkyDurum == true
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                    color: provider.getkyDurum == true
                                        ? Colors.green.shade500
                                        : Colors.blue.shade600,
                                    iconSize: 30 * oran,
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                        Dil().sec(dilSecimi, "tv28"),
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
                                            'assets/images/ky_klp_tunel_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      if (!provider.gettyDurum) {
                                        provider.settyDurum = true;
                                        provider.setkyDurum = false;
                                      }

                                      Metotlar().veriGonder("6*9*2*0*0*0",2233).then((value) {
                                        if(value.split("*")[0]=="error"){
                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                        }else{
                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                          dbProkis.dbSatirEkleGuncelle(8, "2", "0", "0", "0");
                                        }
                                      });
                                    },
                                    icon: Icon(provider.gettyDurum == true
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                    color: provider.gettyDurum == true
                                        ? Colors.green.shade500
                                        : Colors.blue.shade600,
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
                          Spacer(
                            flex: 20,
                          ),
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
                                              MhYontemi(true)),
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
                                visible: ilkKurulumMu,
                                maintainState: true,
                                maintainSize: true,
                                maintainAnimation: true,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  iconSize: 50 * oran,
                                  onPressed: () {
                                    if (!provider.getkyDurum &&
                                        !provider.gettyDurum) {
                                      Toast.show(
                                          Dil().sec(dilSecimi, "toast23"),
                                          context,
                                          duration: 3);
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FanHaritasi(true)),
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
              ));
        },
      ),
    );
  }
}

class KlpYontemiProvider with ChangeNotifier {

  bool _kyDurum = false;
  bool _tyDurum = false;

  bool get getkyDurum => _kyDurum;

  set setkyDurum(bool value) {
    _kyDurum = value;
    notifyListeners();
  }

  bool get gettyDurum => _tyDurum;

  set settyDurum(bool value) {
    _tyDurum = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  KlpYontemiProvider(this.context, this.dbProkis) {

    String xx = dbProkis.dbVeriGetir(8, 1, "0");
    _kyDurum = xx == "1" ? true : false;
    _tyDurum = xx == "2" ? true : false;
  }
}
