package com.bwnbits.personal_tracker

import android.content.Intent
import android.net.TrafficStats
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "netpulse"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, NetworkSpeedService::class.java)
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "stopService" -> {
                    val intent = Intent(this, NetworkSpeedService::class.java)
                    stopService(intent)
                    result.success(null)
                }
                "getTotals" -> {
                    val rx = TrafficStats.getTotalRxBytes()
                    val tx = TrafficStats.getTotalTxBytes()
                    val totals = mapOf(
                        "download" to if (rx != TrafficStats.UNSUPPORTED.toLong()) rx else 0L,
                        "upload" to if (tx != TrafficStats.UNSUPPORTED.toLong()) tx else 0L
                    )
                    result.success(totals)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
