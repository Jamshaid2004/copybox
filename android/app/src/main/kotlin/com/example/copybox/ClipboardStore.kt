package com.example.copybox

import android.content.Context
import android.util.Log

object ClipboardStore {
    private const val TAG = "ClipboardStore"
    private const val PREF_NAME = "clipboard_store"
    private const val KEY_ITEMS = "items"
    private const val SEPARATOR = "|||CLIP|||"
    private const val MAX_ITEMS = 100

    fun add(context: Context, text: String) {
        Log.d(TAG, "════════════════════════════════════")
        Log.d(TAG, "add() called")
        Log.d(TAG, "Text length: ${text.length}")
        Log.d(TAG, "Text preview: '${text.take(100)}...'")
        
        try {
            val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
            Log.d(TAG, "✅ SharedPreferences obtained")
            
            val current = getAll(context).toMutableList()
            Log.d(TAG, "📚 Current history size: ${current.size}")
            
            // Check for duplicate
            if (current.contains(text)) {
                Log.d(TAG, "⚠️ Duplicate found - removing old entry")
                current.remove(text)
            }
            
            // Add to beginning
            current.add(0, text)
            Log.d(TAG, "✅ Added to list at position 0")
            
            // Trim if needed
            if (current.size > MAX_ITEMS) {
                val removed = current.size - MAX_ITEMS
                current.subList(MAX_ITEMS, current.size).clear()
                Log.d(TAG, "✂️ Trimmed $removed old items")
            }
            
            // Join and save
            val joined = current.joinToString(SEPARATOR)
            Log.d(TAG, "💾 Saving joined string (length: ${joined.length})")
            
            val success = prefs.edit().putString(KEY_ITEMS, joined).commit()
            
            if (success) {
                Log.d(TAG, "✅✅✅ SAVED SUCCESSFULLY! Total items: ${current.size}")
            } else {
                Log.e(TAG, "❌❌❌ SAVE FAILED!")
            }
            
            // Verify by reading back
            val verification = prefs.getString(KEY_ITEMS, "")
            Log.d(TAG, "🔍 Verification read length: ${verification?.length ?: 0}")
            
        } catch (e: Exception) {
            Log.e(TAG, "❌ Exception in add(): ${e.message}", e)
        }
        
        Log.d(TAG, "════════════════════════════════════")
    }

    fun getAll(context: Context): List<String> {
        Log.d(TAG, "getAll() called")
        
        try {
            val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
            val saved = prefs.getString(KEY_ITEMS, "") ?: ""
            
            Log.d(TAG, "📖 Read from storage (length: ${saved.length})")
            
            if (saved.isEmpty()) {
                Log.d(TAG, "📭 No history found in storage")
                return emptyList()
            }
            
            val list = saved.split(SEPARATOR).filter { it.isNotBlank() }
            Log.d(TAG, "📚 Returning ${list.size} items")
            
            return list
            
        } catch (e: Exception) {
            Log.e(TAG, "❌ Exception in getAll(): ${e.message}", e)
            return emptyList()
        }
    }

    fun clear(context: Context) {
        Log.d(TAG, "clear() called")
        try {
            val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
            val success = prefs.edit().remove(KEY_ITEMS).commit()
            
            if (success) {
                Log.d(TAG, "✅ History cleared successfully")
            } else {
                Log.e(TAG, "❌ Failed to clear history")
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ Exception in clear(): ${e.message}", e)
        }
    }
}