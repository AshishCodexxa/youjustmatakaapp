

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? prefs;


  static Future<String> getUserName() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("userName") ?? "";
  }


  static setUserName(String userName) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    print("userName    $userName");
    prefs.setString("userName", userName);
  }
}