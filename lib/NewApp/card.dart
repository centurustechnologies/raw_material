import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/logins/login.dart';
import 'package:raw_material/mainfiles/add_product.dart';
import 'package:raw_material/mainfiles/add_user.dart';
import 'package:raw_material/mainfiles/bill_history.dart';
import 'package:raw_material/mainfiles/category.dart';
import 'package:raw_material/mainfiles/homepage.dart';
import 'package:raw_material/mainfiles/my_order.dart';

import '../lastoption.dart';

// Assuming MyDrawer is defined in another file

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  bool usertype = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: usertype ? 4 : 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(context),
        drawer: const MyDrawer(), // Assuming MyDrawer is defined somewhere
        body: usertype
            ? TabBarView(
                children: [
                  const _HomeBody(),
                  const ManageUser(),
                  const _productTab(),
                  MenuTab(),
                ],
              )
            : TabBarView(
                children: [
                  const _HomeBody(),
                  const _productTab(),
                  MenuTab(),
                ],
              ),
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(170),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/Logo-10.png'),
                  )
                ],
              ),
              const SizedBox(height: 5),
              _searchBox(),
              usertype ? _tabBar() : _tabBar2(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      gradient: LinearGradient(
        colors: [
          Colors.red,
          Colors.redAccent,
          Colors.red,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _searchBox() {
    return SizedBox(
      height: 35,
      child: TextFormField(
        textAlign: TextAlign.start,
        controller: _searchText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: InkWell(
            child: const Icon(Icons.close),
            onTap: () {
              _searchText.clear();
            },
          ),
          hintText: 'Search...',
          contentPadding: const EdgeInsets.all(0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return const TabBar(
      labelPadding: EdgeInsets.all(0),
      labelColor: Color.fromARGB(255, 68, 255, 224),
      indicatorColor: Color.fromARGB(255, 68, 255, 224),
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.home),
          text: 'Home',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.group),
          text: 'User',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.notifications),
          text: 'Products',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.menu),
          text: 'Menu',
        ),
      ],
    );
  }

  Widget _tabBar2() {
    return const TabBar(
      labelPadding: EdgeInsets.all(0),
      labelColor: Color.fromARGB(255, 68, 255, 224),
      indicatorColor: Color.fromARGB(255, 68, 255, 224),
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.home),
          text: 'Home',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.notifications),
          text: 'Products',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.menu),
          text: 'Menu',
        ),
      ],
    );
  }

  Widget _tabBarViewItem(IconData icon, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 40),
        ),
      ],
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody({Key? key}) : super(key: key);

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      minWidth: 280,
                      padding: const EdgeInsets.all(20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BillGeneration(),
                          ),
                        );
                      },
                      child: Text(
                        'New bill',
                        style: GoogleFonts.poppins(
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      minWidth: 280,
                      padding: const EdgeInsets.all(20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrder(),
                          ),
                        );
                      },
                      child: Text(
                        'My Order',
                        style: GoogleFonts.poppins(
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

// User Tab

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  // ignore: unused_field
  final TextEditingController _searchController = TextEditingController();

  late StreamController<List<DocumentSnapshot>> _streamController;
  late List<DocumentSnapshot> _document;

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

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('raw_user').get();
      _document = querySnapshot.docs;
      _streamController.add(_document);
    } catch (e) {
      print('error in fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _streamController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ListView(
                  children: snapshot.data!.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String userName = data['user_name'];
                    String userEmail = data['user_email'];

                    return Card(
                      shadowColor: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(data['user_image']),
                            ),
                            title: Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("email: $userEmail"),
                            trailing: PopupMenuButton<String>(
                                icon: Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: const Icon(
                                    Icons
                                        .more_vert, // Customize the icon as needed
                                    color: Color.fromARGB(255, 180, 68,
                                        255), // Change the color of the icon
                                  ),
                                ),
                                onSelected: (String value) {
                                  // Handle selected value
                                },
                                itemBuilder: (
                                  context,
                                ) =>
                                    [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.edit,
                                          ),
                                          title: const Text('Edit'),
                                          onTap: () {},
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'remove',
                                        child: ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text('Remove'),
                                          onTap: () {
                                            // removeItem(context, index);
                                          },
                                        ),
                                      ),
                                    ])),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 10, right: 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(26),
            ),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNewUser()),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Add user',
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
      ],
    );
  }
}

// product Tab

class _productTab extends StatefulWidget {
  const _productTab({super.key});

  @override
  State<_productTab> createState() => __productTabState();
}

// ignore: camel_case_types
class __productTabState extends State<_productTab> {
  // ignore: non_constant_identifier_names
  List category_List = [];
  String categorytype = "";
  bool _isLoading = false;
  String categoryname = "";
  String _selectedUnit = 'Select';
  String? selectedCategory;
  String selectedCategoryLabel = 'Select Category';
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  // ignore: unused_field
  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
  late List<DocumentSnapshot> _document;

