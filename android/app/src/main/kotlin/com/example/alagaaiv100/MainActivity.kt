package com.example.alagaaiv100

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "alagaaiv100/channel"
    private val SMS_EVENT_CHANNEL = "alagaaiv100/sms_event"
    private val BUBBLE_CHANNEL = "bubble_channel"
    private var smsReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        requestOverlayPermissionIfNeeded()

        // MethodChannel 1: General (e.g. accessibility, bubble)
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
        Companion.methodChannel = methodChannel

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, AccessibilityMonitor::class.java)
                    startService(intent)
                    result.success(null)
                }
                /*"showBubble" -> {
                    //val intent = Intent(this, FloatingBubbleService::class.java)
                    //startService(intent)
                    result.success(null)
                }*/
                else -> result.notImplemented()
            }
        }

        // MethodChannel 2: Start bubble from Dart via "bubble_channel"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BUBBLE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "startBubble") {
                    //val intent = Intent(this, FloatingBubbleService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success("Bubble Started")
                } else {
                    result.notImplemented()
                }
            }

        // EventChannel: Forward SMS to Flutter from BroadcastReceiver
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    smsReceiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            val message = intent?.getStringExtra("message")
                            Log.d("MainActivity", "🛎 Forwarding to Flutter: $message")
                            if (message != null) {
                                events?.success(message)
                            }
                        }
                    }

                    LocalBroadcastManager.getInstance(this@MainActivity)
                        .registerReceiver(smsReceiver!!, IntentFilter("SMS_MONITOR_EVENT"))
                }

                override fun onCancel(arguments: Any?) {
                    smsReceiver?.let {
                        LocalBroadcastManager.getInstance(this@MainActivity).unregisterReceiver(it)
                    }
                }
            })
    }

    // Request overlay permission
    fun requestOverlayPermission() {
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, 1001)
        }
    }

    companion object {
        private var methodChannel: MethodChannel? = null

        @JvmStatic
        fun sendToFlutter(method: String, arguments: Any?) {
            methodChannel?.invokeMethod(method, arguments)
        }
    }
    private fun requestOverlayPermissionIfNeeded() {
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivity(intent)
        }
    }

}
