import 'package:mobx/mobx.dart';
import 'package:monecom/helpers/extensions.dart';

part 'signup_store.g.dart';

class SignUpStore = _SignUpStore with _$SignUpStore;

abstract class _SignUpStore with Store {
  @observable
  String name;

  @action
  void setName(String value) => name = value;

  @computed
  bool get nameIsValid => name != null && name.isNotEmpty;
  String get nameError {
    if (name == null || nameIsValid)
      return null;
    else if (name.isEmpty)
      return 'Campo obrigatório!';
    else
      return 'Nome inválido.';
  }

  @observable
  String email;

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailIsValid => email != null && email.isEmailValid();
  String get emailError {
    if (email == null || emailIsValid)
      return null;
    else if (email.isEmpty)
      return 'Campo obrigatório!';
    else
      return 'E-mail inválido.';
  }

  @observable
  String phone;

  @action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneIsValid => phone != null && phone.length >= 14;
  String get phoneError {
    if (phone == null || phoneIsValid)
      return null;
    else if (phone.isEmpty)
      return 'Campo obrigatório!';
    else
      return 'Celular inválido.';
  }

  @computed
  bool get isFormValid => nameIsValid && emailIsValid && phoneIsValid;
}
