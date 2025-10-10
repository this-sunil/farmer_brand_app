import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farmer_brand/UI/MyApp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// armStrongNumber(){
//   int number=153;
//   int sum=0;
//   int rem;
//   int temp=number;
//   do{
//     rem=number%10;
//     sum+=rem*rem*rem;
//     number~/=10;
//   }
//   while(number!=0);
//   if(sum==temp){
//     log("This is ArmStrong number=>$sum");
//   }
//   else{
//     log("This is not armstrong number=>$sum");
//   }
// }
//
// primeNumber(){
//   int n=100;
//   for(int i=0;i<n;i++){
//     if(i%2==0){
//       log("Even no=>$i");
//     }
//     else{
//       log("Odd no=>$i");
//     }
//   }
// }
//
// palindromeNumber(){
//   log("Palindrome");
//   int n=121;
//   int sum=0,digit,temp=n;
//   do{
//     digit = n % 10;
//     sum = sum * 10 + digit;
//     n = n ~/ 10;
//     log("Number=>$sum");
//   }
//   while(n!=0);
//   if(sum==temp){
//     log("This is Palindrome Number=>$sum");
//   }
//   else{
//     log("This is Palindrome Number=>$sum");
//   }
// }
// reverse(String s){
//   StringBuffer buffer=StringBuffer();
//   for(int i=s.length-1;i>=0;i--){
//     buffer.write(s[i]);
//   }
//   log("message=>$buffer");
// }
// sortAlgo(){
//   List<String> data=["PineApple","Strawberry","Apple","Banana","Mango"];
//   //data.sort((a,b)=>a.compareTo(b));
//   for(int i=0;i<data.length;i++){
//     for(int j=1;j<=data.length-1;j++){
//       if(data[i].compareTo(data[j])>0){
//         String temp=data[i];
//         data[i]=data[j];
//         data[j]=temp;
//       }
//     }
//   }
//   log("Sorting Algorithm=>${data.map((e)=>e).toList()}");
// }


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




