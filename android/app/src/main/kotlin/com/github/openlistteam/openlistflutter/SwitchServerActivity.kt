package com.github.openlistteam.openlistflutter

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.github.openlistteam.openlistflutter.utils.ToastUtils.toast

class SwitchServerActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (OpenListService.isRunning) {
            startService(Intent(this, OpenListService::class.java).apply {
                action = OpenListService.ACTION_SHUTDOWN
            })
        } else {
            startService(Intent(this, OpenListService::class.java))
        }

        finish()
    }
}