import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilewidget extends StatefulWidget {
  const Profilewidget({ Key? key }) : super(key: key);

  @override
  _ProfilewidgetState createState() => _ProfilewidgetState();
}

class _ProfilewidgetState extends State<Profilewidget> {
  @override
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;
  SetDateToTextField(data) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            border: 
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15))),
          controller: _nameController =
          TextEditingController(text: data["name"]),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: 
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15))),
          controller: _phoneController =
          TextEditingController(text: data["phone"]),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: 
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15))),
          controller: _ageController =
          TextEditingController(text: data["age"]),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(onPressed: () => updateData(), child: Text("Update"))
      ],
    );
  }
  updateData() {
    CollectionReference _collectionRef = 
    FirebaseFirestore.instance.collection("Users_form_data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                .collection("users_form_data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SetDateToTextField(data);
                })
            ],
          ),
        ),
      )),
    );
  }
}