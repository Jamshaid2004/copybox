package com.example.copybox

import android.accessibilityservice.AccessibilityService
import android.content.ClipboardManager
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class ClipboardAccessibilityService : AccessibilityService() {

    private lateinit var clipboardManager: ClipboardManager
    private var listener: ClipboardManager.OnPrimaryClipChangedListener? = null

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
            val text = clip?.getItemAt(0)?.coerceToText(this)?.toString()
            if (!text.isNullOrBlank()) {
                ClipboardStore.add(applicationContext, text)
                Log.d(TAG, "✅ Clipboard captured via $source: '${text.take(50)}...'")
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error capturing clipboard: ${e.message}", e)
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
