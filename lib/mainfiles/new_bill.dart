import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/NewApp/card.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/mainfiles/add_product.dart';
import 'package:raw_material/mainfiles/bill_history.dart';
import 'package:raw_material/mainfiles/category.dart';
import 'package:raw_material/mainfiles/manage_user.dart';
import 'package:raw_material/mainfiles/my_order.dart';

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
  late List<DocumentSnapshot> _document;
  List items = [];

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

  void addDataToRawCart() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('raw_cart').get();
      int currentCount = snapshot.size;
      await FirebaseFirestore.instance.collection('raw_cart').add({
        'costomer_id': currentCount + 1,
        'customer_name': nameController.text,
        'price': '₹ 0',
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
            decoration: BoxDecoration(
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
              height: 20,
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
                        padding: EdgeInsets.all(10.0),
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
                          String costumerName = data['customer_name'];
                          String price = data['price'];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GenerateNewBill(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    costumerName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "itemDescription",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Price : ₹ $price",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
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
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Name',
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
                                  addDataToRawCart();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GenerateNewBill(),
                                    ),
                                  );
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
  const GenerateNewBill({
    super.key,
  });

  @override
  State<GenerateNewBill> createState() => _GenerateNewBillStateState();
}

class _GenerateNewBillStateState extends State<GenerateNewBill> {
  bool textlist = true;
  bool imagebool = true;
  bool detail = false;
  String? gender;
  String? gender1;
  bool hascard = true;
  bool selfemploy = true;

  String area = '';
  String name = '';
  int _number = 0;

  // ignore: unused_field
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
  late List<DocumentSnapshot> _document;

  @override
  void initState() {
    _document = [];
    _streamController = StreamController<List<DocumentSnapshot>>();
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
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

  // Future<void> addNewTableProduct(
  //     String id, DocumentSnapshot documentSnapshot) async {
  //   try {
  //     var docRef = FirebaseFirestore.instance
  //         .collection('tables')
  //         .doc(id)
  //         .collection('product')
  //         .doc(documentSnapshot.id);
  //     var doc = await docRef.get();

  //     FirebaseFirestore.instance
  //         .collection('tables')
  //         .doc(id)
  //         .collection('product')
  //         .get()
  //         .then(
  //       (value) {
  //         if (value.docs.isNotEmpty) {
  //         } else {
  //           FirebaseFirestore.instance.collection('tables').doc(id).update(
  //             {
  //               'status': 'occupied',
  //             },
  //           );
  //         }
  //       },
  //     );

  //     if (doc.exists) {
  //       if (kIsWeb) {
  //         String basePrice = documentSnapshot['product_price'];
  //         String totalPrice = doc.get('total_price');
  //         String total = "${int.parse(totalPrice) + int.parse(basePrice)}";
  //         String quantity = doc.get('quantity');
  //         await FirebaseFirestore.instance
  //             .collection('tables')
  //             .doc(id)
  //             .collection('product')
  //             .doc(documentSnapshot.id)
  //             .update(
  //           {
  //             'total_price': total,
  //             'quantity': '${int.parse(quantity) + 1}',
  //           },
  //         );
  //       }
  //     } else {
  //       if (kIsWeb) {
  //         await FirebaseFirestore.instance
  //             .collection('settings')
  //             .doc('settings')
  //             .get()
  //             .then(
  //           (value) async {
  //             await FirebaseFirestore.instance
  //                 .collection('tables')
  //                 .doc(id)
  //                 .collection('product')
  //                 .doc(documentSnapshot.id)
  //                 .set(
  //               {
  //                 'product_name': documentSnapshot['product_name'],
  //                 'categery': documentSnapshot['categery'],
  //                 'product_id': documentSnapshot['product_id'],
  //                 'product_price': documentSnapshot['product_price'],
  //                 'total_price': documentSnapshot['product_price'],
  //                 'product_type': documentSnapshot['product_type'],
  //                 'quantity': '1',
  //                 'tax': value.get('tax').toString(),
  //               },
  //             );
  //           },
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print('Error adding product: $e');
  //   }
  // }

  void _increment() {
    setState(() {
      _number++;
    });
  }

  void _decrement() {
    setState(() {
      if (_number > 0) {
        _number--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
              color: Colors.white, // Change the color here
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 2),
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
                          style: TextStyle(
                              fontSize: 16,
                              color: textlist ? Colors.green : Colors.blue,
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
          SizedBox(
            width: MediaQuery.of(context).size.width - 105,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 10),
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
                            color: Colors.red),
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: SizedBox(
                              width: 300,
                              child: Text(
                                "ProductName",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 8, 71, 123),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 50,
                                  child: Text(
                                    "6 pcs",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 8, 71, 123),
                                    ),
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 2),
                                child: SizedBox(
                                  width: 50,
                                  child: Text(
                                    "200 rs",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 8, 71, 123),
                                    ),
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              MaterialButton(
                                color: mainColor,
                                padding: const EdgeInsets.all(6.0),
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
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: SizedBox(
                                  width: 20,
                                  child: Text(
                                    "$_number",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 8, 71, 123),
                                    ),
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              MaterialButton(
                                color: mainColor,
                                padding: const EdgeInsets.all(6.0),
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
                      )
                    ],
                  ),
                  const Column(
                    children: [
                      Column(
                        children: [
                          Divider(
                            height: 2,
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total :',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$240',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
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
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          height: 39,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
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
            onPressed: () {},
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

  Widget _buildTextAndImageList() {
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
            padding: const EdgeInsets.only(top: 5),
            child: ListView(
              children: snapshot.data!.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String productName = data['product_name'];
                String image = data['product_image'];

                return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2.0),
                    child: imagebool
                        ? InkWell(
                            onTap: () {},
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
                            onTap: () {},
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
              }).toList(),
            ),
          ),
        );
      },
    );
  }

//  dialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20))),
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     height: 250,
//                     width: 300,
//                     child: Lottie.asset('assets/conform.json',
//                         fit: BoxFit.cover, repeat: true),
//                   ),
//                 ),
//                 const Text(
//                   "You'r all set!",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 const SizedBox(
//                   width: 250,
//                   child: Text(
//                     'Click ok button to View Bill',
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Color.fromARGB(255, 94, 94, 94),
//                         fontWeight: FontWeight.w500),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   width: 250,
//                   child: MaterialButton(
//                     onPressed: () {
//                       userlead();
//                     },
//                     color: Color.fromARGB(255, 4, 53, 94),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     child: const Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 7, horizontal: 80),
//                       child: Text(
//                         'ok',
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   info(name, name1, control, type, length) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               name,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w400,
//                 color: Color.fromARGB(255, 8, 71, 123),
//               ),
//             ),
//             const Text(
//               '*',
//               style: TextStyle(
//                   fontSize: 15, fontWeight: FontWeight.w400, color: Colors.red),
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 15, bottom: 20),
//           child: TextField(
//             controller: control,
//             keyboardType: type,
  //             //maxLength: length,
//             expands: false,
  //             //maxLengthEnforcement: false,
//             decoration: InputDecoration(
//               hintText: name1,
//               hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
}
