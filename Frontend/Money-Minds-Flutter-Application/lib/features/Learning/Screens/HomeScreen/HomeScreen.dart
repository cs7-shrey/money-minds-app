import 'package:financeseekho/common/theme_model.dart';
import 'package:financeseekho/common/theme_provider.dart';
import 'package:financeseekho/features/Learning/Screens/SubCategoryScreen/SubCategoryScreen.dart';
import 'package:financeseekho/utils/constants/image_strings.dart';
import 'package:financeseekho/utils/device/device_utility.dart';
import 'package:financeseekho/utils/helper/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController queryController = TextEditingController();

  final todoList = [
    'assets/images/h1.png',
    'assets/images/mf.png',
    'assets/images/bonds.png'
  ];
  final todoListext = [
    'Insurance',
    'Mutual Funds',
    'Commodity'
  ];
  final wishes = [
    "Good Morning",
    "Good Afternoon",
    "Good Evening",
    "Good Night",
  ];

  String getWish(){
    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    if(hour<12 && hour>=5) {
      return wishes[0];
    }
    if(hour<17 && hour>=12) {
      return wishes[1];
    }
    if(hour<19 && hour>=17) {
      return wishes[2];
    }
    else {
      return wishes[3];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            GestureDetector(
                onTap: (){
                  setState(() {
                    Provider.of<ThemeModel>(context, listen: false).toggleTheme();
                  });
                },
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Provider.of<ThemeProvider>(context).isDark ? const Icon( Icons.light_mode_outlined, color: Colors.white,): const Icon(Icons.dark_mode_outlined)
                    ),
                    Text(Provider.of<ThemeProvider>(context).isDark ?'Light Mode':'Dark Mode', style: !Provider.of<ThemeProvider>(context).isDark ?const TextStyle(color: Color(
                        0xFF18215B)): const TextStyle(color: Colors.white))
                  ],
                )
            ),
            const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getWish(), style: TextStyle(fontSize: 24,
                          color: !Provider.of<ThemeProvider>(context).isDark ?const Color(
                              0xFF18215B):
                          const Color(0xFFFFFFFF))),
                      Text('Name Here', style: Theme.of(context).textTheme.bodyMedium,)
                    ],
                  ),

                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(FImages.profileImage),
                        fit: BoxFit.contain
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                          0xFF000434):Colors.white, width: 4)
                    ),
                  )
                ],
              ),

            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: DeviceUtils.getScreenSize(context).width*0.8,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                          0xFF000811):
                      Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                        hintText: 'Search anything',
                        suffixIcon: IconButton(
                          icon: const Icon(CupertinoIcons.search),
                          onPressed: () {},
                        ),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        errorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        errorStyle: const TextStyle(fontSize: 0)
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30,),

            Text('To Do Tasks', style: Theme.of(context).textTheme.headlineSmall,),

            const SizedBox(height: 30,),

            SizedBox(
              height: 155,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8),
                    width: 115,
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                          0xFF000811):
                      Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                            child: Image.asset(todoList[index])
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(todoListext[index], style: Theme.of(context).textTheme.bodySmall,),
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: ElevatedButton(
                              onPressed: (){
                                HelperFunctions.navigateToScreen(context, SubCategoryScreen(category: todoListext[index], moduleNo: index+1));
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0, // no elevation
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Start', style: TextStyle(fontSize: 12),),
                                  Icon(Icons.fast_forward_rounded)
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30,),

            Text('Popular Topics', style: Theme.of(context).textTheme.headlineSmall,),

            const SizedBox(height: 30,),

            SizedBox(
              height: 108*(todoListext.length).toDouble(),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: todoList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 13),
                    padding: const EdgeInsets.all(12),
                    width: 115,
                    decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                            0xFF000811):
                        Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 70,
                            child: Image.asset(todoList[index])
                        ),

                        const SizedBox(width: 50,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(todoListext[index], style: Theme.of(context).textTheme.bodyMedium,),

                              const SizedBox(height: 20,),

                            SizedBox(
                              height: 30,
                              width: 80,
                              child: ElevatedButton(
                                onPressed: (){
                                  HelperFunctions.navigateToScreen(context, SubCategoryScreen(category: todoListext[index], moduleNo: index+1));
                                },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0, // no elevation
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: const Text('Learn', style: TextStyle(fontSize: 14),),
                              ),
                            )

                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
