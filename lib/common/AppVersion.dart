
import 'App.dart';
class AppVersion{
  static String? getAppName() {
    return App.packageInfo.appName;
  }
  static String? getVersion() {
    return  App.packageInfo.version;
  }
  static String? getBuildNumber() {
    return App.packageInfo.buildNumber;
  }



}