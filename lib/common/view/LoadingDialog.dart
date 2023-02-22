

import 'package:flutter/material.dart';

class LoadingDialog{
  final BuildContext buildContext;
  LoadingDialog({
   required this.buildContext,
  });


  showLoading(){
    return showDialog(context: buildContext, builder: (buildContext){
      return UnconstrainedBox(
        constrainedAxis: Axis.vertical,
        child: SizedBox(
          width: 280,
          child: AlertDialog(
            backgroundColor: Color(0xFF88000000),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(value: .8,),
                Padding(padding: EdgeInsets.only(top: 26.0),child: Text("正在加载，请稍后..."),),
              ],
            ),
          ),
        ),
      );
    });
  }

}