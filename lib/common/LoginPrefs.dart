import 'App.dart';
class LoginPrefs{
  static const String USER_ID="USER_ID";//用户ID
  static const String TOKEN="TOKEN";//token
  static const String EXPIRESIN="EXPIRESIN";//EXPIRESIN
  static const String LAST_GET_TOKEN_TIME = "lastgettokentime";
  static const String HEAD_ICON="HEAD_ICON";//头像
  static void setUserId(String userId) {
    App.prefs.setString(USER_ID, userId);
  }
  static String? getUserId() {
    return App.prefs.getString(USER_ID);
  }
  static void setToken(String token){
    App.prefs.setString(TOKEN, token);
  }
  static String? getToken() {
    return App.prefs.getString(TOKEN);
  }
  static void removeUserId() {
    App.prefs.remove(USER_ID);
  }
  static void removeToken() {
    App.prefs.remove(TOKEN);
  }
  // static Future<bool>clearLogin() async{
  //  return  App.prefs.clear();
  // }
  static void clearLogin() {
    App.prefs.clear();
  }
  static void setExpiresIn(int expiresIn){
    App.prefs.setInt(EXPIRESIN, expiresIn);
  }
  static int? getExpiresIn() {
    return App.prefs.getInt(EXPIRESIN);
  }
  static void setLastGetTokenTime(double lastTokenTime){
    App.prefs.setDouble(LAST_GET_TOKEN_TIME, lastTokenTime);
  }
  static double? getLastGetTokenTime() {
    return App.prefs.getDouble(LAST_GET_TOKEN_TIME);
  }
  static void setHeadIcon(String headIcon){
    App.prefs.setString(HEAD_ICON, headIcon);
  }
  static String? getHeadIcon() {
    return App.prefs.getString(HEAD_ICON);
  }
  static void logout() {
     setToken("");
     setExpiresIn(-1);
    setLastGetTokenTime(-1);
    setUserId("");
    setHeadIcon("");
  }

  static void login(String accessToken, int expiresIn, String userId) {
     setToken(accessToken);
    setExpiresIn(expiresIn);
    setUserId(userId);
    setLastGetTokenTime(DateTime.now().millisecondsSinceEpoch / 1000);

  }

}