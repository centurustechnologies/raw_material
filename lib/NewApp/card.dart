import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/logins/login.dart';
import 'package:raw_material/mainfiles/add_user.dart';
import 'package:raw_material/mainfiles/bill_history.dart';
import 'package:raw_material/mainfiles/category.dart';
import 'package:raw_material/mainfiles/homepage.dart';
import 'package:raw_material/mainfiles/my_order.dart';

import '../lastoption.dart';

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
        drawer: const MyDrawer(),
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
                          PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.topCenter,
                            duration: const Duration(milliseconds: 400),
                            isIos: true,
                            child: const BillGeneration(),
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
                          PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.topCenter,
                            duration: const Duration(milliseconds: 400),
                            isIos: true,
                            child: const MyOrder(),
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
                                icon: const Padding(
                                  padding: EdgeInsets.only(bottom: 0),
                                  child: Icon(
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const AddNewUser()),
                // );
                Navigator.push(
                  context,
                  PageTransition(
                    curve: Curves.bounceOut,
                    type: PageTransitionType.bottomToTop,
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.topCenter,
                    child: AddNewUser(),
                  ),
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
  // bool _isLoading = false;
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

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      setState(() {
        _document = querySnapshot.docs;
        _streamController.add(_document);
      });
    } catch (e) {
      print('error i fetching data: $e');
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
    productController.dispose();
    priceController.dispose();
    unitController.dispose();
    super.dispose();

    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: StreamBuilder(
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
                          String productUnit = data['product_unit'];
                          String productName = data['product_name'];
                          String productPrice = data['product_price'];
                          String selectedUnit = data['selected_unit'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                productName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                productId,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                productUnit,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                selectedUnit,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
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
                                              MainAxisAlignment.spaceBetween,
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
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(26),
            ),
            child: MaterialButton(
              onPressed: () => showAddProductDialog(context, () {
                getData();
              }),
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
      ],
    );
  }

  void showAddProductDialog(BuildContext context, VoidCallback onRefresh) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddProductForm(onRefresh: onRefresh),
        );
      },
    );
  }
}

class AddProductForm extends StatefulWidget {
  final VoidCallback onRefresh;

  AddProductForm({Key? key, required this.onRefresh}) : super(key: key);

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  File? _Image;
  final ImagePicker _picker = ImagePicker();
  List category_List = [];
  String categorytype = "";
  String categoryname = "";
  String? selectedCategory;

  String _selectedUnit = 'Select';
  String selectedCategoryLabel = 'Select Category';

  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();

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
      await referenceImageToUpload.putFile(File(pickedFile.path));
      String imageUrl = await referenceImageToUpload.getDownloadURL();

      var snapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      int currentCount = snapshot.size;
      String productId = (currentCount + 1).toString();
      String productPrice = priceController.text;
      String productUnit = unitController.text;
      String basePrice =
          (int.parse(productPrice) / int.parse(productUnit)).toStringAsFixed(2);

      await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .doc(productId)
          .set({
        'categery': selectedCategoryLabel,
        'product_unit': unitController.text,
        'selected_unit': _selectedUnit,
        'product_name': productController.text,
        'product_price': priceController.text,
        'product_id': productId,
        'product_image': imageUrl,
        'base_price': basePrice,
        'product_type': 'full',
      }).then((value) async {
        productController.clear();
        priceController.clear();
        unitController.clear();
        _Image = null;
        getData();
        if (kDebugMode) {
          print("Data added successfully!");
        }
      });
    } catch (error) {
      print("Error occurred while uploading image and data: $error");
      print(error);
    }
  }

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  TextEditingController categoryNameController = TextEditingController();

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

  List<DocumentSnapshot> _document = [];
  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('raw_billing_product')
          .get();
      _document = querySnapshot.docs;
      _streamController.add(_document);
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetching data: $e');
      }
    }
  }

  @override
  void dispose() {
    productController.dispose();
    priceController.dispose();
    unitController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _Image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Product',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: _Image != null ? FileImage(_Image!) : null,
              child: _Image == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 50,
                    )
                  : null,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('raw_categery')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('Some Error Occured ${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              List<PopupMenuItem<String>> categoryItems = [];
              final documents = snapshot.data!.docs.reversed.toList();

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
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    setState(() {
                      selectedCategory = value;
                      var selectedDoc =
                          documents.firstWhere((doc) => doc.id == value);
                      selectedCategoryLabel = selectedDoc['categery_name'];
                    });
                  },
                  itemBuilder: (BuildContext context) => categoryItems,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          selectedCategoryLabel,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 124, 124, 124),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              );
            },
          ),
          TextField(
            controller: productController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Product Name',
              isDense: true,
            ),
          ),
          TextField(
            controller: unitController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Unit',
              isDense: true,
              suffixIcon: PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    if (value != 'Select') {
                      _selectedUnit = value;
                    }
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                    value: 'pcs',
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
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 44,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: MaterialButton(
                  onPressed: () {
                    uploadDataToStorage(_Image);
                    Navigator.of(context).pop();
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
      ),
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
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600),
                          isIos: true,
                          child: CategoryPage(),
                        ),
                      );
                    },
                  ),
                ),
                // Card(
                //   elevation:
                //       2, // Adjust the elevation to control the intensity of the shadow
                //   shadowColor: const Color.fromARGB(255, 68, 255, 224),
                //   child: ListTile(
                //     leading: const Icon(Icons.propane),
                //     title: const Text('Product'),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const product_list()),
                //       );
                //     },
                //   ),
                // ),
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
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600),
                          isIos: true,
                          child: MyOrder(),
                        ),
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
