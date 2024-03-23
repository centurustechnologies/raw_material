import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Subcollection',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Firebase Subcollection'),
        ),
        body: FirebaseSubcollectionPage(),
      ),
    );
  }
}

class FirebaseSubcollectionPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addDocumentToSubcollection() async {
    try {
      // Reference to the main collection
      CollectionReference mainCollection = _firestore.collection('raw_cart');

      // Reference to the document within the main collection
      DocumentReference documentReference = mainCollection.doc('product');

      // Reference to the subcollection within the document
      CollectionReference subcollectionReference =
          documentReference.collection('subcollection_name');

      // Data to be added to the subcollection
      Map<String, dynamic> data = {
        'field1': 'value1',
        'field2': 'value2',
      };

      // Add the data to the subcollection
      await subcollectionReference.add(data);

      print('Document added to subcollection successfully');
    } catch (e) {
      print('Error adding document to subcollection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _addDocumentToSubcollection,
        child: Text('Add Document to Subcollection'),
      ),
    );
  }
}
