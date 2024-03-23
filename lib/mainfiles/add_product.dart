// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/mainfiles/homepage.dart';

// ignore: camel_case_types
class product_list extends StatefulWidget {
  const product_list({super.key});

  @override
  State<product_list> createState() => _product_listState();
}

// ignore: camel_case_types
class _product_listState extends State<product_list> {
  // ignore: non_constant_identifier_names
  List category_List = [];
  String categorytype = "";
  String categoryname = "";
  String? selectedCategory;

  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  // ignore: unused_field
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
  late List<DocumentSnapshot> _document;

  File? _Image;
  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _Image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadDataToStorage(pickedFile) async {
    if (pickedFile == null) {
      print('No image selected.');
      return;
    }
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('product_Image');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);

    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      String imageUrl = await referenceImageToUpload.getDownloadURL();
      FirebaseFirestore.instance.collection('raw_billing_product').doc().set({
        'category': selectedCategory,
        'product_name': productController.text,
        'product_price': priceController.text,
        'product_image': imageUrl,
        'product_quantity': '2',
      }).then((value) {
        print("data added sucessfully");
      }).catchError((error) {
        print("failed to add data: $error");
      }).whenComplete(() {
        setState(() {
          productController.clear();
          priceController.clear();
          unitController.clear();
          _Image = null;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const product_list()),
          );
        });
      });
      // ignore: avoid_print
    } catch (error) {
      // ignore: avoid_print
      print("Error occurred while uploading image and Data: $error");
    }
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();

      _document = querySnapshot.docs;
      _streamController.add(_document);
    } catch (e) {
      print('error i fetching data: $e');
    }
  }

  @override
  void initState() {
    _document = [];
    _streamController = StreamController<List<DocumentSnapshot>>();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  Future<void> addProductToFirestore() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Container(
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     Color.fromARGB(255, 255, 90, 78),
            //     Color.fromARGB(255, 245, 157, 157),
            //     Color.fromARGB(255, 253, 77, 64),
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            color: Colors.redAccent),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 150,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
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
                            padding: EdgeInsets.only(left: 25),
                            child: Text(
                              "Product List",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
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
                    child: StreamBuilder(
                      stream: _streamController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children:
                                snapshot.data!.map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              String category = data['category'];
                              String productName = data['product_name'];
                              String productPrice = data['product_price'];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 8, right: 8),
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.redAccent,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data['product_image']),
                                    ),
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          productName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          category,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(productPrice),
                                      ],
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        // Handle selected value
                                      },
                                      itemBuilder: (context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: ListTile(
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Edit'),
                                            onTap: () {},
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'remove',
                                          child: ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text('Remove'),
                                            onTap: () {
                                              // removeItem(context, index);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
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
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 114,
              left: 0,
              right: 0,
              child: Align(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    child: MaterialButton(
                      minWidth: 200,
                      padding: const EdgeInsets.all(20),
                      onPressed: () {
                        showAddProductDialog(context);
                      },
                      child: Text(
                        'Add Product',
                        style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      //Column(
      //   children: [
      //     Container(
      //       height: 150,
      //     ),
      //     Container(
      //       height: MediaQuery.of(context).size.height - 150,
      //       width: displayWidth(context),
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: const BorderRadius.only(
      //             topLeft: Radius.circular(20),
      //             topRight: Radius.circular(20)),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.5),
      //             spreadRadius: 5,
      //             blurRadius: 7,
      //             offset: const Offset(0, 3),
      //           ),
      //         ],
      //       ),
      //       child: StreamBuilder(
      //           stream: _streamController.stream,
      //           builder: (BuildContext context,
      //               AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
      //             if (snapshot.hasData) {
      //               return ListView(
      //                 children:
      //                     snapshot.data!.map((DocumentSnapshot document) {
      //                   Map<String, dynamic> data =
      //                       document.data() as Map<String, dynamic>;
      //                   String category = data['category'];
      //                   String productName = data['product_name'];
      //                   String productPrice = data['product_price'];

      //                   return Padding(
      //                     padding: const EdgeInsets.only(
      //                         bottom: 10, left: 5, right: 5),
      //                     child: Card(
      //                       elevation:
      //                           5, // Adjust the elevation to control the intensity of the shadow
      //                       shadowColor: Colors.redAccent,
      //                       child: ListTile(
      //                         leading: CircleAvatar(
      //                           backgroundImage:
      //                               NetworkImage(data['product_image']),
      //                         ),
      //                         title: Row(
      //                           crossAxisAlignment: CrossAxisAlignment.end,
      //                           children: [
      //                             Text(
      //                               productName,
      //                               style: const TextStyle(
      //                                 fontSize: 18,
      //                               ),
      //                             ),
      //                             const SizedBox(
      //                               width: 10,
      //                             ),
      //                             Text(
      //                               category,
      //                               style: const TextStyle(
      //                                   fontSize: 15,
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                           ],
      //                         ),
      //                         subtitle: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(productPrice),
      //                           ],
      //                         ),
      //                         trailing: PopupMenuButton<String>(
      //                           onSelected: (String value) {
      //                             // Handle selected value
      //                           },
      //                           itemBuilder: (
      //                             context,
      //                           ) =>
      //                               <PopupMenuEntry<String>>[
      //                             PopupMenuItem<String>(
      //                               value: 'edit',
      //                               child: ListTile(
      //                                 leading: const Icon(Icons.edit),
      //                                 title: const Text('Edit'),
      //                                 onTap: () {},
      //                               ),
      //                             ),
      //                             PopupMenuItem<String>(
      //                               value: 'remove',
      //                               child: ListTile(
      //                                 leading: const Icon(Icons.delete),
      //                                 title: const Text('Remove'),
      //                                 onTap: () {
      //                                   // removeItem(context, index);
      //                                 },
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         onTap: () {},
      //                       ),
      //                     ),
      //                   );
      //                 }).toList(),
      //               );
      //             }
      //             return const Center(
      //               child: Padding(
      //                 padding: EdgeInsets.all(10.0),
      //                 child: CircularProgressIndicator(),
      //               ),
      //             );
      //           }),
      //     ),
      //   ],
      // ),
    );

    //  bottomNavigationBar: Align(
    //   alignment: Alignment.center,
    //   child: Container(
    //     width: 280,
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [
    //           Color.fromARGB(255, 245, 157, 157),
    //           Color.fromARGB(255, 255, 90, 78),
    //           Color.fromARGB(255, 245, 157, 157),
    //         ],
    //         begin: Alignment.bottomLeft,
    //         end: Alignment.topRight,
    //       ),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: MaterialButton(
    //       minWidth: 280,
    //       padding: const EdgeInsets.all(20),
    //       onPressed: () {
    //         showAddProductDialog(context);
    //       },
    //       child: Text(
    //         'Add Product',
    //         style: GoogleFonts.poppins(
    //           color: whiteColor,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
  }

  showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: const Text(
                  'Add Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                titlePadding: const EdgeInsets.only(left: 80, top: 15),
                content: Container(
                  height: 360,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return InkWell(
                                    onTap: () {
                                      pickImage();
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: _Image != null
                                          ? Image.file(
                                              _Image!,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.camera_alt,
                                              size: 70,
                                              color: Colors.grey.shade400,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonTheme(
                                alignedDropdown: true,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('raw_category')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasError) {
                                      print(
                                          'Some Error Occured ${snapshot.error}');
                                    }
                                    List<DropdownMenuItem> rawCategory = [];
                                    if (!snapshot.hasData) {
                                      const CircularProgressIndicator();
                                    } else {
                                      final selectProgram =
                                          snapshot.data?.docs.reversed.toList();

                                      if (selectProgram != null) {
                                        for (var data in selectProgram) {
                                          rawCategory.add(
                                            DropdownMenuItem(
                                              value: data.id,
                                              child: Text(
                                                data['category'],
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                    return DropdownButton(
                                        value: selectedCategory,
                                        items: rawCategory,
                                        hint: const Text('Select Category'),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategory = value;
                                          });
                                        });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: productController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: 'Product Name',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: unitController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: 'Item Unit',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: 'Enter Price ',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 44,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 90, 78),
                              Color.fromARGB(255, 245, 157, 157),
                              Color.fromARGB(255, 253, 77, 64),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            uploadDataToStorage(_Image);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Save',
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
                ],
              );
            },
          ),
        );
      },
    );
  }
}
