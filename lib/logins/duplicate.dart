import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Progress Indicator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true; // Set to true to show the progress indicator initially

  @override
  void initState() {
    super.initState();
    // Simulate loading data
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false; // Set to false when data loading is complete
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circular Progress Indicator Demo'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show progress indicator while loading
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Your data widgets go here
                  Text(
                    'Data Loaded!',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your other data widgets go here...',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
  
                              
                             
                                  // if (snapshot.data!.docs.isEmpty) {
                                  //   return const Padding(
                                  //     padding: EdgeInsets.all(50),
                                  //     child: Center(
                                  //         child: Text(
                                  //       '',
                                  //       style: TextStyle(
                                  //           color: Colors.black,
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.bold),
                                  //     )),
                                  //   );
                                  // }