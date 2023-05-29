
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thara_pickup_orders/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
String? currentUser;
String? currentUserId;
class Login extends StatefulWidget {

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController? userName;
  TextEditingController? passWord;
  bool passwordVisibility=false;
  @override
  void initState() {
    super.initState();
    // userName = TextEditingController();
    // passWord = TextEditingController();
    userName = TextEditingController();
    passWord = TextEditingController();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/tara1.png"),fit: BoxFit.contain
              )
          ),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.45,
              ),
              Expanded(
                child: Container(
                  child:  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: ListView(
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          height:MediaQuery.of(context).size.height,
                          width: double.infinity,

                          padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(height: 130,width: 350,),

                              const SizedBox(height: 10,),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 30,right: 30),
                                  padding: const EdgeInsets.only(left: 30,right: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(
                                          5.0,
                                          5.0,
                                        ),
                                        blurRadius: 20.0,
                                        spreadRadius: 1.0,
                                      ), //BoxShadow
                                      //BoxShadow
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            height: 150,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage("assets/tara1.png")
                                                )
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black)
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: userName,
                                                  obscureText: false,
                                                  keyboardType: TextInputType.emailAddress,
                                                  decoration: InputDecoration(
                                                    hintText: 'User Name',
                                                    hintStyle:
                                                    TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.grey.shade500,
                                                    ),
                                                    enabledBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                  style:
                                                  const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height*0.01),

                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.red)
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                child: Icon(
                                                  Icons.lock,
                                                  color:Colors.black,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: passWord,
                                                  obscureText: !passwordVisibility!,
                                                  decoration: InputDecoration(
                                                    hintText: 'Password',
                                                    hintStyle:
                                                    TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.grey.shade500,
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    suffixIcon: InkWell(
                                                      onTap: () => setState(
                                                            () => passwordVisibility =
                                                        !passwordVisibility!,
                                                      ),
                                                      child: Icon(
                                                        passwordVisibility
                                                            ? Icons.visibility_outlined
                                                            : Icons.visibility_off_outlined,
                                                        color: Colors.black,
                                                        size: 22,
                                                      ),
                                                    ),
                                                  ),
                                                  style:
                                                  TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        Text('version : 0.0.3',style: TextStyle(fontSize: 12,color: Colors.black),),
                                        //
                                        // Text("By clicking Login You are accepted our terms and Conditions",style: TextStyle(
                                        //     color: Colors.black
                                        // ),textAlign: TextAlign.center,),
                                        Container(
                                          padding: EdgeInsets.only(left: 30,right: 30,bottom: 20),
                                          child: TextButton(
                                            onPressed: () async {
                                               SharedPreferences? preferences = await SharedPreferences.getInstance();
                                              try {
                                                currentUser = null;
                                                currentUserId = "";
                                                QuerySnapshot doc =
                                                await FirebaseFirestore.instance
                                                    .collection('posUser').where('delete',isEqualTo: false)
                                                    .where('name',isEqualTo: userName?.text)
                                                    .get();
                                                if (doc.docs.isEmpty) {
                                                  showUploadMessage(
                                                    context,'Invalid User ',);
                                                }
                                                if (doc.docs[0]['password'] == passWord!.text) {
                                                  preferences.setString('userName', userName!.text);
                                                  preferences.setString('userId', doc.docs[0]['id']);
                                                  currentUserId =doc.docs[0]['id'] ;
                                                  currentUser =doc.docs[0]['name'] ;
                                                  print(currentUserId);
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    PageRouteBuilder(
                                                        pageBuilder:
                                                        (context, _, __) =>
                                                        HomeBody(),
                                                  ),
                                              (route) => false);
                                              } else {
                                              showUploadMessage(
                                              context,'Invalid Password');
                                              }
                                              } catch (r) {
                                              showUploadMessage(
                                              context,'Invalid User Id',);
                                              }
                                            },
                                            child: Center(
                                              child: Text("LOGIN", style: TextStyle(color: Colors.black,fontSize: 20),
                                              ),
                                            ),
                                            style: ButtonStyle(backgroundColor:MaterialStateColor.resolveWith((states) => Colors.yellow.shade700),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6),

                                                    )
                                                )
                                            ),),
                                        ),
                                        // /Text('version : 0.0.1',style: TextStyle(fontSize: 12,color: Colors.black),),
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
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.15,

              ),
            ],
          ),
        ),
      ),
    );
  }
}
