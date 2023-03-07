import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class UserInfoRegisterRequestEntity with JsonConvert<UserInfoRegisterRequestEntity> {
	String? nickName;
	late String phone;
	late String authCode;
	late String password;
	late int loginType;
	late int userRole;
}
