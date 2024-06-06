import 'dart:io';
import 'package:divergent/screens/blind/blind_search/bndbox_search.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shake/shake.dart';
import 'package:tflite/tflite.dart';
import 'package:telephony/telephony.dart';
import 'dart:math' as math;

import 'package:divergent/screens/blind/live_labelling/camera.dart';

class blind_search extends StatefulWidget {
  final List<CameraDescription> cameras_search ;
  final String searched;

  blind_search(this.cameras_search,this.searched);
  @override
  State<blind_search> createState() => _blind_searchState();
}

class _blind_searchState extends State<blind_search> {
  late List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "SSD MobileNet";
  // ignore: unused_field
  late File _capImage;
  // ignore: unused_field
  late File _currImage;
  final FlutterTts flutterTts = FlutterTts();
  final Telephony telephony = Telephony.instance;

  PageController _controller = PageController(
    initialPage: 0,
  );
  var sosCount = 0;
  var initTime;
  @override
  // ignore: missing_return
  void initState()  {
    super.initState();
     // smsPermission();
    loadModel();
    ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () {
      if (sosCount == 0) {
        initTime = DateTime.now();
        ++sosCount;
      } else {
        if (DateTime.now().difference(initTime).inSeconds < 4) {
          ++sosCount;
          if (sosCount == 6) {
            // sendSms();
            sosCount = 0;
          }
          print(sosCount);
        } else {
          sosCount = 0;
          print(sosCount);
        }
      }
    });

    detector.startListening();
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
    print("MODEL" + res!);
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
      body: PageView(
        //make the pages view by swapping
        controller: _controller,
        children: <Widget>[
          Container(
            child: Stack(
              children: [
                Camera(
                  widget.cameras_search,
                  _model,
                  setRecognitions,
                ),
                BndBoxSearch(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model,
                    widget.searched),
              ],
            ),
          ),
      ],

        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }

}
