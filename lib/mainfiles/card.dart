import 'package:flutter/material.dart';

class ExpensivePage extends StatefulWidget {
  final List<Map<String, dynamic>> historyData;

  ExpensivePage({required this.historyData});

  @override
  State<ExpensivePage> createState() => _ExpensivePageState();
}

class _ExpensivePageState extends State<ExpensivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expensive Page'),
      ),
      body: ListView.builder(
        itemCount: widget.historyData.length,
        itemBuilder: (context, index) {
          final data = widget.historyData[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Customer: ${data['customerName']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Customer ID: ${data['customerId']}'),
                  Text('User: ${data['userName']}'),
                  Text('User ID: ${data['userId']}'),
                  Text('Products: ${data['products']}'),
                  Text('Total Payment: \$${data['totalPayment']}'),
                  Text('Details: ${data['details']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () {
                      // Add functionality to download data here
                      // Example: downloadData(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading data...')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () {
                      // Add functionality to print data here
                      // Example: printData(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Printing data...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ExpensivePage(
      historyData: [
        {
          'customerName': 'John Doe',
          'customerId': 'C001',
          'userName': 'Jane Smith',
          'userId': 'U001',
          'products': 'Product A, Product B',
          'totalPayment': 200.0,
          'details': 'Details for transaction 1',
        },
        {
          'customerName': 'Alice Johnson',
          'customerId': 'C002',
          'userName': 'Bob Brown',
          'userId': 'U002',
          'products': 'Product C, Product D',
          'totalPayment': 350.0,
          'details': 'Details for transaction 2',
        },
        // Add more historical data as needed
      ],
    ),
  ));
}

    //   body: ListView.builder(
    //     itemCount: 5, // Assuming there are 5 historical records
    //     itemBuilder: (context, index) {
    //       return Card(
    //         margin: EdgeInsets.all(10.0),
    //         color: Colors.grey[200],
    //         child: ListTile(
    //           title: Text('Customer Name'),
    //           subtitle: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text('ID: Customer ID'),
    //               Text('Username: Username'),
    //               Text('Products: Product details'),
    //               Text('Total Payment: Total amount'),
    //               Text('Details: Additional details here'),
    //             ],
    //           ),
    //           trailing: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               IconButton(
    //                 icon: Icon(Icons.file_download),
    //                 onPressed: () {
    //                   // Implement download functionality
    //                 },
    //               ),
    //               IconButton(
    //                 icon: Icon(Icons.print),
    //                 onPressed: () {
    //                   // Implement print functionality
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );

