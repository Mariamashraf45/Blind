import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';

class test extends StatefulWidget {
  @override
  testState createState() => testState();
}

class testState extends State<test> {
  final FlutterTts flutterTts = FlutterTts();
  File? _image;
  bool _loading = false;
  List<dynamic>? _output;
  final _picker = ImagePicker();

  pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      // setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File? image) async {
    var output = await Tflite.runModelOnImage(
      path: image!.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant_cash.tflite',
      labels: 'assets/labels_cash.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Identifier'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 160.0),
                _image == null
                    ? Text('No image selected')
                    : Container(
                        child: Image.file(_image!),
                        height: 250.0, // Fixed height for image
                      ),
                SizedBox(height: 20.0),
                _output != null ? Text('${_output![0]['label']}') : Container(),
                SizedBox(height: 50.0),
                Container(height: 200,
                  width: double.infinity,
                  child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
                    onPressed: (){
                      flutterTts.speak("Take Picture");
                      pickImage();
                    },
                    child: Text('Take Picture',style: TextStyle(color: Colors.white,fontSize: 25),),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
                    onPressed: (){
                      flutterTts.speak("Camera Roll");
                      pickGalleryImage();
                    },
                    child: Text('Camera Roll',style: TextStyle(fontSize: 25,color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
