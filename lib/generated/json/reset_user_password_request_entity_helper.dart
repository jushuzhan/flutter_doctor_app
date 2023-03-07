import 'package:flutter_doctor_app/models/reset_user_password_request_entity.dart';

resetUserPasswordRequestEntityFromJson(ResetUserPasswordRequestEntity data, Map<String, dynamic> json) {
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['authCode'] != null) {
		data.authCode = json['authCode'].toString();
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

Map<String, dynamic> resetUserPasswordRequestEntityToJson(ResetUserPasswordRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['phone'] = entity.phone;
	data['authCode'] = entity.authCode;
	data['newPassword'] = entity.newPassword;
	data['confirmPassword'] = entity.confirmPassword;
	data['userRole'] = entity.userRole;
	return data;
}