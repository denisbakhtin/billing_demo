import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/contract.dart';
import '../utils.dart';
import '../theme.dart';
import 'package:intl/intl.dart';
import 'billing_page.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({
    Key key,
    @required this.invoice,
  })  : assert(invoice != null),
        super(key: key);

  final InvoiceInfo invoice;

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

// Displays a product's heading above photos of all of the other products
// arranged in two columns. Enables the user to specify a quantity and add an
// order to the shopping cart.
class _InvoicePageState extends State<InvoicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'Invoice');
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('MMMM yyyy');
    Set<String> offices = widget.invoice.lines.map((l) => l.officeName).toSet();

    return BillingPage(
      scaffoldKey: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: BillingColors.bodyBg,
        ),
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            //heading
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                    child: Text(
                        'Invoice ${formatter.format(widget.invoice.billingMonth)}',
                        style: pageTitleStyle())),
              ),
            ),

            SliverToBoxAdapter(
              child: _invoiceHeader(widget.invoice),
            ),

            SliverList(
              delegate: SliverChildListDelegate(
                offices
                    .map((office) {
                      List<Widget> items = [];
                      items.add(SizedBox(height: 16.0));
                      items.add(Text(office, style: pageSubtitleStyle()));
                      items.add(SizedBox(height: 8.0));
                      items.add(_linesByOffice(widget.invoice.lines
                          .where((l) => l.officeName == office)
                          .toList()));
                      return items;
                    })
                    .expand((i) => i)
                    .toList(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverToBoxAdapter(
              child: new Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new FlatButton.icon(
                      label: Text('Download XLS',
                          style: sansRegular14(BillingColors.primaryColor)),
                      onPressed: () => 1,
                      icon: Icon(Icons.file_download,
                          size: 16.0, color: BillingColors.secondaryColor),
                    ),
                    new FlatButton.icon(
                      label: Text('Download PDF',
                          style: sansRegular14(BillingColors.primaryColor)),
                      onPressed: () => 1,
                      icon: Icon(Icons.file_download,
                          size: 16.0, color: BillingColors.secondaryColor),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.0)),
          ].where(notNull).toList(),
        ),
      ),
    );
  }
}

Widget _invoiceHeader(InvoiceInfo invoice) {
  DateFormat formatter = DateFormat('MMMM yyyy');
  return Card(
    child: new Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Table(
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Text(
                'Business owner',
                style: sansLight14(BillingColors.textColor),
              ),
              Text(invoice.businessOwnerName),
            ],
          ),
          TableRow(
            children: <Widget>[
              Text(
                'Billing month',
                style: sansLight14(BillingColors.textColor),
              ),
              Text(formatter.format(invoice.billingMonth)),
            ],
          ),
          TableRow(
            children: <Widget>[
              Text(
                'Status',
                style: sansLight14(BillingColors.textColor),
              ),
              Text(invoice.status),
            ],
          ),
          TableRow(
            children: <Widget>[
              Text(
                'Total amount',
                style: sansLight14(BillingColors.textColor),
              ),
              Text('\$${invoice.amount.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _linesByOffice(List<InvoiceLineInfo> lines) {
  List<TableRow> rows = [];
  rows.add(
    TableRow(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: BillingColors.dividerColor))),
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(right: 8.0, bottom: 4.0),
          child: Text('Description',
              style: sansRegular14(BillingColors.secondaryColor)),
        ),
        new Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text('Amount',
              style: sansRegular14(BillingColors.secondaryColor)),
        )
      ],
    ),
  );
  rows.addAll(lines.map((l) {
    return TableRow(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: BillingColors.dividerColor))),
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 4.0, right: 8.0, bottom: 4.0),
          child: Text(l.description,
              style: sansLight14(BillingColors.secondaryColor)),
        ),
        new Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Text('\$${l.amount.toStringAsFixed(2)}',
              style: sansLight14(BillingColors.secondaryColor)),
        )
      ],
    );
  }));
  rows.add(
    TableRow(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 4.0, right: 8.0),
          child:
              Text('Total', style: sansRegular14(BillingColors.secondaryColor)),
        ),
        new Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
              '\$${lines.reduce((a,b)=> InvoiceLineInfo(amount: a.amount + b.amount)).amount.toStringAsFixed(2)}',
              style: sansRegular14(BillingColors.secondaryColor)),
        )
      ],
    ),
  );
  Widget table = new Table(
    children: rows,
    columnWidths: {
      1: IntrinsicColumnWidth(),
    },
  );
  return table;
}
