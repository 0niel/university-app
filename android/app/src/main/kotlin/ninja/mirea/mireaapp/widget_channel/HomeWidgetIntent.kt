package ninja.mirea.mireaapp.widget_channel

import android.app.Activity
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri

object HomeWidgetLaunchIntent {

    const val HOME_WIDGET_LAUNCH_ACTION = "ninja.mirea.mireaapp.action.LAUNCH"

    fun <T> getActivity(
        context: Context,
        activityClass: Class<T>,
        uri: Uri? = null
    ): PendingIntent where T : Activity {
        val intent = Intent(context, activityClass)
        intent.data = uri
        intent.action = HOME_WIDGET_LAUNCH_ACTION

        return PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }
}


object HomeWidgetBackgroundIntent {
    private const val HOME_WIDGET_BACKGROUND_ACTION = "ninja.mirea.mireaapp.action.BACKGROUND"

    fun getBroadcast(context: Context, uri: Uri? = null): PendingIntent {
        val intent = Intent(context, HomeWidgetBackgroundReceiver::class.java)
        intent.data = uri
        intent.action = HOME_WIDGET_BACKGROUND_ACTION

        return PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }
}