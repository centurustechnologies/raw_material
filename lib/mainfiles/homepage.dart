// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raw_material/mainfiles/create_bills.dart';
import 'package:raw_material/mainfiles/product_page.dart';
import 'package:raw_material/mainfiles/category_page.dart';
import 'package:raw_material/mainfiles/user.dart';

import '../helpers/app_constants.dart';
import 'generate_yesterday_bill.dart';
import 'bill_history.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Change the color here
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: const Image(
              image: AssetImage('assets/images/Logo-10.png'),
              height: 35,
              fit: BoxFit.cover,
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 8, 71, 123),
      ),
      drawer: MyDrawer(),
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
            Padding(
              padding: const EdgeInsets.all(20),
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
                            builder: (context) => const create_bill(),
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
                  const SizedBox(
                    height: 20,
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
                            builder: (context) => const GenerateYesterdayBill(),
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
            const SizedBox(
              height: 10,
            ),
          ],
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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 8, 71, 123),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/Logo-10.png'),
                ),
                SizedBox(height: 10),
                Text(
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
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('User'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Category List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.propane),
            title: Text('Product'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const product_list()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_present),
            title: Text('Generate New bill'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const create_bill()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text('Generate From yesterday bill'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GenerateYesterdayBill()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history_sharp),
            title: Text('Show bills history'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Historypage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// help Page of Drawer
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 8, 71, 123),
        title: Text(
          'Help',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Change the color here
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
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

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

// Setting page of Drawer

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  int _selectedThemeIndex = 0; // 0: Light, 1: Dark

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 8, 71, 123),
        title: Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Change the color here
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: MyDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text('Language'),
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
            title: Text('Theme'),
            trailing: DropdownButton<int>(
              value: _selectedThemeIndex,
              onChanged: (value) {
                setState(() {
                  _selectedThemeIndex = value!;
                });
              },
              items: [
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
          ExpansionTile(
            title: Text('Privacy Policy'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'This is the privacy policy of our app. We value your privacy and are committed to protecting your personal information.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
