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
import 'fan_yontemi.dart';
import 'klepe_yontemi.dart';

class MhYontemi extends StatelessWidget {
  bool ilkKurulumMu = true;
  MhYontemi(this.ilkKurulumMu);
  String dilSecimi = "EN";

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    var oran = MediaQuery.of(context).size.width / 731.4;
    
    return ChangeNotifierProvider<MhYontemiProvider>(
          create: (context) => MhYontemiProvider(context, dbProkis),
          child: LayoutBuilder(
        builder:(context, constraints) {

          final provider = Provider.of<MhYontemiProvider>(context);

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
                          Dil().sec(dilSecimi, "tv24"),
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
        //Mh yöntemi seçim bölümü
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
                                  color: provider.getkumesTuru=="1" && provider.getbacafanAdet=="0" ?  Colors.black : Colors.grey[700],
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
                                  'assets/images/ky_mh_klasik_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(

                          onPressed: () {

                            if(provider.getkumesTuru!="1" || provider.getbacafanAdet!="0"){
                              Toast.show(Dil().sec(dilSecimi, "toast67"), context,duration: 3);
                            }else{

                            
                            if (!provider.getkyDurum) {
                              provider.setkyDurum = true;
                              provider.setayDurum = false;
                              provider.sethyDurum = false;
                            }



                            Metotlar().veriGonder("5*8*1*0*0*0", 2233).then((value){
                              if(value.split("*")[0]=="error"){
                                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                              }else{
                                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                dbProkis.dbSatirEkleGuncelle(7, "1", "0", "0", "0");
                              }
                            });

                            }
                          },
                          icon: Icon(provider.getkyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: provider.getkumesTuru=="1" && provider.getbacafanAdet=="0" ? (provider.getkyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600) : Colors.grey[700],
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
                              Dil().sec(dilSecimi, "tv25"),
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
                                  'assets/images/ky_mh_agirlik_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(
                          onPressed: () {
                            if (!provider.getayDurum) {
                              provider.setayDurum = true;
                            }

                            if (provider.getayDurum == true) {
                              provider.setkyDurum = false;
                              provider.sethyDurum = false;
                            }

                            Metotlar().veriGonder("5*8*2*0*0*0", 2233).then((value){
                              if(value.split("*")[0]=="error"){
                                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                              }else{
                                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                dbProkis.dbSatirEkleGuncelle(7, "2", "0", "0", "0");
                              }
                            });

                          },
                          icon: Icon(provider.getayDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: provider.getayDurum == true
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
                              Dil().sec(dilSecimi, "tv26"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Kelly Slab',
                                  color: provider.getkumesTuru=="1" ? Colors.black : Colors.grey[700],
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
                                  'assets/images/ky_mh_hacim_icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      
                      Expanded(flex: 2,
                                              child: IconButton(


                          onPressed: () {

                            if(provider.getkumesTuru=="1"){

                            if (!provider.gethyDurum) {
                              provider.sethyDurum = true;
                              provider.setkyDurum = false;
                              provider.setayDurum = false;
                            }


                            Metotlar().veriGonder("5*8*3*0*0*0", 2233).then((value){
                              if(value.split("*")[0]=="error"){
                                Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                              }else{
                                Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                dbProkis.dbSatirEkleGuncelle(7, "3", "0", "0", "0");
                              }
                            });

                            
                            }else{
                              Toast.show(Dil().sec(dilSecimi, "toast65"), context,duration: 3);
                            }
                          },
                          icon: Icon(provider.gethyDurum == true
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          color: provider.getkumesTuru=="1" ? (provider.gethyDurum == true
                              ? Colors.green.shade500
                              : Colors.blue.shade600) : Colors.grey[700],
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
                    child: Visibility(visible: ilkKurulumMu,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 50 * oran,
                        onPressed: () {

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FanYontemi(true)),
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
                    child: Visibility(visible: ilkKurulumMu ,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          if (!provider.getkyDurum && !provider.getayDurum && !provider.gethyDurum) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast22"),
                                context,
                                duration: 3);
                          } else {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KlpYontemi(true)),
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


class MhYontemiProvider with ChangeNotifier {

  bool _kyDurum = false;
  bool _ayDurum = false;
  bool _hyDurum = false;

  String _bacafanAdet;
  String _kumesTuru;

  bool get getkyDurum => _kyDurum;

  set setkyDurum(bool value) {
    _kyDurum = value;
    notifyListeners();
  }

  bool get getayDurum => _ayDurum;

  set setayDurum(bool value) {
    _ayDurum = value;
    notifyListeners();
  }

  bool get gethyDurum => _hyDurum;

  set sethyDurum(bool value) {
    _hyDurum = value;
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

  MhYontemiProvider(this.context, this.dbProkis) {

    String xx=dbProkis.dbVeriGetir(7, 1, "0");
    _kyDurum= xx=="1" ? true : false;
    _ayDurum= xx=="2" ? true : false;
    _hyDurum= xx=="3" ? true : false;

    _kumesTuru = dbProkis.dbVeriGetir(3, 1, "1");

    var yy =dbProkis.dbVeriGetir(5, 1, "1").split('#');
    _bacafanAdet = yy[0];

  }

}
