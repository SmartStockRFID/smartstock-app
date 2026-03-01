import 'package:flutter/material.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:version/version.dart';

@immutable
class FirmwareVersion {
  final Version version;
  final Uri url;
  final String releaseNotes;
  final DateTime releaseDate;

  const FirmwareVersion({
    required this.version,
    required this.url,
    required this.releaseDate,
    required this.releaseNotes,
  });

  factory FirmwareVersion.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const InternetException('FirmwareVersion.fromJson!');
    }
    return FirmwareVersion(
      version: Version.parse(json['version'] as String),
      url: Uri.parse(json['url'] as String),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      releaseNotes: json['releaseNotes'] as String,
    );
  }
}
