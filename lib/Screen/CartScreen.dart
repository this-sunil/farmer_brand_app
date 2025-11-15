import 'dart:collection';
import 'dart:developer';
import 'package:farmer_brand/Bloc/CartBloc/CartBloc.dart';
import 'package:flutter/material.dart';
import 'package:farmer_brand/Model/CategoryModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonsplus/skeletonsplus.dart';

import '../Bloc/ProductBloc/ProductBloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  HashSet<String> selectItem = HashSet<String>();
  late List<CategoryModel> category;
  @override
  void initState() {
    // TODO: implement initState
    category = [
      CategoryModel(
        id: "1",
        title: "Eggs",
        imgPath: "assets/category/eggs.jpg",
      ),
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
    context.read<CartBloc>().add(FetchCartEvent());
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
      body:BlocListener<ProductBloc,ProductState>(listener: (context,state){
        switch(state.status){
          case ProductStatus.completed:
            context.read<CartBloc>().add(FetchCartEvent());
          default:
            break;
        }
      },child:  BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final isLoading = state.status == CartStatus.loading;
          final productItem = state.cartModel?.result ?? [];

          return Skeleton(
            isLoading: isLoading,
            skeleton: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return  Card(

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 20,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
              },
            ),
            child: ListView.builder(
              itemCount: productItem.length,
              itemBuilder: (context, index) {
                final item = productItem[index];
                if (productItem.isEmpty) {
                  return Center(child: Text("No Data Found !!!"));
                }
                return Dismissible(
                  key: Key(productItem[index].pid.toString()),
                  onDismissed: (direction) {},
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  resizeDuration: Duration(seconds: 1),
                  child: Card(
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  item.productPhoto.toString(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productTitle.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text("\u{20b9} ${item.productPrice}"),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Card(
                              elevation: 10,
                              color: Colors.deepOrangeAccent,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      int qty =
                                          int.parse(
                                            item.productQty.toString(),
                                          ) -
                                              1;
                                      log("Remove qty=>$qty");
                                      context.read<ProductBloc>().add(
                                        AddQuantity(
                                          pid: item.pid.toString(),
                                          qty: qty,
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${item.productQty}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      int qty =
                                          int.parse(
                                            item.productQty.toString(),
                                          ) +
                                              1;
                                      log("Remove qty=>$qty");
                                      context.read<ProductBloc>().add(
                                        AddQuantity(
                                          pid: item.pid.toString(),
                                          qty: qty,
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
      )),
      // body: ListView.builder(
      //   scrollDirection: Axis.vertical,
      //   itemCount: category.length,
      //   itemBuilder: (context, index) {
      //     final item = category[index];
      //     return Dismissible(
      //         key: Key(item.id),
      //       onDismissed: (direction) {
      //         setState(() {
      //           category.remove(item);
      //         });
      //
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(content: Text('${item.title} dismissed')),
      //         );
      //       },
      //       direction: DismissDirection.endToStart,
      //         background: Container(
      //           color: Colors.red,
      //           alignment: Alignment.centerRight,
      //           padding: EdgeInsets.symmetric(horizontal: 20),
      //           child: Icon(Icons.delete, color: Colors.white),
      //         ),
      //         resizeDuration: Duration(seconds: 1),
      //         child: Padding(padding: EdgeInsets.all(8),child: Card(
      //           color: Colors.white,
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Container(
      //                 width: 60,
      //                 height: 60,
      //                 margin: EdgeInsets.all(8),
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(10),
      //                   image: DecorationImage(
      //                     fit: BoxFit.cover,
      //                     image: AssetImage(item.imgPath),
      //                   ),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Padding(
      //                   padding: EdgeInsets.all(8),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         item.title,
      //                         style: TextStyle(
      //                           color: Colors.black,
      //                           fontSize: 16,
      //                           fontWeight: FontWeight.w600,
      //                         ),
      //                       ),
      //                       Text("qty ${item.qty}"),
      //                       Text("\u{20b9} ${item.qty * 10}"),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.all(8),
      //                 child: Card(
      //                   elevation: 10,
      //                   color: Colors.deepOrangeAccent,
      //                   child: Row(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       IconButton(
      //                         onPressed: () {
      //                           if (item.qty == 1) {
      //                             setState(() {
      //                               selectItem.remove(item.id);
      //                             });
      //                           } else {
      //                             setState(() {
      //                               item.qty--;
      //                             });
      //                           }
      //                         },
      //                         icon: Icon(Icons.remove_circle, color: Colors.white),
      //                       ),
      //                       Text("${item.qty}", style: TextStyle(color: Colors.white)),
      //                       IconButton(
      //                         onPressed: () {
      //                           setState(() {
      //                             item.qty++;
      //                           });
      //                         },
      //                         icon: Icon(Icons.add_circle, color: Colors.white),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         )),
      //
      //     );
      //
      //   },
      // ),
    );
  }
}
