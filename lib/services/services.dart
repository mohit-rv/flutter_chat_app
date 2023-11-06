import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_crud/list.dart';
//import 'package:firebase_crud/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/homep.dart';
import 'package:flutter_chat_app/pages/login.dart';

//import '../post.dart';

class Services{


  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(Duration(seconds: 5),
              () => {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeP()))
          });
    }else{
      Timer(Duration(seconds: 5),
              () => {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()))
          });
    }
  }



}