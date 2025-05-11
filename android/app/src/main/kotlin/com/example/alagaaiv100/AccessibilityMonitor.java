package com.example.alagaaiv100;

import android.accessibilityservice.AccessibilityService;
import android.os.Handler;
import android.os.Looper;
import android.view.accessibility.AccessibilityEvent;
import android.widget.Toast;

import java.util.List;

public class AccessibilityMonitor extends AccessibilityService {
    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (event.getEventType() == AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED) {
            List<CharSequence> texts = event.getText();
            StringBuilder builder = new StringBuilder();
            for (CharSequence seq : texts) {
                builder.append(seq);
            }
            String text = builder.toString();

            // Show toast
            Toast.makeText(getApplicationContext(), "Monitored: " + text, Toast.LENGTH_SHORT).show();

            // ✅ Send to Flutter via MethodChannel, only if Flutter is alive
            new Handler(Looper.getMainLooper()).post(() -> {
                MainActivity.sendToFlutter("onTextCaptured", text);
            });
        }
    }

    @Override
    public void onInterrupt() {}
}