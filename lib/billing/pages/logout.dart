import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/app_state.dart';
import '../redux/actions.dart';
import '../models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import '../theme.dart';

class LogoutPage extends StatelessWidget {
  final Key key;
  LogoutPage({this.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Container(
          decoration: BoxDecoration(
            color: BillingColors.bodyBg,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Thank you for using Windermere Billing App.'),
                SizedBox(height: 16.0),
                PrimaryButton(
                  text: 'LOG OUT',
                  elevation: highlightElevation,
                  onPressed: vm.onLogout(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final UserModel user;
  final Function(BuildContext context) onLogout;

  _ViewModel({
    @required this.user,
    @required this.onLogout,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      onLogout: (BuildContext context) =>
          () => store.dispatch(LogOutAction(context)),
    );
  }
}
