import 'package:flutter/material.dart';
import '../utils.dart';

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/app_state.dart';
import '../theme.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import '../redux/actions.dart';

class LoginPage extends StatelessWidget {
  LoginPage();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: vm.loading ? showSpinner() : _Body(vm),
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  _Body(this.vm);
  final _ViewModel vm;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  TextEditingController _userIDController;
  TextEditingController _passwordController;

  @override
  void dispose() {
    _userIDController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userIDController = TextEditingController(text: 'valery@rehnonline.com');
    _passwordController = TextEditingController(text: 'Well1024');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth = min(screenSize.height, screenSize.width);
    bool isLandscape = screenSize.width > screenSize.height;
    return Container(
      decoration: BoxDecoration(
        color: BillingColors.bodyBg,
      ),
      child: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Image.asset(
                "images/logo.png",
                width: maxWidth / 2.5,
              ),
            ),
            SizedBox(height: 8.0),
            isLandscape
                ? null
                : Center(
                    child: Text('Windermere Billing',
                        style: sansRegular16(BillingColors.secondaryColor))),
            isLandscape ? null : SizedBox(height: isLandscape ? 16.0 : 42.0),
            Container(
              width: maxWidth / 2.5,
              child: Material(
                elevation: highlightElevation,
                child: TextField(
                  controller: _userIDController,
                  decoration:
                      highlightInputDecoration('User ID', Icons.account_circle),
                  onSubmitted: (value) => 1 + 1,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Material(
              elevation: highlightElevation,
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: highlightInputDecoration('Password', Icons.vpn_key),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'remember me',
                    style: TextStyle(color: BillingColors.secondaryColor),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) => 1 + 1,
                ),
              ],
            ),
            (widget.vm.loginError != null)
                ? Center(
                    child: Text(
                      widget.vm.loginError,
                      style: TextStyle(color: BillingColors.dangerColor),
                    ),
                  )
                : null,
            SizedBox(height: isLandscape ? 8.0 : 24.0),
            Center(
              child: PrimaryButton(
                text: 'SIGN IN',
                elevation: highlightElevation,
                onPressed: () {
                  if (_userIDController.text.isEmpty) {
                    showSnackbar(context, 'User ID is required');
                    return;
                  }
                  if (_passwordController.text.isEmpty) {
                    showSnackbar(context, 'Password is required');
                    return;
                  }
                  widget.vm.onSignin(_userIDController.text,
                      _passwordController.text, context);
                },
              ),
            ),
            SizedBox(height: isLandscape ? 16.0 : 36.0),
            Center(
              child: SecondaryFlatButton(
                text: 'FORGOT PASSWORD',
                onPressed: () => showSnackbar(context, notImplemented),
              ),
            ),
          ].where(notNull).toList(),
        ),
      ),
    );
  }
}

class _ViewModel {
  final bool loading;
  final Function(String userID, String password, BuildContext context) onSignin;
  final String loginError;

  _ViewModel({
    @required this.loading,
    @required this.onSignin,
    @required this.loginError,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loading: store.state.isLoading,
      onSignin: (userID, password, context) =>
          store.dispatch(LogInAction(userID, password, context)),
      loginError: store.state.error,
    );
  }
}
