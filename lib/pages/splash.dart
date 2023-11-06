//import 'package:firebase_crud/ui/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/services.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Services Splash = Services();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Splash.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children: [
              Image.asset('assets/chat.gif'),
              //NetworkImage('https://i.gifer.com/ZAbi.gif'),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('C',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue)),
                  Text('H',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.red)),
                  Text('A',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.green)),
                  Text('T',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.black)),
                ],
              ),

              SizedBox(height: 10),

              Row(  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('o',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('p',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('e',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('r',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('t',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('i',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('o',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('n',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                  Text('s',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blueGrey)),
                ],
              )
            ],
          ),
        ),


      ),
    );
  }
}
