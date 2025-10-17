import 'dart:developer';

import 'package:farmer_brand/Bloc/AuthBloc/AuthBloc.dart';
import 'package:farmer_brand/Services/HelperMixin.dart';
import 'package:farmer_brand/Services/LocalStorage.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:farmer_brand/Widget/FarmerIconWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with HelperMixin{
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  late TextEditingController phone;
  late TextEditingController pass;
  bool flag=true;
  LocalStorage localStorage=LocalStorage();
  @override
  void initState() {
    // TODO: implement initState
    phone = TextEditingController();
    pass = TextEditingController();
    //FirebaseApi.instance.sendOtp("8668796251");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    phone.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Form(
        key: loginKey,
        child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FarmerIconWidget(imgPath: "assets/icons/farmer-garden.jpg"),
                Padding(padding: EdgeInsets.all(10),child: Text("Login",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold))),

                Padding(padding: EdgeInsets.all(8),child: textFormWidget(
                    controller: phone,
                    radius: 10,
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Enter Phone number"
                )),
                Padding(padding: EdgeInsets.all(8),child: textFormWidget(
                    controller: pass,
                    obscureText: flag,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Enter Password",
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        flag=!flag;
                      });
                    }, icon: Icon(flag?Icons.visibility_off:Icons.visibility))
                )),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8),child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Create an account?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                    TextButton(onPressed: (){
                      context.push(AppRoutes.register);

                    }, child: Text("Register",style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline,decorationColor: Colors.blue))),
                  ],
                )),
                BlocConsumer<AuthBloc,AuthState>(
                    listenWhen: (prev,current)=>prev.status!=current.status,
                    builder: (context,state){
                  switch(state.status){
                    case AuthStatus.loading:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return Padding(padding: EdgeInsets.all(10),child: SizedBox(
                        width: context.sizes.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                backgroundColor: Colors.orange.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            onPressed: () async{
                              if(loginKey.currentState!.validate()){
                                context.read<AuthBloc>().add(LoginEvent(phone: phone.text, pass: pass.text));
                                loginKey.currentState!.save();
                              }
                            }, child: Text("Submit".toUpperCase(),style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold))),
                      ));
                  }
                }, listener: (context,state) async{
                  switch(state.status) {
                    case AuthStatus.login:
                      log("Success");
                      await localStorage.setUID("${state.result?.result?.id.toString()}");
                      await localStorage.setToken("${state.result?.token.toString()}");
                      context.pushReplace(AppRoutes.dashboard);
                      break;
                    case AuthStatus.error:
                      log("Error=>${state.msg}");
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text("${state.msg}"),
                          actions: [
                            TextButton(onPressed: (){
                              context.pop();
                            }, child: Text("Ok"))
                          ],
                        );
                      });
                      break;
                    default:
                      break;
                  }
                })

              ]),

      )),
    );
  }
}
