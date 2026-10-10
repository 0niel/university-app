package ninja.mirea.mireaapp

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

class FriendsLocationEngine(private val engine: FlutterEngine) : FlutterPlugin, ActivityAware {
    companion object {
        private const val CACHE_KEY = "friends_location_background"
        private const val CHANNEL_NAME = "ninja.mirea/friends_location_background"

        fun retainedEngine(): FlutterEngine? = FlutterEngineCache.getInstance().get(CACHE_KEY)

        fun isRetained(engine: FlutterEngine?): Boolean =
            engine != null && retainedEngine() === engine
    }

    private var channel: MethodChannel? = null
    private var enabled = false
    private var attachedToActivity = false
    private var changingConfiguration = false

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME).also { channel ->
            channel.setMethodCallHandler { call, result ->
                if (call.method != "setEnabled") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val nextEnabled = call.arguments as? Boolean
                if (nextEnabled == null) {
                    result.error("invalid_arguments", "Expected a boolean", null)
                    return@setMethodCallHandler
                }
                enabled = nextEnabled
                updateRetention()
                result.success(null)
                releaseDetachedEngine()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        enabled = false
        changingConfiguration = false
        attachedToActivity = false
        updateRetention()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        attachedToActivity = true
        changingConfiguration = false
        updateRetention()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        attachedToActivity = false
        changingConfiguration = isRetained(engine)
    }

    override fun onDetachedFromActivity() {
        attachedToActivity = false
        changingConfiguration = false
        updateRetention()
        releaseDetachedEngine()
    }

    private fun updateRetention() {
        val cache = FlutterEngineCache.getInstance()
        if (enabled || changingConfiguration) {
            cache.put(CACHE_KEY, engine)
        } else if (isRetained(engine)) {
            cache.remove(CACHE_KEY)
        }
    }

    private fun releaseDetachedEngine() {
        if (enabled || attachedToActivity || changingConfiguration || channel == null) return
        Handler(Looper.getMainLooper()).post {
            if (!enabled && !attachedToActivity && !changingConfiguration && channel != null) {
                engine.destroy()
            }
        }
    }
}
