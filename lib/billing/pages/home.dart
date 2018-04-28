import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'enrollments.dart';
import 'new_enrollment.dart';
import 'invoices.dart';
import 'contactus.dart';
import 'help.dart';
import 'logout.dart';
import '../theme.dart';
import '../routes.dart';
import 'billing_page.dart';
import '../service.dart';
import '../utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'Tabbed Home Page');
  TabController _controller;
  BillingTab _selectedTab;
  List<BillingTab> _billingTabs;

  @override
  void initState() {
    super.initState();
    _billingTabs = buildTabs();
    _controller = TabController(vsync: this, length: _billingTabs.length);
    _controller.addListener(_handleTabSelection);
    _selectedTab = _billingTabs[0];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTab = _billingTabs[_controller.index];
    });
  }

  Widget _buildFab(BuildContext context, BillingTab billingTab) {
    if (billingTab.fabIcon == null || billingTab.onFabTap == null) return null;

    return FloatingActionButton(
      key: ValueKey(billingTab.title),
      backgroundColor: BillingColors.primaryColor,
      child: Icon(billingTab.fabIcon),
      onPressed: billingTab.onFabTap(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BillingPage(
      scaffoldKey: _scaffoldKey,
      tabBar: TabBar(
        isScrollable: true,
        controller: _controller,
        tabs: _billingTabs.map((billingTab) {
          return Tab(
            text: billingTab.title,
            icon: Icon(billingTab.icon),
          );
        }).toList(),
      ),
      floatingActionButton: _buildFab(context, _selectedTab),
      body: Container(
        decoration: BoxDecoration(
          color: BillingColors.bodyBg,
        ),
        child: TabBarView(
          controller: _controller,
          children: _billingTabs.map((billingTab) {
            return Container(
              decoration: BoxDecoration(color: BillingColors.bodyBg),
              child: billingTab.page,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BillingTab {
  BillingTab({this.title, this.icon, this.page, this.fabIcon, this.onFabTap});
  final String title;
  final IconData icon;
  final Widget page;
  final IconData fabIcon;
  final Function(BuildContext context) onFabTap;
}

List<BillingTab> buildTabs() {
  return <BillingTab>[
    BillingTab(
      title: 'Enrollments',
      icon: Icons.people,
      page: EnrollmentsPage(key: ValueKey('enrollments')),
      fabIcon: Icons.add,
      onFabTap: (context) => _navigateToNewEnrollment(context),
    ),
    BillingTab(
      title: 'Invoices',
      icon: Icons.subject,
      page: InvoicesPage(key: ValueKey('invoices')),
      fabIcon: Icons.plus_one,
      onFabTap: (context) => _createTestInvoice,
    ),
    BillingTab(
        title: 'Help', icon: Icons.help, page: HelpPage(key: ValueKey('help'))),
    BillingTab(
        title: 'Contact us',
        icon: Icons.contact_phone,
        page: ContactUsPage(key: ValueKey('contact_us'))),
    BillingTab(
        title: 'Logout',
        icon: Icons.exit_to_app,
        page: LogoutPage(key: ValueKey('logout'))),
  ];
}

_navigateToNewEnrollment(BuildContext context) {
  return () {
    Navigator.push(
      context,
      NewEnrollmentRoute(builder: (BuildContext context) {
        return NewEnrollmentPage();
      }),
    );
  };
}

void _createTestInvoice() async {
  WindermereService.createInvoice(await getToken());
}
