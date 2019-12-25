

import 'package:flutter/material.dart';

class DegerGiris3X0 extends StatefulWidget {

  int X=0;
  int Y=0;
  int Z=0;
  int T=0;

  DegerGiris3X0.Deger(int yuzLer, int onLar, int birLer, int deGerNo){



    X=yuzLer;
    Y=onLar;
    Z=birLer;
    T=deGerNo;
  }




  @override
  _DegerGiris3X0State createState() => new _DegerGiris3X0State.Deger(X, Y, Z, T);
}



class _DegerGiris3X0State extends State<DegerGiris3X0> {

  int yuzler=0;
  int onlar=0;
  int birler=0;
  int degerNo=0;

  _DegerGiris3X0State.Deger(int x,int y , int z, int t){
    yuzler=x;
    onlar=y;
    birler=z;
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
                      if(yuzler<9)
                        yuzler++;
                      else
                        yuzler=0;

                      setState(() {

                      });
                    },
                  ),

                  Text(yuzler.toString(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,fontFamily: 'Kelly Slab'),),

                  RawMaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/images/deger_dusur_icon.png',
                      scale: 4,
                    ),

                    onPressed: (){

                      if(yuzler>0)
                        yuzler--;
                      else
                        yuzler=9;

                      setState(() {

                      });

                    },
                  ),



                ],
              ),
            ),

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

                    var deger=[yuzler,onlar,birler,degerNo];
                    Navigator.of(context).pop(deger);

                  },
                  child: Text("ONAY",style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: 'Audio wide'),),
                ),

              ),


              Container(
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: (){
                    var deger=[yuzler,onlar,birler,degerNo];
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