import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'global.dart';
import 'login.dart';

int qty = 0;
Map<String, dynamic> addOn = {};
List newAddOn = [];
Map<String, dynamic> selectedItems = {};
Map<String, dynamic> originalSelectedItems = {};
String? currentProduct;

class ProductCard extends StatefulWidget {
  final String? name;

  final String? pid;
  final String? imageUrl;
  final Function? set;

  var price;

  var gst;

  ProductCard({
    this.name,
    this.set,
    this.imageUrl,
    this.pid,
    this.price,
    this.gst,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State> keyLoader = GlobalKey<State>();
  // final UserService _userService = UserService();
  // final ShoppingBagService _shoppingBagService = ShoppingBagService();
  int counter = 0;
  // Future<void> compressImage(File file) async {
  //   final result = await FlutterImageCompress.compressWithFile(
  //     widget.imageUrl,
  //     quality: 50,
  //   );
  //
  //   // The compressed image is now stored in the 'result' variable.
  //   // You can use it however you like, such as uploading it to a server.
  // }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counter++;
    });
  }

  int totalReviews = 0;
  double avgRating = 0;
  int _itemCount = 1;
  bool? userLiked;
  bool exist = false;
  // NewProductsRecord product;
  late Map<String, dynamic> currentItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // product=widget.gridViewProductsRecord;
    if (counter == 0) {
      qty = counter;
    }
  }

  // bucketExistence() {
  //   String uid = currentUserModel.id;
  //   List bag = currentUserModel.bag;
  //   for (int i = 0; i < bag.length; i++) {
  //     Map<String, dynamic> item = bag[i];
  //
  //     if (item['id'] == product.productId &&
  //         item['size'] == "" &&
  //         item['color'] == "" &&
  //         item['cut'] == "" &&
  //         item['unit'] == product.unit &&
  //         item['quantity'] == 1.00) {
  //       setState(() {
  //         exist = true;
  //         currentItem = item;
  //       });
  //       break;
  //     } else {
  //       setState(() {
  //         exist = false;
  //       });
  //     }
  //   }
  // }
  //
  // Future getReviews() async {
  //   double totalRating = 0;
  //   try {
  //     double totRating = 0;
  //
  //     int noRating = product.ones +
  //         product.twos +
  //         product.threes +
  //         product.fours +
  //         product.fives;
  //     totRating = (1.00 * product.ones) +
  //         (2.00 * product.twos) +
  //         (3.00 * product.threes) +
  //         (4.00 * product.fours) +
  //         (5.00 * product.fives);
  //
  //     setState(() {
  //       totalReviews = noRating;
  //
  //       avgRating = noRating == 0 ? 0 : (totRating / noRating);
  //     });
  //   } catch (exception) {
  //     print(exception.toString());
  //   }
  // }

  set() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // List allList=[];
        // List items=[];
        // int qty=1;
        // DocumentSnapshot pdt=await FirebaseFirestore.instance.collection('posUser').doc(currentUserId).get();
        // allList=pdt['bag'];
        //
        // bool contain=false;
        //
        // for(var a in allList){
        //   if(a['pdtName']==widget.name){
        //     qty=int.tryParse(a['qty'].toString())!;
        //     contain=true;
        //     print("qtyyyyyyyy $qty $contain");
        //   }
        // }
        //
        // if(!contain){
        //   items.add({
        //     'gst':widget.gst,
        //     "pdtName":widget.name,
        //     "qty":1,
        //     "price":widget.price,
        //   });
        //   FirebaseFirestore.instance.collection('posUser').doc(currentUserId).update(
        //       {
        //         'bag':FieldValue.arrayUnion(items)
        //       });
        // }else{
        //   FirebaseFirestore.instance.collection('posUser').doc(currentUserId).update(
        //       {
        //         'bag':FieldValue.arrayRemove([{
        //           'gst':widget.gst,
        //           "pdtName":widget.name,
        //           "qty":qty,
        //           "price":widget.price,
        //         }])
        //       });
        //   FirebaseFirestore.instance.collection('posUser').doc(currentUserId).update(
        //       {
        //         'bag':FieldValue.arrayUnion([{
        //           'gst':widget.gst,
        //           "pdtName":widget.name,
        //           "qty":qty+1,
        //           "price":widget.price,
        //         }])
        //       });
        // }
        print("test");
        print(widget.name);
        print("test");

        List allList = [];
        bool contain = false;
        int qty = 1;
        int index = 0;
        Map currentProduct = {};

        DocumentSnapshot pdt = await FirebaseFirestore.instance
            .collection('posUser')
            .doc(currentUserId)
            .get();
        allList = pdt['bag'];
        int i = 0;
        for (var a in allList) {
          if (a['pdtName'] == widget.name) {
            index = i;
            qty = int.tryParse(a['qty'].toString())!;
            currentProduct = a;
            contain = true;
            break;
          }
          i++;
        }

        if (contain) {
          allList.removeAt(index);
          currentProduct['qty'] = qty + 1;
          allList.insert(index, currentProduct);
        } else {
          allList.add({
            'gst': widget.gst,
            "pdtName": widget.name,
            "qty": 1,
            "price": widget.price,
          });
        }

        FirebaseFirestore.instance
            .collection('posUser')
            .doc(currentUserId)
            .update({'bag': allList});

        setState(() {});
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        elevation: 10,
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(0),
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child:
                          // display_image
                          //     ?
                          CachedNetworkImage(
                        // memCacheHeight:10,
                        // memCacheWidth:10,
                        // filterQuality: FilterQuality.low,
                        // maxWidthDiskCache:30,
                        // maxHeightDiskCache:30,

                        // placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while the image is loading
                        errorWidget: (context, url, error) => Icon(Icons
                            .error), // Placeholder for failed image loading
                        cacheKey: widget.imageUrl, // Set a custom cache key
                        memCacheWidth:
                            200, // Set a custom width for memory cache
                        memCacheHeight:
                            100, // Set a custom height for memory cache
                        httpHeaders: {}, // Set custom headers for network requests
                        useOldImageOnUrlChange:
                            true, // Use old image when the URL changes
                        // fadeInDuration: Duration(milliseconds: 500), // Set fade-in duration
                        // fadeInCurve: Curves.easeIn, // Set fade-in curve
                        // fadeOutDuration: Duration(milliseconds: 500), // Set fade-out duration
                        // fadeOutCurve: Curves.easeOut, // Set fade-out curve

                        imageUrl: widget.imageUrl ?? '',
                        fit: BoxFit.fill,
                        width: 300,
                      )
                      // : Container(
                      //     padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                      //     child: Container(
                      //       color: Colors.blueGrey.shade100,
                      //     ),
                      //   ),
                      ),
                ),
              ),
              // Row(
              //   children: [
              //     RatingBar(
              //       ignoreGestures: true,
              //       itemSize: 10,
              //       glow: true,
              //       allowHalfRating: true,
              //       initialRating: avgRating,
              //       itemPadding: EdgeInsets.symmetric(
              //           horizontal: 0.0),
              //       ratingWidget: RatingWidget(
              //         empty: Icon(Icons.star_border,
              //             color: Colors.grey,
              //             size: 25.w),
              //         full: Icon(
              //           Icons.star,
              //           color: Colors.amber,
              //           size: 25.w,
              //         ),
              //         half: Icon(
              //           Icons.star_half,
              //           color: Colors.amber,
              //           size: 25.w,
              //         ),
              //       ),
              //     ),
              //     Text(" ($totalReviews) ",style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontSize: 18.w),)
              //   ],
              // ),
              AutoSizeText(
                widget.name ?? '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.008,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(
              //   widget.gridViewProductsRecord.shopName,
              //   style: TextStyle(
              //     color:Colors.red,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 26.w,
              //   ),
              // ),
              Text('₹ ' + widget.price.toString(),
                  style: TextStyle(
                      color: Color(0xFF33CC33),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),

              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: new Text(msg),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            if (mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
            }
          },
        ),
      ),
    );
  }

  // addToShoppingBag() async {
  //   String msg = await _shoppingBagService.add(
  //       widget.pid,
  //       widget.name,
  //       "",
  //       "",
  //       "",
  //       1.00,
  //
  //   bucketExistence();
  //
  //   widget.set!();
  //   setState(() {});
  // }
}

