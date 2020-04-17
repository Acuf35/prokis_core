

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/mywidgets/floatingActionButton.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/sabitVeriler.dart';
import 'package:provider/provider.dart';


class Adetler1 extends StatefulWidget {
  bool ilkKurulumMu = true;
  Adetler1(this.ilkKurulumMu);

  @override
  _Adetler1State createState() => _Adetler1State();
}

class _Adetler1State extends State<Adetler1> with TickerProviderStateMixin {

  final _fanAdetBloc = FanAdetBloC();

  int sayac=0;
  String dilSecimi = "TR";
  AnimationController _controller1;
  AnimationController _controller2;
   String fanAdet="10";



  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context).size.width / 731.4;
    _controller1 = AnimationController(vsync: this,duration: Duration(milliseconds: 3000),);
    _controller2 = AnimationController(vsync: this,duration: Duration(milliseconds: 3000),);
    //
    _controller1.repeat();
    _controller2.stop();

    return Scaffold(
      body: Column(
        children: <Widget>[
          //Başlık bölümü
          Expanded(flex:1,child: Container(color: Colors.grey[600],)),
          //Gövde
          Expanded(flex:2,child: Container(color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<Object>(
                        initialData: 7,
                        stream: _fanAdetBloc.fanAdet,
                        builder: (context, snapshot) {
                          return _unsurAdetWidget(
                            Dil().sec(dilSecimi, "tv12"),
                            'assets/images/kurulum_fan_icon.png',
                            oran,
                            snapshot.data.toString(),
                            SabitVeriler().adet1den60a,
                            1,
                            context);
                        }
                      ),
                      Expanded(
                        child: RaisedButton(onPressed: (){
                          _fanAdetBloc.fanAdetEventSink.add(FanAdetDegistir());
                        }),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Spacer(),
                Expanded(
                  child: Container(decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.red[800])),
                    child: AnimatedBuilder(animation: fanAdet!="474" ? _controller1 : _controller2,
                    builder: (context, child) => 
                                    RotationTransition(
                        turns:  fanAdet!="474" ? _controller1 : _controller2,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 0.0).animate(
                              fanAdet!="474" ? _controller1 : _controller2,
                              ),
                          child: Image.asset("assets/images/giris_rotate_icon.png"
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              
              ],
            ),


          ),),
          // ileri-Geri ok
          Expanded(flex:1,child: Container(color: Colors.grey[600],
            child: Row(
              children: <Widget>[
                Spacer(flex: 20,),
                //Geri ok
                Expanded(flex: 3,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Expanded(flex: 3,
                                              child: RawMaterialButton(
                          onPressed: (){},
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                          return Icon(
                            Icons.arrow_back_ios,
                            size: constraint.biggest.height,
                            color: Colors.black,
                          );
                        }),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          constraints: BoxConstraints(),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                //İleri ok
                Expanded(flex: 3,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Expanded(flex: 3,
                                              child: RawMaterialButton(
                          onPressed: (){},
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                          return Icon(
                            Icons.arrow_forward_ios,
                            size: constraint.biggest.height,
                            color: Colors.black,
                          );
                        }),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          constraints: BoxConstraints(),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                
              ],
            ),
          )),
        ],
      ),

    );
  }

  Widget _unsurAdetWidget(
      String baslik,
      String imagePath,
      double oran,
      String dropDownValue,
      List<String> liste,
      int adetCode,
      BuildContext context
      ) {

    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: AutoSizeText(
                  baslik,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Kelly Slab',
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 8,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage(imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  color: Colors.grey[300],
                  child: DropdownButton<String>(
                    isDense: true,
                    value: dropDownValue,
                    elevation: 16,
                    iconEnabledColor: Colors.black,
                    iconSize: 40 * oran,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Audio Wide',
                      fontSize: 30 * oran,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {

                      

/*
                      switch (adetCode) {
                        case 1:
                          _blocSinif.bloCVeriEventSink.add("fanAdet*$newValue*$adetCode");
                          print("Caseiçi"+newValue.toString());
                          break;

                        case 2:
                          _blocSinif.bloCVeriEventSink.add("klepeAdet*$newValue*$adetCode");
                          break;

                        case 3:
                          _blocSinif.bloCVeriEventSink.add("pedAdet*$newValue*$adetCode");
                          break;

                        case 4:
                          _blocSinif.bloCVeriEventSink.add("isiSensAdet*$newValue*$adetCode");
                          break;

                        case 5:
                          _blocSinif.bloCVeriEventSink.add("bacafanVarMi*$newValue*$adetCode");
                          break;

                        case 6:
                          _blocSinif.bloCVeriEventSink.add("airinletVarMi*$newValue*$adetCode");
                          break;

                        case 7:
                          _blocSinif.bloCVeriEventSink.add("isiticiAdet*$newValue*$adetCode");
                          break;

                        case 8:
                          _blocSinif.bloCVeriEventSink.add("siloAdet*$newValue*$adetCode");
                          break;
                      }

                      */

                      
                    },
                    items: liste.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          child: Text(value),
                          padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }



}



class FanAdetBloC{

  int _fanAdet=0;

  //state için stream controller

  final _fanAdetStateStreamController = StreamController<int>();
  Stream<int> get fanAdet => _fanAdetStateStreamController.stream;
  StreamSink<int> get _fanAdetStateSink => _fanAdetStateStreamController.sink;




  //eventler için stream controller

  final _fanAdetEventStreamController = StreamController<SayacEvent>();
  Stream<SayacEvent> get _fanAdetEventStream => _fanAdetEventStreamController.stream;
  StreamSink<SayacEvent> get fanAdetEventSink => _fanAdetEventStreamController.sink;


  FanAdetBloC(){

    print("GİRİYOR");
    
    _fanAdetEventStream.listen((event){

      if(event is FanAdetDegistir){
        _fanAdet++;
      }
      
      _fanAdetStateSink.add(_fanAdet);

    });
  
  
  }
    
    
}


abstract class SayacEvent {}

class FanAdetDegistir extends SayacEvent{}
class AzaltmaEvent extends SayacEvent{}