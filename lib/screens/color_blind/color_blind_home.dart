import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();
  File? _selectedImage;
  ui.Image? _image;
  Color _indicatorColor = Colors.grey;
  String _colorName = "";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _selectedImage = imageFile;
      });

      _loadImage(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _loadImage(File imageFile) async {
    final data = await imageFile.readAsBytes();
    final uiImage = await decodeImageFromList(data);
    setState(() {
      _image = uiImage;
    });
  }

  Future<void> _detectColor(Offset position) async {
    if (_image == null) return;

    int x = position.dx.round();
    int y = position.dy.round();

    final byteData = await _image!.toByteData(format: ui.ImageByteFormat.rawRgba);
    final buffer = byteData!.buffer.asUint8List();

    int index = (y * _image!.width + x) * 4;
    int r = buffer[index];
    int g = buffer[index + 1];
    int b = buffer[index + 2];
    int a = buffer[index + 3];

    Color detectedColor = Color.fromARGB(a, r, g, b);
    String colorName = _getColorName(detectedColor);

    setState(() {
      _indicatorColor = detectedColor;
      _colorName = colorName;
    });

    _speak(colorName);
  }

  String _getColorName(Color color) {
    // Define color ranges and their corresponding names
    final colorRanges = {
      'Black': {'minR': 0, 'maxR': 25, 'minG': 0, 'maxG': 25, 'minB': 0, 'maxB': 25},
      'White': {'minR': 230, 'maxR': 255, 'minG': 230, 'maxG': 255, 'minB': 230, 'maxB': 255},
      'Red': {'minR': 200, 'maxR': 255, 'minG': 0, 'maxG': 50, 'minB': 0, 'maxB': 50},
      'Green': {'minR': 0, 'maxR': 50, 'minG': 200, 'maxG': 255, 'minB': 0, 'maxB': 50},
      'Blue': {'minR': 0, 'maxR': 50, 'minG': 0, 'maxG': 50, 'minB': 200, 'maxB': 255},
      'Yellow': {'minR': 200, 'maxR': 255, 'minG': 200, 'maxG': 255, 'minB': 0, 'maxB': 50},
      'Orange': {'minR': 200, 'maxR': 255, 'minG': 100, 'maxG': 150, 'minB': 0, 'maxB': 50},
      'Purple': {'minR': 100, 'maxR': 150, 'minG': 0, 'maxG': 50, 'minB': 100, 'maxB': 150},
    };

    // Find the closest color range
    String closestColor = 'Unknown';
    double minDistance = double.infinity;
    colorRanges.forEach((name, range) {
      int minR = range['minR']!;
      int maxR = range['maxR']!;
      int minG = range['minG']!;
      int maxG = range['maxG']!;
      int minB = range['minB']!;
      int maxB = range['maxB']!;

      double distance = sqrt(pow(color.red - ((minR + maxR) / 2), 2) +
          pow(color.green - ((minG + maxG) / 2), 2) +
          pow(color.blue - ((minB + maxB) / 2), 2));

      if (distance < minDistance) {
        minDistance = distance;
        closestColor = name;
      }
    });

    return closestColor;
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          if (_selectedImage != null)
            Expanded(
              child: GestureDetector(
                onPanDown: (details) {
                  _detectColor(details.localPosition);
                },
                child: Image.file(_selectedImage!),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text('No image selected.'),
              ),
            ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(width: double.infinity,
                    height: 200,
                    child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
                      onPressed: () => _pickImage(ImageSource.camera),

                      child: Text('Camera',style:TextStyle(color: Colors.white,fontSize: 25) ,),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(width: double.infinity,
                    height: 200,
                    child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.indigo)),
                      onPressed: () =>
                        _pickImage(ImageSource.gallery),
    child: Text('Gallery',style: TextStyle(color: Colors.white,fontSize: 25),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _indicatorColor,
            ),
          ),
          Text(
            _colorName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
