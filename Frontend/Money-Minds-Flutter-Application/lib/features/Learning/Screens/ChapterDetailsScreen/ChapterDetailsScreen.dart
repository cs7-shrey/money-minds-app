import 'dart:convert';

import 'package:financeseekho/common/theme_provider.dart';
import 'package:financeseekho/utils/device/device_utility.dart';
import 'package:financeseekho/utils/helper/helper_functions.dart';
import 'package:financeseekho/utils/http/http_client.dart';
import 'package:financeseekho/utils/http/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterDetailsScreen extends StatefulWidget {
  const ChapterDetailsScreen({super.key, required this.category, required this.moduleNo, required this.subCategory});
  final category;
  final moduleNo;
  final subCategory;

  @override
  State<ChapterDetailsScreen> createState() => _ChapterDetailsScreenState();
}

class _ChapterDetailsScreenState extends State<ChapterDetailsScreen> {
  bool isLoading = true;
  var chapters = [];
  var chapterData = [];

  @override
  void initState() {
    getChapters();
    super.initState();
  }

  void getChapters() async {
    setState(() {
      isLoading = true;
    });

    try{
      final responses = await FHttpHelper.get('${learnUrl+widget.category}/${widget.subCategory}/cards');

      if(responses['jsonResponse'].statusCode == 200){
        setState(() {
          chapters = jsonDecode(responses['responseBody']);
        });
        await getChapterData();
        setState(() {
          isLoading = false;
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
        if(await DeviceUtils.isConnected()){
          HelperFunctions.showAlert("Learning", "An error occurred!\nPlease Retry Again.");
        } else {
          HelperFunctions.showAlert("Learning", "Please Connect to the Internet !\nYou are offline.");
        }
      }
    } catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });
      HelperFunctions.showAlert("Chapter", "Error in fetching Chapters");
    }
  }

  getChapterData() async{

    for (int i=0;i<chapters.length;i++){
      try{
        final url = 'content/learn/${widget.category}/${widget.subCategory}/${chapters[i]['title']}';
        final responses = await FHttpHelper.get(url);
        final response = jsonDecode(responses['responseBody']);
        if(responses['jsonResponse'].statusCode==200){
          chapterData.add({"title": chapters[i]['title'], "content": response['content']});
        }
        else {
          chapterData.add({"title": chapters[i]['title'], "content": "Coming Soon"});
        }
      } catch(e){
        setState(() {
          isLoading = false;
        });
        HelperFunctions.showAlert('Content', 'Unable to fetch Content for title ${chapters[i]['title']}');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 105,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: ()=> Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_left_sharp,
                  size: 28,
                  color: !Provider.of<ThemeProvider>(context).isDark ? const Color(
                      0xFF000811):
                  Colors.white,
                )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30,bottom: 3),
              child: Row(
                children: [
                  Text( 'Module: ', style: Theme.of(context).textTheme.bodyMedium,),
                  Text((widget.moduleNo<10)? '0${widget.moduleNo}': '${widget.moduleNo}', style: const TextStyle(fontSize: 24,color: Colors.green, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30,bottom: 7),
                  child: Text(widget.category, style: Theme.of(context).textTheme.bodySmall,),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30,bottom: 7),
              child: Text('${widget.subCategory}', style: Theme.of(context).textTheme.bodySmall,),
            ),
            Container(
              height: 1,
              width: DeviceUtils.getScreenSize(context).width,
              color: Colors.green,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              isLoading? const LinearProgressIndicator() : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: DeviceUtils.isLandscapeOrientation(context)? 2:1,
                  childAspectRatio: 0.35,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      // HelperFunctions.navigateToScreen(context, ChapterDetailsScreen(category: learningCategories[index]['name']));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: DeviceUtils.getScreenSize(context).width*0.9,
                      decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).isDark ? const Color(
                            0xFF000811):
                        Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                SizedBox(
                                    width: DeviceUtils.getScreenSize(context).width*0.9,
                                    height: 200,
                                    child: Image.asset('assets/images/f${index+1}.png')
                                ),

                                Text('Chapter', style: Theme.of(context).textTheme.bodySmall,),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Text((index<9)? '0${(index+1)}':'${(index+1)}',style: Theme.of(context).textTheme.bodyLarge ),
                                    const SizedBox(width: 10,),
                                    Container(height: 20,color: Colors.green,width: 2,),
                                    const SizedBox(width: 10,),
                                    Expanded(child: Text(chapters[index]['title']?? "", style: Theme.of(context).textTheme.bodyMedium,))
                                  ],
                                ),
                                const SizedBox(height: 8,),

                                Text(HelperFunctions.truncateText(chapterData[index]['content'],900)
                                  , style: Theme.of(context).textTheme.bodyMedium,),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 5, left: 20,right: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 12,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Anything Wrong?', style: Theme.of(context).textTheme.bodySmall,),
                                    Text('Read time', style: Theme.of(context).textTheme.bodySmall,)
                                  ],
                                ),

                                const SizedBox(height: 3,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){},
                                      child: Text('Report', style: Theme.of(context).textTheme.bodyLarge,),
                                    ),
                                    Text('11 mins', style: Theme.of(context).textTheme.bodyLarge,)
                                  ],
                                )
                              ],
                            ),
                          )




                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
