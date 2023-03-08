import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class BindPhoneResponseEntity with JsonConvert<BindPhoneResponseEntity> {
	bool? successed;
	String? msg;
	bool? setPassword;
	int? userId;
}
