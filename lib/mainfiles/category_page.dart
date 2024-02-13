import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
        'Category_id': currentCount + 1,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          "Categories",
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  // InkWell(
                  //   // camera icon
                  //   onTap: () {
                  //     getImageFromGallery();
                  //   },
                  //   child: Container(
                  //     width: 210,
                  //     height: 150,
                  //     decoration: BoxDecoration(
                  //       color: whiteColor,
                  //       borderRadius: BorderRadius.circular(10),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.1),
                  //           blurRadius: 10,
                  //           spreadRadius: 1,
                  //         ),
                  //       ],
                  //     ),
                  //     // ignore: unnecessary_null_comparison
                  //     child: _image != null
                  //         ? Image.file(
                  //             _image!,
                  //             fit: BoxFit.cover,
                  //           )
                  //         : Icon(
                  //             Icons.camera_alt,
                  //             size: 100,
                  //             color: Colors.grey.shade400,
                  //           ),
                  //   ),
                  // ),
                  // text editing controller
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
                            color: const Color.fromARGB(255, 102, 100, 100)
                                .withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 3),
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
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 44,
                      width: 150,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Colors.blue,
                              Color.fromARGB(255, 2, 52, 93)
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          addCategoryToFirestore();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 13,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.04,
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
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 0,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.withOpacity(0.2),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'image',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "dfgdgfd",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
