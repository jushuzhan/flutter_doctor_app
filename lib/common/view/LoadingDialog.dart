

import 'package:flutter/material.dart';

class LoadingDialog{
  final BuildContext buildContext;
  LoadingDialog({
   required this.buildContext,
  });
  showLoading(){
    return showDialog(context: buildContext, builder: (buildContext){
      return WillPopScope(child: UnconstrainedBox(
        constrainedAxis: Axis.vertical,
        child: SizedBox(
          width: 200,
          child: AlertDialog(
            backgroundColor: Color(0xFF88000000),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10),child:  CircularProgressIndicator(backgroundColor: Color(0x55c6c6c6),),),
                Padding(padding: EdgeInsets.only(top: 5),child: Text("加载中...",style: TextStyle(
                    color:Color(0xFF9a9b98),
                    fontSize: 12
                ),),),
              ],
            ),
          ),
        ),
      ), onWillPop: (){
        return new Future.value(false);
      });
    }, barrierDismissible: false);
  }

}