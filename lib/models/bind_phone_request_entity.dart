import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class BindPhoneRequestEntity with JsonConvert<BindPhoneRequestEntity> {
  String? unionId;
  String? openid;
  String? nickname;
  int? sex;
  late String phone;
  late String authCode;
  late int loginType;
  late int userRole;
}
