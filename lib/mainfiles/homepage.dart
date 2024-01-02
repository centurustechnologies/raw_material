import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/app_constants.dart';
import 'form.dart';
import 'history.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                minWidth: 280,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                color: greenLightShadeColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountDetail(),
                    ),
                  );
                },
                child: Text(
                  'Generate New bill',
                  style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // onPressed: () {
                //   if (userid.text.isNotEmpty &&
                //       password.text.isNotEmpty) {
                //     // setState(() {
                //     //   id = userid.text;
                //     // });
                //     getadmindata(userid.text);
                //   }
                // },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                minWidth: 280,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                color: greenLightShadeColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Historypage(),
                    ),
                  );
                },
                child: Text(
                  'Show bills history',
                  style: GoogleFonts.poppins(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // onPressed: () {
                //   if (userid.text.isNotEmpty &&
                //       password.text.isNotEmpty) {
                //     // setState(() {
                //     //   id = userid.text;
                //     // });
                //     getadmindata(userid.text);
                //   }
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
