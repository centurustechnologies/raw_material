// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class create_bill extends StatefulWidget {
  const create_bill({
    super.key,
  });

  @override
  State<create_bill> createState() => _create_billStateState();
}

class _create_billStateState extends State<create_bill> {
  bool textlist = true;
  bool imagebool = true;
  bool detail = false;
  String? gender;
  String? gender1;
  bool hascard = true;
  bool selfemploy = true;

  String area = '';
  String name = '';

  Future<void> userlead() async {
    await FirebaseFirestore.instance
        .collection('Bills')
        .add({}).whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

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
    return
        //  WillPopScope(
        //   onWillPop: () async {
        //     Navigator.popUntil(context, ModalRoute.withName('/first'));
        //     return true;
        //   },
        //   child:
        Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          'Generate Bill',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Change the color here
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: MyDrawer(),
      body: Column(
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
      //   ),
    );
  }

  Widget _buildTextAndImageList() {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
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
