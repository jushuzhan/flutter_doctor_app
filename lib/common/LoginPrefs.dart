import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPrefs{
  static const String USER_NAME="USER_NAME";//用户名
  static const String TOKEN="TOKEN";//token
  static  late SharedPreferences _prefs;//延迟初始化
  static Future<String> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    return 'ok';
  }
  static void saveUserName(String userName) {
    _prefs.setString(USER_NAME, userName);
  }
  static String? getUserName() {
    return _prefs.getString(USER_NAME);
  }
  static void saveToken(String token){
    _prefs.setString(TOKEN, token);
  }
  static String? getToken() {
    return _prefs.getString(TOKEN);
  }
  static void removeUserName() {
    _prefs.remove(USER_NAME);
  }
  static void removeToken() {
    _prefs.remove(TOKEN);
  }
  static Future<void>clearLogin() async{
    _prefs.clear();
  }
}