import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../helpers/app_constants.dart';
import '../mainfiles/homepage.dart';
import 'controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();

  String user = '';
  String pass = '';
  String id = '';

  Future getadmindata(String id) async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(id)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          user = value.get('userid');
          pass = value.get('password');
        });
        if (userid.text == user && password.text == pass) {
          LocalStorageHelper.saveValue('userid', user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please fill correct all mandatory fields'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please fill correct all mandatory fields'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
          ),
          child: Stack(
            children: [
              Container(
                height: displayHeight(context),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Lottie.asset(
                  'assets/json-files/background_spiral.json',
                  fit: BoxFit.cover,
                  reverse: true,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: displayWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Image.asset(
                                'assets/images/Logo-10.png',
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.height,
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: greenLightShadeColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome back',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                loginField(
                                  ' Username',
                                  userid,
                                  'Enter username',
                                ),
                                const SizedBox(height: 15),
                                loginField(
                                  ' Password',
                                  password,
                                  'Enter password',
                                ),
                                const SizedBox(height: 15),
                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.center,
                                  child: MaterialButton(
                                    minWidth: 280,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    color: greenLightShadeColor,
                                    child: Text(
                                      'Sign In',
                                      style: GoogleFonts.poppins(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (userid.text.isNotEmpty &&
                                          password.text.isNotEmpty) {
                                        // setState(() {
                                        //   id = userid.text;
                                        // });
                                        getadmindata(userid.text);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: MaterialButton(
                          //     onPressed: () {},
                          //     child: Text(
                          //       'Forgot Password?',
                          //       style: GoogleFonts.poppins(
                          //         color: greenLightShadeColor,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginField(heading, controller, hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            // fontSize: 26,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 2, right: 10),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
