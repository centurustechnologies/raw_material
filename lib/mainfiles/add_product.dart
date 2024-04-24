// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raw_material/helpers/app_constants.dart';

// ignore: camel_case_types
class product_list extends StatefulWidget {
  const product_list({super.key});

  @override
  State<product_list> createState() => _product_listState();
}

class _product_listState extends State<product_list> {
  List category_List = [];
  String categorytype = "";
  String categoryname = "";
  String? selectedCategory;
  DocumentSnapshot? documentSnapshot;
  String _selectedUnit = 'Select';
  String selectedCategoryLabel = 'Select Category';

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
    Reference referenceDireImages = referenceRoot.child('product_image');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);

    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      String imageUrl = await referenceImageToUpload.getDownloadURL();

      var snapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      int currentCount = snapshot.size;
      String productId = (currentCount + 1).toString();
      String productPrice = priceController.text;
      String productUnit = unitController.text;
      String basePrice =
          (int.parse(productUnit) / int.parse(productPrice)).toString();

      await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .doc(productId)
          .set({
        'categery': selectedCategory,
        'product_unit': unitController.text,
        'selected_unit': _selectedUnit,
        'product_name': productController.text,
        'product_price': priceController.text,
        'product_id': productId,
        'product_image': imageUrl,
        'product_type': 'full',
        'base_price': basePrice,
      });

      print("Data added successfully");

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
    } catch (error) {
      print("Error occurred while uploading image and data: $error");
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

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.redAccent,
                Colors.red,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Change the color here
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: MaterialButton(
                onPressed: () {
                  showAddProductDialog(context);
                },
                textColor: Colors.red,
                child: const Text('Add New Product'),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: _streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children:
                              snapshot.data!.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            String productId = data['product_id'];
                            String productType = data['product_type'];
                            String productName = data['product_name'];
                            String productPrice = data['product_price'];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.greenAccent, // Border color
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  productName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  productId,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              productType,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹ $productPrice',

                                                // documentSnapshot['time'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList()));
                }),
          ),
        ],
      ),
    );
  }

  showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
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
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('raw_categery')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(
                                        'Some Error Occured ${snapshot.error}');
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  List<PopupMenuItem<String>> categoryItems =
                                      [];
                                  final documents =
                                      snapshot.data!.docs.reversed.toList();

                                  for (var doc in documents) {
                                    var categoryName = doc['categery_name'];
                                    categoryItems.add(
                                      PopupMenuItem<String>(
                                        value: doc.id,
                                        child: Text(categoryName),
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    child: PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        setState(() {
                                          selectedCategory = value;
                                          var selectedDoc =
                                              documents.firstWhere(
                                                  (doc) => doc.id == value);
                                          selectedCategoryLabel =
                                              selectedDoc['categery_name'];
                                        });
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          categoryItems,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedCategoryLabel,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 124, 124, 124),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                              const SizedBox(height: 0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: unitController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Item Unit',
                                    suffixIcon: PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        setState(() {
                                          if (value != 'Select') {
                                            _selectedUnit = value;
                                          }
                                        });
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Select',
                                          child: Text('Select'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'kg',
                                          child: Text('kg'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'litre',
                                          child: Text('litre'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'pcs',
                                          child: Text('pcs'),
                                        ),
                                      ],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(_selectedUnit),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
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
                          gradient: const LinearGradient(
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
