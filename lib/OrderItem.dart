import 'package:flutter/material.dart';

import 'models/get_paged_order_response_entity.dart';
import 'package:date_format/date_format.dart';

class OrderItemPage extends StatefulWidget {
  OrderItemPage(this.orderItem) : super(key: ValueKey(orderItem.order.orderNumber));

  final GetPagedOrderResponseItems orderItem;

  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  final TextStyle grey12TextStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF999999),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(top: 8, left: 15, right: 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          //第一行
          Row(
            children: <Widget>[
              Container(
                height: 20,
                width: 2,
                decoration: BoxDecoration(
                    color: Color(0xFF009999),
                    borderRadius: BorderRadius.all(Radius.circular(1))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '就诊人',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  widget.orderItem.visit.patientName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                widget.orderItem.order.statusRemark,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          //第二行
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                Text('支付方式', style: grey12TextStyle),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    widget.orderItem.order.tradeTypeRemark,
                    style: grey12TextStyle,
                  ),
                )
              ],
            ),
          ),
          //第三行
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                Text('支付金额', style: grey12TextStyle),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    '¥' +
                        (widget.orderItem.order.payMoney.toDouble() / 100)
                            .toStringAsFixed(2),
                    style: grey12TextStyle,
                  ),
                )
              ],
            ),
          ),
          //第四行
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                Text('订单编号', style: grey12TextStyle),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    widget.orderItem.order.orderNumber,
                    style: grey12TextStyle,
                  ),
                )
              ],
            ),
          ),
          //第五行
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Text('下单时间', style: grey12TextStyle),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    getTime(getDateTime(widget.orderItem.order.creationTime)),
                    //widget.orderItem.order.creationTime,
                    style: grey12TextStyle,
                  ),
                )
              ],
            ),
          ),
          //第七行动态创建布局
          Column(
            children: _buildList(),
          ),
          //第六行 展开/折叠检查项
         GestureDetector(
           onTap: (){
             setState(() {
               widget.orderItem.isExpanded=!widget.orderItem.isExpanded;
             });
           },
           child: FractionallySizedBox(
             widthFactor: 1,
             child: Container(
               height: 40,
               alignment: Alignment.center,
               decoration: BoxDecoration(
                   border: Border(
                       top: BorderSide(
                           color: Color(0xFFEEEEEE),
                           width: 1
                       )
                   )
               ),
               child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     Text(
                       widget.orderItem.isExpanded?'收起检查项':'展开检查项',
                       style: grey12TextStyle,
                     ),
                     Image(
                         image: AssetImage(widget.orderItem.isExpanded?'assets/images/order_list_unfold.png':'assets/images/order_list_fold.png'))
                   ],
                 ),
             ),
           ),
         ) ,

        ],
      ),
    );
  }
  /// 创建列表 , 每个元素都是一个 ExpansionTile 组件
  List<Widget> _buildList(){
    List<Widget> widgets = [];

    if(widget.orderItem.isExpanded){
      widget.orderItem.checkItems.forEach((key) {
        widgets.add(_generateWidget(key));
      });
    }
    return widgets;
  }


  /// ListView 的单个组件
  Widget _generateWidget(GetPagedOrderResponseItemsCheckItems checkItems) {
    /// 使用该组件可以使宽度撑满
    return FractionallySizedBox(
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                checkItems.examinationTypeRemark,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
              flex: 1,
            ),
            Text(
              '×1',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
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
