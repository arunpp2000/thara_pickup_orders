
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'buttons.dart';
import 'orderDetailsPage.dart';



class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List products = [];
  late TextEditingController search = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot>? userStream;
  bool nxtVal = false;
  int ind = 0;

  Map<String,dynamic> newQty={};
  Map<String,dynamic> newPrice={};
  Map<String,dynamic> prdSku={};
  Map<String,dynamic> prdSold={};



  next() {
    pageIndex++;
    if (lastDoc == null || pageIndex == 0) {
      ind = 0;
      userStream = FirebaseFirestore.instance
          .collection('pickUpOrders')
          .orderBy('date', descending: true)
          .startAfterDocument(lastDocuments[pageIndex - 1]!)
          .limit(limit)
          .snapshots();
    } else {
      ind += limit;
      userStream = FirebaseFirestore.instance
          .collection('pickUpOrders')
          .orderBy('date', descending: true)
          .limit(limit)
          .startAfterDocument(lastDocuments[pageIndex - 1]!)
          .startAfterDocument(lastDoc)
          .snapshots();
    }
    setState(() {});
  }

  prev() {
    pageIndex--;
    if (firstDoc == null || pageIndex == 0) {
      ind = 0;
      userStream = FirebaseFirestore.instance
          .collection('pickUpOrders')
          .orderBy('date', descending: true)
          .limit(limit)
          .snapshots();
    } else {
      ind -= limit;
      userStream = FirebaseFirestore.instance
          .collection('pickUpOrders')
          .orderBy('date', descending: true)
          .startAfterDocument(lastDocuments[pageIndex - 1]!)
          .limit(limit)
          .snapshots();
    }
    setState(() {});
  }

  List datas = [
    'B2C',
    'B2B',
  ];
  bool loading =false;
  Map<int, DocumentSnapshot> lastDocuments = {};
  List data = [];
  int pageIndex = 0;
  var lastDoc;
  var firstDoc;
  int limit = 20;
  int selectedIndex = 0;
  Timestamp? datePicked1;
  Timestamp? datePicked2;
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  final scroll = ScrollController();
  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    userStream = FirebaseFirestore.instance
        .collection('pickUpOrders')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
