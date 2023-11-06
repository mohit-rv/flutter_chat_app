import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  //refrence for our collection                      creating collection in cloud firestore
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');


  //saving user data
  Future savingUserData(String fullname,String email,String password) async{
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "ProfilePic": "",
      "uid": uid,
    });
  }

  //getting userdata
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //for getting the user group
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }


  //Creating a group
  Future createGroup(String userName, String id,String groupName) async{
    DocumentReference groupdocumentReference = await groupCollection.add({
     "groupName": groupName,
     "groupIcon": "",
     "admin": "${id}_$userName",
     "members": [],
     "groupId": "",
     "recentMessage": "",
     "recentMessageSender": "",
     "recentMessageTime": ""
    });

    //Update the Member
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupdocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });

  }


  //getting the chats by time
  //getChats function is designed to fetch and return a stream of chat messages for a specific group, ordered by their "time" field, from a Firestore
  //database.You can use this stream in your Flutter application to listen for changes in the chatmessages and update the UI accordingly.
  getChats(String groupId) async{
    return groupCollection.doc(groupId).collection("messages")
        .orderBy("time").snapshots();
  }


  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }


  //get group members
  getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }

  //search
  searchByName(String groupName){
    return groupCollection.where("groupName",isEqualTo: groupName).get();    //for searching
  }


  //Joined button functionality
  Future<bool> isUserJoinedd(String groupName, String groupId, String userName) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")) {
      return true;
    }else{
      return false;
    }
  }


  //toggling the group join/exit
  Future toggleGroupJoin(String groupName, String groupId, String userName) async {
    //doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = userCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    //if user has our groups -> then removes then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await  groupDocumentReference.update({
          "members": FieldValue.arrayRemove(["${uid}_$userName"])
        });


    }else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await  groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }

  }



    //send message
    //'message' is subcollection of collection 'groups'
    sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),

    });
  }



  }