import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class UpdateUserInfoResponseEntity with JsonConvert<UpdateUserInfoResponseEntity> {
	String? msg;
	UpdateUserInfoResponseDoctorExtend? doctorExtend;
}

class UpdateUserInfoResponseDoctorExtend with JsonConvert<UpdateUserInfoResponseDoctorExtend> {
	int? doctorId;
	String? showCardId;
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
	int? id;
}
