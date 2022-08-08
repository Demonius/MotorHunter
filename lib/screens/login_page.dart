import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:motor_hunter/base/styles.dart';
import 'package:motor_hunter/constants/dimen_constants.dart';
import 'package:motor_hunter/constants/string_constants.dart';
import 'package:motor_hunter/screens/home_page.dart';

import '../base/widgets.dart';
import '../data/api/rest_api.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  String login = "";
  String password = "";
  final double wightTextField = 250.0;
  final double wightAdditionalBlock = 270.0;

  bool enabledInput = true;
  bool loadingState = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  void _onLoginTextChange(String text) {
    setState(() {
      login = text;
    });
  }

  void _onPasswordTextChange(String text) {
    setState(() {
      password = text;
    });
  }

  void _onSubmitLogin(String text) {
    setState(() {
      password = text;
    });
    _onClickAuthApp();
  }

  void _onClickAuthApp() {
    if (loadingState) {
      return;
    }
    if (login.isEmpty) {
      showErrorSnackBar(context, StringResources.errorEmptyLogin);
      return;
    }
    if (password.isEmpty) {
      showErrorSnackBar(context, StringResources.errorEmptyPassword);
      return;
    }
    setState(() {
      enabledInput = false;
      loadingState = true;
    });
    ApisMock().loginUser(login, password).then((user) {
      print("logged user => $user");
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const HomePage()));
    }).catchError((error) {
      String message;
      if (error is DioError) {
        message = error.message;
      } else {
        message = error.toString();
      }
      showErrorSnackBar(context, message);
      setState(() {
        enabledInput = true;
        loadingState = false;
      });
    });
  }

  void _onRegistrationClick() {
    if (loadingState) {
      return;
    }
    showSnackBar(context, StringResources.functionNotAllowed);
  }

  void _onForgotPasswordClick() {
    if (loadingState) {
      return;
    }
    showSnackBar(context, StringResources.functionNotAllowed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: wightTextField,
              child: TextField(
                onChanged: _onLoginTextChange,
                enabled: enabledInput,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    icon: Icon(Icons.login), hintText: StringResources.textHintLogin, helperText: StringResources.textHelperLogin),
              )),
          SizedBox(
              width: wightTextField,
              child: TextField(
                onChanged: _onPasswordTextChange,
                obscureText: true,
                enabled: enabledInput,
                textInputAction: TextInputAction.done,
                onSubmitted: _onSubmitLogin,
                decoration: const InputDecoration(
                    icon: Icon(Icons.password), hintText: StringResources.textHintPassword, helperText: StringResources.textHelperPassword),
              )),
          SizedBox(
            width: wightTextField,
            child: TextButton(
                style: stylePrimaryButton(wightTextField, DoubleConstants.minButtonHeight),
                onPressed: _onClickAuthApp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(StringResources.textAuthButton),
                    Visibility(
                        visible: loadingState,
                        child: const CupertinoActivityIndicator(
                          color: Colors.white,
                          radius: 8.0,
                        ))
                  ],
                )),
          ),
          SizedBox(
            width: wightAdditionalBlock,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  style: styleSecondaryButton(),
                  onPressed: _onRegistrationClick,
                  child: const Text(StringResources.textRegistrationButton),
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.amber),
                  onPressed: _onForgotPasswordClick,
                  child: const Text(StringResources.textForgotPassword),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
