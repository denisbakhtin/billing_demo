import 'contract.dart';

class InvoicesModel {
  final List<InvoiceInfo> invoices;

  InvoicesModel({
    this.invoices,
  });

  InvoicesModel.fromJson(Map json)
      : invoices = json['Invoices'] != null
            ? (json['Invoices'] as List)
                .map((i) => new InvoiceInfo.fromJson(i))
                .toList()
            : null;
}
