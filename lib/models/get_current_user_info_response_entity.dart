import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class GetCurrentUserInfoResponseEntity with JsonConvert<GetCurrentUserInfoResponseEntity> {
	String? nickName;
	String? phoneNumber;
	bool? bindWechat;
	int? id;
}
