import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(home: AddProductPage()));
}

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Add New Product'),
          onPressed: () => showAddProductDialog(context),
        ),
      ),
    );
  }

  void showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: AddProductForm(),
        );
      },
    );
  }
}

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _productController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> uploadDataToStorage() async {
    // Placeholder for your upload logic
    print("Simulating data upload");
    Navigator.of(context).pop(); // Close the dialog after "upload"
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Product',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
            ),
          ),
          TextField(
            controller: _productController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _unitController,
            decoration: InputDecoration(labelText: 'Unit'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: uploadDataToStorage,
            child: Text('Save Product'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}
