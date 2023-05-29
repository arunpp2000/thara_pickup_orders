import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thara_pickup_orders/homePage.dart';

import 'login.dart';

var cWidth;
bool? userLogged;
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future loginEvent() async {
    final preferences = await SharedPreferences.getInstance();
    currentUser = preferences.getString('name') ?? '';
    if(currentUserId!=null){
      preferences.setString('userId', currentUserId!);
    }else{
      currentUserId=preferences.getString('userId') ?? '';
    }
    print('user id = '+currentUserId!);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    loginEvent().whenComplete((){
      Timer(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                currentUserId == null ?Login():HomeBody(),
            ),
                (route) => false);
      });
      print(currentUserId);
    });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = MediaQuery.of(context).size.width;
    // var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    final sWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


