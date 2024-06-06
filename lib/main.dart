import 'dart:io';

import 'package:divergent/screens/blind/blind_home.dart';
import 'package:divergent/screens/blind/blind_search/blind_search_home.dart';
import 'package:divergent/screens/blind/blind_search/speach_text.dart';
import 'package:divergent/screens/color_blind/color_blind_home.dart';
import 'package:divergent/screens/deaf/screens/landing_screen.dart';
import 'package:divergent/screens/profile.dart';
import 'package:divergent/screens/registration.dart';
import 'package:divergent/sos_activate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shake/shake.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

final Telephony telephony = Telephony.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    cameras = await availableCameras();
    camerasSearch = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      durationInSeconds: 6,
      navigator: MyHomePage1(),
      backgroundImage: AssetImage('assets/images/splash.png'),
      loaderColor: Colors.grey,
      logo: Image.asset(
        'assets/images/134543.png',
      ),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  MyHomePage1({key}) : super(key: key);

  @override
  _MyHomePageState1 createState() => _MyHomePageState1();
}

class _MyHomePageState1 extends State<MyHomePage1> {
  var sosCount = 0;
  var initTime;
  final FlutterTts flutterTts = FlutterTts();
  @override
  // ignore: missing_return
  void initState() {
    super.initState();
    smsPermission();
    _getPrediction(context);
   // loadModel();
    ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SOSActivate()),
      );
    });
    detector.startListening();
  }

  Future<void> _getPrediction(
      BuildContext context) async {
      final model = await FirebaseModelDownloader.instance.getModel(
         "ssd_mobilenet",
        FirebaseModelDownloadType.localModelUpdateInBackground,
        FirebaseModelDownloadConditions(
          iosAllowsCellularAccess: true,
          iosAllowsBackgroundDownloading: false,
          androidChargingRequired: false,
          androidWifiRequired: false,
          androidDeviceIdleRequired: false,
        ),
      );
      final labelsPath = await _saveLabelsToFile();
      Tflite.close();
      await Tflite.loadModel(
        model: model.file.path,
        labels: labelsPath,
        isAsset:
        false, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
        false, // defaults to false, set to true to use GPU delegate
      );
  }


  Future<String> _saveLabelsToFile() async {
    // Load the contents of labels.txt from assets
    String labelsContent = await rootBundle.loadString('assets/ssd_mobilenet.txt');

    // Get the application documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Create the file path
    String filePath = '${documentsDirectory.path}/labels.txt';

    // Write the contents to the file
    File labelsFile = File(filePath);
    await labelsFile.writeAsString(labelsContent);

    return filePath;
  }
  void sendSms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String n1 = prefs.getString('n1')!;
    String n2 = prefs.getString('n2')!;
    String n3 = prefs.getString('n3')!;
    String name = prefs.getString('name')!;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    String lat = (position.latitude).toString();
    String long = (position.longitude).toString();
    String alt = (position.altitude).toString();
    String speed = (position.speed).toString();
    String timestamp = (position.timestamp).toIso8601String();
    print(n2);
    LocationPermission permission = await Geolocator.requestPermission();
    telephony.sendSms(
        to: n1,
        message:
            "$name needs you help, last seen at: Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp");
    telephony.sendSms(
        to: n2,
        message:
            "$name needs you help, last seen at:  Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp");
    telephony.sendSms(
        to: n3,
        message:
            "$name needs you help, last seen at:  Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp");
  }

  void smsPermission() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
  }

  FirebaseCustomModel? model;




/*
  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
    print("MODEL" + res!);
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'Welcom',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => profile(
                        phone: 01212803051,
                        email: 'mariamsadek54@gmail.com',
                        name: 'Mariam Ashraf',
                        addrees: 'Alex,El Amria'),
                  )),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'Choose Your Mood',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20),
              child: Text(
                'choose the rigth for you',
                style: TextStyle(fontSize: 25, color: Colors.grey),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  flutterTts.speak("Blind Mood");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlindHome()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blind',
                              style: TextStyle(
                                  color: Colors.yellow[100],
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'We are intersted to help you',
                              style: TextStyle(
                                  color: Colors.yellow[100], fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.indigo[700],
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(50))),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  flutterTts.speak("Search Mood");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => blind_searchHome(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search',
                              style: TextStyle(
                                  color: Colors.indigo[700],
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'We are intersted to help you',
                              style: TextStyle(
                                  color: Colors.indigo[700], fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(50))),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  flutterTts.speak("Colour Blind Mood");

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorBlindHome()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Color Blind',
                              style: TextStyle(
                                  color: Colors.yellow[100],
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'We are intersted to help you',
                              style: TextStyle(
                                  color: Colors.yellow[100], fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.indigo[700],
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(50))),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
