import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class DegerGiris1X0 extends StatefulWidget {
  int ustLimit;
  int birlerX = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;

  DegerGiris1X0.Deger(
    int gelenUstLimit,
    int gelenBirlerX,
    int gelenIndex,
    double gelenOran,
    String gelenDil,
    String gelenBaslik,
  ) {
    ustLimit=gelenUstLimit;
    birlerX = gelenBirlerX;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik = gelenBaslik;
  }

  @override
  _DegerGiris1X0State createState() => new _DegerGiris1X0State.Deger(
      birlerX, index, oran, dilSecimi, baslik,ustLimit);
}

class _DegerGiris1X0State extends State<DegerGiris1X0> {
  int ustLimitX=0;
  int birlerX = 0;
  int birlerX1 = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;

  _DegerGiris1X0State.Deger(int gelenBirlerX, int gelenIndex,
      double gelenOran, String gelenDil, String gelenBaslik, int ustLimit) {
        ustLimitX=ustLimit;
    birlerX = gelenBirlerX;
    birlerX1 = gelenBirlerX;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik = gelenBaslik;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 10 * oran, bottom: 10 * oran),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0 * oran))),
      backgroundColor: Colors.deepOrange.shade800,
      title: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    Dil().sec(dilSecimi, baslik),
                    style: TextStyle(
                        fontFamily: 'Kelly Slab',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: oran,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(right: 10 * oran, top: 5 * oran),
                        child: Column(
                          children: <Widget>[
                            RawMaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0),
                              child: Image.asset(
                                'assets/images/deger_artir_icon.png',
                                scale: 4 / oran,
                              ),
                              onPressed: () {
                                if (birlerX < ustLimitX)
                                  birlerX++;
                                else
                                  birlerX = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              birlerX.toString(),
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kelly Slab'),
                              textScaleFactor: oran,
                            ),
                            RawMaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0),
                              child: Image.asset(
                                'assets/images/deger_dusur_icon.png',
                                scale: 4 / oran,
                              ),
                              onPressed: () {
                                if (birlerX > 0)
                                  birlerX--;
                                else
                                  birlerX = ustLimitX;

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10 * oran),
          alignment: Alignment.center,
          width: 400 * oran,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20 * oran),
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    var deger = [birlerX, index];
                    Navigator.of(context).pop(deger);
                  },
                  child: Text(
                    Dil().sec(dilSecimi, "btn2"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25 * oran,
                        fontFamily: 'Audio wide'),
                  ),
                ),
              ),
              Container(
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    var deger = [birlerX1, index];
                    Navigator.of(context).pop(deger);
                  },
                  child: Text(
                    Dil().sec(dilSecimi, "btn3"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25 * oran,
                        fontFamily: 'Audio wide'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
