package com.bwnbits.personal_tracker

import android.app.*
import android.content.Intent
import android.net.TrafficStats
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import android.content.pm.ServiceInfo

class NetworkSpeedService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var lastRxBytes: Long = TrafficStats.getTotalRxBytes()
    private var lastTxBytes: Long = TrafficStats.getTotalTxBytes()

    private val updateRunnable = object : Runnable {
        override fun run() {
            updateNotification()
            handler.postDelayed(this, 1000)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()

        val notification = createNotification("Initializing...", "Monitoring network speed")
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
        } else {
            startForeground(1, notification)
        }
        
        handler.post(updateRunnable)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(updateRunnable)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotification(title: String, content: String): Notification {
        return NotificationCompat.Builder(this, "netpulse_channel")
            .setContentTitle(title)
            .setContentText(content)
            .setSmallIcon(android.R.drawable.stat_sys_download)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .build()
    }

    private fun updateNotification() {
        val currentRxBytes = TrafficStats.getTotalRxBytes()
        val currentTxBytes = TrafficStats.getTotalTxBytes()

        val rxSpeed = currentRxBytes - lastRxBytes
        val txSpeed = currentTxBytes - lastTxBytes

        lastRxBytes = currentRxBytes
        lastTxBytes = currentTxBytes

        val speedText = "↓ ${formatSpeed(rxSpeed)}  ↑ ${formatSpeed(txSpeed)}"
        
        val notification = createNotification("NetPulse Active", speedText)
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(1, notification)
    }

    private fun formatSpeed(bytes: Long): String {
        val kb = bytes / 1024.0
        return if (kb < 1024) {
            "${String.format("%.0f", kb)} KB/s"
        } else {
            "${String.format("%.2f", kb / 1024.0)} MB/s"
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "netpulse_channel",
                "NetPulse Service",
                NotificationManager.IMPORTANCE_LOW
            )
            channel.description = "Displays real-time network speed"
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
