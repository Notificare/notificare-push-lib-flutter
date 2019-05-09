#import "NotificarePushLibPlugin.h"
#import "NotificarePushLib.h"
#import "NotificarePushLibUtils.h"

@interface NotificarePushLibPlugin () <FlutterStreamHandler,NotificarePushLibDelegate>
@end

@implementation NotificarePushLibPlugin {
    FlutterMethodChannel *_channel;
    FlutterEventSink _eventSink;
    NSDictionary *_launchOptions;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"notificare_push_lib"
                                     binaryMessenger:[registrar messenger]];

    NotificarePushLibPlugin* instance = [[NotificarePushLibPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* eventsChannel = [FlutterEventChannel
                                          eventChannelWithName:@"notificare_push_lib/events"
                                          binaryMessenger:[registrar messenger]];
    [eventsChannel setStreamHandler:instance];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initializeWithKeyAndSecret" isEqualToString:call.method]) {
      [[NotificarePushLib shared] initializeWithKey:nil andSecret:nil];
      [[NotificarePushLib shared] setDelegate:self];
      [[NotificarePushLib shared] didFinishLaunchingWithOptions:_launchOptions];
      result([NSNull null]);
  } else if ([@"launch" isEqualToString:call.method]) {
      [[NotificarePushLib shared] launch];
      result([NSNull null]);
  } else if ([@"registerForNotifications" isEqualToString:call.method]) {
      [[NotificarePushLib shared] registerForNotifications];
      result([NSNull null]);
  } else if ([@"unregisterForNotifications" isEqualToString:call.method]) {
      [[NotificarePushLib shared] unregisterForNotifications];
      result([NSNull null]);
  } else if ([@"isRemoteNotificationsEnabled" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] remoteNotificationsEnabled]]);
  } else if ([@"isAllowedUIEnabled" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] allowedUIEnabled]]);
  } else if ([@"isNotificationFromNotificare" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] isNotificationFromNotificare:call.arguments]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)sendEvent:(NSDictionary*)event{
    if (!_eventSink) {
        return;
    }
    _eventSink(event);
}

