import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

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
          'Generate Bill',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 176,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Text(
                            'Billing detail',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 8, 71, 123),
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 35,
                              width: 120,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, bottom: 6),
                                child: TextField(
                                  controller: billfirstnameController,
                                  decoration: const InputDecoration(
                                    // border: InputBorder.none,
                                    hintText: "First name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                            Container(
                              height: 35,
                              width: 120,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, bottom: 6),
                                child: TextField(
                                  controller: billlastnameController,
                                  decoration: const InputDecoration(
                                    // border: InputBorder.none,
                                    hintText: "last name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      info(
                          'Mobile Number',
                          'Enter',
                          billmobilenumberController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      info(
                          'House and Street Number',
                          'Enter no.',
                          billcurrentadressController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(50)]),
                      info(
                          'Landmark',
                          'Enter',
                          billlandmarkController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      info(
                          'City Name',
                          'Enter no.',
                          billcurrentadressController1,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 8, 71, 123),
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 60,
                                width: 130,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, bottom: 6),
                                  child: TextField(
                                    controller: billstateController,
                                    decoration: const InputDecoration(
                                      // border: InputBorder.none,
                                      labelText: "State",
                                      hintText: "Enter Your State",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 130,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 0, bottom: 6),
                                  child: TextField(
                                    //controller: placeofbirthController,

                                    decoration: InputDecoration(
                                      // border: InputBorder.none,
                                      labelText: "Country",
                                      hintText: "Enter Your Country",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      info(
                          'Pin Code',
                          'Enter',
                          billpincodeController,
                          TextInputType.number,
                          [LengthLimitingTextInputFormatter(6)]),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Text(
                            'Shipping detail',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            "Same as Billing",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 8, 71, 123),
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 35,
                              child: RadioListTile(
                                title: Text("Yes",
                                    style:
                                        TextStyle(color: Colors.grey.shade700)),
                                value: "Yes",
                                groupValue: gender1,
                                onChanged: (value) {
                                  setState(() {
                                    gender1 = value.toString();
                                    hascard = true;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              height: 35,
                              child: RadioListTile(
                                title: Text(
                                  "No",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                value: "No",
                                groupValue: gender1,
                                onChanged: (value) {
                                  setState(() {
                                    gender1 = value.toString();
                                    hascard = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      hascard
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 8, 71, 123),
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0, bottom: 6),
                                          child: TextField(
                                            controller: shipfirstnameController,
                                            decoration: const InputDecoration(
                                              // border: InputBorder.none,
                                              hintText: "First name",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 28,
                                      ),
                                      Container(
                                        height: 35,
                                        width: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0, bottom: 6),
                                          child: TextField(
                                            controller: shiplastnameController,
                                            decoration: const InputDecoration(
                                              // border: InputBorder.none,
                                              hintText: "last name",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                info(
                                    'Mobile Number',
                                    'Enter',
                                    shipmobilenumberController,
                                    TextInputType.emailAddress,
                                    [LengthLimitingTextInputFormatter(30)]),
                                info(
                                    'House and Street Number',
                                    'Enter no.',
                                    shipcurrentadressController,
                                    TextInputType.emailAddress,
                                    [LengthLimitingTextInputFormatter(50)]),
                                info(
                                    'Landmark',
                                    'Enter',
                                    shiplandmarkController,
                                    TextInputType.emailAddress,
                                    [LengthLimitingTextInputFormatter(30)]),
                                info(
                                    'City Name',
                                    'Enter no.',
                                    shipcurrentadressController1,
                                    TextInputType.emailAddress,
                                    [LengthLimitingTextInputFormatter(30)]),
                                const SizedBox(
                                  height: 16,
                                ),
                                Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromARGB(255, 8, 71, 123),
                                          ),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 130,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, bottom: 6),
                                            child: TextField(
                                              controller: shipstateController,
                                              decoration: const InputDecoration(
                                                // border: InputBorder.none,
                                                labelText: "State",
                                                hintText: "Enter Your State",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 60,
                                          width: 130,
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 0, bottom: 6),
                                            child: TextField(
                                              //controller: placeofbirthController,

                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                labelText: "Country",
                                                hintText: "Enter Your Country",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                info(
                                    'Pin Code',
                                    'Enter',
                                    shippincodeController,
                                    TextInputType.number,
                                    [LengthLimitingTextInputFormatter(6)]),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            )
                          : Container(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Text(
                            'Product Informations',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.9)),
                          ),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Are You a",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //         fontWeight: FontWeight.w400,
                      //         color: Color.fromARGB(255, 8, 71, 123),
                      //       ),
                      //     ),
                      //     const Text(
                      //       '*',
                      //       style: TextStyle(
                      //           fontSize: 15,
                      //           fontWeight: FontWeight.w400,
                      //           color: Colors.red),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(
                        height: 16,
                      ),
                      info(
                          'Product Name',
                          'item name',
                          itemnameController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      info(
                          'Quantity',
                          'Enter ',
                          itemquantityController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      info(
                          'HSN/SAC',
                          'Enter',
                          hsnController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      info(
                          'Price',
                          'Enter price',
                          priceController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                      info(
                          'Enter Hypothecation By',
                          'Enter ',
                          hypothecationController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),

                      info(
                          'Payment Terms',
                          'Enter ',
                          paymentermController,
                          TextInputType.emailAddress,
                          [LengthLimitingTextInputFormatter(30)]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                  billlastnameController.text.isNotEmpty &&
                  billcurrentadressController.text.isNotEmpty &&
                  billcurrentadressController1.text.isNotEmpty &&
                  billmobilenumberController.text.isNotEmpty &&
                  billpincodeController.text.isNotEmpty &&
                  billstateController.text.isNotEmpty &&
                  billlandmarkController.text.isNotEmpty &&
                  hsnController.text.isNotEmpty &&
                  hypothecationController.text.isNotEmpty &&
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
                    'Submit',
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
