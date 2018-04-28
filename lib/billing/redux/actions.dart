import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/enrollment.dart';

//================== loading actions
class LoadInitialStateAction {}

class StateLoadedAction {
  final String token;
  StateLoadedAction(this.token);
}

//================== auth actions
class LogInAction {
  final String userID;
  final String password;
  final BuildContext context; //required for navigation
  LogInAction(this.userID, this.password, this.context);
}

class LoggedInAction {
  final String token;
  LoggedInAction(this.token);
}

class LogOutAction {
  final BuildContext context;
  LogOutAction(this.context);
}

//================== error actions
class ErrorAction {
  final String error;
  ErrorAction(this.error);
}

//================== user actions
class LoadUserAction {}

class UserLoadedAction {
  final UserModel user;
  UserLoadedAction(this.user);
}

//================== enrollment actions
class LoadEnrollmentsAction {}

class EnrollmentsLoadedAction {
  final EnrollmentsModel enrollments;
  EnrollmentsLoadedAction(this.enrollments);
}
