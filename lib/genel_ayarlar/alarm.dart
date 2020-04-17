
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';

class Alarm extends StatefulWidget {
  List<Map> gelenDBveri;
  Alarm(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return AlarmState(gelenDBveri);
  }
}

class AlarmState extends State<Alarm> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  AlarmState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    //++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height  / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
        appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv99',Colors.blue),
        body: Row(
          children: <Widget>[
            Spacer(),
            Expanded(flex: 7,
                          child: GridView.count(
                crossAxisSpacing: 0.0,
                dragStartBehavior: DragStartBehavior.down,
                mainAxisSpacing: 0.0,
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 6,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(18, (index) {
                  return Center(
                    child: Visibility(visible: index%2==1 ? false: true,
                      child: _fanHaritaUnsur(index, oran))
                  );
                }),
              ),
            ),
            Spacer()
          ],
        ),
      );
    
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


  
  Widget _fanHaritaUnsur(int indexNo, double oran) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: RawMaterialButton(
              onPressed: () {
                


              },
              child: Stack(
                children: <Widget>[
                  Opacity(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(imageGetir(indexNo%2==0 ? 1 :2)),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    opacity: 1,
                  ),
                  ],
              )
              
              ),
        ),
      ],
    );
  }

  _satirlar(List<Map> satirlar) {
    dbVeriler = satirlar;
  }

  _dbVeriCekme() {
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      dbSatirlar.then((List<Map> satir) => _satirlar(satir));
    });
  }
}
