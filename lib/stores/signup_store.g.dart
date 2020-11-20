// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpStore on _SignUpStore, Store {
  Computed<bool> _$nameIsValidComputed;

  @override
  bool get nameIsValid =>
      (_$nameIsValidComputed ??= Computed<bool>(() => super.nameIsValid,
              name: '_SignUpStore.nameIsValid'))
          .value;
  Computed<bool> _$emailIsValidComputed;

  @override
  bool get emailIsValid =>
      (_$emailIsValidComputed ??= Computed<bool>(() => super.emailIsValid,
              name: '_SignUpStore.emailIsValid'))
          .value;
  Computed<bool> _$phoneIsValidComputed;

  @override
  bool get phoneIsValid =>
      (_$phoneIsValidComputed ??= Computed<bool>(() => super.phoneIsValid,
              name: '_SignUpStore.phoneIsValid'))
          .value;
  Computed<bool> _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_SignUpStore.isFormValid'))
          .value;

  final _$nameAtom = Atom(name: '_SignUpStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$emailAtom = Atom(name: '_SignUpStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$phoneAtom = Atom(name: '_SignUpStore.phone');

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$_SignUpStoreActionController = ActionController(name: '_SignUpStore');

  @override
  void setName(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
email: ${email},
phone: ${phone},
nameIsValid: ${nameIsValid},
emailIsValid: ${emailIsValid},
phoneIsValid: ${phoneIsValid},
isFormValid: ${isFormValid}
    ''';
  }
}
