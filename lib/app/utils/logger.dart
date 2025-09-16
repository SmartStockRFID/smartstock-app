import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // número de chamadas de método a serem exibidas
    errorMethodCount:
        8, // número de chamadas de método se a stacktrace for fornecida
    lineLength: 120, // largura da linha do log
    colors: true, // logs coloridos
    printEmojis: true, // imprimir um emoji para cada mensagem de log,
    dateTimeFormat: DateTimeFormat.none,
  ),
);
