package ninja.mirea.mireaapp.widget_channel

import android.content.Intent
import android.widget.RemoteViewsService


class UpdateWidgetService : RemoteViewsService() {
    override
    fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
//        val a = intent?.getStringExtra("schedule");
        return HomeFactory2(applicationContext, intent!!)
    }
}