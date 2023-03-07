import 'package:flutter_doctor_app/models/user_info_settings_get_by_user_id_request_entity.dart';

userInfoSettingsGetByUserIdRequestEntityFromJson(UserInfoSettingsGetByUserIdRequestEntity data, Map<String, dynamic> json) {
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

Map<String, dynamic> userInfoSettingsGetByUserIdRequestEntityToJson(UserInfoSettingsGetByUserIdRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userId'] = entity.userId;
	data['userRole'] = entity.userRole;
	return data;
}