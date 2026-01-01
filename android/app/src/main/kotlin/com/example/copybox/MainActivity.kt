package com.example.copybox

import android.content.Intent
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "copybox/clipboard"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "openAccessibilitySettings" -> {
                    val intent = Intent(android.provider.Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(null)
                }
            
                "isServiceRunning" -> {
                    result.success(ClipboardAccessibilityService.isRunning)
                }
            
                "getClipboardHistory" -> {
                    result.success(ClipboardStore.getAll(this))
                }
            
                "clearHistory" -> {
                    ClipboardStore.clear(this)
                    result.success(null)
                }
            
                else -> result.notImplemented()
            }
            
        }
    }
}
