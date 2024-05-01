import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class updateProduct extends StatefulWidget {
  final String productID;

  const updateProduct({
    super.key,
    required this.productID,
  });

  @override
  State<updateProduct> createState() => _updateProductState();
}

class _updateProductState extends State<updateProduct> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController productController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String selectedCategory = 'Select Category';

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    var document = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productID)
        .get();

    var data = document.data()!;
    productController.text = data['product_name'];
    unitController.text = data['unit'];
    priceController.text = data['price'].toString();
    selectedCategory = data['category'];
    if (data['image_url'] != null) {
      _image = File(
          data['image_url']); // This won't work directly for network images
    }
    setState(() {});
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void updateProductDetails() {
    var collection = FirebaseFirestore.instance.collection('products');
    collection.doc(widget.productID).update({
      'product_name': productController.text,
      'unit': unitController.text,
      'price': double.tryParse(priceController.text) ?? 0,
      'category': selectedCategory,
      'image_url': _image
          ?.path, // Update logic for image might need handling for actual file upload
    }).then((_) {
      print("Document successfully updated!");
      Navigator.pop(context);
    }).catchError((error) {
      print("Error updating document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: productController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  isDense: true,
                ),
              ),
              TextField(
                controller: unitController,
                decoration: InputDecoration(
                  labelText: 'Unit',
                  isDense: true,
                ),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 44,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: MaterialButton(
                      onPressed: updateProductDetails,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
