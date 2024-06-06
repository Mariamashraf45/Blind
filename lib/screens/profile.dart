import 'package:divergent/main.dart';
import 'package:divergent/screens/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profile extends StatelessWidget {
   profile({
     this.phone,
     this.name,
     this.email,
     this.addrees,
});

  String? name;
  String? addrees;
  String? email;
  int? phone;




  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Info About User',
            style: TextStyle(fontSize: 30),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage1(),
                    ));
              },
              icon: Icon(CupertinoIcons.house_alt_fill))
        ],
      ),
      body: Center(
        child: Column(

          children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: CircleAvatar(radius: 100,
              child: Image.asset('assets/images/p1.jpeg'),
            ),
          ),
            Text('${name}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
            Text('${email}',style: TextStyle(fontSize: 20,color: Colors.grey),),
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SingleChildScrollView(scrollDirection:Axis.horizontal ,
              child: Row(
                children: [
                Text('Phone Number',style: TextStyle(color: Colors.blue[500],fontSize: 20,fontWeight: FontWeight.w700),),
                      SizedBox(width:30),
                       Text('${phone}',style: TextStyle(fontSize: 20,color: Colors.grey),)
              ],),
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(right: 50,bottom: 50,left: 50,top: 10),
              child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Address',style: TextStyle(color: Colors.blue[500],fontSize: 20,fontWeight: FontWeight.w700),),
                    SizedBox(width:30),
                    Text('${addrees}',style: TextStyle(fontSize: 20,color: Colors.grey),)
                  ],),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadiusDirectional.circular(50)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => regist(),));
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
            )
          ],),
  ),
    );
  }
}
