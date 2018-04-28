import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../models/invoice.dart';
import '../models/contract.dart';
import 'package:flutter/foundation.dart';
import '../theme.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import '../service.dart';
import 'dart:async';
import '../routes.dart';
import 'invoice.dart';

class InvoicesPage extends StatefulWidget {
  final Key key;
  InvoicesPage({this.key});

  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  InvoicesModel invoices;
  String error;
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<Null> _loadInvoicesAsync() async {
    WindermereService.getInvoices(await getToken()).then((model) {
      if (mounted)
        setState(() {
          invoices = model;
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

  @override
  void initState() {
    super.initState();
    _loadInvoicesAsync(); //can't use straight async await in initState
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
                onRefresh: _loadInvoicesAsync,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    //heading
                    new SliverToBoxAdapter(child: SizedBox(height: 16.0)),
                    new SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Invoices',
                          style: pageTitleStyle(),
                        ),
                      ),
                    ),
                    new SliverToBoxAdapter(child: SizedBox(height: 16.0)),
                    //check error
                    error != null
                        ? SliverToBoxAdapter(child: _Error(error))
                        : SliverList(
                            delegate: SliverChildListDelegate(invoices.invoices
                                .map((InvoiceInfo invoice) =>
                                    _invoiceItem(invoice, context))
                                .toList())),

                    SliverToBoxAdapter(child: SizedBox(height: 100.0)),
                  ].where(notNull).toList(),
                ),
              ),
      ),
    );
  }
}

Widget _invoiceItem(InvoiceInfo invoice, BuildContext context) {
  DateFormat formatter = DateFormat('MMMM yyyy');
  return Container(
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 1.0, color: BillingColors.dividerColor))),
    child: Material(
      color: BillingColors.bodyBg,
      child: ListTile(
        key: ValueKey(invoice.sid),
        dense: true,
        onTap: () async {
          await Navigator.push(
              context,
              InvoiceRoute(
                  invoice: invoice,
                  builder: (BuildContext context) {
                    return InvoicePage(
                      invoice: invoice,
                    );
                  }));
        },
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new SizedBox(
              width: 100.0,
              child: Text(
                formatter.format(invoice.billingMonth),
                style: sansRegular14(BillingColors.listItemColor),
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              '\$${invoice.amount.toStringAsFixed(2)}',
              style: sansLight14(BillingColors.listItemColor),
            ),
          ],
        ),
        subtitle: Text(
          invoice.status,
          style: sansLight12(BillingColors.listItemColor),
        ),
        trailing: Row(
          children: <Widget>[
            InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.file_download,
                    size: 13.0,
                    color: BillingColors.listItemColor,
                  ),
                  SizedBox(width: 2.0),
                  Text(
                    'xls',
                    style: sansRegular14(BillingColors.listItemColor),
                  ),
                ],
              ),
              onTap: () => showSnackbar(context, notImplemented),
            ),
            SizedBox(width: 8.0),
            InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.file_download,
                    size: 13.0,
                    color: BillingColors.listItemColor,
                  ),
                  SizedBox(width: 2.0),
                  Text(
                    'pdf',
                    style: sansRegular14(BillingColors.listItemColor),
                  ),
                ],
              ),
              onTap: () => showSnackbar(context, notImplemented),
            ),
          ],
        ),
      ),
    ),
  );
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
