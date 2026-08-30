package ninja.mirea.nativefeatures

import android.app.Activity
import android.content.Context

interface NativeFeature {
    val channelName: String

    fun handle(
        context: Context,
        activity: Activity,
        method: String,
        arguments: Map<String, Any?>,
        result: NativeFeatureResult,
    )

    fun onResume(activity: Activity) = Unit

    fun onPause(activity: Activity) = Unit

    fun onDestroy(activity: Activity) = Unit
}

interface NativeFeatureResult {
    fun success(value: Any?)

    fun error(code: String, message: String?, details: Any?)

    fun notImplemented()
}
