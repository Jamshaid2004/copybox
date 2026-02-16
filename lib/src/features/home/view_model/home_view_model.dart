import 'dart:async';

import 'package:copybox/src/core/global/navigator_key.dart';
import 'package:copybox/src/core/services/db/local_db.dart';
import 'package:copybox/src/features/home/model/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  /* -------------------------------------------------------------------------- */
  /*                                  Variables                                 */
  /* -------------------------------------------------------------------------- */

  /// Database
  final LocalDb db = LocalDb();

  /// Is Filter Selected
  final isFilterSelected = false;

  /// Status checker timer
  late Timer _statusCheckTimer;

  /// Clipboard stream subscription
  late StreamSubscription? _clipboardSub;

  /// Is Service Active
  ValueNotifier<bool> isServiceActive = ValueNotifier(false);

  /// Method Channel
  static const platform = MethodChannel('copybox/clipboard');

  /// Event Channel
  static const clipboardStream = EventChannel('copybox/clipboard_stream');

  ValueNotifier<List<ClipboardItem>> clipboardItems = ValueNotifier([]);

  /* -------------------------------------------------------------------------- */
  /*                                   Methods                                  */
  /* -------------------------------------------------------------------------- */

  /// Constructor
  HomeViewModel() {
    // Load the history
    _loadClipboardHistory();

    // Check service status after every 2 second
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkServiceStatus();
    });
    // Listen to clipboard stream
    _clipboardSub = clipboardStream.receiveBroadcastStream().listen(_onClipboardReceived, onError: (e) {
      debugPrint('❌ Clipboard stream error: $e');
    });
  }

  /// On Clipboard Received
  void _onClipboardReceived(dynamic data) {
    final text = data as String?;

    if (text == null || text.isEmpty) return;

    debugPrint('📥 Clipboard received: $text');

    if (!_checkIfContentAlreadyExists(text)) {
      _addClipboardItem(text);
    }
  }

  bool _checkIfContentAlreadyExists(String content) {
    return clipboardItems.value.any((item) => item.content == content);
  }

  /// Load Clipboard History
  void _loadClipboardHistory() async {
    try {
      final items = await db.getClipboardItems();
      clipboardItems.value = items;
    } catch (e) {
      debugPrint('❌ Error loading clipboard history: $e');
    }
  }

  /// Add Clipboard Item
  void _addClipboardItem(String content) async {
    try {
      final item = ClipboardItem(title: 'unnamed', content: content, createdAt: DateTime.now());
      if (await db.addClipboardItem(item)) {
        _loadClipboardHistory();
      } else {
        debugPrint('Something went wrong while adding the item');
      }
    } catch (e) {
      debugPrint('❌ Error adding clipboard item: $e');
    }
  }

  /// Delete Clipboard Item
  void deleteClipboardItem(String id) async {
    try {
      if (await db.deleteClipboardItem(id)) {
        _loadClipboardHistory();
      } else {
        debugPrint('Soemthing Went wrong while deleting the item');
      }
    } catch (e) {
      debugPrint('❌ Error deleting clipboard item: $e');
    }
  }

  /// Clear Clipboard History
  void clearClipboardHistory() async {
    try {
      final confirm = await showDialog<bool>(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Clear History'),
          content: const Text('Are you sure you want to clear all clipboard history?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirm ?? false) {
        if (await db.clearClipboardItems()) {
          clipboardItems.value = [];
        } else {
          debugPrint('Something went wrong while clearing the history');
        }
      }
    } catch (e) {
      debugPrint('❌ Error clearing clipboard history: $e');
    }
  }

  /// Open Accessibility Settings
  void openAccessibilitySettings() async {
    try {
      await platform.invokeMethod('openAccessibilitySettings');

      if (navigatorKey.currentState!.mounted) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Enable "CopyBox" in Accessibility Settings'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error opening settings: $e');
    }
  }

  /// Checks the service status after every 2 seconds
  void _checkServiceStatus() async {
    // Check service status
    isServiceActive.value = await platform.invokeMethod('isServiceRunning') ?? false;
  }

  @override
  void dispose() {
    _statusCheckTimer.cancel();
    _clipboardSub?.cancel();
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  /*                                 Properties                                 */
  /* -------------------------------------------------------------------------- */
  static HomeViewModel getInstance([listen = false]) {
    return Provider.of<HomeViewModel>(
      navigatorKey.currentContext!,
      listen: listen,
    );
  }
}
