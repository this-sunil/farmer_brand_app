// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   MethodChannel channel = MethodChannel('com.brand.farmer_brand/upi');
//   GoogleSignIn googleSignIn=GoogleSignIn.instance;
//   FirebaseAuth auth=FirebaseAuth.instance;
//   Future<UserCredential?> signGoogle() async{
//     UserCredential? userCredential;
//     try {
//       final signInAccount = await googleSignIn.authorizationClient
//           .authorizationForScopes([]);
//       final authorization = await googleSignIn.authenticate();
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         idToken: authorization.authentication.idToken,
//         accessToken: signInAccount?.accessToken,
//       );
//       userCredential = await auth.signInWithCredential(credential);
//     }
//     catch(e){
//      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//       //throw Exception(e);
//     }
//     return userCredential;
//   }
//   String? verificationId;
//   verifyNumber() async{
//     await auth.verifyPhoneNumber(
//        phoneNumber: '+918668796251',
//         verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
//           await auth.signInWithCredential(phoneAuthCredential);
//         }, verificationFailed: (FirebaseAuthException error) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${error.message}')));
//     }, codeSent: (String verificationId, int? forceResendingToken) {
//           setState(() {
//             verificationId=verificationId;
//           });
//     }, codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             verificationId=verificationId;
//           });
//     });
//   }
//   startPayment() async {
//     String url =
//         'upi://pay?pa=suryatuts@ybl&pn=amazon&mc=&tid=${DateTime.now()}&tr=AIRPAY${DateTime.now()}&tn='
//         '&am=10&cu=INR';
//     try {
//       final resp = await channel.invokeMethod('startTransaction', {'url': url});
//       if (resp['statusCode'] == '200') {
//         if (kDebugMode) {
//           print("Successfully payment=>${resp['message']}");
//         }
//       } else {
//         if (kDebugMode) {
//           print("Failure Payment=>${resp['message']}");
//         }
//       }
//     } catch (e) {
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
//       //throw Exception(e);
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     verifyNumber();
//     super.initState();
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//            signGoogle();
//           },
//           child: Text("Google Sign In"),
//         ),
//       ),
//     );
//   }
// }
