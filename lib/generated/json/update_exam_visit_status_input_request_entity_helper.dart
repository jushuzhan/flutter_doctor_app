import 'package:flutter_doctor_app/models/update_exam_visit_status_input_request_entity.dart';

updateExamVisitStatusInputRequestEntityFromJson(UpdateExamVisitStatusInputRequestEntity data, Map<String, dynamic> json) {
	if (json['examVisitStatus'] != null) {
		data.examVisitStatus = json['examVisitStatus'] is String
				? int.tryParse(json['examVisitStatus'])
				: json['examVisitStatus'].toInt();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> updateExamVisitStatusInputRequestEntityToJson(UpdateExamVisitStatusInputRequestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['examVisitStatus'] = entity.examVisitStatus;
	data['id'] = entity.id;
	return data;
}