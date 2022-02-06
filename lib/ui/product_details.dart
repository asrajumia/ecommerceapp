import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecommerceapp/const/mycolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);

  // const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  var _dotPosition = 0;
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users_cart_items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["p_name"],
      "price": widget._product["p_price"],
      "image": widget._product["p_image"],
    }).then((value) => print("Add To Cart"));
  }
  Future addToFavorite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users_favorite_items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["p_name"],
      "price": widget._product["p_price"],
      "image": widget._product["p_image"],
    }).then((value) => print("Add To Favorite"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
            child: Text(
          "Product Details",
          style: TextStyle(color: Colors.black),
        )),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: appcolor.mycolor,
            size: 30,
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
            .collection("users_favorite_items")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("items")
            .where("name", isEqualTo: widget._product["p_name"])
            .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: appcolor.mycolor,
                  child: IconButton(
                    onPressed: ()=> snapshot.data.docs.length ==0
                    ? addToFavorite()
                    : Fluttertoast.showToast(msg: "Already Added"),
                    icon: snapshot.data.docs.length ==0
                    ? Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                    )
                    :Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                    ),
                ),
              );
            })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: CarouselSlider(
                items: widget._product["p_image"]
                    .map<Widget>((item) => Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: NetworkImage(item),
                              fit: BoxFit.fitWidth,
                            )),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    autoPlay: true,
                    viewportFraction: 0.8,
                    onPageChanged: (val, carouselPageChangedReason) {
                      setState(() {
                        _dotPosition = val;
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: DotsIndicator(
                dotsCount:
                    widget._product.length == 0 ? 1 : widget._product.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: appcolor.mycolor,
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(8, 8),
                  size: Size(6, 6),
                  color: appcolor.mycolor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Text(
                  "\৳ ${widget._product["p_price"].toString()}",
                  style: TextStyle(fontSize: 30.sp),
                ),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(onPressed: () => addToCart(), child: Text("Add To Cart"))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget._product["p_name"], style: TextStyle(fontSize: 20.sp)),
            SizedBox(
              height: 10,
            ),
            Text(widget._product["p_description"]),
          ],
        )),
      ),
    );
  }
}
