// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReadingResponseContent {
  final String tagUid;
  final String productOEM;

  ReadingResponseContent({required this.tagUid, required this.productOEM});

  factory ReadingResponseContent.fromMap(Map<String, dynamic> map) {
    return ReadingResponseContent(tagUid: map['uid'] as String, productOEM: map['data'] as String);
  }

  factory ReadingResponseContent.fromJson(String source) =>
      ReadingResponseContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReadingContent(tagUid: $tagUid, productOEM: $productOEM)';
}
