import 'package:flutter/material.dart';

class speech extends StatefulWidget {
  String text;
  
speech(this.text);
  @override
  State<speech> createState() => _speechState();
}

class _speechState extends State<speech> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Text(widget.text,style: TextStyle(fontSize: 30),),),
    );
  }
}
