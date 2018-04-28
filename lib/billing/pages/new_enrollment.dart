import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../models/enrollment.dart';
import '../models/contract.dart';
import 'package:flutter/foundation.dart';
import '../theme.dart';
import '../utils.dart';
import '../service.dart';
import 'dart:async';
import 'billing_page.dart';

class NewEnrollmentPage extends StatefulWidget {
  final Key key;
  NewEnrollmentPage({this.key});

  @override
  _NewEnrollmentPageState createState() => _NewEnrollmentPageState();
}

class _NewEnrollmentPageState extends State<NewEnrollmentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'New enrollment');
  NewEnrollmentModel newEnrollment;
  String error;
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();

  Future<Null> _loadNewEnrollmentAsync() async {
    WindermereService.getNewEnrollment(await getToken()).then((model) {
      if (mounted)
        setState(() {
          newEnrollment = model;
          newEnrollment.birthDate = DateTime.now();
          newEnrollment.hireDate = DateTime.now();
          newEnrollment.effectiveDate = DateTime.now();
          newEnrollment.gender = newEnrollment.genders.first.value;
          newEnrollment.officeSid = newEnrollment.offices.first.sid;
          newEnrollment.payGroupSid = newEnrollment.payGroups.first.sid;
          newEnrollment.classificationSid =
              newEnrollment.classifications.first.sid;
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

  void _onSaveEnrollment() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      WindermereService
          .saveNewEnrollment(await getToken(), newEnrollment)
          .then((_) {
        Navigator.pop(context);
        showSnackbar(context, 'enrollment created successfully!');
      }).catchError((err) {
        if (mounted) setState(() => error = err.toString());
      });
    }
  }

  bool _isW2() {
    return newEnrollment.classifications
        .where((c) => c.sid == newEnrollment.classificationSid)
        .first
        .name
        .startsWith('W2');
  }

  @override
  void initState() {
    super.initState();
    _loadNewEnrollmentAsync(); //can't use straight async await in initState
  }

  @override
  Widget build(BuildContext context) {
    return BillingPage(
      scaffoldKey: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: BillingColors.bodyBg,
        ),
        child: Center(
          child: isLoading
              ? showSpinner()
              : CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    //heading
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                            child: Text('New enrollment',
                                style: pageTitleStyle())),
                      ),
                    ),
                    //check error
                    error != null
                        ? SliverToBoxAdapter(child: _Error(error))
                        : null,
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      decoration:
                                          labelDecoration('First name *'),
                                      validator: (value) => value.isEmpty
                                          ? 'Can\'t be empty.'
                                          : null,
                                      onSaved: (value) =>
                                          newEnrollment.firstName = value,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      decoration:
                                          labelDecoration('Middle name'),
                                      onSaved: (value) =>
                                          newEnrollment.middleName = value,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      decoration:
                                          labelDecoration('Last name *'),
                                      validator: (value) => value.isEmpty
                                          ? 'Can\'t be empty.'
                                          : null,
                                      onSaved: (value) =>
                                          newEnrollment.lastName = value,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: DateTimePicker(
                                      labelText: 'Date of birth',
                                      selectedDate: newEnrollment.birthDate,
                                      selectDate: (DateTime date) {
                                        setState(() =>
                                            newEnrollment.birthDate = date);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: InputDecorator(
                                      decoration: labelDecoration('Gender'),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          value: newEnrollment.gender,
                                          items: newEnrollment.genders
                                              .map((Gender g) {
                                            return DropdownMenuItem<String>(
                                              key: ValueKey(g.value),
                                              value: g.value,
                                              child: Text(g.text),
                                            );
                                          }).toList(),
                                          onChanged: (value) => setState(() =>
                                              newEnrollment.gender = value),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InputDecorator(
                                decoration: labelDecoration('Office'),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    value: newEnrollment.officeSid.toString(),
                                    items:
                                        newEnrollment.offices.map((Office o) {
                                      return DropdownMenuItem<String>(
                                        key: ValueKey(o.sid),
                                        value: o.sid.toString(),
                                        child: Text(o.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(() =>
                                        newEnrollment.officeSid =
                                            int.parse(value)),
                                  ),
                                ),
                              ),
                              InputDecorator(
                                decoration: labelDecoration('Pay group'),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    value: newEnrollment.payGroupSid.toString(),
                                    items: newEnrollment.payGroups
                                        .map((PayGroup p) {
                                      return DropdownMenuItem<String>(
                                        key: ValueKey(p.sid),
                                        value: p.sid.toString(),
                                        child: Text(p.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(() =>
                                        newEnrollment.payGroupSid =
                                            int.parse(value)),
                                  ),
                                ),
                              ),
                              TextFormField(
                                decoration: labelDecoration('Address 1'),
                                onSaved: (value) =>
                                    newEnrollment.address1 = value,
                              ),
                              TextFormField(
                                decoration: labelDecoration('Address 2'),
                                onSaved: (value) =>
                                    newEnrollment.address2 = value,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: labelDecoration('City'),
                                      onSaved: (value) =>
                                          newEnrollment.city = value,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: labelDecoration('State'),
                                      onSaved: (value) =>
                                          newEnrollment.state = value,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: labelDecoration('Zip'),
                                      onSaved: (value) =>
                                          newEnrollment.zip = value,
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: labelDecoration('Ssn *'),
                                validator: (value) {
                                  if (value.isEmpty) return 'Can\'t be empty.';
                                  RegExp exp = RegExp(r'^([0-9]{9})$');
                                  if (!exp.hasMatch(value))
                                    return 'Ssn is not valid';
                                  return null;
                                },
                                onSaved: (value) => newEnrollment.ssn = value,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: InputDecorator(
                                      decoration:
                                          labelDecoration('Classification'),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          value: newEnrollment.classificationSid
                                              .toString(),
                                          items: newEnrollment.classifications
                                              .map((Classification c) {
                                            return DropdownMenuItem<String>(
                                              key: ValueKey(c.sid),
                                              value: c.sid.toString(),
                                              child: Text(c.name),
                                            );
                                          }).toList(),
                                          onChanged: (value) => setState(() =>
                                              newEnrollment.classificationSid =
                                                  int.parse(value)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: DateTimePicker(
                                      labelText: 'Hire date',
                                      selectedDate: newEnrollment.hireDate,
                                      selectDate: (DateTime date) {
                                        setState(() =>
                                            newEnrollment.hireDate = date);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  !_isW2()
                                      ? Expanded(
                                          child: DateTimePicker(
                                            labelText: 'Qualified amount date',
                                            selectedDate:
                                                newEnrollment.effectiveDate,
                                            selectDate: (DateTime date) {
                                              setState(() => newEnrollment
                                                  .effectiveDate = date);
                                            },
                                          ),
                                        )
                                      : Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: labelDecoration(
                                                    'Hours per week')
                                                .copyWith(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 13.0,
                                                            bottom: 16.0)),
                                            onSaved: (value) =>
                                                newEnrollment.hoursPerWeek =
                                                    num.parse(value),
                                          ),
                                        ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: labelDecoration(_isW2()
                                              ? 'Annual Income'
                                              : 'Current income')
                                          .copyWith(
                                              contentPadding: EdgeInsets.only(
                                                  top: 13.0, bottom: 16.0)),
                                      onSaved: (value) => newEnrollment
                                          .currentIncome = num.parse(value),
                                    ),
                                  ),
                                ].where(notNull).toList(),
                              ),
                              error != null ? SizedBox(height: 8.0) : null,
                              error != null
                                  ? _Error(error)
                                  : SizedBox(height: 16.0),
                              Center(
                                child: PrimaryButton(
                                  elevation: highlightElevation,
                                  text: 'SAVE ENROLLMENT',
                                  onPressed: _onSaveEnrollment,
                                ),
                              )
                            ].where(notNull).toList(),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 16.0)),
                  ].where(notNull).toList(),
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
