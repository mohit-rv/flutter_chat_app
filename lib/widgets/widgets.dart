import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),       //text color
  focusedBorder: OutlineInputBorder(                //when we touch on box
    borderSide: BorderSide(color: Colors.redAccent,width: 2)
  ),

  enabledBorder: OutlineInputBorder(                 //no operation on box
      borderSide: BorderSide(color: Colors.black38,width: 2)
  ),

  errorBorder: OutlineInputBorder(                   //when error occour in textffield box
      borderSide: BorderSide(color: Colors.red,width: 2)
  ),

);



void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context,color,message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(fontSize: 14),),
        backgroundColor: color,
        duration: Duration(seconds: 3),
        action: SnackBarAction(label: "Ok",onPressed: (){},textColor: Colors.white),
      ));
}
