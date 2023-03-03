import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';

import 'ExamVisitItem.dart';
import 'OrderItem.dart';
import 'common/view/ExitBottomDialog.dart';
import 'common/view/LoadingDialog.dart';
import 'models/get_paged_exam_visit_for_doctor_input_entity.dart';
import 'models/get_paged_order_response_entity.dart';
import 'models/paged_result_dto_response_entity.dart';

class ExamVisitListPage extends StatefulWidget {

  ExamVisitListPage(this.tabItemStrings);
  final String tabItemStrings;



  @override
  _ExamVisitListPageState createState() {
    return _ExamVisitListPageState();
  }
}

class _ExamVisitListPageState extends State<ExamVisitListPage> {

  ScrollController _scrollController = ScrollController(); //listview 的控制器
  int currentPage = 1;
  static final int MAXRESULTCOUNT = 10;
  /// 页面是否正在加载
  bool isLoading=false;
  List<PagedResultDtoResponseItems> _items=[];
  int totalCount=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (!this.isLoading&&this._scrollController.position.pixels >=
          this._scrollController.position.maxScrollExtent) {
        setState(() {
          print('滑动到了最底部');
          print('totalCount:$totalCount');
          print(_items.length);
          if(totalCount>_items.length){
            this.isLoading=true;
            getPagedExamVisitForDoctor();
          }
        });


      }
    });
    refreshData();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this._scrollController.dispose();
  }

  void refreshData() {
      setState(() {
      _items=[];
      currentPage=1;
      getPagedExamVisitForDoctor();
    });
  }
  //处理刷新操作
  Future onRefresh(){
    return Future.delayed(Duration(microseconds: 500),(){
      refreshData();

    });
  }




  @override
  Widget build(BuildContext context) {
    return  _items.length==0?_getEmptyWidget():_buildBody();
  }
  Widget _buildBody() {
      //已登录，则显示项目列表
      return RefreshIndicator(child: ListView.separated(
        itemCount: _items.length+1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          //显示列表项
          if(index<_items.length){
            return ExamVisitItemPage(examVisitItem:_items[index],refreshDataCallBack:refreshData,);
          }else{
            return renderBottom();
          }

        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ), onRefresh: onRefresh);
    }

  /**
   * 空视图,给用户提示
   */
  Widget _getEmptyWidget() {
    return GestureDetector(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '目前还没有申请\n点击刷新',
                style: TextStyle(fontSize: 14.0, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        refreshData();

      },
    );
  }
  Widget renderBottom() {
    if(this.isLoading) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '努力加载中...',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          '没有更多数据',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
      );
    }
  }

  void getPagedExamVisitForDoctor () async{
    GetPagedExamVisitForDoctorInputEntity  _pagedExamVisitForDoctorInputEntity=GetPagedExamVisitForDoctorInputEntity();
    _pagedExamVisitForDoctorInputEntity.maxResultCount=MAXRESULTCOUNT;
    _pagedExamVisitForDoctorInputEntity.skipCount=(currentPage - 1) * MAXRESULTCOUNT;
    switch(widget.tabItemStrings){
      case '已申请':
        _pagedExamVisitForDoctorInputEntity.examVisitStatus=1;
        break;
      case '已同意':
        _pagedExamVisitForDoctorInputEntity.examVisitStatus=4;
        break;
      case '已诊断':
        _pagedExamVisitForDoctorInputEntity.examVisitStatus=5;
        break;
      case '全部':
      //examVisitStatus不传
      //   _pagedExamVisitForDoctorInputEntity.examVisitStatus=null;
        break;
    }

    Future<PagedResultDtoResponseEntity> data=NetWorkWithToken(context).getPagedExamVisitForDoctor(_pagedExamVisitForDoctorInputEntity);
    data.then((value) {
      setState(() {
        print(value.totalCount);
        totalCount=value.totalCount!;
        print(value.toJson());
        this.isLoading = false;
        //如果返回的数据小于指定的条数，则表示没有更多数据，反之，则否
        //hasMore=data.totalCount>0&&data.items.length%10==0;
        //把请求到的新数据添加到items中
        _items.insertAll(_items.length, value.items!);
        print(_items.length);
        currentPage++;
      });
    });
  }

}
