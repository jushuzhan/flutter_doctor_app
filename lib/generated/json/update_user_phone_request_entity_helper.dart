import 'package:flutter_doctor_app/models/update_user_phone_request_entity.dart';

updateUserPhoneRequestEntityFromJson(UpdateUserPhoneRequestEntity data, Map<String, dynamic> json) {
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['authCode'] != null) {
		data.authCode = json['authCode'].toString();
	}
	if (json['userRole'] != null) {
		data.userRole = json['userRole'] is String
				? int.tryParse(json['userRole'])
				: json['userRole'].toInt();
	}
	return data;
}

Map<String, dynamic> updateUserPhoneRequestEntityToJson(UpdateUserPhoneRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['phone'] = entity.phone;
	data['authCode'] = entity.authCode;
	data['userRole'] = entity.userRole;
	return data;
}