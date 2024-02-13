import 'package:flutter/material.dart';
import 'package:raw_material/mainfiles/homepage.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: const Text(
          'Bill history',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
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
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 400,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: const Color.fromARGB(255, 102, 100, 100)
                                  .withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'Order Id',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Text(
                                ' : ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '............',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'Order Name',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Text(
                                ' : ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '............',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Text(
                                ' : ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '+91 _____-_____',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Text(
                                ' : ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.8)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '--/--/----',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: IconButton(
                                    icon: const Icon(Icons.remove_red_eye),
                                    onPressed: () {},
                                    iconSize:
                                        25.0, // Adjust the size of the icon as needed
                                    color: Colors
                                        .blue, // Customize the color of the icon
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  child: IconButton(
                                    icon: const Icon(Icons.download),
                                    onPressed: () {},
                                    iconSize:
                                        28.0, // Adjust the size of the icon as needed
                                    color: Colors
                                        .blue, // Customize the color of the icon
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //trailing: ,
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
