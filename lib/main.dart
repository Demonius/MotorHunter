import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:motor_hunter/managers/shared_pref_manager.dart';
import 'package:motor_hunter/screens/home_page.dart';
import 'package:motor_hunter/screens/login_page.dart';

import 'constants/string_constants.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: StringResources.appName, theme: ThemeData(primarySwatch: Colors.orange, primaryColor: Colors.orange), home: const StartPage());
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  late Future<bool> stateAuth;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    stateAuth = SharedPrefManager().getStateAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: stateAuth,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data == true) {
          return const HomePage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
