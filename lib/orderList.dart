import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doctor_app/common/LoginPrefs.dart';
import 'package:flutter_doctor_app/common/net/NetWorkWithToken.dart';

import 'OrderItem.dart';
import 'common/view/ExitBottomDialog.dart';
import 'common/view/LoadingDialog.dart';
import 'models/get_paged_order_response_entity.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() {
    return _OrderListPageState();
  }
}

class _OrderListPageState extends State<OrderListPage> {

  ScrollController _scrollController = ScrollController(); //listview 的控制器
  int currentPage = 1;
  static final int MAXRESULTCOUNT = 10;
  /// 页面是否正在加载
  bool isLoading=false;
  List<GetPagedOrderResponseItems> _items=[];
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
          if(totalCount>_items.length){
            this.isLoading=true;
            _getOrderList();
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
      _getOrderList();
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 15.0, //标题距离左边大小
          title: Text(
            "订单列表",
            style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
          ),
          leading: IconButton(
              icon: Image.asset(
                'assets/images/nav_icon_back.png',
                width: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          //状态栏字体为白色
          elevation: 0.0,
        ),
        body: _items.length==0?_getEmptyWidget():_buildBody());
  }
  Widget _buildBody() {
      //已登录，则显示项目列表
      return RefreshIndicator(child: ListView.separated(
        itemCount: _items.length+1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          //显示订单列表项
          if(index<_items.length){
            return OrderItemPage(_items[index]);
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
                '目前还没有订单\n点击刷新',
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
  void _getOrderList() async {
    Future <GetPagedOrderResponseEntity> data = NetWorkWithToken(context)
        .getPagedOrdersByCurrentDoctor(queryParameters: {
      'MaxResultCount': MAXRESULTCOUNT,
      'SkipCount': (currentPage - 1) * MAXRESULTCOUNT
    },);
    data.then((value) {
      print(value.toJson());
      totalCount=value.totalCount;
      print(_items.length);
      setState(() {
        this.isLoading = false;
        //如果返回的数据小于指定的条数，则表示没有更多数据，反之，则否
        //hasMore=data.totalCount>0&&data.items.length%10==0;
        //把请求到的新数据添加到items中
          _items.insertAll(_items.length, value.items);
          print(_items.length);
          currentPage++;

      });
    });
  }

}
