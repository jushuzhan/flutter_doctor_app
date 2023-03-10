import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class CreateOrUpdateDoctorExtendInputRequestEntity with JsonConvert<CreateOrUpdateDoctorExtendInputRequestEntity> {
	CreateOrUpdateDoctorExtendInputRequestDoctorExtend? doctorExtend;
}

class CreateOrUpdateDoctorExtendInputRequestDoctorExtend with JsonConvert<CreateOrUpdateDoctorExtendInputRequestDoctorExtend> {
	int? id;
	int? doctorId;
	String? cardId;
	String? birthdate;
	int? gender;
	String? name;
	String? phoneNumber;
	int? price;
	String? headimgurl;
	int? doctorType;
	int? technicianType;
	String? hospital;
	String? description;
	String? certificationImgUrl;
	int? auditStatus;
}
