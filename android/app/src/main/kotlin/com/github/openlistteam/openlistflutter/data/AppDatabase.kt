/*
package com.github.openlistteam.openlistflutter.data

import androidx.room.AutoMigration
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.github.openlistteam.openlistandroid.data.dao.ServerLogDao
import com.github.openlistteam.openlistflutter.data.entities.ServerLog
import com.github.openlistteam.openlistflutter.App.Companion.app

val appDb by lazy { AppDatabase.create() }

@Database(
    version = 2,
    entities = [ServerLog::class],
    autoMigrations = [
        AutoMigration(from = 1, to = 2)
    ]
)
abstract class AppDatabase : RoomDatabase() {
    abstract val serverLogDao: ServerLogDao

    companion object {
        fun create() = Room.databaseBuilder(
            app,
            AppDatabase::class.java,
            "openlistandroid.db"
        )
            .allowMainThreadQueries()
            .build()
    }
}*/
