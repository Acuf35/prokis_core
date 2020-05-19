import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sabitVeriler.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'adetler.dart';
import 'dil_secimi.dart';

class TemelAyarlar extends StatelessWidget {
  bool ilkKurulumMu = true;
  TemelAyarlar(this.ilkKurulumMu);
  String dilSecimi = "EN";



  final FocusNode _focusNodeKumesIsmi = FocusNode();

  int sayac = 0;

  @override
  Widget build(BuildContext context) {
    

    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1,"TR");
    var oran = MediaQuery.of(context).size.width / 731.4;

    return ChangeNotifierProvider<TemelAyarlarProvider>(
      create: (context) => TemelAyarlarProvider(context, dbProkis),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          final provider = Provider.of<TemelAyarlarProvider>(context);

          TextEditingController tec1 =
              new TextEditingController(text: provider.getKumesIsmi==null ? "" : provider.getKumesIsmi);
          TextEditingController tec2 =
              new TextEditingController(text: provider.getSifreAna==null ? "" : provider.getSifreAna);
          TextEditingController tec3 =
              new TextEditingController(text: provider.getSifreTekrar==null ? "" : provider.getSifreTekrar);

          _textFieldCursorPosition(tec1, provider.getKumesIsmi==null ? "" : provider.getKumesIsmi);
          _textFieldCursorPosition(tec2, provider.getSifreAna==null ? "" : provider.getSifreAna);
          _textFieldCursorPosition(tec3, provider.getSifreTekrar==null ? "" : provider.getSifreTekrar);

          _focusNodeKumesIsmi.addListener(() {
            if (!_focusNodeKumesIsmi.hasFocus && sayac == 0) {
              if (provider.getKumesIsmi.length < 4) {
                //Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!

                Toast.show(Dil().sec(dilSecimi, "toast1"), context,
                    duration: 2);
              } else {
                String komut='1*2*${provider.getKumesTuruIndex.toString()}*${provider.getKumesNo}*${provider.getKumesIsmi}*${provider.getSifreAna}';
                Metotlar().veriGonder(komut,2233).then((value) {
                  if(value.split("*")[0]=="error"){
                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                  }else{
                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                      dbProkis.dbSatirEkleGuncelle(
                    3,
                    provider.getKumesTuruIndex.toString(),
                    provider.getKumesNo,
                    provider.getKumesIsmi,
                    provider.getSifreAna);
                  }

                    });
                
              }
              sayac++;
            }
          });

          return Scaffold(
              extendBody: true,
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Başlık Bölümü
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  Dil().sec(dilSecimi, "tv2"),
                                  style: TextStyle(
                                      fontFamily: 'Kelly Slab',
                                      color: Colors.grey.shade600,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: oran,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 40*oran,
                                  width: 40*oran,
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return IconButton(
                                      padding: EdgeInsets.all(0),
                                      icon:Icon(Icons.info_outline,),
                                      iconSize: 35*oran,
                                      color: Colors.grey[700],
                                      onPressed: ()=>Scaffold.of(context).openEndDrawer(),
                                      );
                                    }
                                  ),
                                ),
                              ),
                            
                            ],
                          ),
                        ),
                        // Ayarlar Bölümü
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.grey.shade600,
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                //Kümes Türü ve Kümes No Bölümü
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      //Kümes Türü Bölümü
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              Dil().sec(dilSecimi,
                                                  "tv3"), //Kümes Türü
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[300]),
                                              textScaleFactor: oran,
                                            ),
                                            Container(
                                              height: 5 * oran,
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: DropdownButton<String>(
                                                isDense: true,
                                                value: provider.getKumesTuru,
                                                elevation: 16,
                                                iconEnabledColor: Colors.black,
                                                iconSize: 40 * oran,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontFamily: 'Audio Wide',
                                                  fontSize: 20 * oran,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                onChanged: (String newValue) {
                                                  provider.setkumesTuru =
                                                      newValue;
                                                  if (provider.getKumesTuru ==
                                                      Dil().sec(
                                                          dilSecimi, "dd1")) {
                                                    provider.setkumesTuruIndex =
                                                        1;
                                                  } else if (provider
                                                          .getKumesTuru ==
                                                      Dil().sec(
                                                          dilSecimi, "dd2")) {
                                                    provider.setkumesTuruIndex =
                                                        2;
                                                  } else if (provider
                                                          .getKumesTuru ==
                                                      Dil().sec(
                                                          dilSecimi, "dd3")) {
                                                    provider.setkumesTuruIndex =
                                                        3;
                                                  }
                                                  String komut='1*2*${provider.getKumesTuruIndex.toString()}*${provider.getKumesNo}*${provider.getKumesIsmi}*${provider.getSifreAna}';

                                                  Metotlar().veriGonder(komut,2233).then((value) {
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                        dbProkis.dbSatirEkleGuncelle(
                                                      3,
                                                      provider.getKumesTuruIndex
                                                          .toString(),
                                                      provider.getKumesNo,
                                                      provider.getKumesIsmi,
                                                      provider.getSifreAna);
                                                    }
                                                      });
                                                  
                                                },
                                                items: <String>[
                                                  Dil().sec(dilSecimi, "dd1"),
                                                  Dil().sec(dilSecimi, "dd2"),
                                                  Dil().sec(dilSecimi, "dd3")
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Container(
                                                      child: Text(value),
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 0,
                                                          top: 0),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Kümes No Bölümü
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              Dil().sec(dilSecimi, "tv4"),
                                              textScaleFactor: oran,
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[300]),
                                            ),
                                            Container(
                                              height: 5 * oran,
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: DropdownButton<String>(
                                                isDense: true,
                                                value: provider.getKumesNo,
                                                elevation: 16,
                                                iconEnabledColor: Colors.black,
                                                iconSize: 40 * oran,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontFamily: 'Audio Wide',
                                                  fontSize: 30 * oran,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                underline: Container(
                                                  height: 1,
                                                  color: Colors.grey.shade600,
                                                ),
                                                onChanged: (String newValue) {
                                                  provider.setkumesNo =
                                                      newValue;
                                                  String komut='1*2*${provider.getKumesTuruIndex.toString()}*${provider.getKumesNo}*${provider.getKumesIsmi}*${provider.getSifreAna}';
                                                  Metotlar().veriGonder(komut,2233).then((value) {
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                        dbProkis.dbSatirEkleGuncelle(
                                                        3,
                                                        provider.getKumesTuruIndex
                                                            .toString(),
                                                        provider.getKumesNo,
                                                        provider.getKumesIsmi,
                                                        provider.getSifreAna);
                                                    }
                                                      });
                                                  
                                                },
                                                items: SabitVeriler()
                                                    .adet1den10a
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: SizedBox(
                                                        width: 50 * oran,
                                                        child: Text(
                                                          value,
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Kümes Adı Bölümü
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              Dil().sec(dilSecimi, "tv5"),
                                              style: TextStyle(
                                                  color: Colors.grey.shade300,
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              textScaleFactor: oran,
                                            ),
                                            TextField(
                                              focusNode: _focusNodeKumesIsmi,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22 * oran,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Audio wide'),
                                              textAlign: TextAlign.center,
                                              cursorColor: Colors.pink,
                                              maxLength: 15,
                                              controller: tec1,
                                              onTap: () {
                                                sayac = 0;
                                              },
                                              onChanged: (String metin) {
                                                provider.setkumesIsmi = metin;
                                              },
                                              onSubmitted: (metin) {
                                                _focusNodeKumesIsmi.unfocus();
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 2 * oran,
                                                    top: 5 * oran),
                                                isDense: true,
                                                counterStyle: TextStyle(
                                                    fontSize: 14 * oran,
                                                    color: Colors.grey.shade300,
                                                    fontFamily: 'Kelly Slab'),
                                                hintText:
                                                    Dil().sec(dilSecimi, "tv6"),
                                                hintStyle: TextStyle(
                                                    fontSize: 14 * oran,
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    fontFamily: 'Kelly Slab'),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                )),
                                //Yetki şifresi bölümü
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    //Admin Şifresi
                                    Row(
                                      children: <Widget>[
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  Dil().sec(dilSecimi, "tv8"),
                                                  style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textScaleFactor: oran,
                                                ),
                                                TextField(
                                                  controller: tec2,
                                                  style: TextStyle(
                                                      fontFamily: 'Audio wide',
                                                      color: Colors.white,
                                                      fontSize: 20 * oran),
                                                  textAlign: TextAlign.center,
                                                  maxLength: 4,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  obscureText:
                                                      provider.getSifreGor1 ==
                                                              true
                                                          ? false
                                                          : true,
                                                  onChanged: (String metin) {
                                                    provider.setadminSifreLimit1 =
                                                        4 - metin.length;
                                                    provider.setsifreAna =
                                                        metin;
                                                    if (provider.getSifreAna !=
                                                            "" &&
                                                        provider.getSifreAna ==
                                                            provider
                                                                .getSifreTekrar) {
                                                      provider.setsifreUyusma =
                                                          true;
                                                    } else {
                                                      provider.setsifreUyusma =
                                                          false;
                                                    }

                                                    if (provider.getSifreAna ==
                                                            provider
                                                                .getSifreTekrar &&
                                                        provider.getSifreAna !=
                                                            provider
                                                                .getSifreAnaGecici) {
                                                      provider.setsifreOnaylandi =
                                                          false;
                                                    }

                                                    if (provider.getSifreAna ==
                                                            provider
                                                                .getSifreTekrar &&
                                                        provider.getSifreAna ==
                                                            provider
                                                                .getSifreAnaGecici) {
                                                      provider.setsifreOnaylandi =
                                                          true;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 3 * oran,
                                                            top: 3 * oran),
                                                    counterStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade300,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontSize: 12 * oran),
                                                    hintText: Dil()
                                                        .sec(dilSecimi, "tv7"),
                                                    hintStyle: TextStyle(
                                                        fontSize: 12 * oran,
                                                        backgroundColor: Colors
                                                            .grey.shade300,
                                                        fontFamily:
                                                            'Kelly Slab'),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        IconButton(
                                          color: Colors.white,
                                          icon: Icon(
                                              provider.getSifreGor1 == false
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                          onPressed: () {
                                            provider.getSifreGor1 == true
                                                ? provider.setsifreGor1 = false
                                                : provider.setsifreGor1 = true;
                                          },
                                          iconSize: 20 * oran,
                                        )
                                      ],
                                    ),
                                    //Admin şifresi tekrar
                                    Row(
                                      children: <Widget>[
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  Dil().sec(dilSecimi, "tv10"),
                                                  style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textScaleFactor: oran,
                                                ),
                                                TextField(
                                                  controller: tec3,
                                                  style: TextStyle(
                                                      fontFamily: 'Audio wide',
                                                      color: Colors.white,
                                                      fontSize: 20 * oran),
                                                  textAlign: TextAlign.center,
                                                  maxLength: 4,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  obscureText:
                                                      provider.getSifreGor2 ==
                                                              true
                                                          ? false
                                                          : true,
                                                  onChanged: (String metin) {
                                                    provider.setadminSifreLimit2 =
                                                        4 - metin.length;
                                                    provider.setsifreTekrar =
                                                        metin;
                                                    if (provider.getSifreAna !=
                                                            "" &&
                                                        provider.getSifreAna ==
                                                            provider
                                                                .getSifreTekrar) {
                                                      provider.setsifreUyusma =
                                                          true;
                                                    } else {
                                                      provider.setsifreUyusma =
                                                          false;
                                                    }

                                                    if (provider.getSifreAna ==
                                                            provider
                                                                .getSifreTekrar &&
                                                        provider.getSifreTekrar !=
                                                            provider
                                                                .getSifreTekrarGecici) {
                                                      provider.setsifreOnaylandi =
                                                          false;
                                                    }

                                                    if (provider.getSifreAna ==
                                                            provider
                                                                .getSifreTekrar &&
                                                        provider.getSifreTekrar ==
                                                            provider
                                                                .getSifreTekrarGecici) {
                                                      provider.setsifreOnaylandi =
                                                          true;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 3 * oran,
                                                            top: 3 * oran),
                                                    counterStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade300,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontSize: 12 * oran),
                                                    hintText: Dil()
                                                        .sec(dilSecimi, "tv9"),
                                                    hintStyle: TextStyle(
                                                        fontSize: 12 * oran,
                                                        backgroundColor: Colors
                                                            .grey.shade300,
                                                        fontFamily:
                                                            'Kelly Slab'),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        IconButton(
                                          color: Colors.white,
                                          icon: Icon(
                                              provider.getSifreGor2 == false
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                          onPressed: () {
                                            provider.getSifreGor2 == true
                                                ? provider.setsifreGor2 = false
                                                : provider.setsifreGor2 = true;
                                          },
                                          iconSize: 20 * oran,
                                        )
                                      ],
                                    ),
                                    //Şifreleri kontrol
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(3 * oran),
                                            child: Visibility(
                                              visible: provider.getSifreUyusma,
                                              maintainAnimation: true,
                                              maintainState: true,
                                              maintainSize: true,
                                              child: RawMaterialButton(
                                                onPressed: () async {
                                                  if (!provider
                                                      .getSifreUyusma) {
                                                    //Şifreler uyuşmuyor!
                                                    Toast.show(
                                                        Dil().sec(dilSecimi,
                                                            "toast3"),
                                                        context,
                                                        duration: 2);
                                                  } else if (provider
                                                          .getAdminSifreLimit1 !=
                                                      0) {
                                                    //Lütfen 4 karakterlik bir şifre belirleyiniz!
                                                    Toast.show(
                                                        Dil().sec(dilSecimi,
                                                            "toast2"),
                                                        context,
                                                        duration: 2);
                                                  } else {
                                                    String komut='1*2*${provider.getKumesTuruIndex.toString()}*${provider.getKumesNo}*${provider.getKumesIsmi}*${provider.getSifreAna}';
                                                    Metotlar().veriGonder(komut,2233).then((value) {
                                                      if(value.split("*")[0]=="error"){
                                                        Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                      }else{
                                                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                        provider.setsifreOnaylandi=true;

                                                        dbProkis.dbSatirEkleGuncelle(
                                                        3,
                                                        provider
                                                            .getKumesTuruIndex
                                                            .toString(),
                                                        provider.getKumesNo,
                                                        provider.getKumesIsmi,
                                                        provider.getSifreAna);
                                                      }
                                                      });

                                                  }
                                                },
                                                fillColor:
                                                    provider.getSifreOnaylandi
                                                        ? Colors.green.shade400
                                                        : Colors.blue[300],
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      3.0 * oran),
                                                  child: Text(
                                                    Dil()
                                                        .sec(dilSecimi, "btn1"),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: oran,
                                                  ),
                                                ),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                constraints: BoxConstraints(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                Dil().sec(dilSecimi, "tv36"),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Kelly Slab',
                                                    fontSize: 12),
                                                textScaleFactor: oran,
                                              ),
                                              Icon(
                                                provider.getSifreUyusma == true
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color:
                                                    provider.getSifreUyusma ==
                                                            true
                                                        ? Colors.green.shade400
                                                        : Colors.red,
                                                size: 17 * oran,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                        // Sayfa geçiş okları bölümü
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 20,
                                      ),
                                      //geri OK
                                      Expanded(
                                          flex: 2,
                                          child: Visibility(
                                            visible: ilkKurulumMu,
                                            maintainState: true,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_back_ios),
                                              iconSize: 50 * oran,
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DilSecimi(true)));
                                              },
                                              color: Colors.black,
                                            ),
                                          )),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      //ileri OK
                                      Expanded(
                                          flex: 2,
                                          child: Visibility(
                                            visible: ilkKurulumMu,
                                            maintainState: true,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            child: IconButton(
                                              icon:
                                                  Icon(Icons.arrow_forward_ios),
                                              iconSize: 50 * oran,
                                              onPressed: () {
                                                if (provider
                                                        .getKumesIsmi.length <
                                                    4) {
                                                  //Lütfen en az 4 karakterlik bir kümes ismi belirleyiniz!
                                                  Toast.show(
                                                      Dil().sec(
                                                          dilSecimi, "toast1"),
                                                      context,
                                                      duration: 2);
                                                } else if (provider
                                                        .getAdminSifreLimit1 !=
                                                    0) {
                                                  //Lütfen 4 karakterlik bir şifre belirleyiniz!
                                                  Toast.show(
                                                      Dil().sec(
                                                          dilSecimi, "toast2"),
                                                      context,
                                                      duration: 2);
                                                } else if (!provider
                                                    .getSifreUyusma) {
                                                  //Şifreler uyuşmuyor!
                                                  Toast.show(
                                                      Dil().sec(
                                                          dilSecimi, "toast3"),
                                                      context,
                                                      duration: 2);
                                                } else if (!provider
                                                    .getSifreOnaylandi) {
                                                  //Girilen Şifreyi onaylamadınız!
                                                  Toast.show(
                                                      Dil().sec(
                                                          dilSecimi, "toast19"),
                                                      context,
                                                      duration: 2);
                                                } else {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Adetler(true)));
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: MyFloatingActionBackButton(
                  !ilkKurulumMu,
                  !provider.getSifreOnaylandi,
                  oran,
                  40,
                  Colors.grey[700],
                  Colors.white,
                  Icons.arrow_back,
                  1,
                  "tv563"),
          
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
                            Dil().sec(dilSecimi, "tv2"), 
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
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      //Giriş metni
                                      TextSpan(
                                        text: Dil().sec(dilSecimi, "info44"),
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13*oran
                                        )
                                      ),

                                      
                                    ]
                                  ),
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
    
          
          
          );
        },
      ),
    );
  }

  _textFieldCursorPosition(TextEditingController tec, String str) {
    tec
      ..text = str
      ..selection =
          TextSelection.collapsed(offset: str.length != null ? str.length : 0);
  }
}

