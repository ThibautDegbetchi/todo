
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todolist/screen/login_screen.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                      child: const Image(image: AssetImage('assets/images.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ) ,
                    const Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Text('Planify your time to have a better live ! ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,),
                    )
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
                   const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Do your best bro',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          color: Colors.white
                        ),
                      textAlign: TextAlign.center,),
                    )
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
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Let Start Now! ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          color: Colors.white
                        ),
                      textAlign: TextAlign.center,),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage?
          Padding(
            padding: const EdgeInsets.only(left: 18,right: 18,bottom: 10),
            child: TextButton(
                style:TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () async{
                  final pref = await SharedPreferences.getInstance();
                  pref.setBool('showHome', true);
                  // ignore: use_build_context_synchronously
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return const LoginScreen();
                  }));
            }, child: const Text('Start')),
          )
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
