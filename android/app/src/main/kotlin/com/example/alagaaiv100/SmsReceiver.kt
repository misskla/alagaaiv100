package com.example.alagaaiv100

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log
import android.widget.Toast

class SmsReceiver : BroadcastReceiver() {

    private val triggerWords = listOf("secret", "meet up", "send pics", "trust me", "don’t tell", "alone")

    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION == intent.action) {
            val bundle: Bundle? = intent.extras
            if (bundle != null) {
                val pdus = bundle["pdus"] as Array<*>
                for (pdu in pdus) {
                    val format = bundle.getString("format")
                    val message = SmsMessage.createFromPdu(pdu as ByteArray, format)
                    val sender = message.displayOriginatingAddress
                    val body = message.messageBody

                    Log.d("SmsReceiver", "From: $sender\nMessage: $body")

                    val hasTrigger = triggerWords.any { word ->
                        body.contains(word, ignoreCase = true)
                    }

                    if (hasTrigger) {
                        Toast.makeText(context, "⚠️ Trigger word detected!", Toast.LENGTH_SHORT).show()
                        Log.w("SmsReceiver", "Trigger word found in: $body")

                        // Send to Flutter via platform channel
                        MainActivity.sendSmsToFlutter(body, sender)
                    }
                }
            }
        }
    }
}
