package ninja.mirea.mireaapp

import io.flutter.embedding.android.FlutterFragment

class FriendsLocationFlutterFragment : FlutterFragment() {
    override fun shouldDestroyEngineWithHost(): Boolean =
        !FriendsLocationEngine.isRetained(flutterEngine)
}
