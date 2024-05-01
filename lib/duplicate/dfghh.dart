// class updateProduct extends StatefulWidget {
//   final String productID;
//   // final String productUNIT;
//   // final String productNAME;
//   // final String productPRICE;
//   // final String selectedUNIT;

//   const updateProduct({
//     super.key,
//     required this.productID,
//     // required this.productUNIT,
//     // required this.productNAME,
//     // required this.productPRICE,
//     // required this.selectedUNIT,
//   });

//   @override
//   State<updateProduct> createState() => _updateProductState();
// }





// File? _Image;
// final ImagePicker _picker = ImagePicker();
// List category_List = [];
// String categorytype = "";
// String categoryname = "";
// String? selectedCategory;

// String _selectedUnit = 'Select';
// String selectedCategoryLabel = 'Select Category';

// TextEditingController productController = TextEditingController();
// TextEditingController priceController = TextEditingController();
// TextEditingController unitController = TextEditingController();

// Future updateDataToStorage(pickedFile) async {
//   if (pickedFile == null) {
//     print('No image selected.');
//     return;
//   }
//   String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';

//   Reference referenceRoot = FirebaseStorage.instance.ref();
//   Reference referenceDireImages = referenceRoot.child('product_Image');
//   Reference referenceImageToUpload = referenceDireImages.child(fileName);

//   try {
//     await referenceImageToUpload.putFile(File(pickedFile.path));
//     String imageUrl = await referenceImageToUpload.getDownloadURL();

//     var snapshot = await FirebaseFirestore.instance
//         .collection('raw_billing_product')
//         .get();
//     int currentCount = snapshot.size;
//     String productId = (currentCount + 1).toString();
//     String productPrice = priceController.text;
//     String productUnit = unitController.text;
//     String basePrice =
//         (int.parse(productPrice) / int.parse(productUnit)).toStringAsFixed(2);

//     await FirebaseFirestore.instance
//         .collection('raw_billing_product')
//         .doc(productId)
//         .update({
//       'categery': selectedCategoryLabel,
//       'product_unit': unitController.text,
//       'selected_unit': _selectedUnit,
//       'product_name': productController.text,
//       'product_price': priceController.text,
//       'product_id': productId,
//       'product_image': imageUrl,
//       'base_price': basePrice,
//       'product_type': 'full',
//     }).then((value) async {
//       productController.clear();
//       priceController.clear();
//       unitController.clear();
//       _Image = null;
//       getData();
//       if (kDebugMode) {
//         print("Data added successfully!");
//       }
//     });
//   } catch (error) {
//     print("Error occurred while uploading image and data: $error");
//     print(error);
//   }
// }

// StreamController<List<DocumentSnapshot>> _streamController =
//     StreamController<List<DocumentSnapshot>>();
// TextEditingController categoryNameController = TextEditingController();

// @override
// void initState() {
//   _document = [];
//   _streamController = StreamController<List<DocumentSnapshot>>();
//   getData();
//   unitController.addListener(() {
//     if (unitController.text.isEmpty && _selectedUnit != 'Select') {
//       _selectedUnit = 'Select';
//     }
//   });
// }

// List<DocumentSnapshot> _document = [];
// Future<void> getData() async {
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('raw_billing_product')
//         .get();
//     _document = querySnapshot.docs;
//     _streamController.add(_document);
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error in fetching data: $e');
//     }
//   }
// }

// @override
// void dispose() {
//   productController.dispose();
//   priceController.dispose();
//   unitController.dispose();
// }

// Future pickImage() async {
//   try {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
     
//       _Image = File(pickedFile.path);
//     }
//   } catch (e) {
//     print('Failed to pick image: $e');
//   }
// }

// class _updateProductState extends State<updateProduct> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(color: Colors.red),
//         ),
//         title: const Text(
//           'Update Product',
//           style: TextStyle(
//               fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//         leading: Builder(builder: (BuildContext context) {
//           return IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white, // Change the color here
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           );
//         }),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('raw_billing_product')
//             .where('product_id', isEqualTo: widget.productID)
//             // .where('product_unit', isEqualTo: widget.productUNIT)
//             // .where('product_name', isEqualTo: widget.productNAME)
//             // .where('product_price', isEqualTo: widget.productPRICE)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No products found'));
//           }

