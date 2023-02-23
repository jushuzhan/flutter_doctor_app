import 'package:json_annotation/json_annotation.dart';
import 'EnumBean.dart';
class Result {
  String? enmuType;
  @JsonKey(name: 'enum')
  List<EnumBean>? enumX;

  Result({this.enmuType, this.enumX});

Result.fromJson(Map<String, dynamic> json) {
enmuType = json['enmuType'];
if (json['enum'] != null) {
  enumX = <EnumBean>[];
json['enum'].forEach((v) { enumX!.add(new EnumBean.fromJson(v)); });
}
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['enmuType'] = this.enmuType;
  if (this.enumX != null) {
    data['enum'] = this.enumX!.map((v) => v.toJson()).toList();
}
  return data;
}
}