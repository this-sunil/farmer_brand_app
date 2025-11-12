import 'dart:collection';
import 'dart:developer';

import 'package:farmer_brand/Bloc/BannerBloc/BannerBloc.dart';
import 'package:farmer_brand/Bloc/ProductBloc/ProductBloc.dart';
import 'package:farmer_brand/Bloc/WeatherBloc/WeatherBloc.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/AuthBloc/AuthBloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  late Animation animation;




  int currentIndex = 0;
  late PageController pageController;

  String formatTemp(double kelvin, {bool isCelsius = true}) {
    if (isCelsius) {
      final celsius = kelvin - 273.15;
      return '${celsius.toStringAsFixed(1)}°C';
    } else {
      final fahrenheit = (kelvin - 273.15) * 9 / 5 + 32;
      return '${fahrenheit.toStringAsFixed(1)}°F';
    }
  }

  HashSet<String> selectItem = HashSet<String>();
  multiSelect(String title) {
    if (selectItem.contains(title)) {
      selectItem.remove(title);
    } else {
      selectItem.add(title);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    context.read<AuthBloc>().add(FetchProfileEvent());
    //context.read<PostBloc>().add(FetchPostEvent());
    context.read<BannerBloc>().add(FetchBannerEvent());
    context.read<ProductBloc>().add(FetchProduct(page: "1"));
    context.read<WeatherBloc>().add(FetchWeatherEvent("17.691401", "74.000938"));




    super.initState();
    pageController = PageController();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.forward();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<BannerBloc, BannerState>(
              listenWhen: (prev,current)=>prev.status!=current.status,
              listener: (context, state) {
                switch (state.status) {
                  case BannerStatus.completed:
                    animationController.addStatusListener((status) async {
                      if (status == AnimationStatus.completed) {
                        int length = state.model?.result?.length ?? 0;
                        log("Banner length=>$length");
                        if (currentIndex < length - 1) {
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
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              currentIndex = 0;
                              pageController.animateToPage(
                                currentIndex,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                              );
                              animationController
                                ..reset()
                                ..forward();
                            });
                          });
                        }
                      }
                    });
                    break;
                  default:
                    break;
                }
              },
              buildWhen: (prev,current)=>prev.status!=current.status,
              builder: (context, state) {
                switch (state.status) {
                  case BannerStatus.loading:
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  case BannerStatus.completed:
                    return SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: state.model?.result?.length ?? 0,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = state.model?.result?[index];
                          return Hero(
                            tag: '${item?.title.toString()}',
                            flightShuttleBuilder:
                                (
                                  BuildContext flightContext,
                                  Animation<double> animation,
                                  HeroFlightDirection flightDirection,
                                  BuildContext fromHeroContext,
                                  BuildContext toHeroContext,
                                ) {
                                  return ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                    child:
                                        flightDirection ==
                                            HeroFlightDirection.push
                                        ? toHeroContext.widget
                                        : fromHeroContext.widget,
                                  );
                                },
                            transitionOnUserGestures: true,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${item?.photo.toString()}',
                                          ),
                                          fit: BoxFit.cover,
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
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  default:
                    return Container(color: Colors.red);
                }
              },
            ),

            // BlocBuilder<WeatherBloc, WeatherState>(
            //   builder: (context, state) {
            //     switch (state.status) {
            //       case WeatherStatus.completed:
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Padding(
            //               padding: EdgeInsets.all(8),
            //               child: Row(
            //                 children: [
            //                   Text(
            //                     "Today’s Weather Forecast",
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontSize: 18,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.all(8),
            //               child: SingleChildScrollView(
            //                 scrollDirection: Axis.horizontal,
            //                 child: Row(
            //                   children: [
            //                     _buildInfoCard(
            //                       icon: Icons.air,
            //                       label: "Wind",
            //                       value:
            //                           "${state.model?.wind?.speed ?? '-'} m/s",
            //                       color: Colors.orange,
            //                     ),
            //                     _buildInfoCard(
            //                       icon: Icons.thermostat,
            //                       label: "Temperature",
            //                       value: formatTemp(
            //                         state.model?.main?.temp ?? 0.0,
            //                       ),
            //                       color: Colors.amber,
            //                     ),
            //                     _buildInfoCard(
            //                       icon: Icons.opacity,
            //                       label: "Humidity",
            //                       value:
            //                           "${state.model?.main?.humidity ?? '-'}%",
            //                       color: Colors.greenAccent,
            //                     ),
            //                     _buildInfoCard(
            //                       icon: Icons.speed,
            //                       label: "Pressure",
            //                       value:
            //                           "${state.model?.main?.pressure ?? '-'} hPa",
            //                       color: Colors.pink,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         );
            //       default:
            //         return Container();
            //     }
            //   },
            // ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    "Our Farmers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                switch (state.status) {
                  case ProductStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case ProductStatus.completed:
                    return ListView.builder(
                      itemCount: state.product?.result?.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item=state.product?.result?[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          shadowColor: Colors.grey.shade300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  top: 5,
                                ),
                                leading: CircleAvatar(
                                  maxRadius: 30,
                                  backgroundImage: NetworkImage(
                                    item?.photo.toString()??'',
                                  ),
                                ),
                                title: Text(
                                  "${item?.name}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${item?.city},MH-${item?.pin}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: Colors.orangeAccent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      index % 2 == 0 ? "Active" : "Inactive",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff333945),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Divider(color: Colors.grey.shade300),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Our Products",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 220,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: ListView.builder(
                                    itemCount: state.product?.result?.length??0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, currentIndex) {
                                      final productItem=item?.products?[currentIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          context.push(AppRoutes.overView, {
                                            "id": '${productItem?.pid}',
                                            "name": '${productItem?.productTitle}',
                                            "imgPath": "${productItem?.productPhoto}",
                                            "price": "${productItem?.productPrice}",
                                          });
                                        },
                                        child: SizedBox(
                                          width: 160,
                                          child: Card(
                                            color: Colors.white,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Hero(
                                                    tag: '$index$currentIndex',
                                                    child: Container(
                                                      clipBehavior:
                                                      Clip.hardEdge,
                                                      width: double.infinity,
                                                      height: 180,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                            10,
                                                          ),
                                                          topRight:
                                                          Radius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          colorFilter:
                                                          index % 2 == 0
                                                              ? null
                                                              : ColorFilter.mode(
                                                            Colors.black,
                                                            BlendMode
                                                                .saturation,
                                                          ),
                                                          image: NetworkImage(
                                                            '${productItem?.productPhoto}',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                    left: 10,
                                                    right: 5,
                                                    top: 8,
                                                  ),
                                                  child: Text(
                                                    "${item?.name}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                    left: 10,
                                                    right: 5,
                                                    bottom: 8,
                                                  ),
                                                  child: Text(
                                                    "\u{20b9} ${productItem?.productPrice}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),

                                                Flexible(
                                                  flex: 3,
                                                  child: Align(
                                                    alignment: AlignmentGeometry
                                                        .center,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                        Colors.pinkAccent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        "Add Cart",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),


                            ],
                          ),
                        );
                      },
                    );
                  case ProductStatus.error:
                    return Text("${state.msg}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16));
                  default:
                    return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
