import 'dart:collection';
import 'dart:developer';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:farmer_brand/Bloc/BannerBloc/BannerBloc.dart';
import 'package:farmer_brand/Bloc/ProductBloc/ProductBloc.dart';
import 'package:farmer_brand/Bloc/WeatherBloc/WeatherBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonsplus/skeletonsplus.dart';

import '../Bloc/AuthBloc/AuthBloc.dart';
import '../Widget/RefreshButton.dart';

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
    context.read<WeatherBloc>().add(
      FetchWeatherEvent("17.691401", "74.000938"),
    );

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
    animationController.removeListener(() {});
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
              listenWhen: (prev, current) => prev.status != current.status,
              listener: (context, state) {
                if (state.status == BannerStatus.completed) {
                  log("Banners loaded: ${state.model?.result?.length ?? 0}");
                }
              },
              buildWhen: (prev, current) => prev.status != current.status,
              builder: (context, state) {
                switch (state.status) {
                  case BannerStatus.error:
                    return Center(
                      child: RefreshButton(
                        onTap: () {
                          context.read<BannerBloc>().add(FetchBannerEvent());
                        },
                      ),
                    );
                  default:
                    final isLoading = state.status == BannerStatus.loading;
                    final banners = state.model?.result ?? [];
                    return Skeleton(
                      isLoading: isLoading,
                      skeleton: _buildBannerCard(),
                      child: Builder(
                        builder: (context) {
                          switch (state.status) {
                            case BannerStatus.completed:
                              if (banners.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "No banners available",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: banners.length,
                                    itemBuilder: (context, index, realIdx) {
                                      final item = banners[index];
                                      return Hero(
                                        tag: item.title ?? 'banner_$index',
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              item.photo ?? '',
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                    if (progress == null) {
                                                      return child;
                                                    }
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  },
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black54,
                                                  ],
                                                  stops: [0.6, 1.0],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 16,
                                              left: 16,
                                              right: 16,
                                              child: Text(
                                                item.title ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black54,
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 250,
                                      autoPlay: true,
                                      enlargeCenterPage: false,
                                      viewportFraction: 1,
                                      aspectRatio: 16 / 9,
                                      autoPlayInterval: const Duration(
                                        seconds: 4,
                                      ),
                                      autoPlayAnimationDuration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      onPageChanged: (index, reason) {
                                        setState(() => currentIndex = index);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Indicator Dots
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: banners.asMap().entries.map((
                                        entry,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(
                                              () => currentIndex = entry.key,
                                            );
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            width: currentIndex == entry.key
                                                ? 15
                                                : 8,
                                            height: 5,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: currentIndex == entry.key
                                                  ? Colors.black
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              );

                            case BannerStatus.error:
                              return Center(
                                child: Text(
                                  state.msg ?? "Failed to load banners",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );

                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                    );
                }
              },
            ),

            BlocBuilder<ProductBloc, ProductState>(
              buildWhen: (prev, current) => prev.status != current.status,
              builder: (context, state) {
                switch (state.status) {
                  case ProductStatus.error:
                    return Center(
                      child: RefreshButton(
                        onTap: () {
                          context.read<ProductBloc>().add(
                            FetchProduct(page: "1"),
                          );
                        },
                      ),
                    );
                  default:
                    final isLoading = state.status == ProductStatus.loading;
                    final productList = state.product?.result ?? [];
                    return Skeleton(
                      isLoading: isLoading,
                      skeleton: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildProductCard();
                        },
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Our Farmers Product",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text("See All"),
                                ),
                              ],
                            ),
                          ),

                          ListView.builder(
                            itemCount: productList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = productList[index];
                              final productItems = item.products ?? [];
                              if (productItems.isEmpty) {
                                return Container();
                              }
                              return SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(
                                    bottom: 5,
                                    left: 5,
                                    right: 5,
                                  ),
                                  itemCount: productItems.length,
                                  itemBuilder: (context, currentIndex) {
                                    final productItem =
                                        productItems[currentIndex];
                                    return SizedBox(
                                      width: 150,
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: Hero(
                                                tag: '$index$currentIndex',
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
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
                                                      image: NetworkImage(
                                                        productItem
                                                                .productPhoto ??
                                                            '',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment: AlignmentGeometry
                                                        .bottomRight,
                                                    child:
                                                        productItem
                                                                .productQty !=
                                                            0
                                                        ? SizedBox(
                                                            height: 50,
                                                            child: Card(
                                                              color:
                                                                  Colors.pink,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      int qty =
                                                                          int.parse(
                                                                            productItem.productQty.toString(),
                                                                          ) -
                                                                          1;
                                                                      log(
                                                                        "Remove qty=>$qty",
                                                                      );
                                                                      context
                                                                          .read<
                                                                            ProductBloc
                                                                          >()
                                                                          .add(
                                                                            AddQuantity(
                                                                              pid: productItem.pid.toString(),
                                                                              qty: qty,
                                                                            ),
                                                                          );
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove_circle,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),

                                                                  Text(
                                                                    "${productItem.productQty}",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      int qty =
                                                                          int.parse(
                                                                            productItem.productQty.toString(),
                                                                          ) +
                                                                          1;
                                                                      log(
                                                                        "message=>$qty",
                                                                      );
                                                                      context
                                                                          .read<
                                                                            ProductBloc
                                                                          >()
                                                                          .add(
                                                                            AddQuantity(
                                                                              pid: productItem.pid.toString(),
                                                                              qty: qty,
                                                                            ),
                                                                          );
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .add_circle,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              context.read<ProductBloc>().add(
                                                                AddQuantity(
                                                                  pid: productItem
                                                                      .pid
                                                                      .toString(),
                                                                  qty:
                                                                      double.parse(
                                                                        productItem
                                                                            .productQty
                                                                            .toString(),
                                                                      ).toInt() +
                                                                      1,
                                                                ),
                                                              );
                                                            },
                                                            icon: Card(
                                                              elevation: 8,
                                                              shadowColor:
                                                                  Colors
                                                                      .grey
                                                                      .shade300,
                                                              color: Colors
                                                                  .pinkAccent,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            .5,
                                                                      ),
                                                                  width: 1.5,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      5,
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      2,
                                                                    ),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                child: Text(
                                                  productItem.productTitle ??
                                                      "Unknown",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              child: Text(
                                                "\u{20b9} ${productItem.productPrice} / ${productItem.productWeight ?? '--'}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildProductCard() {
  return SizedBox(
    height: 180,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
      itemCount: 10,
      itemBuilder: (context, currentIndex) {
        return SizedBox(
          width: 150,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            shadowColor: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Hero(
                    tag: '$currentIndex',
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildBannerCard() {
  return SizedBox(
    height: 250,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    ),
  );
}

/*

Widget _buildInfoCard({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

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
*/
