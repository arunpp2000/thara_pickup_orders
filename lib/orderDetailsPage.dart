
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class OrderDetails extends StatefulWidget {
  var id;

  OrderDetails({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final scaffoldKey = GlobalKey<ScaffoldState>();


  Map address = {};
  var data;
  String partner ='';
  List items = [];
  int? sum;

  String? invoiceNo;
  getorders() {
    FirebaseFirestore.instance
        .collection('pickUpOrders')
        .doc(widget.id)
        .snapshots()
        .listen((event) {
      data = event.data();
      sum =0;
      items=[];
      for (var a in event.data()!['bag']) {
        items.add(a);
        // sum = a['price'] + sum;
      }
      print(items);
      if (mounted) {
        setState(() {});
      }
    });
  }



  List<dynamic> p=[];
  List<String> pItems=[''];

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    getorders();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF383838)),
          automaticallyImplyLeading: true,
          title: Text(
            'Details',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF090F13),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 5,
        ),
        backgroundColor: Color(0xFFF1F4F8),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text('Name :'+data['name']??'',style: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold
              )),
              SizedBox(height: 5,),
              Text('Mobile Number :'+data['mobileNumber'],style: TextStyle(
                fontSize: 15,fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 5,),
              Text('Order Date :'+DateFormat("dd-MM-yyyy").format(
                  data['date'].toDate()),style: TextStyle(
                  fontSize: 15,fontWeight: FontWeight.bold
              ),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [




                    Material(
                      color: Colors.transparent,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.shopping_bag),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Order Details',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                width:
                                // double.infinity,
                                MediaQuery.of(context).size.width * 0.95,
                                child: DataTable(
                                  horizontalMargin: 10,
                                  columnSpacing: 20,
                                  columns: [
                                    DataColumn(
                                      label: Text("No",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11)),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Qty",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text("GST",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11)),
                                    ),
                                    DataColumn(
                                      label: Text("Prize",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11)),
                                    ),
                                  ],
                                  rows: List.generate(
                                    items.length,
                                        (index) {
                                      String name = items[index]['pdtName']??'';
                                     String price= items[index]['price'].toString();
                                      String qty =
                                      items[index]['qty'].toString();
                                      String gst =
                                      items[index]['gst'].toString();


                                      return DataRow(
                                        color: index.isOdd
                                            ? MaterialStateProperty.all(Colors
                                            .blueGrey.shade50
                                            .withOpacity(0.7))
                                            : MaterialStateProperty.all(
                                            Colors.blueGrey.shade50),
                                        cells: [
                                          DataCell(SelectableText(
                                            ' ${index + 1}',
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          DataCell(SelectableText(
                                            name,
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),


                                          DataCell(SelectableText(
                                            qty,
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          DataCell(SelectableText(
                                            gst,
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          DataCell(SelectableText(
                                            price,
                                            style: TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                    ),
                    Material(
                      color: Colors.transparent,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(right: 80),
                              //         child: Row(
                              //           children: [
                              //             Text(
                              //               'Product Total (${items.length}) items',
                              //               style: TextStyle(
                              //                   fontSize: 15,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //             SizedBox(
                              //               width: 50,
                              //             ),
                              //             Text(
                              //               '\₹$sum',
                              //               style: TextStyle(
                              //                   fontSize: 15,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(right: 80),
                              //         child: Row(
                              //           children: [
                              //             Text(
                              //               'Shipping Charge',
                              //               style: TextStyle(
                              //                   fontSize: 15,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //             SizedBox(
                              //               width: 50,
                              //             ),
                              //             Text('3242'),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(right: 80),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                       '\₹${data['discount']}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.only(right: 80),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total (excel.GST)',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      '\₹${data['totalEx'].toStringAsFixed(2)}',

                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 80),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Text(
                              //         'GST:',
                              //         style: TextStyle(
                              //             fontSize: 15,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //       SizedBox(
                              //         width: 50,
                              //       ),
                              //       Text(
                              //         '\₹',
                              //         style: TextStyle(
                              //             fontSize: 15,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80),
                                      child: Row(
                                        children: [
                                          Text(
                                            '----------------------------------------------------------',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Order Total',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            '\₹${data['grandTotal']}',

                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // );
          // }),
        ));
  }
}
