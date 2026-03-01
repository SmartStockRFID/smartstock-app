// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeedbackResponseContent {
  final String status;
  final String message;

  FeedbackResponseContent({required this.status, required this.message});

  factory FeedbackResponseContent.fromMap(Map<String, dynamic> map) {
    return FeedbackResponseContent(
      status: map['status'] as String,
      message: map['message'] as String,
    );
  }

  factory FeedbackResponseContent.fromJson(String source) =>
      FeedbackResponseContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FeedbackResponseContent(status: $status, message: $message)';
}
