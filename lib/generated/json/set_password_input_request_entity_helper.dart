import 'package:flutter_doctor_app/models/set_password_input_request_entity.dart';

setPasswordInputRequestEntityFromJson(SetPasswordInputRequestEntity data, Map<String, dynamic> json) {
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['newPassword'] != null) {
		data.newPassword = json['newPassword'].toString();
	}
	if (json['confirmPassword'] != null) {
		data.confirmPassword = json['confirmPassword'].toString();
	}
	if (json['userRole'] != null) {
		data.userRole = json['userRole'] is String
				? int.tryParse(json['userRole'])
				: json['userRole'].toInt();
	}
	return data;
}

Map<String, dynamic> setPasswordInputRequestEntityToJson(SetPasswordInputRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userId'] = entity.userId;
	data['newPassword'] = entity.newPassword;
	data['confirmPassword'] = entity.confirmPassword;
	data['userRole'] = entity.userRole;
	return data;
}