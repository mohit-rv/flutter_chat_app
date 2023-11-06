import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/login.dart';
import 'package:flutter_chat_app/pages/profile.dart';
import 'package:flutter_chat_app/pages/searchp.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/widgets/group_tile.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class HomeP extends StatefulWidget {
  const HomeP({super.key});

  @override
  State<HomeP> createState() => _HomePState();
}

class _HomePState extends State<HomeP> {

  AuthService authService = AuthService();
  Stream? groups;
  String userName = "";
  String email = "";
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }



  //String manipultion
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }


  gettingUserData() async{
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value){
      setState(() {
        userName = value!;
      });
    });

    //getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            nextScreenReplace(context, SearchP());
          }, icon: Icon(Icons.search))
        ],
        elevation: 0,
        title: Text('Groups',style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),

   drawer: Drawer(
     child: ListView(
       padding: EdgeInsets.symmetric(vertical: 50),
       children: [
         Icon(Icons.account_circle,size: 150,color: Colors.grey[700]),
         SizedBox(height: 15),
         Text(userName,textAlign: TextAlign.center,style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,color: Colors.black),),
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
             nextScreenReplace(context, ProfileP(email: email, userName: userName));
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

     body: groupList(),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         popUpDialog(context);
       },
       elevation: 0,
       backgroundColor: Theme.of(context).primaryColor,
       child: Icon(Icons.add,color: Colors.white,size: 30),
     ),


      );
  }

  popUpDialog(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Create a Group", textAlign: TextAlign.left,),
          content: Column(mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ? Center(
                  child: CircularProgressIndicator(color: Theme
                      .of(context)
                      .primaryColor),) //Center
                    : TextField(

                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                  style: TextStyle(color: Colors.black),

                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Theme
                            .of(context)
                            .primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ]
          ),

          actions: [
            ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("CANCEL"),
              style: ElevatedButton.styleFrom(primary: Theme
                  .of(context)
                  .primaryColor),),

            ElevatedButton(onPressed: () async {
              if (groupName != "") {
                setState(() {
                  _isLoading = true;
                });
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .createGroup(
                    userName, FirebaseAuth.instance.currentUser!.uid, groupName)
                    .whenComplete(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
                showSnackBar(
                    context, Colors.greenAccent, "Group Created Succesfully");
              }
            }, child: Text("CREATE"),
              style: ElevatedButton.styleFrom(primary: Theme
                  .of(context)
                  .primaryColor),),
          ],

        );
      }
      );
    });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot)
    {
      //make some checks
       if(snapshot.hasData){

      if (snapshot.data['groups']!= null) {
        if (snapshot.data['groups'].length != 0) {
          
          return ListView.builder(
              itemCount: snapshot.data["groups"].length,
              itemBuilder: (context,index){

            int reverseIndex = snapshot.data['groups'].length - index - 1;  //to display group sequence vise which created first

                return GroupTile(
              groupName: getName(snapshot.data['groups'][reverseIndex]),
              groupId: getId(snapshot.data['groups'][reverseIndex]),
               userName: snapshot.data['fullName'],
                );
    },);

        } else {
          return noGroupWidget();
        }
      } else {
        return noGroupWidget();
      }

       } else{
         return Center (child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),);
       }
        });
  }


  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
           child: Icon(Icons.add_circle,color: Colors.grey[700],size: 75)),

          SizedBox(height: 30),
          Text('You have not joined any group till now tap on the add icon to create a group or also search from top search button.',
          textAlign: TextAlign.center,),

        ],
      ),
    );
  }

}
