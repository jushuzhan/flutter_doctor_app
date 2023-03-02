import 'package:flutter_doctor_app/models/paged_result_dto_response_entity.dart';

pagedResultDtoResponseEntityFromJson(PagedResultDtoResponseEntity data, Map<String, dynamic> json) {
	if (json['totalCount'] != null) {
		data.totalCount = json['totalCount'] is String
				? int.tryParse(json['totalCount'])
				: json['totalCount'].toInt();
	}
	if (json['items'] != null) {
		data.items = (json['items'] as List).map((v) => PagedResultDtoResponseItems().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> pagedResultDtoResponseEntityToJson(PagedResultDtoResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['totalCount'] = entity.totalCount;
	data['items'] =  entity.items?.map((v) => v.toJson())?.toList();
	return data;
}

pagedResultDtoResponseItemsFromJson(PagedResultDtoResponseItems data, Map<String, dynamic> json) {
	if (json['doctorId'] != null) {
		data.doctorId = json['doctorId'] is String
				? int.tryParse(json['doctorId'])
				: json['doctorId'].toInt();
	}
	if (json['doctorName'] != null) {
		data.doctorName = json['doctorName'].toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['patientId'] != null) {
		data.patientId = json['patientId'] is String
				? int.tryParse(json['patientId'])
				: json['patientId'].toInt();
	}
	if (json['patientName'] != null) {
		data.patientName = json['patientName'].toString();
	}
	if (json['question'] != null) {
		data.question = json['question'].toString();
	}
	if (json['examRecordId'] != null) {
		data.examRecordId = json['examRecordId'] is String
				? int.tryParse(json['examRecordId'])
				: json['examRecordId'].toInt();
	}
	if (json['diagnoseId'] != null) {
		data.diagnoseId = json['diagnoseId'] is String
				? int.tryParse(json['diagnoseId'])
				: json['diagnoseId'].toInt();
	}
	if (json['recommendUserId'] != null) {
		data.recommendUserId = json['recommendUserId'] is String
				? int.tryParse(json['recommendUserId'])
				: json['recommendUserId'].toInt();
	}
	if (json['recommendUserName'] != null) {
		data.recommendUserName = json['recommendUserName'].toString();
	}
	if (json['tenantId'] != null) {
		data.tenantId = json['tenantId'] is String
				? int.tryParse(json['tenantId'])
				: json['tenantId'].toInt();
	}
	if (json['tenantName'] != null) {
		data.tenantName = json['tenantName'].toString();
	}
	if (json['receivablePrice'] != null) {
		data.receivablePrice = json['receivablePrice'] is String
				? int.tryParse(json['receivablePrice'])
				: json['receivablePrice'].toInt();
	}
	if (json['actualPrice'] != null) {
		data.actualPrice = json['actualPrice'] is String
				? int.tryParse(json['actualPrice'])
				: json['actualPrice'].toInt();
	}
	if (json['examVisitType'] != null) {
		data.examVisitType = json['examVisitType'] is String
				? int.tryParse(json['examVisitType'])
				: json['examVisitType'].toInt();
	}
	if (json['examVisitTypeRemark'] != null) {
		data.examVisitTypeRemark = json['examVisitTypeRemark'].toString();
	}
	if (json['examVisitStatus'] != null) {
		data.examVisitStatus = json['examVisitStatus'] is String
				? int.tryParse(json['examVisitStatus'])
				: json['examVisitStatus'].toInt();
	}
	if (json['examVisitStatusRemark'] != null) {
		data.examVisitStatusRemark = json['examVisitStatusRemark'].toString();
	}
	if (json['orderNumber'] != null) {
		data.orderNumber = json['orderNumber'].toString();
	}
	if (json['conclusion'] != null) {
		data.conclusion = json['conclusion'].toString();
	}
	if (json['creationTime'] != null) {
		data.creationTime = json['creationTime'].toString();
	}
	if (json['lastModificationTime'] != null) {
		data.lastModificationTime = json['lastModificationTime'].toString();
	}
	if (json['deletionTime'] != null) {
		data.deletionTime = json['deletionTime'].toString();
	}
	if (json['isDeleted'] != null) {
		data.isDeleted = json['isDeleted'];
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> pagedResultDtoResponseItemsToJson(PagedResultDtoResponseItems entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['doctorId'] = entity.doctorId;
	data['doctorName'] = entity.doctorName;
	data['userId'] = entity.userId;
	data['patientId'] = entity.patientId;
	data['patientName'] = entity.patientName;
	data['question'] = entity.question;
	data['examRecordId'] = entity.examRecordId;
	data['diagnoseId'] = entity.diagnoseId;
	data['recommendUserId'] = entity.recommendUserId;
	data['recommendUserName'] = entity.recommendUserName;
	data['tenantId'] = entity.tenantId;
	data['tenantName'] = entity.tenantName;
	data['receivablePrice'] = entity.receivablePrice;
	data['actualPrice'] = entity.actualPrice;
	data['examVisitType'] = entity.examVisitType;
	data['examVisitTypeRemark'] = entity.examVisitTypeRemark;
	data['examVisitStatus'] = entity.examVisitStatus;
	data['examVisitStatusRemark'] = entity.examVisitStatusRemark;
	data['orderNumber'] = entity.orderNumber;
	data['conclusion'] = entity.conclusion;
	data['creationTime'] = entity.creationTime;
	data['lastModificationTime'] = entity.lastModificationTime;
	data['deletionTime'] = entity.deletionTime;
	data['isDeleted'] = entity.isDeleted;
	data['id'] = entity.id;
	return data;
}