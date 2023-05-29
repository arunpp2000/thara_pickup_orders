
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'billWidget.dart';



List<Map<String,dynamic>> itemList=[];

class BillWidget extends StatefulWidget {
  final  List items;
  const BillWidget({Key? key, required this.items}) : super(key: key);

  @override
  _BillWidgetState createState() => _BillWidgetState();
}

class _BillWidgetState extends State<BillWidget> {
  TextEditingController? textController;
  List items=[];


  final scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  initState(){

    super.initState();
    items=[];

    textController=TextEditingController();

  }
int selectedItems=0;
  @override
  Widget build(BuildContext context) {

// if(items.isEmpty){
    items=widget.items;
//
// }
    return Container(
      height: MediaQuery.of(context).size.height*.4,
      width: MediaQuery.of(context).size.width/2,
      padding: const EdgeInsets.only(left: 5,right: 5),
      child:  ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: items.length ?? 0,
          itemBuilder: (context,index){
            // selectedItems=items[index];
            String item = items[index]['pdtName']??"";
            int count=items[index]['qty'];
            double gst=items[index]['gst'].toDouble();
            double? price=double.tryParse(items[index]['price'].toString());
            return  billWidget(
              index: index,
              name: item,
              items: widget.items,
              price: price,
              count: count,
              gst:gst,
            );
          }
      ),
    );
  }

  Widget deleteCard() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: const BoxDecoration(
          color: Colors.grey
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text("Remove from Bag"),
          Icon(Icons.delete,
            color:Colors.teal,),
        ],
      ),
    );
  }
}
