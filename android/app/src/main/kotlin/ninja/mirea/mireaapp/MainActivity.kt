package ninja.mirea.mireaapp

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity
import com.clostra.newnode.NewNode;

class MainActivity: FlutterActivity() {
    override protected fun onCreate(savedInstanceState: Bundle) {
        super.onCreate(savedInstanceState)
        NewNode.init()
    }
}
