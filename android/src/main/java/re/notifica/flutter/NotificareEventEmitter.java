package re.notifica.flutter;

import android.os.Handler;
import android.os.Looper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class NotificareEventEmitter {

    private static NotificareEventEmitter INSTANCE = null;
    private static final Object lock = new Object();

    private static final String EVENT_NAME_KEY = "event";
    private static final String EVENT_BODY_KEY = "body";

    private EventChannel.EventSink mEventSink;
    private List<Map<String, Object>> mEventQueue;


    private NotificareEventEmitter(EventChannel.EventSink eventSink) {
        mEventSink = eventSink;
        mEventQueue = new ArrayList<>();
    }

    public void sendEvent(String event, Object payload, boolean queue) {
        Map<String, Object> eventMap = new HashMap<>();
        eventMap.put(EVENT_NAME_KEY, event);
        eventMap.put(EVENT_BODY_KEY, payload);
        sendEventMap(eventMap, queue);
    }

    /**
     * Send event name,payload on main thread
     * @param eventMap
     */
    private void sendEventMap(final Map<String, Object> eventMap, boolean queue) {
        final EventChannel.EventSink eventSink = mEventSink;
        if (eventSink != null) {
            new Handler(Looper.getMainLooper()).post(() -> eventSink.success(eventMap));
        } else if (queue) {
            mEventQueue.add(eventMap);
        }
    }

    /**
     * Process queue of events
     */
    private void processEventQueue() {
        for (Map<String, Object> eventMap: mEventQueue) {
            sendEventMap(eventMap, false);
        }
        mEventQueue.clear();
    }

    /**
     * We have a listener
     * @param eventSink
     */
    public void onListen(EventChannel.EventSink eventSink) {
        mEventSink = eventSink;
        processEventQueue();
    }

    /**
     * We lost a listener
     */
    public void onCancel() {
        mEventSink = null;
    }

    public static NotificareEventEmitter getInstance() {

        synchronized (lock) {
            if (INSTANCE == null) {
                INSTANCE = new NotificareEventEmitter(null);
            }
            return INSTANCE;
        }
    }
}
