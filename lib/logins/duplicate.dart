import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Arrays',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Firebase Arrays'),
        ),
        body: AddProductScreen(),
      ),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  int _productIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _getDocumentCount();
  }

  Future<void> _getDocumentCount() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('raw_bills').get();
    setState(() {
      _productIdCounter = querySnapshot.size;
    });
  }

  void _addProduct() {
    String productName = _productNameController.text.trim();
    String productPrice = _productPriceController.text.trim();

    if (productName.isNotEmpty && productPrice.isNotEmpty) {
      int newProductId = _productIdCounter + 1;
      FirebaseFirestore.instance
          .collection('raw_bills')
          .doc(newProductId.toString())
          .set({
        'id': newProductId,
        'products': {
          'product_Name': productName,
          'product_Price': FieldValue.arrayUnion([productPrice]),
        }
      }).then((_) {
        _productNameController.clear();
        _productPriceController.clear();
        _productIdCounter++; // Increment the counter after adding a new product
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter product name and price')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _productPriceController,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _addProduct,
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