//           final DocumentSnapshot document = snapshot.data!.docs.first;
//           final Map<String, dynamic> data =
//               document.data() as Map<String, dynamic>;
//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: pickImage,
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundImage: NetworkImage(data['product_image']),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('raw_categery')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       print('Some Error Occured ${snapshot.error}');
//                       return Text('Error: ${snapshot.error}');
//                     }

//                     if (!snapshot.hasData) {
//                       return const CircularProgressIndicator();
//                     }

//                     List<PopupMenuItem<String>> categoryItems = [];
//                     final documents = snapshot.data!.docs.reversed.toList();

//                     for (var doc in documents) {
//                       var categoryName = doc['categery_name'];
//                       categoryItems.add(
//                         PopupMenuItem<String>(
//                           value: doc.id,
//                           child: Text(categoryName),
//                         ),
//                       );
//                     }

//                     return Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: const BoxDecoration(
//                         border: Border(bottom: BorderSide(color: Colors.grey)),
//                       ),
//                       child: PopupMenuButton<String>(
//                         onSelected: (String value) {
//                           setState(() {
//                             selectedCategory = value;
//                             var selectedDoc =
//                                 documents.firstWhere((doc) => doc.id == value);
//                             selectedCategoryLabel =
//                                 selectedDoc['categery_name'];
//                           });
//                         },
//                         itemBuilder: (BuildContext context) => categoryItems,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               child: Text(
//                                 data['categery']?.toString() ?? 'Not available',
//                                 style: const TextStyle(
//                                   color: Color.fromARGB(255, 124, 124, 124),
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                             const Icon(Icons.arrow_drop_down),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextField(
//                   controller: productController,
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     hintText: data['product_name'] ?? 'Not available',
//                     isDense: true,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 TextField(
//                   controller: unitController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: data['product_unit'] ?? 'Not available',
//                     isDense: true,
//                     suffixIcon: PopupMenuButton<String>(
//                       onSelected: (String value) {
//                         setState(() {
//                           if (value != data['product_unit']) {
//                             _selectedUnit = value;
//                           }
//                         });
//                       },
//                       itemBuilder: (BuildContext context) =>
//                           <PopupMenuEntry<String>>[
//                         const PopupMenuItem<String>(
//                           value: 'Select',
//                           child: Text('Select'),
//                         ),
//                         const PopupMenuItem<String>(
//                           value: 'kg',
//                           child: Text('kg'),
//                         ),
//                         const PopupMenuItem<String>(
//                           value: 'litre',
//                           child: Text('litre'),
//                         ),
//                         const PopupMenuItem<String>(
//                           value: 'pcs',
//                           child: Text('pieces'),
//                         ),
//                       ],
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Text(_selectedUnit),
//                           const Icon(Icons.arrow_drop_down),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 TextField(
//                   controller: priceController,
//                   decoration: InputDecoration(
//                     hintText:
//                         data['product_price']?.toString() ?? 'Not available',
//                     isDense: true,
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 44,
//                       width: 120,
//                       decoration: BoxDecoration(
//                         color: Colors.purple,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: MaterialButton(
//                         onPressed: () {
//                           updateDataToStorage(_Image);
//                           Navigator.of(context).pop();
//                         },
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(26),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text(
//                               'Update',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//           // return ListView(
//           //   children: <Widget>[
//           //     if (data['product_image'] != null)
//           //       Image.network(
//           //         data['product_image'],
//           //         fit: BoxFit.cover,
//           //         errorBuilder: (context, error, stackTrace) {
//           //           return const Text('Failed to load image');
//           //         },
//           //       ),
//           //     ListTile(
//           //       title: Text('Product ID'),
//           //       subtitle: Text(data['product_id'] ?? 'Not available'),
//           //     ),
//           //     ListTile(
//           //       title: Text('Product Unit'),
//           //       subtitle: Text(data['product_unit'] ?? 'Not available'),
//           //     ),
//           //     ListTile(
//           //       title: Text('Product Name'),
//           //       subtitle: Text(data['product_name'] ?? 'Not available'),
//           //     ),
//           //     ListTile(
//           //       title: Text('Product Price'),
//           //       subtitle:
//           //           Text(data['product_price']?.toString() ?? 'Not available'),
//           //     ),
//           //     ListTile(
//           //       title: Text('category'),
//           //       subtitle: Text(data['categery']?.toString() ?? 'Not available'),
//           //     ),
//           //   ],
//           // );
//         },
//       ),
//     );
//   }

