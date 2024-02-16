// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raw_material/helpers/app_constants.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List items = [];
  UploadTask? uploadTask;
  File? image;
  String originalImageName = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController eMailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  File? pickedlogoimage;

  Future pickImage(ImageSource galary) async {
    try {
      final image = await ImagePicker().pickImage(source: galary);
      if (image == null) return;

      final imageTemporary = File(image.path);
      final imageName = path.basenameWithoutExtension(imageTemporary.path);
      final newFile = await imageTemporary
          .rename('${imageTemporary.parent.path}/$imageName.png');
      log('picked image is $newFile ${imageTemporary.parent.path}');

      setState(() {
        this.image = newFile;
        originalImageName = "$imageName.png";
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future<void> addDataToFirestore(userIdController) async {
    final path = 'image/$originalImageName';
    final file = File(image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download link : $urlDownload');

    setState(() {
      uploadTask = null;
    });

    String documentId = userIdController.text;
    FirebaseFirestore.instance.collection('raw_user').doc(documentId).set({
      'user_name': nameController.text,
      'user_id': userIdController.text,
      'user_number': mobileNumberController.text,
      'user_email': eMailController.text,
      'date': dateController.text,
      'image': urlDownload.toString(),
    }).then((value) {
      print("data added sucessfully");
    }).catchError((error) {
      print("failed to add data: $error");
    }).whenComplete(() {
      setState(() {
        nameController.clear();
        userIdController.clear();
        mobileNumberController.clear();
        eMailController.clear();
      });
    });
  }

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

  Future<void> getData() async {
    // ignore: unused_local_variable
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('raw_user').get();
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
        // WillPopScope(
        //   onWillPop: () async {
        //     Navigator.popUntil(context, ModalRoute.withName('/first'));
        //     return true;
        //   },
        //   child:
        Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          "User",
          style: TextStyle(color: Colors.white),
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
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                height: displayHeight(context) / 1.16,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ExpansionTile(
                        title: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Color.fromARGB(255, 2, 52, 93)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Create New User',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 5, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            pickImage(ImageSource.gallery);
                                          },
                                          child: Container(
                                            width: 140,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: pickedlogoimage != null
                                                ? Image.file(
                                                    pickedlogoimage!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Icon(
                                                    Icons.camera_alt,
                                                    size: 70,
                                                    color: Colors.grey.shade400,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          height: 35,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: TextField(
                                              controller: nameController,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                                hintText: 'Name',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          height: 40,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: TextField(
                                              controller: userIdController,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                                hintText: 'User id',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          height: 40,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: TextField(
                                              controller: eMailController,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                                hintText: 'email',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          height: 40,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: TextField(
                                              controller:
                                                  mobileNumberController,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                                hintText: 'Number',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    height: 44,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [
                                            Colors.blue,
                                            Color.fromARGB(255, 2, 52, 93)
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight),
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    child: MaterialButton(
                                      onPressed: () {
                                        addDataToFirestore(userIdController);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 13,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Text(
                                              'Create',
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
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      StreamBuilder<List<DocumentSnapshot>>(
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
                              height: displayHeight(context) / 1.2,
                              width: 400,
                              child: ListView(
                                  children: snapshot.data!
                                      .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                String userName = data['user_name'];
                                String userId = data['user_id'];
                                String userEmail = data['user_email'];
                                String userNumber = data['user_number'];
                                String date = data['date'];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 175,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 102, 100, 100)
                                                  .withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 0),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      'User Name',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.6)),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black
                                                            .withOpacity(0.6)),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    userName,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      'User id',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.6)),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black
                                                            .withOpacity(0.6)),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    userId,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      'Number',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.6)),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black
                                                            .withOpacity(0.6)),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    userNumber,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      'email',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.6)),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black
                                                            .withOpacity(0.6)),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    userEmail,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      'Date',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.6)),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' : ',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    date,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.remove_red_eye),
                                                    onPressed: () {},
                                                    iconSize:
                                                        25.0, // Adjust the size of the icon as needed
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
                                    ),
                                  ),
                                );
                              }).toList()),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //  ),
    );
  }
}
