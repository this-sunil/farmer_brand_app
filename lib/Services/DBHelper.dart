import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper{
  DBHelper._();
  static DBHelper get instance=>DBHelper._();
  String favTable='Favourite';

  Future<Database> init() async{
    Directory dir=await getApplicationDocumentsDirectory();
    log("Directory Path=>${dir.path}");
    Database database=await openDatabase(join(dir.path,"farmer.db"),onCreate: _onCreate,version: 1);
    return database;
  }

  _onCreate(Database db,int version) async{
    String sql='CREATE TABLE IF NOT EXISTS $favTable(id INTEGER PRIMARY KEY,title TEXT NOT NULL,description TEXT NOT NULL,price FLOAT NOT NULL,dPrice FLOAT NOT NULL,created_at DATE DEFAULT CURRENT_TIMESTAMP)';
    await db.execute(sql);
  }

  Future<int> addFav(Map<String,dynamic> values) async{
    Database db=await DBHelper.instance.init();
    return db.insert(favTable, values,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeFav(int id) async{
    Database db=await DBHelper.instance.init();
    return db.delete(favTable, where: 'id=?',whereArgs: [id]);
  }

  Future<void> close() async{
    Database db=await DBHelper.instance.init();
    return db.close();
  }
}

class DatabaseHelper{
  DatabaseHelper._();
  DatabaseHelper get instance=>DatabaseHelper._();
  Future<Database> init() async{
    Directory dir=await getApplicationCacheDirectory();
    Database db=await openDatabase(join(dir.path),onCreate: _onCreate,version: 1);
    return db;
  }

  String userTable="users";
  _onCreate(Database db,int version) async{
    String sql='CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY,title TEXT NOT NULL,description TEXT NOT NULL,createdAt DATE DEFAULT CURRENT_DATE)';
    Database db=await init();
    return db.execute(sql);
  }

  addUser(Map<String,dynamic> values) async{
    Database db=await init();
    return db.insert(userTable, values);
  }
  removeUser(String id) async{
    Database db=await init();
    return db.delete(userTable,whereArgs: ["id=?"],where: id);
  }
  Future<void> close() async{
    Database db=await init();
    return db.close();
  }

  FirebaseAuth auth=FirebaseAuth.instance;
  GoogleSignIn googleSignIn=GoogleSignIn.instance;


  Future<UserCredential> signGoogle() async{
    try{

      GoogleSignInAccount googleSignInAccount=await googleSignIn.authenticate();
      final authorization=await googleSignInAccount.authorizationClient.authorizeScopes([]);
      OAuthCredential credential=GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleSignInAccount.authentication.idToken
      );
      return auth.signInWithCredential(credential);
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.message.toString());
    }
    catch(e){
      throw Exception(e);
    }
  }
}