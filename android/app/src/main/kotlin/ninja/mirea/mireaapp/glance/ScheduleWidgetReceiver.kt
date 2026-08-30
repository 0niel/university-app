package ninja.mirea.mireaapp.glance

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

class ScheduleWidgetReceiver  : HomeWidgetGlanceWidgetReceiver<ScheduleGlanceAppWidget>() {
    override val glanceAppWidget = ScheduleGlanceAppWidget()
}
