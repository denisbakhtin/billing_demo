// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/app_state.dart';
import 'package:redux/redux.dart';

class BillingPage extends StatelessWidget {
  BillingPage({
    Key key,
    @required this.scaffoldKey,
    @required this.body,
    this.floatingActionButton,
    this.tabBar,
  })  : assert(body != null),
        assert(scaffoldKey != null),
        super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  final Widget floatingActionButton;
  final Widget tabBar;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PageViewModel>(
      converter: PageViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            brightness: Brightness.light,
            title: Text('Windermere Billing', style: appBarTitleStyle()),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Theme.of(context).iconTheme.color,
                ),
                tooltip: 'Notifications',
                onPressed: null,
              ),
            ],
            bottom: tabBar,
          ),
          floatingActionButton: floatingActionButton,
          body: body,
        );
      },
    );
  }
}

class PageViewModel {
  PageViewModel();

  static PageViewModel fromStore(Store<AppState> store) {
    return PageViewModel();
  }
}
