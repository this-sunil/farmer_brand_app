import 'package:farmer_brand/Services/LocalStorage.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:farmer_brand/Widget/FarmerIconWidget.dart';
import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocalStorage localStorage=LocalStorage();
    return Scaffold(
      body:SingleChildScrollView(
        child:  Column(
          children: [
            FarmerIconWidget(imgPath: "assets/icons/farmer-garden.jpg",width: 140,height: 140),
            Padding(padding: EdgeInsets.all(2),child: Text("Farmer",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18))),
            Padding(padding: EdgeInsets.all(2),child: Text("+91876567575")),
            SizedBox(height: 20),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.local_shipping),
                ),
                title: Text("My Order",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.edit),
                ),
                title: Text("Update Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(HeroiconsSolid.language),
                ),
                title: Text("App Language",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(HeroiconsSolid.shieldCheck),
                ),
                title: Text("Privacy Policy",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                onTap: (){
                  context.push(AppRoutes.chat);
                },
                leading: CircleAvatar(
                  child: Icon(HeroiconsSolid.academicCap),
                ),
                title: Text("Chat Assistance",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.call),
                ),
                title: Text("Contact Us",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),
            Card(
              elevation:2,
              color: Colors.white,
              child: ListTile(
                onTap: () async{
                  await localStorage.resetUID();
                  await localStorage.resetToken();
                  if(context.mounted) {
                    context.pushReplace(AppRoutes.login);
                  }
                },
                leading: CircleAvatar(
                  child: Icon(Icons.logout),
                ),
                title: Text("Log Out",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
