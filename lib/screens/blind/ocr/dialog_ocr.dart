import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

// ignore: camel_case_types
class ocrDialog {
  final FlutterTts flutterTts = FlutterTts();
  Future<Future<Object?>> showOCRDialog(
      String text, XFile picture, BuildContext context) async {
    final pngByteData = await picture.readAsBytes();

    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Text Detected'),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      new Container(
                        color: Colors.white,
                        width: 300.0,
                        height: 150,
                        // ignore: deprecated_member_use
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.indigo[700])),
                          onPressed: _stopTts,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            color: Colors.indigo[700],
                            child: const Text('Stop',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      new Container(height: 10),
                      new Container(
                        width: 300.0,
                        height: 150,
                        // ignore: deprecated_member_use
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStatePropertyAll(Colors.indigo[700])),
                          onPressed: () {
                            _speakOCR(text);
                          },
                          child: Container(
                            color: Colors.indigo[700],
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Replay',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      new Container(height: 10),
                      new Container(
                        width: 300.0,
                        height: 150,
                        // ignore: deprecated_member_use
                        child: GestureDetector(
                          onTap: _pauseTts,
                          child: Container(
                            width: 150.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Pause',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Container(height: 10),
                      new Image.memory(pngByteData),
                      SizedBox(width: 20),
                      new Text("$text"),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {
          return CircularProgressIndicator();
        });
  }

  _stopTts() {
    if (Vibration.hasVibrator() == true) {
      Vibration.vibrate(amplitude: 100, duration: 200);
    }
    flutterTts.stop();
  }

  _pauseTts() {
    if (Vibration.hasVibrator() == true) {
      Vibration.vibrate(amplitude: 200, duration: 100);
    }
    flutterTts.pause();
  }

  _speakOCR(String text) {
    if (Vibration.hasVibrator() == true) {
      Vibration.vibrate(amplitude: 500, duration: 200);
    }
    flutterTts.speak(text);
  }

  Future<void> optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Icon(CupertinoIcons.camera_fill),
                          ),
                        ),
                        TextSpan(
                          text: 'Choose mode',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: () {
                      openCamera(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> openCamera(BuildContext context) async {
    final _picker = ImagePicker();

    XFile? picture = await _picker.pickImage(source: ImageSource.camera);
    var _extractText = await FlutterTesseractOcr.extractText(picture!.path);

    showOCRDialog(_extractText, picture, context);
    _speakOCR(_extractText);
  }

  Future<void> openGallery(BuildContext context) async {
    final _picker = ImagePicker();

    XFile? picture = await _picker.pickImage(source: ImageSource.gallery);
    var _extractText = await FlutterTesseractOcr.extractText(picture!.path);
    print(_extractText.substring(20));

    showOCRDialog(
        _extractText.substring(20, _extractText.length - 15), picture, context);
    _speakOCR(_extractText.substring(20, _extractText.length - 15));
  }
}
