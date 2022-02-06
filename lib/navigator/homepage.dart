import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/const/mycolor.dart';
import 'package:ecommerceapp/navigator/search.dart';
import 'package:ecommerceapp/ui/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  List<String> image = [];
  var _dotposition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;
  fetchimage() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("sliding_image").get();
    setState(() {
      for (var i = 0; i < qn.docs.length; i++) {
        image.add(qn.docs[i]["imgpath"]);
      }
    });
    return qn.docs;
  }

  fatchproducts() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("product_image").get();
    setState(() {
      for (var i = 0; i < qn.docs.length; i++) {
        _products.add({
          "p_name": qn.docs[i]["p_name"],
          "p_description": qn.docs[i]["p_description"],
          "p_price": qn.docs[i]["p_price"],
          "p_image": qn.docs[i]["p_image"],
        });
      }
    });
    return qn.docs;
  }

  void initState() {
    fetchimage();
    fatchproducts();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          hintText: "Search Here",
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                          )
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                             MaterialPageRoute(builder: (context) => ScreenWidget()));
                          },
                    ),
                  ),
                ),
                Container(
                  color: appcolor.mycolor,
                  height: 50.h,
                  width: 50.w,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 3.5,
            child: CarouselSlider(
              items: image
                  .map((item) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fitWidth)),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (val, carouselPageChangedReason) {
                    setState(() {
                      _dotposition = val;
                    });
                  }),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          DotsIndicator(
            dotsCount: image.length == 0 ? 1 : image.length,
            position: _dotposition.toDouble(),
            decorator: DotsDecorator(
              activeColor: appcolor.mycolor,
              spacing: EdgeInsets.all(2),
              activeSize: Size(8, 8),
              size: Size(6, 6),
              color: appcolor.mycolor.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetails(_products[index]))),
                    child: Card(
                      elevation: 3,
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 2,
                            child:
                                Image.network(_products[index]["p_image"][0]),
                          ),
                          Text("${_products[index]["p_name"]}"),
                          Text("\৳ ${_products[index]["p_price"].toString()}"),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      )),
    );
  }
}
