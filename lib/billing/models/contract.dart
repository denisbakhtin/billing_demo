import "package:intl/intl.dart";

class BenefitInfo {
  final int sid;
  final String name;
  final String shortName;

  BenefitInfo({
    this.sid,
    this.name,
    this.shortName,
  });

  BenefitInfo.fromJson(Map json)
      : sid = json['Sid'],
        name = json['Name'],
        shortName = json['ShortName'];
}

DateFormat aspDateFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss");

class AccountInfo {
  final int sid;
  final String lastName;
  final String firstName;
  final String middleName;
  final String relation;
  final DateTime birthDate;
  final DateTime effectiveDate;
  final DateTime terminationDate;
  final String gender;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zip;
  final String ssn;
  final String status;
  final String enrollmentStatus;
  final DateTime hireDate;
  final int officeSid;
  final String phone;
  final String officeName;
  final bool isMarried;
  final int classificationSid;
  final String classificationName;
  final String payGroup;
  final int payGroupSid;
  final List<ElectionInfo> elections;
  final double currentIncome;
  final double hoursPerWeek;
  final bool canChangeBenefits;
  String get fullName => '${this.lastName} ${this.firstName}';

  AccountInfo({
    this.sid,
    this.lastName,
    this.firstName,
    this.middleName,
    this.relation,
    this.birthDate,
    this.effectiveDate,
    this.terminationDate,
    this.gender,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.ssn,
    this.status,
    this.enrollmentStatus,
    this.hireDate,
    this.officeSid,
    this.phone,
    this.officeName,
    this.isMarried,
    this.classificationSid,
    this.classificationName,
    this.payGroup,
    this.payGroupSid,
    this.elections,
    this.currentIncome,
    this.hoursPerWeek,
    this.canChangeBenefits,
  });

  AccountInfo.fromJson(Map json)
      : sid = json['Sid'],
        lastName = json['LastName'],
        firstName = json['FirstName'],
        middleName = json['MiddleName'],
        relation = json['Relation'],
        birthDate = json['BirthDate'] != null
            ? aspDateFormat.parse(json['BirthDate'])
            : null,
        effectiveDate = json['EffectiveDate'] != null
            ? aspDateFormat.parse(json['EffectiveDate'])
            : null,
        terminationDate = json['TerminationDate'] != null
            ? aspDateFormat.parse(json['TerminationDate'])
            : null,
        gender = json['Gender'],
        address1 = json['Address1'],
        address2 = json['Address2'],
        city = json['City'],
        state = json['State'],
        zip = json['Zip'],
        ssn = json['SSN'],
        status = json['Status'],
        enrollmentStatus = json['EnrollmentStatus'],
        hireDate = json['HireDate'] != null
            ? aspDateFormat.parse(json['HireDate'])
            : null,
        officeSid = json['OfficeSid'],
        phone = json['Phone'],
        officeName = json['OfficeName'],
        isMarried = json['IsMarried'],
        classificationSid = json['ClassificationSid'],
        classificationName = json['ClassificationName'],
        payGroup = json['PayGroup'],
        payGroupSid = json['PayGroupSid'],
        elections = json['Elections'] != null
            ? (json['Elections'] as List)
                .map((a) => new ElectionInfo.fromJson(a))
                .toList()
            : null,
        currentIncome = json['CurrentIncome'],
        hoursPerWeek = json['HoursPerWeek'],
        canChangeBenefits = json['CanChangeBenefits'];
}

class ElectionInfo {
  final int sid;
  final int benefitSid;
  final String benefitShortName;
  final String benefitName;
  final double amount;
  final double employeeAmount;
  final double employerAmount;
  final double volume;
  final double age;

  ElectionInfo({
    this.sid,
    this.benefitSid,
    this.benefitShortName,
    this.benefitName,
    this.amount,
    this.employeeAmount,
    this.employerAmount,
    this.volume,
    this.age,
  });

  ElectionInfo.fromJson(Map json)
      : sid = json['Sid'],
        benefitSid = json['BenefitSid'],
        benefitShortName = json['BenefitShortName'],
        benefitName = json['BenefitName'],
        amount = json['Amount'],
        employeeAmount = json['EmployeeAmount'],
        employerAmount = json['EmployerAmount'],
        volume = json['Volume'],
        age = json['Age'];
}

class Gender {
  final String text;
  final String value;
  Gender({this.text, this.value});

  Gender.fromJson(Map json)
      : text = json['Text'],
        value = json['Value'];
}

class Classification {
  final int sid;
  final String name;
  Classification({this.sid, this.name});

  Classification.fromJson(Map json)
      : sid = json['Sid'],
        name = json['Name'];
}

class Office {
  final int sid;
  final String name;
  final String address1;
  final String address2;
  final String city;
  final String zip;
  final String state;
  final String contactName;
  final String email;
  final String phone;
  Office(
      {this.sid,
      this.name,
      this.address1,
      this.address2,
      this.city,
      this.zip,
      this.state,
      this.contactName,
      this.email,
      this.phone});

  Office.fromJson(Map json)
      : sid = json['Sid'],
        name = json['Name'],
        address1 = json['Address1'],
        address2 = json['Address2'],
        city = json['City'],
        zip = json['Zip'],
        state = json['State'],
        contactName = json['ContactName'],
        email = json['Email'],
        phone = json['Phone'];
}

class PayGroup {
  final int sid;
  final String name;
  PayGroup({this.sid, this.name});

  PayGroup.fromJson(Map json)
      : sid = json['Sid'],
        name = json['Name'];
}

class InvoiceInfo {
  final int sid;
  final DateTime billingMonth;
  final String businessOwnerName;
  final String status;
  final num amount;
  final List<InvoiceLineInfo> lines;
  InvoiceInfo({
    this.sid,
    this.billingMonth,
    this.businessOwnerName,
    this.status,
    this.amount,
    this.lines,
  });

  InvoiceInfo.fromJson(Map json)
      : sid = json['Sid'],
        billingMonth = json['BillingMonth'] != null
            ? aspDateFormat.parse(json['BillingMonth'])
            : null,
        businessOwnerName = json['BusinessOwnerName'],
        status = json['Status'],
        amount = json['Amount'],
        lines = json['Lines'] != null
            ? (json['Lines'] as List)
                .map((l) => new InvoiceLineInfo.fromJson(l))
                .toList()
            : null;
}

class InvoiceLineInfo {
  final int sid;
  final int invoiceSid;
  final String description;
  final num amount;
  final int accountSid;
  final String officeName;
  final num employeeAmount;
  final num employerAmount;

  InvoiceLineInfo({
    this.sid,
    this.invoiceSid,
    this.description,
    this.amount,
    this.accountSid,
    this.officeName,
    this.employeeAmount,
    this.employerAmount,
  });

  InvoiceLineInfo.fromJson(Map json)
      : sid = json['Sid'],
        invoiceSid = json['InvoiceSid'],
        description = json['Description'],
        amount = json['Amount'],
        accountSid = json['AccountSid'],
        officeName = json['OfficeName'],
        employeeAmount = json['EmployeeAmount'],
        employerAmount = json['EmployerAmount'];
}
