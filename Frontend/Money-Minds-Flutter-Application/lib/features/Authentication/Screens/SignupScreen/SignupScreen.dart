import 'dart:convert';

import 'package:financeseekho/common/theme_model.dart';
import 'package:financeseekho/common/theme_provider.dart';
import 'package:financeseekho/features/Authentication/Screens/LoginScreen/LoginScreen.dart';
import 'package:financeseekho/features/NavigationBottomController/NavigationBottomController.dart';
import 'package:financeseekho/utils/device/device_utility.dart';
import 'package:financeseekho/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool imageSelected = false;
  bool isLoading = false;

  String email = '';
  String password = '';
  String name = '';
  String profession = '';
  String mobile = '';
  String gender = 'Male';
  int age = 0;
  late File _image;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile !=null){
      imageSelected = true;
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void registerUser() async {
    if (name.isNotEmpty && password.isNotEmpty && email.isNotEmpty && mobile.isNotEmpty && profession.isNotEmpty && gender.isNotEmpty ){
      setState(() {
        isLoading = true;
      });
      var reqBody = {
        "name": name,
        "gender": gender,
        "age": age,
        "email": email,
        "phone": mobile,
        "profession": profession,
        "password": password
      };

      try{
          var jsonResponse = await http.post(
              Uri.parse('https://712c-2401-4900-40fd-664e-d0c4-5d78-b38-3229.ngrok-free.app/users/signup'),
              headers: {"content-Type": "application/json"},
              body: jsonEncode(reqBody)
          );

          var response = jsonDecode(jsonResponse.body);


          if (jsonResponse.statusCode ==201) {
            setState(() {
              isLoading = false;
            });

            HelperFunctions.shiftToScreen(context, const LoginScreen());
            HelperFunctions.showAlert('Sign Up', 'User Registration Successful for ${response['email']}\nPlease Login to access our services.');

          } else {
            setState(() {
              isLoading = false;
            });

            HelperFunctions.showAlert('Sign Up', 'User Registration Failed !\nError: ${jsonResponse.statusCode} - Invalid Details');
          }

      } catch(e) {
          print(e);
          setState(() {
            isLoading = false;
          });

          bool isConnected = await DeviceUtils.isConnected();
          if(!isConnected) {
            HelperFunctions.showAlert('Sign Up', 'Please Connect to Internet Connection');
          }
          else {
            HelperFunctions.showAlert('Sign Up', 'An error occurred while registration ! Please retry again.');
          }
      }

    } else {
      HelperFunctions.showSnackBar('Please Enter Valid Details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
              onTap: (){
                setState(() {
                  Provider.of<ThemeModel>(context, listen: false).toggleTheme();
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20,bottom: 10),
                child: Icon(Provider.of<ThemeProvider>(context).isDark ? Icons.light_mode_outlined: Icons.dark_mode_outlined)
              )
          ),
          GestureDetector(
              onTap: (){
                HelperFunctions.navigateToScreen(context, const BottomNavBarController());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 25, bottom: 12),
                child: Text('Skip', style: Theme.of(context).textTheme.bodyMedium,),
              )
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personal Information', style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: 5,),
                  Text('Enter your personal information', style: Theme.of(context).textTheme.bodyMedium,),

                  const SizedBox(height: 25,),

                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: imageSelected != false
                              ? DecorationImage(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          )
                              : const DecorationImage(
                            image: AssetImage('assets/icons/profile_icon.avif'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle
                        ),
                      ),

                      const SizedBox(width: 12,),

                      Expanded(child: Text('Capture and select your own image', style: Theme.of(context).textTheme.bodySmall,)),

                      IconButton(
                          onPressed: (){
                            getImage(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.camera_alt_outlined)
                      )
                    ],
                  ),

                  const SizedBox(height: 20,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                           0xFF000811): Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name', style: Theme.of(context).textTheme.titleMedium,),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: const InputDecoration(
                                hintText: 'e.g. Ramu Kaka',
                                enabledBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle:  TextStyle(fontSize: 0)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => name = value!,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                         0xFF000811): Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age', style: Theme.of(context).textTheme.titleMedium,),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'e.g. 25',
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle: TextStyle(fontSize: 0)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => age = 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   height: 104,
                  //   width: DeviceUtils.getScreenSize(context).width,
                  //   padding: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //       color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                  //          0xFF000811): Colors.white,
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('Date Of Birth', style: Theme.of(context).textTheme.titleMedium,),
                  //       SizedBox(
                  //         height: 40,
                  //         child: TextFormField(
                  //           style: Theme.of(context).textTheme.bodySmall,
                  //           readOnly: true,
                  //           controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(dateOfBirth)),
                  //           decoration: InputDecoration(
                  //               suffixIcon: IconButton(
                  //                 icon: const Icon(Icons.calendar_today),
                  //                 onPressed: () async {
                  //                   final DateTime? picked = await showDatePicker(
                  //                     context: context,
                  //                     initialDate: dateOfBirth,
                  //                     firstDate: DateTime(1900),
                  //                     lastDate: DateTime(2100),
                  //                   );
                  //                   if (picked != null) {
                  //                     setState(() {
                  //                       dateOfBirth = picked;
                  //                     });
                  //                   }
                  //                 },
                  //               ),
                  //               enabledBorder:  const UnderlineInputBorder(borderSide: BorderSide.none),
                  //               focusedBorder:  const UnderlineInputBorder(borderSide: BorderSide.none),
                  //               errorBorder:  const UnderlineInputBorder(borderSide: BorderSide.none),
                  //               focusedErrorBorder:  const UnderlineInputBorder(borderSide: BorderSide.none),
                  //               errorStyle:  const TextStyle(fontSize: 0)
                  //           ),
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return '';
                  //             }
                  //             return null;
                  //           },
                  //           onSaved: (value) => {
                  //             setState(()=>dob = value!
                  //             )
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 3,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                         0xFF000811): Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gender', style: Theme.of(context).textTheme.titleMedium,),

                        SizedBox(
                          height: 40,
                          child: DropdownButtonFormField(
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: const InputDecoration(
                                enabledBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder:  UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle:  TextStyle(fontSize: 0)
                            ),

                            value: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value as String;
                              });
                            },
                            dropdownColor: Colors.black,
                            items: const [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'Transgender',
                                child: Text('Transgender'),
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => {
                              setState(()=>gender = value!
                              )
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                           0xFF000811): Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Profession', style: Theme.of(context).textTheme.titleMedium,),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'e.g. Teacher',
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle: TextStyle(fontSize: 0)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => profession = value!,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                         0xFF000811): Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email', style: Theme.of(context).textTheme.titleMedium,),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Enter your email (Username)',
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle: TextStyle(fontSize: 0)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => email = value!,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                         0xFF000811): Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mobile', style: Theme.of(context).textTheme.titleMedium,),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Enter your mobile number',
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle: TextStyle(fontSize: 0)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => mobile = value!,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3,),

                  Container(
                    height: 104,
                    width: DeviceUtils.getScreenSize(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                           0xFF000811): Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password', style: Theme.of(context).textTheme.titleMedium,),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                                hintText: 'Enter Password',
                                suffixIcon: IconButton(
                                  icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                ),
                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                errorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                                errorStyle: const TextStyle(fontSize: 0)
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) => password = value!,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: DeviceUtils.getScreenSize(context).width,
                    child: ElevatedButton(
                      onPressed: !isLoading? () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          registerUser();
                        }
                        else {
                          _formKey.currentState!.save();
                          HelperFunctions.showSnackBar('Enter Valid Details');
                        }
                      }: (){},
                      child: isLoading? const SizedBox(
                        height: 19,
                        width: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.white,
                        ),
                      ) : const Text('SIGN UP'),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: Theme.of(context).textTheme.bodySmall,),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text("Login")
                      )
                    ],
                  )

                ],
              ),
            ),
          )
      ),
    );
  }
}