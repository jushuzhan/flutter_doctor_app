import 'package:flutter_doctor_app/models/get_paged_order_response_entity.dart';

getPagedOrderResponseEntityFromJson(GetPagedOrderResponseEntity data, Map<String, dynamic> json) {
	if (json['totalCount'] != null) {
		data.totalCount = json['totalCount'] is String
				? int.tryParse(json['totalCount'])
				: json['totalCount'].toInt();
	}
	if (json['items'] != null) {
		data.items = (json['items'] as List).map((v) => GetPagedOrderResponseItems().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> getPagedOrderResponseEntityToJson(GetPagedOrderResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['totalCount'] = entity.totalCount;
	data['items'] =  entity.items.map((v) => v.toJson()).toList();
	return data;
}

getPagedOrderResponseItemsFromJson(GetPagedOrderResponseItems data, Map<String, dynamic> json) {
	if (json['order'] != null) {
		data.order = GetPagedOrderResponseItemsOrder().fromJson(json['order']);
	}
	if (json['visit'] != null) {
		data.visit = GetPagedOrderResponseItemsVisit().fromJson(json['visit']);
	}
	if (json['examRecord'] != null) {
		data.examRecord = GetPagedOrderResponseItemsExamRecord().fromJson(json['examRecord']);
	}
	if (json['checkItems'] != null) {
		data.checkItems = (json['checkItems'] as List).map((v) => GetPagedOrderResponseItemsCheckItems().fromJson(v)).toList();
	}
	if (json['isExpanded'] != null) {
		data.isExpanded = json['isExpanded'];
	}
	return data;
}

Map<String, dynamic> getPagedOrderResponseItemsToJson(GetPagedOrderResponseItems entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['order'] = entity.order.toJson();
	data['visit'] = entity.visit.toJson();
	data['examRecord'] = entity.examRecord.toJson();
	data['checkItems'] =  entity.checkItems.map((v) => v.toJson()).toList();
	data['isExpanded'] = entity.isExpanded;
	return data;
}

getPagedOrderResponseItemsOrderFromJson(GetPagedOrderResponseItemsOrder data, Map<String, dynamic> json) {
	if (json['orderType'] != null) {
		data.orderType = json['orderType'] is String
				? int.tryParse(json['orderType'])
				: json['orderType'].toInt();
	}
	if (json['orderTypeRemark'] != null) {
		data.orderTypeRemark = json['orderTypeRemark'].toString();
	}
	if (json['orderNumber'] != null) {
		data.orderNumber = json['orderNumber'].toString();
	}
	if (json['payMoney'] != null) {
		data.payMoney = json['payMoney'] is String
				? int.tryParse(json['payMoney'])
				: json['payMoney'].toInt();
	}
	if (json['tradeType'] != null) {
		data.tradeType = json['tradeType'] is String
				? int.tryParse(json['tradeType'])
				: json['tradeType'].toInt();
	}
	if (json['tradeTypeRemark'] != null) {
		data.tradeTypeRemark = json['tradeTypeRemark'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['statusRemark'] != null) {
		data.statusRemark = json['statusRemark'].toString();
	}
	if (json['creationTime'] != null) {
		data.creationTime = json['creationTime'].toString();
	}
	return data;
}

Map<String, dynamic> getPagedOrderResponseItemsOrderToJson(GetPagedOrderResponseItemsOrder entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['orderType'] = entity.orderType;
	data['orderTypeRemark'] = entity.orderTypeRemark;
	data['orderNumber'] = entity.orderNumber;
	data['payMoney'] = entity.payMoney;
	data['tradeType'] = entity.tradeType;
	data['tradeTypeRemark'] = entity.tradeTypeRemark;
	data['status'] = entity.status;
	data['statusRemark'] = entity.statusRemark;
	data['creationTime'] = entity.creationTime;
	return data;
}

getPagedOrderResponseItemsVisitFromJson(GetPagedOrderResponseItemsVisit data, Map<String, dynamic> json) {
	if (json['patientName'] != null) {
		data.patientName = json['patientName'].toString();
	}
	return data;
}

Map<String, dynamic> getPagedOrderResponseItemsVisitToJson(GetPagedOrderResponseItemsVisit entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['patientName'] = entity.patientName;
	return data;
}

getPagedOrderResponseItemsExamRecordFromJson(GetPagedOrderResponseItemsExamRecord data, Map<String, dynamic> json) {
	if (json['tenantId'] != null) {
		data.tenantId = json['tenantId'] is String
				? int.tryParse(json['tenantId'])
				: json['tenantId'].toInt();
	}
	if (json['tenantName'] != null) {
		data.tenantName = json['tenantName'].toString();
	}
	if (json['organizationCode'] != null) {
		data.organizationCode = json['organizationCode'].toString();
	}
	if (json['organizationName'] != null) {
		data.organizationName = json['organizationName'].toString();
	}
	if (json['patientId'] != null) {
		data.patientId = json['patientId'] is String
				? int.tryParse(json['patientId'])
				: json['patientId'].toInt();
	}
	if (json['patientName'] != null) {
		data.patientName = json['patientName'].toString();
	}
	if (json['patientBirthdate'] != null) {
		data.patientBirthdate = json['patientBirthdate'].toString();
	}
	if (json['patientGender'] != null) {
		data.patientGender = json['patientGender'] is String
				? int.tryParse(json['patientGender'])
				: json['patientGender'].toInt();
	}
	if (json['patientMonth'] != null) {
		data.patientMonth = json['patientMonth'] is String
				? int.tryParse(json['patientMonth'])
				: json['patientMonth'].toInt();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
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
	if (json['examStatus'] != null) {
		data.examStatus = json['examStatus'] is String
				? int.tryParse(json['examStatus'])
				: json['examStatus'].toInt();
	}
	if (json['examStatusRemark'] != null) {
		data.examStatusRemark = json['examStatusRemark'].toString();
	}
	if (json['diagnoseStatus'] != null) {
		data.diagnoseStatus = json['diagnoseStatus'] is String
				? int.tryParse(json['diagnoseStatus'])
				: json['diagnoseStatus'].toInt();
	}
	if (json['diagnoseStatusRemark'] != null) {
		data.diagnoseStatusRemark = json['diagnoseStatusRemark'].toString();
	}
	if (json['examDateTime'] != null) {
		data.examDateTime = json['examDateTime'].toString();
	}
	if (json['diagnoseUserId'] != null) {
		data.diagnoseUserId = json['diagnoseUserId'] is String
				? int.tryParse(json['diagnoseUserId'])
				: json['diagnoseUserId'].toInt();
	}
	if (json['diagnoseUserName'] != null) {
		data.diagnoseUserName = json['diagnoseUserName'].toString();
	}
	if (json['examRecordType'] != null) {
		data.examRecordType = json['examRecordType'] is String
				? int.tryParse(json['examRecordType'])
				: json['examRecordType'].toInt();
	}
	if (json['examRecordTypeRemark'] != null) {
		data.examRecordTypeRemark = json['examRecordTypeRemark'].toString();
	}
	if (json['creationTime'] != null) {
		data.creationTime = json['creationTime'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> getPagedOrderResponseItemsExamRecordToJson(GetPagedOrderResponseItemsExamRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['tenantId'] = entity.tenantId;
	data['tenantName'] = entity.tenantName;
	data['organizationCode'] = entity.organizationCode;
	data['organizationName'] = entity.organizationName;
	data['patientId'] = entity.patientId;
	data['patientName'] = entity.patientName;
	data['patientBirthdate'] = entity.patientBirthdate;
	data['patientGender'] = entity.patientGender;
	data['patientMonth'] = entity.patientMonth;
	data['userId'] = entity.userId;
	data['receivablePrice'] = entity.receivablePrice;
	data['actualPrice'] = entity.actualPrice;
	data['examStatus'] = entity.examStatus;
	data['examStatusRemark'] = entity.examStatusRemark;
	data['diagnoseStatus'] = entity.diagnoseStatus;
	data['diagnoseStatusRemark'] = entity.diagnoseStatusRemark;
	data['examDateTime'] = entity.examDateTime;
	data['diagnoseUserId'] = entity.diagnoseUserId;
	data['diagnoseUserName'] = entity.diagnoseUserName;
	data['examRecordType'] = entity.examRecordType;
	data['examRecordTypeRemark'] = entity.examRecordTypeRemark;
	data['creationTime'] = entity.creationTime;
	data['id'] = entity.id;
	return data;
}

getPagedOrderResponseItemsCheckItemsFromJson(GetPagedOrderResponseItemsCheckItems data, Map<String, dynamic> json) {
	if (json['examinationType'] != null) {
		data.examinationType = json['examinationType'] is String
				? int.tryParse(json['examinationType'])
				: json['examinationType'].toInt();
	}
	if (json['examinationTypeRemark'] != null) {
		data.examinationTypeRemark = json['examinationTypeRemark'].toString();
	}
	return data;
}

Map<String, dynamic> getPagedOrderResponseItemsCheckItemsToJson(GetPagedOrderResponseItemsCheckItems entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['examinationType'] = entity.examinationType;
	data['examinationTypeRemark'] = entity.examinationTypeRemark;
	return data;
}