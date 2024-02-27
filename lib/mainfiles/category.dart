// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List items = [];
  // File? _image;
  // Uint8List webImage = Uint8List(8);
  TextEditingController categoryNameController = TextEditingController();

  // ignore: unused_field
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
  late List<DocumentSnapshot> _document;

  // Future getImageFromGallery() async {
  //   final picker = ImagePicker();

  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       if (kDebugMode) {
  //         print('No image selected.');
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    _document = [];
    _streamController = StreamController<List<DocumentSnapshot>>();
    getData();
    super.initState();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('raw_category').get();

      _document = querySnapshot.docs;
      _streamController.add(_document);
    } catch (e) {
      print('error i fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  void addCategoryToFirestore() async {
    try {
      // Get the current count from Firestore
      var snapshot =
          await FirebaseFirestore.instance.collection('raw_category').get();
      int currentCount =
          snapshot.size; // Get the number of documents as the current count

      // Add the new category with incremented count
      await FirebaseFirestore.instance.collection('raw_category').add({
        'category': categoryNameController.text,
        'category_id': currentCount + 1,
      }).whenComplete(() {
        setState(() {
          categoryNameController.clear();
        });
      });

      categoryNameController.clear();
      if (kDebugMode) {
        print("Data added successfully!");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to add data: $error");
      }
    }
  }

  // bool TextListVisible = true;
  // void toggleList() {
  //   setState(() {
  //     TextListVisible = !TextListVisible;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 71, 123),
          title: const Text(
            "Category List",
            style: TextStyle(color: Colors.white),
          ),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white, // Change the color here
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 45,
                            width: 210,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 102, 100, 100)
                                          .withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: TextField(
                                  controller: categoryNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 5.0,
                                      ),
                                    ),
                                    hintText: 'Enter Category Name',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // save button
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            height: 44,
                            width: 170,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Color.fromARGB(255, 2, 52, 93)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                addCategoryToFirestore();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    'Add Category Name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.49,
                      width: displayWidth(context),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: StreamBuilder<List<DocumentSnapshot>>(
                          stream: _streamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                children: snapshot.data!
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  int categoryId = data['category_id'];
                                  String category = data['category'];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 8, right: 8),
                                    child: Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MaterialButton(
                                              color: Color.fromARGB(
                                                  255, 153, 195, 253),
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              minWidth: 0,
                                              height: 0,
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        leading: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: CircleAvatar(
                                            // Wrap with CircleAvatar
                                            backgroundColor: Color.fromARGB(
                                                255,
                                                201,
                                                201,
                                                201), // Example background color
                                            child: Text(
                                              "$categoryId",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors
                                                      .white), // Example text style
                                            ),
                                          ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 5, left: 10),
                                              child: Text(
                                                category,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
