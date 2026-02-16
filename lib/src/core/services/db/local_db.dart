import 'package:copybox/src/features/home/model/clipboard_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  static Database? _db;
  static const String databaseName = 'app.db';
  static const int version = 1;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: version,
      onCreate: (db, version) async {
        await db.execute(ClipboardItem.createTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(ClipboardItem.dropTable);
          await db.execute(ClipboardItem.createTable);
        }
      },
    );
  }

  /// Add a new clipboard item
  Future<bool> addClipboardItem(ClipboardItem item) async {
    final db = await database;
    return await db.insert(ClipboardItem.tableName, item.toMap()) > 0;
  }

  /// Get all clipboard items
  Future<List<ClipboardItem>> getClipboardItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ClipboardItem.tableName, orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) => ClipboardItem.fromMap(maps[i]));
  }

  /// Delete a clipboard item
  Future<bool> deleteClipboardItem(String id) async {
    final db = await database;
    return await db.delete(ClipboardItem.tableName, where: 'id = ?', whereArgs: [id]) > 0;
  }

  /// Update a clipboard item
  Future<bool> updateClipboardItem(ClipboardItem item) async {
    final db = await database;
    return await db.update(ClipboardItem.tableName, item.toMap(), where: 'id = ?', whereArgs: [item.id]) > 0;
  }

  /// Clear all clipboard items
  Future<bool> clearClipboardItems() async {
    final db = await database;
    return await db.delete(ClipboardItem.tableName) > 0;
  }
}
