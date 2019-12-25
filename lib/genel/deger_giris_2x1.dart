

import 'package:flutter/material.dart';

class DegerGiris2X1 extends StatefulWidget {

  int X=0;
  int Y=0;
  int Z=0;
  int T=0;

  DegerGiris2X1.Deger(int onLar, int birLer, int onDalik, int deGerNo){


    X=onLar;
    Y=birLer;
    Z=onDalik;
    T=deGerNo;
  }




  @override
  _DegerGiris2X1State createState() => new _DegerGiris2X1State.Deger(X, Y, Z, T);
}



class _DegerGiris2X1State extends State<DegerGiris2X1> {

  int onlar=0;
  int birler=0;
  int ondalik=0;
  int degerNo=0;

  _DegerGiris2X1State.Deger(int x,int y , int z, int t){
    onlar=x;
    birler=y;
    ondalik=z;
    ondalik=z;
    degerNo=t;
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),

      backgroundColor: Colors.deepOrange.shade800,

      title: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(right: 10),
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
                      if(onlar<9)
                        onlar++;
                      else
                        onlar=0;

                      setState(() {

                      });
                    },
                  ),

                  Text(onlar.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                  RawMaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/images/deger_dusur_icon.png',
                      scale: 4,
                    ),

                    onPressed: (){

                      if(onlar>0)
                        onlar--;
                      else
                        onlar=9;

                      setState(() {

                      });

                    },
                  ),



                ],
              ),
            ),

            Column(
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

                    if(birler<9)
                      birler++;
                    else
                      birler=0;

                    setState(() {

                    });
                  },
                ),

                Text(birler.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/deger_dusur_icon.png',
                    scale: 4,
                  ),

                  onPressed: (){

                    if(birler>0)
                      birler--;
                    else
                      birler=9;

                    setState(() {

                    });
                  },
                ),



              ],
            ),

            Text(".",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

            Column(
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
                    if(ondalik<9)
                      ondalik++;
                    else
                      ondalik=0;

                    setState(() {

                    });
                  },
                ),

                Text(ondalik.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                RawMaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/deger_dusur_icon.png',
                    scale: 4,
                  ),

                  onPressed: (){

                    if(ondalik>0)
                      ondalik--;
                    else
                      ondalik=9;

                    setState(() {

                    });
                  },
                ),



              ],
            ),




          ],
        ),
      ),

      actions: <Widget>[

        Container(
          alignment: Alignment.center,
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){

                    var deger=[onlar,birler,ondalik,degerNo];
                    Navigator.of(context).pop(deger);

                  },
                  child: Text("ONAY",style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),),
                ),

              ),


              Container(
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){
                    var deger=[onlar,birler,ondalik,degerNo];
                    Navigator.of(context).pop(deger);
                  },
                  child: Text("ÇIKIŞ",style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),),
                ),
              ),

            ],
          ),
        ),


      ],

    );
  }
}