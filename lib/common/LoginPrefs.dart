import 'package:flutter/cupertino.dart';

import '../models/RefreshTokenRequest.dart';
import '../models/RefreshTokenResponse.dart';
import 'App.dart';
import 'constants/constants.dart';
import 'net/NetWorkWithoutToken.dart';
class LoginPrefs {
  BuildContext? context;

  LoginPrefs({required this.context});

  static const String USER_ID = "USER_ID"; //用户ID
  static const String TOKEN = "TOKEN"; //token
  static const String EXPIRESIN = "EXPIRESIN"; //EXPIRESIN
  static const String LAST_GET_TOKEN_TIME = "lastgettokentime";
  static const String HEAD_ICON = "HEAD_ICON"; //头像
  static void setUserId(String userId) {
    App.prefs.setString(USER_ID, userId);
  }

  static String? getUserId() {
    return App.prefs.getString(USER_ID);
  }

  static void setAccessToken(String token) {
    App.prefs.setString(TOKEN, token);
  }

  static String? getAccessToken() {
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

  static void setExpiresIn(int? expiresIn) {
    App.prefs.setInt(EXPIRESIN, expiresIn!);
  }

  static int? getExpiresIn() {
    return App.prefs.getInt(EXPIRESIN);
  }

  static void setLastGetTokenTime(double lastTokenTime) {
    App.prefs.setDouble(LAST_GET_TOKEN_TIME, lastTokenTime);
  }

  static double? getLastGetTokenTime() {
    return App.prefs.getDouble(LAST_GET_TOKEN_TIME);
  }

  static void setHeadIcon(String headIcon) {
    App.prefs.setString(HEAD_ICON, headIcon);
  }

  static String? getHeadIcon() {
    return App.prefs.getString(HEAD_ICON);
  }

  static void logout() {
    setAccessToken("");
    setExpiresIn(-1);
    setLastGetTokenTime(-1);
    setUserId("");
    setHeadIcon("");
  }

  static void login(String accessToken, int expiresIn, String userId) {
    setAccessToken(accessToken);
    setExpiresIn(expiresIn);
    setUserId(userId);
    setLastGetTokenTime(DateTime
        .now()
        .millisecondsSinceEpoch / 1000);
  }

  // static Iterable<Future<String>> getToken() sync *{
  //   return "";
  //
  // }

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
    } else {
      //根据 refreshToken 刷新 token，获得最新 token
      //⚠️需要使用同步请求
      String? userId = getUserId();
      if (userId == null || userId!.isEmpty) {
        print("本地存储的userId为空");
        token = "";
        // toLogin();展示登录弹窗
      } else {
        RefreshTokenRequest refreshTokenRequest = RefreshTokenRequest(
            clientId: CLIENT_ID, userId: userId, deviceUUID: JIGUANGID);
        Future<RefreshTokenResponse> refreshTokenResponse = NetWorkWithoutToken(
            context).refreshToken(refreshTokenRequest);
        refreshTokenResponse.then((RefreshTokenResponse value) {
          if (value == null) {
            //toLogin();
          } else {
            if (value.success != null && value.success == true &&
                value.accessToken != null && value.expiresIn != null) {
              print(
                  "UserUtil刷新token成功，将新的token、expiresIn、lastGetTokenTime保存到本地，并返回刷新出来的token");
              token = value.accessToken;
              setAccessToken(token!);
              print("新的token保存成功");
              setExpiresIn(value.expiresIn);
              print("新的expiresIn保存成功");
              setLastGetTokenTime(getCurrentTime() / 1000);
              print("新的lastGetTokenTime保存成功");
            } else {
              print("UserUtil刷新token失败");
              token = "";
              //toLogin();
            }
          }
        });
      }
      return token;
    }
    return "";
  }

  int getCurrentTime() {
    return DateTime
        .now()
        .millisecondsSinceEpoch;
  }
}