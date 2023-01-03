import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasesignup/screen/firebase/firebase_screen.dart';
import 'package:firebasesignup/screen/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeController homeController = Get.put(HomeController());

  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Firebase SignUp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtemail,
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtpassword,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()async{
              String? msg = await signUp(txtemail.text, txtpassword.text);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$msg",style: TextStyle(color: Colors.white),)));
            }, child: Text("SignUp")),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()async{
              String? msg = await login(txtemail.text, txtpassword.text);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$msg")));

              if(msg == "Success")
                {
                  Get.offNamed("main");
                }

            }, child: Text("Log In")),

            SizedBox(height: 20,),
            ElevatedButton(onPressed: ()async{

              bool msg = await googleLogin();

              if(msg)
                {
                  Get.offNamed('main');
                }
            }, child: Text("Google Log In")),


          ],
        ),
      ),
    ));
  }
}


