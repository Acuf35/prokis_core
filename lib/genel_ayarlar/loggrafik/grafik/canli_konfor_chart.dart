import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';

/// Example of a combo scatter plot chart with a second series rendered as a
/// line.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:prokis/genel_ayarlar/loggrafik/grafik.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class CanliKonforChart extends StatefulWidget {
  @override
  CanliKonforChartState createState() => CanliKonforChartState();
}

class CanliKonforChartState extends State<CanliKonforChart> {
  String dilSecimi = "EN";

  int timerSayac = 0;

  int yazmaSonrasiGecikmeSayaci = 0;

  bool timerCancel = false;

  bool baglanti = false;

  String baglantiDurum = "";

  String alarmDurum =
      "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  String ortSic = "0.0";
  String nem = "0.0";

  @override
  void dispose() {
    timerCancel = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context).size.width / 731.4;
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");

    if (timerSayac == 0) {
      Metotlar().takipEt("33*", 2236).then((veri) {
        if (veri.split("*")[0] == "error") {
          baglanti = false;
          baglantiDurum =
              Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
          setState(() {});
        } else {
          ortSic = veri.split("*")[0];
          nem = veri.split("*")[1];
          alarmDurum = veri.split("*")[2];
          print(veri);

          baglantiDurum = "";
          baglanti = false;
          if (!timerCancel) setState(() {});
        }
      });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          Metotlar().takipEt("33*", 2236).then((veri) {
            if (veri.split("*")[0] == "error") {
              baglanti = false;
              baglantiDurum =
                  Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
              setState(() {});
            } else {
              ortSic = veri.split("*")[0];
              nem = veri.split("*")[1];
              alarmDurum = veri.split("*")[2];
              print(veri);
              baglantiDurum = "";
              baglanti = false;
              if (!timerCancel) setState(() {});
            }
          });
        }
      });
    }

    timerSayac++;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv801a',
          Colors.blue, baglantiDurum, alarmDurum),
      floatingActionButton: Container(
        width: 56 * oran,
        height: 56 * oran,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              timerCancel = true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Grafik()),
              );
            },
            backgroundColor: Colors.purple,
            child: Icon(
              Icons.arrow_back,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          //saat ve tarih
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.grey[300],
                  padding: EdgeInsets.only(left: 10 * oran),
                  child: TimerBuilder.periodic(Duration(seconds: 1),
                      builder: (context) {
                    return Text(
                      Metotlar().getSystemTime(dbProkis.getDbVeri),
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontFamily: 'Kelly Slab',
                          fontSize: 12 * oran,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.grey[300],
                  padding: EdgeInsets.only(right: 10 * oran),
                  child: TimerBuilder.periodic(Duration(seconds: 1),
                      builder: (context) {
                    return Text(
                      Metotlar().getSystemDate(dbProkis.getDbVeri),
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontFamily: 'Kelly Slab',
                          fontSize: 12 * oran,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
            ],
          ),

          Expanded(
            flex: 40,
            child: Container(
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(color: Colors.white,
                      child: Column(
                        children: [
                          Spacer(),
                          Expanded(flex: 4,
                            child: Row(
                              children: [
                                Spacer(flex: 1,),

                                Expanded(
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: LayoutBuilder(builder: (context, constraint) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.brightness_1,
                                          ),
                                          iconSize: constraint.biggest.height,
                                          color: Colors.green,
                                          onPressed: () {},
                                        );
                                }),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                Expanded(flex: 3,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv802"),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontSize: 50,
                                                color: Colors.green
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: LayoutBuilder(builder: (context, constraint) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.brightness_1,
                                          ),
                                          iconSize: constraint.biggest.height,
                                          color: Colors.yellow[500],
                                          onPressed: () {},
                                        );
                                }),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                Expanded(flex: 3,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv803"),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontSize: 50,
                                                color: Colors.yellow[500]
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: LayoutBuilder(builder: (context, constraint) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.brightness_1,
                                          ),
                                          iconSize: constraint.biggest.height,
                                          color: Colors.orange,
                                          onPressed: () {},
                                        );
                                }),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                Expanded(flex: 3,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv804"),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontSize: 50,
                                                color: Colors.orange
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: LayoutBuilder(builder: (context, constraint) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.brightness_1,
                                          ),
                                          iconSize: constraint.biggest.height,
                                          color: Colors.red,
                                          onPressed: () {},
                                        );
                                }),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                Expanded(flex: 3,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv805"),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontSize: 50,
                                                color: Colors.red
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: LayoutBuilder(builder: (context, constraint) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.brightness_1,
                                          ),
                                          iconSize: constraint.biggest.height,
                                          color: Colors.purple,
                                          onPressed: () {},
                                        );
                                }),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                Expanded(flex: 3,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv806"),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontSize: 50,
                                                color: Colors.purple
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                
                                
                                Spacer(flex: 1,),
                              ],
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  Dil().sec(dilSecimi, "tv441") + "  (%)",
                                  style: TextStyle(
                                      fontFamily: "Kelly Slab",
                                      fontSize: 50,
                                      color: Colors.white),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 17,
                          child: Container(
                            color: Colors.white,
                            child: _chart2(oran),
                          ),
                        ),
                        Expanded(
                          flex: 2,

                          child: Column(
                            children: [
                              Spacer(flex: 4,),
                              Expanded(flex: 3,
                                child: SizedBox(
                                  child: Container(
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv661a"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        fontSize: 50,
                                        color: Colors.white
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 3,
                                child: SizedBox(
                                  child: Container(
                                    child: AutoSizeText(
                                      ortSic+" °C",
                                      style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        fontSize: 50,
                                        color: Colors.white
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 4,),
                              Expanded(flex: 3,
                                child: SizedBox(
                                  child: Container(
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv441a"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        fontSize: 50,
                                        color: Colors.white
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 3,
                                child: SizedBox(
                                  child: Container(
                                    child: AutoSizeText(
                                      nem+" %",
                                      style: TextStyle(
                                        fontFamily: 'Kelly Slab',
                                        fontSize: 50,
                                        color: Colors.white
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 6,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Container(
                        child: AutoSizeText(
                          Dil().sec(dilSecimi, "tv661") + "  (°C)",
                          style: TextStyle(
                              fontFamily: "Kelly Slab",
                              fontSize: 50,
                              color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      endDrawer: SizedBox(
        width: 320 * oran,
        child: Drawer(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      Dil().sec(dilSecimi, "tv801a"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Kelly Slab',
                      ),
                      textScaleFactor: oran,
                    ),
                    color: Colors.yellow[700],
                  ),
                ),
                Expanded(
                  flex: 17,
                  child: Container(
                    color: Colors.yellow[100],
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          dense: false,
                          title: Text(
                            Dil().sec(dilSecimi, "tv186"),
                            textScaleFactor: oran,
                          ),
                          subtitle: RichText(
                            text: TextSpan(children: <TextSpan>[
                              //Giriş metni
                              TextSpan(
                                  text: Dil().sec(dilSecimi, "info59"),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13 * oran)),
/*
                                TextSpan(
                                  text: '\n\n'+Dil().sec(dilSecimi, "tv673"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text:'\n'+ Dil().sec(dilSecimi, "ksltm20")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm3")+'\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11*oran,
                                  )
                                ),
                                */
                            ]),
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
      ),
      drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
    );
  }

  Widget _chart1(double oran) {
    return charts.ScatterPlotChart(_createSampleData(),
        animate: false,
        domainAxis: new charts.NumericAxisSpec(
          showAxisLine: true,
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(15),
              charts.TickSpec<num>(16),
              charts.TickSpec<num>(17),
              charts.TickSpec<num>(18),
              charts.TickSpec<num>(19),
              charts.TickSpec<num>(20),
              charts.TickSpec<num>(21),
              charts.TickSpec<num>(22),
              charts.TickSpec<num>(23),
              charts.TickSpec<num>(24),
              charts.TickSpec<num>(25),
              charts.TickSpec<num>(26),
              charts.TickSpec<num>(27),
              charts.TickSpec<num>(28),
              charts.TickSpec<num>(29),
              charts.TickSpec<num>(30),
              charts.TickSpec<num>(31),
              charts.TickSpec<num>(32),
              charts.TickSpec<num>(33),
              charts.TickSpec<num>(34),
              charts.TickSpec<num>(35),
              charts.TickSpec<num>(36),
              charts.TickSpec<num>(37),
              charts.TickSpec<num>(38),
              charts.TickSpec<num>(39),
              charts.TickSpec<num>(40),
            ],
          ),
          renderSpec: new charts.GridlineRendererSpec(
              //labelRotation: 50,
              labelOffsetFromAxisPx: (4 * oran).round(),

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: (10 * oran).round(), // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.gray.shade500)),
        ),
        primaryMeasureAxis: new charts.NumericAxisSpec(
          showAxisLine: true,
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(40),
              charts.TickSpec<num>(45),
              charts.TickSpec<num>(50),
              charts.TickSpec<num>(55),
              charts.TickSpec<num>(60),
              charts.TickSpec<num>(65),
              charts.TickSpec<num>(70),
              charts.TickSpec<num>(75),
              charts.TickSpec<num>(80),
              charts.TickSpec<num>(85),
              charts.TickSpec<num>(90),
              charts.TickSpec<num>(95),
              charts.TickSpec<num>(100),
            ],
          ),
          renderSpec: new charts.GridlineRendererSpec(
              //labelRotation: 50,
              labelOffsetFromAxisPx: (4 * oran).round(),

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: (10 * oran).round(), // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.gray.shade500)),
        ),
        customSeriesRenderers: [
          new charts.LineRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customLine',
              strokeWidthPx: 5,

              // Configure the regression line to be painted above the points.
              //
              // By default, series drawn by the point renderer are painted on
              // top of those drawn by a line renderer.
              layoutPaintOrder: charts.LayoutViewPaintOrder.point + 1),
        ]);
  }

  Widget _chart2(double oran) {
    return charts.LineChart(_createSampleData2(),
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: false,


        domainAxis: new charts.NumericAxisSpec(
          showAxisLine: true,
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(15),
              charts.TickSpec<num>(16),
              charts.TickSpec<num>(17),
              charts.TickSpec<num>(18),
              charts.TickSpec<num>(19),
              charts.TickSpec<num>(20),
              charts.TickSpec<num>(21),
              charts.TickSpec<num>(22),
              charts.TickSpec<num>(23),
              charts.TickSpec<num>(24),
              charts.TickSpec<num>(25),
              charts.TickSpec<num>(26),
              charts.TickSpec<num>(27),
              charts.TickSpec<num>(28),
              charts.TickSpec<num>(29),
              charts.TickSpec<num>(30),
              charts.TickSpec<num>(31),
              charts.TickSpec<num>(32),
              charts.TickSpec<num>(33),
              charts.TickSpec<num>(34),
              charts.TickSpec<num>(35),
              charts.TickSpec<num>(36),
              charts.TickSpec<num>(37),
              charts.TickSpec<num>(38),
              charts.TickSpec<num>(39),
              charts.TickSpec<num>(40),
            ],
          ),
          renderSpec: new charts.GridlineRendererSpec(
              //labelRotation: 50,
              labelOffsetFromAxisPx: (4 * oran).round(),

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: (10 * oran).round(), // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.gray.shade500)),
        ),
        primaryMeasureAxis: new charts.NumericAxisSpec(
          showAxisLine: true,
          viewport: charts.NumericExtents(40,100),
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(40),
              charts.TickSpec<num>(45),
              charts.TickSpec<num>(50),
              charts.TickSpec<num>(55),
              charts.TickSpec<num>(60),
              charts.TickSpec<num>(65),
              charts.TickSpec<num>(70),
              charts.TickSpec<num>(75),
              charts.TickSpec<num>(80),
              charts.TickSpec<num>(85),
              charts.TickSpec<num>(90),
              charts.TickSpec<num>(95),
              charts.TickSpec<num>(100),
            ],
          ),
          renderSpec: new charts.GridlineRendererSpec(
              //labelRotation: 50,
              labelOffsetFromAxisPx: (4 * oran).round(),

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: (10 * oran).round(), // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.gray.shade500)),
        ),
        customSeriesRenderers: [
          new charts.PointRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customPoint')
        ]);
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<LinearSales, num>> _createSampleData() {
    final desktopSalesData = [
      new LinearSales(double.parse(ortSic), double.parse(nem), 8.0),
      //new LinearSales(16, 45, 0),
      //new LinearSales(17, 50, 0),
      //new LinearSales(18, 55, 0),
      //new LinearSales(19, 60, 0),
      //new LinearSales(20, 65, 0),
      //new LinearSales(21, 70, 0),
      //new LinearSales(22, 75, 0),
      //new LinearSales(23, 80, 0),
      //new LinearSales(24, 85, 0),
      //new LinearSales(25, 90, 0),
      //new LinearSales(25, 25, 7.0),
    ];

    var myRegressionData = [
      new LinearSales(15, 96, 3.5),
      new LinearSales(40, 51, 3.5),
    ];

    var myRegressionData1 = [
      new LinearSales(15, 91, 3.5),
      new LinearSales(40, 46, 3.5),
    ];

    final maxMeasure = 90;
    return [
      new charts.Series<LinearSales, num>(
        id: 'Sales',
        // Providing a color function is optional.
        colorFn: (LinearSales sales, _) {
          // Bucket the measure column value into 3 distinct colors.
          final bucket = sales.sales / maxMeasure;

          if (bucket < 1 / 3) {
            return charts.MaterialPalette.blue.shadeDefault;
          } else if (bucket < 2 / 3) {
            return charts.MaterialPalette.red.shadeDefault;
          } else {
            return charts.MaterialPalette.green.shadeDefault;
          }
        },
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        // Providing a radius function is optional.
        radiusPxFn: (LinearSales sales, _) => sales.radius,
        data: desktopSalesData,
      ),
      new charts.Series<LinearSales, num>(
          id: 'Mobile1',
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          areaColorFn: (_, __) =>
              charts.MaterialPalette.blue.shadeDefault.lighter,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: myRegressionData)
        ..setAttribute(charts.rendererIdKey, 'customLine'),
      new charts.Series<LinearSales, num>(
          id: 'Mobile2',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          areaColorFn: (_, __) =>
              charts.MaterialPalette.purple.shadeDefault.lighter,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: myRegressionData1)
        // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<LinearSales2, num>> _createSampleData2() {

    final myFakeDesktopData = [
      new LinearSales2(15, 91, 3.5,Colors.white),
      new LinearSales2(40, 46, 3.5,Colors.white),
      //new LinearSales2(2, 100),
      //new LinearSales2(3, 75),
    ];

    var myFakeTabletData = [
      new LinearSales2(15, 5, 3.5,Colors.white),
      new LinearSales2(40, 5, 3.5,Colors.white),
      //new LinearSales2(2, 200),
      //new LinearSales2(3, 150),
    ];

    var myFakeMobileData = [
      new LinearSales2(15, 5, 3.5,Colors.white),
      new LinearSales2(40, 5, 3.5,Colors.white),
      //new LinearSales2(2, 300),
      //new LinearSales2(3, 225),
    ];

    var myFakeDigerData = [
      new LinearSales2(15, 5, 3.5,Colors.white),
      new LinearSales2(40, 5, 3.5,Colors.white),
      //new LinearSales2(2, 300),
      //new LinearSales2(3, 225),
    ];

    var myFakeDiger2Data = [
      new LinearSales2(15, 39, 3.5,Colors.white),
      new LinearSales2(40, 100, 3.5,Colors.white),
      //new LinearSales2(2, 300),
      //new LinearSales2(3, 225),
    ];

    final desktopSalesData = [
      new LinearSales2(double.parse(ortSic), double.parse(nem), 6.0,Colors.white),
      //new LinearSales(16, 45, 0),
      //new LinearSales(17, 50, 0),
      //new LinearSales(18, 55, 0),
      //new LinearSales(19, 60, 0),
      //new LinearSales(20, 65, 0),
      //new LinearSales(21, 70, 0),
      //new LinearSales(22, 75, 0),
      //new LinearSales(23, 80, 0),
      //new LinearSales(24, 85, 0),
      //new LinearSales(25, 90, 0),
      //new LinearSales(25, 25, 7.0),
    ];

    return [
      new charts.Series<LinearSales2, num>(
        id: 'Sales',
        // Providing a color function is optional.
        colorFn: (LinearSales2 sales, _) =>charts.MaterialPalette.black,
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        // Providing a radius function is optional.
        radiusPxFn: (LinearSales2 sales, _) => sales.radius,
        data: desktopSalesData,
      )..setAttribute(charts.rendererIdKey, 'customPoint'),
      new charts.Series<LinearSales2, num>(
        id: 'Desktop',
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light blue.
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green.withAlpha(75)),
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: myFakeDesktopData,
      ),
      new charts.Series<LinearSales2, num>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.yellow.withAlpha(75)),
        //areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: myFakeTabletData,
      ),
      new charts.Series<LinearSales2, num>(
        id: 'Mobile',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.orange.withAlpha(75)),
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: myFakeMobileData,
      ),
      new charts.Series<LinearSales2, num>(
        id: 'diger',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red[800].withAlpha(75)),
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: myFakeDigerData,
      ),
      new charts.Series<LinearSales2, num>(
        id: 'diger2',
        // colorFn specifies that the line will be green.
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        // areaColorFn specifies that the area skirt will be light green.
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purple[600].withAlpha(75)),
        domainFn: (LinearSales2 sales, _) => sales.year,
        measureFn: (LinearSales2 sales, _) => sales.sales,
        data: myFakeDiger2Data,
      ),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final double year;
  final double sales;
  final double radius;

  LinearSales(this.year, this.sales, this.radius);
}

/// Sample linear data type.
class LinearSales2 {
  final double year;
  final double sales;
  final double radius;
  final Color color;

  LinearSales2(this.year, this.sales, this.radius, this.color);
}
