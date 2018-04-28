import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/app_state.dart';
import '../models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import '../theme.dart';
import '../utils.dart';
import '../service.dart';

List<DropdownMenuItem<String>> subjects = [
  DropdownMenuItem<String>(
      value: 'Customer Support', child: Text('Customer Support')),
  DropdownMenuItem<String>(
      value: 'Technical Issued', child: Text('Technical Issues')),
  DropdownMenuItem<String>(value: 'Other', child: Text('Other')),
];

class ContactUsPage extends StatefulWidget {
  final Key key;
  ContactUsPage({this.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController _messageController;
  String subject;

  @override
  void initState() {
    super.initState();
    subject = 'Customer Support';
    _messageController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: BillingColors.bodyBg,
          ),
          child: vm.loading
              ? showSpinner()
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    Center(child: Text('Contact Us', style: pageTitleStyle())),
                    SizedBox(height: 16.0),
                    Text('ADDRESS',
                        style: sansRegular14(BillingColors.secondaryColor)),
                    SizedBox(height: 8.0),
                    Text('Rehn & Associates, Inc.',
                        style: sansRegular14(BillingColors.textColor)),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.mail),
                        SizedBox(width: 8.0),
                        Text('PO Box 5433, Spokane WA 99205'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.location_city),
                        SizedBox(width: 8.0),
                        Text('1322 N Post Street, Spokane WA 99201'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text('HOURS OF OPERATION (PACIFIC TIME)',
                        style: sansRegular14(BillingColors.secondaryColor)),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.access_time),
                        SizedBox(width: 8.0),
                        Text(
                            'Monday - Thursday 8:00am - 5:00pm,\nFriday 8:00am - 4:00pm'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text('PHONES',
                        style: sansRegular14(BillingColors.secondaryColor)),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.phone),
                        SizedBox(width: 8.0),
                        Text('(509) 534-0600'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.settings_phone),
                        SizedBox(width: 8.0),
                        Text('(509) 535-7883 (fax)'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.phone_in_talk),
                        SizedBox(width: 8.0),
                        Text('(800) 872-8979, ext. 780 (toll free)'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text('E-MAIL',
                        style: sansRegular14(BillingColors.secondaryColor)),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        _addressIcon(Icons.alternate_email),
                        SizedBox(width: 8.0),
                        Text('rehn@rehnonline.com'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text('Send us your message',
                        style: sansRegular16(BillingColors.secondaryColor)),
                    Row(
                      children: <Widget>[
                        DropdownButton<String>(
                          value: subject,
                          items: <String>[
                            'Customer Support',
                            'Technical Issues',
                            'Other'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => subject = value),
                        ),
                      ],
                    ),
                    Material(
                      elevation: 0.0,
                      child: TextField(
                        controller: _messageController,
                        maxLines: 7,
                        decoration: null,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        PrimaryButton(
                          text: 'SEND',
                          elevation: highlightElevation,
                          onPressed: () {
                            if (_messageController.text.isEmpty) {
                              showSnackbar(context, 'The message is required.');
                              return;
                            }
                            showSnackbar(context, notImplemented);
                            vm.onSendMessage(subject, _messageController.text);
                            _messageController.clear();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
        );
      },
    );
  }
}

Icon _addressIcon(IconData icon) {
  return Icon(
    icon,
    color: BillingColors.secondaryColor,
    size: 18.0,
  );
}

class _ViewModel {
  final bool loading;
  final UserModel user;
  final Function(String subject, String text) onSendMessage;

  _ViewModel({
    @required this.loading,
    @required this.user,
    @required this.onSendMessage,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loading: store.state.isLoading,
      user: store.state.user,
      onSendMessage: WindermereService.sendMessageToSupport,
    );
  }
}
