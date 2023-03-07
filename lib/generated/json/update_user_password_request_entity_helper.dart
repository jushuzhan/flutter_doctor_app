import 'package:flutter_doctor_app/models/update_user_password_request_entity.dart';

updateUserPasswordRequestEntityFromJson(UpdateUserPasswordRequestEntity data, Map<String, dynamic> json) {
	if (json['oldPassword'] != null) {
		data.oldPassword = json['oldPassword'].toString();
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

Map<String, dynamic> updateUserPasswordRequestEntityToJson(UpdateUserPasswordRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['oldPassword'] = entity.oldPassword;
	data['newPassword'] = entity.newPassword;
	data['confirmPassword'] = entity.confirmPassword;
	data['userRole'] = entity.userRole;
	return data;
}