import 'package:flutter/material.dart';
typedef _CallBack = void Function();
class ExitBottomDialog extends StatefulWidget {
  final _CallBack callBack;
  ExitBottomDialog({
  super.key,
  required this.callBack,
  });



  @override
  _ExitBottomDialogState createState() {
   return _ExitBottomDialogState();
  }

}

class _ExitBottomDialogState extends State<ExitBottomDialog> {
  _dismissDialog() {
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _dismissDialog,
              child: Container(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: GestureDetector(
                      child: Text(
                        '立即退出',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFE65D4E)),
                      ),
                      onTap: (){
                        _dismissDialog();
                        if(widget.callBack!=null){
                          widget.callBack();
                        }

                      },
                    )),
                Divider(
                  color: Color(0xFFEEEEEE),
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: GestureDetector(
                    child: Text(
                      '取消',
                      style: TextStyle(fontSize: 16, color: Color(0xFF009999)),
                    ),
                    onTap: () {
                      _dismissDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

