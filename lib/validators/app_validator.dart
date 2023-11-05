String? tagValidator(String? value) {
  final isNumber = num.tryParse(value ?? '');
  if (isNumber == null) {
    return 'A tag deve possuir apenas numeros';
  } else if (value == null || value.isEmpty) {
    return 'O email não pode ser vazio';
  } else if (value.length < 14) {
    return 'A tag deve possuir no minimo 14 caracteres';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'A tag deve possuir apenas numeros';
  }
  return null;
}

String? emptyValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Este campo não pode ser vazio';
  }
  return null;
}
