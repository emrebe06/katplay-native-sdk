package com.example.app;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.kattplay.NativePlayer;

import java.io.IOException;

public final class ExampleActivity extends AppCompatActivity {
    private NativePlayer player;

    @Override protected void onCreate(@Nullable Bundle state) {
        super.onCreate(state);
        player = new NativePlayer();
        if (getIntent().getData() == null) return;
        try {
            if (!player.load(this, getIntent().getData()) || !player.play()) {
                Log.e("KatPlay", player.getLastError());
            }
        } catch (IOException error) {
            Log.e("KatPlay", "Cannot open selected audio", error);
        }
    }

    @Override protected void onPause() {
        super.onPause();
        player.pause();
    }

    @Override protected void onDestroy() {
        player.close();
        super.onDestroy();
    }
}
