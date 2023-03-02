
import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';

import 'models/paged_result_dto_response_entity.dart';

class ExamVisitItemPage extends StatefulWidget {
  ExamVisitItemPage(this.examVisitItem)
      : super(key: ValueKey(examVisitItem.creationTime));

  final PagedResultDtoResponseItems examVisitItem;

  @override
  _ExamVisitItemPageState createState() => _ExamVisitItemPageState();
}

class _ExamVisitItemPageState extends State<ExamVisitItemPage> {
  final TextStyle grey12TextStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF999999),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          //状态
          Row(
            children: _buildTopList(),
          ),
          //第一行
          Padding(
            padding: EdgeInsets.only(top: 8, left: 15, right: 15),
            child: Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xFF009999),
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: Text(
                    '就诊人',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      widget.examVisitItem.patientName!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Text(
                  getTime(getDateTime(widget.examVisitItem.creationTime!)),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          //第二行
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 27, right: 15),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 4),child: Text('描述:', style: grey12TextStyle),),
                Expanded(
                  child: Text(
                    widget.examVisitItem.question!=null?widget.examVisitItem.question!:"",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF333333),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          //最后一行动态创建布局
          Column(
            children: _buildBottomList(),
          ),
        ],
      ),
    );
  }

  /// 创建列表 ,状态显示
  List<Widget> _buildTopList() {
    List<Widget> widgets = [];
    int? examVisitStatus = widget.examVisitItem.examVisitStatus;
    if (examVisitStatus != null) {
      switch (examVisitStatus) {
        // case 1://已申请
        //   break;
        case 2: //超时，未回复
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            child: Text(
              '您回复已超时，不能进行下一步操作',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ));
          break;
        case 3: //拒绝
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            child: Text(
              '您已拒绝该申请',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ));
          break;
        // case 4://同意
        //   break;
        // case 5://已解决
        //   break;
        case 6: //诊断超时
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            child: Text(
              '您诊断已超时',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ));
          break;
        // case 7://超时，未支付
        //   break;
      }
    }

    return widgets;
  }
  Divider horizontalLine(){
    return Divider(
      height: 1,
      color: Color(0xFFEEEEEE),
    );
  }
  Container verticalLine(){
    return Container(
      height: 24,
      width: 1,
      color: Color(0xFFEEEEEE),
    );
  }

  /// 创建列表 ,底部按钮显示
  List<Widget> _buildBottomList() {
    List<Widget> widgets = [];
    int? examVisitStatus = widget.examVisitItem.examVisitStatus;
    if (examVisitStatus != null) {
      switch (examVisitStatus) {
        case 1: //已申请
        widgets.add(horizontalLine());
        widgets.add(Row(
          crossAxisAlignment: CrossAxisAlignment.center,//垂直居中
          children: <Widget>[
            Expanded(child: GestureDetector(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text('拒绝申请',style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF009999),
                ),),
              ),
              onTap: (){
                //TODO 调接口，拒绝申请
              },
            ),flex: 1,),
            verticalLine(),
            Expanded(child: GestureDetector(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text('检查记录',style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF009999),
                ),),
              ),
              onTap: (){
                //TODO 跳转至检查记录界面
              },
            ),flex: 1,),
            verticalLine(),
            Expanded(child: GestureDetector(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text('同意申请',style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF009999),
                ),),
              ),
              onTap: (){
                //TODO 调接口，同意申请
              },
            ),flex: 1,),
          ],
        ));
          break;
        case 2: //超时，未回复
          break;
        case 3: //拒绝
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,//垂直居中
            children: <Widget>[
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('检查记录',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至检查记录界面
                },
              ),flex: 1,),
            ],
          ));
          break;
        case 4: //同意
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,//垂直居中
            children: <Widget>[
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('检查记录',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至检查记录界面
                },
              ),flex: 1,),
              verticalLine(),
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('继续对话',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至聊天界面
                },
              ),flex: 1,),
              verticalLine(),
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('填写结论',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至填写结论界面
                },
              ),flex: 1,),
            ],
          ));
          break;
        case 5: //已解决
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,//垂直居中
            children: <Widget>[
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('检查记录',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至检查记录界面
                },
              ),flex: 1,),
              verticalLine(),
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('查看结论',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至查看结论界面
                },
              ),flex: 1,),
            ],
          ));
          break;
        case 6: //诊断超时
          widgets.add(horizontalLine());
          widgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,//垂直居中
            children: <Widget>[
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('检查记录',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至检查记录界面
                },
              ),flex: 1,),
              verticalLine(),
              Expanded(child: GestureDetector(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text('查看对话',style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF009999),
                  ),),
                ),
                onTap: (){
                  //TODO 跳转至聊天界面
                },
              ),flex: 1,),
            ],
          ));
          break;
        case 7: //超时，未支付
          break;
      }
    }

    return widgets;
  }

  DateTime? getDateTime(String time) {
    DateTime? dateTime = DateTime.tryParse("${time.substring(0, 19)}");
    return dateTime;
  }

  String getTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return formatDate(
        dateTime!, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }
}
