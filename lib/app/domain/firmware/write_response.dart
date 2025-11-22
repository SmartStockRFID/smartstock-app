import 'dart:convert';

class WriteResponseContent {
  final bool ok;
  final String? tagUid;
  final String? errorMessage;

  WriteResponseContent({required this.ok, this.tagUid, this.errorMessage});

  factory WriteResponseContent.fromMap(Map<String, dynamic> map) {
    final bool ok = (map['status'] as String) == 'ok';
    return WriteResponseContent(
      ok: ok,
      tagUid: ok ? map['uid'] as String : null,
      errorMessage: ok ? null : map['message'] as String,
    );
  }

  factory WriteResponseContent.fromJson(String source) =>
      WriteResponseContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WriteResponseContent(ok: $ok, content: ${ok ? tagUid : errorMessage})';
}
