import 'app_state.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import '../models/user.dart';
import '../models/enrollment.dart';
import '../utils.dart';

// App state State reducer combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: loadingReducer(state.isLoading, action),
    token: authReducer(state.token, action),
    user: userReducer(state.user, action),
    error: errorReducer(state.error, action),
    enrollments: enrollmentsReducer(state.enrollments, action),
  );
}

//Loading reducers
final loadingReducer = combineReducers<bool>([
  new TypedReducer<bool, StateLoadedAction>(_setLoaded),
  new TypedReducer<bool, LoadUserAction>(_setLoading),
  new TypedReducer<bool, UserLoadedAction>(_setLoaded),
  new TypedReducer<bool, LoadEnrollmentsAction>(_setLoading),
  new TypedReducer<bool, EnrollmentsLoadedAction>(_setLoaded),
  new TypedReducer<bool, ErrorAction>(_setLoaded),
]);

bool _setLoading(bool state, action) {
  return true;
}

bool _setLoaded(bool state, action) {
  return false;
}

//Login reducers
final authReducer = combineReducers<String>([
  new TypedReducer<String, LoggedInAction>(_setToken),
  new TypedReducer<String, StateLoadedAction>(_setToken),
  new TypedReducer<String, LogOutAction>(_clearToken),
]);

String _setToken(String state, action) {
  return action.token;
}

String _clearToken(String state, action) {
  deleteToken();
  return null;
}

final errorReducer = combineReducers<String>([
  new TypedReducer<String, ErrorAction>(_setError),
  new TypedReducer<String, LogInAction>(_clearError),
  new TypedReducer<String, LoadUserAction>(_clearError),
  new TypedReducer<String, LoadEnrollmentsAction>(_clearError),
]);

String _setError(String state, action) {
  return action.error;
}

String _clearError(String state, action) {
  return null;
}

//User reducers
final userReducer = combineReducers<UserModel>([
  new TypedReducer<UserModel, UserLoadedAction>(_setUser),
  new TypedReducer<UserModel, LogOutAction>(_clearUser),
]);

UserModel _setUser(UserModel state, action) {
  return action.user;
}

UserModel _clearUser(UserModel state, action) {
  return null;
}

//Enrollments reducers
final enrollmentsReducer = combineReducers<EnrollmentsModel>([
  new TypedReducer<EnrollmentsModel, EnrollmentsLoadedAction>(_setEnrollments),
]);

EnrollmentsModel _setEnrollments(EnrollmentsModel state, action) {
  return action.enrollments;
}
