


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

Widget MyAutoSizeText(String dilSecimi, double oran, String metinCode, int maxLine, Alignment alignmentCont, TextAlign alignmentTex, bool boldDurum, Color textColor){

  return Expanded(
          flex: 1,
          child: SizedBox(
            child: Container(
              alignment: alignmentCont,
              child: AutoSizeText(
                Dil().sec(dilSecimi, metinCode),
                textAlign: alignmentTex,
                style: TextStyle(
                  fontFamily: 'Kelly Slab',
                  color: textColor,
                  fontSize: 100,
                ),
                maxLines: maxLine,
                minFontSize: 2,
              ),
            ),
          ),
        );
}
