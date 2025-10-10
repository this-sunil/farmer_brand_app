import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class PickerImage{
  PickerImage._();
  static PickerImage get instance=>PickerImage._();

  Future<File> pickImage({required ImageSource source}) async{
    final imagePicker=await ImagePicker().pickImage(source: source);
    if(imagePicker==null){
      log("Failed to pick image");
    }
    return File(imagePicker!.path);
  }

  FirebaseAuth auth=FirebaseAuth.instance;
  GoogleSignIn googleSignIn=GoogleSignIn.instance;

  Future<UserCredential> signGoogle() async{
    try{
      GoogleSignInAccount googleSignInAccount=await googleSignIn.authenticate();
      final authorizationClient=await googleSignInAccount.authorizationClient.authorizeScopes([]);
      OAuthCredential credential= GoogleAuthProvider.credential(
        idToken: googleSignInAccount.authentication.idToken,
        accessToken: authorizationClient.accessToken
      );
      return auth.signInWithCredential(credential);
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.message);
    }
    catch(e){
      throw Exception(e);
    }
  }

}