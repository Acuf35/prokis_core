import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class DegerGiris4X0 extends StatefulWidget {
  int onlarX = 0;
  int birlerX = 0;
  int yuzlerX = 0;
  int binlerX = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;
  String onBaslik;

  DegerGiris4X0.Deger(
    int gelenBinlerX,
    int gelenYuzlerX,
    int gelenOnlarX,
    int gelenBirlerX,
    int gelenIndex,
    double gelenOran,
    String gelenDil,
    String gelenBaslik,
    String gelenOnBaslik,
  ) {
    onlarX = gelenOnlarX;
    birlerX = gelenBirlerX;
    yuzlerX = gelenYuzlerX;
    binlerX = gelenBinlerX;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik = gelenBaslik;
    onBaslik = gelenOnBaslik;
  }

  @override
  _DegerGiris4X0State createState() => new _DegerGiris4X0State.Deger(
      binlerX, yuzlerX,onlarX,birlerX, index, oran, dilSecimi, baslik,onBaslik);
}

class _DegerGiris4X0State extends State<DegerGiris4X0> {
  int onlarX = 0;
  int onlarX1 = 0;
  int birlerX = 0;
  int birlerX1 = 0;
  int yuzlerX = 0;
  int yuzlerX1 = 0;
  int binlerX = 0;
  int binlerX1 = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;
  String onBaslik;

  _DegerGiris4X0State.Deger(int gelenBinlerX,gelenYuzlerX,gelenOnlarX,gelenBirlerX,gelenIndex,
      double gelenOran, String gelenDil, String gelenBaslik,String gelenOnBaslik) {
    onlarX = gelenOnlarX;
    onlarX1 = gelenOnlarX;
    birlerX = gelenBirlerX;
    birlerX1 = gelenBirlerX;
    yuzlerX =  gelenYuzlerX;
    yuzlerX1 = gelenYuzlerX;
    binlerX =  gelenBinlerX;
    binlerX1 = gelenBinlerX;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik = gelenBaslik;
    onBaslik = gelenOnBaslik;
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
                    onBaslik+Dil().sec(dilSecimi, baslik),
                    textAlign: TextAlign.center,
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
                                if (binlerX < 9)
                                  binlerX++;
                                else
                                  binlerX = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              binlerX.toString(),
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
                                if (binlerX > 0)
                                  binlerX--;
                                else
                                  binlerX = 9;

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
                                if (yuzlerX < 9)
                                  yuzlerX++;
                                else
                                  yuzlerX = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              yuzlerX.toString(),
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
                                if (yuzlerX > 0)
                                  yuzlerX--;
                                else
                                  yuzlerX = 9;

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
                    var deger = [binlerX,yuzlerX,onlarX, birlerX, index];
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
                    var deger = [binlerX1,yuzlerX1,onlarX1, birlerX1, index];
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
