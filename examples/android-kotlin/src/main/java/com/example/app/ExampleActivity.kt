package com.example.app

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.kattplay.NativePlayer

class ExampleActivity : AppCompatActivity() {
    private lateinit var player: NativePlayer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        player = NativePlayer()
        val uri = intent.data ?: return
        if (!player.load(this, uri) || !player.play()) {
            Log.e("KatPlay", player.lastError)
        }
    }

    fun seekTo(seconds: Double) {
        if (!player.seek(seconds)) Log.e("KatPlay", player.lastError)
    }

    override fun onPause() {
        super.onPause()
        player.pause()
    }

    override fun onDestroy() {
        player.close()
        super.onDestroy()
    }
}
