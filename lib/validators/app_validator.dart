String? tagValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'A tag não pode ser vazia';
  } else if (value.length != 15) {
    return 'A tag deve possuir 15 caracteres';
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