#pragma mark Notificare Delegates
-(void)notificarePushLib:(NotificarePushLib *)library onReady:(NotificareApplication *)application{
    _eventSink(@{@"event":@"ready", @"body": [[NotificarePushLibUtils shared] dictionaryFromApplication:application]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didRegisterDevice:(nonnull NotificareDevice *)device{
    _eventSink(@{@"event":@"deviceRegistered", @"body": [[NotificarePushLibUtils shared] dictionaryFromDevice:device]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didChangeNotificationSettings:(BOOL)granted{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[NSNumber numberWithBool:granted] forKey:@"granted"];
    _eventSink(@{@"event":@"notificationSettingsChanged", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveLaunchURL:(NSURL *)launchURL{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[launchURL absoluteString] forKey:@"url"];
    _eventSink(@{@"event":@"launchUrlReceived", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveRemoteNotificationInBackground:(NotificareNotification *)notification withController:(id _Nullable)controller{
    _eventSink(@{@"event":@"remoteNotificationReceivedInBackground", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveRemoteNotificationInForeground:(NotificareNotification *)notification withController:(id _Nullable)controller{
    _eventSink(@{@"event":@"remoteNotificationReceivedInForeground", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveSystemNotificationInBackground:(NotificareSystemNotification *)notification{
    _eventSink(@{@"event":@"systemNotificationReceivedInBackground", @"body": [[NotificarePushLibUtils shared] dictionaryFromSystemNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveSystemNotificationInForeground:(NotificareSystemNotification *)notification{
    _eventSink(@{@"event":@"systemNotificationReceivedInForeground", @"body": [[NotificarePushLibUtils shared] dictionaryFromSystemNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveUnknownNotification:(NSDictionary *)notification{
    _eventSink(@{@"event":@"unknownNotificationReceived", @"body": notification});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveUnknownAction:(NSDictionary *)action forNotification:(NSDictionary *)notification{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:action forKey:@"action"];
    [payload setObject:notification forKey:@"notification"];
    _eventSink(@{@"event":@"unknownActionForNotificationReceived", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library willOpenNotification:(NotificareNotification *)notification{
    _eventSink(@{@"event":@"notificationWillOpen", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didOpenNotification:(NotificareNotification *)notification{
    _eventSink(@{@"event":@"notificationOpened", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didCloseNotification:(NotificareNotification *)notification{
    _eventSink(@{@"event":@"notificationClosed", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToOpenNotification:(NotificareNotification *)notification{
    _eventSink(@{@"event":@"notificationFailedToOpen", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didClickURL:(NSURL *)url inNotification:(NotificareNotification *)notification{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[url absoluteString] forKey:@"url"];
    [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromNotification:notification] forKey:@"notification"];
    _eventSink(@{@"event":@"urlClickedInNotification", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library willExecuteAction:(NotificareAction *)action{
    _eventSink(@{@"event":@"actionWillExecute", @"body": [[NotificarePushLibUtils shared] dictionaryFromAction:action]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didExecuteAction:(NotificareAction *)action{
    _eventSink(@{@"event":@"actionExecuted", @"body": [[NotificarePushLibUtils shared] dictionaryFromAction:action]});
}

- (void)notificarePushLib:(NotificarePushLib *)library shouldPerformSelectorWithURL:(NSURL *)url inAction:(NotificareAction *)action{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[url absoluteString] forKey:@"url"];
    [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromAction:action] forKey:@"action"];
    _eventSink(@{@"event":@"shouldPerformSelectorWithUrl", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didNotExecuteAction:(NotificareAction *)action{
    _eventSink(@{@"event":@"actionNotExecuted", @"body": [[NotificarePushLibUtils shared] dictionaryFromAction:action]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToExecuteAction:(NotificareAction *)action withError:(NSError *)error{
    _eventSink(@{@"event":@"actionFailedToExecute", @"body": [[NotificarePushLibUtils shared] dictionaryFromAction:action]});
}

/*
 * Uncomment this code to implement native PKPasses
 * Additionally you must import PassKit framework in the NotificareReactNativeIOS.h and implement PKAddPassesViewControllerDelegate in the PushHandler interface
 *
 - (void)notificarePushLib:(NotificarePushLib *)library didReceivePass:(NSURL *)pass inNotification:(NotificareNotification*)notification{
 
 NSData *data = [[NSData alloc] initWithContentsOfURL:pass];
 NSError *error;
 
 //init a pass object with the data
 PKPass * pkPass = [[PKPass alloc] initWithData:data error:&error];
 
 if(!error){
 //present view controller to add the pass to the library
 PKAddPassesViewController * vc = [[PKAddPassesViewController alloc] initWithPass:pkPass];
 [vc setDelegate:self];
 
 [[NotificarePushLib shared] presentWalletPass:notification inNavigationController:[[NotificareReactNativeIOS getInstance] navigationControllerForRootViewController] withController:vc];
 
 }
 
 }
 */

- (void)notificarePushLib:(NotificarePushLib *)library shouldOpenSettings:(NotificareNotification* _Nullable)notification{
    _eventSink(@{@"event":@"shouldOpenSettings", @"body": [[NotificarePushLibUtils shared] dictionaryFromNotification:notification]});
}

/*
- (void)notificarePushLib:(NotificarePushLib *)library didLoadInbox:(NSArray<NotificareDeviceInbox*>*)items{
    NSMutableArray * inboxItems = [NSMutableArray array];
    for (NotificareDeviceInbox * inboxItem in items) {
        [inboxItems addObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromDeviceInbox:inboxItem]];
    }
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"inboxLoaded" body:inboxItems];
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateBadge:(int)badge{
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"badgeUpdated" body:[NSNumber numberWithInt:badge]];
}


- (void)notificarePushLib:(NotificarePushLib *)library didFailToStartLocationServiceWithError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"locationServiceFailedToStart" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveLocationServiceAuthorizationStatus:(NotificareGeoAuthorizationStatus)status{
    
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateLocations:(NSArray<NotificareLocation*> *)locations{
    NSMutableArray * payload = [NSMutableArray new];
    for (NotificareLocation * location in locations) {
        [payload addObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromLocation:location]];
    }
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"locationsUpdated" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library monitoringDidFailForRegion:(id)region withError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"monitoringForRegionFailed" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didStartMonitoringForRegion:(id)region{
    
    if([region isKindOfClass:[NotificareRegion class]]){
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"monitoringForRegionStarted" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromRegion:region]];
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"monitoringForRegionStarted" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromBeacon:region]];
    }
}

- (void)notificarePushLib:(NotificarePushLib *)library didDetermineState:(NotificareRegionState)state forRegion:(id)region{
    
    NSMutableDictionary * payload = [NSMutableDictionary new];
    
    if (state == NotificareRegionStateInside) {
        [payload setObject:@"inside" forKey:@"state"];
    } else if (state == NotificareRegionStateOutside) {
        [payload setObject:@"outside" forKey:@"state"];
    } else if (state == NotificareRegionStateUnknown) {
        [payload setObject:@"unknown" forKey:@"state"];
    }
    
    if([region isKindOfClass:[NotificareRegion class]]){
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromRegion:region] forKey:@"region"];
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromRegion:region] forKey:@"region"];
    }
    
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"stateForRegionChanged" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didEnterRegion:(id)region{
    
    if([region isKindOfClass:[NotificareRegion class]]){
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"regionEntered" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromRegion:region]];
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"regionEntered" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromBeacon:region]];
    }
}

- (void)notificarePushLib:(NotificarePushLib *)library didExitRegion:(id)region{
    
    if([region isKindOfClass:[NotificareRegion class]]){
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"regionExited" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromRegion:region]];
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"regionExited" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromBeacon:region]];
    }
    
}

- (void)notificarePushLib:(NotificarePushLib *)library rangingBeaconsDidFailForRegion:(NotificareBeacon *)region withError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromBeacon:region] forKey:@"region"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"rangingBeaconsFailed" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRangeBeacons:(NSArray<NotificareBeacon *> *)beacons inRegion:(NotificareBeacon *)region{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    NSMutableArray * beaconsList = [NSMutableArray new];
    for (NotificareBeacon * beacon in beacons) {
        [beaconsList addObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromBeacon:beacon]];
    }
    [payload setObject:beaconsList forKey:@"beacons"];
    [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromBeacon:region] forKey:@"region"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"beaconsInRangeForRegion" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateHeading:(NotificareHeading*)heading{
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"headingUpdated" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromHeading:heading]];
}

- (void)notificarePushLib:(NotificarePushLib *)library didVisit:(NotificareVisit*)visit{
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"visitReceived" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromVisit:visit]];
}

- (void)notificarePushLib:(NotificarePushLib *)library didChangeAccountState:(NSDictionary *)info{
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"accountStateChanged" body:info];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToRenewAccountSessionWithError:(NSError * _Nullable)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"accountSessionFailedToRenewWithError" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveActivationToken:(NSString *)token{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:token forKey:@"token"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"activationTokenReceived" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveResetPasswordToken:(NSString *)token{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:token forKey:@"token"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"resetPasswordTokenReceived" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didLoadStore:(NSArray<NotificareProduct *> *)products{
    NSMutableArray * payload = [NSMutableArray array];
    for (NotificareProduct * product in products) {
        [payload addObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:product]];
    }
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"storeLoaded" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToLoadStore:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"storeFailedToLoad" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didCompleteProductTransaction:(SKPaymentTransaction *)transaction{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productTransactionCompleted" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response]];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRestoreProductTransaction:(SKPaymentTransaction *)transaction{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productTransactionRestored" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response]];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailProductTransaction:(SKPaymentTransaction *)transaction withError:(NSError *)error{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[error localizedDescription] forKey:@"error"];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productTransactionFailed" body:payload];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didStartDownloadContent:(SKPaymentTransaction *)transaction{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productContentDownloadStarted" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response]];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didPauseDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productContentDownloadPaused" body:payload];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didCancelDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productContentDownloadCancelled" body:payload];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveProgressDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productContentDownloadProgress" body:payload];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productContentDownloadFailed" body:payload];
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFinishDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromSKDownload:download]forKey:@"download"];
        [payload setObject:[[NotificareReactNativeIOSUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        [[NotificareReactNativeIOS getInstance] dispatchEvent:@"productContentDownloadFinished" body:payload];
    }];
}


- (void)notificarePushLib:(NotificarePushLib *)library didStartQRCodeScanner:(UIViewController*)scanner{
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"qrCodeScannerStarted" body:[NSNull null]];
}

- (void)notificarePushLib:(NotificarePushLib *)library didInvalidateScannableSessionWithError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"scannableSessionInvalidatedWithError" body:payload];
}

- (void)notificarePushLib:(NotificarePushLib *)library didDetectScannable:(NotificareScannable *)scannable{
    [[NotificareReactNativeIOS getInstance] dispatchEvent:@"scannableDetected" body:[[NotificareReactNativeIOSUtils shared] dictionaryFromScannable:scannable]];
}
 */

#pragma mark AppDelegate implementation
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (launchOptions != nil) {
        _launchOptions = launchOptions;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[NotificarePushLib shared] handleOpenURL:url withOptions:options];
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[url absoluteString] forKey:@"url"];
    [payload setObject:options forKey:@"options"];
    _eventSink(@{@"event":@"urlOpened", @"body": payload});
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [[NotificarePushLib shared] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[NotificarePushLib shared] didReceiveRemoteNotification:userInfo completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        if (!error) {
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }];
    return YES;
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler{
    [[NotificarePushLib shared] handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        completionHandler();
    }];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo completionHandler:(nonnull void (^)())completionHandler{
    [[NotificarePushLib shared] handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:nil completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        completionHandler();
    }];
}


#pragma mark FlutterStreamHandler implementation
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    return nil;
}

@end
