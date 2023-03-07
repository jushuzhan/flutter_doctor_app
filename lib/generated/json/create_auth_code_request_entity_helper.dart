import 'package:flutter_doctor_app/models/create_auth_code_request_entity.dart';

createAuthCodeRequestEntityFromJson(CreateAuthCodeRequestEntity data, Map<String, dynamic> json) {
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['userRole'] != null) {
		data.userRole = json['userRole'] is String
				? int.tryParse(json['userRole'])
				: json['userRole'].toInt();
	}
	return data;
}

Map<String, dynamic> createAuthCodeRequestEntityToJson(CreateAuthCodeRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['phone'] = entity.phone;
	data['userRole'] = entity.userRole;
	return data;
}