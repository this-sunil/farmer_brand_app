import 'dart:async';

import 'package:farmer_brand/Services/HelperMixin.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Widget/FarmerIconWidget.dart';

class VerifyScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String pass;
  const VerifyScreen({
    super.key,
    required this.phone,
    required this.pass,
    required this.name,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen>
    with HelperMixin, SingleTickerProviderStateMixin {
  late TextEditingController first, second, third, fourth;
  late FocusNode firstFocus, secondFocus, thirdFocus, fourthFocus;
  late Timer timer;
  late AnimationController animationController;
  late Animation<Duration> animation;
  @override
  void initState() {
    // TODO: implement initState
    first = TextEditingController();
    second = TextEditingController();
    third = TextEditingController();
    fourth = TextEditingController();

    firstFocus = FocusNode();
    secondFocus = FocusNode();
    thirdFocus = FocusNode();
    fourthFocus = FocusNode();

    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 30))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {});
            }
          });
    animation = Tween(begin: Duration(seconds: 30), end: Duration.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    first.dispose();
    second.dispose();
    third.dispose();
    fourth.dispose();
    firstFocus.dispose();
    secondFocus.dispose();
    thirdFocus.dispose();
    fourthFocus.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: CircleAvatar(
                  maxRadius: 22,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),

              Align(
                alignment: AlignmentGeometry.center,
                child: FarmerIconWidget(
                  imgPath: "assets/icons/farmer-garden.jpg",
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.center,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Verify Mobile Number ${widget.phone}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    pinField(controller: first, focus: firstFocus),
                    pinField(controller: second, focus: secondFocus),
                    pinField(controller: third, focus: thirdFocus),
                    pinField(controller: fourth, focus: fourthFocus),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(2),
                child: animationController.isCompleted
                    ? Align(
                        alignment: AlignmentGeometry.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent
                          ),
                          onPressed: () {
                            setState(() {
                              animationController
                                ..reset()
                                ..forward();
                            });
                          },
                          child: Text(
                            "RESEND OTP",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return Text(
                                "00:${animation.value.inSeconds.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: context.sizes.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.green.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      // final result=await FirebaseApi.instance.verifyNumber(phone.text);
                      // result.fold((l)=>log(l.toString()), (r)=>context.pushReplace(AppRoutes.dashboard));
                      //context.pushReplace(AppRoutes.dashboard);
                    },
                    child: Text(
                      "Verify OTP".toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pinField({
    required TextEditingController controller,
    required FocusNode focus,
  }) {
    return SizedBox(
      width: 50,
      height: 60,
      child: textFormWidget(
        textAlign: TextAlign.center,
        controller: controller,
        focusNode: focus,
        onChanged: (v) {
          if (v.length == 1) {
            focus.nextFocus();
          } else {
            focus.previousFocus();
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        radius: 10,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
