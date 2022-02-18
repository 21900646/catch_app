import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as math;


double speed=0.0;
var speedInMps=0;
double velocity = 0;

class Speed extends StatefulWidget {
 // Speed({Key key}) : super(key: key);

  @override
  _SpeedState createState() => _SpeedState();
}

class _SpeedState extends State<Speed> {
  late List<double> _accelerometerValues;

  double highestVelocity = 0.0;

  double xIc1 = -25.0;
  double xIc2 = 0.0;
  double xIc3 = -10.0;
  double scale = 1920 / 1080;





  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z
    );

    if ((newVelocity - velocity).abs() < 1) {
      return;
    }

    setState(() {
      velocity = newVelocity;

      if (velocity > highestVelocity) {
        highestVelocity = velocity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
     mainAxisAlignment: MainAxisAlignment.start,
     // crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Icon(Icons.speed,
          color:Colors.white,
        ),

        Text(
                ' '+'${velocity.toInt()}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50.w,
          ),
        ),


      ],

    );
  }



  // Widget parallax() {
  //   return new Stack(
  //     children: <Widget>[
  //       new Positioned(
  //           left: xIc1,
  //           bottom: 0,
  //           top: 0,
  //           child: new Container(
  //             width: MediaQuery.of(context).size.width + 250,
  //             height: MediaQuery.of(context).size.height,
  //             decoration: new BoxDecoration(
  //                 image: new DecorationImage(
  //                     fit: BoxFit.cover,
  //                     image: new AssetImage('assets/layer_01_1920x1080.png'))),
  //           )),
  //       new Positioned(
  //           left: xIc2,
  //           bottom: 0,
  //           child: new Container(
  //             width: MediaQuery.of(context).size.width + 250,
  //             height: (MediaQuery.of(context).size.width + 250) / scale,
  //             decoration: new BoxDecoration(
  //                 image: new DecorationImage(
  //                     fit: BoxFit.fill,
  //                     image: new AssetImage('assets/layer_02_1920x1080.png'))),
  //           )),
  //       new Positioned(
  //           left: xIc3,
  //           bottom: 0,
  //           child: new Container(
  //             width: MediaQuery.of(context).size.width + 100,
  //             height: (MediaQuery.of(context).size.width + 100) / scale,
  //             decoration: new BoxDecoration(
  //                 image: new DecorationImage(
  //                     fit: BoxFit.cover,
  //                     image: new AssetImage('assets/layer_03_1920x1080.png'))),
  //           )),
  //       new Positioned(
  //           left: xIc2,
  //           bottom: 0,
  //           child: new Container(
  //             width: MediaQuery.of(context).size.width + 100,
  //             height: (MediaQuery.of(context).size.width + 100) / scale,
  //             decoration: new BoxDecoration(
  //                 image: new DecorationImage(
  //                     fit: BoxFit.cover,
  //                     image: new AssetImage('assets/layer_04_1920x1080.png'))),
  //           )),
  //       new Positioned(
  //           left: xIc1,
  //           bottom: 0,
  //           child: new Container(
  //             width: MediaQuery.of(context).size.width + 100,
  //             height: (MediaQuery.of(context).size.width + 100) / scale,
  //             decoration: new BoxDecoration(
  //                 image: new DecorationImage(
  //                     fit: BoxFit.cover,
  //                     image: new AssetImage('assets/layer_05_1920x1080.png'))),
  //           )),
  //     ],
  //   );
  // }
}