class TemelAyarlarProvider with ChangeNotifier {
  String _dilSecimi;
  String _kumesTuru;
  int _kumesTuruIndex;
  String _kumesNo;
  int _kumesIsimLimit;
  int _adminSifreLimit1;
  int _adminSifreLimit2;
  bool _sifreGor1;
  bool _sifreGor2;

  String _kumesIsmi;
  String _sifreAna;
  String _sifreAnaGecici;
  String _sifreTekrar;
  String _sifreTekrarGecici;
  bool _sifreUyusma;
  bool _sifreOnaylandi;

  String get getKumesTuru => _kumesTuru;

  set setkumesTuru(String value) {
    _kumesTuru = value;
    notifyListeners();
  }

  int get getKumesTuruIndex => _kumesTuruIndex;

  set setkumesTuruIndex(int value) {
    _kumesTuruIndex = value;
    notifyListeners();
  }

  String get getKumesNo => _kumesNo;

  set setkumesNo(String value) {
    _kumesNo = value;
  }

  int get getKumesIsimLimit => _kumesIsimLimit;

  set setkumesIsimLimit(int value) {
    _kumesIsimLimit = value;
    notifyListeners();
  }

  int get getAdminSifreLimit1 => _adminSifreLimit1;

  set setadminSifreLimit1(int value) {
    _adminSifreLimit1 = value;
    notifyListeners();
  }

