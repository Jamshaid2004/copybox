import 'package:flutter/material.dart';

@immutable
class ClipboardItem {
  final int? id;
  final String title;
  final String content;
  final String? category;
  final DateTime createdAt;

  static const String tableName = 'clipboard_items';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colCategory = 'category';
  static const String colCreatedAt = 'createdAt';

  /// Command to create table
  static const String createTable = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT NOT NULL,
      $colContent TEXT NOT NULL,
      $colCategory TEXT,
      $colCreatedAt INTEGER NOT NULL
    )
  ''';

  /// Command to drop table
  static const String dropTable = 'DROP TABLE IF EXISTS $tableName';

  /// Construtor
  const ClipboardItem({this.id, required this.title, required this.content, this.category, required this.createdAt});

  /// Converts to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'content': content, 'category': category, 'createdAt': createdAt.millisecondsSinceEpoch};
  }

  /// Converts from Map
  factory ClipboardItem.fromMap(Map<String, dynamic> map) {
    return ClipboardItem(
      id: map['id'] ?? 1,
      title: map['title'] ?? 'unamed',
      content: map['content'] ?? '',
      category: map['category'] ?? 'add category',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
