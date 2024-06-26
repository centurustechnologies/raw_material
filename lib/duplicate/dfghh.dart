import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raw_material/NewApp/card.dart';

import '../helpers/app_constants.dart';
import '../helpers/controller.dart';

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

  String usertype = '';

  Future getadmindata(String id) async {
    await FirebaseFirestore.instance
        .collection('raw_user')
        .doc(id)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          user = value.get('user_name');
          pass = value.get('user_password');
          usertype = value.get('user_type');
        });
        if (userid.text == user && password.text == pass) {
          LocalStorageHelper.saveValue('user_name', user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const NewHome(
                      isAdmin: false,
                    )),
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
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background1.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: displayWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, top: 140, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'LOGIN',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            loginField(
                              ' Username',
                              userid,
                              'Enter username',
                            ),
                            const SizedBox(height: 25),
                            loginField(
                              ' Password',
                              password,
                              'Enter password',
                            ),
                            const SizedBox(height: 25),
                            const SizedBox(height: 50),

                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 280,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 90, 78),
                                      Color.fromARGB(255, 255, 155, 137),
                                      Color.fromARGB(255, 255, 90, 78),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: MaterialButton(
                                  minWidth: 250,
                                  padding: const EdgeInsets.all(15),
                                  onPressed: () {
                                    if (userid.text.isNotEmpty &&
                                        password.text.isNotEmpty) {
                                      // setState(() {
                                      //   id = userid.text;
                                      // });
                                      getadmindata(userid.text);
                                    }
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.center,
                            //   child: MaterialButton(
                            //     minWidth: 250,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     padding: const EdgeInsets.all(20),
                            //     color: greenLightShadeColor,
                            //     child: Text(
                            //       'Sign In',
                            //       style: GoogleFonts.poppins(
                            //         fontSize: 16,
                            //         color: whiteColor,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //     onPressed: () {
                            //       if (userid.text.isNotEmpty &&
                            //           password.text.isNotEmpty) {
                            //         // setState(() {
                            //         //   id = userid.text;
                            //         // });
                            //         getadmindata(userid.text);
                            //       }
                            //     },
                            //   ),
                            // ),
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
