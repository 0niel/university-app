package ninja.mirea.mireaapp.glance

import android.content.ComponentName
import android.content.Context
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.ImageProvider
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.state.getAppWidgetState
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import ninja.mirea.mireaapp.MainActivity
import ninja.mirea.mireaapp.R
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition

class ScheduleGlanceAppWidget : GlanceAppWidget() {
    private val TAG = "ScheduleWidget"

    // Maximum number of lessons to show on small widgets
    private val MAX_LESSONS_SMALL = 3
    // Maximum number of lessons to show on regular widgets
    private val MAX_LESSONS_REGULAR = 6

    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        @Suppress("UNCHECKED_CAST")
        val widgetState = getAppWidgetState(
            context    = context,
            definition = stateDefinition as HomeWidgetGlanceStateDefinition,
            glanceId   = id
        ) as HomeWidgetGlanceState

        provideContent {
            GlanceTheme {
                ModernMinimalWidget(context, widgetState)
            }
        }
    }

    @Composable
    private fun ModernMinimalWidget(context: Context, state: HomeWidgetGlanceState) {
        val prefs = state.preferences
        val scheduleJson = prefs.getString("schedule", null)

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ImageProvider(R.drawable.widget_background_light))
                .clickable(
                    actionStartActivity(
                        ComponentName(context, MainActivity::class.java)
                    )
                ),
            contentAlignment = Alignment.TopStart
        ) {
            if (scheduleJson != null) {
                var scheduleName by remember { mutableStateOf("") }
                var lessons by remember { mutableStateOf<List<LessonItem>>(emptyList()) }
                var weekNumber by remember { mutableStateOf(1) }
                var formattedDate by remember { mutableStateOf("") }
                var dayType by remember { mutableStateOf("") }
                var hasLessons by remember { mutableStateOf(false) }
                val isSmallWidget = true 

                LaunchedEffect(scheduleJson) {
                    try {
                        withContext(Dispatchers.IO) {
                            val cal = Calendar.getInstance()
                            
                            val jsonObject = JSONObject(scheduleJson)
                            weekNumber = jsonObject.optInt("weekNumber", 0)
                            
                            val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                                .format(cal.time)

                            scheduleName = jsonObject.optString("group", "Расписание")

                            val todayLessons = parseSchedule(scheduleJson, today)
                            if (todayLessons.isEmpty()) {
                                cal.add(Calendar.DAY_OF_YEAR, 1)
                                val tomorrow = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                                    .format(cal.time)
                                val tomorrowLessons = parseSchedule(scheduleJson, tomorrow)
                                
                                if (tomorrowLessons.isEmpty()) {
                                    hasLessons = false
                                } else {
                                    lessons = tomorrowLessons
                                    hasLessons = true
                                    dayType = "tomorrow"
                                    formattedDate = formatDate(tomorrow)
                                }
                            } else {
                                lessons = todayLessons
                                hasLessons = true
                                dayType = "today"
                                formattedDate = formatDate(today)
                            }
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Error parsing schedule", e)
                        hasLessons = false
                    }
                }

                Column(
                    modifier = GlanceModifier
                        .fillMaxSize()
                        .padding(16.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = GlanceModifier.fillMaxWidth()
                    ) {
                        Column(
                            modifier = GlanceModifier.defaultWeight()
                        ) {
                            val dayLabel = when (dayType) {
                                "today" -> context.getString(R.string.widget_today)
                                "tomorrow" -> context.getString(R.string.widget_tomorrow)
                                else -> ""
                            }
                            
                            if (dayLabel.isNotEmpty()) {
                                Text(
                                    text = "$dayLabel, $formattedDate",
                                    style = TextStyle(
                                        color = ColorProvider(R.color.text_primary),
                                        fontWeight = FontWeight.Bold,
                                        fontSize = 15.sp
                                    )
                                )
                            }
                            
                            Text(
                                text = scheduleName,
                                style = TextStyle(
                                    color = ColorProvider(R.color.text_secondary),
                                    fontSize = 12.sp
                                ),
                                maxLines = 1
                            )
                        }
                        
                        Box(
                            modifier = GlanceModifier
                                .background(ImageProvider(R.drawable.week_badge))
                                .padding(horizontal = 8.dp, vertical = 4.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "$weekNumber",
                                style = TextStyle(
                                    color = ColorProvider(R.color.text_white),
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 12.sp
                                )
                            )
                        }
                    }
                    
                    Spacer(modifier = GlanceModifier.height(16.dp))
                    
                    if (hasLessons) {
                        Column {
                            val maxLessons = if (isSmallWidget) MAX_LESSONS_SMALL else MAX_LESSONS_REGULAR
                            val visibleLessons = lessons.take(maxLessons)
                            
                            visibleLessons.forEach { lesson ->
                                CompactLessonItem(lesson)
                                Spacer(modifier = GlanceModifier.height(12.dp))
                            }
                            
                            if (lessons.size > maxLessons) {
                                MoreIndicator(context, lessons.drop(maxLessons))
                            }
                        }
                    } else {
                        Box(
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .padding(top = 8.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = context.getString(R.string.widget_no_lessons),
                                style = TextStyle(
                                    color = ColorProvider(R.color.text_secondary),
                                    fontSize = 14.sp,
                                    textAlign = TextAlign.Center
                                )
                            )
                        }
                    }
                }
            } else {
                Box(
                    modifier = GlanceModifier
                        .fillMaxSize()
                        .padding(16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Нет доступного расписания",
                        style = TextStyle(
                            color = ColorProvider(R.color.text_secondary),
                            fontSize = 14.sp,
                            textAlign = TextAlign.Center
                        )
                    )
                }
            }
        }
    }
    
    @Composable
    private fun MoreIndicator(context: Context, remainingLessons: List<LessonItem>) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = GlanceModifier.padding(start = 4.dp, top = 6.dp, bottom = 2.dp)
        ) {
            Text(
                text = "+ ещё ${remainingLessons.size}",
                style = TextStyle(
                    color = ColorProvider(R.color.text_accent),
                    fontWeight = FontWeight.Medium,
                    fontSize = 13.sp
                )
            )
            
            Spacer(modifier = GlanceModifier.width(12.dp))
            
            val dotsToShow = minOf(remainingLessons.size, 3)
            
            for (i in 0 until dotsToShow) {
                Box(
                    modifier = GlanceModifier
                        .padding(horizontal = 5.dp)
                        .size(width = 4.dp, height = 18.dp)
                        .background(ColorProvider(getLessonTypeColorRes(remainingLessons[i].lessonType))),
                    contentAlignment = Alignment.Center
                ) {}
            }
        }
    }

    @Composable
    private fun CompactLessonItem(lesson: LessonItem) {
        Row(
            verticalAlignment = Alignment.Top,
            modifier = GlanceModifier.fillMaxWidth()
        ) {
            Column(
                horizontalAlignment = Alignment.Start,
                modifier = GlanceModifier.width(50.dp)
            ) {
                Text(
                    text = lesson.startTime.substring(0, 5),
                    style = TextStyle(
                        fontWeight = FontWeight.Bold,
                        fontSize = 16.sp,
                        color = ColorProvider(R.color.text_primary)
                    )
                )
            }
            
            Box(
                modifier = GlanceModifier
                    .padding(top = 2.dp)
                    .size(width = 4.dp, height = 36.dp)
                    .background(ColorProvider(getLessonTypeColorRes(lesson.lessonType))),
                contentAlignment = Alignment.Center
            ) {}
            
            Spacer(modifier = GlanceModifier.width(14.dp))
            
            Column(
                modifier = GlanceModifier.defaultWeight()
            ) {
                Text(
                    text = lesson.subject,
                    style = TextStyle(
                        fontWeight = FontWeight.Medium,
                        fontSize = 14.sp,
                        color = ColorProvider(R.color.text_primary)
                    ),
                    maxLines = 1
                )
                
                Text(
                    text = lesson.classroom,
                    style = TextStyle(
                        fontSize = 12.sp,
                        color = ColorProvider(R.color.text_secondary)
                    ),
                    maxLines = 1
                )
            }
        }
    }

    private fun getLessonTypeColorRes(lessonType: Int): Int = when (lessonType) {
        0 -> R.color.lesson_lecture
        1 -> R.color.lesson_lab
        2 -> R.color.lesson_practice
        3 -> R.color.lesson_selfwork
        4 -> R.color.lesson_exam
        5 -> R.color.lesson_credit
        6 -> R.color.lesson_consultation
        7, 8 -> R.color.lesson_coursework
        else -> R.color.lesson_lecture
    }

    private fun formatDate(dateString: String): String = try {
        val input = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val output = SimpleDateFormat("d MMMM", Locale("ru"))
        output.format(input.parse(dateString)!!)
    } catch (e: Exception) {
        dateString
    }

    private suspend fun parseSchedule(scheduleJson: String, date: String): List<LessonItem> {
        val list = mutableListOf<LessonItem>()
        JSONObject(scheduleJson).optJSONArray("schedule")?.let { arr ->
            for (i in 0 until arr.length()) {
                val obj = arr.getJSONObject(i)
                val dates = obj.optJSONArray("dates")
                if (dates != null && (0 until dates.length()).any { dates.getString(it).startsWith(date) }) {
                    list += LessonItem(
                        subject    = obj.optString("subject", "Неизвестно"),
                        lessonType = obj.optInt("lessonType", 0),
                        startTime  = obj.optString("startTime", "00:00"),
                        endTime    = obj.optString("endTime", "00:00"),
                        classroom  = obj.optString("classroom", "Неизвестно"),
                        number     = obj.optInt("number", 0),
                        teachers   = obj.optString("teachers", "")
                    )
                }
            }
        }
        return list.sortedBy { it.number }
    }

    data class LessonItem(
        val subject: String,
        val lessonType: Int,
        val startTime: String,
        val endTime: String,
        val classroom: String,
        val number: Int,
        val teachers: String
    )
}
