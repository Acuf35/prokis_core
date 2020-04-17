


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

Future MyshowModalBottomSheet2x0ve2xQ(String dilSecimi, BuildContext context, double oran, int xqByteOnlarAc, int xqByteBirlerAc, int xqBitAc,
int xqByteOnlarKapa, int xqByteBirlerKapa, int xqBitKapa, int xfOnlar, int xfBirler, String baslikNo, String baslikCikisNoAc, String baslikCikisNoKapa  ){

  int qByteOnlarAc=xqByteOnlarAc;
  int qByteBirlerAc=xqByteBirlerAc;
  int qBitAc=xqBitAc;
  int qByteOnlarKapa=xqByteOnlarKapa;
  int qByteBirlerKapa=xqByteBirlerKapa;
  int qBitKapa=xqBitKapa;
  int fOnlar=xfOnlar;
  int fBirler=xfBirler;

  return showModalBottomSheet<void>(
    isDismissible: false,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, state) {
                              return Container(
                                //color: Colors.white,
                                //height: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    //Başlık bölümü
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          // 1. Parametre Başlık
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, baslikNo),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // 2. Parametre Başlık
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              child: Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, baslikCikisNoAc),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // 3. Parametre Başlık
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              child: Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, baslikCikisNoKapa),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Parametre Gİriş Bölümü
                                    Expanded(
                                      flex: 10,
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(flex: 5,
                                              child: Row(children: <Widget>[
                                              //Unsur No Girişi
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5 * oran,
                                                    bottom: 5 * oran,
                                                    right: 2.5 * oran),
                                                padding: EdgeInsets.only(
                                                    top: 5 * oran,
                                                    bottom: 5 * oran),
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.deepOrange[700],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20 * oran))),
                                                child: Row(
                                                  children: <Widget>[
                                                    //Fan No onlar artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //Fan No ONLAR ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (fOnlar <
                                                                            9)
                                                                          fOnlar++;
                                                                        else
                                                                          fOnlar =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          //Fan No ONLAR DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  fOnlar
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Fan No ONLAR DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (fOnlar >
                                                                            0)
                                                                          fOnlar--;
                                                                        else
                                                                          fOnlar =
                                                                              9;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //Fan No birler artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //Fan No BİRLER ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (fBirler <
                                                                            9)
                                                                          fBirler++;
                                                                        else
                                                                          fBirler =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          //Fan No BİRLER DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  fBirler
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Fan No BİRLER DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (fBirler >
                                                                            0)
                                                                          fBirler--;
                                                                        else
                                                                          fBirler =
                                                                              9;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //Output NoAC Girişi
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 2.5 * oran,
                                                    bottom: 5 * oran,
                                                    right: 2.5 * oran),
                                                padding: EdgeInsets.only(
                                                    top: 5 * oran,
                                                    bottom: 5 * oran),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepOrange[700],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20 * oran)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    // Q HARFİ
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Spacer(),
                                                          //Q
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Q",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Fan No ONLAR DÜŞÜR
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                    //BYTE ONLAR
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BYTE ONLAR ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteOnlarAc <
                                                                            9)
                                                                          qByteOnlarAc++;
                                                                        else
                                                                          qByteOnlarAc =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          ////BYTE ONLAR DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  qByteOnlarAc
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ////BYTE ONLAR DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteOnlarAc >
                                                                            0)
                                                                          qByteOnlarAc--;
                                                                        else
                                                                          qByteOnlarAc =
                                                                              9;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //BYTE BİRLER
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BYTE BİRLER ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteBirlerAc <
                                                                            9)
                                                                          qByteBirlerAc++;
                                                                        else
                                                                          qByteBirlerAc =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          //Fan No BİRLER DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  qByteBirlerAc
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //BYTE BİRLER DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteBirlerAc >
                                                                            0)
                                                                          qByteBirlerAc--;
                                                                        else
                                                                          qByteBirlerAc =
                                                                              9;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // NOKTA İŞARETİ
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Spacer(),
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    AutoSizeText(
                                                                  ".",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                    //BIT KISMI
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BİT ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qBitAc <
                                                                            7)
                                                                          qBitAc++;
                                                                        else
                                                                          qBitAc =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          //BİT DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  qBitAc.toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Fan No BİRLER DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qBitAc >
                                                                            0)
                                                                          qBitAc--;
                                                                        else
                                                                          qBitAc =
                                                                              7;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //Output NoKAPA Girişi
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 2.5 * oran,
                                                    bottom: 5 * oran,
                                                    right: 2.5 * oran),
                                                padding: EdgeInsets.only(
                                                    top: 5 * oran,
                                                    bottom: 5 * oran),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepOrange[700],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20 * oran)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    // Q HARFİ
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Spacer(),
                                                          //Q
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Q",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Fan No ONLAR DÜŞÜR
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                    //BYTE ONLAR
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BYTE ONLAR ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteOnlarKapa <
                                                                            9)
                                                                          qByteOnlarKapa++;
                                                                        else
                                                                          qByteOnlarKapa =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          ////BYTE ONLAR DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  qByteOnlarKapa
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ////BYTE ONLAR DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteOnlarKapa >
                                                                            0)
                                                                          qByteOnlarKapa--;
                                                                        else
                                                                          qByteOnlarKapa =
                                                                              9;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //BYTE BİRLER
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BYTE BİRLER ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteBirlerKapa <
                                                                            9)
                                                                          qByteBirlerKapa++;
                                                                        else
                                                                          qByteBirlerKapa =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          //Fan No BİRLER DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  qByteBirlerKapa
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //BYTE BİRLER DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qByteBirlerKapa >
                                                                            0)
                                                                          qByteBirlerKapa--;
                                                                        else
                                                                          qByteBirlerKapa =
                                                                              9;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // NOKTA İŞARETİ
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Spacer(),
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    AutoSizeText(
                                                                  ".",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                    //BIT KISMI
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BİT ARTIR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qBitKapa <
                                                                            7)
                                                                          qBitKapa++;
                                                                        else
                                                                          qBitKapa =
                                                                              0;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                          //BİT DEĞER
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  qBitKapa.toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          100,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .white),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Fan No BİRLER DÜŞÜR
                                                          Expanded(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return RawMaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (qBitKapa >
                                                                            0)
                                                                          qBitKapa--;
                                                                        else
                                                                          qBitKapa =
                                                                              7;

                                                                        bottomDrawerIcindeGuncelle(
                                                                            state);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: constraints
                                                                            .biggest
                                                                            .height,
                                                                        color: Colors
                                                                            .deepOrange[700],
                                                                      ),
                                                                      hoverColor:
                                                                          Colors
                                                                              .red,
                                                                      splashColor:
                                                                          Colors
                                                                              .green,
                                                                      focusColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            
                                            ],)),
                                            //Onay-Çıkış Butonu
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 2.5 * oran,
                                                    bottom: 5 * oran,
                                                    right: 5 * oran),
                                                
                                                child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[

                                                  Container(
                                                    child: RaisedButton(
                                                      elevation: 14,
                                                      highlightColor: Colors.green,
                                                      splashColor: Colors.red,
                                                      color: Colors.indigo,
                                                      onPressed: (){
                                                        List x=[true,qByteOnlarAc,qByteBirlerAc,qBitAc,qByteOnlarKapa,qByteBirlerKapa,qBitKapa,fOnlar,fBirler];

                                                        Navigator.of(context).pop(x);
                                                        

                                                      },
                                                      child: Text(Dil().sec(dilSecimi, "btn2"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),textScaleFactor: oran,),
                                                    ),

                                                  ),


                                                  Container(
                                                    child: RaisedButton(
                                                      elevation: 14,
                                                      color: Colors.indigo,
                                                      highlightColor: Colors.green,
                                                      splashColor: Colors.red,
                                                      onPressed: (){
                                                        List x=[false,qByteOnlarAc,qByteBirlerAc,qBitAc,qByteOnlarKapa,qByteBirlerKapa,qBitKapa,fOnlar,fBirler];
                                                        Navigator.of(context).pop(x);
                                                      },
                                                      child: Text(Dil().sec(dilSecimi, "btn3"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),textScaleFactor: oran,),
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
                                  ],
                                ),
                              );
                            },
                          );
                        });

}

Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }