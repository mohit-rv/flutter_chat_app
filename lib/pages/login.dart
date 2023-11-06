import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/homep.dart';
import 'package:flutter_chat_app/pages/register.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  AuthService authService = AuthService();
  final formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     //  appBar: AppBar(
     //   backgroundColor: Theme.of(context).primaryColor,
     //  ),
 body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),)
     :SingleChildScrollView(
       child: SafeArea(
         child: Padding(
           padding: EdgeInsets.all(20),
           child: Form(
             key: formkey,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 
                 Text('Groupie',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                 Text('Login to chat with your friends',style: TextStyle(fontSize: 10),),
                 Image.asset("assets/groupP.avif",scale: 2),
                 TextFormField(
                   decoration: textInputDecoration.copyWith(
                     labelText: "Email",
                     prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,),
                   ), //decoration
                   onChanged: (val){
                     setState(() {
                       email = val;
                       print(email);
                     });
                   },      //onchanged

                   validator: (val){
                     if (RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val!)) {
                       return null;
                     } else {
                       return "Please Enter valid email id";
                     }
                   },
                 ),
                 
                 SizedBox(height: 15),
                 
                 TextFormField(
                   obscureText: true,
                   decoration: textInputDecoration.copyWith(
                       labelText: "Password",
                       prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,)
                   ),
                   onChanged: (val){
                     setState(() {
                       password = val;
                     });
                   },

                   validator: (val){
                     if(val!.length < 6) {
                       return "Password must content 6 letters";
                     }else{
                       return null;
                     }
                   },
                 ),

                 SizedBox(height: 20),

                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       primary: Theme.of(context).primaryColor,
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20)
                       )
                     ),
                       onPressed: (){
                       login();
                       },
                       child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 20),)),
                 ),

                 SizedBox(height: 15),

                 Text.rich(
                     TextSpan(text: "Don't have an account?",
                     children: <TextSpan>[
                       TextSpan(text: "Register here",
                       style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                       recognizer: TapGestureRecognizer()..onTap = () {
                         nextScreen(context, Register());
                       } )
                     ],
                       style: TextStyle(color: Colors.black,fontSize: 14)
                     ))

               ],
             ),
           ),
         ),
       ),
     ),
    );
  }

  login() async {

    if(formkey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });
      await authService.loginWithEmailandPassword(email,password).then((value) async{
        if(value == true) {
      //it will search the user login details in firestore
     QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
     await HelperFunctions.saveUserLoggedInStatus(true);
     await HelperFunctions.saveUserEmailSF(email);
     await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          nextScreenReplace(context, const HomeP());    //navigation
        }else{
          showSnackBar(context,Colors.red,value);
          setState(() {
            _isLoading = false;
          });
        }
      });      //then
    }

  }

}
