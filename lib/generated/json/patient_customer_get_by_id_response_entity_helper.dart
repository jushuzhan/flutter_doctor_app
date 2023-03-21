import 'package:flutter_doctor_app/models/patient_customer_get_by_id_response_entity.dart';

patientCustomerGetByIdResponseEntityFromJson(PatientCustomerGetByIdResponseEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['birthdate'] != null) {
		data.birthdate = json['birthdate'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'] is String
				? int.tryParse(json['gender'])
				: json['gender'].toInt();
	}
	if (json['genderRemark'] != null) {
		data.genderRemark = json['genderRemark'].toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['showCardId'] != null) {
		data.showCardId = json['showCardId'].toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> patientCustomerGetByIdResponseEntityToJson(PatientCustomerGetByIdResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['birthdate'] = entity.birthdate;
	data['gender'] = entity.gender;
	data['genderRemark'] = entity.genderRemark;
	data['userId'] = entity.userId;
	data['showCardId'] = entity.showCardId;
	data['phone'] = entity.phone;
	data['id'] = entity.id;
	return data;
}