import 'package:flutter/material.dart';

import '../Model/CategoryModel.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: GridView.builder(
          itemCount: category.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder: (context,index){
            final item=category[index];
            return Card(
              color: Colors.white,
              child: Column(


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

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            );
      }),
    );
  }
}
