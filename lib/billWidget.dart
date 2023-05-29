
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../product_card.dart';
import 'homePage.dart';
import 'login.dart';

class billWidget extends StatefulWidget {
  final int? index;
  final String? name;
  final List? items;
  final double? price;

  var count;

  var gst;
     billWidget({Key? key, this.index, this.name,this.items, this.price,  this.count,  this. gst,}) : super(key: key);

  @override
  _billWidgetState createState() => _billWidgetState();
}

class _billWidgetState extends State<billWidget> {
  int progress = 0;
  @override
  Widget build(BuildContext context) {
    progress=widget.count;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(child: Text((widget.index!+1).toString(),style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),)),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      currentProduct=widget.name;
                      // selectedItems = widget.items[widget.index];
                      print(selectedItems);
                    },
                    child: Center(child: Text(widget.name??'',style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,

              child: Center(
                  child: Text((widget.price).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),)),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        onPressed: () {
                          if(progress!=0){
                            int i=0;
                            for(int k=0;k<widget.items!.length;k++){
                              if(widget.items![k]['pdtName']==widget.name&&widget.items![k]['price']==widget.price){
                                i=k;
                                break;
                              }
                            }
                            widget.items?.removeAt(i);

                            if (progress != 1) {
                              widget.items?.insert(i,{
                                'pdtName': widget.name,
                                'price': widget.price,
                                'qty': progress - 1,
                                'gst':widget.gst
                              });
                            }
                            FirebaseFirestore.instance.collection(
                                'posUser')
                                .doc(currentUserId)
                              .update(
                                {'bag': widget.items
                                });

                            setState(() {
                              progress = progress - 1;
                            });
                          }
                        },
                        icon:  const FaIcon(
                          FontAwesomeIcons.minusCircle,
                          color: Colors.black,
                          size: 20,
                        ),
                        iconSize: 20,
                      ),
                      Text(progress.toString()),
                      IconButton(
                        onPressed: () {
                          int i=0;
                          for(int k=0;k<widget.items!.length;k++){
                            if(widget.items![k]['pdtName']==widget.name&&widget.items![k]['price']==widget.price){
                              i=k;
                              break;
                            }
                          }
                          widget.items?.removeAt(i);
                          widget.items?.insert(i,{
                            'pdtName': widget.name,
                            'price': widget.price,
                            'qty': progress + 1,
                            'gst':widget.gst

                          });
                          setState(() {

                          });
                          FirebaseFirestore.instance.collection(
                              'posUser')
                              .doc(currentUserId)
                              .update(
                              {'bag': widget.items});
                          setState(() {
                            progress = progress + 1;
                          });
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.plusCircle,
                          color: Colors.black,
                          size: 18,
                        ),
                        iconSize: 18,
                      )
                    ],
                  ),
                )
            ),
            const SizedBox(width: 2,),
            InkWell(
              onTap: (){
                FirebaseFirestore.instance.collection('posUser')
                    .doc(currentUserId).update(
                    {
                      'bag': FieldValue.arrayRemove([widget.items![widget.index??0]])
                    });

              },
              child: const Icon(Icons.delete,
                color:Colors.teal,),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
