import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctios {
//keys
  static String userLoggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';

//saving the data to sharedpreferences

//getting the data from sharedpreferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
