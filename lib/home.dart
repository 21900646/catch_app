import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'hud.dart';


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
          //여기에 추가해서 진행하기
        ],
      ),
    );
  }
}