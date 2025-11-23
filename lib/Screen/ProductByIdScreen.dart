import 'dart:developer';

import 'package:farmer_brand/Widget/NoProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonsplus/skeletonsplus.dart';
import '../Bloc/ProductBloc/ProductBloc.dart';
import '../Bloc/ProductByIdBloc/ProductByIdBloc.dart';

class ProductByIdScreen extends StatefulWidget {
  final String id;
  final String name;
  const ProductByIdScreen({super.key, required this.id, required this.name});

  @override
  State<ProductByIdScreen> createState() => _ProductByIdScreenState();
}

class _ProductByIdScreenState extends State<ProductByIdScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ProductByIdBloc>().add(ProductById(id: widget.id));
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
      appBar: AppBar(title: Text(widget.name)),
      body: BlocListener<ProductBloc,ProductState>(
          listenWhen: (prev,current)=>prev!=current,
          listener: (context,state){
        switch(state.status){
          case ProductStatus.completed:
            context.read<ProductByIdBloc>().add(ProductById(id: widget.id));
            break;
          default:
            break;
        }
      },child: BlocBuilder<ProductByIdBloc, ProductByIdState>(
        builder: (context, state) {
          final isLoading = state.status == ProductByIdStatus.loading;
          final productList = state.product?.result ?? [];

              return Skeleton(
                isLoading: isLoading,
                skeleton: GridView.builder(
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Card();
                  },
                ),
                child: productList.isNotEmpty
                    ? SizedBox(
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(
                      bottom: 5,
                      left: 5,
                      right: 5,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, currentIndex) {
                      final productItem = productList[currentIndex];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        shadowColor: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Hero(
                                tag: '$currentIndex',
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        productItem.productPhoto ?? '',
                                      ),
                                    ),
                                  ),
                                  child: Align(
                                    alignment:
                                    AlignmentGeometry.bottomRight,
                                    child: productItem.productQty != 0
                                        ? SizedBox(
                                      height: 50,
                                      child: Card(
                                        color: Colors.pink,
                                        child: Row(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                int qty =
                                                    int.parse(
                                                      productItem
                                                          .productQty
                                                          .toString(),
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
                                                    pid: productItem
                                                        .pid
                                                        .toString(),
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
                                              "${productItem.productQty}",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                int qty =
                                                    int.parse(
                                                      productItem
                                                          .productQty
                                                          .toString(),
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
                                                    pid: productItem
                                                        .pid
                                                        .toString(),
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
                                    )
                                        : IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        context
                                            .read<ProductBloc>()
                                            .add(
                                          AddQuantity(
                                            pid: productItem.pid
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
                                        Colors.grey.shade300,
                                        color: Colors.pinkAccent,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.white
                                                .withValues(
                                              alpha: .5,
                                            ),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            2,
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 5,
                                top: 8,
                              ),
                              child: Text(
                                productItem.productTitle ?? "Unknown",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
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
                      );
                    },
                  ),
                )
                    : const NoProductScreen(),
              );
          
        },
      )),
    );
  }
}
