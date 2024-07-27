import 'dart:convert';

import 'package:financeseekho/common/theme_model.dart';
import 'package:financeseekho/common/theme_provider.dart';
import 'package:financeseekho/features/Community/Screens/CommunityScreen.dart';
import 'package:financeseekho/features/FloatingButtonsController/FinBot_AI/FinBot.dart';
import 'package:financeseekho/features/FloatingButtonsController/Search/Search.dart';
import 'package:financeseekho/features/Learning/Screens/HomeScreen/HomeScreen.dart';
import 'package:financeseekho/features/Learning/Screens/LearningScreen/LearningScreen.dart';
import 'package:financeseekho/features/Services/Screens/ServicesScreen.dart';
import 'package:financeseekho/utils/device/device_utility.dart';
import 'package:financeseekho/utils/helper/helper_functions.dart';
import 'package:financeseekho/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BottomNavBarController extends StatefulWidget {
  const BottomNavBarController({super.key});

  @override
  State<BottomNavBarController> createState() => _BottomNavBarController();
}

class _BottomNavBarController extends State<BottomNavBarController> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool isChatBotOpen = false;
  var messages = [];
  bool isWriting = false;
  TextEditingController myMessage = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollToEnd);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(_animationController);
  }
  
  void getResponse()async {

    final data = {
        "query": myMessage.text
    };
    setState(() {
      isWriting = true;
      myMessage.clear();
    });
    try{
        const url = "https://cash-compass-ph0d.onrender.com/chat/";
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        int hour = DateTime.now().hour;
        int minute = DateTime.now().minute;

        if(response.statusCode == 200){
          setState(() {
            messages.add({"message": jsonDecode(response.body), "time": '$hour:$minute', "from": "ai"});
            _scrollToEnd();
            isWriting = false;
          });
        }
        else {
          setState(() {
            isWriting = false;
          });
          if(await DeviceUtils.isConnected()){
            setState(() {
              messages.add({"message": jsonDecode(response.body), "time": '$hour:$minute', "from": "ai"});
              _scrollToEnd();
            });
          } else {
            setState(() {
              messages.add({"message": "Please Connect to the Internet !\nYou are offline.", "time": '$hour:$minute', "from": "ai"});
              _scrollToEnd();
            });
          }
        }

    } catch(e){
      print(e);
      int hour = DateTime.now().hour;
      int minute = DateTime.now().minute;
      setState(() {
        isWriting = false;
        messages.add({"message": "Internal Server Error", "from": "ai", "time": '$hour:$minute'});
      });
    }

  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollToEnd);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //   }
    // });
  }

  static final List<Widget> screens =  [
    const HomeScreen(),
    const LearningScreen(),
    const ServicesScreen(),
    const CommunityScreen()
  ];

  final titles = [
    'Home',
    'Learning',
    'Services',
    'Profile'
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),

      body: Stack(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  isChatBotOpen = false;
                });
              },
                child: screens[_currentIndex]
            ),

            Positioned(
              right: isChatBotOpen ? 5 : 16,
              bottom: isChatBotOpen ? 575 : 16,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _offsetAnimation.value,
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      onPressed: () {
                        setState(() {
                          isChatBotOpen = !isChatBotOpen;
                        });
                        if (isChatBotOpen) {
                          _animationController.forward();
                        } else {
                          _animationController.reverse();
                        }
                      },
                      child: const Text('AI'),
                    ),
                  );
                },
              ),
            ),

            isChatBotOpen? Container(
              margin: const EdgeInsets.only(top: 70,left: 20,right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                    0xFF000811):
                Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 10),
                    width: DeviceUtils.getScreenSize(context).width,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.chat_bubble)),
                        const Padding(
                          padding: EdgeInsets.only(top: 8,bottom: 8),
                          child: Text('Finny', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18)),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 80),
                          child: TextButton(onPressed: (){
                            setState(() {
                              messages.clear();
                            });
                          }, child: const Text('Clear Chat', style: TextStyle(color: Colors.white),)),
                        )
                      ],
                    )
                  ),

                  (messages.isEmpty)?
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(20),
                        width: DeviceUtils.getScreenSize(context).width*0.65,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Provider.of<ThemeProvider>(context).isDark ? Colors.blueGrey: Colors.grey.shade100,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Text('Hi there!, I am Finny. What\'s on your mind today?\n\nYou can ask any financial questions to me.', style: Theme.of(context).textTheme.bodyMedium)
                    ),
                  )
                      :
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return  ListTile(
                          title: (isWriting && index==messages.length-1)? TypingIndicator() :Column(
                            crossAxisAlignment: (messages[index]['from']=="ai")? CrossAxisAlignment.start:CrossAxisAlignment.end,
                            children: [

                              Container(
                                width: DeviceUtils.getScreenSize(context).width*0.65,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Provider.of<ThemeProvider>(context).isDark ? (messages[index]['from']=="ai")? Colors.blueGrey: Colors.lightGreen.shade900: (messages[index]['from']=="ai")? Colors.grey.shade100: Colors.green.shade100,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text('${messages[index]['message']}', style: Theme.of(context).textTheme.bodyMedium, textAlign: (messages[index]['from']=="ai")?
                                TextAlign.left:  TextAlign.right),
                              ),

                              Text('${messages[index]['time']}',
                                  style: TextStyle(fontSize: 8,
                                      color: !Provider.of<ThemeProvider>(context).isDark ? const Color(
                                          0xFF000811):
                                      Colors.white,),
                                  textAlign: (messages[index]['from']=="ai")?
                                  TextAlign.left:  TextAlign.right
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                          0xFF000811):
                      Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: myMessage,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: !isWriting? const Icon(Icons.send): const Icon(Icons.stop),
                          onPressed: !isWriting? () {
                            if(myMessage.text==""){
                              return HelperFunctions.showSnackBar('Enter Valid Message');
                            }
                            int hour = DateTime.now().hour;
                            int minute = DateTime.now().minute;
                            setState(() {
                              messages.add({"message": myMessage.text, "time": '$hour:$minute', "from": "self"});
                              _scrollToEnd();
                            });
                            getResponse();

                          }: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ): Container(),

          ]
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Provider.of<ThemeProvider>(context).isDark ? const Color(0xFF000811):Colors.white,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: !Provider.of<ThemeProvider>(context).isDark ? const Color(0xFF000811):Colors.white,
        type: BottomNavigationBarType.fixed,

        onTap: (index){
          setState(() {
            _currentIndex = index;
            isChatBotOpen = false;
          });
        },

        items:const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_right_arrow_left),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group_solid),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 0.3, curve: Curves.easeOut),
      ),
    );
    _animation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );
    _animation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1, curve: Curves.easeOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _animation1,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 5),
        FadeTransition(
          opacity: _animation2,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 5),
        FadeTransition(
          opacity: _animation3,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}