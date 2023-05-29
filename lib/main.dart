
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thara_pickup_orders/SplashScreen.dart';
import 'homePage.dart';
import 'login.dart';
// var scrheight;
// var scrwidth;
// var primaeryColor;
String? uId;
var userdata;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:SplashScreen()
    );
  }
}
