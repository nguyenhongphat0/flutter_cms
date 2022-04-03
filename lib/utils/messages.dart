import 'package:flutter/cupertino.dart';

void message(BuildContext context, String title, String description) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text(title),
        message: Text(description),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Action'),
            onPressed: () {},
          ),
        ],
      );
    },
  );
}
