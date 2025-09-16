// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReadingContentObject {
  final String tagUid;
  final String productOEM;

  ReadingContentObject({
    required this.tagUid,
    required this.productOEM,
  });

  factory ReadingContentObject.fromMap(Map<String, dynamic> map) {
    return ReadingContentObject(
      tagUid: map['uid'] as String,
      productOEM: map['data'] as String,
    );
  }

  factory ReadingContentObject.fromJson(String source) => ReadingContentObject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReadingContent(tagUid: $tagUid, productOEM: $productOEM)';
}