  File? _Image;
  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _Image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadDataToStorage(pickedFile) async {
    if (pickedFile == null) {
      print('No image selected.');
      return;
    }
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('product_Image');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);

    try {
      setState(() {
        _isLoading = true;
      });
      await referenceImageToUpload.putFile(File(pickedFile.path));
      String imageUrl = await referenceImageToUpload.getDownloadURL();

      var snapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      int currentCount = snapshot.size;
      String productId = (currentCount + 1).toString();

      await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .doc(productId)
          .set({
        'categery': selectedCategory,
        'product_unit': unitController.text,
        'selected_unit': _selectedUnit,
        'product_name': productController.text,
        'product_price': priceController.text,
        'product_id': productId, // Set product ID same as document ID
        'product_image': imageUrl,
        'product_type': 'full',
      });

      print("Data added successfully");

      setState(() {
        _isLoading = false;
        productController.clear();
        priceController.clear();
        unitController.clear();
        _Image = null;
      });
    } catch (error) {
      print("Error occurred while uploading image and data: $error");

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      setState(() {
        _document = querySnapshot.docs;
        _streamController.add(_document);
        _isLoading = false;
      });
    } catch (e) {
      print('error i fetching data: $e');

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _document = [];
    _streamController = StreamController<List<DocumentSnapshot>>();
    getData();
    super.initState();
    unitController.addListener(() {
      if (unitController.text.isEmpty && _selectedUnit != 'Select') {
        setState(() {
          _selectedUnit = 'Select';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children:
                                snapshot.data!.map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              String productId = data['product_id'];
                              String productType = data['product_type'];
                              String productName = data['product_name'];
                              String productPrice = data['product_price'];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    productName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    productId,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                productType,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '₹ $productPrice',
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
                            }).toList()));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 10, left: 10),
              child: Center(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      showAddProductDialog(context, () {
                        getData();
                      });
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
        if (_isLoading)
          Positioned(
            child: Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  void showAddProductDialog(BuildContext context, VoidCallback onDataAdded) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: const Text(
                  'Add Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                titlePadding: const EdgeInsets.only(left: 80, top: 15),
                content: Container(
                  height: 360,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return InkWell(
                                    onTap: () {
                                      pickImage();
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: _Image != null
                                          ? Image.file(
                                              _Image!,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.camera_alt,
                                              size: 70,
                                              color: Colors.grey.shade400,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('raw_categery')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(
                                        'Some Error Occured ${snapshot.error}');
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  List<PopupMenuItem<String>> categoryItems =
                                      [];
                                  final documents =
                                      snapshot.data!.docs.reversed.toList();

                                  for (var doc in documents) {
                                    var categoryName = doc['categery_name'];
                                    categoryItems.add(
                                      PopupMenuItem<String>(
                                        value: doc.id,
                                        child: Text(categoryName),
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    child: PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        setState(() {
                                          selectedCategory = value;
                                          var selectedDoc =
                                              documents.firstWhere(
                                                  (doc) => doc.id == value);
                                          selectedCategoryLabel =
                                              selectedDoc['categery_name'];
                                        });
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          categoryItems,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedCategoryLabel,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 124, 124, 124),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: productController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: 'Product Name',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: unitController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Item Unit',
                                    suffixIcon: PopupMenuButton<String>(
                                      onSelected: (String value) {
                                        setState(() {
                                          if (value != 'Select') {
                                            _selectedUnit = value;
                                          }
                                        });
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Select',
                                          child: Text('Select'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'kg',
                                          child: Text('kg'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'litre',
                                          child: Text('litre'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'pieces',
                                          child: Text('pieces'),
                                        ),
                                      ],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(_selectedUnit),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: 'Enter Price ',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
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
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 44,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 90, 78),
                              Color.fromARGB(255, 245, 157, 157),
                              Color.fromARGB(255, 253, 77, 64),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            await uploadDataToStorage(
                                _Image); // Ensure this function is async and properly handles the upload
                            Navigator.of(context).pop(); // Closes the dialog
                            onDataAdded();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

//    Menu Bills

class MenuTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: ListView(
              shrinkWrap: true,
              children: [
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: const Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Categories'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryPage()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: const Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: const Icon(Icons.propane),
                    title: const Text('Product'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const product_list()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: const Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: const Icon(Icons.file_copy),
                    title: const Text('My Order'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyOrder()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: const Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: const Icon(Icons.history_sharp),
                    title: const Text('Bills history'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Historypage()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: const Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Setting'),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ManageUser()),
                      // );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: const Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
