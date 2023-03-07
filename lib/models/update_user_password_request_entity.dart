import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class UpdateUserPasswordRequestEntity with JsonConvert<UpdateUserPasswordRequestEntity> {
	late String oldPassword;
	late String newPassword;
	late String confirmPassword;
	late int userRole;
}
