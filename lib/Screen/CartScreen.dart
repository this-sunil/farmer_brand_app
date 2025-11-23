import 'dart:collection';
import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:farmer_brand/Bloc/CartBloc/CartBloc.dart';
import 'package:farmer_brand/Widget/NoProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:farmer_brand/Model/CategoryModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:skeletonsplus/skeletonsplus.dart';
import '../Bloc/ProductBloc/ProductBloc.dart';
import '../Services/HashService.dart';
import '../Widget/RefreshButton.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    implements PayUCheckoutProProtocol {
  HashSet<String> selectItem = HashSet<String>();
  late List<CategoryModel> category;
  late PayUCheckoutProFlutter checkoutProFlutter;
  @override
  void initState() {
    // TODO: implement initState
    checkoutProFlutter = PayUCheckoutProFlutter(this);
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

  startTransaction(double amount) async {
    await checkoutProFlutter.openCheckoutScreen(
      payUPaymentParams: {
        PayUPaymentParamKey.key: "rPBQSz",
        PayUPaymentParamKey.transactionId:
            "txn${DateTime.now().millisecondsSinceEpoch}",
        PayUPaymentParamKey.amount: "$amount",
        PayUPaymentParamKey.productInfo: "Farmer Brand",
        PayUPaymentParamKey.firstName: "Sunil",
        PayUPaymentParamKey.email: "swarajya888@gmail.com",
        PayUPaymentParamKey.phone: "8668796251",
        PayUPaymentParamKey.environment: "1",
        PayUPaymentParamKey.android_furl:
            "https:///www.payumoney.com/mobileapp/payumoney/failure.php",
        PayUPaymentParamKey.ios_surl:
            "https:///www.payumoney.com/mobileapp/payumoney/success.php",
        PayUPaymentParamKey.ios_furl:
            "https:///www.payumoney.com/mobileapp/payumoney/failure.php",
      },
      payUCheckoutProConfig: {PayUCheckoutProConfigKeys.merchantName: "PayU"},
    );
  }

  @override
  generateHash(Map response) async {
    // Method 1 :
    Map hashResponse = HashService.generateHash(response);
    checkoutProFlutter.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) {
    log(response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    log(response.toString());
  }

  @override
  onPaymentCancel(dynamic response) {
    log(response.toString());
  }

  @override
  onError(dynamic response) {
    log(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.status == ProductStatus.completed) {
            context.read<CartBloc>().add(FetchCartEvent());
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          buildWhen: (prev, current) => prev.status != current.status,
          builder: (context, state) {
            final isLoading = state.status == CartStatus.loading;
            final productItem = state.cartModel?.result ?? [];

            final totalPrice = productItem.fold<int>(
              0,
              (sum, current) => sum + (current.productQty ?? 0),
            );
            if (state.status == CartStatus.error) {
              return Center(
                child: RefreshButton(
                  onTap: () {
                    context.read<CartBloc>().add(
                      FetchCartEvent(),
                    );
                  },
                ),
              );;
            } else if (productItem.isEmpty) {
              return NoProductScreen();
            }
            return Skeleton(
              isLoading: isLoading,
              skeleton: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
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
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: productItem.length,
                      itemBuilder: (context, index) {
                        final item = productItem[index];

                        return Dismissible(
                          key: Key(item.pid.toString()),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productTitle.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Qty: ${item.productQty} × ${item.productPrice}",
                                        ),
                                        Text(
                                          "\u{20b9} ${(int.tryParse(item.productPrice?.toString() ?? '0') ?? 0) * (int.tryParse(item.productQty?.toString() ?? '0') ?? 0)}",
                                        ),
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
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Card(
                      color: Colors.white,
                      child: DottedBorder(
                        options: RectDottedBorderOptions(
                          dashPattern: [
                            5,
                            4,
                          ], // Length of dash, length of space
                          strokeWidth: 1,
                          color: Colors.black,
                          padding: EdgeInsets.all(8),
                        ),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Amount",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      " \u{20b9}$totalPrice",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Delivery Charges",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "\u{20b9} 50",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Total Amount",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "\u{20b9} ${totalPrice + 50}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        startTransaction(totalPrice.toDouble());
                      },
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),

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
