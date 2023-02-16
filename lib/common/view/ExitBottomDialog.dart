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
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {
                          _dismissDialog();
                          if (widget.callBack != null) {
                            widget.callBack();
                          }
                        },
                        child: Text(
                          '立即退出',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFE65D4E)),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0)),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                      height: 50,
                    ),
                    flex: 1,
                  )
                ],
              ),
              Divider(
                color: Color(0xFFEEEEEE),
                height: 0.5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () => _dismissDialog(),
                        child: Text(
                          '取消',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF009999)),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.zero),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                      height: 50,
                    ),
                    flex: 1,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
