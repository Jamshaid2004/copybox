package com.example.copybox

import android.accessibilityservice.AccessibilityService
import android.content.ClipboardManager
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class ClipboardAccessibilityService : AccessibilityService() {

    private lateinit var clipboardManager: ClipboardManager
    private var listener: ClipboardManager.OnPrimaryClipChangedListener? = null
    private var lastClipboardText: String? = null
    private val PREF_NAME = "clipboard_dedupe"
    private val KEY_LAST_TEXT = "last_sent_text"



    companion object {
        @Volatile
        var isRunning: Boolean = false
        private const val TAG = "ClipboardAccessibility"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "🔥 Service CREATED")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.d(TAG, "════════════════════════════════════")
        Log.d(TAG, "✅ Accessibility Service Connected!")
        Log.d(TAG, "════════════════════════════════════")

        isRunning = true

        val prefs = getSharedPreferences(PREF_NAME, MODE_PRIVATE)
lastClipboardText = prefs.getString(KEY_LAST_TEXT, null)

Log.d(TAG, "📦 Restored lastClipboardText = ${lastClipboardText?.take(60)}")

        // Clipboard manager setup
        clipboardManager = getSystemService(CLIPBOARD_SERVICE) as ClipboardManager

        // Fallback listener (optional)
        listener = ClipboardManager.OnPrimaryClipChangedListener {
            captureClipboard("Listener fallback")
        }
        clipboardManager.addPrimaryClipChangedListener(listener!!)

        Log.d(TAG, "✅ Clipboard listener registered")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        // Trigger on relevant events to catch clipboard reliably
        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED,
            AccessibilityEvent.TYPE_VIEW_TEXT_SELECTION_CHANGED,
            AccessibilityEvent.TYPE_VIEW_FOCUSED -> captureClipboard("AccessibilityEvent")
        }
    }

   private fun captureClipboard(source: String) {
    try {
        val clip = clipboardManager.primaryClip
        val text = clip?.getItemAt(0)
            ?.coerceToText(this)
            ?.toString()
            ?.trim()

        if (text.isNullOrBlank()) return

         Log.d(TAG, "LAST CLIPBOARD TEXT WAS : ${lastClipboardText?.take(80)}")
         Log.d(TAG, "CURRENT TEXT IS : ${text.take(80)}")

        // 🔥 DEDUPE — only send if changed
        if (text == lastClipboardText) {
            Log.d(TAG, "DUPLICATE DATA RECIEVED")
    return
}

lastClipboardText = text
  getSharedPreferences(PREF_NAME, MODE_PRIVATE)
            .edit()
            .putString(KEY_LAST_TEXT, text)
            .apply()

        Log.d(TAG, "📤 Sending clipboard to Flutter: ${text.take(80)}")

        MainActivity.eventSink?.success(text)

    } catch (e: Exception) {
        Log.e(TAG, "❌ Error capturing clipboard", e)
    }
}



    override fun onInterrupt() {
        Log.d(TAG, "onInterrupt called")
    }

    override fun onDestroy() {
        Log.d(TAG, "════════════════════════════════════")
        Log.d(TAG, "❌ Service Destroyed")
        Log.d(TAG, "════════════════════════════════════")

        isRunning = false

        listener?.let {
            clipboardManager.removePrimaryClipChangedListener(it)
            Log.d(TAG, "✅ Listener removed")
        }

        super.onDestroy()
    }
}
