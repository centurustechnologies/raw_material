import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:raw_material/helpers/app_constants.dart';

import 'homepage.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({
    super.key,
  });

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  bool detail = false;
  String? gender;
  String? gender1;
  bool hascard = true;
  bool selfemploy = true;
  TextEditingController billfirstnameController = TextEditingController();
  TextEditingController billlastnameController = TextEditingController();
  TextEditingController shipfirstnameController = TextEditingController();
  TextEditingController shiplastnameController = TextEditingController();

  TextEditingController billmobilenumberController = TextEditingController();
  TextEditingController shipmobilenumberController = TextEditingController();

  TextEditingController billcurrentadressController = TextEditingController();
  TextEditingController billcurrentadressController1 = TextEditingController();
  //TextEditingController currentadressController2 = TextEditingController();
  TextEditingController billlandmarkController = TextEditingController();
  TextEditingController billstateController = TextEditingController();
  TextEditingController shipcurrentadressController = TextEditingController();
  TextEditingController shipcurrentadressController1 = TextEditingController();
  //TextEditingController currentadressController2 = TextEditingController();
  TextEditingController shiplandmarkController = TextEditingController();
  TextEditingController shipstateController = TextEditingController();
  TextEditingController billpincodeController = TextEditingController();
  TextEditingController shippincodeController = TextEditingController();

  TextEditingController itemnameController = TextEditingController();
  TextEditingController itemquantityController = TextEditingController();

  TextEditingController hsnController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController hypothecationController = TextEditingController();
  TextEditingController paymentermController = TextEditingController();
  TextEditingController existinglimitController = TextEditingController();
  TextEditingController existingvintageController = TextEditingController();
  TextEditingController mortagepaymentController = TextEditingController();

  String area = '';
  String name = '';
  Future getadmindata(String id) async {
    await FirebaseFirestore.instance
        .collection('agents')
        .doc(id)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          area = value.get('location');
          name = value.get('name');
        });
      }
    });
  }

  Future<void> userlead() async {
    await FirebaseFirestore.instance.collection('Bills').add({
      'first_name':
          ("${billfirstnameController.text} ${billlastnameController.text}"),
      'pin_code': billpincodeController.text,
      'mobile_number': billmobilenumberController.text,
      'current_adress':
          ("${billcurrentadressController.text},${billcurrentadressController1.text}"),
      'landmark': billlandmarkController.text,
      'state': billstateController.text,
      'first_nameship': hascard
          ? ("${billfirstnameController.text} ${billlastnameController.text}")
          : ("${shipfirstnameController.text} ${shiplastnameController.text}"),
      'pin_codeship':
          hascard ? billpincodeController.text : shippincodeController.text,
      'mobile_numbership': hascard
          ? billmobilenumberController.text
          : shipmobilenumberController.text,
      'current_adressship': hascard
          ? ("${billcurrentadressController.text},${billcurrentadressController1.text}")
          : ("${shipcurrentadressController.text},${shipcurrentadressController1.text}"),
      'landmarkship':
          hascard ? billlandmarkController.text : shiplandmarkController.text,
      'stateship':
          hascard ? billstateController.text : shipstateController.text,
      'product_name': itemnameController.text,
      'price': priceController.text,
      'quantity': itemquantityController.text,
      'hsn': hsnController.text,
      'hypothecation': hypothecationController.text,
      'payment_term': paymentermController.text,
    }).whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

  //static const storage = FlutterSecureStorage();

  // String localtoken = '';
  // checkLogin() async {
  //   String? token = await getToken();

  //   if (token != null) {
  //     setState(() {
  //       localtoken = token;
  //     });
  //   } else {
  //     setState(() {
  //       localtoken = '';
  //     });
  //   }
  //   //log('user number is splash $token');
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          'Create Bill',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('billing_products')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // or any other loading indicator
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // Here, you can process the data from the snapshot and build your UI accordingly.
                        List<DocumentSnapshot> documents = snapshot.data!.docs;

                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 170,
                          width: MediaQuery.of(context).size.height / 6,
                          child: ListView(
                            children:
                                documents.map((DocumentSnapshot document) {
                              // Access data from the document using document.data()
                              String name = document[
                                  'product_name']; // Replace 'name' with the actual field name in your collection

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors.black, // Customize border color
                                    width: 1.0,
                                    // Customize border width
                                  ),
                                ),
                                padding: const EdgeInsets.all(
                                    10.0), // Add padding inside the box
                                margin: const EdgeInsets.symmetric(
                                    horizontal:
                                        10.0), // Add margin around the box
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 8, 71, 123),
                                  ),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                  maxLines:
                                      2, // Limit the number of lines initially displayed (adjust as needed)
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // or any other loading indicator
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // Here, you can process the data from the snapshot and build your UI accordingly.
                        List<DocumentSnapshot> documents = snapshot.data!.docs;

                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 170,
                          width: MediaQuery.of(context).size.height / 3,
                          child: ListView(
                            children:
                                documents.map((DocumentSnapshot document) {
                              // Access data from the document using document.data()
                              String name = document[
                                  'product_name']; // Replace 'name' with the actual field name in your collection

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SizedBox(
                                      width: 300,
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Color.fromARGB(255, 8, 71, 123),
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
                                              color: Color.fromARGB(
                                                  255, 8, 71, 123),
                                            ),
                                            softWrap:
                                                true, // Allow text to wrap to the next line
                                            maxLines:
                                                3, // Limit the number of lines initially displayed (adjust as needed)
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
                                              color: Color.fromARGB(
                                                  255, 8, 71, 123),
                                            ),
                                            softWrap:
                                                true, // Allow text to wrap to the next line
                                            maxLines:
                                                3, // Limit the number of lines initially displayed (adjust as needed)
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: mainColor,
                                        padding: EdgeInsets.zero,
                                        minWidth: 0,
                                        height: 0,
                                        onPressed: () {
                                          // insertCartWithQuantity(
                                          //   securityKey,
                                          //   widget.userId,
                                          //   cartData[index]['product_id'],
                                          //   cartData[index]['current_price'],
                                          //   cartData[index]['categery_id'],
                                          //   int.parse(cartData[index]
                                          //           ['cart_product_quantity']) +
                                          //       1,
                                          // );
                                          // setState(() {
                                          //   getCart(securityKey, userId);
                                          // });
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: whiteColor,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(right: 8, left: 8),
                                        child: SizedBox(
                                          width: 20,
                                          child: Text(
                                            "23",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 8, 71, 123),
                                            ),
                                            softWrap:
                                                true, // Allow text to wrap to the next line
                                            maxLines:
                                                3, // Limit the number of lines initially displayed (adjust as needed)
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                          color: mainColor,
                                          padding: EdgeInsets.zero,
                                          minWidth: 0,
                                          height: 0,
                                          onPressed: () {},
                                          child: InkWell(
                                            onTap: () {
                                              // removeCart(
                                              //   securityKey,
                                              //   cartData[index]['cart_id'],
                                              // );
                                              // setState(() {
                                              //   getCart(
                                              //     securityKey,
                                              //     widget.userId,
                                              //   );
                                              //   cartData.length <= 1
                                              //       ? log(
                                              //           'cart length is smaller ${cartData.length}')
                                              //       : log(
                                              //           'cart length is greater ${cartData.length}');
                                              // });
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: whiteColor,
                                            ),
                                          )
                                          // : Icon(
                                          //     Icons.remove,
                                          //     color: whiteColor,
                                          //   ),
                                          ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              "Grand Total",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 8, 71, 123),
                              ),
                              softWrap:
                                  true, // Allow text to wrap to the next line
                              maxLines:
                                  3, // Limit the number of lines initially displayed (adjust as needed)
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: SizedBox(
                            width: 80,
                            child: Text(
                              "50 items",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 8, 71, 123),
                              ),
                              softWrap:
                                  true, // Allow text to wrap to the next line
                              maxLines:
                                  3, // Limit the number of lines initially displayed (adjust as needed)
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: SizedBox(
                            width: 70,
                            child: Text(
                              "200000 rs",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 8, 71, 123),
                              ),
                              softWrap:
                                  true, // Allow text to wrap to the next line
                              maxLines:
                                  3, // Limit the number of lines initially displayed (adjust as needed)
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
                colors: [Colors.blue, Color.fromARGB(255, 8, 71, 123)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
          ),
          child: MaterialButton(
            onPressed: () {
              if (billfirstnameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  paymentermController.text.isNotEmpty) {
                dialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please fill all mandatory fields'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(
                        bottom: 610, left: 10, right: 10, top: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
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

  dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 250,
                    width: 300,
                    child: Lottie.asset('assets/conform.json',
                        fit: BoxFit.cover, repeat: true),
                  ),
                ),
                const Text(
                  "You'r all set!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: 250,
                  child: Text(
                    'Click ok button to View Bill',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 94, 94, 94),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: MaterialButton(
                    onPressed: () {
                      userlead();
                    },
                    color: Color.fromARGB(255, 4, 53, 94),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 80),
                      child: Text(
                        'ok',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  info(name, name1, control, type, length) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 8, 71, 123),
              ),
            ),
            const Text(
              '*',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w400, color: Colors.red),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 20),
          child: TextField(
            controller: control,
            keyboardType: type,
            //maxLength: length,
            expands: false,
            //maxLengthEnforcement: false,

            decoration: InputDecoration(
              hintText: name1,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
