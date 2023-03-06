import 'package:flutter_doctor_app/models/doctor_extend_by_doctor_id_response_entity.dart';

doctorExtendByDoctorIdResponseEntityFromJson(DoctorExtendByDoctorIdResponseEntity data, Map<String, dynamic> json) {
	if (json['doctorId'] != null) {
		data.doctorId = json['doctorId'] is String
				? int.tryParse(json['doctorId'])
				: json['doctorId'].toInt();
	}
	if (json['showCardId'] != null) {
		data.showCardId = json['showCardId'].toString();
	}
	if (json['birthdate'] != null) {
		data.birthdate = json['birthdate'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'] is String
				? int.tryParse(json['gender'])
				: json['gender'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['phoneNumber'] != null) {
		data.phoneNumber = json['phoneNumber'].toString();
	}
	if (json['price'] != null) {
		data.price = json['price'] is String
				? int.tryParse(json['price'])
				: json['price'].toInt();
	}
	if (json['headimgurl'] != null) {
		data.headimgurl = json['headimgurl'].toString();
	}
	if (json['doctorType'] != null) {
		data.doctorType = json['doctorType'] is String
				? int.tryParse(json['doctorType'])
				: json['doctorType'].toInt();
	}
	if (json['technicianType'] != null) {
		data.technicianType = json['technicianType'] is String
				? int.tryParse(json['technicianType'])
				: json['technicianType'].toInt();
	}
	if (json['hospital'] != null) {
		data.hospital = json['hospital'].toString();
	}
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	if (json['certificationImgUrl'] != null) {
		data.certificationImgUrl = json['certificationImgUrl'].toString();
	}
	if (json['auditStatus'] != null) {
		data.auditStatus = json['auditStatus'] is String
				? int.tryParse(json['auditStatus'])
				: json['auditStatus'].toInt();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> doctorExtendByDoctorIdResponseEntityToJson(DoctorExtendByDoctorIdResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['doctorId'] = entity.doctorId;
	data['showCardId'] = entity.showCardId;
	data['birthdate'] = entity.birthdate;
	data['gender'] = entity.gender;
	data['name'] = entity.name;
	data['phoneNumber'] = entity.phoneNumber;
	data['price'] = entity.price;
	data['headimgurl'] = entity.headimgurl;
	data['doctorType'] = entity.doctorType;
	data['technicianType'] = entity.technicianType;
	data['hospital'] = entity.hospital;
	data['description'] = entity.description;
	data['certificationImgUrl'] = entity.certificationImgUrl;
	data['auditStatus'] = entity.auditStatus;
	data['id'] = entity.id;
	return data;
}