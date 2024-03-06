import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:raw_material/mainfiles/card.dart'; // Commented out as it seems to be unnecessary or missing

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
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
      FirebaseFirestore.instance.collection('raw_user').doc().set({
        'user_name': nameController.text,
        'user_id': userIdController.text,
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
          userIdController.clear();
          numberController.clear();
          eMailController.clear();
          _image = null;
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
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
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
                      child: TextField(
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: userIdController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'User id',
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: eMailController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'email',
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
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
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Color.fromARGB(255, 2, 52, 93)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
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
