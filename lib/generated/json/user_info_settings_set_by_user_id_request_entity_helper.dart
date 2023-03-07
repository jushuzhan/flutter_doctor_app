import 'package:flutter_doctor_app/models/user_info_settings_set_by_user_id_request_entity.dart';

userInfoSettingsSetByUserIdRequestEntityFromJson(UserInfoSettingsSetByUserIdRequestEntity data, Map<String, dynamic> json) {
	if (json['jiguangPush'] != null) {
		data.jiguangPush = json['jiguangPush'];
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['userRole'] != null) {
		data.userRole = json['userRole'] is String
				? int.tryParse(json['userRole'])
				: json['userRole'].toInt();
	}
	return data;
}

Map<String, dynamic> userInfoSettingsSetByUserIdRequestEntityToJson(UserInfoSettingsSetByUserIdRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['jiguangPush'] = entity.jiguangPush;
	data['userId'] = entity.userId;
	data['userRole'] = entity.userRole;
	return data;
}