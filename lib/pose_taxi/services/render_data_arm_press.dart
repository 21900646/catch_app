// import 'package:flutter/material.dart';
//
// class RenderDataArmPress extends StatefulWidget {
//   final List<dynamic> data;
//   final int previewH;
//   final int previewW;
//   final double screenH;
//   final double screenW;
//
//   RenderDataArmPress(
//       {required this.data, required this.previewH, required this.previewW, required this.screenH, required this.screenW});
//   @override
//   _RenderDataArmPressState createState() => _RenderDataArmPressState();
// }
//
// class _RenderDataArmPressState extends State<RenderDataArmPress> {
//   late Map<String, List<double>> inputArr;
//
//   String excercise = 'arm_press';
//   double upperRange = 300;
//   double lowerRange = 500;
//   late bool midCount, isCorrectPosture;
//   late int _counter;
//   late Color correctColor;
//   late double shoulderLY;
//   late double shoulderRY;
//
//   late double wristLX, wristLY, wristRX, wristRY, elbowLX, elbowRX; //손목과 팔꿈치 x,y 좌표
//   late double kneeRY; //오른쪽 무릎 y좌표
//   late double kneeLY; //왼쪽 무릎 y좌표
//   late bool squatUp;
//   String whatToDo = 'Finding Posture';
//
//   var leftEyePos = Vector(0, 0); // 왼쪽 눈(1)
//   var rightEyePos = Vector(0, 0); // 오른쪽 눈(2)
//   var leftShoulderPos = Vector(0, 0); //왼쪽 어깨(5)
//   var rightShoulderPos = Vector(0, 0); // 오른쪽 어깨(6)
//   var leftHipPos = Vector(0, 0); //왼쪽 골반(11)
//   var rightHipPos = Vector(0, 0); // 오른쪽 골반 부위(12)
//   var leftElbowPos = Vector(0, 0); //왼쪽 팔꿀치(7)
//   var rightElbowPos = Vector(0, 0); //오른쪽 팔꿈치(8)
//   var leftWristPos = Vector(0, 0); //왼쪽 손목(9)
//   var rightWristPos = Vector(0, 0); //오른쪽 손목(10)
//   var leftKneePos = Vector(0, 0); //왼쪽 무릎(13)
//   var rightKneePos = Vector(0, 0); //오른쪽 무릎(14)
//   var leftAnklePos = Vector(0, 0); //왼쪽 발목(15)
//   var rightAnklePos = Vector(0, 0); //오른쪽 발목(16)
//
//   @override
//   void initState() {
//     inputArr = new Map();
//     midCount = false;
//     isCorrectPosture = false;
//     _counter = 0;
//     correctColor = Colors.red;
//     shoulderLY = 0;
//     shoulderRY = 0;
//     kneeRY = 0;
//     kneeLY = 0;
//     squatUp = true;
//     super.initState();
//   }
//
//   bool _postureAccordingToExercise(Map<String, List<double>> poses) {
//     setState(() {
//       wristLX = poses['leftWrist']![0];
//       wristLY = poses['leftWrist']![1];
//       wristRX = poses['rightWrist']![0];
//       wristRY = poses['rightWrist']![1];
//       elbowLX = poses['leftElbow']![0];
//       elbowRX = poses['rightElbow']![0];
//
//       shoulderLY = poses['leftShoulder']![1];
//       shoulderRY = poses['rightShoulder']![1];
//       kneeLY = poses['leftKnee']![1];
//       kneeRY = poses['rightKnee']![1];
//     });
//     if (excercise == 'arm_press') {
//       if (squatUp) { //팔이 내려져 있을때 / 초기값은 true이므로 처음에 실행됨.
//
//         print("팔이 내려져 있을 때 $wristLX $wristLY // $wristRX");
//
//         return
//             wristLX > 280 &&
//             elbowLX > 280 &&
//             wristRX < 95 &&
//             elbowRX < 95 &&
//
//             wristLY < 240 && wristLY > 200 &&
//             wristRY < 240 && wristRY > 200;
//       } else { //팔이 올려져 있을때
//
//         print("팔이 올려져 있을 때 $wristLY $wristRY");
//
//         return wristLY < 125 && wristRY < 125;
//       }
//     }
//   }
//
//   _checkCorrectPosture(Map<String, List<double>> poses) {
//     if (_postureAccordingToExercise(poses)) {
//       if (!isCorrectPosture) {
//         setState(() {
//           //올바른 자세일경우,초록색으로 바꾸기
//           isCorrectPosture = true;
//           correctColor = Colors.green;
//         });
//       }
//     } else {
//       if (isCorrectPosture) {
//         setState(() {
//           isCorrectPosture = false;
//           correctColor = Colors.red;
//         });
//       }
//     }
//   }
//
//   Future<void> _countingLogic(Map<String, List<double>> poses) async {
//     if (poses != null) {
//       _checkCorrectPosture(poses); //정확한 자세인지 확인
//
//       //팔을 올려야할때
//       if (isCorrectPosture && squatUp && midCount == false) {
//         //in correct initial posture
//         setState(() {
//           whatToDo = 'Lift';
//           //correctColor = Colors.green;
//         });
//         squatUp = !squatUp;
//         isCorrectPosture = false;
//       }
//
//       //팔을 내려야할때
//       //lowered all the way
//       if (isCorrectPosture && !squatUp && midCount == false) {
//         midCount = true;
//         isCorrectPosture = false;
//         squatUp = !squatUp;
//
//         setState(() {
//           whatToDo = 'Drop';
//           //correctColor = Colors.green;
//         });
//       }
//
//       //한번 들어올렸다가 내리면 횟수 증가
//       //back up
//       if (midCount && isCorrectPosture) {
//         incrementCounter();
//         midCount = false;
//         squatUp = !squatUp;
//         setState(() {
//           whatToDo = 'Lift';
//         });
//       }
//     }
//   }
//
//   void incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     void _getKeyPoints(k, x, y) {
//       if (k["part"] == 'leftEye') {
//         leftEyePos.x = x - 230;
//         leftEyePos.y = y - 45;
//       }
//       if (k["part"] == 'rightEye') {
//         rightEyePos.x = x - 230;
//         rightEyePos.y = y - 45;
//       }
//       if (k["part"] == 'leftShoulder') {
//         leftShoulderPos.x = x - 230;
//         leftShoulderPos.y = y - 45;
//       }
//       if (k["part"] == 'rightShoulder') {
//         rightShoulderPos.x = x - 230;
//         rightShoulderPos.y = y - 45;
//       }
//       if (k["part"] == 'leftElbow') {
//         leftElbowPos.x = x - 230;
//         leftElbowPos.y = y - 45;
//       }
//       if (k["part"] == 'rightElbow') {
//         rightElbowPos.x = x - 230;
//         rightElbowPos.y = y - 45;
//       }
//       if (k["part"] == 'leftWrist') {
//         leftWristPos.x = x - 230;
//         leftWristPos.y = y - 45;
//       }
//       if (k["part"] == 'rightWrist') {
//         rightWristPos.x = x - 230;
//         rightWristPos.y = y - 45;
//       }
//       if (k["part"] == 'leftHip') {
//         leftHipPos.x = x - 230;
//         leftHipPos.y = y - 45;
//       }
//       if (k["part"] == 'rightHip') {
//         rightHipPos.x = x - 230;
//         rightHipPos.y = y - 45;
//       }
//       if (k["part"] == 'leftKnee') {
//         leftKneePos.x = x - 230;
//         leftKneePos.y = y - 45;
//       }
//       if (k["part"] == 'rightKnee') {
//         rightKneePos.x = x - 230;
//         rightKneePos.y = y - 45;
//       }
//       if (k["part"] == 'leftAnkle') {
//         leftAnklePos.x = x - 230;
//         leftAnklePos.y = y - 45;
//       }
//       if (k["part"] == 'rightAnkle') {
//         rightAnklePos.x = x - 230;
//         rightAnklePos.y = y - 45;
//       }
//     }
//
//     List<Widget> _renderKeypoints() {
//       var lists = <Widget>[];
//       widget.data.forEach((re) {
//         var list = re["keypoints"].values.map<Widget>((k) {
//           var _x = k["x"];
//           var _y = k["y"];
//           var scaleW, scaleH, x, y;
//
//           if (widget.screenH / widget.screenW >
//               widget.previewH / widget.previewW) {
//             scaleW = widget.screenH / widget.previewH * widget.previewW;
//             scaleH = widget.screenH;
//             var difW = (scaleW - widget.screenW) / scaleW;
//             x = (_x - difW / 2) * scaleW;
//             y = _y * scaleH;
//           } else {
//             scaleH = widget.screenW / widget.previewW * widget.previewH;
//             scaleW = widget.screenW;
//             var difH = (scaleH - widget.screenH) / scaleH;
//             x = _x * scaleW;
//             y = (_y - difH / 2) * scaleH;
//           }
//           inputArr[k['part']] = [x, y]; //좌표(리스트)를 특정 key(map)의 value에 저장
//           print(inputArr[k['part']]);
//
//           //Mirroring
//           if (x > 320) {
//             var temp = x - 320;
//             x = 320 - temp;
//           } else {
//             var temp = 320 - x;
//             x = 320 + temp;
//           }
//
//           _getKeyPoints(k, x, y);
//
//           if (k["part"] == 'leftEye') {
//             leftEyePos.x = x - 230;
//             leftEyePos.y = y - 45;
//           }
//           if (k["part"] == 'rightEye') {
//             rightEyePos.x = x - 230;
//             rightEyePos.y = y - 45;
//           }
//           /////
//           return Positioned(
//             left: x - 230,
//             top: y - 50,
//             width: 100,
//             height: 15,
//             child: Container(
//                 // child: Text(
//                 //   "● ${k["part"]}",
//                 //   style: TextStyle(
//                 //     color: Color.fromRGBO(37, 213, 253, 1.0),
//                 //     fontSize: 12.0,
//                 //   ),
//                 // ),
//                 ),
//           );
//         }).toList();
//
//         _countingLogic(inputArr);
//         inputArr.clear();
//
//         lists..addAll(list);
//       });
//       //lists.clear();
//
//       return lists;
//     }
//
//     return Stack(
//       children: <Widget>[
//         Stack(
//           children: [
//             CustomPaint(
//               painter:
//                   MyPainter(left: leftShoulderPos, right: rightShoulderPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: leftElbowPos, right: leftShoulderPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: leftWristPos, right: leftElbowPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: rightElbowPos, right: rightShoulderPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: rightWristPos, right: rightElbowPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: leftShoulderPos, right: leftHipPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: leftHipPos, right: leftKneePos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: leftKneePos, right: leftAnklePos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: rightShoulderPos, right: rightHipPos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: rightHipPos, right: rightKneePos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: rightKneePos, right: rightAnklePos),
//             ),
//             CustomPaint(
//               painter: MyPainter(left: leftHipPos, right: rightHipPos),
//             ),
//           ],
//         ),
//         Stack(children: _renderKeypoints()),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 50,
//             width: widget.screenW,
//             decoration: BoxDecoration(
//               color: correctColor,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(25.0),
//                   topRight: Radius.circular(25)),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   '$whatToDo\nArm Presses: ${_counter.toString()}',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//       ],
//     );
//   }
// }
//
// class Vector {
//   double x, y;
//   Vector(this.x, this.y);
// }
//
// class MyPainter extends CustomPainter {
//   Vector left;
//   Vector right;
//   MyPainter({required this.left, required this.right});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p1 = Offset(left.x, left.y);
//     final p2 = Offset(right.x, right.y);
//     final paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 4;
//     canvas.drawLine(p1, p2, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter old) {
//     return false;
//   }
// }
//
//
