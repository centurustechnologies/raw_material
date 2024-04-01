import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'manage_user.dart';
// import 'package:raw_material/mainfiles/card.dart'; // Commented out as it seems to be unnecessary or missing

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  // String? validateEmail(String? value) {
  //   var pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //   final regex = RegExp(pattern);

  //   return value!.isNotEmpty && !regex.hasMatch(value)
  //       ? 'Enter a valid email address'
  //       : null;
  // }

  List items = [];
  UploadTask? uploadTask;

  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController eMailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String imageURL = "";

  // ignore: unused_field
  File? _image;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToStorage(pickedFile) async {
    if (pickedFile == null) {
      print('No image selected.');
      return;
    }
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('user_image');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);

    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      String imageURL = await referenceImageToUpload.getDownloadURL();

      var snapshot =
          await FirebaseFirestore.instance.collection('raw_user').get();
      int currentCount = snapshot.size;

      String productId = (currentCount + 1).toString();

      FirebaseFirestore.instance.collection('raw_user').doc(productId).set({
        'user_name': nameController.text,
        'user_id': productId,
        'user_number': numberController.text,
        'user_email': eMailController.text,
        'user_image': imageURL,
      }).then((value) {
        print("data added sucessfully");
      }).catchError((error) {
        print("failed to add data: $error");
      }).whenComplete(() {
        setState(() {
          nameController.clear();
          numberController.clear();
          eMailController.clear();
          _image = null;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageUser()),
          );
        });
      });
      // ignore: avoid_print
    } catch (error) {
      // ignore: avoid_print
      print("Error occurred while uploading image and Data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'Add New User',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white, // Change the color here
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 20),
        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: _image != null
                          ? Image.file(
                              _image!,
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 40, top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Name',
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10),
                    //   child: TextFormField(
                    //     controller: userIdController,
                    //     keyboardType: TextInputType.text,
                    //     decoration: const InputDecoration(
                    //       isDense: true,
                    //       hintText: 'User id',
                    //     ),
                    //     style: const TextStyle(
                    //       color: Colors.black54,
                    //       fontSize: 16,
                    //     ),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please enter your name';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: eMailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'email',
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          } else {
                            // Regex for email validation
                            String pattern =
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                            RegExp regExp = RegExp(pattern);
                            if (!regExp.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Number',
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]+$')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 44,
                  width: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 245, 157, 157),
                      Color.fromARGB(255, 255, 90, 78),
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      uploadImageToStorage(_image);
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ),
      ),
    );
  }
}
