import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cms/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("accessToken");
    if (accessToken != null) {
      print('Loading user');
      final Future<ZaloUser> userFuture = http.get(
        Uri.parse('https://graph.zalo.me/v2.0/me?fields=id%2Cname%2Cpicture'),
        headers: {'access_token': accessToken},
      ).then((response) {
        try {
          if (response.statusCode == 200) {
            return ZaloUser.fromJson(jsonDecode(response.body));
          } else {
            throw Exception('Failed to load album');
          }
        } catch (e) {
          message(
              context,
              'Đã có lỗi xảy ra trong quá trình đăng nhập, vui lòng thử lại sau!',
              'Chi tiết lỗi: ' + e.toString());
          return Future.error(e);
        }
      });
      Provider.of<UserModel>(context, listen: false).newFuture(userFuture);
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

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
              alignment: Alignment.bottomRight,
              repeat: ImageRepeat.repeat,
              opacity: 0.1,
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
          child: Consumer<UserModel>(
            builder: (context, user, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FutureBuilder<ZaloUser>(
                      future: user.future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data!.picture.data.url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 140,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'ID: ' + snapshot.data!.id,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.inactiveGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return CupertinoActivityIndicator();
                        }
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
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
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            },
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
                    child: const Text('Chọn ngày'),
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
