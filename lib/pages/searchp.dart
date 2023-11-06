import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/chatp.dart';
//import 'package:flutter_chat_app/pages/group_i.dart';
import 'package:flutter_chat_app/pages/homep.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class SearchP extends StatefulWidget {
  const SearchP({super.key});

  @override
  State<SearchP> createState() => _SearchPState();
}

class _SearchPState extends State<SearchP> {

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async{
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
       userName = value!;
      });
      user = FirebaseAuth.instance.currentUser;
    });
  }

  //string manipulation
  String getName(String r) {
    return r.substring(r.indexOf("_")+1);
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("search",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,color: Colors.white),),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
                nextScreenReplace(context, HomeP());
          },
        ),
      ),

      body: Column(
        children: [
          Container(color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    color: Colors.white,),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search group....",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 16))
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    initiateSearchMethode();
                  },
                  child: Container(width: 40,height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: Icon(Icons.search,color: Colors.white,),
                  ),
                )

              ],
            ),
          ),
          isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) : groupList(),
        ],
      ),

    );
  }

  initiateSearchMethode() async{
    if(searchController.text.isNotEmpty){
    setState(() {
      isLoading = true;
    });
    await DatabaseService().searchByName(searchController.text).then((snapshot) {
      setState(() {
        searchSnapshot = snapshot;
        isLoading = false;
        hasUserSearched = true;
      });
    });
    }

  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index){
          return groupTile(
            userName,
            searchSnapshot!.docs[index]['groupId'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],
          );
        },
    )
        : Container();
  }


  joinedOrNot(String userName, String groupId, String groupName, String admin )async{
    await DatabaseService(uid: user!.uid).isUserJoinedd(groupName, groupId, userName).then((value) {
      setState(() {
       isJoined = value;
      });
    });
  }

  //it will show result for searching group
  //it is taking gid ,gname , gadmin fom groupList
  Widget groupTile(String userName, String groupId, String groupName, String admin){

    //function to check whether user already exist in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(groupName.substring(0,1).toUpperCase(),
        style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupName,style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(       //joined button
        onTap: () async{

          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupName, groupId, userName);
          if(isJoined){
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.green,"Successfully joined Group");
            Future.delayed(Duration(seconds: 2), (){      //exit button
              nextScreen(context, ChatP(
                  groupId: groupId,
                  groupName: groupName,
                  userName: userName
              ));
            });
          }else{
            setState(() {
              isJoined= !isJoined;
              showSnackBar(context, Colors.red, "Left the group $groupName");
            });
          }
        },
        child: isJoined ? Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              border: Border.all(color: Colors.white,width: 1)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text('Joined',style: TextStyle(color: Colors.white),),
        ) : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text('Join Now',style: TextStyle(color: Colors.white),),

        ),
      ),
    );
  }
}
