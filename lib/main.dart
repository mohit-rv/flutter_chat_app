import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/splash.dart';
import 'package:flutter_chat_app/shared/constaints.dart';            //shared preference

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

   if(kIsWeb) {
     await Firebase.initializeApp(
         options: FirebaseOptions(              //run the initialization for web
         apiKey: Constaints.apiKey,
             appId: Constaints.appId,
             messagingSenderId: Constaints.messagingSenderId,
             projectId: Constaints.projectId)
     );
   }else{
     //run the initialization for android
     await Firebase.initializeApp();
   }

   runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   getChatandAdmin();
  //   super.initState();
  //
  //   // 1. This method call when app in terminated state and you get a notification
  //   // when you click on notification app open from terminated state and you can get notification data in this method
  //   FirebaseMessaging.instance.getInitialMessage().then(
  //         (message) {
  //       print("FirebaseMessaging.instance.getInitialMessage");
  //       if (message != null) {
  //         print("New Notification");
  //         if (message.data['_id'] != null) {
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => Demo(
  //                 id: message.data['_id'],
  //               ),
  //             ),
  //           );
  //         }
  //       }
  //     },
  //   );
  //
  //   // 2. This method only call when App in forground it mean app must be opened
  //   FirebaseMessaging.onMessage.listen(
  //         (message) {
  //       print("FirebaseMessaging.onMessage.listen");
  //       if (message.notification != null) {
  //         sendMessage();
  //         LocalNotificationService.createanddisplaynotification(message);       //calling created channel in this
  //
  //       }
  //     },
  //   );
  //
  //   // 3. This method only call when App in background and not terminated(not closed)
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //         (message) {
  //       print("FirebaseMessaging.onMessageOpenedApp.listen");
  //       if (message.notification != null) {
  //         sendMessage();
  //         LocalNotificationService.createanddisplaynotification(message);       //calling created channel in this
  //
  //       }
  //     },
  //   );
  //
  //
  // }

  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInstatus().then((value) {
      if(value!=null){
        setState(() {
          _isSignedIn = value;
        });
      }
    } );
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter_chat_app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        primaryColor: Constaints().primaryColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
     initialRoute: 'splash',
     routes: {
        'splash': (context) => Splash()
     },
     //home:  _isSignedIn ? const HomeP() : const Login(),
    );
  }
}

