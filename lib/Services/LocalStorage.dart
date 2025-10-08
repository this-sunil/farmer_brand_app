import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{



  Future<bool> setUID(String val) async{
    final pref=await SharedPreferences.getInstance();
    return pref.setString("key", val);
  }

  Future<String?> getUID() async{
    final pref=await SharedPreferences.getInstance();
    final String? uid=pref.getString("key");
    return uid;
  }

  Future<bool> setToken(String val) async{
    final pref=await SharedPreferences.getInstance();
    return pref.setString("token", val);
  }

  Future<String?> getToken() async{
    final pref=await SharedPreferences.getInstance();
    final String? token=pref.getString("token");
    return token;
  }
  Future<bool> resetUID() async{
    final pref=await SharedPreferences.getInstance();
    final flag=pref.remove("key");
    return flag;
  }
  Future<bool> resetToken() async{
    final pref=await SharedPreferences.getInstance();
    final flag=pref.remove("token");
    return flag;
  }


}