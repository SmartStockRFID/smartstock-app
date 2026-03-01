// Todo: como subir isso a nível de .env?
bool isStockFresh(DateTime lastUpdatedAt) {
  return DateTime.now().difference(lastUpdatedAt).inMinutes < 30;
}
