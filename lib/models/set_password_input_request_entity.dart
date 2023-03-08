import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class SetPasswordInputRequestEntity with JsonConvert<SetPasswordInputRequestEntity> {
	late int userId;
	late String newPassword;
	late String confirmPassword;
	late int userRole;
}
