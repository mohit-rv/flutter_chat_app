
import 'package:shared_preferences/shared_preferences.dart';
//FOR REACHING USER TO HOME SCREEN IF HE LOGGEDIN OTHERWISE REACHING TO LOGIN SCREEN
class HelperFunctions {


  //keys
  static String userLoggedInkey = "LOGGEDINKEY";
  static String userNamekey = "USERNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";

  //saving the data to Shared Preference
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInkey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNamekey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailkey, userEmail);
  }


  //getting the data from Shared Preference
   static Future<bool?> getUserLoggedInstatus() async{
     SharedPreferences sf = await SharedPreferences.getInstance();
     return sf.getBool(userLoggedInkey);
   }

  static Future<String?> getUserEmailFromSF() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailkey);
  }

  static Future<String?> getUserNameFromSF() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNamekey);
  }
}
