import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thara_pickup_orders/product_card.dart';

import 'homePage.dart';
// List data=[];
TextEditingController searchController = TextEditingController();
class ItemsPage extends StatefulWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> with TickerProviderStateMixin {
  TextEditingController? textController;
  // TextEditingController? searchController;
  final pageViewController1 = PageController();
  final pageViewController2 = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();

  }

 Stream? userStream;
  // var pData;
  @override
  Widget build(BuildContext context) {
    return search==true?
    SizedBox(
      height: 350,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search Products'
                    ),
                    controller: searchController,
                    onFieldSubmitted: (value){
                      // if(value==''){
                      //   userStream = FirebaseFirestore.instance
                      //       .collection("products").where('available',isEqualTo: false)
                      //       .snapshots();
                      //   setState(() {});
                      // }else{
                        userStream = FirebaseFirestore.instance
                            .collection("products").where('available',isEqualTo: false)
                            .where('search',
                            arrayContains: searchController?.text.toUpperCase())
                            .snapshots();
                        setState(() {});
                      // }
                    },
                  ),
                ),
                ElevatedButton(onPressed: (){
                  searchController.clear();
                  userStream = FirebaseFirestore.instance
                      .collection("products").where('available',isEqualTo: false)
                      .where('search',
                      arrayContains: searchController?.text.toUpperCase())
                      .snapshots();


                  setState(() {
                    // pData=[];
                  });
                }, child: Text('clear'))
              ],
            ),
            StreamBuilder(
              stream: userStream,
              builder: (context, snapshot) {
                print("Test SNa ${snapshot.data}");
                print("Test SNa ${snapshot.error}");
                if(!snapshot.hasData){
                  return Text('empty');
                }else

                if(snapshot.data.docs.isEmpty){
                  return Text('No Products');
                }
                var pData = snapshot.data!.docs;
                print(pData);
                print("testing");

                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.white,
                  child: GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: pData?.length,
                    itemBuilder: (context, int index) {
                      print(pData?.length);
                      print('==========');
                      return
                        ProductCard(
                            gst:pData![index]['gst'],
                            name: pData![index]['name'],
                            imageUrl: pData[index]['imageId'].isEmpty?'':pData[index]['imageId'][0],
                            pid: pData[index]['productId'],
                            price:pData[index]['b2cP']==0?pData[index]['b2bP']:pData[index]['b2cP']

                        );
                    },
                  ),
                );
              }
            )
          ],
        ),
      ),
    )
     :StreamBuilder(
       stream:
           FirebaseFirestore.instance.collection('category').snapshots(),
       builder: (context, snapshot) {
         // Customize what your widget looks like when it's loading.
         if (!snapshot.hasData) {
           return const Center(child: CircularProgressIndicator());
         }
         var tabBarCategoryRecordList = snapshot.data?.docs;
         _tabController = TabController(
           vsync: this,
           length: tabBarCategoryRecordList!.length! + 1,
         );
         List<Widget> tabList = [];
         List<Widget> tabPages = [];

         for (var a in tabBarCategoryRecordList!) {
           tabList.add(SizedBox(
             width: 120,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Container(
                     height: 50,
                     width: 50,
                     decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(width: 2, color: Colors.black),
                         image: DecorationImage(
                             image: CachedNetworkImageProvider(
                              a['imageUrl'],
                             ),
                             fit: BoxFit.fill)
                     )
                     // ,child: CachedNetworkImage(imageUrl: a['imageUrl'],fit: BoxFit.fill),
                 ),
                 const SizedBox(
                   height: 3,
                 ),
                 Text(
                  a['name'],
                   style: const TextStyle(fontSize: 12),
                   textAlign: TextAlign.center,
                 ),
               ],
             ),
           ));
           tabPages.add(tabPage(a['categoryId'],));
         }

         // Customize what your widget looks like with no query results.
         if (tabBarCategoryRecordList.isEmpty) {
           return const SizedBox(
             height: 100,
             child: Center(
               child: Text('No results.'),
             ),
           );
         }

         return DefaultTabController(
           length: tabPages.length,
           child: Column(
             children: [
               Container(
                 height: 100,
                 width: double.infinity,
                 padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                 decoration: BoxDecoration(
                   color: Colors.grey.shade100,
                   boxShadow: const [
                     BoxShadow(
                       offset: Offset(2, 2),
                       blurRadius: 5,
                       color: Colors.black,
                     )
                   ],
                 ),
                 child: Center(
                   child: TabBar(
                     onTap: (index) {
                       setState(() {
                         // DefaultTabController.of(context).animateTo(index);
                       });
                     },
                     labelPadding: const EdgeInsets.only(left: 15),
                     labelStyle: const TextStyle(
                         fontWeight: FontWeight.bold, fontSize: 18),
                     unselectedLabelStyle: const TextStyle(
                         fontWeight: FontWeight.w400, fontSize: 12),
                     labelColor: Colors.red.shade900,
                     indicatorColor: Colors.pink.shade100,
                     indicatorWeight: 1,
                     unselectedLabelColor: Colors.black,
                     tabs: tabList,
                     isScrollable: true,
                   ),
                 ),
               ),
               Expanded(
                 child: TabBarView(
                   children: tabPages,
                 ),
               ),
             ],
           ),
         );
       },
     );
  }

  Widget tabPage(String categoryName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products').where('available',isEqualTo: false)
          .where('category', isEqualTo: categoryName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        // Customize what your widget looks like with no query results.
        var data = snapshot.data?.docs;
        print(data);
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                color: Colors.white,
                child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: data?.length,
                  itemBuilder: (context, int index) {
                    print(data?.length);
                    print('==========');
                    return
                      ProductCard(
                        gst:data![index]['gst'],
                      name: data![index]['name'],
                      imageUrl: data[index]['imageId'].isEmpty?'':data[index]['imageId'][0],
                      pid: data[index]['productId'],
                          price:data[index]['b2cP']==0?data[index]['b2bP']:data[index]['b2cP']

                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
