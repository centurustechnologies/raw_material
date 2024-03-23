// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/NewApp/card.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  // ignore: unused_field
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
  late List<DocumentSnapshot> _document;
  List items = [];

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

  void removeItem(BuildContext context) {
    if (items.isNotEmpty) {
      int removedItem = items.removeLast();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item $removedItem removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                items.add(removedItem);
              });
            },
          ),
        ),
      );
      setState(() {}); // Trigger rebuild after removing the item
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Bill history',
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
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _streamController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  width: 400,
                  child: ListView(
                    children: snapshot.data!.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      int customerId = data['costomer_id'];
                      String productQuantity = data['product_quantity'];
                      String productPrice = data['product_price'];

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10),
                        child: Card(
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 20, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        productQuantity,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            removeItem(
                                              context,
                                            );
                                          },
                                          iconSize: 28.0,
                                          color: Colors.blue,
                                        ),
                                      ),
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
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Bill Id :",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    " $customerId",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "₹",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    " $productPrice",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                          ),
                                          onPressed: () {
                                            String quantity =
                                                data['product_quantity'];
                                            int id = data['costomer_id'];
                                            String price =
                                                data['product_price'];

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BillDetail(
                                                  productQuantity: quantity,
                                                  customerId: id,
                                                  productPrice: price,
                                                ),
                                              ),
                                            );
                                          },
                                          iconSize: 25.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.download,
                                          ),
                                          onPressed: () {},
                                          iconSize:
                                              28.0, // Adjust the size of the icon as needed
                                          color: Colors
                                              .blue, // Customize the color of the icon
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            //trailing: ,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class BillDetail extends StatefulWidget {
  final int customerId;
  final String productQuantity;
  final String productPrice;

  BillDetail(
      {required this.customerId,
      required this.productQuantity,
      required this.productPrice});
  @override
  State<BillDetail> createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  final bool _paymentResult = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          'Detail Bill history',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('raw_cart')
            .where(
              'product_price',
              isEqualTo: widget.productPrice,
            )
            .where(
              'costomer_id',
              isEqualTo: widget.customerId,
            )
            .where(
              'product_quantity',
              isEqualTo: widget.productQuantity,
            )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bills found'));
          }
          final DocumentSnapshot document = snapshot.data!.docs.first;
          final Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;

          return Column(
            children: [
              const Row(
                children: [],
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: SizedBox(
                  height: 510,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Bill Id',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(': '),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${data['costomer_id']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 28,
                                ),
                                const Text(':'),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  data['product_quantity'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Customer Name',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                const Text(':'),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  data['product_price'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Text(
                                  'Products',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                            const SizedBox(height: 0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Expanded(
                                child: Card(
                                  child: Container(
                                    height: 230,
                                    width: MediaQuery.of(context).size.width,
                                    child: const SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 2,
                                            left: 5,
                                            top: 2,
                                            bottom: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '1.)',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            'customer',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(":"),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Price',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer_name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer_name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer_name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer_name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'customer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'name',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 30),
                        child: Column(
                          children: [
                            const Divider(
                              height: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Items',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 14,
                                  ),
                                  const Text(':'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data['product_price'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: _paymentResult
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              height: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Grand Price',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text(':'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '₹',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data['product_price'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: _paymentResult
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              height: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


 
 
 
 
 // ListView.builder(
      //   itemCount: widget.historyData.length,
      //   itemBuilder: (context, index) {
      //     final data = widget.historyData[index];
      //     return Card(
      //       margin: const EdgeInsets.all(8.0),
      //       child: ListTile(
      //         title: Text('Customer: ${data['customerName']}'),
      //         subtitle: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             Text('Customer ID: ${data['customerId']}'),
      //             Text('User: ${data['userName']}'),
      //             Text('User ID: ${data['userId']}'),
      //             Text('Products: ${data['products']}'),
      //             Text('Total Payment: \$${data['totalPayment']}'),
      //             Text('Details: ${data['details']}'),
      //           ],
      //         ),
      //         trailing: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             IconButton(
      //               icon: const Icon(Icons.file_download),
      //               onPressed: () {
      //                 // Add functionality to download data here
      //                 // Example: downloadData(data);
      //                 ScaffoldMessenger.of(context).showSnackBar(
      //                   const SnackBar(content: Text('Downloading data...')),
      //                 );
      //               },
      //             ),
      //             IconButton(
      //               icon: const Icon(Icons.print),
      //               onPressed: () {
      //                 // Add functionality to print data here
      //                 // Example: printData(data);
      //                 ScaffoldMessenger.of(context).showSnackBar(
      //                   const SnackBar(content: Text('Printing data...')),
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    

  // void main() {
  //   runApp(MaterialApp(
  //     home: ExpensivePage(
  //       historyData: const [
  //         {
  //           'customerName': 'John Doe',
  //           'customerId': 'C001',
  //           'userName': 'Jane Smith',
  //           'userId': 'U001',
  //           'products': 'Product A, Product B',
  //           'totalPayment': 200.0,
  //           'details': 'Details for transaction 1',
  //         },
  //         {
  //           'customerName': 'Alice Johnson',
  //           'customerId': 'C002',
  //           'userName': 'Bob Brown',
  //           'userId': 'U002',
  //           'products': 'Product C, Product D',
  //           'totalPayment': 350.0,
  //           'details': 'Details for transaction 2',
  //         },
  //         // Add more historical data as needed
  //       ],
  //   ),
  // ));
