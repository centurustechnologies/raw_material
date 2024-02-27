
   
    //  Column(
    //           children: [
    //             StreamBuilder<List<DocumentSnapshot>>(
    //               stream: _streamController.stream,
    //               builder: (BuildContext context,
    //                   AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    //                 // if (snapshot.connectionState ==
    //                 //     ConnectionState.waiting) {
    //                 //   return const Center(
    //                 //     child: CircularProgressIndicator(),
    //                 //   );
    //                 // } else if (snapshot.hasError) {
    //                 //   return Center(
    //                 //     child: Text('Error: ${snapshot.error}'),
    //                 //   );
    //                 // }

    //                 return SizedBox(
    //                   child: ListView(
    //                     children:
    //                         snapshot.data!.map((DocumentSnapshot document) {
    //                       // Access data from the document using document.data()
    //                       String name = document['product_name'];

    //                       // Replace 'name' with the actual field name in your collection

    //                       return Column(
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.only(top: 16),
    //                             child: SizedBox(
    //                               width: 300,
    //                               child: Text(
    //                                 name,
    //                                 style: const TextStyle(
    //                                   fontSize: 15,
    //                                   fontWeight: FontWeight.w800,
    //                                   color: Color.fromARGB(255, 8, 71, 123),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           Row(
    //                             children: [
    //                               const Padding(
    //                                 padding: EdgeInsets.only(right: 8),
    //                                 child: SizedBox(
    //                                   width: 50,
    //                                   child: Text(
    //                                     "5 pcs",
    //                                     style: TextStyle(
    //                                       fontSize: 12,
    //                                       fontWeight: FontWeight.w400,
    //                                       color:
    //                                           Color.fromARGB(255, 8, 71, 123),
    //                                     ),
    //                                     softWrap:
    //                                         true, // Allow text to wrap to the next line
    //                                     maxLines:
    //                                         3, // Limit the number of lines initially displayed (adjust as needed)
    //                                     overflow: TextOverflow.ellipsis,
    //                                   ),
    //                                 ),
    //                               ),
    //                               const Padding(
    //                                 padding: EdgeInsets.only(right: 2),
    //                                 child: SizedBox(
    //                                   width: 50,
    //                                   child: Text(
    //                                     "200 rs",
    //                                     style: TextStyle(
    //                                       fontSize: 12,
    //                                       fontWeight: FontWeight.w400,
    //                                       color:
    //                                           Color.fromARGB(255, 8, 71, 123),
    //                                     ),
    //                                     softWrap:
    //                                         true, // Allow text to wrap to the next line
    //                                     maxLines:
    //                                         3, // Limit the number of lines initially displayed (adjust as needed)
    //                                     overflow: TextOverflow.ellipsis,
    //                                   ),
    //                                 ),
    //                               ),
    //                               MaterialButton(
    //                                 color: mainColor,
    //                                 padding: EdgeInsets.zero,
    //                                 minWidth: 0,
    //                                 height: 0,
    //                                 onPressed: () {
    //                                   //

    //                                   //insertCartWithQuantity(
    //                                   //   securityKey,
    //                                   //   widget.userId,
    //                                   //   cartData[index]['product_id'],
    //                                   //   cartData[index]['current_price'],
    //                                   //   cartData[index]['categery_id'],
    //                                   //   int.parse(cartData[index]
    //                                   //           ['cart_product_quantity']) +
    //                                   //       1,
    //                                   // );
    //                                   // setState(() {
    //                                   //   getCart(securityKey, userId);
    //                                   // });
    //                                 },
    //                                 child: Icon(
    //                                   Icons.add,
    //                                   color: whiteColor,
    //                                 ),
    //                               ),
    //                               const Padding(
    //                                 padding: EdgeInsets.only(right: 8, left: 8),
    //                                 child: SizedBox(
    //                                   width: 20,
    //                                   child: Text(
    //                                     "23",
    //                                     style: TextStyle(
    //                                       fontSize: 12,
    //                                       fontWeight: FontWeight.w400,
    //                                       color:
    //                                           Color.fromARGB(255, 8, 71, 123),
    //                                     ),
    //                                     softWrap:
    //                                         true, // Allow text to wrap to the next line
    //                                     maxLines:
    //                                         3, // Limit the number of lines initially displayed (adjust as needed)
    //                                     overflow: TextOverflow.ellipsis,
    //                                   ),
    //                                 ),
    //                               ),
    //                               MaterialButton(
    //                                   color: mainColor,
    //                                   padding: EdgeInsets.zero,
    //                                   minWidth: 0,
    //                                   height: 0,
    //                                   onPressed: () {},
    //                                   child: InkWell(
    //                                     onTap: () {
    //                                       // removeCart(
    //                                       //   securityKey,
    //                                       //   cartData[index]['cart_id'],
    //                                       // );
    //                                       // setState(() {
    //                                       //   getCart(
    //                                       //     securityKey,
    //                                       //     widget.userId,
    //                                       //   );
    //                                       //   cartData.length <= 1
    //                                       //       ? log(
    //                                       //           'cart length is smaller ${cartData.length}')
    //                                       //       : log(
    //                                       //           'cart length is greater ${cartData.length}');
    //                                       // });
    //                                     },
    //                                     child: Icon(
    //                                       Icons.delete,
    //                                       color: whiteColor,
    //                                     ),
    //                                   )
    //                                   // : Icon(
    //                                   //     Icons.remove,
    //                                   //     color: whiteColor,
    //                                   //   ),
    //                                   ),
    //                             ],
    //                           ),
    //                         ],
    //                       );
    //                     }).toList(),
    //                   ),
    //                 );
    //               },
    //             ),
    //             const Row(
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(
    //                     right: 2,
    //                   ),
    //                   child: SizedBox(
    //                     width: 100,
    //                     child: Text(
    //                       "Grand Total",
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w900,
    //                         color: Color.fromARGB(255, 8, 71, 123),
    //                       ),
    //                       softWrap: true, // Allow text to wrap to the next line
    //                       maxLines:
    //                           3, // Limit the number of lines initially displayed (adjust as needed)
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(right: 2),
    //                   child: SizedBox(
    //                     width: 80,
    //                     child: Text(
    //                       "50 items",
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w900,
    //                         color: Color.fromARGB(255, 8, 71, 123),
    //                       ),
    //                       softWrap: true, // Allow text to wrap to the next line
    //                       maxLines:
    //                           3, // Limit the number of lines initially displayed (adjust as needed)
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(right: 2),
    //                   child: SizedBox(
    //                     width: 70,
    //                     child: Text(
    //                       "20000 rs",
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w900,
    //                         color: Color.fromARGB(255, 8, 71, 123),
    //                       ),
    //                       softWrap: true, // Allow text to wrap to the next line
    //                       maxLines:
    //                           3, // Limit the number of lines initially displayed (adjust as needed)
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
      