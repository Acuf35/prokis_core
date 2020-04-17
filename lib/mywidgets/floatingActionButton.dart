import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/sistem/kurulum_ayarlari.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';

class MyFloatingActionBackButton extends StatelessWidget {
  bool ilkKurulumMu = true;
  bool alertGetir = false;
  double oran = 1;
  int butonEnBoy = 1;
  Color backgroundColor;
  Color iconColor;
  IconData icon;
  int sayfaKodu = 0;
  String uyariMetni="";

  MyFloatingActionBackButton(
      bool xilkKurulumMu,
      bool xAlertGetir,
      double xOran,
      int xButonEnBoy,
      Color xBackgroundColor,
      Color xIconColor,
      IconData xIcon,
      int xSayfaKodu,
      String xUyariMetni) {
    ilkKurulumMu = xilkKurulumMu;
    alertGetir = xAlertGetir;
    oran = xOran;
    butonEnBoy = xButonEnBoy;
    backgroundColor = xBackgroundColor;
    iconColor = xIconColor;
    icon = xIcon;
    sayfaKodu = xSayfaKodu;
    uyariMetni=xUyariMetni;
  }

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context,listen: false);
    return Visibility(
      visible: ilkKurulumMu,
      child: Container(
        width: butonEnBoy * oran,
        height: butonEnBoy * oran,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              if (alertGetir) {
                Metotlar().sayfaGeriAlert(context, dbProkis.dbVeriGetir(1, 1,""),
                    uyariMetni, sayfaKodu);
              } else {
                if (sayfaKodu == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KurulumAyarlari(),
                    ),
                  );
                }
              }
            },
            backgroundColor: backgroundColor,
            child: Icon(
              icon,
              size: 50,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
