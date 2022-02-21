import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'hud.dart';
import 'main.dart';
import 'main_screen.dart';

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

  //
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

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(cameras)),
              );
            },
            child: Text('포즈넷 테스트'),
          ),

          //여기에 추가해서 진행하기
        ],
      ),
    );
  }
}