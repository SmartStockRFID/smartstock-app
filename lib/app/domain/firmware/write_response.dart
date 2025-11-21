// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WriteResponseContent {
  final bool ok;
  final String? uid;
  final String? errorMessage;

  WriteResponseContent({required this.ok, this.uid, this.errorMessage});

  factory WriteResponseContent.fromMap(Map<String, dynamic> map) {
    final bool ok = (map['status'] as String) == 'ok';
    return WriteResponseContent(
      ok: ok,
      uid: ok ? map['uid'] as String : null,
      errorMessage: ok ? null : map['message'] as String,
    );
  }

  factory WriteResponseContent.fromJson(String source) =>
      WriteResponseContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FeedbackResponseContent(ok: $ok, content: ${ok ? uid : errorMessage})';
}
