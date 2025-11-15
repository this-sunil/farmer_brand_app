import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../Bloc/ProductBloc/ProductBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonsplus/skeletonsplus.dart';
import '../Widget/RefreshButton.dart';

class CategoryScreen extends StatelessWidget {

  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (prev, current) => prev.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.error:
              return Center(
                child: RefreshButton(
                  onTap: () {
                    context.read<ProductBloc>().add(FetchProduct(page: "1"));
                  },
                ),
              );
            default:
              final isLoading = state.status == ProductStatus.loading;
              final productList = state.product?.result ?? [];
              if(productList.isEmpty){
                return Center(child: Text("No Farmer Found !!!"),);
              }
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

                child: GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .9
                  ),
                  itemBuilder: (context, index) {
                    return  Card(
                      elevation: 5,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Hero(
                                tag: '$index',
                                child: Container(
                                  height: 100,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        productList[index].photo ?? '',
                                      ),
                                    ),

                                  ),
                                  child: Align(
                                    alignment: AlignmentGeometry.topRight,
                                    child: Card(
                                      color: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Padding(padding: EdgeInsets.all(8),child: Text(index%2==0?'Active':'Inactive',style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2),child: Text("${productList[index].name}",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(2),child: Text("#${productList[index].city}",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500))),
                            Padding(padding: EdgeInsets.all(2),child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )
                                ),
                                icon: Icon(HeroiconsSolid.shoppingBag,color: Colors.white),
                                onPressed: (){
                                  context.push(AppRoutes.productById,{'id':productList[index].fid.toString(),'name':productList[index].name.toString()});
                                }, label: Text("View Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14))))
                          ],
                        ),
                      );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
            ),
            title: Container(
              height: 14,
              width: 100,
              color: Colors.grey.shade300,
            ),
            subtitle: Container(
              height: 12,
              width: 80,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.only(top: 6),
            ),
            trailing: Container(
              width: 70,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 14,
              width: 120,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
            child: Row(
              children: List.generate(
                3,
                (i) => Container(
                  width: 100,
                  height: 120,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
