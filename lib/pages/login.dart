import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cms/envs/env.dart';
import 'package:flutter_cms/utils/messages.dart';
import 'package:pkce/pkce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final String? code;
  const LoginPage({Key? key, this.code}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    if (widget.code != null) {
      final prefs = await SharedPreferences.getInstance();
      final verifier = prefs.getString("verifier");
      final response = await http.post(
          Uri.parse("https://oauth.zaloapp.com/v4/access_token"),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'secret_key': Environment().config.appSecret
          },
          body: {
            'app_id': Environment().config.appId,
            'code': widget.code,
            'grant_type': 'authorization_code',
            'code_verifier': verifier,
          });
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['error'] != null) {
        message(
            context,
            'Đã có lỗi xảy ra trong quá trình đăng nhập, vui lòng thử lại sau!',
            'Chi tiết lỗi: ' + data['error_description']);
      } else {
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("accessToken", accessToken);
        prefs.setString("refreshToken", refreshToken);

        Navigator.of(context).pushReplacementNamed('/');
        message(context, 'Đăng nhập thành công!',
            'Chúc bạn có một ngày làm việc vui vẻ!');
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("accessToken");
      final refreshToken = prefs.getString("refreshToken");
      if (accessToken != null && refreshToken != null) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  Future<void> login(BuildContext context) async {
    final pkcePair = PkcePair.generate(length: 43);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("verifier", pkcePair.codeVerifier);
    final origin = Uri.base;
    final state = Uri.encodeFull(jsonEncode({
      "origin": origin.toString().replaceAll('#', '%23'),
    }));
    final appId = Environment().config.appId;
    final redirectUrl = Environment().config.redirectUrl;
    final url =
        "https://oauth.zaloapp.com/v4/permission?app_id=$appId&redirect_uri=$redirectUrl&code_challenge=${pkcePair.codeChallenge}&state=$state";
    if (await canLaunch(url)) {
      await launch(url, webOnlyWindowName: "_self");
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            repeat: ImageRepeat.repeat,
            opacity: 0.5,
          ),
        ),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.all(Radius.circular(60)),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.inactiveGray,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Welcome back to"),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text("ZStudio Checkin CMS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                  ),
                  CupertinoButton(
                    child: const Text('Login with Zalo'),
                    color: CupertinoColors.systemBlue,
                    onPressed: () {
                      login(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
