import 'contract.dart';
import '../utils.dart';

class EnrollmentsModel {
  final List<BenefitInfo> benefits;
  final List<AccountsByOfficeModel> accountsByOffices;
  List<AccountsByOfficeModel> filteredAccountsByOffice(String nameLike) {
    return accountsByOffices
        .where((a) => stringIsNullOrEmpty(nameLike)
            ? true
            : a.accounts.any((aa) =>
                aa.fullName.toLowerCase().contains(nameLike.toLowerCase())))
        .toList();
  }

  EnrollmentsModel({
    this.benefits,
    this.accountsByOffices,
  });

  EnrollmentsModel.fromJson(Map json)
      : benefits = json['Benefits'] != null
            ? (json['Benefits'] as List)
                .map((b) => new BenefitInfo.fromJson(b))
                .toList()
            : null,
        accountsByOffices = json['AccountsByOffices'] != null
            ? (json['AccountsByOffices'] as List)
                .map((a) => new AccountsByOfficeModel.fromJson(a))
                .toList()
            : null;
}

class AccountsByOfficeModel {
  final String officeName;
  final List<AccountInfo> accounts;
  List<AccountInfo> filteredAccounts(String nameLike) {
    return accounts
        .where((a) => stringIsNullOrEmpty(nameLike)
            ? true
            : a.fullName.toLowerCase().contains(nameLike.toLowerCase()))
        .toList();
  }

  AccountsByOfficeModel({this.officeName, this.accounts});

  AccountsByOfficeModel.fromJson(Map json)
      : officeName = json['OfficeName'],
        accounts = json['Accounts'] != null
            ? (json['Accounts'] as List)
                .map((a) => new AccountInfo.fromJson(a))
                .toList()
            : null;
}

class NewEnrollmentModel {
  String lastName;
  String firstName;
  String middleName;
  DateTime birthDate;
  DateTime effectiveDate;
  String gender;
  String address1;
  String address2;
  String city;
  String state;
  String zip;
  String ssn;
  DateTime hireDate;
  int officeSid;
  int payGroupSid;
  int classificationSid;
  num currentIncome;
  num hoursPerWeek;

  final List<Gender> genders;
  final List<Classification> classifications;
  final List<Office> offices;
  final List<PayGroup> payGroups;
  final bool supportOnlineBenefitEnrollment;
  NewEnrollmentModel(
      {this.genders,
      this.classifications,
      this.offices,
      this.payGroups,
      this.supportOnlineBenefitEnrollment});

  NewEnrollmentModel.fromJson(Map json)
      : genders = json['Genders'] != null
            ? (json['Genders'] as List)
                .map((g) => new Gender.fromJson(g))
                .toList()
            : null,
        classifications = json['Classifications'] != null
            ? (json['Classifications'] as List)
                .map((c) => new Classification.fromJson(c))
                .toList()
            : null,
        offices = json['Offices'] != null
            ? (json['Offices'] as List)
                .map((o) => new Office.fromJson(o))
                .toList()
            : null,
        payGroups = json['PayGroups'] != null
            ? (json['PayGroups'] as List)
                .map((p) => new PayGroup.fromJson(p))
                .toList()
            : null,
        supportOnlineBenefitEnrollment = json['SupportOnlineBenefitEnrollment'];
}
