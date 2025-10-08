import 'dart:developer';

import 'package:farmer_brand/Bloc/AuthBloc/AuthBloc.dart';
import 'package:farmer_brand/Services/HelperMixin.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../Services/LocalStorage.dart';
import '../../Widget/FarmerIconWidget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with HelperMixin {
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController adhar;
  late TextEditingController pass;
  late TextEditingController states;
  late TextEditingController city;
  bool flag = true;
  LocalStorage localStorage=LocalStorage();
  @override
  void initState() {
    // TODO: implement initState
    name = TextEditingController();
    phone = TextEditingController();
    adhar = TextEditingController();
    pass = TextEditingController();
    states = TextEditingController();
    city = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    phone.dispose();
    adhar.dispose();
    pass.dispose();
    states.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: registerKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                FarmerIconWidget(imgPath: "assets/icons/farmer-garden.jpg"),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: textFormWidget(
                    controller: name,
                    radius: 10,
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter Full Name",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: textFormWidget(
                    controller: phone,
                    radius: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Enter Phone number",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: textFormWidget(
                    controller: pass,
                    obscureText: flag,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Enter Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                      icon: Icon(
                        flag ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: textFormWidget(
                    controller: states,
                    radius: 10,
                    prefixIcon: Icon(Icons.location_city),
                    hintText: "Enter state",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: textFormWidget(
                    controller: city,
                    radius: 10,
                    prefixIcon: Icon(Icons.location_on),
                    hintText: "Enter city",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: textFormWidget(
                    controller: adhar,
                    radius: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(
                      HeroiconsSolid.shieldCheck,
                      color: Colors.black,
                      size: 20,
                    ),
                    hintText: "Enter Aadhaar card number",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push(AppRoutes.login);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) async{
                    switch (state.status) {
                      case AuthStatus.login:
                        log("Success");
                        await localStorage.setUID(
                          "${state.result?.result?.id.toString()}",
                        );
                        await localStorage.setToken(
                          "${state.result?.token.toString()}",
                        );
                        context.pushReplace(AppRoutes.dashboard);
                        break;
                      case AuthStatus.error:
                        log("Error=>${state.msg}");
                      default:
                        break;
                    }
                  },
                  builder: (context, state) {
                    switch (state.status) {
                      case AuthStatus.loading:
                        return Center(child: CircularProgressIndicator());
                      default:
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: context.sizes.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                backgroundColor: Colors.orange.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (registerKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    RegisterEvent(
                                      name: name.text,
                                      phone: phone.text,
                                      pass: pass.text,
                                      state: states.text,
                                      city: city.text,
                                    ),
                                  );
                                  registerKey.currentState!.save();
                                }
                                // context.pushReplace(AppRoutes.verifyOtp,{
                                //   "name":name.text,
                                //   "phone":phone.text,
                                //   "pass":pass.text
                                // });
                              },
                              child: Text(
                                "Submit".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
