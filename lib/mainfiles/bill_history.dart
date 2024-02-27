// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/mainfiles/card.dart';
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 71, 123),
          title: const Text(
            'Bill history',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
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
        body: SingleChildScrollView(
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
                    children: snapshot.data!.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String customerId = data['customer_id'];
                      String customerName = data['customer_name'];
                      String price = data['price'];

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Card(
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              border: Border.all(color: Colors.blue, width: 1),
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
                                        customerName,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
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
                                              Row(
                                                children: [
                                                  Text(
                                                    "Customer Id :",
                                                    style: const TextStyle(
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
                                                  Text(
                                                    "₹",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    " $price",
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
                                          icon:
                                              const Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BillDetail(
                                                  historyData: const [],
                                                ),
                                              ),
                                            );
                                          },
                                          iconSize:
                                              25.0, // Adjust the size of the icon as needed
                                          color: Colors
                                              .blue, // Customize the color of the icon
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        child: IconButton(
                                          icon: const Icon(Icons.download),
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
                );
              }),
        ),
      ),
    );
  }
}

class BillDetail extends StatefulWidget {
  final List<Map<String, dynamic>> historyData;

  // ignore: prefer_const_constructors_in_immutables
  BillDetail({super.key, required this.historyData});
  @override
  State<BillDetail> createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill history Details'),
      ),
      body: ListView.builder(
        itemCount: widget.historyData.length,
        itemBuilder: (context, index) {
          final data = widget.historyData[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Customer: ${data['customerName']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Customer ID: ${data['customerId']}'),
                  Text('User: ${data['userName']}'),
                  Text('User ID: ${data['userId']}'),
                  Text('Products: ${data['products']}'),
                  Text('Total Payment: \$${data['totalPayment']}'),
                  Text('Details: ${data['details']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: () {
                      // Add functionality to download data here
                      // Example: downloadData(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading data...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () {
                      // Add functionality to print data here
                      // Example: printData(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Printing data...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: ExpensivePage(
        historyData: const [
          {
            'customerName': 'John Doe',
            'customerId': 'C001',
            'userName': 'Jane Smith',
            'userId': 'U001',
            'products': 'Product A, Product B',
            'totalPayment': 200.0,
            'details': 'Details for transaction 1',
          },
          {
            'customerName': 'Alice Johnson',
            'customerId': 'C002',
            'userName': 'Bob Brown',
            'userId': 'U002',
            'products': 'Product C, Product D',
            'totalPayment': 350.0,
            'details': 'Details for transaction 2',
          },
          // Add more historical data as needed
        ],
      ),
    ));
  }
}
