import 'package:flutter/cupertino.dart';
import 'package:flutter_cms/models/user.dart';
import 'package:flutter_cms/pages/home.dart';
import 'package:flutter_cms/pages/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => UserModel()),
      child: CupertinoApp(
          title: 'ZStudio Checkin CMS',
          initialRoute: "/",
          routes: {
            '/': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
          },
          onGenerateRoute: (settings) {
            final name = settings.name ?? '';
            // If you push the PassArguments route
            if (name.startsWith('/login')) {
              final settingsUri = Uri.parse(name);
              final code = settingsUri.queryParameters['code'];
              return CupertinoPageRoute(builder: (context) {
                return LoginPage(
                  code: code,
                );
              });
            }
          }),
    );
  }
}
