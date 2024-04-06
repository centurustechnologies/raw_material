// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'NewApp/alertdialog.dart';

class BillGeneration extends StatefulWidget {
  const BillGeneration({super.key});

  @override
  State<BillGeneration> createState() => _BillGenerationState();
}

class _BillGenerationState extends State<BillGeneration> {
  String selectedCategoryIndex = '';
  bool showCart = false;
  bool textlist = true;
  bool imagebool = true;
  bool showCategories = true;
  bool showOrders = true;
  bool showProducts = false;
  bool showCustomer = false;
  bool showPayments = false;
  bool kotButton = true;
  bool kotDone = false;
  bool billButton = false;
  bool billDone = false;
  bool paymentButton = false;
  bool paymentDone = false;
  bool cancelTableButton = false;
  bool cancelTableDone = false;
  bool discountbutton = true;
  bool clickkot = true;
  bool clickprintbill = false;
  bool clickpayment = false;
  bool addInstructions = false;
  bool billprintshare = true;

  bool editGrandTotalPrice = false;

  int cloudTotalQuantity = 0;
  double cloudTotal = 0.0;
  double cloudCgst = 0.0;
  double cloudSgst = 0.0;

  double tax = 0.0;
  double taxAfterCalculation = 0.0;
  double totalTax = 0.0;
  String _errorMessage = '';

  bool discountstatus = true;
  String _productHover = '';
  String _tableHover = '';
  String _tableSelected = '0';
  String menuItemHover = 'Billing';
  String billType = 'Eat';
  String genderType = 'Male';
  String itemlenght = '';
  String selectedpaymentType = 'cash';
  String selectedSubpaymentType = '';
  TextEditingController searchController = TextEditingController();
  String search = '';
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController addnoteController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController customerPaidController = TextEditingController();
  TextEditingController customerPaidCashController = TextEditingController();
  TextEditingController cartController = TextEditingController();

  TextEditingController rawnameController = TextEditingController();

  String totalTables = '';
  String totalproducts = '';
  var discount = 0;
  String totalDiscount = '';
  String securityKey = "dev";
  var categery = '';
  var productid = '';
  var productprice = '';
  var producttype = '';
  var productname = '';
  var itemcount = '';
  var userId = '100';
  var paymenttype = 'Billing_panel';
  List productNames = [];
  List productPrice = [];
  List productType = [];
  List quantitytype = [];

  List instructionCollection = [];
  List listinstruction = [];

  num grandtotal = 0;

  double totalReturnToCustomer = 0.0;
  double restPayment = 0.0;

  String categoryid = "";

  String selectedCartProductName = '',
      selectedCartProductType = '',
      selectedCartProductPrice = '0',
      selectedCartProductId = '';

  Future<void> addNewTable() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('tablesraw').get();
    int currentCount = snapshot.size;
    String tableId = (currentCount + 1).toString(); // Generate new table ID

