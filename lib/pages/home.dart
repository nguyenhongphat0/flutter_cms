import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cms/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/messages.dart';

class HomePage extends StatefulWidget {
  final Widget? child;

  const HomePage({
    Key? key,
    this.child,
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
                          return const CupertinoActivityIndicator();
                        }
                      },
                    ),
                  ),
                  Column(
                    children: const [
                      MenuItem(
                          path: '/',
                          title: 'Trang chủ',
                          icon: CupertinoIcons.money_dollar_circle),
                      MenuItem(
                          path: '/checkin',
                          title: 'Điểm danh',
                          icon: CupertinoIcons.table),
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
            child: widget.child,
          ),
        ),
      ],
    ));
  }
}

class MenuItem extends StatelessWidget {
  final String path;
  final String title;
  final IconData icon;
  const MenuItem({
    Key? key,
    required this.path,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: CupertinoButton(
        color: ModalRoute.of(context)!.settings.name == path
            ? CupertinoTheme.of(context).primaryColor
            : null,
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Icon(icon),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(path);
        },
      ),
    );
  }
}
