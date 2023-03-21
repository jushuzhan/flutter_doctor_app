import 'package:flutter_doctor_app/models/get_huanxin_id_input_request_entity.dart';

getHuanxinIdInputRequestEntityFromJson(GetHuanxinIdInputRequestEntity data, Map<String, dynamic> json) {
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['doctorId'] != null) {
		data.doctorId = json['doctorId'] is String
				? int.tryParse(json['doctorId'])
				: json['doctorId'].toInt();
	}
	return data;
}

Map<String, dynamic> getHuanxinIdInputRequestEntityToJson(GetHuanxinIdInputRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userId'] = entity.userId;
	data['doctorId'] = entity.doctorId;
	return data;
}