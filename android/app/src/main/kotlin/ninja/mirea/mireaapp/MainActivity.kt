package ninja.mirea.mireaapp

import android.os.Bundle;
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import com.clostra.newnode.NewNode;

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        NewNode.init()
    }
}
