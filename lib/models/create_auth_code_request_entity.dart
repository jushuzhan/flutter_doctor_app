import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class CreateAuthCodeRequestEntity with JsonConvert<CreateAuthCodeRequestEntity> {
	late String phone;
	late int userRole;
}
