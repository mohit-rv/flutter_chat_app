import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/homep.dart';
import 'package:flutter_chat_app/pages/login.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class ProfileP extends StatefulWidget {

  AuthService authService= AuthService();
  String userName = "";
  String email = "";
  ProfileP({Key?key, required this.email,required this.userName}) : super(key: key);

  @override
  State<ProfileP> createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {

  AuthService authService= AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         foregroundColor: Colors.white,
         title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold),),
         centerTitle: true,
         backgroundColor: Theme.of(context).primaryColor,
       ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,size: 150,color: Colors.grey[700]),
            SizedBox(height: 15),
            Text(widget.userName,textAlign: TextAlign.center,style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,color: Colors.black),),
            SizedBox(height: 30),
            Divider(height: 2),
            ListTile(
              onTap: (){  nextScreen(context, HomeP());  },
              // selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.group),
              title: Text("Groups",style: TextStyle(color: Colors.black)),
            ),

            ListTile(
              onTap: (){

              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.portrait_rounded),
              title: Text("Profile",style: TextStyle(color: Colors.black)),
            ),

            ListTile(
              onTap: (){
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context){
                      return AlertDialog(content: Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.cancel_presentation_outlined,color: Colors.red)),
                          IconButton(onPressed: () async{
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),(route) => false);
                          }, icon: Icon(Icons.exit_to_app,color: Colors.green))
                        ],
                      );
                    });
                // authService.signOut().whenComplete(() {
                //   nextScreenReplace(context, Login());
                // });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.logout),
              title: Text("Logout",style: TextStyle(color: Colors.black)),
            ),

          ],
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          children: [
            Icon(Icons.account_circle,size: 200,color: Colors.grey[700]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Name: ",style: TextStyle(fontSize: 20),),
                Text(widget.userName,style: TextStyle(fontSize: 20),),
              ],
            ),

            Divider(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Email: ",style: TextStyle(fontSize: 20),),
                Text(widget.email,style: TextStyle(fontSize: 20),),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
