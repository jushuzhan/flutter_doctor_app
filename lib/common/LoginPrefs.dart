import 'App.dart';
class LoginPrefs{
  static const String USER_NAME="USER_NAME";//用户名
  static const String TOKEN="TOKEN";//token

  static void saveUserName(String userName) {
    App.prefs.setString(USER_NAME, userName);
  }
  static String? getUserName() {
    return App.prefs.getString(USER_NAME);
  }
  static void saveToken(String token){
    App.prefs.setString(TOKEN, token);
  }
  static String? getToken() {
    return App.prefs.getString(TOKEN);
  }
  static void removeUserName() {
    App.prefs.remove(USER_NAME);
  }
  static void removeToken() {
    App.prefs.remove(TOKEN);
  }
  static Future<void>clearLogin() async{
    App.prefs.clear();
  }
}