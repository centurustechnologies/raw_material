import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raw_material/NewApp/card.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/logins/duplicate.dart';

import 'homepage.dart';

class NewBill extends StatefulWidget {
  const NewBill({super.key});

  @override
  State<NewBill> createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  late StreamController<List<DocumentSnapshot>> _streamController;
  final TextEditingController _searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String _errorMessage = '';
  late List<DocumentSnapshot> _document;
  List items = [];
  String price = '0';
  String quantity = '';
  String grandprice = '';
  String _tableSelected = '';

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

  // void addDataToRawCart() async {
  //   try {
  //     var snapshot =
  //         await FirebaseFirestore.instance.collection('raw_user').get();
  //     int currentCount = snapshot.size;
  //     await FirebaseFirestore.instance
  //         .collection('raw_cart')
  //         .doc(nameController.text)
  //         .set({
  //       'costomer_id': currentCount + 1,
  //       'product_name': '',
  //       'product_quantity': currentCount + 1,
  //       'customer_name': nameController.text,
  //       'product_price': '0',
  //       'Grand_total': '0',
  //     }).whenComplete(() {
  //       setState(() {
  //         nameController.clear();

  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const NewBill()),
  //         );
  //       });
  //     });
  //     if (kDebugMode) {
  //       print("Data added successfully!");
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print("Failed to add data: $error");
  //     }
  //   }
  // }

  void addproductdatToRawCart(String id) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('raw_cart').get();
      int id = snapshot.size;
      await FirebaseFirestore.instance
          .collection('raw_cart')
          .doc(id.toString())
          .set({
        'product_id': id,
        'product_name': nameController.text,
        'product_details': FieldValue.arrayUnion([
          {
            'product_id': id,
            'product_price': price,
            'product_quantity': quantity,
          }
        ]),
        'time': DateFormat('MMM d, y hh:mm a').format(DateTime.now()),
        'grand_price': grandprice,
      }).whenComplete(() {
        setState(() {
          nameController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewBill()),
          );
        });
      });
      if (kDebugMode) {
        print("Data added successfully!");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Failed to add data: $error");
      }
    }
  }
  // void addproductdatToRawCart() async {
  //   try {
  //     var snapshot =
  //         await FirebaseFirestore.instance.collection('raw_cart').get();
  //     int currentCount = snapshot.size;
  //     await FirebaseFirestore.instance.collection('raw_cart').add({
  //       'costomer_id': currentCount + 1,
  //       'product_name': '',
  //       'product_quantity': currentCount + 6,
  //       'customer_name': nameController.text,
  //       'product_price': ' 0',
  //       'Grand_total': ' 0',
  //     }).whenComplete(() {
  //       setState(() {
  //         nameController.clear();
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const NewBill()),
  //         );
  //       });
  //     });
  //     if (kDebugMode) {
  //       print("Data added successfully!");
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print("Failed to add data: $error");
  //     }
  //   }
  // }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('raw_cart').get();
      _document = querySnapshot.docs;
      _streamController.add(_document);
    } catch (e) {
      print('error in fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NewHome()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 245, 157, 157),
                  Color.fromARGB(255, 255, 90, 78),
                  Color.fromARGB(255, 245, 157, 157),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'New Bill',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        drawer: const MyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 5.0,
                    ),
                  ),
                  hintText: "Search...",
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            // _isLoading
            // ? const Expanded(
            //     child: Center(
            //       child: Column(
            //         children: [
            //           Padding(
            //             padding: EdgeInsets.all(16.0),
            //             child: Text(
            //               'No data available....',
            //               style: TextStyle(
            //                   fontSize: 18, fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   )
            // :
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: _streamController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 250,
                      width: 400,
                      child: ListView(
                        children:
                            snapshot.data!.map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String productName = data['product_name'];
                          dynamic productprice = data['product_price'];

                          return InkWell(
                            onTap: () {
                              String name = data['product_name'];
                              dynamic pprice = data['product_price'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenerateNewBill(
                                    productName: name,
                                    productprice: pprice,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "itemDescription",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Price : ₹ $productprice",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 10, right: 10),
                                  child: Divider(
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  height: 44,
                  width: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 247, 125, 125),
                      Colors.red
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Create New Bill',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Name',
                                    errorText: _errorMessage.isNotEmpty
                                        ? _errorMessage
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Price : ₹0",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 247, 125, 125)),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _errorMessage = '';
                                  });
                                  if (nameController.text.isEmpty) {
                                    setState(() {
                                      _errorMessage = 'Please fill the details';
                                    });
                                  } else
                                    setState(() {
                                      addproductdatToRawCart(
                                          _tableSelected.toString());
                                    });
                                },
                                child: const Text(
                                  'Create',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 247, 125, 125),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add New Bill',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

class GenerateNewBill extends StatefulWidget {
  final String productName;
  final String productprice;

  GenerateNewBill({required this.productName, required this.productprice});

  @override
  State<GenerateNewBill> createState() => _GenerateNewBillStateState();
}

class _GenerateNewBillStateState extends State<GenerateNewBill> {
  bool textlist = true;
  bool imagebool = true;
  bool detail = false;
  String? gender;
  String? gender1;
  bool loading = true;
  bool _isLoading = true;

  String area = '';
  String productName = '';
  String price = '';
  String quantity = '';
  String name = '';
  int _number = 1;
  double _totalPrice = 0.0;

  // ignore: unused_field
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
  late List<DocumentSnapshot> _document;
  TextEditingController nameController = TextEditingController();

  String priceController = '';
  String quantityController = '';

  @override
  void initState() {
    _document = [];
    _streamController = StreamController<List<DocumentSnapshot>>();
    fetchData();
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addProductToRawCart() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('raw_cart').get();
      DocumentReference docRef = _firestore.collection('raw_cart').doc();

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Get the existing data
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('product_detail')) {
          List<dynamic> productDetails = List.from(data['product_detail']);
          productDetails.add({
            'productName': productName,
            'price': price,
            'quantity': quantity
          });
          await docRef.update({'product_details': productDetails});
        } else {
          await docRef.set({
            'product_detail': [
              {'productName': productName, 'price': price, 'quantity': quantity}
            ]
          });
        }

        print('Product details added to Firestore document.');
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error adding product details to Firestore document: $e');
    }
  }

  // void addproductdatToRawCart(String pdName) async {
  //   try {
  //     var snapshot =
  //         await FirebaseFirestore.instance.collection('raw_cart').get();
  //     int currentCount = snapshot.size;
  //     await FirebaseFirestore.instance.collection('raw_cart').add({
  //       'costomer_id': currentCount + 1,
  //       'product_name': pdName,
  //       'product_quantity': currentCount + 6,
  //       'customer_name': nameController.text,
  //       'product_price': ' 0',
  //       'Grand_total': ' 0',
  //     }).whenComplete(() {
  //       setState(() {
  //         nameController.clear();
  //       });
  //     });
  //     if (kDebugMode) {
  //       print("Data added successfully!");
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print("Failed to add data: $error");
  //     }
  //   }
  // }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      _document = querySnapshot.docs;
      _streamController.add(_document);
      print("data add successfully $_document");
    } catch (e) {
      print('error i fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  void _increment() async {
    setState(() {
      _number++;
      _totalPrice += 240;
    });
    // await FirebaseFirestore.instance
    //     .collection('raw_billing_product')
    //     .doc('your_document_id')
    //     .update({'product_quantity': _number});
  }

  void _decrement() async {
    setState(() {
      if (_number > 1) {
        _number--;
        _totalPrice -= 240;
      }
    });
    // await FirebaseFirestore.instance
    //     .collection('raw_billing_product')
    //     .doc('your_document_id')
    //     .update({'product_quantity': _number});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 245, 157, 157),
                Color.fromARGB(255, 255, 90, 78),
                Color.fromARGB(255, 245, 157, 157),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Generate New Bill',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 2),
                      child: SizedBox(
                        width: 100,
                        height: 45,
                        child: IconButton(
                          iconSize: 30,
                          splashColor: Colors.red,
                          icon: Row(
                            children: [
                              Text(
                                textlist ? ' Image' : " Text",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const Icon(
                                Icons.swap_horiz,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              imagebool = !imagebool;
                              textlist = !textlist;
                            });
                          },
                        ),
                      ),
                    ),
                    _buildTextAndImageList(),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('raw_cart')
                      .where(
                        'product_name',
                      )
                      .where(
                        'product_price',
                      )
                      .where(
                        'product_quantity',
                      )
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width - 105,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Order details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: SizedBox(
                                    height: 506,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data() as Map<String, dynamic>;
                                        // String productName =
                                        //     data['product_name'];
                                        // String productPrice =
                                        //     data['product_price'];
                                        // int productQuantity =
                                        //     data['product_quantity'];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(
                                                      'productName',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Color.fromARGB(
                                                            255, 8, 71, 123),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 8),
                                                        child: SizedBox(
                                                          width: 50,
                                                          child: Text(
                                                            "productQuantity",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      8,
                                                                      71,
                                                                      123),
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 2),
                                                        child: SizedBox(
                                                          width: 50,
                                                          child: Text(
                                                            'productPrice',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      8,
                                                                      71,
                                                                      123),
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        color: Colors.green,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        minWidth: 0,
                                                        height: 0,
                                                        onPressed: () {
                                                          _decrement();
                                                        },
                                                        child: Icon(
                                                          size: 18,
                                                          Icons.delete,
                                                          color: whiteColor,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8,
                                                                left: 8),
                                                        child: SizedBox(
                                                          width: 20,
                                                          child: Text(
                                                            "$_number",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      8,
                                                                      71,
                                                                      123),
                                                            ),
                                                            softWrap: true,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        color: Colors.green,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        minWidth: 0,
                                                        height: 0,
                                                        onPressed: () {
                                                          _increment();
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 18,
                                                          color: whiteColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 2,
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const Column(
                                  children: [
                                    Divider(
                                      height: 2,
                                    ),
                                    SizedBox(
                                      height: 13,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 2, right: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Grand Total :',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '\$240',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 13,
                                    ),
                                    Divider(
                                      height: 5,
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
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          height: 39,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 245, 157, 157),
                Color.fromARGB(255, 255, 90, 78),
                Color.fromARGB(255, 245, 157, 157),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(),
                ),
              );
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Generate',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTextAndImageList() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _streamController.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height - 205,
          width: MediaQuery.of(context).size.height / 7.4,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: ListView(
              children: snapshot.data!.map(
                (DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String productName = data['product_name'];
                  String image = data['product_image'];

                  return Container(
                      height: 67,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3.0),
                      child: imagebool
                          ? InkWell(
                              onTap: () {
                                fetchData();
                                addProductToRawCart();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, bottom: 20, right: 5, left: 5),
                                child: Text(
                                  productName,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 8, 71, 123),
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                fetchData();
                                addProductToRawCart();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Image.network(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width / 6,
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ));
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}
