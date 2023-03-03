import 'package:flutter_doctor_app/models/make_conclusion_input_request_entity.dart';

makeConclusionInputRequestEntityFromJson(MakeConclusionInputRequestEntity data, Map<String, dynamic> json) {
	if (json['conclusion'] != null) {
		data.conclusion = json['conclusion'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> makeConclusionInputRequestEntityToJson(MakeConclusionInputRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['conclusion'] = entity.conclusion;
	data['id'] = entity.id;
	return data;
}