  int get getAdminSifreLimit2 => _adminSifreLimit2;

  set setadminSifreLimit2(int value) {
    _adminSifreLimit2 = value;
    notifyListeners();
  }

  bool get getSifreGor1 => _sifreGor1;

  set setsifreGor1(bool value) {
    _sifreGor1 = value;
    notifyListeners();
  }

  bool get getSifreGor2 => _sifreGor2;

  set setsifreGor2(bool value) {
    _sifreGor2 = value;
    notifyListeners();
  }

  String get getKumesIsmi => _kumesIsmi;

  set setkumesIsmi(String value) {
    _kumesIsmi = value;
    notifyListeners();
  }

  String get getSifreAna => _sifreAna;

  set setsifreAna(String value) {
    _sifreAna = value;
    notifyListeners();
  }

  String get getSifreAnaGecici => _sifreAnaGecici;

  set setsifreAnaGecici(String value) {
    _sifreAnaGecici = value;
    notifyListeners();
  }

  String get getSifreTekrar => _sifreTekrar;

  set setsifreTekrar(String value) {
    _sifreTekrar = value;
    notifyListeners();
  }

  String get getSifreTekrarGecici => _sifreTekrarGecici;

  set setsifreTekrarGecici(String value) {
    _sifreTekrarGecici = value;
    notifyListeners();
  }

