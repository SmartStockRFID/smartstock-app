bool refreshTokenIsFresh(DateTime tokenExpiresAt) {
  return tokenExpiresAt.difference(DateTime.now()).inHours > 8;
}
