// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'hud.dart';
//
// class Home extends StatefulWidget {
//   final CameraDescription camera;
//   const Home(CameraDescription camera);
//
//   @override
//   _HomeState createState() => _HomeState(camera: camera);
// }
//
// class _HomeState extends State<Home> {
//   final CameraDescription camera;
//   _HomeState(@required this.camera, {CameraDescription camera});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           IconButton(
//             icon: Icon(Icons.arrow_forward_ios),
//             onPressed: () {
//               Get.to(Hud(camera: camera));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