  bool get getSifreUyusma => _sifreUyusma;

  set setsifreUyusma(bool value) {
    _sifreUyusma = value;
    notifyListeners();
  }

  bool get getSifreOnaylandi => _sifreOnaylandi;

  set setsifreOnaylandi(bool value) {
    _sifreOnaylandi = value;
    notifyListeners();
  }

  BuildContext context;
  DBProkis dbProkis;

  TemelAyarlarProvider(this.context, this.dbProkis) {
    _dilSecimi = dbProkis.dbVeriGetir(1, 1,"EN");

    switch (dbProkis.dbVeriGetir(3, 1,"1")) {
      case "1":
        _kumesTuru = Dil().sec(_dilSecimi, "dd1");
        break;

      case "2":
        _kumesTuru = Dil().sec(_dilSecimi, "dd2");
        break;

      case "3":
        _kumesTuru = Dil().sec(_dilSecimi, "dd3");
        break;

      default:
        _kumesTuru = Dil().sec(_dilSecimi, "dd1");
    }

    _kumesTuruIndex = int.parse(dbProkis.dbVeriGetir(3, 1,"1"));
    _kumesNo = dbProkis.dbVeriGetir(3, 2,"1");
    _kumesIsmi =dbProkis.dbVeriGetir(3, 3,"");
    _sifreAna = dbProkis.dbVeriGetir(3, 4,"");
    _sifreAnaGecici = _sifreAna;
    _sifreTekrar = _sifreAna;
    _sifreTekrarGecici = _sifreAna;
    _sifreOnaylandi = _sifreAna!="";
    _sifreUyusma =
        (_sifreAna == _sifreTekrar && _sifreAna != "" && _sifreTekrar != "")
            ? true
            : false;
    _sifreOnaylandi = _sifreAna!="" && _sifreUyusma ? true : false;
    _adminSifreLimit1 = 4 - _sifreAna.length;
    _adminSifreLimit2 = 4 - _sifreTekrar.length;
    _sifreGor1 = _sifreAna == "yok" ? true : false;
    _sifreGor2 = _sifreTekrar == "yok" ? true : false;
  }
}
