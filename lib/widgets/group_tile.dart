// import 'package:flutter/material.dart';
// import 'package:flutter_chat_app/pages/chatp.dart';
// import 'package:flutter_chat_app/widgets/widgets.dart';
//
// class GroupTile extends StatefulWidget {
//  // const GroupTile({super.key});
//   final String userName;
//   final String groupId;
//   final String groupName;
//
//   const GroupTile({Key? key, required this.groupName,required this.userName,required this.groupId}): super(key: key);
//
//
//   @override
//   State<GroupTile> createState() => _GroupTileState();
// }
//
// class _GroupTileState extends State<GroupTile> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: (){
//           nextScreen(context, ChatP(
//               groupId: widget.groupId,
//               groupName: widget.groupName,
//               userName: widget.userName));},
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
//         child: ListTile(
//           leading: CircleAvatar(
//             radius: 30,backgroundColor: Theme.of(context).primaryColor,
//             child: Text(widget.groupName.substring(0,1).toUpperCase(),
//               textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//           ),
//
//           title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
//           subtitle: Text("Join the conversation as ${widget.userName}",style: TextStyle(fontSize: 13),),
//
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/chatp.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
  // const GroupTile({super.key});
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({Key? key, required this.groupName,required this.userName,required this.groupId}): super(key: key);


  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatP(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName));},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          ),

          title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}",style: TextStyle(fontSize: 13),),

        ),
      ),
    );
  }
}
