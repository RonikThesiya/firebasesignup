import 'package:firebase_core/firebase_core.dart';
import 'package:firebasesignup/screen/home/view/home_screen.dart';
import 'package:firebasesignup/screen/home/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
     GetMaterialApp(

       debugShowCheckedModeBanner: false,
       routes: {
         '/': (context) => HomeScreen(),
         'main': (context) => MainScreen(),
       },
    )
  );
}