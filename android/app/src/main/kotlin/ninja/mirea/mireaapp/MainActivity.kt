package ninja.mirea.mireaapp

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import ninja.mirea.nativefeatures.NativeFeature
import ninja.mirea.nativefeatures.NativeFeatureResult

class MainActivity : FlutterFragmentActivity() {
    private companion object {
        const val FEATURE_PROVIDERS_KEY = "ninja.mirea.nativefeatures.providers"
    }

    private val nativeFeatures by lazy {
        val applicationInfo = packageManager.getApplicationInfo(
            packageName,
            PackageManager.GET_META_DATA,
        )
        applicationInfo.metaData
            ?.getString(FEATURE_PROVIDERS_KEY)
            .orEmpty()
            .split(',')
            .map(String::trim)
            .filter(String::isNotEmpty)
            .map(::createNativeFeature)
    }
    private val nativeChannels = mutableListOf<MethodChannel>()
    private var pendingInitialIntent: Intent? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        val forwardsInitialIntent = when (intent.action) {
            Intent.ACTION_VIEW -> intent.data != null
            "SELECT_NOTIFICATION", "SELECT_FOREGROUND_NOTIFICATION" -> true
            else -> false
        }
        if (savedInstanceState == null &&
            forwardsInitialIntent &&
            intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY == 0 &&
            FriendsLocationEngine.retainedEngine()?.dartExecutor?.isExecutingDart == true
        ) {
            pendingInitialIntent = intent
        }
        super.onCreate(savedInstanceState)
    }

    override fun onPostResume() {
        super.onPostResume()
        pendingInitialIntent?.let {
            pendingInitialIntent = null
            super.onNewIntent(it)
        }
    }

    override fun onNewIntent(intent: Intent) {
        pendingInitialIntent = null
        super.onNewIntent(intent)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? =
        FriendsLocationEngine.retainedEngine()

    override fun createFlutterFragment(): FlutterFragment =
        FriendsLocationFlutterFragment().apply {
            arguments = super.createFlutterFragment().arguments
        }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        if (!flutterEngine.plugins.has(FriendsLocationEngine::class.java)) {
            flutterEngine.plugins.add(FriendsLocationEngine(flutterEngine))
        }
        nativeFeatures.forEach { feature ->
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, feature.channelName)
                .also(nativeChannels::add)
                .setMethodCallHandler { call, result ->
                    feature.handle(
                        context = applicationContext,
                        activity = this,
                        method = call.method,
                        arguments = call.arguments.asStringKeyedMap(),
                        result = FlutterNativeFeatureResult(result),
                    )
                }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        nativeChannels.forEach { it.setMethodCallHandler(null) }
        nativeChannels.clear()
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onResume() {
        super.onResume()
        nativeFeatures.forEach { it.onResume(this) }
    }

    override fun onPause() {
        nativeFeatures.forEach { it.onPause(this) }
        super.onPause()
    }

    override fun onDestroy() {
        nativeFeatures.forEach { it.onDestroy(this) }
        super.onDestroy()
    }

    private fun Any?.asStringKeyedMap(): Map<String, Any?> {
        val values = this as? Map<*, *> ?: return emptyMap()
        return buildMap {
            values.forEach { (key, value) ->
                if (key is String) put(key, value)
            }
        }
    }

    private fun createNativeFeature(className: String): NativeFeature =
        Class.forName(className, true, javaClass.classLoader)
            .getDeclaredConstructor()
            .newInstance() as NativeFeature

    private class FlutterNativeFeatureResult(
        private val result: MethodChannel.Result,
    ) : NativeFeatureResult {
        override fun success(value: Any?) {
            result.success(value)
        }

        override fun error(code: String, message: String?, details: Any?) {
            result.error(code, message, details)
        }

        override fun notImplemented() {
            result.notImplemented()
        }
    }
}
