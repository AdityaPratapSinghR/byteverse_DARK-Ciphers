import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedImage;
  bool imageSelected = false;

  List<String> images =[
    'assets/images/avatar1.jpg',
    'assets/images/avatar2.jpg',
    'assets/images/avatar3.jpg',
    'assets/images/avatar4.jpg',
    'assets/images/avatar5.jpg',
    'assets/images/avatar6.jpg',
  ];
  @override
  void initState(){
    super.initState();
    selectedImage='assets/images/blank.png';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF1E4),
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,0,20.0,0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  setState(() {
                    imageSelected=!imageSelected;
                  });
                },
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage(selectedImage!),
                ),
              ),
              if(imageSelected)
                Expanded(child: GridView.builder(
                  itemCount: images.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                    ),
                    itemBuilder: (context,index){
                     return GestureDetector(
                       onTap: (){
                         setState(() {
                           selectedImage=images[index];
                           imageSelected=false;
                         });
                       },
                       child: GridTile(
                         child: Image.asset(images[index]),
                       ),
                     );
                    },
                  ),
                ),
              Divider(
                thickness: 0.25,
                height: 50.0,
                color: Colors.grey[850],
              ),
              const SizedBox(height: 25,),
              const Row(
                children: [
                  SizedBox(width:20,),
                  Text('User-ID :', style: TextStyle(fontSize: 20,color: Color(0xff445d48)),),
                  SizedBox(width: 30,),
                  Text('User123',style: TextStyle(fontSize: 16 , color: Color(0xff898121)),),
                ],
              ),
              const SizedBox(height: 30,),
              const Row(
                children: [
                  SizedBox(width: 20.0,),
                  Text('Mail-ID :', style: TextStyle(color:Color(0xff445D48),fontSize: 20.0),),
                  SizedBox(width: 30.0,),
                  Text('test@gmail.com', style: TextStyle(color: Color(0xff898121),fontSize: 16.0),),
                ],
              ),
              const SizedBox(height: 30,),
              const Row(
                children: [
                  SizedBox(width:20,),
                  Text('Gender :', style: TextStyle(fontSize: 20,color: Color(0xff445d48)),),
                  SizedBox(width: 30,),
                  Text('Male',style: TextStyle(fontSize: 16 , color: Color(0xff898121)),),
                ],
              ),
              const SizedBox(height: 30,),
              const Row(
                children: [
                  SizedBox(width: 20.0,),
                  Text('Phone Number :', style: TextStyle(color:Color(0xff445D48),fontSize: 20.0),),
                  SizedBox(width: 30.0,),
                  Text('9871235467', style: TextStyle(color: Color(0xff898121),fontSize: 16.0),),
                ],
              ),
              const SizedBox(height: 30,),
              const Row(
                children: [
                  SizedBox(width: 20.0,),
                  Text('Instagram :', style: TextStyle(color:Color(0xff445D48),fontSize: 20.0),),
                  SizedBox(width: 30.0,),
                  Text('user._.123', style: TextStyle(color: Color(0xff898121),fontSize: 16.0),),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

