package re.notifica.flutter.example;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import re.notifica.flutter.NotificarePushLibPlugin;

public class EmbeddingV1Activity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    FlutterAndroidLifecyclePlugin.registerWith(registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    PermissionHandlerPlugin.registerWith(registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    NotificarePushLibPlugin.registerWith(registrarFor("re.notifica.flutter.NotificarePushLibPlugin"));
  }
}
