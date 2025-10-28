import 'package:form_validator/form_validator.dart';

class AppValidators {
  static String? Function(String?) email() {
    return ValidationBuilder(
      requiredMessage: 'Campo obrigatório!',
    ).required().email('E-mail inválido').build();
  }

  static String? Function(String?) senha() {
    return ValidationBuilder(requiredMessage: 'Campo obrigatório!',)
        .required('Informe a senha')
        .minLength(6, 'Mínimo 6 caracteres')
        .build();
  }

  static String? Function(String?) nome({String label = 'Nome'}) {
    return ValidationBuilder(requiredMessage: 'Campo obrigatório!',)
        .required('Informe o $label')
        .minLength(3, 'Min. 3 caracteres')
        .maxLength(80, 'Máx. 80 caracteres')
        .build();
  }
   static String? Function(String?) celular({String label = 'Celular'}) {
    return ValidationBuilder(requiredMessage: 'Campo obrigatório!',)
        .required('Informe o $label')
        .minLength(14, 'Número inválido')
        .build();
  }

  static String? Function(String?) numero({String label = 'Número'}) {
    return ValidationBuilder(requiredMessage: 'Campo obrigatório!',)
        .required('Informe o $label')
        .regExp(RegExp(r'^\d+$'), '$label deve conter apenas números')
        .build();
  }

  static String? Function(String?) cpf() {
    return ValidationBuilder(requiredMessage: 'Campo obrigatório!',)
        .required('Informe o CPF')
        .regExp(RegExp(r'^\d{11}$'), 'CPF inválido')
        .build();
  }

  static String? Function(String?) confirmarSenha(String senha) {
    return ValidationBuilder(requiredMessage: 'Campo obrigatório!',)
        .required('Confirme a senha')
        .add((val) => val == senha ? null : 'As senhas não coincidem')
        .build();
  }


  
}
