import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';
// import 'package:turning/audio/classifier.dart';
import 'package:catch_app/theme/app_colors.dart';
import 'dart:math' as math;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../home.dart';
import '../../main.dart';
import '../../speed.dart';
import 'package:catch_app/detectObject/bndbox.dart';
import 'package:catch_app/detectObject/camera.dart';

List func = [true, true, true, true, false, true, true, true];

bool person = false;
bool schoolzone = false;

const int sampleRate = 16000;

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String predOne = '';
  double confidence = 0;
  String _model = "Tiny YOLOv2";

  RecorderStream _recorder = RecorderStream();

  bool inputState = true;

  List<int> _micChunks = [];
  bool _isRecording = false;
  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;

  late StreamController<List<Category>> streamController;
  late Timer _timer;

  // late Classifier _classifier;

  List<Category> preds = [];

  Category? prediction;

  @override
  void initState() {
    super.initState();
    loadModel();
    streamController = StreamController();
    initPlugin();
    // _classifier = Classifier();
    // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   streamController.add(_classifier.predict(_micChunks));
    // });
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _audioStream.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _audioStream = _recorder.audioStream.listen((data) {
      if (_micChunks.length > 2 * sampleRate) {
        _micChunks.clear();
      }
      _micChunks.addAll(data);
    });

    streamController.stream.listen((event) {
      setState(() {
        preds = event;
      });
    });

    await Future.wait([_recorder.initialize(), _recorder.start()]);
  }

  loadModel() async {
    String? res;
    String? res2;
    print('load model');
    res = await Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite", labels: "assets/yolov2_tiny.txt");
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        SizedBox(height:160.h),
                        Transform.rotate(
                          angle: 90 * math.pi / 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.speed,
                                color:Colors.white,
                              ),
                              Text(
                                ' ' +DateTime.now().hour.toString()+':'+DateTime.now().minute.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.w,
                                ),
                              ),
                              // SizedBox(width:100.w),
                            ],
                          ),
                        ),
                        SizedBox(height:1400.h),
                        //     SizedBox(width:200.w),
                        Transform.rotate(
                          angle: 90 * math.pi / 180,
                          child: Speed(),

                        ),
                      ]
                  ),
                ],
              )
          ),

          Positioned(
            bottom: 448.h,
            left: 635.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black.withOpacity(0.4),
              ),
              width: 193.w,
              height: 891.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 54.h,
                  ),
                  if(func[0]==true)
                  SizedBox(
                    height: 124.h,
                    width: 124.h,
                    child: Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: ElevatedButton(
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  return schoolzone
                                      ? Colors.red
                                      : Colors.white.withOpacity(0.0);
                                }),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: AppColors.onPrimary,
                                    width: 3.w,
                                  ),
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.h),
                                        side: BorderSide(
                                            color: AppColors.onPrimary)))),
                        onPressed: () {
                          setState(() {});
                        },
                        child: Image.asset('assets/icons/스쿨존.png',
                            color:
                                true ? Colors.white : AppColors.primary[800]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42.h,
                  ),
                  if(func[1]==true)
                    SizedBox(
                      height: 124.h,
                      width: 124.h,
                      child: Transform.rotate(
                        angle: 90 * math.pi / 180,
                        child: Row(
                          children: [
                            if(func[1] == true)
                              SizedBox(
                                height: 124.h,
                                width: 124.h,
                                child: Container(
                                  width: 200.w,
                                  height: 300.h,
                                  child: Column(
                                    children: [
                                      preds.elementAt(0).label == "Police car (siren)" ||
                                          preds.elementAt(0).label == "Ambulance (siren)" ||
                                          preds.elementAt(0).label == "Emergency vehicle" ||
                                          preds.elementAt(0).label == "Fire engine, fire truck (siren)" ||
                                          preds.elementAt(1).label == "Police car (siren)" ||
                                          preds.elementAt(1).label == "Ambulance (siren)" ||
                                          preds.elementAt(1).label == "Emergency vehicle" ||
                                          preds.elementAt(1).label == "Fire engine, fire truck (siren)" ||
                                          preds.elementAt(2).label == "Police car (siren)" ||
                                          preds.elementAt(2).label == "Ambulance (siren)" ||
                                          preds.elementAt(2).label == "Emergency vehicle" ||
                                          preds.elementAt(2).label == "Fire engine, fire truck (siren)"
                                          ?Image.asset('assets/icons/구급차_경고.png') :  Image.asset('assets/icons/구급차_아이콘.png')
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 42.h),
                  if(func[2]==true)
                  SizedBox(
                    height: 124.h,
                    width: 124.h,
                    child: Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: ElevatedButton(
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  return person
                                      ? Colors.red
                                      : Colors.white.withOpacity(0.0);
                                }),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: AppColors.onPrimary,
                                    width: 3.w,
                                  ),
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.h),
                                        side: BorderSide(
                                            color: AppColors.onPrimary)))),
                        onPressed: () {
                          setState(() {});
                        },
                        child: Image.asset('assets/icons/장애물2.png',
                            color:
                                true ? Colors.white : AppColors.primary[800]),
                      ),
                    ),
                  ),
                  SizedBox(height: 42.h),
                  // SizedBox(
                  //   height: 124.h,
                  //   width: 124.h,
                  //   child: Transform.rotate(
                  //     angle: 90 * math.pi / 180,
                  //     child: ElevatedButton(
                  //       style: Theme.of(context)
                  //           .elevatedButtonTheme
                  //           .style!
                  //           .copyWith(
                  //               backgroundColor:
                  //                   MaterialStateProperty.resolveWith((states) {
                  //                 return false
                  //                     ? Colors.red
                  //                     : Colors.white.withOpacity(0.0);
                  //               }),
                  //               side: MaterialStateProperty.all(
                  //                 BorderSide(
                  //                   color: AppColors.onPrimary,
                  //                   width: 3.w,
                  //                 ),
                  //               ),
                  //               shape: MaterialStateProperty.all<
                  //                       RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(30.h),
                  //                       side: BorderSide(
                  //                           color: AppColors.onPrimary)))),
                  //       onPressed: () {
                  //         setState(() {});
                  //       },
                  //       child: Image.asset('assets/icons/졸음.png',
                  //           color:
                  //               true ? Colors.white : AppColors.primary[800]),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 42.h),
                  // if(func[5]==true)
                  // SizedBox(
                  //   height: 124.h,
                  //   width: 124.h,
                  //   child: Transform.rotate(
                  //     angle: 90 * math.pi / 180,
                  //     child: ElevatedButton(
                  //       style: Theme.of(context)
                  //           .elevatedButtonTheme
                  //           .style!
                  //           .copyWith(
                  //               backgroundColor:
                  //                   MaterialStateProperty.resolveWith((states) {
                  //                 return false
                  //                     ? Colors.red
                  //                     : Colors.white.withOpacity(0.0);
                  //               }),
                  //               side: MaterialStateProperty.all(
                  //                 BorderSide(
                  //                   color: AppColors.onPrimary,
                  //                   width: 3.w,
                  //                 ),
                  //               ),
                  //               shape: MaterialStateProperty.all<
                  //                       RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(30.h),
                  //                       side: BorderSide(
                  //                           color: AppColors.onPrimary)))),
                  //       onPressed: () {
                  //         setState(() {});
                  //       },
                  //       child: Image.asset('assets/icons/휴대폰.png',
                  //           color:
                  //               true ? Colors.white : AppColors.primary[800]),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          Positioned(
              bottom:55.h,
              right:55.w,

              child: IconButton(
                iconSize: 50.w,
                icon: Icon(Icons.close,

                ),
                onPressed: (){
                  // Get.offAll(() => home(cameras));
                },

              )
          ),
          if(func[2]==true)
          Transform.rotate(
              angle: 90 * math.pi / 180,
              child:BndBox(
          _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
          )
        ],
      ),
    );
  }
}
