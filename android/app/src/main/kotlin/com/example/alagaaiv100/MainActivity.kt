package com.example.alagaaiv100

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val CHANNEL = "alagaaiv100/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize the method channel
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel = channel

        channel.setMethodCallHandler { call, result ->
            if (call.method == "startService") {
                val intent = Intent(this, AccessibilityMonitor::class.java)
                startService(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    companion object {
        private var methodChannel: MethodChannel? = null

        @JvmStatic
        fun sendToFlutter(method: String, arguments: Any?) {
            methodChannel?.invokeMethod(method, arguments)
        }
    }
}