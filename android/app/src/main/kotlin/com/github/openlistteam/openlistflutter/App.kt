package com.github.openlistteam.openlistflutter

import android.app.Application
import com.github.openlistteam.openlistflutter.utils.ToastUtils.longToast
import io.flutter.app.FlutterApplication

val app by lazy { App.app }

class App : FlutterApplication() {
    companion object {
        lateinit var app: Application
    }


    override fun onCreate() {
        super.onCreate()

        app = this
    }
}