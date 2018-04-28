import 'package:flutter/material.dart';
import 'theme.dart';
import 'models/contract.dart';
import 'package:flutter/foundation.dart';

// In a standalone version of this app, MaterialPageRoute<T> could be used directly.
class BillingPageRoute<T> extends MaterialPageRoute<T> {
  BillingPageRoute(
      {WidgetBuilder builder, RouteSettings settings: const RouteSettings()})
      : super(builder: builder, settings: settings);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return buildBillingPage(
        context, super.buildPage(context, animation, secondaryAnimation));
  }
}

// Home page route for logged in users.
class HomeRoute extends BillingPageRoute {
  HomeRoute({
    WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
  }) : super(builder: builder, settings: settings);

  static HomeRoute of(BuildContext context) => ModalRoute.of(context);
}

// Login page route for unauthenticated or signed off users.
class LoginRoute extends BillingPageRoute {
  LoginRoute({
    WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
  }) : super(builder: builder, settings: settings);

  static LoginRoute of(BuildContext context) => ModalRoute.of(context);
}

// New enrollment page route.
class NewEnrollmentRoute extends BillingPageRoute {
  NewEnrollmentRoute({
    WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
  }) : super(builder: builder, settings: settings);

  static NewEnrollmentRoute of(BuildContext context) => ModalRoute.of(context);
}

// Invoice page route.
class InvoiceRoute extends BillingPageRoute {
  InvoiceRoute({
    @required this.invoice,
    WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
  })  : assert(invoice != null),
        super(builder: builder, settings: settings);

  InvoiceInfo invoice;

  @override
  InvoiceInfo get currentResult => invoice;

  static NewEnrollmentRoute of(BuildContext context) => ModalRoute.of(context);
}
