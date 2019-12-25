

import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class DegerGiris2X2X2X0 extends StatefulWidget {

  int XFan=0;
  int YFan=0;
  int XOutAc=0;
  int YOutAc=0;
  int XOutKapa=0;
  int YOutKapa=0;
  int deger=0;
  double oran;
  String dilSecimi;
  String noBaslik;

  DegerGiris2X2X2X0.Deger( int onLarNo, int birLerNo, int onLarOutAc, int birLerOutAc, int onLarOutKapa, int birLerOutKapa, int deGerNo, double o, String gelenDil,String baslik){



    
    XFan=onLarNo;
    YFan=birLerNo;
    XOutAc=onLarOutAc;
    YOutAc=birLerOutAc;
    XOutKapa=onLarOutKapa;
    YOutKapa=birLerOutKapa;
    deger=deGerNo;
    oran=o;
    dilSecimi=gelenDil;
    noBaslik=baslik;
  }




  @override
  _DegerGiris2X2X2X0State createState() => new _DegerGiris2X2X2X0State.Deger(XFan, YFan, XOutAc, YOutAc, XOutKapa, YOutKapa, deger, oran,dilSecimi,noBaslik);
}



class _DegerGiris2X2X2X0State extends State<DegerGiris2X2X2X0> {

  
  int onlarF=0;
  int onlarF1=0;
  int birlerF=0;
  int birlerF1=0;
  int onlarOAc=0;
  int onlarO1Ac=0;
  int birlerOAc=0;
  int birlerO1Ac=0;
  int onlarOKapa=0;
  int onlarO1Kapa=0;
  int birlerOKapa=0;
  int birlerO1Kapa=0;
  int degerNo=0;
  double oran;
  String dilSecimi;
  String noBaslik;

  _DegerGiris2X2X2X0State.Deger(int x1,int y1 , int x2, int y2, int x3, int y3, int t, double o,String gelenDil, String baslik){
    
    onlarF=x1;
    onlarF1=x1;
    birlerF=y1;
    birlerF1=y1;
    onlarOAc=x2;
    onlarO1Ac=x2;
    birlerOAc=y2;
    birlerO1Ac=y2;
    onlarOKapa=x3;
    onlarO1Kapa=x3;
    birlerOKapa=y3;
    birlerO1Kapa=y3;
    degerNo=t;
    oran=o;
    dilSecimi=gelenDil;
    noBaslik=baslik;
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(titlePadding: EdgeInsets.only(top: 10*oran),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),

      backgroundColor: Colors.deepOrange.shade800,

      title: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(child: Column(
              children: <Widget>[
                Text(SelectLanguage().selectStrings(dilSecimi, noBaslik),style: TextStyle(fontFamily: 'Kelly Slab', color: Colors.white),),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  Padding(
                  padding: EdgeInsets.only(right: 10*oran,top: 5*oran),
                  child: Column(
                    children: <Widget>[

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_artir_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){
                          if(onlarF<9)
                            onlarF++;
                          else
                            onlarF=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(onlarF.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(onlarF>0)
                            onlarF--;
                          else
                            onlarF=9;

                          setState(() {

                          });

                        },
                      ),



                    ],
                  ),
                ),

                  Padding(
                  padding: EdgeInsets.only(right: 10*oran,top: 5*oran),
                  child: Column(
                    children: <Widget>[

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_artir_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerF<9)
                            birlerF++;
                          else
                            birlerF=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(birlerF.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerF>0)
                            birlerF--;
                          else
                            birlerF=9;

                          setState(() {

                          });
                        },
                      ),



                    ],
                  ),
                ),

                ],),
              ],
            ),),


            Expanded(child: Column(
              children: <Widget>[
                Text(SelectLanguage().selectStrings(dilSecimi, "tv41"),style: TextStyle(fontFamily: 'Kelly Slab', color: Colors.white),),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Padding(
                  padding: EdgeInsets.only(right: 10*oran,top: 5*oran),
                  child: Column(
                    children: <Widget>[

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_artir_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(onlarOAc<9)
                            onlarOAc++;
                          else
                            onlarOAc=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(onlarOAc.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(onlarOAc>0)
                            onlarOAc--;
                          else
                            onlarOAc=9;

                          setState(() {

                          });
                        },
                      ),



                    ],
                  ),
                ),

                  Padding(
                  padding: EdgeInsets.only(right: 10*oran,top: 5*oran),
                  child: Column(
                    children: <Widget>[

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_artir_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerOAc<9)
                            birlerOAc++;
                          else
                            birlerOAc=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(birlerOAc.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerOAc>0)
                            birlerOAc--;
                          else
                            birlerOAc=9;

                          setState(() {

                          });
                        },
                      ),



                    ],
                  ),
                ),


                ],),
              ],
            ),),
            
            
            
            Expanded(child: Column(
              children: <Widget>[
                Text(SelectLanguage().selectStrings(dilSecimi, "tv42"),style: TextStyle(fontFamily: 'Kelly Slab', color: Colors.white),),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Padding(
                  padding: EdgeInsets.only(right: 10*oran,top: 5*oran),
                  child: Column(
                    children: <Widget>[

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_artir_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(onlarOKapa<9)
                            onlarOKapa++;
                          else
                            onlarOKapa=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(onlarOKapa.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(onlarOKapa>0)
                            onlarOKapa--;
                          else
                            onlarOKapa=9;

                          setState(() {

                          });
                        },
                      ),



                    ],
                  ),
                ),

                  Padding(
                  padding: EdgeInsets.only(right: 10*oran,top: 5*oran),
                  child: Column(
                    children: <Widget>[

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_artir_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerOKapa<9)
                            birlerOKapa++;
                          else
                            birlerOKapa=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(birlerOKapa.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerOKapa>0)
                            birlerOKapa--;
                          else
                            birlerOKapa=9;

                          setState(() {

                          });
                        },
                      ),



                    ],
                  ),
                ),


                ],),
              ],
            ),),
            


          ],
        ),
      ),

      actions: <Widget>[

        Container(
          alignment: Alignment.center,
          width: 500*oran,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){

                    var deger=[onlarF,birlerF,onlarOAc,birlerOAc,onlarOKapa,birlerOKapa,degerNo];
                    Navigator.of(context).pop(deger);

                  },
                  child: Text(SelectLanguage().selectStrings(dilSecimi, "btn2"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),),
                ),

              ),


              Container(
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){
                    var deger=[onlarF1,birlerF1,onlarO1Ac,birlerO1Ac,onlarO1Kapa,birlerO1Kapa,degerNo];
                    Navigator.of(context).pop(deger);
                  },
                  child: Text(SelectLanguage().selectStrings(dilSecimi, "btn3"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),),
                ),
              ),

            ],
          ),
        ),


      ],

    );
  }
}