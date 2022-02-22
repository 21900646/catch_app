import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'home.dart';

Future<void> main() async {
  // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //firebase 초기화
  await Permission.camera.request();
  await Permission.bluetooth.request();
  await Permission.microphone.request();
  await Permission.location.request();
  final cameras = await availableCameras();

  // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: home(
        // 적절한 카메라를 TakePictureScreen 위젯에게 전달합니다.
        camera: firstCamera,
      ),
    ),
  );
}

class home extends StatefulWidget {
  final CameraDescription camera;

  home({
    required this.camera,
  });

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  late CameraController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePictureScreen(camera: widget.camera)),
              );
            },
            child: Text('hud'),
          ),
          //여기에 추가해서 진행하기
        ],
      ),
    );
  }
}


// 사용자가 주어진 카메라를 사용하여 사진을 찍을 수 있는 화면
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  TakePictureScreen({
    required this.camera,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}


class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.camera == null) {
      print('No camera is found');
    } else {
      // 카메라의 현재 출력물을 보여주기 위해 CameraController를 생성합니다.
      _controller = CameraController(
        // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
        widget.camera,

        // 적용할 해상도를 지정합니다.
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();

      caller();
    }
  }

  @override
  void dispose() {
    // 위젯의 생명주기 종료시 컨트롤러 역시 해제시켜줍니다.
    _controller.dispose();
    super.dispose();
  }

  Future<void> caller() async {
    try {
      // 카메라 초기화가 완료됐는지 확인합니다.
      await _initializeControllerFuture;

      // _controller.startImageStream(
      //    (CameraImage image) async {
      //       print("here!!!!");
      //    }
      // );

      // path 패키지를 사용하여 이미지가 저장될 경로를 지정합니다.
      final path = join(
        // 본 예제에서는 임시 디렉토리에 이미지를 저장합니다. `path_provider`
        // 플러그인을 사용하여 임시 디렉토리를 찾으세요.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      //

      XFile picture = await _controller.takePicture();
      picture.saveTo(path);
      print(path);

      // // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
      // await _controller.takePicture(path);

      //사진을 촬영하면, 새로운 화면으로 넘어갑니다.
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DisplayPictureScreen(imagePath: path),
      //     ),
      //   );
      // }
    }catch (e) {
      // 만약 에러가 발생하면, 콘솔에 에러 로그를 남깁니다.
      print("error is here!");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('hud')),
      // 카메라 프리뷰를 보여주기 전에 컨트롤러 초기화를 기다려야 합니다. 컨트롤러 초기화가
      // 완료될 때까지 FutureBuilder를 사용하여 로딩 스피너를 보여주세요.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future가 완료되면, 프리뷰를 보여줍니다.
            return CameraPreview(_controller);
          } else {
            // 그렇지 않다면, 진행 표시기를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// 사용자가 촬영한 사진을 보여주는 위젯
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // 이미지는 디바이스에 파일로 저장됩니다. 이미지를 보여주기 위해 주어진
      // 경로로 `Image.file`을 생성하세요.
      body: Image.file(File(imagePath)),
    );
  }
}
