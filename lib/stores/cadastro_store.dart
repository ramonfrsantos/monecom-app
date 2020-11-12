import 'package:mobx/mobx.dart';
import 'package:monecom/helpers/extensions.dart';

part 'cadastro_store.g.dart';

class CadastroStore = _CadastroStore with _$CadastroStore;

abstract class _CadastroStore with Store {
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

  @computed
  bool get isFormValid => nameIsValid && emailIsValid;
}
