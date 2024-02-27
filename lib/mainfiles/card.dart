import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: use_key_in_widget_constructors
class ImagePickerWidget extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      _pickedImage = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  void _clearImage() {
    setState(() {
      _pickedImage = null;
    });
  }
// Future<void> _uploadImageToFirebase() async {
//     if (_pickedImage == null) {
//       return; // No image picked, return early
//     }

//     try {
//       final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('images') // Your Firebase Storage path for images
//           .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');

//       await ref.putFile(_pickedImage!);

//       // Image uploaded successfully, now clear the picked image
//       setState(() {
//         _pickedImage = null;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Image uploaded to Firebase'),
//       ));
//     } catch (e) {
//       print('Error uploading image: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error uploading image to Firebase'),
//       ));
//     }
//   }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_pickedImage != null) ...[
          Image.file(_pickedImage!), // Display picked image
          ElevatedButton(
            onPressed: _clearImage,
            child: Text('Clear Image'),
          ),
        ],
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: Text('Pick Image from Camera'),
        ),
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: Text('Pick Image from Gallery'),
        ),
      ],
    );
  }
}
