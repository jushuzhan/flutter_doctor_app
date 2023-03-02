import 'package:flutter_doctor_app/models/get_paged_exam_visit_for_doctor_input_entity.dart';

getPagedExamVisitForDoctorInputEntityFromJson(GetPagedExamVisitForDoctorInputEntity data, Map<String, dynamic> json) {
	if (json['examVisitStatus'] != null) {
		data.examVisitStatus = json['examVisitStatus'] is String
				? int.tryParse(json['examVisitStatus'])
				: json['examVisitStatus'].toInt();
	}
	if (json['maxResultCount'] != null) {
		data.maxResultCount = json['maxResultCount'] is String
				? int.tryParse(json['maxResultCount'])
				: json['maxResultCount'].toInt();
	}
	if (json['skipCount'] != null) {
		data.skipCount = json['skipCount'] is String
				? int.tryParse(json['skipCount'])
				: json['skipCount'].toInt();
	}
	return data;
}

Map<String, dynamic> getPagedExamVisitForDoctorInputEntityToJson(GetPagedExamVisitForDoctorInputEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if(entity.examVisitStatus!=null){
		data['examVisitStatus'] = entity.examVisitStatus;
	}
	data['maxResultCount'] = entity.maxResultCount;
	data['skipCount'] = entity.skipCount;
	return data;
}