// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/helpers/app_constants.dart';

import 'homepage.dart';

class create_bill extends StatefulWidget {
  const create_bill({super.key});

  @override
  State<create_bill> createState() => _create_billState();
}

class _create_billState extends State<create_bill> {
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
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
      await FirebaseFirestore.instance.collection('raw_cart').add({
        'user_id': 'ccdsf',
        'customer_name': 'dfsdfs',
        'price': 'dfsdff',
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
      // ignore: unused_local_variable
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
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 71, 123),
          title: const Text(
            'New Bill',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Create Table',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 24,
                                    )),
                              )
                            ],
                          ),
                          actions: [
                            Center(
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    addDataToRawCart();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Create',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]);
                    },
                  );
                },
                child: Container(
                  height: 50,
                  width: 180,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Color.fromARGB(255, 2, 52, 93)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
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
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                      height: MediaQuery.of(context).size.height - 180,
                      width: 400,
                      child: ListView(
                        children:
                            snapshot.data!.map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String userId = data['user_id'];
                          String costumerName = data['customer_name'];
                          String price = data['price'];

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddNewBillPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 20, top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            userId,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.more_vert))
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 20, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    costumerName,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    price,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                //trailing: ,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class AddNewBillPage extends StatefulWidget {
  const AddNewBillPage({
    super.key,
  });

  @override
  State<AddNewBillPage> createState() => _AddNewBillPageStateState();
}

class _AddNewBillPageStateState extends State<AddNewBillPage> {
  bool textlist = true;
  bool imagebool = true;
  bool detail = false;
  String? gender;
  String? gender1;
  bool hascard = true;
  bool selfemploy = true;

  String area = '';
  String name = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
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
                            padding: EdgeInsets.only(top: 5),
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
                                    "5 pcs",
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
                                onPressed: () {},
                                child: Icon(
                                  size: 18,
                                  Icons.add,
                                  color: whiteColor,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: SizedBox(
                                  width: 20,
                                  child: Text(
                                    "23",
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
                                onPressed: () {},
                                child: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
            gradient: const LinearGradient(
                colors: [Colors.blue, Color.fromARGB(255, 8, 71, 123)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
          ),
          child: MaterialButton(
            onPressed: () {},
            //color: Colors.blue,

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
        // if (snapshot.hasError) {
        //   return Text('Error: ${snapshot.error}');
        // }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          );
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height - 205,
          width: MediaQuery.of(context).size.height / 7.4,
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
                      horizontal: 10.0, vertical: 5.0),
                  child: imagebool
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 8, 71, 123),
                            ),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(2),
                          child: Image.network(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 6,
                            image,
                            fit: BoxFit.cover,
                          ),
                        ));
            }).toList(),
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
