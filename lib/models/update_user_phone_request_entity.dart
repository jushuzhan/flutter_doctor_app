import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class UpdateUserPhoneRequestEntity with JsonConvert<UpdateUserPhoneRequestEntity> {
	late String phone;
	late String authCode;
	late int userRole;
}
