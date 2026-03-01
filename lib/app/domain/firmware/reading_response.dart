import 'dart:convert';

class ReadingResponseContent {
  final bool ok;
  final String? tagUid;
  final String? productOEM;
  final String? errorMessage;

  ReadingResponseContent({required this.ok, this.tagUid, this.productOEM, this.errorMessage});

  factory ReadingResponseContent.fromMap(Map<String, dynamic> map) {
    final bool ok = map['status'] == 'ok';
    return ReadingResponseContent(
      ok: ok,
      tagUid: ok ? map['uid'] as String : null,
      productOEM: ok ? map['data'] as String : null,
      errorMessage: ok ? null : map['message'],
    );
  }

  factory ReadingResponseContent.fromJson(String source) =>
      ReadingResponseContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReadingResponseContent(ok: $ok, content: ${ok ? tagUid : errorMessage})';
}
