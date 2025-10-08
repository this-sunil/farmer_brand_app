import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:either_dart/either.dart';
class FirebaseApi{
  FirebaseApi._();
  static FirebaseApi get instance=>FirebaseApi._();
  FirebaseAuth auth=FirebaseAuth.instance;
  GoogleSignIn googleSignIn=GoogleSignIn.instance;
  String verificationId='';
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