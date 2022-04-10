import 'package:flutter/cupertino.dart';

class LatePage extends StatelessWidget {
  const LatePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Quản lý điểm danh',
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoSlidingSegmentedControl(
              children: const {
                0: Text('Hôm nay'),
                1: Text('Hôm qua'),
                2: Text('Tự chọn'),
              },
              onValueChanged: (value) {},
              groupValue: 0,
            ),
            CupertinoButton(
                child: const Text('Chọn ngày'),
                onPressed: () {
                  showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => Container(
                            height: 216,
                            padding: const EdgeInsets.only(top: 6.0),
                            // The Bottom margin is provided to align the popup above the system navigation bar.
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            // Provide a background color for the popup.
                            color: CupertinoColors.systemBackground
                                .resolveFrom(context),
                            // Use a SafeArea widget to avoid system overlaps.
                            child: SafeArea(
                              top: false,
                              child: CupertinoDatePicker(
                                // This is called when the user changes the time.
                                onDateTimeChanged: (DateTime newTime) {},
                              ),
                            ),
                          ));
                }),
          ],
        ),
      ],
    );
  }
}
