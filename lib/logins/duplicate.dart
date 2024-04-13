import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Example'),
        ),
        body: Center(
          child: TextFieldWithPopupMenu(),
        ),
      ),
    );
  }
}

class TextFieldWithPopupMenu extends StatefulWidget {
  @override
  _TextFieldWithPopupMenuState createState() => _TextFieldWithPopupMenuState();
}

class _TextFieldWithPopupMenuState extends State<TextFieldWithPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  height: 100,
                  color: Colors.green,
                )),
            Expanded(
                flex: 2,
                child: Container(
                  height: 100,
                  color: Colors.amber,
                )),
          ],
        ),
      ],
    );
  }
}













// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: Text('Example'),
//         ),
//         body: Center(
//           child: TextFieldWithPopupMenu(),
//         ),
//       ),
//     );
//   }
// }

// class TextFieldWithPopupMenu extends StatefulWidget {
//   @override
//   _TextFieldWithPopupMenuState createState() => _TextFieldWithPopupMenuState();
// }

// class _TextFieldWithPopupMenuState extends State<TextFieldWithPopupMenu> {
//   final TextEditingController _controller = TextEditingController();
//   String? _selectedUnit; // Make it nullable and not initialized

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               hintText: 'Enter value',
//               suffixIcon: PopupMenuButton<String>(
//                 onSelected: (String value) {
//                   setState(() {
//                     _selectedUnit = value;
//                   });
//                 },
//                 itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                   const PopupMenuItem<String>(
//                     value: 'Select',
//                     child: Text('Select'),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: 'kg',
//                     child: Text('kg'),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: 'litter',
//                     child: Text('litter'),
//                   ),
//                 ],
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     // Use the conditional expression here
//                     Text(_selectedUnit ?? 'Select'),
//                     Icon(Icons.arrow_drop_down),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
