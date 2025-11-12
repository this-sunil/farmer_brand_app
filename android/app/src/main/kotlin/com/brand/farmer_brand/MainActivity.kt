package com.brand.farmer_brand

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.brand.farmer_brand/upi"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "startTransaction") {
                    val url = call.argument<String>("url")
                    if (url != null) {
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                            val chooser = Intent.createChooser(intent, "Pay with UPI")
                            startActivity(chooser)
                            result.success("UPI Intent Launched")
                        } catch (e: Exception) {
                            result.error("FAILED", e.message, null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "URL is required", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
