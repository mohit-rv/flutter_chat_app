




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/group_i.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/widgets/message_tile.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';
import 'package:intl/intl.dart';


class ChatP extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatP({Key? key,required this.groupId,required this.groupName,required this.userName}): super(key: key);

  @override
  State<ChatP> createState() => _ChatPState();
}

class _ChatPState extends State<ChatP> {

  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messageController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();



  }


  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.groupName),
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, GroupI(
                groupName: widget.groupName,
                adminName: admin,
                groupId: widget.groupId));
          }, icon: Icon(Icons.info)
          )
        ],
      ),

      body: Stack(
        children: [
          chatMessage(),
        Container(
        alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            color: Colors.grey[700],
            child: Row(
              children: [
                Expanded(child: TextFormField(
                  controller: messageController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Send a message",
                    hintStyle: TextStyle(color:Colors.white,fontSize: 16 ),
                    border: InputBorder.none
                  ),
                )),
                SizedBox(width: 12),
                GestureDetector(    //sending message to reciever
                  onTap: (){
                    sendMessage();
                  },
                  child: Container(
                    height: 50,width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Icon(Icons.send,color: Colors.white,),),
                  ),
                )
              ],
            ),
          ),
    )
        ],
      ),
    );
  }

  //fetching chat messages
  chatMessage() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  reverse: false,
            itemBuilder: (context, index){
              //time = DateTime.now();
             //        print('${DateFormat('Hms').format(time)}');
                    return MessageTile(
                          message: snapshot.data.docs[index]['message'],
                          sender: snapshot.data.docs[index]['sender'],
                          sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                         // image: '',
                         // time: snapshot.data.docs[index]['recentMessageTime']
                         // time: snapshot.data.docs[index]['${DateFormat('Hms').format(time)}']

                    );
            },
          )
              : Container();
        });
  }

  sendMessage() {
    if(messageController.text.isNotEmpty){
      Map<String , dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now()
      };
      DatabaseService().sendMessage(widget.groupId,chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }

  }

}
