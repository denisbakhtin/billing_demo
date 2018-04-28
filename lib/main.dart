import 'package:flutter/material.dart';
import 'billing/theme.dart';
import 'billing/pages/login.dart';
import 'billing/pages/home.dart';
import 'billing/redux/app_state.dart';
import 'billing/redux/middleware.dart';
import 'billing/redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'billing/redux/actions.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class BillingDemo extends StatelessWidget {
  BillingDemo(this.store);
  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Windermere Billing Demo',
        theme: new ThemeData(fontFamily: 'OpenSans'),
        home: new StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(new LoadInitialStateAction()),
          builder: (context, store) => buildBillingPage(
                context,
                //TODO: check JWT token expire date and validity??
                store.state.token != null ? new HomePage() : new LoginPage(),
              ),
        ),
      ),
    );
  }
}

void main() {
  initFirebase();

  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState.loading(),
    middleware: [loadInitialMiddleware],
  );
  runApp(new BillingDemo(store));
}

void initFirebase() {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) {
      LocalNotifications.createNotification(
          title: "New invoice", content: message['billingMonth'], id: 0);
    },
    onLaunch: (Map<String, dynamic> message) {
      //todo: navigate to invoices tab
    },
    onResume: (Map<String, dynamic> message) {
      //todo: navigate to invoices tab
    },
  );
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  _firebaseMessaging.getToken().then((_) {
    _firebaseMessaging.subscribeToTopic('invoices');
  });
}
