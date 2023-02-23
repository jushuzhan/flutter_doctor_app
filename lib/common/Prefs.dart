import 'App.dart';
class Prefs{
  static const String DoctorType="DoctorType";//医生职称
  static const String TechnicianType="TechnicianType";//技师职称

  static void saveDoctorType(String doctorType) {
    App.prefs.setString(DoctorType, doctorType);
  }
  static String? getDoctorType() {
    return App.prefs.getString(DoctorType);
  }
  static void saveTechnicianType(String token){
    App.prefs.setString(TechnicianType, token);
  }
  static String? getTechnicianType() {
    return App.prefs.getString(TechnicianType);
  }
  static void removeDoctorType() {
    App.prefs.remove(DoctorType);
  }
  static void removeTechnicianType() {
    App.prefs.remove(TechnicianType);
  }

}