# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Retrofit
-keepattributes Signature
-keepattributes Exceptions

# OkHTTP
-dontwarn okhttp3.**
-keep class okhttp3.**{ *; }
-keep interface okhttp3.**{ *; }

# Other
-keepattributes *Annotation*
-keepattributes SourceFile, LineNumberTable

# Logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
    public static *** wtf(...);
}

-assumenosideeffects class io.flutter.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** w(...);
    public static *** e(...);
}

-assumenosideeffects class java.util.logging.Level {
    public static *** w(...);
    public static *** d(...);
    public static *** v(...);
}

-assumenosideeffects class java.util.logging.Logger {
    public static *** w(...);
    public static *** d(...);
    public static *** v(...);
}

# Removes third parties logging
-assumenosideeffects class org.slf4j.Logger {
    public *** trace(...);
    public *** debug(...);
    public *** info(...);
    public *** warn(...);
    public *** error(...);
}

# Keep Play Core library classes used for dynamic feature delivery
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep Flutter Deferred Components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.app.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager { *; }
-keepclassmembers class io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager {
    void installDeferredComponent(...);
}

# Firebase
-keep class com.google.firebase.** { *; }

# Device Calendar
-keep class com.builttoroam.devicecalendar.** { *; }

# Fix for missing class: SplitCompatApplication
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }

# Fix for missing classes related to SplitInstallManager and SplitInstallRequest
-keep class com.google.android.play.core.splitinstall.SplitInstallManager { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManagerFactory { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest$Builder { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallException { *; }

# Task handling in Play Core
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }
