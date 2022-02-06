import 'package:ecommerceapp/const/mycolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CustomButton(String bottomText, onPressed) {
  return SizedBox(
    width: 1.sw,
    height: 56.w,
    child: ElevatedButton(
      onPressed: onPressed,
     child: Text(
       bottomText,
       style: TextStyle(color: Colors.white, fontSize: 18.sp),
     ),
     style: ElevatedButton.styleFrom(primary: appcolor.mycolor, elevation: 3),
     ),
  );
}