import 'package:ecommerceapp/navigator/addtocart.dart';
import 'package:ecommerceapp/navigator/favorite.dart';
import 'package:ecommerceapp/navigator/homepage.dart';
import 'package:ecommerceapp/navigator/profile.dart';
import 'package:flutter/material.dart';

class Homewidget extends StatefulWidget {
  const Homewidget({ Key? key }) : super(key: key);

  @override
  _HomewidgetState createState() => _HomewidgetState();
}

class _HomewidgetState extends State<Homewidget> {
  @override
  var indexpage = 0;
  final Page = [
    Homepage(),
    Favoritewidget(),
    Cartwidget(),
    Profilewidget(),
  ];
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("E-Commerce")),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),label: "Favorite"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),label: "Cart"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),label: "Profile"),
          ],
          onTap: (index){
            setState(() {
              indexpage = index;
            });
          },
          ),
          body: Page[indexpage],
      ),
    );
  }
}