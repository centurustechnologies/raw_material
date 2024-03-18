// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/NewApp/card.dart';
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

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryPage()),
          );
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 245, 157, 157),
                Color.fromARGB(255, 255, 90, 78),
                Color.fromARGB(255, 245, 157, 157),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                        child: SizedBox(
                          height: 60,
                          width: 280,
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: categoryNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: InkWell(
                                child: const Icon(Icons.close),
                                onTap: () {
                                  categoryNameController.clear();
                                },
                              ),
                              hintText: 'Search...',
                              contentPadding: const EdgeInsets.all(0),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // save button
                      Container(
                        height: 44,
                        width: 170,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 159, 159),
                                Color.fromARGB(255, 253, 94, 83)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Add Category',
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
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.49,
                  width: displayWidth(context),
                  child: StreamBuilder<List<DocumentSnapshot>>(
                      stream: _streamController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children:
                                snapshot.data!.map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              int categoryId = data['category_id'];
                              String category = data['category'];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 190, 190, 190),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MaterialButton(
                                          color: Colors.red,
                                          padding: const EdgeInsets.all(6.0),
                                          minWidth: 0,
                                          height: 0,
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        // Wrap with CircleAvatar
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          "$categoryId",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors
                                                  .black), // Example text style
                                        ),
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, left: 10),
                                          child: Text(
                                            category,
                                            style:
                                                const TextStyle(fontSize: 20),
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
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
