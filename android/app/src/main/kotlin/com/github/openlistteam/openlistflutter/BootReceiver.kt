package com.github.openlistteam.openlistflutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.github.openlistteam.openlistflutter.config.AppConfig

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED && AppConfig.isStartAtBootEnabled) {
            context.startService(Intent(context, OpenListService::class.java))
        }
    }
}
