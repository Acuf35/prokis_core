


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

Future MyshowModalBottomSheet1to6x0(String dilSecimi, BuildContext context, double oran, int xqByteOnlar, int xqByteBirler, int xqBit, int xfOnlar, int xfBirler, String baslikNo, String baslikCikis  ){

  int qByteOnlar=xqByteOnlar;
  int qByteBirler=xqByteBirler;
  int qBit=xqBit;
  int fOnlar=xfOnlar;
  int fBirler=xfBirler;

  return showModalBottomSheet<void>(
    isDismissible: false,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, state) {
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    //Başlık bölümü
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          // 1. Parametre Başlık
                                          Expanded(
                                            flex: 4,
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
                                          // Onay boşluğu
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "btn2"),
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
                                        child: Row(
                                          children: <Widget>[
                                            //Unsur No Girişi
                                            Expanded(
                                              flex: 4,
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
                                                    Spacer(),
                                                    //yüzbinler artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //yüzbinler ARTIR
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
                                                          //yüzbinler DEĞER
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
                                                          //yüzbinler DÜŞÜR
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
                                                    //onbinler artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //onbinler ARTIR
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
                                                          //onbinler DEĞER
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
                                                          //onbinler DÜŞÜR
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
                                                    //binler artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //binler ARTIR
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
                                                          //binler DEĞER
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
                                                          //binler DÜŞÜR
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
                                                    //yüzler artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BİRLER ARTIR
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
                                                          //BİRLER DEĞER
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
                                                          //BİRLER DÜŞÜR
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
                                                    //onlar artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //yüzler ARTIR
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
                                                          //yüzler DEĞER
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
                                                          //ONLAR DÜŞÜR
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
                                                    //birler artır - azalt
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          //BİRLER ARTIR
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
                                                          //BİRLER DEĞER
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
                                                          //BİRLER DÜŞÜR
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
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //Onay-Çıkış Butonu
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 2.5 * oran,
                                                    bottom: 5 * oran,
                                                    right: 5 * oran),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20 * oran),
                                                            color: Colors.deepOrange[700],
                                                ),
                                                
                                                child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[

                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Spacer(flex: 2,),
                                                        Expanded(flex: 3,
                                                          child: RaisedButton(
                                                            elevation: 14,
                                                            highlightColor: Colors.green,
                                                            splashColor: Colors.red,
                                                            color: Colors.indigo,
                                                            onPressed: (){
                                                              List x=[true,qByteOnlar,qByteBirler,qBit,fOnlar,fBirler];

                                                              Navigator.of(context).pop(x);
                                                              

                                                            },
                                                            child: Text(Dil().sec(dilSecimi, "btn2"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),textScaleFactor: oran,),
                                                          ),
                                                        ),
                                                        Spacer(flex: 2,)
                                                      ],
                                                    ),

                                                  ),


                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Spacer(flex: 2,),
                                                        Expanded(flex: 3,
                                                          child: RaisedButton(
                                                            elevation: 14,
                                                            color: Colors.indigo,
                                                            highlightColor: Colors.green,
                                                            splashColor: Colors.red,
                                                            onPressed: (){
                                                              List x=[false,qByteOnlar,qByteBirler,qBit,fOnlar,fBirler];
                                                              Navigator.of(context).pop(x);
                                                            },
                                                            child: Text(Dil().sec(dilSecimi, "btn3"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),textScaleFactor: oran,),
                                                          ),
                                                        ),
                                                        Spacer(flex: 2,)
                                                      ],
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