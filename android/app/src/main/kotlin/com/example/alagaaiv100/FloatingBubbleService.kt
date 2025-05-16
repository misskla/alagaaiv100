package com.example.alagaaiv100

import android.app.Service
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.LinearLayout
import androidx.core.app.NotificationCompat
import com.example.alagaaiv100.R




class FloatingBubbleService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var bubbleView: View


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("FloatingBubbleService", "🔔 onStartCommand entered")

        startForegroundNotification()
        Log.d("FloatingBubbleService", "✅ Foreground notification started")

        try {
            bubbleView = LayoutInflater.from(this).inflate(R.layout.bubble_layout, null)
            Log.d("FloatingBubbleService", "✅ bubble layout inflated")

            val bubbleCard = bubbleView.findViewById<LinearLayout>(R.id.bubble_card)
            bubbleCard.setOnClickListener {
                val launchIntent = Intent(this, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    putExtra("fromBubble", true)
                }
                Log.d("FloatingBubbleService", "🚀 Launching MainActivity from bubble")
                startActivity(launchIntent)
                stopSelf()
            }

            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                else
                    WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )

            params.gravity = Gravity.TOP or Gravity.END
            params.x = 24
            params.y = 100

            windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
            windowManager.addView(bubbleView, params)
            Log.d("FloatingBubbleService", "🟢 Bubble added to screen")
        } catch (e: Exception) {
            Log.e("FloatingBubbleService", "❌ Error in bubble overlay: ${e.message}")
        }

        return START_NOT_STICKY
    }



    // ✅ Foreground notification to keep service alive
    private fun startForegroundNotification() {
        val channelId = "bubble_service_channel"
        val channelName = "Bubble Overlay Service"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Alaga AI is monitoring")
            .setContentText("Tap the bubble to talk.")
            .setSmallIcon(R.mipmap.ic_launcher) // You can customize this
            .setOngoing(true)
            .build()

        startForeground(1, notification)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::windowManager.isInitialized && ::bubbleView.isInitialized) {
            windowManager.removeView(bubbleView)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
