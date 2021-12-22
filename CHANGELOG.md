## 2.7.3
- Update native iOS dependency
- Update native Android dependency
- Remove dependency on JCenter

## 2.7.2
- Fix inbox item extra parsing

## 2.7.1
- Update native iOS dependency

## 2.7.0
- Update native dependencies
- Fix notification opens from cold app start
- Fix notification content (map) parsing

## 2.7.0-beta.1
- Update native Android dependency to 2.7.0-beta.5
- Update native iOS dependency to 2.7-beta2
- Add handled flags for openUrl and continueUserActivity

##### BREAKING CHANGE: ANDROID NOTIFICATION TRAMPOLINE
Add the following to your `Manifest.xml`:

```xml
<activity android:name=".MainActivity">

    <!-- existing intent filters  -->

    <intent-filter>
        <action android:name="re.notifica.intent.action.RemoteMessageOpened" />
        <category android:name="android.intent.category.DEFAULT" />
    </intent-filter>

</activity>
```

For more information about this subject please take a look at [this](https://github.com/Notificare/notificare-push-lib-android-src/blob/2.7-dev/UPGRADE.md#breaking-change-trampoline-intents) section.

##### BREAKING CHANGE: ANDROID BLUETOOTH PERMISSION
From Android 12 and up, bluetooth scanning permissions have to be requested at runtime. This impacts the geofencing functionality of our library.

## 2.6.2
- Prevent the plugin from stopping the events propagation

## 2.6.1
- Update native Android dependency
- Update native iOS dependency
- Handle test device registration
- Fix notification serialisation

## 2.6.0
- Fix preferred language update
- Add null safety support

## 2.5.4
- Update native iOS dependency
- Improve present notifications, inbox items & scannables transition & styling 

## 2.5.3
- Prevent crash on mapping inbox items without a notification
- Update native Android dependency
- Update native iOS dependency

## 2.5.2
* Fix WidgetsBindingObserver lifecycle issue
* Fix un-launch related inbox crash

## 2.5.1
* Add `extra` to assets
* Allow nullable asset URLs 

## 2.5.0
* Update native Android SDK to 2.5.0
* Update native iOS SDK to 2.5.0
* Add beacon scanning foreground service
* Add iOS 14 presentation options

## 2.4.0-beta.2
* Add `targetContentIdentifier` to `NotificareNotification`
* Update native iOS SDK to v2.4.0-beta.7

## 2.4.0-beta.1
* update native SDKs to v2.4.0-beta
* refactor Billing Manager integration
* add `unknownNotificationReceivedInBackground` and `unknownNotificationReceivedInForeground` events on iOS
* add `markAllAsRead` method
* add `accuracy` to `NotificareDevice`
* add support for Dynamic Links
* add 'ephemeral' authorization status
* add `requestAlwaysAuthorizationForLocationUpdates` and `requestTemporaryFullAccuracyAuthorization` methods
* add `fetchLink` helper method

## 2.3.2
* Fix `updateUserData` method consistency between platforms

## 2.3.1
* add 'urlOpened' event on Android

## 2.3.0
* update Android SDK to v2.3.0
* update iOS SDK to v2.3.2
* allow `carPlay` in authorization options

## 2.2.6
* fix example's plugin registration
* update example's Android SDK to v2.2.3

## 2.2.5
* migrated Android Plugin to new Flutter 1.12 API
* fix fetching device dnd for fresh installations
* fix custom params & headers on cloud API requests
* fix beacons parsing when the result is empty
* added method to send a password reset email
* fix user mapping
* enhance NotificareUser model
* fix handling new intents
* fix scannable session
* fix notification parsing without an inbox item id
* fix logout method
* fix region monitoring

## 2.2.4
* check partially fetched notifications when fetching inbox items 

## 2.2.3
* updated to iOS SDK 2.2.6

## 2.2.2
* updated to iOS SDK 2.2.4
* changes in isViewController method

## 2.2.1
* updated to Android SDK 2.2.1
* updated to iOS SDK 2.2.3

## 2.2.0
* added noops for Android-only calls in iOS
* fixed changePassword method
* updated to Android SDK 2.2.0

## 2.0.1
* added static_framework flag

## 2.0.0
* Updated to Notificare Android SDK 2.1.0
* Updated to Notificare iOS SDK 2.2.0 (Required Xcode 11 and iOS13 SDK to build it)
* Added new method clearDeviceLocation for iOS

## 1.0.4
* Added missing properties to inbox model

## 1.0.3
* Added authorization options for iOS
* Added presentation options for iOS
* Added category options for iOS
* cleaned up parameter types in all models
* Return inboxItem on remove and markAsRead
* Update Notificare iOS library to 2.1.6
* Fixed parameter in removedInboxItem method

## 1.0.2
* Updated description

## 1.0.1
* Updated dependencies

## 1.0.0
* Initial release.
