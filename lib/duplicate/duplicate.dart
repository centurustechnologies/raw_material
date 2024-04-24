import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(App());

///Example App
class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS:
              PageTransition(type: PageTransitionType.fade, child: this)
                  .matchingBuilder,
        }),
      ),
      home: ProductListScreen(
        tableSelected: '',
      ),
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case '/second':
      //       return PageTransition(
      //         child: const SecondPage(),
      //         type: PageTransitionType.theme,
      //         settings: settings,
      //         duration: const Duration(seconds: 1),
      //         reverseDuration: const Duration(seconds: 1),
      //       );
      //     default:
      //       return null;
      //   }
      // },
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final String tableSelected;
  ProductListScreen({Key? key, required this.tableSelected}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 2.35,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(widget.tableSelected)
              .collection('productraw')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> productSnapshot) {
            if (productSnapshot.hasData) {
              return ListView.builder(
                itemCount: productSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot productDocumentSnapshot =
                      productSnapshot.data!.docs[index];
                  TextEditingController unitController = TextEditingController(
                      text: productDocumentSnapshot['product_unit'].toString());

                  double productPrice = double.parse(
                      productDocumentSnapshot['product_price'].toString());
                  int productUnit = int.parse(
                      productDocumentSnapshot['product_unit'].toString());
                  double basePrice = productPrice / productUnit;

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 246, 254),
                      border: Border.all(
                          color: Colors.blue.withOpacity(0.05), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " ${productDocumentSnapshot['product_name']} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Edit Product Unit"),
                                        content: TextField(
                                          controller: unitController,
                                          keyboardType: TextInputType.number,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              hintText: "Enter new unit"),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Update"),
                                            onPressed: () {
                                              int newUnit = int.tryParse(
                                                      unitController.text) ??
                                                  productUnit;
                                              double newBasePrice =
                                                  productPrice / newUnit;
                                              FirebaseFirestore.instance
                                                  .collection('tablesraw')
                                                  .doc(widget.tableSelected)
                                                  .collection('productraw')
                                                  .doc(productDocumentSnapshot
                                                      .id)
                                                  .update({
                                                'product_unit':
                                                    newUnit.toString(),
                                                'base_price':
                                                    newBasePrice.toString(),
                                              }).then((_) {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "${productDocumentSnapshot['product_unit']}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                " ${productDocumentSnapshot['selected_unit']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '\$${basePrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                                // Additional Widgets...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
