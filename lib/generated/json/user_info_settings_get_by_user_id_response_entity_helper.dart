import 'package:flutter_doctor_app/models/user_info_settings_get_by_user_id_response_entity.dart';

userInfoSettingsGetByUserIdResponseEntityFromJson(UserInfoSettingsGetByUserIdResponseEntity data, Map<String, dynamic> json) {
	if (json['jiguangPush'] != null) {
		data.jiguangPush = json['jiguangPush'];
	}
	return data;
}

Map<String, dynamic> userInfoSettingsGetByUserIdResponseEntityToJson(UserInfoSettingsGetByUserIdResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['jiguangPush'] = entity.jiguangPush;
	return data;
}