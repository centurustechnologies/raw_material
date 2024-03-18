import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/mainfiles/add_product.dart';
import 'package:raw_material/mainfiles/add_user.dart';
import 'package:raw_material/mainfiles/bill_history.dart';
import 'package:raw_material/mainfiles/category.dart';
import 'package:raw_material/mainfiles/homepage.dart';
import 'package:raw_material/mainfiles/my_order.dart';
import 'package:raw_material/mainfiles/new_bill.dart';

// Assuming MyDrawer is defined in another file

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(context),
        drawer: const MyDrawer(), // Assuming MyDrawer is defined somewhere
        body: TabBarView(
          children: [
            const _HomeBody(),
            const ManageUser(),
            const MyNewBill(),
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
              _tabBar(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 255, 159, 159),
          Color.fromARGB(255, 253, 94, 83)
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
    return TabBar(
      labelPadding: const EdgeInsets.all(0),
      labelColor: Color.fromARGB(255, 68, 255, 224),
      indicatorColor: Color.fromARGB(255, 68, 255, 224),
      unselectedLabelColor: Colors.white,
      tabs: const [
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
          text: 'New Bills',
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
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/white-abstract.png'),
      //     fit: BoxFit.fitHeight,
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       'Welcome',
                //       style: TextStyle(
                //           fontSize: 28,
                //           color: Colors.blue,
                //           fontWeight: FontWeight.bold),
                //       textAlign: TextAlign.center,
                //     ),
                //     Text(
                //       ',',
                //       style: TextStyle(
                //         fontSize: 30,
                //         color: Colors.green, // Change the text color to red
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //     Text(
                //       ' Here',
                //       style: TextStyle(
                //           fontSize: 26,
                //           color: Colors.red,
                //           fontWeight: FontWeight.bold),
                //       textAlign: TextAlign.center,
                //     ),
                //   ],
                // ),
              ],
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
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 245, 157, 157),
                          Color.fromARGB(255, 255, 90, 78),
                          Color.fromARGB(255, 245, 157, 157),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      minWidth: 280,
                      padding: const EdgeInsets.all(20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewBill(),
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
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 245, 157, 157),
                          Color.fromARGB(255, 255, 90, 78),
                          Color.fromARGB(255, 245, 157, 157),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
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
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _streamController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: const Padding(
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
                    String userId = data['user_id'];
                    String userEmail = data['user_email'];
                    String userNumber = data['user_number'];

                    return Card(
                      child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['user_image']),
                          ),
                          title: Row(
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "[ $userId ]",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("contact: $userNumber"),
                              Text("email: $userEmail"),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert, // Customize the icon as needed
                                color: Color.fromARGB(255, 180, 68,
                                    255), // Change the color of the icon
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
                    );
                  }).toList(),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: 44,
            width: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 247, 125, 125), Colors.red],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
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

// New Bill Tab

class MyNewBill extends StatefulWidget {
  const MyNewBill({Key? key}) : super(key: key);

  @override
  State<MyNewBill> createState() => _NewBillState();
}

class _NewBillState extends State<MyNewBill> {
  late StreamController<List<DocumentSnapshot>> _streamController;
  TextEditingController nameController = TextEditingController();
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
      var snapshot =
          await FirebaseFirestore.instance.collection('raw_cart').get();
      int currentCount = snapshot.size;
      await FirebaseFirestore.instance.collection('raw_cart').add({
        'costomer_id': currentCount + 1,
        'customer_name': nameController.text,
        'price': '₹ 0',
      }).whenComplete(() {
        setState(() {
          nameController.clear();
        });
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyNewBill()),
      );
    } catch (error) {
      print("Failed to add data: $error");
    }
  }

  Future<void> getData() async {
    try {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _streamController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  width: 400,
                  child: ListView(
                    children: snapshot.data!.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String costumerName = data['customer_name'];
                      String price = data['price'];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GenerateNewBill(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                costumerName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "itemDescription",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Price : ₹ $price",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 247, 125, 125), Colors.red],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
                borderRadius: BorderRadius.circular(26),
              ),
              child: MaterialButton(
                onPressed: () {
                  showDialog(
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
                              controller: nameController,
                              decoration: const InputDecoration(
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
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 125, 125)),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              addDataToRawCart();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GenerateNewBill(),
                                ),
                              );
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                color: Color.fromARGB(255, 247, 125, 125),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
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
                  shadowColor: Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: Icon(Icons.list_alt),
                    title: Text('Categories'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryPage()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: Icon(Icons.propane),
                    title: Text('Product'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => product_list()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: Icon(Icons.file_copy),
                    title: Text('My Order'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyOrder()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: Icon(Icons.history_sharp),
                    title: Text('Bills history'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Historypage()),
                      );
                    },
                  ),
                ),
                Card(
                  elevation:
                      2, // Adjust the elevation to control the intensity of the shadow
                  shadowColor: Color.fromARGB(255, 68, 255, 224),
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Setting'),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ManageUser()),
                      // );
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
