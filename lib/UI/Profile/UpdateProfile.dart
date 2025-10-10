import 'dart:io';

import 'package:farmer_brand/Services/HelperMixin.dart';
import 'package:farmer_brand/Services/PickImage.dart';
import 'package:farmer_brand/Services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../Bloc/AuthBloc/AuthBloc.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> with HelperMixin {
  GlobalKey<FormState> updateKey = GlobalKey<FormState>();
  File? file;
  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController states;
  late TextEditingController city;

  pickImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          title: Text("Pick Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  context.pop();
                  final imgPath = await PickerImage.instance.pickImage(
                    source: ImageSource.camera,
                  );
                  setState(() {
                    file = File(imgPath.path);
                  });
                },
                leading: Icon(Icons.camera),
                title: Text("Camera"),
              ),
              ListTile(
                onTap: () async {
                  context.pop();
                  final imgPath = await PickerImage.instance.pickImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {
                    file = File(imgPath.path);
                  });
                },
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    name = TextEditingController();
    phone = TextEditingController();
    states = TextEditingController();
    city = TextEditingController();
    context.read<AuthBloc>().add(FetchProfileEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    phone.dispose();
    states.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Profile")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthStatus.fetch:
              name.text = '${state.result?.result?.name.toString()}';
              phone.text = '${state.result?.result?.phone.toString()}';
              states.text = '${state.result?.result?.state.toString()}';
              city.text = '${state.result?.result?.city.toString()}';
              break;
            default:
              break;
          }
        },
        child: Form(
          key: updateKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.center,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case AuthStatus.fetch:
                        return Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,

                              image: NetworkImage(
                                'https://res.cloudinary.com/dluddj8ca/image/upload/v1760064211/${state.result?.result?.photo}.jpg',
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentGeometry.bottomRight,
                            child: IconButton(
                              onPressed: () async {
                                await pickImage();
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                        );
                      default:
                        return Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: file == null
                                  ? AssetImage(
                                      "assets/icons/village-farmer.png",
                                    )
                                  : FileImage(File(file!.path)),
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentGeometry.bottomRight,
                            child: IconButton(
                              onPressed: () async {
                                await pickImage();
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                        );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8),
                child: textFormWidget(
                  controller: name,
                  radius: 10,
                  prefixIcon: Icon(Icons.person),
                  hintText: "Enter Name",
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
                  controller: states,
                  radius: 10,
                  prefixIcon: Icon(Icons.location_city),
                  hintText: "Enter State",
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
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthStatus.update:
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("${state.msg}")));
                      break;
                    case AuthStatus.error:
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("${state.msg}")));
                      break;
                    default:
                      break;
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
                    case AuthStatus.loading:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                UpdateEvent(
                                  name: name.text,
                                  phone: phone.text,
                                  state: states.text,
                                  city: city.text,
                                  file: file,
                                ),
                              );
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
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
    );
  }
}
