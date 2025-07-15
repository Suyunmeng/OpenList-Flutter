package com.github.openlistteam.openlistflutter.bridge

import android.content.Context
import android.content.Intent
import android.os.Build
import com.github.openlistteam.openlistflutter.OpenListService
import com.github.openlistteam.openlistflutter.BuildConfig
import com.github.openlistteam.openlistflutter.R
import com.github.openlistteam.openlistflutter.SwitchServerActivity
import com.github.openlistteam.openlistflutter.model.openlist.OpenList
import com.github.openlistteam.openlistflutter.utils.MyTools
import com.github.openlistteam.openlistflutter.utils.ToastUtils.longToast
import com.github.openlistteam.openlistflutter.utils.ToastUtils.toast
import com.github.openlistteam.pigeon.GeneratedApi

class AndroidBridge(private val context: Context) : GeneratedApi.Android {
    override fun addShortcut() {
        MyTools.addShortcut(
            context,
            context.getString(R.string.app_switch),
            "openlist_flutter_switch",
            R.drawable.openlist_switch,
            Intent(context, SwitchServerActivity::class.java)
        )
    }

    override fun startService() {
        context.startService(Intent(context, OpenListService::class.java))
    }

    override fun setAdminPwd(pwd: String) {
        OpenList.setAdminPassword(pwd)
    }

    override fun getOpenListHttpPort(): Long {
        return OpenList.getHttpPort().toLong()
    }

    override fun isRunning() = OpenListService.isRunning


    override fun getOpenListVersion() = BuildConfig.OPENLIST_VERSION
}