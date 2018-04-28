import 'models/user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/enrollment.dart';
import 'models/invoice.dart';
import 'utils.dart';

class WindermereService {
  static String get apiDomain => getApiDomain();

  static Future<String> login(String userID, String password) async {
    http.Response response =
        await http.post(Uri.parse('$apiDomain/api/login'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'login': userID,
      'password': password
    });
    if (response.statusCode == 200) return response.body;
    throw new StateError('Error ${response.statusCode}');
  }

  static Future<UserModel> getActiveUser(String token) async {
    http.Response response =
        await http.get(Uri.parse('$apiDomain/api/account'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200)
      return new UserModel.fromJson(json.decode(response.body));
    throw new StateError('Error ${response.statusCode}');
  }

  static Future<EnrollmentsModel> getEnrollments(String token) async {
    http.Response response =
        await http.get(Uri.parse('$apiDomain/api/enrollments'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200)
      return new EnrollmentsModel.fromJson(json.decode(response.body));
    throw new StateError('Error ${response.statusCode}');
  }

  static Future<NewEnrollmentModel> getNewEnrollment(String token) async {
    http.Response response =
        await http.get(Uri.parse('$apiDomain/api/enrollments/new'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200)
      return new NewEnrollmentModel.fromJson(json.decode(response.body));
    throw new StateError('Error ${response.statusCode}');
  }

  static Future<Null> saveNewEnrollment(
      String token, NewEnrollmentModel model) async {
    http.Response response =
        await http.post(Uri.parse('$apiDomain/api/enrollments'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    }, body: {
      'LastName': model.lastName,
      'FirstName': model.firstName,
      'MiddleName': model.middleName,
      'BirthDate': model.birthDate.toIso8601String(),
      'EffectiveDate': model.effectiveDate.toIso8601String(),
      'Gender': model.gender,
      'Address1': model.address1,
      'Address2': model.address2,
      'City': model.city,
      'State': model.state,
      'Zip': model.zip,
      'Ssn': model.ssn,
      'HireDate': model.hireDate.toIso8601String(),
      'OfficeSid': model.officeSid.toString(),
      'PayGroupSid': model.payGroupSid.toString(),
      'ClassificationSid': model.classificationSid.toString(),
      'CurrentIncome':
          model.currentIncome != null ? model.currentIncome.toString() : '0',
      'HoursPerWeek':
          model.hoursPerWeek != null ? model.hoursPerWeek.toString() : '0',
    });
    if (response.statusCode != 204)
      throw new StateError('Error ${response.statusCode}');
  }

  static sendMessageToSupport(String subject, String text) {
    //empty yet
  }

  static Future<InvoicesModel> getInvoices(String token) async {
    http.Response response =
        await http.get(Uri.parse('$apiDomain/api/invoices'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200)
      return new InvoicesModel.fromJson(json.decode(response.body));
    throw new StateError('Error ${response.statusCode}');
  }

  static Future createInvoice(String token) async {
    await http.post(Uri.parse('$apiDomain/api/invoices'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }
}