    await FirebaseFirestore.instance.collection('tablesraw').doc(tableId).set(
      {
        'status': 'vacant',
        'discount': '0',
        'customer_name': rawnameController.text,
        'items': '0',
        'amount': '0',
        'time': '00:00',
        'table_id': tableId, // Set table_id as the document ID
        'kot_done': 'false',
        'bill_done': 'false',
        'payment_done': 'false',
        'email': '',
        'number': '',
        'gender': '',
        'address': '',
        'order_id': '',
        'instructions': '',
      },
    );
    fetchtables();
    setState(() {
      rawnameController.clear();
    });
  }

  Future<void> addNewTableProduct(
      String id, DocumentSnapshot documentSnapshot) async {
    try {
      var docRef = FirebaseFirestore.instance
          .collection('tablesraw')
          .doc(id)
          .collection('productraw')
          .doc(documentSnapshot.id);
      var doc = await docRef.get();

      FirebaseFirestore.instance
          .collection('tablesraw')
          .doc(id)
          .collection('productraw')
          .get()
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
          } else {
            FirebaseFirestore.instance.collection('tablesraw').doc(id).update(
              {
                'status': 'occupied',
                'time': DateFormat('MMM d, y hh:mm a').format(DateTime.now())
              },
            );
          }
        },
      );

      if (doc.exists) {
        String basePrice = documentSnapshot['product_price'];
        String totalPrice = doc.get('total_price');
        String total = "${int.parse(totalPrice) + int.parse(basePrice)}";
        String quantity = doc.get('quantity');
        await FirebaseFirestore.instance
            .collection('tablesraw')
            .doc(id)
            .collection('productraw')
            .doc(documentSnapshot.id)
            .update(
          {
            'total_price': total,
            'quantity': '${int.parse(quantity) + 1}',
          },
        );
      } else {
        await FirebaseFirestore.instance
            .collection('tablesraw')
            .doc(id)
            .collection('productraw')
            .doc(documentSnapshot.id)
            .set(
          {
            'product_name': documentSnapshot['product_name'],
            'categery': documentSnapshot['categery'],
            'product_id': documentSnapshot['product_id'],
            'product_price': documentSnapshot['product_price'],
            'total_price': documentSnapshot['product_price'],
            'product_type': documentSnapshot['product_type'],
            'quantity': '1',
          },
        );
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future getCustomerDetails() async {
    log('tables selected is $_tableSelected');
    await FirebaseFirestore.instance
        .collection('tablesraw')
        .doc(_tableSelected)
        .get()
        .then(
      (value) {
        setState(() {
          nameController.text = value.get('customer_name');
          emailController.text = value.get('email');
          numberController.text = value.get('number');
          addressController.text = value.get('address');
          genderType = value.get('gender');
        });
      },
    );
  }

  Future getInstructionDetails() async {
    log('tables selected is $_tableSelected');
    await FirebaseFirestore.instance
        .collection('tablesraw')
        .doc(_tableSelected)
        .get()
        .then(
      (value) {
        setState(() {
          instructionsController.text = value.get('instructions');
          if (instructionsController.text.isNotEmpty) {
            instructionCollection = instructionsController.text.split(',');
          }
        });
      },
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> MinusNewTableProduct(
      String id, DocumentSnapshot documentSnapshot) async {
    try {
      var docRef = FirebaseFirestore.instance
          .collection('tablesraw')
          .doc(id)
          .collection('productraw')
          .doc(documentSnapshot.id);
      var doc = await docRef.get();

      if (doc.exists) {
        String basePrice = documentSnapshot['product_price'];
        String totalPrice = doc.get('total_price');
        String total = "${int.parse(totalPrice) - int.parse(basePrice)}";
        String quantity = doc.get('quantity');
        if (int.parse(quantity) > 1) {
          await FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(id)
              .collection('productraw')
              .doc(documentSnapshot.id)
              .update(
            {
              'total_price': total,
              'quantity': '${int.parse(quantity) - 1}',
            },
          );
        } else {
          deleteTableProduct(id, documentSnapshot);
        }
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> deleteTableProduct(String id, documentSnapshot) async {
    try {
      await FirebaseFirestore.instance
          .collection('tablesraw')
          .doc(id)
          .collection('productraw')
          .doc(documentSnapshot.id)
          .delete();
      print('Product deleted successfully');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future insertOrderbilling(
    productNames,
    categery,
    productid,
    productPrice,
    grandtotal,
    productType,
    quantitytype,
    discount,
    itemcount,
    id,
    paymenttype,
    userId,
    buttonType,
    instruction,
    kotDone,
    discountAmount,
  ) async {
    List v1 = [];
    List v2 = [];
    List v3 = [];
    String newProductString = '';
    v1 = productNames;
    v2 = productType;
    for (var i = 0; i < v1.length; i++) {
      v3.add("${v1[i]} ${v2[i]}");
    }
    newProductString = v3.join(', ');
    String apiurl =
        "http://shreeumeshsons.com/ankit/admin_api/insert_orders_raw.php?key=$securityKey&user_id=$userId&products_name=$newProductString&order_ammount=${productPrice.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&discount=$discount&total_ammount=$grandtotal&payment_type=$paymenttype&product_quantity=${quantitytype.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&product_quantity_type=${productType.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}&discount_amount=$discountAmount";
    try {
      print('place order $apiurl');
      final response = await http.get(
        Uri.parse(apiurl),
      );
      String inserted_id = '';
      inserted_id = jsonDecode(json.encode(response.body));
      log('order id is $inserted_id');

      if (inserted_id is int) {
        FirebaseFirestore.instance
            .collection('tablesraw')
            .doc(_tableSelected)
            .update(
          {
            'order_id': inserted_id,
          },
        );

        updateBillStatus(securityKey, response.body, '3');
      }
    } on Exception catch (e) {
      log('exception is $e');
    }
    log("Insert order is $apiurl");
  }

  List updateBillingStatus = [];
  List listtables = [];
  List listcategories = [];

  Future updateBillStatus(key, orderId, orderStatus) async {
    String apiurl =
        "http://shreeumeshsons.com/ankit/admin_api/update_raw_status.php?key=$key&&order_id=$orderId&&bill_clicked=$orderStatus";

    try {
      var response = await http.get(Uri.parse(apiurl));
      if (response.statusCode == 200) {
        Map<String, dynamic> idData = json.decode(response.body);

        setState(() {
          updateBillingStatus = idData["data"];
          getBillPrintingData(securityKey);
        });
        log("Update your status $orderId $updateBillingStatus");
      } else {
        log("Update your Not update your status");
      }
    } on Exception catch (e) {
      log('Update your exception is $e');
    }
  }

  void generateBillPdf(
    String name,
    qty,
    qtyType,
    orderNumber,
    punchDate,
    rate,
    amt,
    subTotal,
    grandTotal,
    packagingCharges,
    discount,
    tax,
    qtyTotal,
    paymentType,
    billType,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Order No.',
                    style: pw.TextStyle(
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(width: 2),
                  pw.Text(
                    orderNumber,
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "Shri Umesh Son's Healthy Foods",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 8,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Text(
                  "shop no. 29, Hig market, Metro Rd, near Pani Tanki, Jamalpur, Ludhiana, Punjab 141010",
                  style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold,
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                "Contact No:- 09988259798",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 6,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                punchDate,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              pw.Divider(
                borderStyle: pw.BorderStyle.solid,
                thickness: 0.5,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Align(
                    child: pw.SizedBox(
                      width: billType == 'billing' ? 85 : 80,
                      child: pw.Text(
                        "Item",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Align(
                    child: pw.Row(
                      children: [
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            "Rate",
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            "Qty",
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Text(
                          "Amt",
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Divider(
                borderStyle: pw.BorderStyle.solid,
                thickness: 0.5,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Row(
                      children: [
                        billType == 'billing'
                            ? pw.Align(
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Row(
                                  children: [
                                    pw.SizedBox(
                                      width: 77,
                                      child: pw.Text(
                                        name.replaceAll('\n ', '\n'),
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(width: 8),
                                  ],
                                ),
                              )
                            : pw.Row(
                                children: [
                                  pw.Text(
                                    name,
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(width: 2),
                                  pw.Text(
                                    "$qtyType",
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Row(
                      children: [
                        pw.SizedBox(
                          child: pw.Text(
                            rate,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(
                          child: pw.Text(
                            qty,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Text(
                          amt,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Divider(
                borderStyle: pw.BorderStyle.solid,
                thickness: 0.5,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Total Quantity',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      qtyTotal,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Sub Total',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      subTotal,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Discount',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      discount,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              paymentType.contains('billing') || paymentType.contains('Billing')
                  ? pw.SizedBox()
                  : pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Packaging Charges',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            packagingCharges,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Tax',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      tax,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Divider(
                borderStyle: pw.BorderStyle.solid,
                thickness: 0.5,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'Grand Total',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      grandTotal,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Divider(
                borderStyle: pw.BorderStyle.solid,
                thickness: 0.5,
              ),
              pw.Text(
                'Thank You! Visit Again',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
    try {
      final bytes = await pdf.save();
      await Printing.sharePdf(bytes: bytes, filename: '$orderNumber.pdf');
    } catch (e) {
      print(e.toString());
    }
  }

  List billPrintData = [];

  Future getBillPrintingData(securityKey) async {
    String apiurl =
        "http://shreeumeshsons.com/ankit/admin_api/billing_status_raw.php?key=$securityKey";
    try {
      var response = await http.get(
        Uri.parse(apiurl),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> idData = json.decode(response.body);
        setState(
          () {
            billPrintData = idData["data"];

            for (var index = 0; index < billPrintData.length; index++) {
              updateBillStatus(
                  securityKey, billPrintData[index]['order_id'], '2');

              List<int> numbersList = billPrintData[index]['product_quantity']
                  .toString()
                  .split(',')
                  .map((str) => int.parse(str.trim()))
                  .toList();
              int qtytotal = numbersList.reduce((a, b) => a + b);
              List<int> qtyList = billPrintData[index]['product_quantity']
                  .toString()
                  .split(',')
                  .map((str) => int.parse(str.trim()))
                  .toList();
              List<int> priceList = billPrintData[index]['order_ammount']
                  .toString()
                  .split(',')
                  .map((str) => int.parse(str.trim()))
                  .toList();

              List<int> productList = List.generate(
                  qtyList.length, (index) => qtyList[index] * priceList[index]);
              String resultString = productList.join(',');

              generateBillPdf(
                billPrintData[index]['products_name'].replaceAll(',', '\n'),
                billPrintData[index]['product_quantity'].replaceAll(',', '\n'),
                billPrintData[index]['product_quantity_type']
                    .replaceAll(',', '\n'),
                billPrintData[index]['order_id'],
                "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                billPrintData[index]['order_ammount'].replaceAll(',', '\n'),
                resultString.replaceAll(',', '\n'),
                (int.parse(billPrintData[index]['total_ammount']) -
                        int.parse(billPrintData[index]['packging_charges']) -
                        int.parse(billPrintData[index]['taxes']) +
                        int.parse(billPrintData[index]['discount']))
                    .toString(),
                billPrintData[index]['total_ammount'],
                billPrintData[index]['packging_charges'],
                billPrintData[index]['discount'],
                billPrintData[index]['taxes'],
                qtytotal.toString(),
                billPrintData[index]['payment_type'],
                'online',
              );
            }
          },
        );
      } else {
        log("Not found any data");
      }
    } on Exception catch (e) {
      log('exception is $e');
    }
  }

  Future<void> fetchinstruction() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('instructions').get();
    setState(() {
      listinstruction = snapshot.docs;
    });
  }

  Future<void> fetchtables() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('tablesraw').get();
    setState(() {
      listtables = snapshot.docs;
    });
  }

  Future<void> fetchcategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      listcategories = snapshot.docs;
    });
  }

  @override
  void initState() {
    fetchinstruction();
    fetchtables();

    fetchcategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: StreamBuilder(
          stream: Stream.periodic(
            Duration(seconds: 1),
          ).asyncMap(
            (event) => getBillPrintingData(securityKey),
          ),
          builder: (context, snapshot) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 10, left: 10, right: 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 121,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(left: 5),
                          child: showProducts
                              ? billingProducts()
                              : showPayments
                                  ? billingCart(context)
                                  : billingTables(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  billingInstructions() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 700,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(05),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      maxLines: 6,
                      controller: instructionsController,
                      decoration: InputDecoration(
                        prefixStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        hintText: 'Add Instructions Here',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 18,
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 250,
                    width: 700,
                    child: Center(
                      child: ResponsiveGridList(
                        minItemWidth: 150,
                        minItemsPerRow: 5,
                        children:
                            List.generate(listinstruction.length, (index) {
                          DocumentSnapshot docSnapshot = listinstruction[index];
                          return InkWell(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                if (instructionCollection
                                    .contains(docSnapshot['instruction'])) {
                                  instructionCollection
                                      .remove(docSnapshot['instruction']);
                                  instructionsController.text =
                                      instructionCollection
                                          .toString()
                                          .replaceAll('[', '')
                                          .replaceAll(']', '')
                                          .replaceAll(', ', ',');
                                } else {
                                  instructionCollection
                                      .add(docSnapshot['instruction']);
                                  instructionsController.text =
                                      instructionCollection
                                          .toString()
                                          .replaceAll('[', '')
                                          .replaceAll(']', '')
                                          .replaceAll(', ', ',');
                                }
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  instructionCollection
                                          .contains(docSnapshot['instruction'])
                                      ? Icons.done_all_rounded
                                      : Icons.add_rounded,
                                  color: greenLightShadeColor,
                                ),
                                SizedBox(width: 5),
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    docSnapshot['instruction'],
                                    style: TextStyle(
                                      color: greenLightShadeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        padding: EdgeInsets.all(20),
                        color: mainColor,
                        onPressed: () {
                          setState(() {
                            instructionsController.clear();
                            instructionCollection.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      MaterialButton(
                        padding: EdgeInsets.all(20),
                        color: greenSelectedColor,
                        onPressed: () {
                          setState(() {
                            instructionsController.clear();
                            instructionCollection.clear();
                          });
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      MaterialButton(
                        padding: EdgeInsets.all(20),
                        color: greenShadeColor,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('tablesraw')
                              .doc(_tableSelected)
                              .update(
                            {
                              'instructions': instructionsController.text,
                            },
                          ).whenComplete(() {
                            setState(() {
                              FirebaseFirestore.instance
                                  .collection('tablesraw')
                                  .doc(_tableSelected)
                                  .get()
                                  .then(
                                    (value) {},
                                  );
                              instructionsController.clear();
                              instructionCollection.clear();
                              Navigator.pop(context);
                            });
                          });
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  billingCustomers() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: displayWidth(context) / 5,
                height: 500,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    billingContactTextFieldWidget(
                      numberController,
                      'Contact Number',
                      'Enter Contact Number',
                    ),
                    billingContactTextFieldWidget(
                      nameController,
                      'Full Name',
                      'Enter Customer Full Name',
                    ),
                    billingContactTextFieldWidget(
                      emailController,
                      'Email',
                      'Enter Customer Email',
                    ),
                    billingContactTextFieldWidget(
                      addressController,
                      'Address',
                      'Enter Customer Full Address',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () => setState(() => genderType = 'Male'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: genderType == 'Male'
                                    ? greenShadeColor
                                    : whiteColor,
                                border: Border.all(
                                  color: genderType == 'Male'
                                      ? greenShadeColor
                                      : Colors.greenAccent,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Male',
                                style: TextStyle(
                                  color: genderType == 'Male'
                                      ? whiteColor
                                      : Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => setState(() => genderType = 'Female'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: genderType == 'Female'
                                    ? greenShadeColor
                                    : whiteColor,
                                border: Border.all(
                                  color: genderType == 'Female'
                                      ? greenShadeColor
                                      : Colors.greenAccent,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Female',
                                style: TextStyle(
                                  color: genderType == 'Female'
                                      ? whiteColor
                                      : Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  nameController.clear();
                                  emailController.clear();
                                  numberController.clear();
                                  addressController.clear();
                                },
                              );
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mainShadeColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('tablesraw')
                                  .doc(_tableSelected)
                                  .update(
                                {
                                  'customer_name': nameController.text,
                                  'email': emailController.text,
                                  'gender': genderType,
                                  'number': numberController.text,
                                  'address': addressController.text,
                                },
                              ).whenComplete(() {
                                setState(
                                  () {
                                    nameController.clear();
                                    emailController.clear();
                                    numberController.clear();
                                    addressController.clear();
                                  },
                                );
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: greenShadeColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  billingContactTextFieldWidget(controller, label, hintText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(05),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          maxLines: label == 'Address' ? 5 : 1,
          controller: controller,
          decoration: InputDecoration(
            prefix: label == 'Contact Number'
                ? const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text('+91'),
                  )
                : null,
            prefixStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              fontSize: 12,
            ),
            label: Text(label),
            floatingLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: greenShadeColor,
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.3),
              fontSize: 13,
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  billingTables() {
    return Column(
      children: [
        InkWell(
          onTap: () => showDialog(
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
                      controller: rawnameController,
                      decoration: InputDecoration(
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 247, 125, 125)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addNewTable();

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Create',
                      style:
                          TextStyle(color: Color.fromARGB(255, 247, 125, 125)),
                    ),
                  ),
                ],
              );
            },
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.plus,
                    color: whiteColor,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Add New Bill",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height - 183,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: listtables.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot documentSnapshot = listtables[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _tableSelected = documentSnapshot.id.toString();
                        _tableHover = '';
                        showProducts = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.greenAccent, // Border color
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  documentSnapshot['customer_name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  onPressed: () {},
                                  child: FaIcon(
                                    FontAwesomeIcons.ellipsisVertical,
                                    color: _tableSelected == documentSnapshot.id
                                        ? whiteColor.withOpacity(0.8)
                                        : Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: documentSnapshot['status'] == 'vacant'
                                  ? Colors.blueGrey[100]!
                                  : documentSnapshot['status'] == 'occupied'
                                      ? Colors.purple
                                      : documentSnapshot['status'] ==
                                              'bill-printed'
                                          ? Colors.amber
                                          : Colors.greenAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(8),
                                bottomRight: const Radius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    documentSnapshot['time'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  billingProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => setState(() => showCategories = !showCategories),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 150,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 90, 78),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: whiteColor,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            showProducts = false;
                            showCustomer = false;
                            showPayments = false;
                            addInstructions = false;
                            _tableSelected = '0';
                          },
                        );
                      },
                    ),
                    billingHeaderTextWidget('Categories'),
                    FaIcon(
                      showCategories
                          ? FontAwesomeIcons.circleChevronUp
                          : FontAwesomeIcons.circleChevronDown,
                      color: whiteColor,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 45,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search..',
                          contentPadding: EdgeInsets.all(04),
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color.fromARGB(255, 155, 153, 153)
                                .withOpacity(0.8),
                            size: 16,
                          ),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = searchController.text.toLowerCase();
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            search = searchController.text.toLowerCase();
                          });
                        },
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        !showCategories
            ? const SizedBox()
            : SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listcategories.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot productDocumentSnapshot =
                        listcategories[index];

                    categery = productDocumentSnapshot['categery_name'];

                    return Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index.toString();

                            if (productDocumentSnapshot['categery_name'] !=
                                "All") {
                              categoryid =
                                  productDocumentSnapshot['categery_id'];
                            } else {
                              categoryid = "";
                            }
                          });
                        },
                        onHover: (value) {
                          if (value) {
                            setState(() {
                              selectedCategoryIndex = index.toString();
                            });
                          } else {
                            setState(() {
                              selectedCategoryIndex = '';
                            });
                          }
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: index.toString() == selectedCategoryIndex
                                ? Colors.greenAccent
                                : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: index.toString() == selectedCategoryIndex
                                    ? Colors.greenAccent.withOpacity(0.9)
                                    : Colors.greenAccent.withOpacity(0.2),
                                blurRadius:
                                    index.toString() == selectedCategoryIndex
                                        ? 20
                                        : 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            productDocumentSnapshot['categery_name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontSize: 8,
                              color: index.toString() == selectedCategoryIndex
                                  ? whiteColor
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        const SizedBox(height: 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: IconButton(
                    iconSize: 30,
                    splashColor: Colors.red,
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                // _buildTextAndImageList(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: MediaQuery.of(context).size.height - 259,
                    child: StreamBuilder(
                      stream: categoryid.isEmpty
                          ? FirebaseFirestore.instance
                              .collection('raw_billing_product')
                              .where('product_price', isNotEqualTo: "0")
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('raw_billing_product')
                              .where('categery', isEqualTo: categoryid)
                              .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: streamSnapshot.data!.docs
                                .where((element) =>
                                    element['product_name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(search) ||
                                    element['product_type']
                                        .toString()
                                        .toLowerCase()
                                        .contains(search))
                                .length,
                            itemBuilder: (context, index) {
                              final filteredData =
                                  streamSnapshot.data!.docs.where(
                                (element) =>
                                    element['product_name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(search) ||
                                    element['product_type']
                                        .toString()
                                        .toLowerCase()
                                        .contains(search),
                              );
                              final documentSnapshot =
                                  filteredData.elementAt(index);

                              return InkWell(
                                onTap: () {
                                  addNewTableProduct(
                                    _tableSelected.toString(),
                                    documentSnapshot,
                                  );
                                },
                                onHover: (value) {
                                  if (value) {
                                    setState(() {
                                      _productHover = index.toString();
                                    });
                                  } else {
                                    setState(() {
                                      _productHover = '';
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 3, right: 5, top: 2),
                                  child: Container(
                                    // Increase the size of the Container to make the InkWell tappable
                                    height: 90,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: _productHover == index.toString()
                                            ? 2
                                            : 1,
                                        color: _productHover == index.toString()
                                            ? Colors.greenAccent
                                            : Colors.grey, // Border color
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            imagebool
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 64,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    top: 5),
                                                            child: Text(
                                                              documentSnapshot[
                                                                  'product_name'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8),
                                                                  ),
                                                                  color: Colors
                                                                      .greenAccent),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8)), // Rounded corners for the image
                                                          child: Image.network(
                                                            documentSnapshot[
                                                                'product_image'],
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height:
                                                                64, // Adjust height as needed
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8),
                                                                  ),
                                                                  color: Colors
                                                                      .greenAccent),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  billingCart(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  billingPayments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    showCustomer = false;
                    showProducts = false;
                    showPayments = false;
                    addInstructions = false;
                    _tableSelected = '0';
                    addnoteController.clear();
                    customerPaidController.clear();
                    selectedpaymentType = '';
                    selectedSubpaymentType = '';
                    totalReturnToCustomer = 0.0;
                  });
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: whiteColor,
                ),
              ),
              Text(
                'Payments',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'cash';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'cash'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'cash'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Cash',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'card';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'card'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'card'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Card',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'Pending';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'Pending'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'Pending'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Pending',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedpaymentType = 'company';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedpaymentType == 'company'
                                  ? greenLightShadeColor
                                  : whiteColor,
                              border: Border.all(
                                color: selectedpaymentType == 'company'
                                    ? whiteColor
                                    : Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Company',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Total Bill",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(width: 80),
                        Text(
                          "$rupeeSign${grandtotal.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                            fontSize: 20,
                            color: greenLightShadeColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              selectedpaymentType == 'Pending'
                  ? Container()
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How much customer paid by $selectedpaymentType?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.4),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: customerPaidController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter the amount customer paid',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      var customerPaid = double.parse(
                                          customerPaidController.text);
                                      totalReturnToCustomer =
                                          customerPaid - grandtotal;
                                    });
                                  } else {
                                    setState(() {
                                      totalReturnToCustomer = 0.0;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            totalReturnToCustomer.toString().contains('-')
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'You have to collect ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '$rupeeSign${totalReturnToCustomer.toString().replaceAll('-', '')} ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                            fontSize: 19,
                                            color: greenLightShadeColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'from the customer',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : customerPaidController.text.isEmpty
                                    ? RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'You have to collect ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontSize: 17,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '$rupeeSign$grandtotal ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontSize: 19,
                                                color: greenLightShadeColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'from the customer',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'You have to return ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontSize: 17,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '$rupeeSign$totalReturnToCustomer ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontSize: 19,
                                                color: mainColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'to the customer',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                          ],
                        ),
                        totalReturnToCustomer.toString().contains('-')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 40),
                                  Text(
                                    'Collect the remaining amount by',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      selectedpaymentType == 'cash'
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedSubpaymentType =
                                                      'cash';
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: selectedSubpaymentType ==
                                                                'cash'
                                                            ? greenLightShadeColor
                                                            : whiteColor,
                                                        border: Border.all(
                                                          color: selectedSubpaymentType ==
                                                                  'cash'
                                                              ? whiteColor
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.1),
                                                          width: 2,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      'Cash',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                          width: selectedpaymentType == 'cash'
                                              ? 0
                                              : 20),
                                      selectedpaymentType == 'card'
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedSubpaymentType =
                                                      'card';
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: selectedSubpaymentType ==
                                                                'card'
                                                            ? greenLightShadeColor
                                                            : whiteColor,
                                                        border: Border.all(
                                                          color: selectedSubpaymentType ==
                                                                  'card'
                                                              ? whiteColor
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.1),
                                                          width: 2,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      'Card',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                          width: selectedpaymentType == 'card'
                                              ? 0
                                              : 20),
                                      selectedpaymentType == 'Pending'
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedSubpaymentType =
                                                      'Pending';
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: selectedSubpaymentType ==
                                                                'Pending'
                                                            ? greenLightShadeColor
                                                            : whiteColor,
                                                        border: Border.all(
                                                          color: selectedSubpaymentType ==
                                                                  'Pending'
                                                              ? whiteColor
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.1),
                                                          width: 2,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      'Pending',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                          width:
                                              selectedpaymentType == 'Pending'
                                                  ? 0
                                                  : 20),
                                      selectedpaymentType == 'company'
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedSubpaymentType =
                                                      'company';
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: selectedSubpaymentType ==
                                                                'company'
                                                            ? greenLightShadeColor
                                                            : whiteColor,
                                                        border: Border.all(
                                                          color: selectedSubpaymentType ==
                                                                  'company'
                                                              ? whiteColor
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.1),
                                                          width: 2,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      'Company',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 40),
                      ],
                    ),
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  maxLines: 5,
                  controller: addnoteController,
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      fontSize: 12,
                    ),
                    label: Text('Add Note'),
                    floatingLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: greenShadeColor,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    hintText: 'Enter any aditional information here',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 13,
                    ),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.all(20),
                    color: greenSelectedColor,
                    onPressed: () {
                      setState(() {
                        addnoteController.clear();
                        customerPaidController.clear();
                        selectedpaymentType = '';
                        selectedSubpaymentType = '';
                        totalReturnToCustomer = 0.0;
                      });
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tablesraw')
                        .where('table_id', isEqualTo: _tableSelected)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (var v = 0; v < snapshot.data!.docs.length;) {
                          DocumentSnapshot orderSnapshot =
                              snapshot.data!.docs[v];
                          return MaterialButton(
                            padding: EdgeInsets.all(20),
                            color: greenShadeColor,
                            onPressed: () {
                              log('table order id is ${orderSnapshot['order_id']}');
                              if (totalReturnToCustomer
                                  .toString()
                                  .contains('-')) {
                                if (selectedSubpaymentType.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection('tablesraw')
                                      .doc(_tableSelected)
                                      .update(
                                    {
                                      'status': 'vacant',
                                      'customer_name': 'New Customer',
                                      'bill_done': 'false',
                                      'payment_done': 'false',
                                      'kot_done': 'false',
                                      'time': '00:00',
                                      'address': '',
                                      'instructions': '',
                                      'order_id': '',
                                      'number': '',
                                      'email': '',
                                      'gender': '',
                                      'amount': '0',
                                    },
                                  );
                                  FirebaseFirestore.instance
                                      .collection('tablesraw')
                                      .doc(_tableSelected)
                                      .collection('productraw')
                                      .get()
                                      .then((snapshot) {
                                    for (DocumentSnapshot doc
                                        in snapshot.docs) {
                                      doc.reference.delete();
                                    }
                                  }).then((_) {
                                    FirebaseFirestore.instance
                                        .collection('tablesraw')
                                        .doc(_tableSelected)
                                        .collection('productraw')
                                        .doc()
                                        .delete();
                                  });
                                  FirebaseFirestore.instance
                                      .collection('tablesraw')
                                      .doc(_tableSelected)
                                      .collection('orderraw')
                                      .get()
                                      .then((snapshot) {
                                    for (DocumentSnapshot doc
                                        in snapshot.docs) {
                                      doc.reference.delete();
                                    }
                                  }).then((_) {
                                    FirebaseFirestore.instance
                                        .collection('tablesraw')
                                        .doc(_tableSelected)
                                        .collection('orderraw')
                                        .doc()
                                        .delete();
                                  });
                                  setState(() {
                                    showProducts = false;
                                    _tableSelected = "0";
                                    discountbutton = true;
                                    showPayments = false;
                                    showCustomer = false;
                                    discount = 0;
                                  });
                                } else {}
                              } else {
                                FirebaseFirestore.instance
                                    .collection('tablesraw')
                                    .doc(_tableSelected)
                                    .update(
                                  {
                                    'status': 'vacant',
                                    'customer_name': 'New Customer',
                                    'bill_done': 'false',
                                    'payment_done': 'false',
                                    'kot_done': 'false',
                                    'time': '00:00',
                                    'address': '',
                                    'instructions': '',
                                    'order_id': '',
                                    'number': '',
                                    'email': '',
                                    'gender': '',
                                    'amount': '0',
                                  },
                                );
                                FirebaseFirestore.instance
                                    .collection('tablesraw')
                                    .doc(_tableSelected)
                                    .collection('productraw')
                                    .get()
                                    .then((snapshot) {
                                  for (DocumentSnapshot doc in snapshot.docs) {
                                    doc.reference.delete();
                                  }
                                }).then((_) {
                                  FirebaseFirestore.instance
                                      .collection('tablesraw')
                                      .doc(_tableSelected)
                                      .collection('productraw')
                                      .doc()
                                      .delete();
                                });
                                FirebaseFirestore.instance
                                    .collection('tablesraw')
                                    .doc(_tableSelected)
                                    .collection('orderraw')
                                    .get()
                                    .then((snapshot) {
                                  for (DocumentSnapshot doc in snapshot.docs) {
                                    doc.reference.delete();
                                  }
                                }).then((_) {
                                  FirebaseFirestore.instance
                                      .collection('tablesraw')
                                      .doc(_tableSelected)
                                      .collection('orderraw')
                                      .doc()
                                      .delete();
                                });
                                setState(() {
                                  showProducts = false;
                                  _tableSelected = "0";
                                  discountbutton = true;
                                  showPayments = false;
                                  showCustomer = false;
                                  discount = 0;
                                  addnoteController.clear();
                                  customerPaidController.clear();
                                  selectedpaymentType = '';
                                  selectedSubpaymentType = '';
                                  totalReturnToCustomer = 0.0;
                                });
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  billingCart(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 258,
      width: MediaQuery.of(context).size.width - 107,
      decoration: BoxDecoration(
          // color: _tableSelected == '0' ? Colors.black : whiteColor,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.green.withOpacity(0.2),
          //     blurRadius: 10,
          //     spreadRadius: 1,
          //   ),
          // ],
          ),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.05),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Expanded(
                  child: InkWell(
                    onTap: () => setState(() => billType = 'Eat'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: billType == "Eat" ? mainColor : whiteColor,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Center(
                        child: billingHeaderWidget(
                          'Product Cart',
                          billType,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: displayHeight(context) / 2.35,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('tablesraw')
                          .doc(_tableSelected)
                          .collection('productraw')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> productSnapshot) {
                        if (productSnapshot.hasData) {
                          productNames.clear();
                          productPrice.clear();
                          productType.clear();
                          quantitytype.clear();
                          return ListView.builder(
                            itemCount: productSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot productDocumentSnapshot =
                                  productSnapshot.data!.docs[index];
                              productNames.add(
                                  productDocumentSnapshot['product_name']
                                      .toString());
                              productPrice.add(
                                  productDocumentSnapshot['product_price']
                                      .toString());
                              productType.add(
                                  productDocumentSnapshot['product_type']
                                      .toString());

                              quantitytype
                                  .add(productDocumentSnapshot['quantity']);

                              log("ljiksdldfsljksdf $productType");

                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    235,
                                    246,
                                    254,
                                  ),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.05),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    " ${productDocumentSnapshot['product_name']} ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    " ${productDocumentSnapshot['product_type']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              child: Text(
                                                '$rupeeSign${productDocumentSnapshot['product_price']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            MaterialButton(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              minWidth: 0,
                                              height: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              color: Colors.greenAccent,
                                              onPressed: () {
                                                MinusNewTableProduct(
                                                    _tableSelected,
                                                    productDocumentSnapshot);
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.minus,
                                                size: 8,
                                                color: whiteColor,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: 30,
                                              height: 30,
                                              child: TextFormField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      3),
                                                ],
                                                controller:
                                                    TextEditingController(
                                                  text: productDocumentSnapshot[
                                                      'quantity'],
                                                ),
                                                focusNode: FocusNode(),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            MaterialButton(
                                              padding: const EdgeInsets.all(5),
                                              minWidth: 4,
                                              height: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              color: Colors.greenAccent,
                                              onPressed: () {
                                                addNewTableProduct(
                                                    _tableSelected,
                                                    productDocumentSnapshot);
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.plus,
                                                size: 10,
                                                color: whiteColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                              child: Text(
                                                '$rupeeSign${productDocumentSnapshot['total_price']}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            MaterialButton(
                                              padding: const EdgeInsets.all(5),
                                              minWidth: 4,
                                              height: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              color: mainColor,
                                              onPressed: () {
                                                deleteTableProduct(
                                                    _tableSelected,
                                                    productDocumentSnapshot);
                                              },
                                              child: FaIcon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            ),
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
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tablesraw')
                    .doc(_tableSelected)
                    .collection('productraw')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    var totalprice = 0;
                    for (var i = 0; i < snapshot.data!.docs.length; i++) {
                      totalprice +=
                          int.parse(snapshot.data!.docs[i]['total_price']);
                    }

                    var demoTotal =
                        discountstatus ? discount : totalprice * discount / 100;

                    totalDiscount = demoTotal.toString();

                    log('total discount is $demoTotal');

                    totalTax = totalprice * tax / 100;
                    grandtotal = discountstatus
                        ? (totalprice - discount + totalTax)
                        : (totalprice -
                            (totalprice * discount / 100) +
                            totalTax);
                    itemcount = "${snapshot.data!.docs.length}";

                    FirebaseFirestore.instance
                        .collection('tablesraw')
                        .doc(_tableSelected)
                        .update(
                      {
                        'amount': '$grandtotal',
                        'total_tax': '$totalTax',
                      },
                    );

                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SizedBox(
                                    child: Text(
                                      'Item Count : ${snapshot.data!.docs.length}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        'Sub Total :  ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.5),
                                          letterSpacing: 0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: SizedBox(
                                        child: Text(
                                          '$rupeeSign $totalprice',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: greenShadeColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 10,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Grand Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: whiteColor,
                                      fontSize: 14,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  Text(
                                    "$rupeeSign${grandtotal.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                      color: whiteColor,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tablesraw')
                .where('table_id', isEqualTo: _tableSelected)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (var v = 0; v < snapshot.data!.docs.length;) {
                  DocumentSnapshot documentSnapshot = snapshot.data!.docs[v];
                  // Adjusting for a Row inside a fixed width Container.
                  return Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: SizedBox(
                      width: 260, // Fixed width for the Row
                      child: Row(
                        children: [
                          // Assuming clearButton, paymentsButton, kotPrintDone, and printBillButton are widget builder functions.
                          if (documentSnapshot['kot_done'] == 'true' &&
                              documentSnapshot['bill_done'] == 'false') ...[
                            clearButton(context, documentSnapshot),
                            paymentsButton(context, documentSnapshot),
                            kotPrintDone(context, documentSnapshot),
                            printBillButton(context, documentSnapshot),
                          ] else if (documentSnapshot['bill_done'] == 'true' &&
                              documentSnapshot['kot_done'] == 'true') ...[
                            clearButton(context, documentSnapshot),
                            kotPrintDone(context, documentSnapshot),
                            printBillButton(context, documentSnapshot),
                            paymentsButton(context, documentSnapshot),
                          ] else ...[
                            //   clearButton(context, documentSnapshot),
                            //   SizedBox(
                            //     width: 2,
                            //   ),
                            //   paymentsButton(context, documentSnapshot),
                            SizedBox(
                              width: 2,
                            ),
                            printBillButton(context, documentSnapshot),
                            SizedBox(
                              width: 2,
                            ),
                            // kotPrintDone(context, documentSnapshot),
                          ],
                        ],
                      ),
                    ),
                  );
                }
              }
              // ignore: avoid_unnecessary_containers
              return Container(
                child: Text("data"),
              ); // Fallback for no data.
            },
          ),
        ],
      ),
    );
  }

  billingPreview(BuildContext context, documentSnapshot) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: Container(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bill Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      minWidth: 0,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Shri Umesh Son's Healthy Foods",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 500,
                    child: Text(
                      "shop no. 29, Hig market, Metro Rd, near Pani Tanki, Jamalpur, Ludhiana, Punjab 141010",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "09988259798",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tablesraw')
                        .where('table_id', isEqualTo: _tableSelected)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (var v = 0; v < snapshot.data!.docs.length;) {
                          return Text(
                            snapshot.data!.docs[v]['time'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SizedBox(
                        child: Text(
                          "Item",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Rate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Qty",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "Amt",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tablesraw')
                        .doc(_tableSelected)
                        .collection('productraw')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        for (var i = 0; i < snapshot.data!.docs.length; i++) {
                          cloudTotalQuantity =
                              int.parse(snapshot.data!.docs[i]['quantity']);
                          cloudTotal += double.parse(
                              snapshot.data!.docs[i]['total_price']);
                          cloudCgst = cloudTotal *
                              double.parse(snapshot.data!.docs[i]['quantity']) /
                              100;
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: 50 *
                                  double.parse(
                                    snapshot.data!.docs.length.toString(),
                                  ),
                              width: 500,
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot prodSnapshot =
                                      snapshot.data!.docs[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 3,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${prodSnapshot['product_name']}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            "${prodSnapshot['product_price']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            "${prodSnapshot['quantity']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: Text(
                                            "${prodSnapshot['total_price']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 5),
                            //   child: Divider(
                            //     thickness: 1,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 10,
                            //     vertical: 5,
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         "Total Quantity",
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //         ),
                            //         textAlign: TextAlign.start,
                            //       ),
                            //       SizedBox(
                            //         width: 100,
                            //         child: Text(
                            //           "$cloudTotalQuantity",
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 14,
                            //           ),
                            //           textAlign: TextAlign.end,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tablesraw')
                        .where('table_id', isEqualTo: _tableSelected)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (var i = 0; i < snapshot.data!.docs.length;) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Grand Total :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "₹ ${snapshot.data!.docs[i]['amount']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth: 0,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('tablesraw')
                                .doc(_tableSelected)
                                .collection('productraw')
                                .get()
                                .then((value) {
                              if (value.size > 0) {
                                setState(() {
                                  insertOrderbilling(
                                    productNames,
                                    categery,
                                    productid,
                                    productPrice,
                                    grandtotal,
                                    productType,
                                    quantitytype,
                                    discount,
                                    itemcount,
                                    _tableSelected,
                                    paymenttype,
                                    userId,
                                    'bill done',
                                    "",
                                    '',
                                    totalDiscount.toString(),
                                  );
                                });
                              } else {
                                Text("sad");
                              }
                            });
                          },
                          child: Text(
                            'Print Pdf',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                                color: whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  changeCartProductMethod(
      context, cartProductName, cartProductId, cartProductQuantity) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      235,
                      246,
                      254,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartProductName,
                        style: TextStyle(),
                      ),
                      MaterialButton(
                        color: mainColor,
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(
                            () {
                              selectedCartProductName = '';
                              selectedCartProductType = '';
                              selectedCartProductPrice = '0';
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  width: 400,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('billing_products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot docSnapshot =
                                snapshot.data!.docs[index];
                            if (docSnapshot['product_name']
                                .toString()
                                .contains(cartProductName)) {
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Text(
                                            docSnapshot['product_name'],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: greenShadeColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              docSnapshot['product_type'],
                                              style: TextStyle(
                                                color: greenShadeColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "$rupeeSign${docSnapshot['product_price']}",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCartProductName =
                                              docSnapshot['product_name'];
                                          selectedCartProductType =
                                              docSnapshot['product_type'];
                                          selectedCartProductPrice =
                                              docSnapshot['product_price'];
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: selectedCartProductName ==
                                                    docSnapshot[
                                                        'product_name'] &&
                                                selectedCartProductType ==
                                                    docSnapshot['product_type']
                                            ? Icon(
                                                Icons.done_all_rounded,
                                                color: Colors.green,
                                              )
                                            : Text(
                                                'Select',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartProductName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    selectedCartProductType,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "$rupeeSign$selectedCartProductPrice",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(20),
                        color: Colors.green,
                        onPressed: () async {
                          var selectedCartProductTotal = 0.0;
                          setState(() {
                            selectedCartProductTotal =
                                int.parse(cartProductQuantity) *
                                    double.parse(selectedCartProductPrice);
                          });
                          await FirebaseFirestore.instance
                              .collection('tablesraw')
                              .doc(_tableSelected)
                              .collection('productraw')
                              .doc(cartProductId)
                              .update(
                            {
                              'product_type': selectedCartProductType,
                              'product_price': selectedCartProductPrice,
                              'total_price':
                                  selectedCartProductTotal.toString(),
                            },
                          );
                          setState(
                            () {
                              selectedCartProductName = '';
                              selectedCartProductType = '';
                              selectedCartProductPrice = '0';
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Update item',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  kotPrintDone(context, documentSnapshot) {
    return SizedBox(
      width: 55,
      child: MaterialButton(
        minWidth: 0,
        color: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(_tableSelected)
              .collection('productraw')
              .get()
              .then(
            (value) {
              if (value.size > 0) {
                insertOrderbilling(
                  productNames,
                  categery,
                  productid,
                  productPrice,
                  grandtotal,
                  productType,
                  quantitytype,
                  discount,
                  itemcount,
                  _tableSelected,
                  paymenttype,
                  userId,
                  'kot',
                  '',
                  '',
                  totalDiscount.toString(),
                );
              } else {
                // alertDialogWidget(
                //   context,
                //   Colors.red,
                //   'Please add any product to continue',
                // );
              }
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            documentSnapshot['kot_done'] == 'true'
                ? FaIcon(
                    Icons.done_all_rounded,
                    color: Colors.greenAccent,
                    size: 6,
                  )
                : const SizedBox(),
            Text(
              'KOT',
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  printBillButton(context, documentSnapshot) {
    return SizedBox(
      width: 245,
      child: MaterialButton(
        minWidth: 0,
        color: documentSnapshot['bill_done'] == 'true'
            ? Colors.amber
            : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          billingPreview(context, documentSnapshot);
          //   FirebaseFirestore.instance
          //       .collection('tablesraw')
          //       .doc(_tableSelected)
          //       .collection('productraw')
          //       .get()
          //       .then((value) {
          //     if (value.size > 0) {
          //       setState(() {
          //         insertOrderbilling(
          //           productNames,
          //           categery,
          //           productid,
          //           productPrice,
          //           grandtotal,
          //           productType,
          //           quantitytype,
          //           discount,
          //           itemcount,
          //           _tableSelected,
          //           paymenttype,
          //           userId,
          //           'bill done',
          //           documentSnapshot['instructions'],
          //           '',
          //           totalDiscount.toString(),
          //         );
          //         // updateBillStatus(
          //         //     securityKey, documentSnapshot['order_id'], '3');
          //       });
          //     } else {
          //       Text("sad");
          //     }
          //   });
        },
        child: Text(
          'Generate Bill',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              color: whiteColor),
        ),
      ),
    );
  }

  paymentsButton(context, documentSnapshot) {
    return SizedBox(
      width: 68,
      child: MaterialButton(
        minWidth: 0,
        color: documentSnapshot['payment_done'] == 'true'
            ? Colors.green
            : Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(_tableSelected)
              .collection('productraw')
              .get()
              .then(
            (value) {
              if (value.size > 0) {
                setState(() {
                  showPayments = true;
                  showProducts = false;
                  showCustomer = false;
                });
                if (documentSnapshot['kot_done'] == 'true' &&
                    documentSnapshot['bill_done'] == 'true') {
                  FirebaseFirestore.instance
                      .collection('tables')
                      .doc(_tableSelected)
                      .update(
                    {
                      'payment_done': 'true',
                      'status': 'payment',
                    },
                  );
                  setState(() {
                    updateBillStatus(
                        securityKey, documentSnapshot['order_id'], '3');
                  });
                } else {
                  insertOrderbilling(
                    productNames,
                    categery,
                    productid,
                    productPrice,
                    grandtotal,
                    productType,
                    quantitytype,
                    discount,
                    itemcount,
                    _tableSelected,
                    paymenttype,
                    userId,
                    'payment done',
                    "",
                    documentSnapshot['kot_done'],
                    totalDiscount.toString(),
                  );
                }
              } else {}
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            documentSnapshot['payment_done'] == 'true'
                ? FaIcon(
                    Icons.done_all_rounded,
                    color: Colors.greenAccent,
                    size: 6,
                  )
                : const SizedBox(),
            Text(
              'Payment',
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  clearButton(context, documentSnapshot) {
    return SizedBox(
      width: 55,
      child: MaterialButton(
        minWidth: 0,
        color: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(_tableSelected)
              .update(
            {
              'status': 'vacant',
              'customer_name': 'New Customer',
              'bill_done': 'false',
              'payment_done': 'false',
              'kot_done': 'false',
              'time': '00:00',
              'address': '',
              'instructions': '',
              'order_id': '',
              'number': '',
              'email': '',
              'gender': '',
              'amount': '0',
            },
          );
          FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(_tableSelected)
              .collection('productraw')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          }).then((_) {
            FirebaseFirestore.instance
                .collection('tablesraw')
                .doc(_tableSelected)
                .collection('productraw')
                .doc()
                .delete();
          });
          FirebaseFirestore.instance
              .collection('tablesraw')
              .doc(_tableSelected)
              .collection('orderraw')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          }).then((_) {
            FirebaseFirestore.instance
                .collection('tablesraw')
                .doc(_tableSelected)
                .collection('orderraw')
                .doc()
                .delete();
          });
          setState(() {
            showProducts = false;
            _tableSelected = "0";
            discountbutton = true;
            showPayments = false;
            showCustomer = false;
            discount = 0;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cancelTableDone
                ? FaIcon(
                    Icons.done_all_rounded,
                    color: Colors.greenAccent,
                    size: 6,
                  )
                : const SizedBox(),
            Text(
              'Clear',
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  billingTopBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: whiteColor,
        shadowColor: Colors.greenAccent.withOpacity(0.3),
        elevation: 10,
        centerTitle: false,
        title: InkWell(
          onTap: () => setState(
            () {
              showProducts = false;
              _tableSelected = "0";
              discountbutton = true;
              discount = 0;
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Shri',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " UmeshSon's",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Healthy Foods",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    menuItemHover = 'Billing Panel';
                  });
                },
                child: menuItemWidget('Billing Panel', menuItemHover),
              ),
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    menuItemHover = 'Delivery Panel';
                  });
                },
                child: menuItemWidget('Delivery Panel', menuItemHover),
              ),
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    menuItemHover = 'Settings';
                  });
                },
                child: menuItemWidget('Settings', menuItemHover),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  showCart = !showCart;
                });
              },
              icon: FaIcon(
                !showCart ? FontAwesomeIcons.xing : FontAwesomeIcons.bars,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  menuItemWidget(title, hoverMenu) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(
            color: hoverMenu == title ? Colors.greenAccent : whiteColor,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: hoverMenu == title
              ? Colors.black.withOpacity(0.6)
              : Colors.black.withOpacity(0.3),
          fontSize: 14,
        ),
      ),
    );
  }

  billingHeaderTextWidget(heading) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        heading,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: whiteColor,
        ),
      ),
    );
  }

  billingHeaderWidget(heading, billType) {
    return Text(
      heading,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: whiteColor,
      ),
    );
  }
}
