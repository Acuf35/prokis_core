import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class DegerGiris2X2X0 extends StatefulWidget {
  int onlarX = 0;
  int birlerX = 0;
  int onlarY = 0;
  int birlerY = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik1;
  String baslik2;

  DegerGiris2X2X0.Deger(
      int gelenOnlarX,
      int gelenBirlerX,
      int gelenOnlarY,
      int gelenBirlerY,
      int gelenIndex,
      double gelenOran,
      String gelenDil,
      String gelenBaslik1,
      String gelenBaslik2) {
    onlarX = gelenOnlarX;
    birlerX = gelenBirlerX;
    onlarY = gelenOnlarY;
    birlerY = gelenBirlerY;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik1 = gelenBaslik1;
    baslik2 = gelenBaslik2;
  }

  @override
  _DegerGiris2X2X0State createState() => new _DegerGiris2X2X0State.Deger(onlarX,
      birlerX, onlarY, birlerY, index, oran, dilSecimi, baslik1, baslik2);
}

class _DegerGiris2X2X0State extends State<DegerGiris2X2X0> {
  int onlarX = 0;
  int onlarX1 = 0;
  int birlerX = 0;
  int birlerX1 = 0;
  int onlarY = 0;
  int onlarY1 = 0;
  int birlerY = 0;
  int birlerY1 = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik1;
  String baslik2;

  _DegerGiris2X2X0State.Deger(
      int gelenOnlarX,
      int gelenBirlerX,
      int gelenOnlarY,
      int gelenBirlerY,
      int gelenIndex,
      double gelenOran,
      String gelenDil,
      String gelenBaslik1,
      String gelenBaslik2) {
    onlarX = gelenOnlarX;
    onlarX1 = gelenOnlarX;
    birlerX = gelenBirlerX;
    birlerX1 = gelenBirlerX;
    onlarY = gelenOnlarY;
    onlarY1 = gelenOnlarY;
    birlerY = gelenBirlerY;
    birlerY1 = gelenBirlerY;
    index = gelenIndex;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik1 = gelenBaslik1;
    baslik2 = gelenBaslik2;
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
                    Dil().sec(dilSecimi, baslik1),
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
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    Dil().sec(dilSecimi, baslik2),
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
                                if (onlarY < 9)
                                  onlarY++;
                                else
                                  onlarY = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              onlarY.toString(),
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
                                if (onlarY > 0)
                                  onlarY--;
                                else
                                  onlarY = 9;

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
                                if (birlerY < 9)
                                  birlerY++;
                                else
                                  birlerY = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              birlerY.toString(),
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
                                if (birlerY > 0)
                                  birlerY--;
                                else
                                  birlerY = 9;

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
                    var deger = [onlarX, birlerX, onlarY, birlerY, index];
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
                    var deger = [onlarX1, birlerX1, onlarY1, birlerY1, index];
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
