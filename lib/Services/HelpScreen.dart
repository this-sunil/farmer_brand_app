import 'dart:async';
import 'dart:collection';
import 'package:farmer_brand/Model/CategoryModel.dart';
import 'package:farmer_brand/Services/HelperMixin.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with HelperMixin {
  HashSet<String> selectItem=HashSet<String>();
  late TextEditingController searchController;
  List<CategoryModel> category = [
    CategoryModel(id: "1", title: "Eggs", imgPath: "assets/category/eggs.jpg"),
    CategoryModel(
      id: "2",
      title: "Vegetable",
      imgPath: "assets/category/Vegetables.jpg",
    ),
    CategoryModel(
      id: "3",
      title: "Dry Fruits",
      imgPath: "assets/category/dry-fruit.jpg",
    ),
    CategoryModel(
      id: "4",
      title: "Fruits",
      imgPath: "assets/category/fruits.jpg",
    ),
  ];
  List<CategoryModel> product = [
    CategoryModel(id: "5", title: "Eggs", imgPath: "assets/category/eggs.jpg"),
    CategoryModel(
      id: "6",
      title: "Vegetable",
      imgPath: "assets/category/Vegetables.jpg",
    ),
    CategoryModel(
      id: "7",
      title: "Dry Fruits",
      imgPath: "assets/category/dry-fruit.jpg",
    ),
    CategoryModel(
      id: "8",
      title: "Fruits",
      imgPath: "assets/category/fruits.jpg",
    ),
  ];
  int activeIndex = 0;
  late PageController pageController;
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (activeIndex < category.length - 1) {
        activeIndex++;
      } else {
        activeIndex = 0;
      }
      pageController.animateToPage(
        activeIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
    searchController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    pageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,

              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: category.length,
                      onPageChanged: (int index) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = category[index];
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            width: context.sizes.width,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(item.imgPath),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        category.length,
                            (index) => GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: activeIndex == index ? 20 : 10,
                            height: activeIndex == index ? 5 : 10,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: activeIndex == index
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(8),child: Card(color: Colors.white,child: textFormWidget(
                radius: 10,
                hintText: "Search Product",
                controller: searchController,
                prefixIcon: Icon(HeroiconsSolid.magnifyingGlass),
                suffixIcon: Icon(HeroiconsSolid.adjustmentsHorizontal)
            ))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text("See All")),
                ],
              ),
            ),

            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: category.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = category[index];
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: Colors.green.shade200,
                            backgroundImage: AssetImage(item.imgPath),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Products",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text("See All")),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: category.length,
                itemBuilder: (context, index) {
                  final item = category[index];
                  return Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: 160,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(item.imgPath),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment:AlignmentGeometry.topRight,
                                  child: Card(
                                    color: Colors.deepOrangeAccent,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(10),
                                        )
                                    ),
                                    child: Padding(padding: EdgeInsets.all(8),child: Text("20 % off",style: TextStyle(color: Colors.white))),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentGeometry.bottomRight,
                                  child: selectItem.contains(item.id)?Card(
                                    elevation: 10,
                                    color: Colors.deepOrangeAccent,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(onPressed: (){
                                          if(item.qty==1){
                                            selectItem.remove(item.id);
                                          }
                                          else{
                                            item.qty--;
                                          }
                                          setState(() {});
                                        }, icon: Icon(Icons.remove_circle,color: Colors.white)),
                                        Text("${item.qty}",style: TextStyle(color: Colors.white)),
                                        IconButton(onPressed: (){
                                          setState(() {
                                            item.qty++;
                                          });
                                        }, icon: Icon(Icons.add_circle,color: Colors.white))
                                      ],
                                    ),
                                  ):IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectItem.add(item.id);
                                      });
                                    },
                                    icon: Card(
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '\u{20b9} ${item.qty*10}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Special Products",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text("See All")),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.length,
                itemBuilder: (context, index) {
                  final item = product[index];
                  return Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: 160,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(item.imgPath),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment:AlignmentGeometry.topRight,
                                  child: Card(
                                    color: Colors.deepOrangeAccent,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(10),
                                        )
                                    ),
                                    child: Padding(padding: EdgeInsets.all(8),child: Text("20 % off",style: TextStyle(color: Colors.white))),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentGeometry.bottomRight,
                                  child: selectItem.contains(item.id)?Card(
                                    elevation: 10,
                                    color: Colors.deepOrangeAccent,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(onPressed: (){
                                          if(item.qty==1){
                                            selectItem.remove(item.id);
                                          }
                                          else{
                                            item.qty--;
                                          }
                                          setState(() {});
                                        }, icon: Icon(Icons.remove_circle,color: Colors.white)),
                                        Text("${item.qty}",style: TextStyle(color: Colors.white)),
                                        IconButton(onPressed: (){
                                          setState(() {
                                            item.qty++;
                                          });
                                        }, icon: Icon(Icons.add_circle,color: Colors.white))
                                      ],
                                    ),
                                  ):IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectItem.add(item.id);
                                      });
                                    },
                                    icon: Card(
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '\u{20b9} ${item.qty*10}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
