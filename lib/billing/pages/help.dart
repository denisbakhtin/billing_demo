import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme.dart';

class HelpPage extends StatelessWidget {
  final Key key;
  HelpPage({this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: BillingColors.bodyBg,
      ),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Windermere Group Benefits Portal',
              style: pageTitleStyle(),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
              'Welcome to Rehn and Associates (Rehn). We appreciate the opportunity to provide employee benefit services for you and your employees. This guide will provide you an outline of the documentation and information necessary to implement your benefits with Rehn.',
              style: regularTextStyle()),
          SizedBox(height: 8.0),
          Text(
              'The Windermere Group Benefits Portal will integrate enrollment and benefit management for Windermere’s Broker/Owner groups. Users can quickly and easily access and enroll in their group’s benefits from one place, online, anytime. This makes the entire process more manageable and results in streamlined processes and efficiencies gained.',
              style: regularTextStyle()),
          SizedBox(height: 8.0),
          Text(
              'You’re managing your group’s benefits in real time. If an employee leaves the company today, you can terminate their benefits today.',
              style: regularTextStyle()),
          SizedBox(height: 8.0),
          Text(
              'If you hire someone and benefits go into effect immediately, you can add them as a new hire today and they will be enrolled in the group.',
              style: regularTextStyle()),
          SizedBox(height: 8.0),
          Text(
              'One person from your company will be set up as the primary contact and they will be responsible for administering your group’s benefits. For example, if you want someone from Accounting to have access to the Enrollment Maintenance and Billing, you can set them up as primary contact...',
              style: regularTextStyle()),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
