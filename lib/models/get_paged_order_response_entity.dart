import 'package:flutter_doctor_app/generated/json/base/json_convert_content.dart';

class GetPagedOrderResponseEntity with JsonConvert<GetPagedOrderResponseEntity> {
	late int totalCount;
	late List<GetPagedOrderResponseItems> items;
}

class GetPagedOrderResponseItems with JsonConvert<GetPagedOrderResponseItems> {
	late GetPagedOrderResponseItemsOrder order;
	late GetPagedOrderResponseItemsVisit visit;
	late GetPagedOrderResponseItemsExamRecord examRecord;
	late List<GetPagedOrderResponseItemsCheckItems> checkItems;
	late bool isExpanded=false;
}

class GetPagedOrderResponseItemsOrder with JsonConvert<GetPagedOrderResponseItemsOrder> {
	late int orderType;
	late String orderTypeRemark;
	late String orderNumber;
	late int payMoney;
	late int tradeType;
	late String tradeTypeRemark;
	late int status;
	late String statusRemark;
	late String creationTime;
}

class GetPagedOrderResponseItemsVisit with JsonConvert<GetPagedOrderResponseItemsVisit> {
	late String patientName;
}

class GetPagedOrderResponseItemsExamRecord with JsonConvert<GetPagedOrderResponseItemsExamRecord> {
	late int tenantId;
	late String tenantName;
	late String organizationCode;
	late String organizationName;
	late int patientId;
	late String patientName;
	late String patientBirthdate;
	late int patientGender;
	late int patientMonth;
	late int userId;
	late int receivablePrice;
	late int actualPrice;
	late int examStatus;
	late String examStatusRemark;
	late int diagnoseStatus;
	late String diagnoseStatusRemark;
	late String examDateTime;
	late int diagnoseUserId;
	late String diagnoseUserName;
	late int examRecordType;
	late String examRecordTypeRemark;
	late String creationTime;
	late int id;
}

class GetPagedOrderResponseItemsCheckItems with JsonConvert<GetPagedOrderResponseItemsCheckItems> {
	late int examinationType;
	late String examinationTypeRemark;

}
