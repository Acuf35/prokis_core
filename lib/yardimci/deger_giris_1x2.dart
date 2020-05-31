import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';

class DegerGiris1X2 extends StatefulWidget {
  int birlerX = 0;
  int ondalikOnlarX = 0;
  int ondalikBirlerX = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;
  String onBaslik;

  DegerGiris1X2.Deger(
    int gelenBirlerX,
    int gelenOndalikOnlarX,
    int gelenOndalikBirlerX,
    int gelenIndex,
    double gelenOran,
    String gelenDil,
    String gelenBaslik,
    String gelenOnBaslik,
  ) {
    birlerX = gelenBirlerX;
    ondalikOnlarX = gelenOndalikOnlarX;
    ondalikBirlerX = gelenOndalikBirlerX;
    index = gelenIndex;
    oran = gelenOran;
    dilSecimi = gelenDil;
    baslik = gelenBaslik;
    onBaslik = gelenOnBaslik;
  }

  @override
  _DegerGiris1X2State createState() => new _DegerGiris1X2State.Deger(
       birlerX,ondalikOnlarX,ondalikBirlerX, index, oran, dilSecimi, baslik,onBaslik);
}

class _DegerGiris1X2State extends State<DegerGiris1X2> {
  int birlerX = 0;
  int birlerX1 = 0;
  int ondalikOnlarX = 0;
  int ondalikOnlarX1 = 0;
  int ondalikBirlerX = 0;
  int ondalikBirlerX1 = 0;
  int index = 0;
  double oran;
  String dilSecimi;
  String baslik;
  String onBaslik;

  _DegerGiris1X2State.Deger(int gelenBirlerX,gelenOndalikOnlarX,gelenOndalikBirlerX,gelenIndex,
      double gelenOran, String gelenDil, String gelenBaslik,String gelenOnBaslik) {
    birlerX = gelenBirlerX;
    birlerX1 = gelenBirlerX;
    ondalikOnlarX =  gelenOndalikOnlarX;
    ondalikOnlarX1 = gelenOndalikOnlarX;
    ondalikBirlerX =  gelenOndalikBirlerX;
    ondalikBirlerX1 = gelenOndalikBirlerX;
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
                      Text(".",style: TextStyle(fontSize: 50*oran,fontWeight: FontWeight.bold),),
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
                                if (ondalikOnlarX < 9)
                                  ondalikOnlarX++;
                                else
                                  ondalikOnlarX = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              ondalikOnlarX.toString(),
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
                                if (ondalikOnlarX > 0)
                                  ondalikOnlarX--;
                                else
                                  ondalikOnlarX = 9;

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
                                if (ondalikBirlerX < 9)
                                  ondalikBirlerX++;
                                else
                                  ondalikBirlerX = 0;

                                setState(() {});
                              },
                            ),
                            Text(
                              ondalikBirlerX.toString(),
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
                                if (ondalikBirlerX > 0)
                                  ondalikBirlerX--;
                                else
                                  ondalikBirlerX = 9;

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
                    var deger = [birlerX, ondalikOnlarX, ondalikBirlerX, index];
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
                    var deger = [birlerX1, ondalikOnlarX1, ondalikBirlerX1, index];
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
