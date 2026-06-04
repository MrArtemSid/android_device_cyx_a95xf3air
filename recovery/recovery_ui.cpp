#include <recovery_ui/device.h>
#include <recovery_ui/screen_ui.h>

// 1. Custom UI Class to intercept hardware states
class Kvim3lRecoveryUI : public ScreenRecoveryUI {
  public:
    Kvim3lRecoveryUI() {}

    // CheckKey is evaluated by the input thread before keys enter the queue
    KeyAction CheckKey(int key, bool is_long_press) override {
        // If POWER (116) is long-pressed
        if (key == 116 && is_long_press) {
            // Inject a standard KEY_BACK (158) event into the queue
            EnqueueKey(158);
            // Return IGNORE so the original 116 long-press isn't processed twice
            return IGNORE;
        }
        // Let standard AOSP handle all other key states
        return ScreenRecoveryUI::CheckKey(key, is_long_press);
    }
};

// 2. Custom Device Class to map the queue to menu actions
class Kvim3lRecoveryDevice : public Device {
  public:
    Kvim3lRecoveryDevice(ScreenRecoveryUI* ui) : Device(ui) {}

    int HandleMenuKey(int key, bool visible) override {
        if (visible) {
            if (key == 102) {
                return kInvokeItem;     // Home (102) -> Confirm / Select
            }
            if (key == 116) {
                return kHighlightDown;  // Power (116 Short) -> Navigate / Scroll Down
            }
            if (key == 158) {
                return kGoBack;         // Intercepted Long-Press (158) -> Go Back
            }
        }
        return Device::HandleMenuKey(key, visible);
    }
};

// 3. Entry point
Device* make_device() {
    // Pass our custom UI class into our custom Device class
    return new Kvim3lRecoveryDevice(new Kvim3lRecoveryUI());
}
