import 'package:flutter/material.dart';
import 'package:raw_material/NewApp/card.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(color: Colors.redAccent),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    CircleAvatar(
                      radius: 70.0,
                      backgroundImage: AssetImage('assets/images/Logo-10.png'),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Color.fromARGB(255, 68, 255, 224),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 90, 255, 68),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: const Text('Edit Profile'),
                        onTap: () {
                          // Navigate to edit profile screen
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage());
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Help & Support'),
                        onTap: () {
                          MaterialPageRoute(
                              builder: (context) => const HelpPage());
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () {
                          // Implement logout functionality
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Handle pay button press
              //     },
              //     child: Text('Pay'),
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.orange,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
