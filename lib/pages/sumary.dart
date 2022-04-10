import 'package:flutter/cupertino.dart';

class SumaryPage extends StatelessWidget {
  const SumaryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Chào mừng bạn đến với',
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        Text('ZStudio Checkin CMS',
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
        ClipRRect(
            child: Image.asset('images/logo.png', width: 100, height: 100),
            borderRadius: BorderRadius.circular(100)),
      ],
    );
  }
}
