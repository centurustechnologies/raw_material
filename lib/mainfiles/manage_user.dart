// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raw_material/NewApp/card.dart';
import 'package:raw_material/mainfiles/add_user.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class ManageUser extends StatefulWidget {
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  TextEditingController _searchController = TextEditingController();

  late StreamController<List<DocumentSnapshot>> _streamController;
  // ignore: unused_field
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
      // ignore: unused_local_variable
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NewHome()),
            (route) => false);
        return true;
      },
      child: Scaffold(
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
            'Manage Users',
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              child: Container(
                height: 60,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 245, 157, 157),
                        width: 5.0,
                      ),
                    ),
                    hintText: "Search...",
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        //search logic here
                      },
                    ),
                  ),
                ),
              ),
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
                          color: Color.fromARGB(255, 255, 247, 247),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 65,
                              child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data['user_image']),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "[ $userId ]",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("contact: $userNumber"),
                                      Text("email: $userEmail"),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
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
                                                leading: const Icon(Icons.edit),
                                                title: const Text('Edit'),
                                                onTap: () {},
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'remove',
                                              child: ListTile(
                                                leading:
                                                    const Icon(Icons.delete),
                                                title: const Text('Remove'),
                                                onTap: () {
                                                  // removeItem(context, index);
                                                },
                                              ),
                                            ),
                                          ])),
                            ),
                          ),
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
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 245, 157, 157),
                    Color.fromARGB(255, 255, 90, 78),
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewUser()),
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
        ),
      ),
    );
  }
}


    //  SizedBox(
    //           child: Padding(
    //             padding: const EdgeInsets.only(top: 8),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 StreamBuilder<List<DocumentSnapshot>>(
    //                     stream: _streamController.stream,
    //                     builder: (BuildContext context,
    //                         AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    //                       if (snapshot.hasError) {
    //                         return Text('Error: ${snapshot.error}');
    //                       }

    //                       if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //                         return const Text('No data available');
    //                       }

    //                       return SizedBox(
    //                         height: displayHeight(context) / 1.2,
    //                         width: 400,
    //                         child: ListView(
    //                             children: snapshot.data!
    //                                 .map((DocumentSnapshot document) {
    //                           Map<String, dynamic> data =
    //                               document.data() as Map<String, dynamic>;
    //                           String userName = data['user_name'];
    //                           String userId = data['user_id'];
    //                           String userEmail = data['user_email'];
    //                           String userNumber = data['user_number'];
    //                           String date = data['date'];

    //                           return Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Container(
    //                               height: 175,
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(15),
    //                                   color: Colors.white,
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                         color: const Color.fromARGB(
    //                                                 255, 102, 100, 100)
    //                                             .withOpacity(0.3),
    //                                         spreadRadius: 1,
    //                                         blurRadius: 1)
    //                                   ]),
    //                               child: Padding(
    //                                 padding:
    //                                     const EdgeInsets.only(left: 15, top: 0),
    //                                 child: Column(
    //                                   children: [
    //                                     const SizedBox(
    //                                       height: 10,
    //                                     ),
    //                                     Column(
    //                                       children: [
    //                                         Row(
    //                                           children: [
    //                                             SizedBox(
    //                                               width: 80,
    //                                               child: Text(
    //                                                 'User Name',
    //                                                 style: TextStyle(
    //                                                     fontSize: 14,
    //                                                     fontWeight:
    //                                                         FontWeight.w500,
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.6)),
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               ' : ',
    //                                               style: TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w400,
    //                                                   color: Colors.black
    //                                                       .withOpacity(0.6)),
    //                                             ),
    //                                             const SizedBox(
    //                                               width: 10,
    //                                             ),
    //                                             Text(
    //                                               userName,
    //                                               style: const TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w500,
    //                                                   color: Colors.black),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             SizedBox(
    //                                               width: 80,
    //                                               child: Text(
    //                                                 'User id',
    //                                                 style: TextStyle(
    //                                                     fontSize: 14,
    //                                                     fontWeight:
    //                                                         FontWeight.w500,
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.6)),
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               ' : ',
    //                                               style: TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w400,
    //                                                   color: Colors.black
    //                                                       .withOpacity(0.6)),
    //                                             ),
    //                                             const SizedBox(
    //                                               width: 10,
    //                                             ),
    //                                             Text(
    //                                               userId,
    //                                               style: const TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w500,
    //                                                   color: Colors.black),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             SizedBox(
    //                                               width: 80,
    //                                               child: Text(
    //                                                 'Number',
    //                                                 style: TextStyle(
    //                                                     fontSize: 14,
    //                                                     fontWeight:
    //                                                         FontWeight.w500,
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.6)),
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               ' : ',
    //                                               style: TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w400,
    //                                                   color: Colors.black
    //                                                       .withOpacity(0.6)),
    //                                             ),
    //                                             const SizedBox(
    //                                               width: 10,
    //                                             ),
    //                                             Text(
    //                                               userNumber,
    //                                               style: const TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w500,
    //                                                   color: Colors.black),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             SizedBox(
    //                                               width: 80,
    //                                               child: Text(
    //                                                 'email',
    //                                                 style: TextStyle(
    //                                                     fontSize: 14,
    //                                                     fontWeight:
    //                                                         FontWeight.w500,
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.6)),
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               ' : ',
    //                                               style: TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w400,
    //                                                   color: Colors.black
    //                                                       .withOpacity(0.6)),
    //                                             ),
    //                                             const SizedBox(
    //                                               width: 10,
    //                                             ),
    //                                             Text(
    //                                               userEmail,
    //                                               style: const TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w500,
    //                                                   color: Colors.black),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             SizedBox(
    //                                               width: 80,
    //                                               child: Text(
    //                                                 'Date',
    //                                                 style: TextStyle(
    //                                                     fontSize: 14,
    //                                                     fontWeight:
    //                                                         FontWeight.w500,
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.6)),
    //                                               ),
    //                                             ),
    //                                             Text(
    //                                               ' : ',
    //                                               style: TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w400,
    //                                                   color: Colors.black
    //                                                       .withOpacity(0.8)),
    //                                             ),
    //                                             const SizedBox(
    //                                               width: 10,
    //                                             ),
    //                                             Text(
    //                                               date,
    //                                               style: const TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.w500,
    //                                                   color: Colors.blue),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ],
    //                                     ),
    //                                     Padding(
    //                                       padding:
    //                                           const EdgeInsets.only(top: 12),
    //                                       child: Row(
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.end,
    //                                         children: [
    //                                           SizedBox(
    //                                             child: IconButton(
    //                                               icon: const Icon(
    //                                                   Icons.remove_red_eye),
    //                                               onPressed: () {},
    //                                               iconSize:
    //                                                   25.0, // Adjust the size of the icon as needed
    //                                               color: Colors
    //                                                   .blue, // Customize the color of the icon
    //                                             ),
    //                                           ),
    //                                           const SizedBox(
    //                                             width: 20,
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         }).toList()),
    //                       );
    //                     }),
    //               ],
    //             ),
    //           ),
    //         ),
       