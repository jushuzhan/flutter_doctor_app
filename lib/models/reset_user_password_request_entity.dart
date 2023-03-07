import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class ResetUserPasswordRequestEntity with JsonConvert<ResetUserPasswordRequestEntity> {
	late String phone;
	late String authCode;
	late String newPassword;
	late String confirmPassword;
	late int userRole;
}
