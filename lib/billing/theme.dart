import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:intl/intl.dart';

Widget buildBillingPage(BuildContext context, Widget child) {
  return new Theme(
    data: new ThemeData(
      primaryColor: BillingColors.primaryColor,
      accentColor: BillingColors.secondaryColor,
      iconTheme: const IconThemeData(color: const Color(0xAAFFFFFF)),
      platform: Theme.of(context).platform,
    ),
    child: child,
  );
}

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the Billing app.
class BillingColors {
  static const Color bodyBg = Color(0xFFEFEFEF);
  static const Color primaryColor = Color(0xFF283593);
  static const Color secondaryColor = Color(0xFF00838f);
  static const Color textColor = Color(0xFF424242);
  static const Color listItemColor = Color(0xFF757575);
  static const Color dangerColor = Color(0xFFF44336);

  static const Color cardBackgroundColor = Colors.white;
  static const Color appBarBorderColor = Color(0xFFAB47BC);
  static const Color dividerColor = Color(0xFFE0E0E0);
}

const double highlightElevation = 4.0;

//Text styles
TextStyle sansRegular12(Color color) =>
    new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: color);
TextStyle sansLight12(Color color) =>
    new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: color);
TextStyle sansRegular14(Color color) =>
    new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: color);
TextStyle sansSemibold14(Color color) =>
    new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: color);
TextStyle sansLight14(Color color) =>
    new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: color);
TextStyle sansRegular16(Color color) =>
    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: color);
TextStyle sansRegular18(Color color) =>
    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: color);
TextStyle sansRegular20(Color color) =>
    new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: color);
TextStyle sansRegular24(Color color) =>
    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: color);
TextStyle sansRegular34(Color color) =>
    new TextStyle(fontSize: 34.0, fontWeight: FontWeight.w500, color: color);

TextStyle pageTitleStyle() => sansRegular18(BillingColors.secondaryColor);
TextStyle pageSubtitleStyle() => sansRegular16(BillingColors.textColor);
TextStyle regularTextStyle() => sansRegular14(BillingColors.textColor);
TextStyle appBarTitleStyle() => sansRegular20(Colors.white70);

//Input decorations
InputDecoration highlightInputDecoration(String hint,
        [IconData iconData, void Function() onClear]) =>
    InputDecoration(
      hintText: hint,
      hintStyle: new TextStyle(color: Colors.grey.shade400),
      border: InputBorder.none,
      contentPadding: new EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          bottom: 10.0,
          right: onClear != null ? 0.0 : 10.0),
      prefixIcon: iconData != null
          ? new Padding(
              padding: const EdgeInsetsDirectional.only(end: 16.0),
              child: new Icon(
                iconData,
                color: BillingColors.secondaryColor.withOpacity(0.8),
              ),
            )
          : null,
      suffixIcon: onClear != null
          ? new IconButton(
              onPressed: onClear,
              iconSize: 16.0,
              icon: new Icon(Icons.clear),
            )
          : null,
    );

InputDecoration labelDecoration(String label) => new InputDecoration(
    labelText: label, labelStyle: sansLight14(BillingColors.secondaryColor));

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {this.elevation = 0.0, @required this.text, @required this.onPressed});

  final double elevation;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      elevation: elevation,
      child: new Text(
        text,
        style: new TextStyle(color: Colors.grey.shade100),
      ),
      color: BillingColors.primaryColor,
      onPressed: onPressed,
    );
  }
}

class PrimaryFlatButton extends StatelessWidget {
  PrimaryFlatButton({@required this.text, @required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(
        text,
        style: new TextStyle(color: BillingColors.primaryColor),
      ),
      onPressed: onPressed,
    );
  }
}

class SecondaryFlatButton extends StatelessWidget {
  SecondaryFlatButton({@required this.text, @required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(
        text,
        style: new TextStyle(color: BillingColors.secondaryColor),
      ),
      onPressed: onPressed,
    );
  }
}

Widget showSpinner() {
  return new Container(
    decoration: new BoxDecoration(color: BillingColors.bodyBg),
    child: new Center(child: new CircularProgressIndicator()),
  );
}

void showSnackbar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(text)));
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.selectedDate,
    this.selectDate,
    this.labelText,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final String labelText;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = sansRegular14(BillingColors.secondaryColor);
    return new _InputDropdown(
      labelText: labelText,
      valueText: new DateFormat.yMMMd().format(selectedDate),
      valueStyle: valueStyle,
      onPressed: () {
        _selectDate(context);
      },
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: labelDecoration(labelText),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
