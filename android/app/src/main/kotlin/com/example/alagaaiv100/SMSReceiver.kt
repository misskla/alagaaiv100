package com.example.alagaaiv100

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.telephony.SmsMessage
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager

class SMSReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("SMSReceiver", "✅ onReceive() triggered")
        val bundle = intent.extras
        val pdus = bundle?.get("pdus") as? Array<*>
        val format = bundle?.getString("format") ?: ""

        pdus?.forEach { pdu ->
            val sms = SmsMessage.createFromPdu(pdu as ByteArray, format)
            val message = sms.displayMessageBody
            Log.d("SMSReceiver", "📩 SMS: $message")

            // Send internal broadcast to Flutter (optional)
            Handler(Looper.getMainLooper()).postDelayed({
                val internalIntent = Intent("SMS_MONITOR_EVENT")
                internalIntent.putExtra("message", message)
                LocalBroadcastManager.getInstance(context).sendBroadcast(internalIntent)
                Log.d("SMSReceiver", "📤 Sent SMS to Flutter via LocalBroadcast: $message")
            }, 1000)

            // ✅ If message contains trigger word, launch bubble
            val triggerWords = listOf("help", "abuse", "emergency") // Customize this list
            if (triggerWords.any { word -> message.contains(word, ignoreCase = true) }) {
                Log.d("SMSReceiver", "🚨 Trigger word detected, launching bubble")

                val bubbleIntent = Intent(context, FloatingBubbleService::class.java)
                bubbleIntent.putExtra("trigger_message", message)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(bubbleIntent)
                } else {
                    context.startService(bubbleIntent)
                }
            }
        }
    }

}
