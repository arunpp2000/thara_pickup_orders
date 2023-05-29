import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thara_pickup_orders/productAndCatorgory.dart';
import 'package:thara_pickup_orders/report.dart';

import 'bill.dart';
import 'buttons.dart';
import 'global.dart';
import 'login.dart';

// List items=[];
bool search = false;

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<String> tables = [];
  late TextEditingController discountController;
  late TextEditingController deliveryCharge;
  late TextEditingController tableController;

  // _getDevicelist() async {
  //   List<Map<String, dynamic>> results = [];
  //   results = await FlutterUsbPrinter.getUSBDeviceList();
  //   for (dynamic device in results) {
  //     _connect(int.parse(device['vendorId']), int.parse(device['productId']));
  //   }
  //   print(" length: ${results.length}");
  //   setState(() {
  //     devices = results;
  //   });
  // }
  List<int> bytes = [];
  List<int> kotBytes = [];

  // counter() async {
  //
  //   for(int i=count;i>0;i--){
  //     await Future.delayed(const Duration(seconds: 1));
  //     if(i==5){
  //
  //       final CapabilityProfile profile = await CapabilityProfile.load();
  //       final generator = Generator(PaperSize.mm80, profile);
  //
  //       bytes=generator.beep(duration: PosBeepDuration.beep50ms,n:1 );
  //       flutterUsbPrinter.write(Uint8List.fromList(bytes));
  //       bytes=[];
  //       i=count;
  //     }
  //
  //   }
  // }
  bool keyboard = false;
  // ScreenshotController screenshotController = ScreenshotController();
  qr(String vatTotal1, String grantTotal) {
    // seller name
    String sellerName = 'Chicken House Brosted';
    String vat_registration = '302120536400003';
    String vatTotal = vatTotal1;
    String invoiceTotal = grantTotal;
    BytesBuilder bytesBuilder = BytesBuilder();
    bytesBuilder.addByte(1);
    List<int> sellerNameBytes = utf8.encode(sellerName);
    bytesBuilder.addByte(sellerNameBytes.length);
    bytesBuilder.add(sellerNameBytes);

    //vat registration
    bytesBuilder.addByte(2);
    List<int> vat_registrationBytes = utf8.encode(vat_registration);
    bytesBuilder.addByte(vat_registrationBytes.length);
    bytesBuilder.add(vat_registrationBytes);

    //date
    bytesBuilder.addByte(3);
    List<int> date = utf8.encode(DateTime.now().toString().substring(0, 16));
    bytesBuilder.addByte(date.length);
    bytesBuilder.add(date);
    print(date);

    //invoice total
    bytesBuilder.addByte(4);
    List<int> invoiceTotals = utf8.encode(invoiceTotal);
    bytesBuilder.addByte(invoiceTotals.length);
    bytesBuilder.add(invoiceTotals);

    //vat total

    bytesBuilder.addByte(5);
    List<int> vatTotals = utf8.encode(vatTotal);
    bytesBuilder.addByte(vatTotals.length);
    bytesBuilder.add(vatTotals);
    Uint8List qrCodeAsBytes = bytesBuilder.toBytes();
    const Base64Encoder base64encoder = Base64Encoder();
    return base64encoder.convert(qrCodeAsBytes);
  }
  // updateSales(){
  //   print('ll');
  //   FirebaseFirestore.instance
  //       .collection('sales')
  //       .doc(currentBranchId)
  //       .collection('sales')
  //       .snapshots()
  //       .listen((event) {
  //     for(var sale in event.docs){
  //       print(sale.id);
  //       sale.reference
  //           .update({
  //         'currentUserId': currentUserId,
  //       });
  //     }
  //   });
  // }

  // getAlert(){
  //   FirebaseFirestore.instance.collection('orders')
  //       .orderBy('salesDate',descending: true)
  //       .where('status',isEqualTo: 0)
  //       .snapshots()
  //       .listen((event) {
  //     if(event.docs.isNotEmpty){
  //       print('mmm');
  //       for(var doc in event.docs){
  //         if(doc.get('orderId')!=null&&doc.get('status')==0){
  //           showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               title:  Text('Online Order'),
  //               content: Container(
  //                 height: MediaQuery.of(context).size.width*0.09,
  //                 padding: EdgeInsets.all(8),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(bottom: 10),
  //                       child: Text("You have received a new order",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 17
  //                         ),),
  //                     ),
  //                     Text("OrederId :${(doc.get('orderId'))}"),
  //                     Text("Customer Name :${(doc.get('name'))}"),
  //                   ],
  //                 ),
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                     Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderConfirmWidget(
  //                         orderId:doc.get('orderId'))));
  //
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         color: default_color,
  //                         borderRadius: BorderRadius.circular(7)
  //                     ),
  //                     padding: const EdgeInsets.all(14),
  //                     child: const Text("view",style: TextStyle(
  //                       color: Colors.white,
  //                     ),),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   });
  // }
  double? discount;
  double totalAmount = 0;
  List items = [];
  double gst = 0;
  double sum = 0;
  Stream? userStream;
  @override
  void initState() {
    super.initState();
    discountController = TextEditingController(text: '0');
    deliveryCharge = TextEditingController();
    tableController = TextEditingController();
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";

    List<String> nameSplits = caseNumber.split(" ");
    for (int i = 0; i < nameSplits.length; i++) {
      String name = "";

      for (int k = i; k < nameSplits.length; k++) {
        name = name + nameSplits[k] + " ";
      }
      temp = "";

      for (int j = 0; j < name.length; j++) {
        temp = temp + name[j];
        caseSearchList.add(temp.toUpperCase());
      }
    }
    return caseSearchList;
  }

  // getSettings() async {
  //   FirebaseFirestore.instance
  //       .collection('settings')
  //       .snapshots()
  //       .listen((value) {
  //     var data = value.docs;
  //     printWidth = double.tryParse(data[0]['logo']);
  //     qrCode = double.tryParse(data[0]['qr']);
  //     lastCut=data[0]['lastCut'];
  //     fontSize = double.tryParse(data[0]['fontSize']);
  //     size = double.tryParse(data[0]['size']);
  //     products = data[0]['product'];
  //     itemCount=data[0]['itemCount'];
  //     display_image=data[0]['display_image'];
  //     setState(() {
  //       print(products);
  //       print(display_image);
  //     });
  //   });
  // }
  // int token=0;
  // getToken() async {
  //   FirebaseFirestore.instance
  //       .collection('invoiceNo').doc(currentBranchId)
  //       .snapshots()
  //       .listen((value) {
  //     // var data = value.get('token');
  //     token=int.tryParse(value.get('token').toString());
  //
  //
  //     setState(() {
  //       print(token);
  //     });
  //   });
  // }
  // initSavetoPath() async {
  //   //read and write
  //   //image max 300px X 300px
  //   const filename = 'chickenhousebill_logo.png';
  //   const filename1 = 'print.png';
  //   var bytes = await rootBundle.load("assets/chickenhousebill_logo.png");
  //   var bytes1= await rootBundle.load("assets/awafi/print.png");
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   writeToFile(bytes, '$dir/$filename');
  //   writeToFile(bytes1, '$dir/$filename1');
  //   setState(() {
  //     topImage = '$dir/$filename';
  //     heading = '$dir/$filename1';
  //   });
  // }
  // Future<File> writeToFile(ByteData data, String path) {
  //   final buffer = data.buffer;
  //   return File(path).writeAsBytes(
  //       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }
  //
  // Future<void> initPlatformState() async {
  //   List<BluetoothDevice> devices = [];
  //
  //   try {
  //     devices = await bluetooth.getBondedDevices();
  //   } on PlatformException {
  //     // TODO - Error
  //   }
  //   bluetooth.onStateChanged().listen((state) {
  //     print("connect");
  //     switch (state) {
  //       case BlueThermalPrinter.CONNECTED:
  //         setState(() {
  //           _connected = true;
  //           _pressed = false;
  //         });
  //         break;
  //       case BlueThermalPrinter.DISCONNECTED:
  //         setState(() {
  //           _connected = false;
  //           _pressed = false;
  //         });
  //         break;
  //       default:
  //         break;
  //     }
  //   });
  //
  //   if (!mounted) return;
  //   setState(() {
  //     btDevices = devices;
  //   });
  // }
  //
  // getTables() async {
  //   FirebaseFirestore.instance.collection('tables')
  //       .doc(currentBranchId)
  //       .collection('tables')
  //       .orderBy('tableNo',descending:false)
  //       .snapshots().listen((event) {
  //     tables = [];
  //     for (DocumentSnapshot doc in event.docs) {
  //       tables.add(doc.get('name'));
  //     }
  //     // selectedTable = tables[0];
  //     if(mounted){
  //       setState(() {
  //
  //       });
  //     }
  //
  //   });
  // }
  //
  // void testReceipt(NetworkPrinter printer) {
  //   printer.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
  //       styles: const PosStyles(codeTable: 'CP1252'));
  //   printer.text('Special 2: blåbærgrød',
  //       styles: const PosStyles(codeTable: 'CP1252'));
  //
  //   printer.text('Bold text', styles: const PosStyles(bold: true));
  //   printer.text('Reverse text', styles: const PosStyles(reverse: true));
  //   printer.text('Underlined text',
  //       styles: const PosStyles(underline: true), linesAfter: 1);
  //   printer.text('Align left', styles: const PosStyles(align: PosAlign.left));
  //   printer.text('Align center', styles: const PosStyles(align: PosAlign.center));
  //   printer.text('Align right',
  //       styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
  //
  //   printer.text('Text size 200%',
  //       styles: const PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));
  //
  //   printer.feed(2);
  //   printer.cut();
  // }
  // List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
  //   List<DropdownMenuItem<BluetoothDevice>> items = [];
  //   if (btDevices.isEmpty) {
  //     print('             BLUETHOOTH DEVICES                   NO');
  //     items.add(const DropdownMenuItem(
  //       child: Text('NONE'),
  //     ));
  //   } else {
  //     print('             BLUETHOOTH DEVICES                   BLU');
  //     btDevices.forEach((device) {
  //       items.add(DropdownMenuItem(
  //         child: Text(device.name),
  //         value: device,
  //       ));
  //     });
  //   }
  //   return items;
  // }
  // Future show(
  //     String message, {
  //       Duration duration: const Duration(seconds: 3),
  //     }) async {
  //   await  Future.delayed( const Duration(milliseconds: 100));
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content:  Text(
  //         message,
  //         style:  const TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       duration: duration,
  //     ),
  //   );
  // }
  // void btConnect() {
  //
  //   if (device == null) {
  //     show('No device selected.');
  //   } else {
  //     bluetooth.isConnected.then((isConnected) {
  //       print("here");
  //       if (!isConnected) {
  //         bluetooth.connect(device).catchError((error) {
  //           print(error);
  //           setState((){pressed = false;
  //           connected=false;
  //           });
  //         });
  //         setState((){pressed = true;
  //         connected=true;
  //         });
  //       }
  //       else{
  //         setState((){pressed = true;
  //         connected=true;
  //         });
  //       }
  //       Navigator.pop(context);
  //
  //     }
  //     );
  //   }
  // }
  // void _disconnect() {
  //   bluetooth.disconnect();
  //   setState(() => pressed = true);
  //
  // }
  // set(){
  //   setState(() {
  //
  //   });
  // }
  List total = [];

  TextEditingController number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('=============');
    print(currentUser.toString());
    return Scaffold(
        drawer: Drawer(

            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.deepPurple,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'User Name :      ',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currentUser!,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Text('id :     '+currentUserId!, style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeBody()),
                );
              },
              child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.home),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'HOME',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.deepPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Report()),
                );
              },
              child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  width: double.infinity,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.note_alt),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'REPORT',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.deepPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            // InkWell(
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (context) => SalesReturnReport()),
            //     // );
            //   },
            //   child: Container(
            //       padding: const EdgeInsets.only(right: 10),
            //       width: double.infinity,
            //       height: 45,
            //       decoration: const BoxDecoration(
            //         color: Colors.white,
            //       ),
            //       child: Align(
            //         alignment: AlignmentDirectional.centerEnd,
            //         child: Text(
            //           'RETURN REPORT',
            //           style: TextStyle(
            //             fontFamily: 'Poppins',
            //             color: Colors.deepPurple,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       )),
            // ),
            // InkWell(
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //       builder: (context) => const ExpenseReport()),
            //     // );
            //   },
            //   child: Container(
            //       padding: const EdgeInsets.only(right: 10),
            //       width: double.infinity,
            //       height: 45,
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //       ),
            //       child: Align(
            //         alignment: AlignmentDirectional.centerEnd,
            //         child: Text(
            //           'EXPENSE REPORT',
            //           style: TextStyle(
            //             fontFamily: 'Poppins',
            //             color: Colors.deepPurple,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       )),
            // ),
            // InkWell(
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //       builder: (context) => const PurchaseReport()),
            //     // );
            //   },
            //   child: Container(
            //       padding: const EdgeInsets.only(right: 10),
            //       width: double.infinity,
            //       height: 45,
            //       decoration: const BoxDecoration(
            //         color: Colors.white,
            //       ),
            //       child: Align(
            //         alignment: AlignmentDirectional.centerEnd,
            //         child: Text(
            //           'PURCHASE REPORTS',
            //           style: TextStyle(
            //             fontFamily: 'Poppins',
            //             color: Colors.deepPurple,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       )),
            // ),
            // InkWell(
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (context) => DailyReportsWidget()),
            //     // );
            //   },
            //   child: Container(
            //       padding: const EdgeInsets.only(right: 10),
            //       width: double.infinity,
            //       height: 45,
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //       ),
            //       child: Align(
            //         alignment: AlignmentDirectional.centerEnd,
            //         child: Text(
            //           'DAILY REPORTS',
            //           style: TextStyle(
            //             fontFamily: 'Poppins',
            //             color: Colors.deepPurple,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       )),
            // ),
            InkWell(
              onTap: () async {
                SharedPreferences? preferences =
                    await SharedPreferences.getInstance();
                preferences.remove('userId');
                preferences.remove('userName');
                currentUserId = '';
                currentUser = '';
                await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (r) => false,
                );
              },
              child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 50),
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'LOG OUT',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.deepPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        )),
        body:
            // !connected?AlertDialog(
            //
            //   content: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: <Widget>[
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           const Text(
            //             'Device:',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           DropdownButton(
            //             items: _getDeviceItems(),
            //             onChanged: (value) => setState(() => device = value),
            //             value: device,
            //           ),
            //           RaisedButton(
            //             onPressed:
            //             pressed ? null : connected ? _disconnect : btConnect,
            //             child: Text(connected ? 'Disconnect' : 'Connect'),
            //           ),
            //
            //         ],
            //       ),
            //       RaisedButton(
            //         onPressed:() async {
            //           if(connected ){
            //
            //
            //           }else{
            //
            //           }
            //         },
            //         child: const Text('Print'),
            //       ),
            //
            //     ],
            //   ),
            // ):
            Builder(
          builder: (context) => Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.deepPurple,

                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage("assets/awafi/coffeeappbar.jpg"),fit: BoxFit.cover
                        //     )
                        // ),
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: const EdgeInsets.only(right: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: Icon(Icons.menu)),
                            Text(
                              'TharaCart',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            // Text(
                            //   'Total Item :'+items.length.toString(),
                            //   style: const TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 18),
                            // ),

                            search == true
                                ? IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        search = false;

                                        searchController.clear();
                                      });
                                      print(search);
                                    },
                                    icon: Icon(Icons.search_off_rounded))
                                : IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        search = true;
                                      });
                                    },
                                    icon: Icon(Icons.search))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: const BoxDecoration(),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            offset: const Offset(
                                              0.0,
                                              -1.0,
                                            ),
                                            blurRadius: 20.0,
                                            spreadRadius: 1.0,
                                          ), //BoxShadow
                                          //BoxShadow
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            color: Colors.grey.shade200,
                                            child: Row(
                                              children: const [
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                      child: Text(
                                                    "NO:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Center(
                                                      child: Text(
                                                    "NAME",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Center(
                                                      child: Text(
                                                    "PRICE",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                      child: Text(
                                                    "QTY",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                      child: Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child:
                                                StreamBuilder<DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('posUser')
                                                        .doc(currentUserId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      items = [];
                                                      // itemList=[];
                                                      double tax = 0;
                                                      double discount = 0;

                                                      if (!snapshot.hasData) {
                                                        return Container();
                                                      }
                                                      totalAmount = 0;
                                                      sum = 0;
                                                      gst = 0;
                                                      if (snapshot.data
                                                              ?.get('bag') !=
                                                          null) {
                                                        items = snapshot.data
                                                            ?.get('bag');
                                                        print('sdfsdfsdfsd');
                                                        print(items.length);
                                                        for (dynamic item
                                                            in snapshot.data
                                                                ?.get('bag')) {
                                                          sum = ((item[
                                                                      'price']) *
                                                                  (item[
                                                                      'qty'])) +
                                                              sum;
                                                          tax = item['gst']
                                                              .toDouble();
                                                          gst = (gst +
                                                              (item['qty'] *
                                                                  ((item['price']) *
                                                                      tax /
                                                                      (100 +
                                                                          tax))))!;
                                                          totalAmount = (totalAmount! +
                                                              (item['qty'] *
                                                                  (item['price'] *
                                                                      100 /
                                                                      (100 +
                                                                          tax))))!;
                                                        }
                                                      }
                                                      return SingleChildScrollView(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                // child:  Container(),
                                                                child: keyboard
                                                                    ? Container()
                                                                    : BillWidget(
                                                                        items: snapshot
                                                                            .data
                                                                            ?.get('bag'),
                                                                      ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        20,
                                                                        10,
                                                                        20,
                                                                        0),
                                                                color: Colors
                                                                    .blueGrey
                                                                    .shade100,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Price",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        Text(
                                                                          "Price Excl.(GST)",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        Text(
                                                                          "GST",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        Text(
                                                                          "Discount",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          "Grand Total",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          "₹ $sum",
                                                                          // double.tryParse(discount) ==
                                                                          //     null
                                                                          //     ? "0.00"
                                                                          //     : "SR ${double.tryParse(discount).toStringAsFixed(2)}",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        Text(
                                                                          '₹ ' +
                                                                              totalAmount!.toStringAsFixed(2),
                                                                          // double.tryParse(discount) ==
                                                                          //     null
                                                                          //     ? "0.00"
                                                                          //     : "SR ${double.tryParse(discount).toStringAsFixed(2)}",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        Text(
                                                                          '₹ ' +
                                                                              gst.toStringAsFixed(2),
                                                                          // double.tryParse(discount) ==
                                                                          //     null
                                                                          //     ? "0.00"
                                                                          //     : "SR ${double.tryParse(discount).toStringAsFixed(2)}",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        Text(
                                                                          '₹ ' +
                                                                              discountController.text,
                                                                          // " SR ${(totalAmount * gst /(100+gst)).toStringAsFixed(2)}",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          "₹ ${(sum! - double.tryParse(discountController.text)!).toStringAsFixed(2)}",
                                                                          // "SR ${(totalAmount - (double.tryParse(discount) ?? 0)+(double.tryParse(delivery) ??0)).toStringAsFixed(2)}",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.grey.shade700),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      );
                                                    }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: const [
                                            Expanded(
                                              child: Text(
                                                "DISCOUNT  :",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 45,
                                                child: TextFormField(
                                                  onEditingComplete: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    discount = double.tryParse(
                                                        discountController
                                                            .text);
                                                    setState(() {
                                                      keyboard = false;
                                                    });
                                                  },
                                                  onTap: () {
                                                    setState(() {
                                                      keyboard = true;
                                                    });
                                                  },
                                                  controller:
                                                      discountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      // labelText: 'DISCOUNT',
                                                      hoverColor:
                                                          Colors.black12,
                                                      hintText: 'Discount',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .pink.shade900,
                                                            width: 1.0),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.all(5)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  keyboard = false;
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  discount = double.tryParse(
                                                      discountController.text);
                                                });
                                              },
                                              child: Container(
                                                width: 100,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                  child: Text(
                                                    "ENTER",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  keyboard = false;
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  discountController.text = '0';
                                                });
                                              },
                                              child: Container(
                                                width: 100,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                  child: Text(
                                                    "Clear",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: const BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              offset: const Offset(
                                                0.0,
                                                -1.0,
                                              ),
                                              blurRadius: 20.0,
                                              spreadRadius: 1.0,
                                            ), //BoxShadow
                                            //BoxShadow
                                          ],
                                        ),
                                        child: ItemsPage()
                                        //     // :
                                        // Container(),
                                        // child: const ItemsPage(),
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // FFButtonWidget(
                                        //   onPressed: () async {
                                        //     DocumentSnapshot invoiceNoDoc =
                                        //         await FirebaseFirestore.instance
                                        //             .collection('invoiceNo')
                                        //             .doc('XaGJz72DaZdJ4S9g7PkO')
                                        //             .get();
                                        //     FirebaseFirestore.instance
                                        //         .collection('invoiceNo')
                                        //         .doc('XaGJz72DaZdJ4S9g7PkO')
                                        //         .update({
                                        //       'pickUp': FieldValue.increment(1),
                                        //     });
                                        //     int invoiceNo =
                                        //         invoiceNoDoc.get('pickUp');
                                        //     invoiceNo++;
                                        //     await FirebaseFirestore.instance
                                        //         .collection('pickUpOrders')
                                        //         .doc(invoiceNo.toString())
                                        //         .set({
                                        //       'date': DateTime.now(),
                                        //       'discount': double.tryParse(discountController.text),
                                        //       'price': sum,
                                        //       'bag': items,
                                        //       'totalEx':totalAmount,
                                        //       'id': invoiceNo.toString(),
                                        //       'grandTotal':
                                        //     (sum! - double.tryParse(discountController.text)!).toStringAsFixed(2),
                                        //     });
                                        //     await FirebaseFirestore.instance
                                        //         .collection('posUser')
                                        //         .doc(currentUserId)
                                        //         .update({'bag': []});
                                        //     setState(() {
                                        //       discountController.text = '0';
                                        //       discount = 0.00;
                                        //       gst=0;
                                        //     });
                                        //     showUploadMessage(
                                        //         context, 'Saved Successfully');
                                        //   },
                                        //   text: 'SAVE',
                                        //   options: FFButtonOptions(
                                        //     width: 100,
                                        //     height: 70,
                                        //     color: Colors.green.shade700,
                                        //     textStyle: TextStyle(
                                        //       fontFamily: 'Overpass',
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w800,
                                        //     ),
                                        //     elevation: 10,
                                        //     borderSide: BorderSide(
                                        //       color: Colors.grey,
                                        //       width: 1,
                                        //     ),
                                        //     borderRadius: 12,
                                        //   ),
                                        // ),
                                        InkWell(
                                          onTap: () async {
                                            if (items.isEmpty) {
                                              return null;
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('posUser')
                                                  .doc(currentUserId)
                                                  .update({'bag': []});
                                              setState(() {
                                                discountController.text = '0';
                                                discount = 0.00;
                                                gst = 0;
                                              });
                                              showUploadMessage(
                                                  context, 'Cancelled');
                                            }
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: Colors.red),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.delete,
                                                  size: 35,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "CANCEL",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (items.isEmpty) {
                                              showUploadMessage(context,
                                                  'select atleast one item');
                                            } else {
                                              await showDialog(
                                                  context: context,
                                                  builder: (BuildContext) {
                                                    return StatefulBuilder(
                                                        builder: (dialogcontext,
                                                            setState) {
                                                      return AlertDialog(
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: 350,
                                                                height: 70,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xFFE6E6E6),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          16,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      TextFormField(
                                                                    maxLength:
                                                                        10,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    controller:
                                                                        number,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Customer Number',
                                                                      labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              12),
                                                                      hintText:
                                                                          'Enter Mobile Number',
                                                                      hintStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              12),
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(4.0),
                                                                          topRight:
                                                                              Radius.circular(4.0),
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(4.0),
                                                                          topRight:
                                                                              Radius.circular(4.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        color: Color(
                                                                            0xFF8B97A2),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                ),
                                                              ),
                                                              StreamBuilder<
                                                                      QuerySnapshot>(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .where(
                                                                          'mobileNumber',
                                                                          isEqualTo: number
                                                                              .text
                                                                              .toUpperCase())
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Text(
                                                                          'no users');
                                                                    }
                                                                    List? data =
                                                                        snapshot
                                                                            .data
                                                                            ?.docs;
                                                                    if (data!
                                                                        .isEmpty) {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            24,
                                                                            0,
                                                                            44),
                                                                        child:
                                                                            FFButtonWidget(
                                                                          onPressed:
                                                                              () async {
                                                                            if (number.text !=
                                                                                '') {
                                                                              bool pressed = await alert(context, 'Accept Order');
                                                                              if (pressed) {
                                                                                DocumentSnapshot invoiceNoDoc = await FirebaseFirestore.instance.collection('invoiceNo').doc('XaGJz72DaZdJ4S9g7PkO').get();
                                                                                FirebaseFirestore.instance.collection('invoiceNo').doc('XaGJz72DaZdJ4S9g7PkO').update({
                                                                                  'pickUp': FieldValue.increment(1),
                                                                                });
                                                                                int invoiceNo = invoiceNoDoc.get('pickUp');
                                                                                invoiceNo++;
                                                                                await FirebaseFirestore.instance.collection('pickUpOrders').doc(invoiceNo.toString()).set({
                                                                                  'name': 'Walking Customer',
                                                                                  'mobileNumber': number.text,
                                                                                  'date': DateTime.now(),
                                                                                  'discount': double.tryParse(discountController.text),
                                                                                  'price': sum,
                                                                                  'bag': items,
                                                                                  'totalEx': totalAmount,
                                                                                  'id': invoiceNo.toString(),
                                                                                  'userId': currentUserId,
                                                                                  'grandTotal': (sum! - double.tryParse(discountController.text)!).toStringAsFixed(2),
                                                                                });
                                                                                await FirebaseFirestore.instance.collection('posUser').doc(currentUserId).update({
                                                                                  'bag': []
                                                                                });
                                                                                setState(() {
                                                                                  discountController.text = '0';
                                                                                  discount = 0.00;
                                                                                  gst = 0;
                                                                                });
                                                                                Navigator.pop(context);
                                                                                showUploadMessage(context, 'Saved Successfully');
                                                                              }
                                                                            } else {
                                                                              number.text == '' ? showUploadMessage(context, 'Please enter mobile Number') : '';
                                                                            }
                                                                          },
                                                                          text:
                                                                              'Save',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.3,
                                                                            height:
                                                                                70,
                                                                            color:
                                                                                Colors.deepPurple,
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontFamily: 'Lexend Deca',
                                                                              color: Colors.white,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            elevation:
                                                                                2,
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.transparent,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    return Container(
                                                                      height:
                                                                          300,
                                                                      width:
                                                                          500,
                                                                      child: ListView.builder(
                                                                          physics: ClampingScrollPhysics(),
                                                                          shrinkWrap: true,
                                                                          padding: EdgeInsets.only(top: 30),
                                                                          itemCount: data?.length,
                                                                          itemBuilder: (context, index) {
                                                                            return InkWell(
                                                                              onTap: () async {
                                                                                bool pressed = await alert(context, 'Accept Order.');
                                                                                if (pressed) {
                                                                                  DocumentSnapshot invoiceNoDoc = await FirebaseFirestore.instance.collection('invoiceNo').doc('XaGJz72DaZdJ4S9g7PkO').get();
                                                                                  FirebaseFirestore.instance.collection('invoiceNo').doc('XaGJz72DaZdJ4S9g7PkO').update({
                                                                                    'pickUp': FieldValue.increment(1),
                                                                                  });
                                                                                  int invoiceNo = invoiceNoDoc.get('pickUp');
                                                                                  invoiceNo++;
                                                                                  FirebaseFirestore.instance.collection('pickUpOrders').doc(invoiceNo.toString()).set({
                                                                                    'name': data[index]['fullName'],
                                                                                    'mobileNumber': data[index]['mobileNumber'],
                                                                                    'date': DateTime.now(),
                                                                                    'discount': double.tryParse(discountController.text),
                                                                                    'price': sum,
                                                                                    'bag': items,
                                                                                    'totalEx': totalAmount,
                                                                                    'id': invoiceNo.toString(),
                                                                                    'userId': currentUserId,
                                                                                    'grandTotal': (sum! - double.tryParse(discountController.text)!).toStringAsFixed(2),
                                                                                  });
                                                                                  await FirebaseFirestore.instance.collection('posUser').doc(currentUserId).update({
                                                                                    'bag': []
                                                                                  });
                                                                                  setState(() {
                                                                                    discountController.text = '0';
                                                                                    discount = 0.00;
                                                                                    gst = 0;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                  showUploadMessage(context, 'Saved Successfully');
                                                                                }
                                                                              },
                                                                              child: SizedBox(
                                                                                height: 120,
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(18),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Color(0xff000000).withOpacity(0.15),
                                                                                        blurRadius: 4,
                                                                                        spreadRadius: 0,
                                                                                        offset: Offset(
                                                                                          0,
                                                                                          4,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  margin: const EdgeInsets.all(10),
                                                                                  child: ListTile(
                                                                                    title: Center(
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Text('Name :  ' + data![index]['fullName'].toString().toUpperCase(), style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600)),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Text('Mobile Number : ' + data![index]['mobileNumber'].toString().toUpperCase(), style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    // leading: Text('${index+1}'),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    );
                                                                  }),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  });
                                            }
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade700,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 35,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "SALE",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildList(List<Map<String, dynamic>> devices) {
    return devices
        .map((device) => ListTile(
              onTap: () {
                // _connect(int.parse(device['vendorId']),
                //     int.parse(device['productId']));
              },
              leading: const Icon(Icons.usb),
              title: Text(device['manufacturer'] + " " + device['productName']),
              subtitle: Text(device['vendorId'] + " " + device['productId']),
            ))
        .toList();
  }
}
