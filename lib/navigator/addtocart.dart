

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/const/mycolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cartwidget extends StatefulWidget {
  const Cartwidget({ Key? key }) : super(key: key);

  @override
  _CartwidgetState createState() => _CartwidgetState();
}

class _CartwidgetState extends State<Cartwidget> {
  
  double totalprice = 0;
bool isload = true;
List<Model> list = [];
late AsyncSnapshot<QuerySnapshot> snapshot;
void initState() {
  super .initState();
  getDate();
}

Future<dynamic> getDate() async {
  final document = (await FirebaseFirestore.instance
  .collection("users_cart_items")
  .doc(FirebaseAuth.instance.currentUser!.email)
  .collection("items")
  .get());
  for (int i = 0; i< document.docs.length; i++) {
    Model model = Model(
      document.docs[i].data()['name'],
      document.docs[i].data()['price'],
      document.docs[i].data()['image'][0],
      document.docs[i].id);
      list.add(model);
  }
  setState(() {
    isload = false;
  });
}

double getTotalPrice() {
  totalprice = 0;
  list.forEach((element) {
    totalprice += element.price;
  });
  return totalprice;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back)),
          backgroundColor: appcolor.mycolor,
          title: Text("Product List"),
      ),
      body: SafeArea(
        child: isload
        ? Center(
          child: CircularProgressIndicator(),
        )
        : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_,index) {
                  return Card(
                    child: ListTile(
                      leading: Text(list[index].name,
                      style: TextStyle(fontSize: 20.sp),
                      ),
                      title: Text(" ${list[index].price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      ),
                      ),
                      trailing: GestureDetector(
                        child: CircleAvatar(
                          child: Icon(Icons.remove_circle),
                        ),
                        onTap: () {
                          FirebaseFirestore.instance
                          .collection("users_cart_items")
                          .doc(FirebaseAuth
                          .instance.currentUser!.email)
                          .collection("items")
                          .doc(list[index].id)
                          .delete();
                          list.remove(list[index]);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                }),
                  ),
                  Text(
                    "Total Price ${getTotalPrice()}" ,
                    style: 
                    TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  ],
        )
        ),
    );
  }
}
class Model {
  String name, image, id;
  int price;
  Model(this.name, this.price, this.image, this.id);
}










// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Addwidget extends StatefulWidget {
//   const Addwidget({ Key? key }) : super(key: key);

//   @override
//   _AddwidgetState createState() => _AddwidgetState();
// }

// class _AddwidgetState extends State<Addwidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//           .collection("user_cart_items")
//           .doc(FirebaseAuth.instance.currentUser!.email)
//           .collection("items")
//           .snapshots(),
//           builder: (BuildContext context,
//           AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (snapshot.hasError) {
//            return Center(
//              child: Text("Something Went Wrong"),
//            );
//          }
//          return ListView.builder(
//            itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
//            itemBuilder: (_, index){
//              DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
//              return ListTile(
//                leading: Text(_documentSnapshot["name"]),
//                title: Text("\৳ ${_documentSnapshot["price"]}",
//                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
//                ),
//                trailing: GestureDetector(
//                  child: CircleAvatar(
//                    child: Icon(Icons.remove_circle),
//                  ),
//                  onTap: (){
//                    FirebaseFirestore.instance
//           .collection("user_cart_items")
//           .doc(FirebaseAuth.instance.currentUser!.email)
//           .collection("items")
//           .doc(_documentSnapshot.id)
//           .delete();
//                  },
//                ),
//              );
//            });
//           })),
//     );
//   }
// }