// class Box extends StatefulWidget {
//   List? varList;
//   String? name;
//   double? discountPrice;
//   String? arabicName;
//   List? addOns;
//   Box(
//       {Key? key,
//       this.varList,
//       this.name,
//       this.discountPrice,
//       this.arabicName,
//       this.addOns})
//       : super(key: key);
//
//   @override
//   _BoxState createState() => _BoxState();
// }
//
// class _BoxState extends State<Box> {
//   int? selectedIndex;
//   double selectedvariantPrice = 0;
//   String selectedvariantName = '';
//   String selectedvariantArName = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: AlertDialog(
//         title: const Text("Choose Variant"),
//         content: Container(
//           width: MediaQuery.of(context).size.width * 0.2,
//           height: MediaQuery.of(context).size.height * 0.2,
//           child: ListView.builder(
//             padding: EdgeInsets.zero,
//             scrollDirection: Axis.vertical,
//             itemCount: widget.varList?.length,
//             physics: BouncingScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, int index) {
//               return Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = index;
//                       selectedvariantPrice =
//                           double.tryParse(widget.varList![index]['price'])!;
//                       selectedvariantName = widget.varList![index]['variant'];
//                       selectedvariantArName =
//                           widget.varList![index]['variantArabic'];
//                       print(selectedvariantPrice);
//                     });
//                   },
//                   child: Container(
//                     color: selectedIndex != index
//                         ? Colors.white
//                         : Colors.blueGrey.shade200,
//                     width: MediaQuery.of(context).size.width * 0.15,
//                     height: 30,
//                     // child: RadioListTile(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           ' ${widget.varList![index]['variant']}',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           ' ${widget.varList![index]['price']}',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               child: Text("Cancel",
//                   style: TextStyle(fontSize: 17, color: Colors.red)),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               if (selectedIndex != null) {
//                 print(selectedvariantPrice);
//                 bool notInCart = true;
//                 currentProduct = widget.name;
//                 for (Map<String, dynamic> item in itemList) {
//                   if (item['pdtname'] == widget.name &&
//                       item['price'] == widget.discountPrice) {
//                     print(selectedvariantPrice);
//                     print('TRUE TRUE TRUE TRUE');
//                     notInCart = false;
//                     FirebaseFirestore.instance
//                         .collection('tables')
//                         // .doc(currentBranchId)
//                         // .collection('tables')
//                         .doc(selectedTable)
//                         .update({
//                       'items': FieldValue.arrayRemove([
//                         {
//                           'pdtname': '${widget.name} $selectedvariantName',
//                           'arabicName':
//                               '${widget.arabicName} $selectedvariantArName',
//                           'price': selectedvariantPrice,
//                           'qty': item['qty'],
//                           'addOns': [],
//                           'addOnArabic': [],
//                           'addOnPrice': 0.0,
//                         }
//                       ])
//                     });
//                     FirebaseFirestore.instance
//                         .collection('tables')
//                         // .doc(currentBranchId)
//                         // .collection('tables')
//                         .doc(selectedTable)
//                         .update({
//                       'items': FieldValue.arrayUnion([
//                         {
//                           'pdtname': '${widget.name} $selectedvariantName',
//                           'arabicName':
//                               '${widget.arabicName} $selectedvariantArName',
//                           'price': selectedvariantPrice,
//                           'qty': item['qty'] + 1,
//                           'addOns': [],
//                           'addOnArabic': [],
//                           'addOnPrice': 0.0,
//                           'variants': widget.varList,
//                         }
//                       ])
//                     });
//                   }
//                 }
//                 if (notInCart) {
//                   FirebaseFirestore.instance
//                       .collection('tables')
//                       .doc(currentBranchId)
//                       .collection('tables')
//                       .doc(selectedTable)
//                       .update({
//                     'items': FieldValue.arrayUnion([
//                       {
//                         'pdtname': '${widget.name} $selectedvariantName',
//                         'price': selectedvariantPrice,
//                         'qty': 1,
//
//                       }
//                     ])
//                   });
//
//                 }
//
//                 Navigator.of(context).pop();
//               }
//               showUploadMessage(context, 'please select variant');
//             },
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               child: Text("Done",
//                   style: TextStyle(fontSize: 17, color: Colors.blue)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