centerTitle: true,
        title: Text('Report'),
        automaticallyImplyLeading: true,
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: scroll,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                  ],
                ),
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Padding(
              //       padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
              //       child: Container(
              //         width: 600,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               blurRadius: 3,
              //               color: Color(0x39000000),
              //               offset: Offset(0, 1),
              //             )
              //           ],
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Padding(
              //           padding:
              //           const EdgeInsetsDirectional.fromSTEB(4, 4, 0, 4),
              //           child: Row(
              //             mainAxisSize: MainAxisSize.max,
              //             children: [
              //               Expanded(
              //                 child: Padding(
              //                   padding:
              //                   EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
              //                   child: TextFormField(
              //                     controller: search,
              //                     obscureText: false,
              //                     onChanged: (text) {
              //                       if (text == "") {
              //                         userStream = FirebaseFirestore.instance
              //                             .collection('products')
              //                             .orderBy('date', descending: true)
              //                             .limit(limit)
              //                             .snapshots();
              //                       } else {
              //                         userStream = FirebaseFirestore.instance
              //                             .collection("products")
              //                             .orderBy('date', descending: true)
              //                             .limit(limit)
              //                             .where('search',
              //                             arrayContains: text.toUpperCase())
              //                             .snapshots();
              //                       }
              //                       setState(() {});
              //                     },
              //                     decoration: InputDecoration(
              //                       labelText: 'Search ',
              //                       hintText: 'Please Enter Name',
              //                       labelStyle: TextStyle(
              //                         fontFamily: 'Poppins',
              //                         color: Color(0xFF7C8791),
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                       enabledBorder: OutlineInputBorder(
              //                         borderSide: BorderSide(
              //                           color: Color(0x00000000),
              //                           width: 2,
              //                         ),
              //                         borderRadius: BorderRadius.circular(8),
              //                       ),
              //                       focusedBorder: OutlineInputBorder(
              //                         borderSide: BorderSide(
              //                           color: Color(0x00000000),
              //                           width: 2,
              //                         ),
              //                         borderRadius: BorderRadius.circular(8),
              //                       ),
              //                       filled: true,
              //                       fillColor: Colors.white,
              //                     ),
              //                     style: TextStyle(
              //                       fontFamily: 'Poppins',
              //                       color: Color(0xFF090F13),
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.normal,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding:
              //                 EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
              //                 child: FFButtonWidget(
              //                   onPressed: () {
              //                     search.clear();
              //                     userStream = FirebaseFirestore.instance
              //                         .collection('products')
              //                         .orderBy('date', descending: true)
              //                         .limit(limit)
              //                         .snapshots();
              //                     setState(() {});
              //                   },
              //                   text: 'Clear',
              //                   options: FFButtonOptions(
              //                     width: 100,
              //                     height: 40,
              //                     color: Color(0xFF4B39EF),
              //                     textStyle: TextStyle(
              //                       fontFamily: 'Poppins',
              //                       color: Colors.white,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.normal,
              //                     ),
              //                     elevation: 2,
              //                     borderSide: BorderSide(
              //                       color: Colors.transparent,
              //                       width: 1,
              //                     ),
              //                     borderRadius: 50,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //
              //
              //   ],
              // ),
              StreamBuilder<QuerySnapshot>(
                  stream: userStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    data = [];
                    products = [];
                    products=snapshot.data!.docs;
                    data = snapshot.data!.docs;
                    if (data.length != 0) {
                      print(data.length);
                      lastDoc = snapshot.data?.docs[data.length - 1];
                      lastDocuments[pageIndex] = lastDoc;
                      firstDoc = snapshot.data?.docs[0];
                    }
                    return data.length == 0
                        ? LottieBuilder.network(
                      'https://assets9.lottiefiles.com/packages/lf20_HpFqiS.json',
                      height: 500,
                    )
                        : Column(
                      children: [
                        SizedBox(
                          width:
                          // double.infinity,
                          MediaQuery.of(context).size.width * 0.85,
                          child: DataTable(
                            horizontalMargin: 10,
                            columnSpacing: 20,
                            columns: [
                              DataColumn(
                                label: Text(
                                  "S.No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Order Date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Order Time",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
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
                                  "Price",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ),
                              DataColumn(
                                label: Text("",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)),
                              ),
                            ],
                            rows: List.generate(
                              data.length,
                                  (index) {
                                String name = data[index]['name'];
                                String mobile = data[index]['mobileNumber'];

                                // String shippingMethod = data[index]['shippingMethod'];
                                // String price = data[index]['price'].toString();
                                // Timestamp placedDate = data[index]['placedDate'];
                                return DataRow(
                                  color: index.isOdd
                                      ? MaterialStateProperty.all(Colors
                                      .blueGrey.shade50
                                      .withOpacity(0.7))
                                      : MaterialStateProperty.all(
                                      Colors.blueGrey.shade50),
                                  cells: [
                                    DataCell(Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.02,
                                      child: SelectableText(
                                        (ind == 0
                                            ? index + 1
                                            : ind + index + 1)
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                    DataCell(SelectableText(
                                      DateFormat("dd-MM-yyyy").format(
                                          data[index]['date'].toDate()),
                                      style: TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    DataCell(SelectableText(
                                      DateFormat.jm().format(
                                          data[index]['date'].toDate()),
                                      style: TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    DataCell(SelectableText(
                                      mobile,
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
                                      data[index]['grandTotal'].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),

                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              OrderDetails(
                                                            id:
                                                            data[index]
                                                            [
                                                            'id'],
                                                          )));
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    color: Colors.deepPurple,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    border: Border.all(
                                                        color: Colors
                                                            .black
                                                            .withOpacity(
                                                            0.3))),
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  'view',
                                                  style: TextStyle(
                                                      color:
                                                      Colors.white),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              pageIndex == 0
                                  ? SizedBox()
                                  : InkWell(
                                onTap: () {
                                  prev();
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                      BorderRadius.circular(
                                          10)),
                                  child: Center(
                                      child: Text('Previous')),
                                ),
                              ),
                              (lastDoc == null && pageIndex != 0) ||
                                  data.length < limit
                                  ? SizedBox()
                                  : InkWell(
                                onTap: () {
                                  next();
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                      BorderRadius.circular(
                                          10)),
                                  child:
                                  Center(child: Text('Next')),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
