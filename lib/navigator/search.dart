import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/const/textfile.dart';
import 'package:flutter/material.dart';

class ScreenWidget extends StatefulWidget {
  const ScreenWidget({Key? key}) : super(key: key);

  @override
  _ScreenWidgetState createState() => _ScreenWidgetState();
}

class _ScreenWidgetState extends State<ScreenWidget> {
  CollectionReference firestoreDocs =
      FirebaseFirestore.instance.collection('product_image');
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.blue)),
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: searchController,
                decoration: textfileStyle('search').copyWith(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.blue,
                        ))),
              ),
              getSearch()
            ],
          ),
        ),
      )),
    );
  }

  Expanded getSearch() {
    return Expanded(
      child: StreamBuilder(
          stream: firestoreDocs.snapshots().asBroadcastStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            if (searchController.text.isEmpty) {
              return const Text(
                'NO seacrh found',
                style: TextStyle(fontSize: 16),
              );
            } else {
              return ListView(
                children: [
                  ...snapshot.data!.dose
                      .where((QueryDocumentSnapshot<Object> element) =>
                          element["p_name"].toString().toLowerCase().contains(
                                searchController.text.toLowerCase(),
                              ))
                      .map((QueryDocumentSnapshot<Object> data) {
                    final name = data["p_name"];
                    final img = data["P_image"][0];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 10,
                        ),
                        child: ListTile(
                          title: Text(
                            name,
                            style: TextStyle(fontSize: 20),
                          ),
                          leading: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(img),
                          ),
                        ),
                      ),
                    );
                  })
                ],
              );
            }
          }),
    );
  }
}
