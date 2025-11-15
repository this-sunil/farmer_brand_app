import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonsplus/skeletonsplus.dart';
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
      body: BlocBuilder<ProductByIdBloc, ProductByIdState>(
        builder: (context, state) {
          final isLoading = state.status == ProductByIdStatus.loading;
          final productList = state.product?.result ?? [];
          switch (state.status) {
            default:
              return Skeleton(
                isLoading: isLoading,
                skeleton: GridView.builder(
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Card();
                  },
                ),
                child: productList.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                            bottom: 5,
                            left: 5,
                            right: 5,
                          ),
                          itemCount: productList.length,
                          itemBuilder: (context, currentIndex) {
                            final productItem = productList[currentIndex];
                            return  Card(
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
                                            borderRadius:
                                                const BorderRadius.only(
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
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {},
                                              icon: Card(
                                                elevation: 8,
                                                shadowColor:
                                                    Colors.grey.shade300,
                                                color: Colors.pinkAccent,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors.white
                                                        .withValues(alpha: .5),
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(2),
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
                                        horizontal: 8,vertical: 5
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
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            "No products available.",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ),
              );
          }
        },
      ),
    );
  }
}
