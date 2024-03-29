// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raw_material/NewApp/card.dart';
import 'package:raw_material/mainfiles/new_bill.dart';
import 'package:raw_material/mainfiles/profile.dart';
import '../helpers/app_constants.dart';
import 'my_order.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NewHome()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: const Text(
            "Home",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
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
        ),
        drawer: const MyDrawer(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/white-abstract.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ',',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.green, // Change the text color to red
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          ' Here',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    // Text(
                    //   'Providing The best features for u',
                    //   style: TextStyle(
                    //     fontSize: 20, // Change the font size to 18
                    //     color: Colors.black, // Change the text color to blue
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 245, 157, 157),
                              Color.fromARGB(255, 255, 90, 78),
                              Color.fromARGB(255, 245, 157, 157),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                          minWidth: 280,
                          padding: const EdgeInsets.all(20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewBill(),
                              ),
                            );
                          },
                          child: Text(
                            'New bill',
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 245, 157, 157),
                              Color.fromARGB(255, 255, 90, 78),
                              Color.fromARGB(255, 245, 157, 157),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                          minWidth: 280,
                          padding: const EdgeInsets.all(20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyOrder(),
                              ),
                            );
                          },
                          child: Text(
                            'My Order',
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 159, 159),
                  Color.fromARGB(255, 253, 94, 83)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                  },
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/Logo-10.png'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'shriiumeshsons@gmail.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Edit Profile'),
            leading: Icon(Icons.list_alt),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Help & Support'),
            leading: Icon(Icons.help),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewBill()),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              // Add the functionality for Settings
            },
          ),
        ],
      ),
    );
  }
}

// help Page of Drawer
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          'Help',
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 20.0),
            FAQItem(
              question: 'How do I reset my password?',
              answer:
                  'To reset your password, go to the settings page and tap on the "Reset Password" button.',
            ),
            SizedBox(height: 10.0),
            FAQItem(
              question: 'How can I contact customer support?',
              answer:
                  'You can contact customer support by sending an email to support@example.com or by calling our hotline at 123-456-7890.',
            ),
            SizedBox(height: 10.0),
            FAQItem(
              question: 'What payment methods do you accept?',
              answer:
                  'We accept payments via credit cards, PayPal, and Google Pay. You can also pay using our in-app payment system.',
            ),
            SizedBox(height: 10.0),
            FAQItem(
              question: 'How do I update the app?',
              answer:
                  'To update the app, go to the app store or Google Play Store and check for updates. Tap on the "Update" button next to our app.',
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     Navigator.popUntil(context, ModalRoute.withName('/first'));
        //     return true;
        //   },
        //   child:
        ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
        ),
      ],
      //   ),
    );
  }
}

// Setting page of Drawer

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  int _selectedThemeIndex = 0; // 0: Light, 1: Dark

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
          'Setting',
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              items: ['English', 'Spanish', 'French']
                  .map<DropdownMenuItem<String>>((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<int>(
              value: _selectedThemeIndex,
              onChanged: (value) {
                setState(() {
                  _selectedThemeIndex = value!;
                });
              },
              items: const [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('Light'),
                ),
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Dark'),
                ),
              ],
            ),
          ),
          const ExpansionTile(
            title: Text('Privacy Policy'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This is the privacy policy of our app. We value your privacy and are committed to protecting your personal information.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ],
      ),
      //   ),
    );
  }
}
