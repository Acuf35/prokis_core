import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class DegerGiris2X0 extends StatefulWidget {
  int onlarX = 0;
  int birlerX = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;

  DegerGiris2X0.Deger(
    int gelenOnlarX,
    int gelenBirlerX,
    int gelenIndex,
    double gelenOran,
    String gelenDil,
    String gelenBaslik,
  ) {
    onlarX = gelenOnlarX;
    birlerX = gelenBirlerX;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik = gelenBaslik;
  }

  @override
  _DegerGiris2X0State createState() => new _DegerGiris2X0State.Deger(
      onlarX, birlerX, index, oran, dilSecimi, baslik);
}

class _DegerGiris2X0State extends State<DegerGiris2X0> {
  int onlarX = 0;
  int onlarX1 = 0;
  int birlerX = 0;
  int birlerX1 = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;

  _DegerGiris2X0State.Deger(int gelenOnlarX, int gelenBirlerX, int gelenIndex,
      double gelenOran, String gelenDil, String gelenBaslik) {
    onlarX = gelenOnlarX;
    onlarX1 = gelenOnlarX;
    birlerX = gelenBirlerX;
    birlerX1 = gelenBirlerX;
    index = gelenIndex;
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
                                if (onlarX < 9)
                                  onlarX++;
                                else
                                  onlarX = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              onlarX.toString(),
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
                                if (onlarX > 0)
                                  onlarX--;
                                else
                                  onlarX = 9;

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
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
                                if (birlerX < 9)
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
                                  birlerX = 9;

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
                    var deger = [onlarX, birlerX, index];
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
                    var deger = [onlarX1, birlerX1, index];
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
