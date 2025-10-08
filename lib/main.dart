import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farmer_brand/UI/MyApp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp().then((v){
    log("Firebase Connected");
  });

  FlutterError.onError=(details){
    log("message=>$details");
  };
  runApp(const MyApp());
}




