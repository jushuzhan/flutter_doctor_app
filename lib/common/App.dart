import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'net/NetWorkWithToken.dart';
import 'net/NetWorkWithoutToken.dart';
import 'package:fluwx/fluwx.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
class App{
  static  late SharedPreferences _prefs;//延迟初始化
  static  late PackageInfo _packageInfo;//延迟初始化
  static Future<String> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    registerWxApi(appId: "wx19013019320318b1");
    _packageInfo = await PackageInfo.fromPlatform();
    _prefs = await SharedPreferences.getInstance();
    //初始化网络请求相关配置
    NetWorkWithoutToken.init();
    NetWorkWithToken.init();
    EMOptions options = EMOptions(
      appKey: "1110191216157295#lbjk",
      debugModel: true,
      autoLogin: true,//允许自动登录
    );
    await EMClient.getInstance.init(options);
    // 通知sdk ui已经准备好，执行后才会收到`EMChatRoomEventHandler`, `EMContactEventHandler`, `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
    return 'ok';
  }

  static PackageInfo get packageInfo => _packageInfo;
  static SharedPreferences get prefs => _prefs;
}