import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:app/Util/routes.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color backgroundColor = Colors.red.shade50;
  bool showMoreInfo = false;
  bool contactUs = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
        backgroundColor: Colors.red.shade100,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,

                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(

                          child: const Text('Change Theme',style: TextStyle(color: Colors.black,fontSize: 16),),
                          onPressed: () {
                            // Change background color when button is pressed
                            setState(() {
                              backgroundColor = Color(0xff1F2544); // Change to desired color
                            });
                          },
                        ),
                        SizedBox(),
                        const Icon(Icons.dark_mode),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25,),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, MyRoutes.mainPage);
                      },
                      child:const Text('Your Playlists',style: TextStyle(color: Colors.black,fontSize: 16)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25,),
              Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showMoreInfo=!showMoreInfo;
                        });
                      },
                      child:const Text('About the App',style: TextStyle(
                          color: Colors.black,fontSize: 16
                      ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Image.asset('assets/images/happy.png'),

              if (showMoreInfo)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Us:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'StudyTube focuses on enhancing learning experiences through  curated educational '
                            'content and features to improve study habits and academic performance.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height:10),
                      Text('User Guide:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      SizedBox(height:10),
                      Text('Enter the URL of the YouTube playlist you want to'
                          'watch. App will retrieve the video details from the YouTube API and'
                          'play the selected video within the app interface.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text('Whats New:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      SizedBox(height: 10),
                      Text('a) Note-taking features\n'
                          'b) Integrate with online resources\n'
                          'c) Track progress, including video watch\n     history, and time spent\n'
                          'd) Customize notification preference\n     based on study schedule.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

            ],
          ),
        ),

      ),
    );

  }
}