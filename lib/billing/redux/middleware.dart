import 'package:redux/redux.dart';
import 'app_state.dart';
import 'actions.dart';
import '../service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../routes.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import '../utils.dart';

const String connectionError = 'Error connecting to web service';

loadInitialMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  if (action is LoadInitialStateAction) {
    String token = await getToken();
    store.dispatch(new StateLoadedAction(token));
    if (token != null) store.dispatch(new LoadUserAction());
  }

  if (action is LogInAction) {
    WindermereService.login(action.userID, action.password).then((token) {
      store.dispatch(new LoggedInAction(json.decode(token)));

      Navigator.pushReplacement(
        action.context,
        new HomeRoute(builder: (BuildContext context) {
          return new HomePage();
        }),
      );
    }).catchError((error) => store.dispatch(new ErrorAction(error.toString())));
  }

  if (action is LoggedInAction) {
    storeToken(action.token);
  }

  if (action is LoadUserAction) {
    WindermereService
        .getActiveUser(store.state.token)
        .then((model) => store.dispatch(new UserLoadedAction(model)))
        .catchError(
            (error) => store.dispatch(new ErrorAction(error.toString())));
  }

  if (action is LoadEnrollmentsAction) {
    WindermereService
        .getEnrollments(store.state.token)
        .then((model) => store.dispatch(new EnrollmentsLoadedAction(model)))
        .catchError(
            (error) => store.dispatch(new ErrorAction(error.toString())));
  }

  next(action);
  //after action has been processed

  //to make sure token has been stored by LoggedInAction
  if (action is LoggedInAction) {
    store.dispatch(new LoadUserAction());
  }

  if (action is LogOutAction) {
    Navigator.pushReplacement(
      action.context,
      new LoginRoute(builder: (BuildContext context) {
        return new LoginPage();
      }),
    );
  }
}
