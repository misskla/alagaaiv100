package com.example.alagaaiv100

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.telephony.SmsMessage
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class SMSReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val bundle: Bundle? = intent.extras
        if (bundle != null) {
            val pdus = bundle.get("pdus") as? Array<*>
            val format = bundle.getString("format") ?: ""

            if (pdus != null) {
                for (pdu in pdus) {
                    val sms = SmsMessage.createFromPdu(pdu as ByteArray, format)
                    val message = sms.displayMessageBody

                    // Optional: Log for debug
                    Log.d("SMSReceiver", "Received SMS: $message")

                    // Pass message to Flutter via MethodChannel
                    val engine = FlutterEngine(context)
                    engine.dartExecutor.executeDartEntrypoint(
                        DartExecutor.DartEntrypoint.createDefault()
                    )

                    MethodChannel(engine.dartExecutor.binaryMessenger, "alagaai/sms")
                        .invokeMethod("incomingSMS", message)
                }
            }
        }
    }
}
