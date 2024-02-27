// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List items = [];
  // ignore: non_constant_identifier_names
  List category_List = [];
  String categorytype = "";
  String categoryname = "";
  File? _image;
  File? editPickImages;

  Uint8List webImage = Uint8List(8);
  Uint8List editWbImage = Uint8List(8);

  TextEditingController categoryController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
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
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  Future<void> addProductToFirestore() async {
    FirebaseFirestore.instance.collection('raw_billing_product').doc().set({
      'category': categoryController,
      'product_name': productController.text,
      'product_price': priceController.text,
      'product_image': _image,
    }).then((value) {
      print("data added sucessfully");
    }).catchError((error) {
      print("failed to add data: $error");
    }).whenComplete(() {
      setState(() {
        categoryController.clear();
        productController.clear();
        priceController.clear();
        unitController.clear();
      });
    });
  }

  Future getImageFromGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
            "Product List",
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
          padding: const EdgeInsets.only(top: 0),
          child: SizedBox(
            height: displayHeight(context) / 1.1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Colors.blue,
                              Color.fromARGB(255, 2, 52, 93)
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        onTap: () {
                          showAddProductDialog(
                              context); // Call the dialog function here
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(
                              right: 40, left: 40, top: 10, bottom: 10),
                          child: Text(
                            'Add Product',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //iklashjlkhasdlik
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.32,
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
                        child: StreamBuilder(
                          stream: _streamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                  children: snapshot.data!.map(
                                (DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  String category = data['category'];
                                  String productName = data['product_name'];
                                  String productPrice = data['product_price'];

                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/images/Logo-10.png'),
                                        ),
                                        title: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              productName,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              category,
                                              style: TextStyle(
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
                                        trailing: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList());
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Product',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          titlePadding: const EdgeInsets.only(left: 80, top: 15),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 44,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Color.fromARGB(255, 2, 52, 93)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      addProductToFirestore();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ignore: prefer_const_literals_to_create_immutables
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
          content: Container(
            height: 365,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            getImageFromGallery();
                          },
                          child: Container(
                            width: 220,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    size: 70,
                                    color: Colors.grey.shade400,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            value: categorytype.isEmpty ? null : categorytype,
                            iconSize: 30,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: const Text(
                              'Category',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                categorytype = newValue!;
                                log("brand value is $categorytype" as num);
                              });
                            },
                            items: category_List.map(
                              (item) {
                                return DropdownMenuItem(
                                  value: item['categery_id'].toString(),
                                  onTap: () {
                                    setState(
                                      () {
                                        categoryname = item['categery_name'];
                                      },
                                    );
                                  },
                                  child: Text(
                                    item['categery_name'],
                                  ),
                                );
                              },
                            ).toList(),
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
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 10),
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
        );
      },
    );
  }
}
