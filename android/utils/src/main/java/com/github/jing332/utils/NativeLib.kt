package com.github.openlistteam.utils

object NativeLib {
    external fun getLocalIp(): String

    init {
        System.loadLibrary("utils")
    }

}