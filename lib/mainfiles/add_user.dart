import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'manage_user.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  late String _generatedPasscode;
  List items = [];
  UploadTask? uploadTask;

  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController eMailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String imageURL = "";

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

  String _generatePasscode() {
    Random random = Random();
    String passcode = '';
    for (int i = 0; i < 6; i++) {
      passcode += random.nextInt(10).toString();
    }
    return passcode;
  }

  Future uploadImageToStorage(File? pickedFile) async {
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

      await FirebaseFirestore.instance
          .collection('raw_user')
          .doc(nameController.text)
          .set({
        'user_name': nameController.text,
        'user_id': productId,
        'user_type': 'user',
        'passcode': _generatedPasscode,
        'user_password': passwordController.text,
        'user_email': eMailController.text,
        'user_image': imageURL,
      }).then((value) {
        print("data added successfully");
      }).catchError((error) {
        print("failed to add data: $error");
      }).whenComplete(() {
        setState(() {
          nameController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          eMailController.clear();
          _image = null;

          print("data added successfully");

          _showSnackBar(context, 'User created successfully!',
              color: Colors.green);
          Navigator.pop(context);
        });
      });
    } catch (error) {
      _showSnackBar(context, "Please fill all the details and select an image");
      print('Error occurred while uploading: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _generatedPasscode = _generatePasscode();
  }

  void _createUser(BuildContext context) {
    String imageURL = "";

    if (eMailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        imageURL.isEmpty) {
      return;
    }
  }

  bool _validateEmail(String email) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 8;
  }

  void _showSnackBar(BuildContext context, String message,
      {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.red),
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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
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
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            prefixIcon: const Icon(Icons.person),
                            hintText: ' Enter',
                            labelText: ' Username',
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: eMailController,
                          decoration: const InputDecoration(
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            prefixIcon: Icon(Icons.email),
                            hintText: " Enter",
                            labelText: " Email ",
                          ),
                          validator: (PassCurrentValue) {
                            var pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                            final regex = RegExp(pattern);

                            return PassCurrentValue!.isNotEmpty &&
                                    !regex.hasMatch(PassCurrentValue)
                                ? 'Enter a valid email address'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (PassCurrentValue) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            var passNonNullValue = PassCurrentValue ?? "";
                            if (passNonNullValue.isEmpty) {
                              return ("Password is required");
                            } else if (passNonNullValue.length < 6) {
                              return ("Enter a valid password");
                            } else if (!regex.hasMatch(passNonNullValue)) {
                              return ("Password should contain upper,lower,digit and Special character ");
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: const Icon(Icons.password),
                              hintText: " Enter",
                              labelText: ' Password'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            prefixIcon: const Icon(Icons.password),
                            hintText: " confirm",
                            labelText: ' Confirm Password',
                          ),
                          validator: (PassCurrentValue) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            var passNonNullValue = PassCurrentValue ?? "";
                            if (passNonNullValue.isEmpty) {
                              return ("Plese confirm your password");
                            } else if (passNonNullValue.length < 6) {
                              return ("Enter a valid password");
                            } else if (!regex.hasMatch(passNonNullValue)) {
                              return ("Password doesn't matched");
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 44,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _createUser(context);
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
      ),
    );
  }
}
