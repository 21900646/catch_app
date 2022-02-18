import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:math' as math;
// import '../../login.dart';
import '../../speed.dart';
import 'bndbox.dart';
import 'home.dart';
import 'text_detector_painter.dart';
import 'package:tflite/tflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

TextEditingController emailController = TextEditingController(text: '');

List<String> ocrText = [];
//bool isBusy = false;
String realtime_parking = "";

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);
  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();

  //CameraController? _cameraController;

  late CustomPaint customPaint;
  late CameraController controller;
  bool isDetecting = false;
  bool isDetecting2 = false;
  bool isBusy = false;
  //late Isolate isolate;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );

      controller.initialize().then((_) async {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) async {



          final WriteBuffer allBytes = WriteBuffer();

          for (Plane plane in img.planes) {
            allBytes.putUint8List(plane.bytes);
          }
          final bytes = allBytes.done().buffer.asUint8List();

          final Size imageSize =
          Size(img.width.toDouble(), img.height.toDouble());

          final planeData = img.planes.map(
                (Plane plane) {
              return InputImagePlaneMetadata(
                bytesPerRow: plane.bytesPerRow,
                height: plane.height,
                width: plane.width,
              );
            },
          ).toList();

          final InputImageFormat inputImageFormat =
              InputImageFormatMethods.fromRawValue(img.format.raw) ??
                  InputImageFormat.NV21;

          InputImageRotation imageRotation = InputImageRotation.Rotation_0deg;

          final inputImageData = InputImageData(
            size: imageSize,
            imageRotation: imageRotation,
            planeData: planeData,
            inputImageFormat: inputImageFormat,
          );

          final inputImage = InputImage.fromBytes(
              bytes: bytes, inputImageData: inputImageData);


          processImage(inputImage); //어린이보호구역 탐색 함수 호출
          //어린이보호구역 끝

          // Isolate.spawn(change,20);
          if (!isDetecting) {
            isDetecting = true;
            int startTime = new DateTime.now().millisecondsSinceEpoch;

            Tflite.detectObjectOnFrame(

              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              model: widget.model,
              imageHeight: img.height,
              imageWidth: img.width,
              imageMean: 127.5,
              imageStd: 127.5,
              numResultsPerClass: 1,
              threshold: 0.4,
              rotation: 0,

            ).then((recognitions) {

              int endTime = new DateTime.now().millisecondsSinceEpoch;

              print("Detection took ${endTime - startTime}");

              widget.setRecognitions(recognitions!, img.height, img.width);
              isDetecting = false;
              person=false;
            });

          }
        });
      });
    }
  }

  update() async {
    print(">>>>주차 구역 발견");
    try {
      FirebaseFirestore.instance
          .collection("parking")
          .doc(emailController.text)
          .update(
          {
            "realtime_parking": realtime_parking,
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
      screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
      screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }

// goolgle mlkit text detection(어린이 보호 구역)
  Future<void> processImage(InputImage inputImage) async {
    print('text start time${DateTime.now()}');

    if (isBusy) return;
    isBusy = true;


    final textDetector = GoogleMlKit.vision.textDetector();

    final RecognisedText recognisedText = await textDetector.processImage(inputImage);
    List<String> recognizedList = [];

    for (TextBlock block in recognisedText.blocks) {
      setState(() {
        recognizedList.add(block.text);
      });
    }



    if(recognizedList.contains('SCHOOL ZONE')||recognizedList.contains('SCHOOL')){
      schoolzone=true;
    }else{
      schoolzone=false;
    }

    ocrText=recognizedList;

    // String pattern = r'^[A-Za-z0-9+]{2,3}$';
    // RegExp regex = new RegExp(pattern);
    // var regType1 = /^[A-Za-z0-9+]{2,12}$/;

    for (String location in recognizedList) {
      // if (location.contains('B2')) {
      // if(RegExp(r'^[A-Za-z0-9+]{2,3}$').hasMatch(location)){
      if (velocity.toInt() <= 30) if (RegExp(r'^[A-Za-z+]{1,1}[0-9+]{1,2}$')
          .hasMatch(location)) {
        print("Here is" + location);
        setState(() {
          realtime_parking = location;
        });
        Hive.box('picture').put('realtime_parking', location);
        //realtime_parking
        //parking_location.add(location);
        update();
      }
    }

    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}


class RecognizedText {
  String? block;
  List<TextLine>? lines;

  RecognizedText({required this.lines, this.block});
}

void change(var value){
  int  num = value;
  for(int i=0;i<100;i++){
    print("change : ${num}");
  }

}