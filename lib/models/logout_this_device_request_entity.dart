import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class LogoutThisDeviceRequestEntity with JsonConvert<LogoutThisDeviceRequestEntity> {
	late String clientId;
	late String userId;
	late int loginType;
	late String deviceUUID;
}
