import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raw_material/NewApp/card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: "",
      //   projectId: "centurusbills",
      //   messagingSenderId: "",
      //   appId: "1:207694629480:web:18814847f52006250bc9dd",-
      // ),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: NewHome());
  }
}

// fade
// rightToLeft
// leftToRight
// upToDown
// downToUp
// scale
// rotate
// size
// rightToLeftWithFade
// leftToRightWithFade
// rightToLeftJoined
// leftToRightJoined
// rightToLeftPop
// leftToRightPop
// topToBottomJoined
// bottomToTopJoined
// topToBottomPop
// bottomToTopPop