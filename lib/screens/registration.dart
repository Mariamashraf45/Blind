
import 'package:divergent/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class regist extends StatelessWidget {
TextEditingController  _controller1 = TextEditingController();
 TextEditingController _controller2 = TextEditingController();
TextEditingController _controller3 = TextEditingController();
TextEditingController _controller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'Update Info',
          style: TextStyle(fontSize: 25),
        )),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                'assets/images/1.jpg',
                scale: 7,
              )),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadiusDirectional.circular(30)),
                child: TextFormField(
                    controller: _controller1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: '  Enter Your Name',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadiusDirectional.circular(30)),
                child: TextFormField(
                    controller: _controller2,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: '  Enter Your E-mail',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadiusDirectional.circular(30)),
                child: TextFormField(
                    controller: _controller3,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: '  Enter Your Address',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadiusDirectional.circular(30)),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _controller4,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: '  Enter Your Phone Number',
                        labelStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '  Add Image',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadiusDirectional.circular(50)),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Select',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadiusDirectional.circular(50)),
                  child: TextButton(
                      onPressed: () {

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                            profile(phone: int.parse(_controller4.text), name: _controller1.text, email: _controller2.text, addrees: _controller3.text),));
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
