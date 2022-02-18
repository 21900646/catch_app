import 'dart:io';

import 'package:flutter/material.dart';
import 'package:catch_app/detectObject/camera.dart';
import 'dart:math' as math;
//import 'foundPeople/home.dart';
import '../../home.dart';
// import '../../speed.dart';
import 'home.dart';



class BndBox extends StatefulWidget{
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      this.model);

  @override
  State<BndBox> createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  var _x;
  var _w =0.0;
  var _y ;
  var _h =0.0;

  String warning_sign = "";


  Color color_person = Colors.grey;
  Color color_motorcycle = Colors.grey;


  Widget texting(){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(warning_sign, style: TextStyle(fontSize: 50, color: Colors.red), )
          ]
        ),
      );
    }
    Widget IconSignal(){
    return Transform.rotate(
      angle:90*math.pi/180 ,
        child: Column(
          children: [
            Icon(
              Icons.person,
              color:color_person,
              size: 100.0,
            ),
            Icon(
              Icons.motorcycle,
              color:color_motorcycle,
              size: 100.0,
            ),
          ]
        ),

    );
    }

   Widget IconSignal2(){
    return Transform.rotate(
      angle: 90*math.pi/180,
      child: Icon(
        Icons.escalator_warning_outlined,
        color:schoolzone?Colors.red:Colors.grey,
        size: 100.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _renderBoxes() {
      return widget.results.map((re) {
        print("here!!");
        print("result-> "+re['detectedClass']);
          _x = re["rect"]["x"];
          _w = re["rect"]["w"];
          _y = re["rect"]["y"];
          _h = re["rect"]["h"];

        var scaleW, scaleH, x, y, w, h;

        if (widget.screenH / widget.screenW > widget.previewH / widget.previewW) {
          scaleW = widget.screenH / widget.previewH * widget.previewW;
          scaleH = widget.screenH;
          var difW = (scaleW - widget.screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
          setState(() {
            _w = w;
            _h = h;
          });

        } else {
          scaleH = widget.screenW / widget.previewW * widget.previewH;
          scaleW = widget.screenW;
          var difH = (scaleH - widget.screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
          setState(() {
            _w = w;
            _h = h;
          });
        }

        if(re["detectedClass"]=='person'){
          print("사람 발견 !!!");//속도가 특정속도 이상일때만
          setState(() {
            person=true;
            warning_sign = "Person Warning!";
         // sleep(const Duration(seconds:10));
         // person=false;
          });
        }
        else{
          setState(() {
          //  person=false;
            warning_sign = "";
          });
        }
        //&& y <20
          if(re["detectedClass"]=='motorbike'){
            setState(() {
              color_motorcycle = Colors.red;
              warning_sign = "Motorcycle Warning!";
              // sleep(const Duration(seconds:10));
              // person=false;
            });
          }
          else{
            setState(() {
              color_motorcycle = Colors.grey;
              warning_sign = "";
            });
          }

          if(re["detectedClass"]=='phone'){
            print("phone발견 !!");
            setState(() {
              warning_sign = "phone Warning!";
              // sleep(const Duration(seconds:10));
              // person=false;
            });
          }
          else{
            setState(() {
              warning_sign = "";
            });
          }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            //여기부터 지우면 된다 !!!!
            padding: EdgeInsets.only(top: 5.0, left: 5.0),

            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: re["detectedClass"]=='person'?Color.fromRGBO(255, 0, 0, 1.0):Color.fromRGBO(0, 255, 0, 1.0),
            //     width: 3.0,
            //   ),
            // ),// 바운드 박스 부분임

            decoration: BoxDecoration(
              border: Border.all(
                color: re["detectedClass"]=='person'?Color.fromRGBO(255, 0, 0, 1.0):Color.fromRGBO(0, 255, 0, 1.0),
                width: 3.0,
              ),
            ),

            child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: re["detectedClass"]=='person'?Color.fromRGBO(255, 0, 0, 1.0):Color.fromRGBO(0, 255, 0, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Container(
      child:Stack(
        children:[
         // Column(
         //   children: [
         //     // IconSignal(),
         //     // IconSignal2(),
         //     Text(ocrText),
         //   ],
         // ),
          Text("hello"),
          texting(),
          Stack(children: _renderBoxes(),),
        ],
      )
    );
  }
}

