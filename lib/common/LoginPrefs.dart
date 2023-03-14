import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/BaseBean.dart';
import '../models/RefreshTokenRequest.dart';
import '../models/RefreshTokenResponse.dart';
import '../models/logout_this_device_request_entity.dart';
import 'App.dart';
import 'constants/constants.dart';
import 'net/NetWorkWithoutToken.dart';
class LoginPrefs {
  late
  BuildContext context;
  LoginPrefs(this.context);
  static const String USER_ID = "USER_ID"; //用户ID
  static const String TOKEN = "TOKEN"; //token
  static const String EXPIRESIN = "EXPIRESIN"; //EXPIRESIN
  static const String LAST_GET_TOKEN_TIME = "lastgettokentime";
  static const String HEAD_ICON = "HEAD_ICON"; //头像
   void setUserId(String userId) {
    App.prefs.setString(USER_ID, userId);
  }

   String? getUserId() {
    return App.prefs.getString(USER_ID);
  }

   void setAccessToken(String token) {
    App.prefs.setString(TOKEN, token);
  }

   String? getAccessToken() {
    return App.prefs.getString(TOKEN);
  }

   void removeUserId() {
    App.prefs.remove(USER_ID);
  }

   void removeToken() {
    App.prefs.remove(TOKEN);
  }

  // static Future<bool>clearLogin() async{
  //  return  App.prefs.clear();
  // }
   void clearLogin() {
    App.prefs.clear();
  }

   void setExpiresIn(int? expiresIn) {
    App.prefs.setInt(EXPIRESIN, expiresIn!);
  }

   int? getExpiresIn() {
    return App.prefs.getInt(EXPIRESIN);
  }

   void setLastGetTokenTime(double lastTokenTime) {
    App.prefs.setDouble(LAST_GET_TOKEN_TIME, lastTokenTime);
  }

   double? getLastGetTokenTime() {
    return App.prefs.getDouble(LAST_GET_TOKEN_TIME);
  }

   void setHeadIcon(String headIcon) {
    App.prefs.setString(HEAD_ICON, headIcon);
  }

   String? getHeadIcon() {
    return App.prefs.getString(HEAD_ICON);
  }

   void logout() {
    setAccessToken("");
    setExpiresIn(-1);
    setLastGetTokenTime(-1);
    setUserId("");
    setHeadIcon("");
  }

   void login(String accessToken, int expiresIn, String userId) {
    setAccessToken(accessToken);
    setExpiresIn(expiresIn);
    setUserId(userId);
    setLastGetTokenTime(DateTime
        .now()
        .millisecondsSinceEpoch / 1000);
  }

  bool isLogin() {
    String? token = getAccessToken();
    int?expiresIn = getExpiresIn();
    String? userId = getUserId();

    return token!=null&&token.isNotEmpty && expiresIn!=null&&expiresIn >= 0 && userId!=null&&userId.isNotEmpty;
  }

  Future<String?> getToken() async {
    String? token = getAccessToken();
    double? lastGetTokenTime = getLastGetTokenTime();
    int currentTime = getCurrentTime();
    int? expiresIn = getExpiresIn();
    if (token == null || token!.isEmpty) {
      print("本地存储的token为空");
      return "";
    }
    if (lastGetTokenTime != null && lastGetTokenTime! < 0) {
      print("本地存储的lastGetTokenTime为空");
      return "";
    }

    if (expiresIn != null && expiresIn < 0) {
      print("本地存储的expiresIn为空");
      return "";
    }

    //判断 token 的有效期是否在时间段内
    if ((currentTime - lastGetTokenTime!) < expiresIn!) {
      //token在有效期内，不需要特殊处理，直接返回token即可
      print("token在有效期内，不需要特殊处理，直接返回token即可");
      return token;
    } else {
      //根据 refreshToken 刷新 token，获得最新 token
      //⚠️需要使用同步请求
      String? userId = getUserId();
      if (userId == null || userId!.isEmpty) {
        print("本地存储的userId为空");
        token = "";
        Navigator.of(context).pushNamedAndRemoveUntil(
            "login", ModalRoute.withName("login"));
      } else {

        RefreshTokenRequest refreshTokenRequest = RefreshTokenRequest(
            clientId: CLIENT_ID, userId: userId, deviceUUID: JIGUANGID);

       RefreshTokenResponse refreshTokenResponse = await NetWorkWithoutToken(
            context).refreshToken(refreshTokenRequest);
          if (refreshTokenResponse == null) {
            LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity=LogoutThisDeviceRequestEntity();
            logoutThisDeviceRequestEntity.userId=userId!;
            logoutThisDeviceRequestEntity.loginType=LOGIN_TYPE;
            logoutThisDeviceRequestEntity.clientId=CLIENT_ID;
            logoutThisDeviceRequestEntity.deviceUUID=JIGUANGID;
            Future<BaseBean> baseBean=NetWorkWithoutToken(context).logoutThisDevice(logoutThisDeviceRequestEntity);
            baseBean.then((value) {
              print(value.success);
              logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "login", ModalRoute.withName("login"));
            });
          } else {
            if (refreshTokenResponse.success != null && refreshTokenResponse.success == true &&
                refreshTokenResponse.accessToken != null && refreshTokenResponse.expiresIn != null) {
              print(
                  "UserUtil刷新token成功，将新的token、expiresIn、lastGetTokenTime保存到本地，并返回刷新出来的token");
              token = refreshTokenResponse.accessToken;
              setAccessToken(token!);
              print("新的token保存成功");
              setExpiresIn(refreshTokenResponse.expiresIn);
              print("新的expiresIn保存成功");
              setLastGetTokenTime(getCurrentTime() / 1000);
              print("新的lastGetTokenTime保存成功");
            } else {
              print("UserUtil刷新token失败");
              token = "";
              LogoutThisDeviceRequestEntity logoutThisDeviceRequestEntity=LogoutThisDeviceRequestEntity();
              logoutThisDeviceRequestEntity.userId=userId!;
              logoutThisDeviceRequestEntity.loginType=LOGIN_TYPE;
              logoutThisDeviceRequestEntity.clientId=CLIENT_ID;
              logoutThisDeviceRequestEntity.deviceUUID=JIGUANGID;
              BaseBean baseBean= await NetWorkWithoutToken(context).logoutThisDevice(logoutThisDeviceRequestEntity);
              if(baseBean!=null){
                print(baseBean.success);
                logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "login", ModalRoute.withName("login"));
              }
            }
          }

      }
      return token;
    }
  }

   int getCurrentTime() {
    return DateTime
        .now()
        .millisecondsSinceEpoch;
  }
}