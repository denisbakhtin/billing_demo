import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../models/enrollment.dart';
import '../models/contract.dart';
import 'package:flutter/foundation.dart';
import '../theme.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import '../service.dart';
import 'dart:async';

class EnrollmentsPage extends StatefulWidget {
  final Key key;
  EnrollmentsPage({this.key});

  @override
  _EnrollmentsPageState createState() => _EnrollmentsPageState();
}

class _EnrollmentsPageState extends State<EnrollmentsPage> {
  EnrollmentsModel enrollments;
  String error;
  bool isLoading = true;
  String searchString;
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<Null> _loadEnrollmentsAsync() async {
    WindermereService.getEnrollments(await getToken()).then((model) {
      if (mounted)
        setState(() {
          enrollments = model;
          isLoading = false;
          error = null;
        });
    }).catchError((err) {
      if (mounted)
        setState(() {
          error = err.toString();
          isLoading = false;
        });
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      searchString = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadEnrollmentsAsync(); //can't use straight async await in initState
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BillingColors.bodyBg,
      ),
      child: Center(
        child: isLoading
            ? showSpinner()
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _loadEnrollmentsAsync,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    //heading
                    new SliverToBoxAdapter(child: SizedBox(height: 16.0)),
                    new SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Enrollments',
                          style: pageTitleStyle(),
                        ),
                      ),
                    ),
                    //search box
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Material(
                          elevation: 0.0,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => searchString = value),
                            decoration: highlightInputDecoration(
                                'Search',
                                Icons.search,
                                stringIsNullOrEmpty(searchString)
                                    ? null
                                    : _clearSearch),
                          ),
                        ),
                      ),
                    ),
                    //check error
                    error != null
                        ? SliverToBoxAdapter(child: _Error(error))
                        : SliverList(
                            delegate: SliverChildListDelegate(
                              enrollments
                                  .filteredAccountsByOffice(searchString)
                                  .map((AccountsByOfficeModel office) {
                                    List<Widget> items = [_OfficeItem(office)];
                                    items.addAll(office
                                        .filteredAccounts(searchString)
                                        .map((account) {
                                      return _AccountItem(
                                          enrollments.benefits, account);
                                    }).toList());
                                    return items;
                                  })
                                  .expand((i) => i)
                                  .toList(),
                            ),
                          ),
                    SliverToBoxAdapter(child: SizedBox(height: 100.0)),
                  ].where(notNull).toList(),
                ),
              ),
      ),
    );
  }
}

class _OfficeItem extends StatelessWidget {
  final AccountsByOfficeModel office;
  _OfficeItem(this.office);

  @override
  Widget build(BuildContext context) {
    return Container(
        key: ValueKey(office.officeName),
        padding:
            EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Text(
          office.officeName,
          style: pageSubtitleStyle(),
        ));
  }
}

class _AccountItem extends StatelessWidget {
  final AccountInfo account;
  final List<BenefitInfo> benefits;
  _AccountItem(this.benefits, this.account);

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: BillingColors.dividerColor))),
      child: Material(
        color: BillingColors.bodyBg,
        child: ListTile(
          key: ValueKey(account.sid),
          dense: true,
          onLongPress: () => showSnackbar(
              context, 'Delete account not implemented in demo version'),
          onTap: () => showSnackbar(
              context, 'View account page not implemented in demo version'),
          title: Text(
            '${account.lastName} ${account.firstName}, ${formatter.format(account.effectiveDate != null ? account.effectiveDate : account.hireDate)}',
            style: sansRegular14(BillingColors.listItemColor),
          ),
          subtitle: Row(
            children: benefits
                .map((b) {
                  return [
                    account.elections != null &&
                            account.elections.any((e) => b.sid == e.benefitSid)
                        ? Icon(
                            Icons.check_box,
                            size: 13.0,
                            color: BillingColors.listItemColor,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            size: 13.0,
                            color: BillingColors.listItemColor,
                          ),
                    SizedBox(width: 2.0),
                    Text(b.shortName,
                        style: sansLight12(BillingColors.listItemColor)),
                    SizedBox(width: 4.0),
                  ];
                })
                .expand((i) => i)
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final String error;
  _Error(this.error);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
      child: Center(
        child: Text(
          error,
          style: sansRegular14(BillingColors.dangerColor),
        ),
      ),
    );
  }
}
