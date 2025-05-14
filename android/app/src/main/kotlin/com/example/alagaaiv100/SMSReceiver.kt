package com.example.alagaaiv100

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
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

            // Send internal broadcast to Flutter with delay
            Handler(Looper.getMainLooper()).postDelayed({
                val internalIntent = Intent("SMS_MONITOR_EVENT")
                internalIntent.putExtra("message", message)
                LocalBroadcastManager.getInstance(context).sendBroadcast(internalIntent)

                // ✅ ADD THIS LOG
                Log.d("SMSReceiver", "📤 Sent SMS to Flutter via LocalBroadcast: $message")
            }, 1000)
        }
    }
}
