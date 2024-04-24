import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  String id = ''; // Assuming you have an ID variable for the document
  DocumentSnapshot?
      documentSnapshot; // Assuming you have a documentSnapshot variable
  TextEditingController productNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productUnitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: productIdController,
              decoration: const InputDecoration(labelText: 'Product ID'),
            ),
            TextFormField(
              controller: productPriceController,
              decoration: const InputDecoration(labelText: 'Product Price'),
            ),
            TextFormField(
              controller: productUnitController,
              decoration: const InputDecoration(labelText: 'Product Unit'),
            ),
            ElevatedButton(
              onPressed: () {
                uploadProduct();
              },
              child: const Text('Upload Product'),
            ),
          ],
        ),
      ),
    );
  }

  void uploadProduct() async {
    try {
      String productName = productNameController.text;
      String category = categoryController.text;
      String productId = productIdController.text;
      String productPrice = productPriceController.text;
      String productUnit = productUnitController.text;

      String basePrice = productPrice;
      String total =
          productPrice; // Assuming total_price is initialized with product_price
      String quantity = '1'; // Assuming initial quantity is 1

      if (documentSnapshot != null) {
        // Retrieve existing total_price and quantity if the document exists
        String totalPrice = documentSnapshot!['total_price'];
        String existingQuantity = documentSnapshot!.get('quantity');

        // Calculate new total_price and quantity based on existing values
        total = "${int.parse(totalPrice) + int.parse(basePrice)}";
        quantity = '${int.parse(existingQuantity) + 1}';

        // Calculate new base_price by dividing total_price by quantity
        basePrice = (int.parse(total) / int.parse(quantity)).toStringAsFixed(2);
      }

      await FirebaseFirestore.instance
          .collection('tablesraw')
          .doc(id)
          .collection('productraw')
          .doc(productId)
          .set(
        {
          'product_name': productName,
          'category': category,
          'product_id': productId,
          'product_price': productPrice,
          'total_price': total,
          'base_price': basePrice,
          'selected_unit': quantity,
          'quantity': productUnit,
        },
      );

      // Clear text fields after upload
      productNameController.clear();
      categoryController.clear();
      productIdController.clear();
      productPriceController.clear();
      productUnitController.clear();
    } catch (e) {
      print('Error uploading product: $e');
    }
  }
}
