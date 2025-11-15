import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:farmer_brand/Screen/CartScreen.dart';
import 'package:farmer_brand/Screen/CategoryScreen.dart';
import 'package:farmer_brand/Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:farmer_brand/Screen/MenuScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../Bloc/AuthBloc/AuthBloc.dart';
import '../Bloc/BannerBloc/BannerBloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  getWeatherCondition(clouds, weatherId) {
    if (weatherId >= 200 && weatherId < 300) {
      return "Thunderstorm";
    } else if (weatherId >= 300 && weatherId < 600) {
      return "Rainy";
    } else if (weatherId >= 600 && weatherId < 700) {
      return "Snowy";
    } else if (weatherId == 800) {
      return "Clear (Sunny)";
    } else if (weatherId > 800 && clouds < 50) {
      return "Partly Cloudy";
    } else if (clouds >= 50 && clouds < 100) {
      return "Cloudy";
    } else if (clouds == 100) {
      return "Overcast";
    } else {
      return "Unknown Weather";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    context.read<AuthBloc>().add(FetchProfileEvent());
    context.read<BannerBloc>().add(FetchBannerEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(4),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/icons/farmer-garden.jpg"),
          ),
        ),
        centerTitle: false,
        titleSpacing: 1.0,
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthStatus.fetch:
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.purple,
                                Colors.pink,
                                Colors.purple,
                              ],
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          currentIndex==0?'Hi,${state.result?.result?.name}':currentIndex==1?'Our Farmer':currentIndex==2?'Cart':'Setting',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),


                      const SizedBox(height: 10),
                    ],
                  ),
                );
              default:
                return Container();
            }
          },
        ),

        actions: [
          IconButton(onPressed: () {}, icon: Icon(HeroiconsSolid.language)),
          IconButton(onPressed: () {}, icon: Icon(HeroiconsSolid.bell)),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [HomeScreen(), CategoryScreen(), CartScreen(), MenuScreen()],
      ),
      bottomNavigationBar: CircleNavBar(
        height: 90,
        gradient: LinearGradient(
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight,
          colors: [Colors.deepPurpleAccent, Colors.red],
        ),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        cornerRadius: BorderRadius.circular(10),
        tabCurve: Curves.fastOutSlowIn,
        activeIndex: currentIndex,
        activeIcons: [
          Icon(HeroiconsSolid.home, color: Colors.white),
          Icon(HeroiconsOutline.square3Stack3d, color: Colors.white),
          Icon(HeroiconsSolid.shoppingBag, color: Colors.white),
          Icon(Icons.menu, color: Colors.white),
        ],
        inactiveIcons: [
          Icon(HeroiconsSolid.home, color: Colors.grey.shade300),
          Icon(HeroiconsSolid.square3Stack3d, color: Colors.grey.shade300),
          Icon(HeroiconsSolid.shoppingBag, color: Colors.grey.shade300),
          Icon(Icons.menu, color: Colors.grey.shade300),
        ],
        color: Colors.deepOrangeAccent,
      ),
    );
  }
}
