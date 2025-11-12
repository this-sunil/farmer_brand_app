import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';

class OverViewScreen extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String imgPath;
  
  const OverViewScreen({super.key, required this.id,required this.name, required this.imgPath,required this.price});
  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  
  @override
  void initState() {
    // TODO: implement initState
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

      body:  Column(
          children: [
            Hero(tag: widget.id, child: Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/icons/village-farmer.png'))
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 10,
                    child: CircleAvatar(
                      maxRadius: 22,
                      backgroundColor: Colors.white.withValues(alpha: .8),
                      child: IconButton(onPressed: (){
                        context.pop();
                      }, icon: Icon(Icons.keyboard_arrow_left_rounded)),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 10,
                    child: CircleAvatar(
                      maxRadius: 22,

                      backgroundColor: Colors.white.withValues(alpha: .8),
                      child: IconButton(onPressed: (){
                        context.pop();
                      }, icon: Icon(Icons.share_sharp)),
                    ),
                  ),
                ],
              ),
            )),
            Padding(padding: EdgeInsets.all(8),child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                Text("\u{20b9} ${widget.price}",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
              ],
            )
            )
          ],

      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal:25,vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton.extended(
            backgroundColor:Colors.pink,
            icon: Icon(Icons.local_shipping,color: Colors.white),
            onPressed: (){},label: Text("Place Order",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold))),
      ),
    );
  }
}
