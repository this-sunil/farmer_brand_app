import 'dart:convert';
import 'dart:developer';
import 'package:farmer_brand/Services/LocalStorage.dart';
import 'package:http/http.dart';
import 'package:farmer_brand/Model/FarmerModel.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import '../Model/User.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin,AppRoutes{
  late AnimationController animationController;
  static const String baseImg = "assets/icons";
  late PageController pageController;
  LocalStorage localStorage=LocalStorage();
  List<FarmerModel> images = [
    FarmerModel(
      title: "Village Grain Farmer",
      description: "Traditional farming techniques passed down generations, growing rice and wheat.",
      photo: "$baseImg/village-farmer.png",
    ),
    FarmerModel(
      title: "Fruit Orchard Owner",
      description: "Specializes in apples, mangoes, and berries with sustainable farming.",
      photo: "$baseImg/fruits.png",
    ),
    FarmerModel(
      title: "Young Seller at Market",
      description: "A young farmer selling fresh produce directly at the village market.",
      photo: "$baseImg/seller-boy.jpg",
    ),
    FarmerModel(
      title: "Organic Vegetable Farmer",
      description: "Grows seasonal organic vegetables in a small eco-friendly farm.",
      photo: "$baseImg/farmer-garden.jpg",
    ),

  ];
  int currentIndex=0;

  Future<List<User>> fetchUsers() async {
    final response = await get(Uri.parse("https://jsonplaceholder.typicode.com/users"),
      headers: {
        "Accept": "application/json",
      },
    );

    log("Message : ${response.statusCode}");
    if(response.statusCode == 200){
      log("Response=>${response.statusCode}");
      final List<dynamic> data = jsonDecode(response.body);
      final List<User> user=data.map((e)=>User.fromJson(e)).toList();
      return user;
    }
    else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.addStatusListener((status) async{
      if (status == AnimationStatus.completed) {
        if (currentIndex < images.length - 1) {
          currentIndex++;
          pageController.animateToPage(
            currentIndex,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
          animationController
            ..reset()
            ..forward();
        } else {
          log("Reached the last page");
          //fetchUsers();
          String? uid=await localStorage.getUID();
          print("User=>$uid");
          if(uid==null){
            context.pushReplace(AppRoutes.login);
          }
          else{
            context.pushReplace(AppRoutes.dashboard);
          }
        }
      }
    });
    animationController.forward();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: images.length,
        onPageChanged: (index){
          setState(() {
            currentIndex=index;
          });
        },
        itemBuilder: (context, index) {
          final item = images[index];
          return Hero(
            tag: item.title,
            flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext) {
                  return ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: flightDirection == HeroFlightDirection.push
                        ? toHeroContext.widget
                        : fromHeroContext.widget,
                  );
                },
            transitionOnUserGestures: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,

                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              item.photo,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,

                                    Colors.black45, 
                                  ],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,

                                    Colors.black45, 
                                  ],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,

                                    Colors.black45, 
                                  ],
                                  stops: [0.6, 1.0], 
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,

                                    Colors.black45, 
                                  ],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,

                                    Colors.black45, 
                                  ],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,

                                    Colors.black45, 
                                  ],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 100,
                        left: 10,
                        right: 10,
                        child:  Column(
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10),child: Text(item.description,style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,

                              ),textAlign: TextAlign.justify))
                            ],
                          ),

                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),

    );
  }
}
