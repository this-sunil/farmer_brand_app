import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:either_dart/either.dart';

class FirebaseApi{
  FirebaseApi._();

  static FirebaseApi get instance=>FirebaseApi._();
  FirebaseAuth auth=FirebaseAuth.instance;
  GoogleSignIn googleSignIn=GoogleSignIn.instance;
  String verificationId='';
  FirebaseMessaging messaging=FirebaseMessaging.instance;

  Future remoteMessage(RemoteMessage message) async{
    if(message.notification==null) return;
    String title=message.notification?.title??'';
    String body=message.notification?.body??'';
    sendNotification(title, body);
  }

  init() async{
    messaging.requestPermission();
    messaging.setAutoInitEnabled(true);
    messaging.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(remoteMessage);
    FirebaseMessaging.onMessage.listen((message){
      if(message.notification==null) return;
      String title=message.notification?.title??'';
      String body=message.notification?.body??'';
      sendNotification(title, body);
    });
    String? token=await messaging.getAPNSToken();

    if(token==null){
      log("=========== Token Empty =========");
    }
    else{
      String? deviceToken=await messaging.getToken();
      log("========Device Token => $deviceToken============");
      messaging.subscribeToTopic('all');
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  sendNotification(String title,String body) async{
    int id=DateTime.now().microsecondsSinceEpoch;
    NotificationDetails notificationDetails=NotificationDetails(
      android: AndroidNotificationDetails('Basic_Channel', 'Basic Channel',priority: Priority.high,category:AndroidNotificationCategory.message),
      iOS: DarwinNotificationDetails(
        subtitle: body
      )
    );
    await flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  Future<Either<String, UserCredential>> signInGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.authenticate();
      final GoogleSignInClientAuthorization? authorization = await googleSignInAccount.authorizationClient.authorizationForScopes([]);
      final GoogleSignInAuthentication googleAuth = googleSignInAccount.authentication;
      final OAuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization?.accessToken
      );
      final UserCredential userCredential = await auth.signInWithCredential(authCredential);
      log("message=>${userCredential.user}");
      if (userCredential.user == null) {
        return Left("No User Found");
      }
      return Right(userCredential);
    } on GoogleSignInException catch (e) {
      return Left("Google Sign-In Error: ${e.description}");
    } catch (e) {
      return Left("Something Went Wrong: ${e.toString()}");
    }
  }

  Future<void> sendOtp(String phone) async{
    return await auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        timeout: Duration(seconds: 60),
        verificationCompleted: (credential) async{
          await verifyNumber(phone);
        },
        verificationFailed: (FirebaseAuthException e){
          log("Verification Failed=>${e.message}");
        },
        codeSent: (v, forceResendingToken) {
          verificationId=v.toString();
        },
        codeAutoRetrievalTimeout: (v){
          verificationId=v.toString();
        }
    );

  }

  Future<Either<String,UserCredential>> verifyNumber(String smsCode) async{
      try{
        PhoneAuthCredential phoneAuthCredential= PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        UserCredential? userCredential=await auth.signInWithCredential(phoneAuthCredential);
        if(userCredential.user==null){
          return Left("No Data Found !!!");
        }
        return Right(userCredential);
      }
      on FirebaseAuthException catch(e){
        return Left(e.toString());
      }
      catch(e){
        return Left(e.toString());
      }
  }

}