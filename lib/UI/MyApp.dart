import 'package:farmer_brand/Bloc/AuthBloc/AuthBloc.dart';
import 'package:farmer_brand/Bloc/WeatherBloc/WeatherBloc.dart';
import 'package:farmer_brand/ChatBloc/ChatBloc.dart';
import 'package:farmer_brand/Repository/AuthRepository.dart';
import 'package:farmer_brand/Repository/WeatherRepository.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:farmer_brand/UI/SplashScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context)=>AuthBloc(AuthRepository())),
      BlocProvider<ChatBloc>(create: (context)=>ChatBloc()),
      BlocProvider(create: (context)=>WeatherBloc(WeatherRepository())),
    ], child: MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Farmer Brand',
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange),
      ),
      home: SplashScreen(),
    ));
  }
}