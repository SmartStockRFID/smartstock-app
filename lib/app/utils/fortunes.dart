import 'dart:math';

const fortunes = [
  'Contagem é clareza.',
  'Números não mentem.',
  'Estoque não perdoa.',
  'Inventário nunca dorme.',
  'Cada item conta.',
  'Confie, mas confira.',
  'Contar é compreender.',
  'Menos caos, mais controle.',
  'A ordem começa por um número.',
  'Um item de cada vez.',
  'Quem conta, manda.',
  'Inventariar é dominar.',
  'Controle é poder.',
  'A precisão é uma virtude.',
  'Erro pequeno, prejuízo grande.',
  'A contagem revela tudo.',
  'Estoque bem contado, mente tranquila.',
  'O estoque fala, você escuta.',
  'Nada some sem deixar rastro.',
  'Caos se vence com números.',
  'Contar é cuidar.',
  'O estoque é honesto com quem olha.',
  'A soma revela o invisível.',
  'Toda contagem é um momento de verdade.',
  'Quem controla, não teme.',
  'Inventário é disciplina.',
  'Confusão nasce do que não se mede.',
  'Todo número tem uma história.',
  'A ordem começa no menor item.',
  'O estoque só engana quem ignora.',
  'Um erro hoje, um rombo amanhã.',
  'A precisão evita discussões.',
  'O inventário é o espelho da empresa.',
  'Quem não conta, perde.',
  'O estoque avisa. Você responde.',
  'Contagem é prevenção.',
  'O caos teme o contador atento.',
  'Cada caixa tem um destino.',
  'A verdade mora nas prateleiras.',
  'Contar é respeitar o trabalho.',
];

String getRandomFortune() {
  final randomIndex = Random().nextInt(fortunes.length);
  return fortunes.elementAtOrNull(randomIndex) ?? 'Sem ditados hoje';
}
