package re.notifica.flutter.example;

import io.flutter.app.FlutterApplication;
import re.notifica.Notificare;
import re.notifica.flutter.NotificareReceiver;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        Notificare.shared().setDebugLogging(true);
        Notificare.shared().launch(this);
        Notificare.shared().createDefaultChannel();
        Notificare.shared().setIntentReceiver(NotificareReceiver.class);
    }
}
