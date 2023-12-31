
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../screen/home.dart';

class OnbordingPageState extends StatefulWidget {
  const OnbordingPageState({super.key});

  @override
  State<OnbordingPageState> createState() => _OnbordingPageStateState();
}

class _OnbordingPageStateState extends State<OnbordingPageState> {
  final control =PageController();
  bool isLastPage=false;

  void controller(){
    control.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: control,
          onPageChanged: (index){
            setState(()=> isLastPage = index ==2);
          },
          children: [
            Container(
              color: Colors.blue,
              child:  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                      child: const Image(image: AssetImage('assets/images.jpeg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ) ,
                    const Text('Planify your time to have a better live ! ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),)
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              child:  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                      child: const Image(image: AssetImage('assets/logo1.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ) ,
                    const Text('Do your best bro',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),)
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              child:  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                      child: const Image(image: AssetImage('assets/imagetodolist.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ) ,
                    const Text('Let Start Now! ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage?
          TextButton(
              style:TextButton.styleFrom(
                foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async{
                final pref = await SharedPreferences.getInstance();
                pref.setBool('showHome', true);
                // ignore: use_build_context_synchronously
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const HomePage();
                }));
          }, child: const Text('Start'))
          : Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
             height: 80,
             child:
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 TextButton(onPressed: (){
                   control.jumpToPage(2);
                  },
                  child:const Text('SKIP')),
              Center(
              child: SmoothPageIndicator(controller: control,
                count: 3,
                effect: const WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.purple,
                ),
                onDotClicked: (index){
                 control.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInSine);
                },
              ) ,
            ),
              TextButton(onPressed: (){
              control.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
                child: const Text('NEXT')),

          ],
        ),
      ),
    );
  }
}
