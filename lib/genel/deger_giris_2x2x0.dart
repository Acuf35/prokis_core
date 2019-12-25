

import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class DegerGiris2X2X0 extends StatefulWidget {

  int XFan=0;
  int YFan=0;
  int XOut=0;
  int YOut=0;
  int deger=0;
  double oran;
  String dilSecimi;
  String noBaslik;

  DegerGiris2X2X0.Deger( int onLarFan, int birLerFan, int onLarOut, int birLerOut, int deGerNo, double o, String gelenDil,String baslik){



    
    XFan=onLarFan;
    YFan=birLerFan;
    XOut=onLarOut;
    YOut=birLerOut;
    deger=deGerNo;
    oran=o;
    dilSecimi=gelenDil;
    noBaslik=baslik;
  }




  @override
  _DegerGiris2X2X0State createState() => new _DegerGiris2X2X0State.Deger(XFan, YFan, XOut, YOut, deger, oran,dilSecimi,noBaslik);
}



class _DegerGiris2X2X0State extends State<DegerGiris2X2X0> {

  
  int onlarF=0;
  int onlarF1=0;
  int birlerF=0;
  int birlerF1=0;
  int onlarO=0;
  int onlarO1=0;
  int birlerO=0;
  int birlerO1=0;
  int degerNo=0;
  double oran;
  String dilSecimi;
  String noBaslik;

  _DegerGiris2X2X0State.Deger(int x1,int y1 , int x2, int y2, int t, double o,String gelenDil, String baslik){
    
    onlarF=x1;
    onlarF1=x1;
    birlerF=y1;
    birlerF1=y1;
    onlarO=x2;
    onlarO1=x2;
    birlerO=y2;
    birlerO1=y2;
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
                Text(SelectLanguage().selectStrings(dilSecimi, "tv35"),style: TextStyle(fontFamily: 'Kelly Slab', color: Colors.white),),
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

                          if(onlarO<9)
                            onlarO++;
                          else
                            onlarO=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(onlarO.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(onlarO>0)
                            onlarO--;
                          else
                            onlarO=9;

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

                          if(birlerO<9)
                            birlerO++;
                          else
                            birlerO=0;

                          setState(() {

                          });
                        },
                      ),

                      Text(birlerO.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                      RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'assets/images/deger_dusur_icon.png',
                          scale: 4,
                        ),

                        onPressed: (){

                          if(birlerO>0)
                            birlerO--;
                          else
                            birlerO=9;

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
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){

                    var deger=[onlarF,birlerF,onlarO,birlerO,degerNo];
                    Navigator.of(context).pop(deger);

                  },
                  child: Text(SelectLanguage().selectStrings(dilSecimi, "btn2"),style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),),
                ),

              ),


              Container(
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){
                    var deger=[onlarF1,birlerF1,onlarO1,birlerO1,degerNo];
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