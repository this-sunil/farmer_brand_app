import 'package:farmer_brand/Bloc/PostBloc/PostBloc.dart';
import 'package:farmer_brand/Bloc/WeatherBloc/WeatherBloc.dart';
import 'package:farmer_brand/Model/PostItem.dart';
import 'package:farmer_brand/Services/AnimatedFav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:intl/intl.dart';
import '../Model/FarmerModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  late Animation animation;
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  static const String baseImg = "assets/icons";
  bool flag = false;
  List<PostItem> items = [
    PostItem(title: "Save Post", icons: Icon(Icons.save)),
    PostItem(title: "Report", icons: Icon(Icons.report)),
  ];
  List<FarmerModel> images = [
    FarmerModel(
      title: "Village Grain Farmer",
      description:
          "Traditional farming techniques passed down generations, growing rice and wheat.",
      photo: "$baseImg/village-farmer.png",
    ),
    FarmerModel(
      title: "Fruit Orchard Owner",
      description:
          "Specializes in apples, mangoes, and berries with sustainable farming.",
      photo: "$baseImg/fruits.png",
    ),

    FarmerModel(
      title: "Organic Vegetable Farmer",
      description:
          "Grows seasonal organic vegetables in a small eco-friendly farm.",
      photo: "$baseImg/farmer-garden.jpg",
    ),
  ];

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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    pageController = PageController();
    context.read<WeatherBloc>().add(
      FetchWeatherEvent("17.691401", "74.000938"),
    );
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.forward();
    animationController.addStatusListener((status) async {
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
    scaleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    scaleAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    animationController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = images[index];
                  return Hero(
                    tag: item.title,
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
                            child: flightDirection == HeroFlightDirection.push
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
                                  image: AssetImage(item.photo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black45],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black45],
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
            ),

            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                switch (state.status) {
                  case WeatherStatus.completed:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Text(
                                "Today’s Weather Forecast",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildInfoCard(
                                  icon: Icons.air,
                                  label: "Wind",
                                  value:
                                      "${state.model?.wind?.speed ?? '-'} m/s",
                                  color: Colors.orange,
                                ),
                                _buildInfoCard(
                                  icon: Icons.thermostat,
                                  label: "Temperature",
                                  value: formatTemp(
                                    state.model?.main?.temp ?? 0.0,
                                  ),
                                  color: Colors.amber,
                                ),
                                _buildInfoCard(
                                  icon: Icons.opacity,
                                  label: "Humidity",
                                  value:
                                      "${state.model?.main?.humidity ?? '-'}%",
                                  color: Colors.greenAccent,
                                ),
                                _buildInfoCard(
                                  icon: Icons.speed,
                                  label: "Pressure",
                                  value:
                                      "${state.model?.main?.pressure ?? '-'} hPa",
                                  color: Colors.pink,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  default:
                    return Container();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    "Market Trends",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case PostStatus.completed:
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: List.generate(
                          state.result?.result?.length??0,
                          (index) {
                            final item=state.result?.result?[index];
                            return Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    leading: CircleAvatar(
                                      maxRadius: 40,
                                      backgroundImage: AssetImage("assets/icons/village-farmer.png"),
                                    ),
                                    minLeadingWidth: 10,
                                    title: Text("${item?.postTitle}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat(
                                            "dd MMM yyyy,hh:mm a",
                                          ).format(DateTime.parse("${item?.createdAt}")),
                                        ),
                                        Text("${item?.user?.state},${item?.user?.city}"),
                                      ],
                                    ),
                                    trailing: PopupMenuButton(
                                      icon: Icon(Icons.more_vert),
                                      color: Colors.white,
                                      offset: Offset(0, 60),
                                      elevation: 5,
                                      itemBuilder: (context) => items
                                          .map(
                                            (e) => PopupMenuItem<List<PostItem>>(
                                          value: items,
                                          onTap: () {},
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 0,
                                          ),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: e.icons,
                                            title: Text(e.title),
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),

                                  Container(
                                    height: 300,
                                    width: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          "${item?.postUrl}",
                                        ),
                                      ),
                                    ),
                                    child: AnimatedOpacity(
                                      duration: Duration(seconds: 1),
                                      opacity: flag ? 1 : 0,
                                      child: AnimatedFav(
                                        scale: scaleAnimation,
                                        child: IconButton(
                                          onPressed: () {
                                            if (flag) {
                                              scaleController.reverse();
                                            } else {
                                              scaleController.forward();
                                            }
                                            setState(() {
                                              flag = !flag;
                                            });
                                          },
                                          color: Colors.white,
                                          icon: Icon(
                                            color: flag
                                                ? Colors.red
                                                : Colors.white,
                                            flag
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(HeroiconsSolid.heart),
                                        Icon(HeroiconsSolid.share),
                                        Icon(Icons.file_download_outlined),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: 140,
      child: Card(
        color: color,

        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
