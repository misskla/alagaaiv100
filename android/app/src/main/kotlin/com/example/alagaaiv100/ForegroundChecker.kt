package com.example.alagaaiv100

import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.util.Log

object ForegroundChecker {
    fun getForegroundApp(context: Context): String? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val now = System.currentTimeMillis()
            val stats = usm.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                now - 1000 * 10,
                now
            )

            if (stats == null || stats.isEmpty()) {
                Log.w("ForegroundChecker", "Usage access not granted")
                return null
            }

            val recentStat = stats.maxByOrNull { it.lastTimeUsed }
            return recentStat?.packageName
        }
        return null
    }

    fun isSMSApp(pkg: String?): Boolean {
        return pkg == "com.google.android.apps.messaging" || pkg == "com.android.mms"
    }

    fun hasUsagePermission(context: Context): Boolean {
        return Settings.Secure.getInt(
            context.contentResolver,
            "usage_stats_enabled",
            0
        ) == 1
    }
}
