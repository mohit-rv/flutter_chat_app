import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/homep.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class GroupI extends StatefulWidget {
  final String adminName;
  final String groupId;
  final String groupName;

  const GroupI({Key? key, required this.groupName,required this.adminName,required this.groupId}): super(key: key);


  @override
  State<GroupI> createState() => _GroupIState();
}

class _GroupIState extends State<GroupI> {

  Stream? members;

  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    super.initState();
  }


  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
       setState(() {
         members = val;
       });
    });
  }


  String getName(String r) {
    return r.substring(r.indexOf("_")+1);
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  AppBar(
      title: Text("Group Information"),
      centerTitle: true,
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(onPressed: (){
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text('EXIT'),
                  content: Text("Are you sure you want to Exit Group?"),
                  actions: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.cancel_presentation_outlined,color: Colors.red)),
                    IconButton(onPressed: () async{
                      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(
                          widget.groupName,
                          getName(widget.adminName),
                          widget.groupName).whenComplete(() {
                         nextScreen(context, HomeP());
                      });
                    }, icon: Icon(Icons.exit_to_app,color: Colors.green))
                  ],
                );
              });
        }, icon: Icon(Icons.exit_to_app_outlined))
      ],
    ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
        children: [
          Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor.withOpacity(0.3)
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 30,backgroundColor: Theme.of(context).primaryColor,
              child: Text(widget.groupName.substring(0,1).toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
            ),

            SizedBox(width: 20),

            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Group Name: ${widget.groupName}",style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 5),
                Text("Admin: ${getName(widget.adminName)}",),

              ],
            ),
          ],
        ),
      ),
           memberList(),
    ]
    )
    )
    );
  }


  memberList(){
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {

          if(snapshot.hasData){
            if(snapshot.data['members'] != null){
              if(snapshot.data['members'].length != 0){
                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,backgroundColor: Theme.of(context).primaryColor,
                          child: Text(getName(snapshot.data['members'][index])
                              .substring(0,1).toUpperCase(),
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        ),

                        title: Text(getName(snapshot.data['members'][index])),
                        subtitle: Text(getId(snapshot.data['members'][index])),

                      ),
                    );
                  }
                );
              }else{
                return Center(child: Text('NO MEMBERS'),);
              }
            }else{
              return Center(child: Text('NO MEMBERS'),);
            }
          }else{
            return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),);
          }

        });
  }


}