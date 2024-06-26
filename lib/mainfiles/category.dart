// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<DocumentSnapshot> _document = [];
  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('raw_categery').get();
      _document = querySnapshot.docs;
      _streamController.add(_document);
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetching data: $e');
      }
    }
  }

  void addCategoryToFirestore() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('raw_categery').get();
      int currentCount = snapshot.size;
      String nextCategoryId = (currentCount + 1).toString();

      await FirebaseFirestore.instance
          .collection('raw_categery')
          .doc(nextCategoryId)
          .set({
        'categery_name': categoryNameController.text,
        'categery_id': nextCategoryId,
      }).then((value) async {
        categoryNameController.clear();
        getData();
        if (kDebugMode) {
          print("Data added successfully!");
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Failed to add data: $error");
      }
    }
  }

  void removeCategoryFromFirestore(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('raw_categery')
          .doc(categoryId)
          .delete()
          .then((_) {
        if (kDebugMode) {
          print("Category successfully removed from Firestore!");
        }
        getData();
      });
    } catch (error) {
      if (kDebugMode) {
        print("Failed to remove category: $error");
      }
    }
  }

  @override
  void dispose() {
    _streamController.close();
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Category",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: SizedBox(
                          height: 60,
                          width: 250,
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
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 180,
                    width: displayWidth(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
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
                                String categoryId =
                                    data['categery_id'].toString();
                                String category = data['categery_name'];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  child: Card(
                                    elevation:
                                        5, // Adjust the elevation to control the intensity of the shadow
                                    shadowColor: Colors.redAccent,
                                    child: ListTile(
                                      leading: Text(
                                        "0$categoryId.",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors
                                                .black), // Example text style
                                      ),
                                      title: Text(category),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MaterialButton(
                                            color: const Color.fromARGB(
                                                255, 76, 161, 241),
                                            padding: const EdgeInsets.all(6.0),
                                            minWidth: 0,
                                            height: 0,
                                            onPressed: () =>
                                                removeCategoryFromFirestore(
                                                    categoryId),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Colors.white,
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
                ),
              ],
            ),
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              child: Align(
                child: Card(
                  color: Colors.blueGrey,
                  child: MaterialButton(
                    minWidth: 160,
                    padding: const EdgeInsets.all(10),
                    onPressed: () {
                      addCategoryToFirestore();
                    },
                    child: Text(
                      'Add New Category',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
