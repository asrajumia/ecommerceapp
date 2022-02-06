import 'dart:async';

import 'package:ecommerceapp/const/mycolor.dart';
import 'package:ecommerceapp/ui/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Startwidget extends StatefulWidget {
  const Startwidget({ Key? key }) : super(key: key);

  @override
  _StartwidgetState createState() => _StartwidgetState();
}

class _StartwidgetState extends State<Startwidget> {
  void initState(){
    Timer(Duration(seconds: 3), ()=>Navigator.push(context, 
    MaterialPageRoute(builder: (_)=>Loginwidget())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.mycolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("E-Commerce",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 44.sp,
              color: Colors.white,
            ),),
            SizedBox(
              height: 28.h,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}