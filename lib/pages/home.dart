import 'package:flutter/cupertino.dart';
import 'package:flutter_cms/utils/messages.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Row(
      children: [
        Container(
          width: 240,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: CupertinoColors.extraLightBackgroundGray,
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'ZStudio Checkin',
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                  Text(
                    'CMS',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: CupertinoButton(
                      color: CupertinoColors.systemBlue,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Điểm danh'),
                          Icon(CupertinoIcons.table),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Tiền phạt'),
                          Icon(CupertinoIcons.money_dollar_circle),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              CupertinoButton(
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.back),
                    Text('Đăng xuất'),
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text('Quản lý điểm danh',
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle),
                CupertinoButton(
                    child: Text('Chọn ngày'),
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) => Container(
                                height: 216,
                                padding: const EdgeInsets.only(top: 6.0),
                                // The Bottom margin is provided to align the popup above the system navigation bar.
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
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
          ),
        ),
      ],
    ));
  }
}
