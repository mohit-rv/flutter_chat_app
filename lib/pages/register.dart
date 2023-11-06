import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/homep.dart';
import 'package:flutter_chat_app/pages/login.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String fullname = "";
  String password = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //  ),
 body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),): SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('Groupie',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                  Text('Cretae your account to chat with your friends',style: TextStyle(fontSize: 10),),
                  Image.asset("assets/register1.avif",scale: 2),

                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person,color: Theme.of(context).primaryColor,),
                    ), //decoration
                    onChanged: (val){
                      setState(() {
                        fullname = val;
                        print(fullname);
                      });
                    },      //onchanged

                    validator: (val){
                      if(val!.isEmpty) {
                        return "This field is reqiured";
                      }else{
                        return null;
                      }
                    },
                  ),

                  SizedBox(height: 15),

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
                          register();
                        },
                        child: Text("Register",style: TextStyle(color: Colors.white,fontSize: 20),)),
                  ),

                  SizedBox(height: 10),

                  Text.rich(
                      TextSpan(text: "Allready have an account?",
                          children: <TextSpan>[
                            TextSpan(text: "Login now",
                                style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  nextScreen(context, Login());
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

  register()async{
    if(formkey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullname,email,password).then((value) async{
        if(value == true) {

          //saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullname);

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
