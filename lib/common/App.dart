import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'net/NetWorkWithToken.dart';
import 'net/NetWorkWithoutToken.dart';
class App{
  static  late SharedPreferences _prefs;//延迟初始化
  static  late PackageInfo _packageInfo;//延迟初始化
  static Future<String> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _packageInfo = await PackageInfo.fromPlatform();
    _prefs = await SharedPreferences.getInstance();
    //初始化网络请求相关配置
    NetWorkWithoutToken.init();
    NetWorkWithToken.init();
    return 'ok';
  }

  static PackageInfo get packageInfo => _packageInfo;
  static SharedPreferences get prefs => _prefs;
}