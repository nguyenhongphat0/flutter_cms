import 'package:flutter/cupertino.dart';
import 'package:flutter_cms/models/user.dart';
import 'package:flutter_cms/pages/home.dart';
import 'package:flutter_cms/pages/late.dart';
import 'package:flutter_cms/pages/login.dart';
import 'package:flutter_cms/pages/sumary.dart';
import 'package:provider/provider.dart';

import 'envs/env.dart';

void main() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.dev,
  );
  Environment().initConfig(environment);

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
          theme: const CupertinoThemeData(
            primaryColor: CupertinoColors.systemPink,
          ),
          initialRoute: "/checkin",
          routes: {
            '/': (context) => const HomePage(child: SumaryPage()),
            '/checkin': (context) => const HomePage(child: LatePage()),
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
            return null;
          }),
    );
  }
}
