import 'package:farmer_brand/Chatboat.dart';
import 'package:farmer_brand/UI/Auth/LoginScreen.dart';
import 'package:farmer_brand/UI/Auth/RegisterScreen.dart';
import 'package:farmer_brand/UI/Auth/VerifyScreen.dart';
import 'package:farmer_brand/UI/Dashboard.dart';
import 'package:farmer_brand/UI/SplashScreen.dart';
import 'package:flutter/material.dart';
import '../UI/Profile/UpdateProfile.dart';

mixin AppRoutes {

  static const String initialRoute = "/";
  static const String dashboard = "/dashboard";
  static const String login="/login";
  static const String register="/register";
  static const String chat="/chat";
  static const String verifyOtp="/verify-otp";
  static const String playMusic="/play-music";
  static const String streamVideo="/stream-video";
  static const String updateProfile="/update-profile";

  static Widget transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SplashScreen(),
          transitionsBuilder: transitionsBuilder,
        );
      case dashboard:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DashboardScreen(),
          transitionsBuilder: transitionsBuilder,
        );
      case login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: transitionsBuilder,
        );
      case register:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              RegisterScreen(),
          transitionsBuilder: transitionsBuilder,
        );
      case chat:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ChatScreen(),
          transitionsBuilder: transitionsBuilder,
        );
      case verifyOtp:
        final args=settings.arguments as Map<String,dynamic>;
        return PageRouteBuilder(
            transitionsBuilder: transitionsBuilder,
            pageBuilder: (context,animation,secondaryAnimation)=>VerifyScreen(
              name: args['name'],
              phone: args['phone'],
              pass: args['pass'],
            ));
      case updateProfile:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => UpdateProfile(),
          transitionsBuilder: transitionsBuilder,
        );
      default:
        return PageRouteBuilder(
          transitionsBuilder: transitionsBuilder,
          pageBuilder: (context, animation, secondaryAnimation) =>
              Scaffold(body: Center(child: Text("No Page Found !!!"))),
        );
    }
  }
}

extension NavigatorExtension on BuildContext {

  Future<void> pushReplace(String routes, [Map<String,dynamic>? arg]) {
    return Navigator.pushReplacementNamed(this, routes, arguments: arg);
  }

  Future<void> push(String routes, [Map<String,dynamic>? arg]) {
    return Navigator.pushNamed(this, routes, arguments: arg);
  }

  Future<void> pop() async {
    return Navigator.pop(this);
  }

}
