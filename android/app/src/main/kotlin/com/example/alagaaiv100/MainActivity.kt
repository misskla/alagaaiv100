package com.example.alagaaiv100

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import androidx.localbroadcastmanager.content.LocalBroadcastManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "alagaaiv100/channel"
    private val SMS_EVENT_CHANNEL = "alagaaiv100/sms_event"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel setup
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        Companion.methodChannel = methodChannel

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, AccessibilityMonitor::class.java)
                    startService(intent)
                    result.success(null)
                }
                "showBubble" -> {
                    val intent = Intent(this, FloatingBubbleService::class.java)
                    startService(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // EventChannel for SMSReceiver
        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_EVENT_CHANNEL)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            private var receiver: BroadcastReceiver? = null

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                receiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        val message = intent?.getStringExtra("message") ?: return
                        events?.success(message)
                    }
                }

                LocalBroadcastManager.getInstance(applicationContext)
                    .registerReceiver(receiver!!, IntentFilter("SMS_MONITOR_EVENT"))
            }

            override fun onCancel(arguments: Any?) {
                receiver?.let {
                    LocalBroadcastManager.getInstance(applicationContext).unregisterReceiver(it)
                }
            }
        })
    }

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
}
