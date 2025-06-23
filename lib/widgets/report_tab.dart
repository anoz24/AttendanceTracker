import 'package:flutter/cupertino.dart';

class ReportTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Padding(
          padding: EdgeInsets.only(top:16.0),
          child: Text('Report',
          style: TextStyle(fontSize: 20),),
        ),
      ),
      child: Center(
        child: Text('Report Tab'),
      ),
    );
  }
}