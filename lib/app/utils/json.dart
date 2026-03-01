void checkIfIsList(dynamic list) {
  if (list is! List<dynamic>) {
    throw const FormatException('Resposta da API não é um JSON de Lista válido');
  }
}

void checkIfIsMap(dynamic json) {
  if (json is! Map<String, dynamic>) {
    throw const FormatException('Resposta da API não é um JSON válido');
  }
}
