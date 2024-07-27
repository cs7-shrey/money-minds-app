import 'dart:convert';
import 'package:financeseekho/common/theme_model.dart';
import 'package:financeseekho/common/theme_provider.dart';
import 'package:financeseekho/features/Authentication/Screens/SignupScreen/SignupScreen.dart';
import 'package:financeseekho/features/NavigationBottomController/NavigationBottomController.dart';
import 'package:financeseekho/utils/constants/image_strings.dart';
import 'package:financeseekho/utils/device/device_utility.dart';
import 'package:financeseekho/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool hidePassword = true;
  bool isLoading = false;

  void loginUser() async {
    if (password.isNotEmpty && email.isNotEmpty){
      setState(() {
        isLoading = true;
      });

      var reqBody = {
        "username": email,
        "password": password
      };

      try{
          var jsonResponse = await http.post(
              Uri.parse('https://1713-2401-4900-40fd-664e-d0c4-5d78-b38-3229.ngrok-free.app/login'),
              headers: {"content-Type": "application/x-www-form-urlencoded"},
              body: reqBody
          );

          var response = jsonDecode(jsonResponse.body);

          if (jsonResponse.statusCode == 200) {

            var myToken = response['access_token'];
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('token', myToken);
            prefs.setBool('isLoggedIn', true);

            setState(() {
              isLoading = false;
            });
            HelperFunctions.shiftToScreen(context, const BottomNavBarController());
            HelperFunctions.showAlert('Login', 'User Login Successful with $email');

          } else {
              HelperFunctions.showAlert('Login', 'User Login Failed !\nError: ${jsonResponse.statusCode} - Invalid Credentials. Please Enter Valid Credentials');
              setState(() {
                isLoading = false;
              });
          }
      } catch (e){
        print(e);
        setState(() {
          isLoading = false;
        });
        bool isConnected = await DeviceUtils.isConnected();
        if(!isConnected) {
          HelperFunctions.showAlert('Login', 'Please Connect to Internet Connection');
        }
        else {
          HelperFunctions.showAlert('Login', 'An error occurred while login ! Please retry again.');
        }
      }
    } else {
      HelperFunctions.showAlert('Login', 'Enter Valid Details');
    }
  }


  @override
  Widget build(BuildContext context) {
    BuildContext myContext = context;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            Provider.of<ThemeModel>(context, listen: false).toggleTheme();
                          });
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Provider.of<ThemeProvider>(context).isDark ? Icons.light_mode_outlined: Icons.dark_mode_outlined)
                        )
                    ),

                    GestureDetector(
                        onTap: (){
                          HelperFunctions.shiftToScreen(context, const BottomNavBarController());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Text('Skip', style: Theme.of(context).textTheme.bodyMedium,),
                        )
                    ),

                  ],
                ),


                Image.asset(FImages.loginImage,width: DeviceUtils.getScreenSize(context).width*0.85),

                Text('Login', style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: 5,),
                Text('Enter your login details to access our financial services.', style: Theme.of(context).textTheme.bodyMedium,),

                const SizedBox(height: 20,),

                Container(
                  height: 104,
                  width: DeviceUtils.getScreenSize(context).width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                        0xFF000811)
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email', style: Theme.of(context).textTheme.titleMedium,),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: const InputDecoration(
                            hintText: 'Enter Registered email',
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
                          0xFF000811):
                      Colors.white,
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

                const SizedBox(height: 5,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){},
                        child: const Text('Forgot Password?')
                    )
                  ],
                ),

                const SizedBox(height: 5,),

                SizedBox(
                  width: DeviceUtils.getScreenSize(context).width,
                  child: ElevatedButton(
                    onPressed: !isLoading? () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        loginUser();
                      }
                      else {
                        _formKey.currentState!.save();
                        if(email=='' && password==''){
                          HelperFunctions.showSnackBar('Enter Valid Email ID and Password');
                        }
                        else {
                          if(email==''){
                            HelperFunctions.showSnackBar('Enter Valid Email ID');
                          }
                          else {
                            HelperFunctions.showSnackBar('Enter Valid Password');
                          }
                        }
                      }
                    }: (){},
                    child: isLoading? const SizedBox(
                      height: 19,
                      width: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.white,
                      ),
                    ) : const Text('LOGIN'),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: Theme.of(context).textTheme.bodySmall,),
                    TextButton(
                        onPressed: (){
                          HelperFunctions.navigateToScreen(context, const SignupScreen());
                        },
                        child: const Text("Sign Up")
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