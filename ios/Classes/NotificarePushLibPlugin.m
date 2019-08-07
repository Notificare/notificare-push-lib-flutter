#import "NotificarePushLibPlugin.h"
#import "NotificarePushLib.h"
#import "NotificarePushLibUtils.h"
#import "UIImage+FromBundle.h"

@interface NotificarePushLibPlugin () <FlutterStreamHandler,NotificarePushLibDelegate>
@end

@implementation NotificarePushLibPlugin {
    FlutterMethodChannel *_channel;
    FlutterEventSink _eventSink;
    NSDictionary *_launchOptions;
}

#define NOTIFICARE_ERROR @"notificare_error"

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"notificare_push_lib"
                                     binaryMessenger:[registrar messenger]
                                     codec:[FlutterJSONMethodCodec sharedInstance]];

    NotificarePushLibPlugin* instance = [[NotificarePushLibPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* eventsChannel = [FlutterEventChannel
                                          eventChannelWithName:@"notificare_push_lib/events"
                                          binaryMessenger:[registrar messenger]
                                          codec: [FlutterJSONMethodCodec sharedInstance]];
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
  if ([@"launch" isEqualToString:call.method]) {
      [[NotificarePushLib shared] initializeWithKey:nil andSecret:nil];
      [[NotificarePushLib shared] launch];
      [[NotificarePushLib shared] setDelegate:self];
      [[NotificarePushLib shared] didFinishLaunchingWithOptions:_launchOptions];
      result(nil);
  } else if ([@"registerForNotifications" isEqualToString:call.method]) {
      [[NotificarePushLib shared] registerForNotifications];
      result(nil);
  } else if ([@"unregisterForNotifications" isEqualToString:call.method]) {
      [[NotificarePushLib shared] unregisterForNotifications];
      result(nil);
  } else if ([@"isRemoteNotificationsEnabled" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] remoteNotificationsEnabled]]);
  } else if ([@"isAllowedUIEnabled" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] allowedUIEnabled]]);
  } else if ([@"isNotificationFromNotificare" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] isNotificationFromNotificare:call.arguments]]);
  } else if ([@"fetchNotificationSettings" isEqualToString:call.method]) {
      if (@available(iOS 10.0, *)) {
          [[[NotificarePushLib shared] userNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
              result([[NotificarePushLibUtils shared] dictionaryFromNotificationSettings:settings]);
          }];
      } else {
          result(nil);
      }
  } else if ([@"startLocationUpdates" isEqualToString:call.method]) {
      [[NotificarePushLib shared] startLocationUpdates];
      result(nil);
  } else if ([@"stopLocationUpdates" isEqualToString:call.method]) {
      [[NotificarePushLib shared] stopLocationUpdates];
      result(nil);
  } else if ([@"isLocationServicesEnabled" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[NotificarePushLib shared] locationServicesEnabled]]);
  } else if ([@"registerDevice" isEqualToString:call.method]) {
      NSString* userID = (call.arguments[@"userID"]) ? call.arguments[@"userID"] : nil;
      NSString* userName = (call.arguments[@"userName"]) ? call.arguments[@"userName"] : nil;
      [[NotificarePushLib shared] registerDevice:userID withUsername:userName completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromDevice:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchDevice" isEqualToString:call.method]) {
      NotificareDevice * device = [[NotificarePushLib shared] myDevice];
      result([[NotificarePushLibUtils shared] dictionaryFromDevice:device]);
  } else if ([@"fetchPreferredLanguage" isEqualToString:call.method]) {
      result([[NotificarePushLib shared] preferredLanguage]);
  } else if ([@"updatePreferredLanguage" isEqualToString:call.method]) {
      NSString* preferredLanguage = call.arguments[@"preferredLanguage"];
      [[NotificarePushLib shared] updatePreferredLanguage:preferredLanguage completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(response);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchTags" isEqualToString:call.method]) {
      [[NotificarePushLib shared] fetchTags:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(response);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"addTag" isEqualToString:call.method]) {
      NSString* tag = call.arguments[@"tag"];
      [[NotificarePushLib shared] addTag:tag completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"addTags" isEqualToString:call.method]) {
      NSArray* tags = call.arguments[@"tags"];
      [[NotificarePushLib shared] addTags:tags completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"removeTag" isEqualToString:call.method]) {
      NSString* tag = call.arguments[@"tag"];
      [[NotificarePushLib shared] removeTag:tag completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"removeTags" isEqualToString:call.method]) {
      NSArray* tags = call.arguments[@"tags"];
      [[NotificarePushLib shared] removeTags:tags completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"clearTags" isEqualToString:call.method]) {
      [[NotificarePushLib shared] clearTags:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchUserData" isEqualToString:call.method]) {
      [[NotificarePushLib shared] fetchUserData:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareUserData * userData in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromUserData:userData]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"updateUserData" isEqualToString:call.method]) {
      NSArray* userData = call.arguments[@"userData"];
      NSMutableArray * data = [NSMutableArray array];
      for (NSDictionary * field in userData) {
          [data addObject:[[NotificarePushLibUtils shared] userDataFromDictionary:field]];
      }
      [[NotificarePushLib shared] updateUserData:data completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareUserData * userData in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromUserData:userData]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchDoNotDisturb" isEqualToString:call.method]) {
      [[NotificarePushLib shared] fetchDoNotDisturb:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromDeviceDnD:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"updateDoNotDisturb" isEqualToString:call.method]) {
      NSDictionary* deviceDnD = call.arguments[@"dnd"];
      [[NotificarePushLib shared] updateDoNotDisturb:[[NotificarePushLibUtils shared] deviceDnDFromDictionary:deviceDnD] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromDeviceDnD:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"clearDoNotDisturb" isEqualToString:call.method]) {
      [[NotificarePushLib shared] clearDoNotDisturb:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromDeviceDnD:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchNotification" isEqualToString:call.method]) {
      NSDictionary* notification = call.arguments[@"notification"];
      [[NotificarePushLib shared] fetchNotification:notification completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromNotification:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchNotificationForInboxItem" isEqualToString:call.method]) {
      NSDictionary* inboxItem = call.arguments[@"inboxItem"];
      [[NotificarePushLib shared] fetchNotification:[inboxItem objectForKey:@"inboxId"] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromNotification:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"presentNotification" isEqualToString:call.method]) {
      NSDictionary* notification = call.arguments[@"notification"];
      NotificareNotification * item = [[NotificarePushLibUtils shared] notificationFromDictionary:notification];
      id controller = [[NotificarePushLib shared] controllerForNotification:item];
      if ([self isViewController:controller]) {
          UINavigationController *navController = [self navigationControllerForViewControllers:controller];
          [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navController animated:NO completion:^{
              [[NotificarePushLib shared] presentNotification:item inNavigationController:navController withController:controller];
          }];
      } else {
          [[NotificarePushLib shared] presentNotification:item inNavigationController:[self navigationControllerForRootViewController] withController:controller];
      }
      result(nil);
  } else if ([@"fetchInbox" isEqualToString:call.method]) {
      [[[NotificarePushLib shared] inboxManager] fetchInbox:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareDeviceInbox * inboxItem in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromDeviceInbox:inboxItem]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"presentInboxItem" isEqualToString:call.method]) {
      NSDictionary* inboxItem = call.arguments[@"inboxItem"];
      NotificareDeviceInbox * item = [[NotificarePushLibUtils shared] deviceInboxFromDictionary:inboxItem];
      [[[NotificarePushLib shared] inboxManager] openInboxItem:item completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              if ([self isViewController:response]) {
                  UINavigationController *navController = [self navigationControllerForViewControllers:response];
                  [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navController animated:NO completion:^{
                      [[NotificarePushLib shared] presentInboxItem:item inNavigationController:navController withController:response];
                  }];
              } else {
                  [[NotificarePushLib shared] presentInboxItem:item inNavigationController:[self navigationControllerForRootViewController] withController:response];
              }
          }
      }];
      result(nil);
  } else if ([@"removeFromInbox" isEqualToString:call.method]) {
      NSDictionary* inboxItem = call.arguments[@"inboxItem"];
      [[[NotificarePushLib shared] inboxManager] removeFromInbox:[[NotificarePushLibUtils shared] deviceInboxFromDictionary:inboxItem] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromDeviceInbox:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"markAsRead" isEqualToString:call.method]) {
      NSDictionary* inboxItem = call.arguments[@"inboxItem"];
      [[[NotificarePushLib shared] inboxManager] markAsRead:[[NotificarePushLibUtils shared] deviceInboxFromDictionary:inboxItem] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromDeviceInbox:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"clearInbox" isEqualToString:call.method]) {
      [[[NotificarePushLib shared] inboxManager] clearInbox:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchAssets" isEqualToString:call.method]) {
      NSString* group = call.arguments[@"group"];
      [[NotificarePushLib shared] fetchAssets:group completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareAsset * asset in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromAsset:asset]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchPassWithSerial" isEqualToString:call.method]) {
      NSString* serial = call.arguments[@"serial"];
      [[NotificarePushLib shared] fetchPassWithSerial:serial completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromPass:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchPassWithBarcode" isEqualToString:call.method]) {
      NSString* barcode = call.arguments[@"barcode"];
      [[NotificarePushLib shared] fetchPassWithBarcode:barcode completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromPass:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchProducts" isEqualToString:call.method]) {
      [[NotificarePushLib shared] fetchProducts:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareProduct * product in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:product]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchPurchasedProducts" isEqualToString:call.method]) {
      [[NotificarePushLib shared] fetchPurchasedProducts:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareProduct * product in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:product]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchProduct" isEqualToString:call.method]) {
      NSDictionary* product = call.arguments[@"product"];
      [[NotificarePushLib shared] fetchProduct:[product objectForKey:@"productIdentifier"] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromProduct:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"buyProduct" isEqualToString:call.method]) {
      NSDictionary* product = call.arguments[@"product"];
      [[NotificarePushLib shared] fetchProduct:[product objectForKey:@"productIdentifier"] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              [[NotificarePushLib shared] buyProduct:response];
          }
      }];
      result(nil);
  } else if ([@"logCustomEvent" isEqualToString:call.method]) {
      NSString* name = call.arguments[@"name"];
      NSDictionary* data = (call.arguments[@"data"]) ? call.arguments[@"data"] : nil;
      [[NotificarePushLib shared] logCustomEvent:name withData:data completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"logOpenNotification" isEqualToString:call.method]) {
      NSDictionary* notification = call.arguments[@"notification"];
      NSMutableDictionary * eventData = [NSMutableDictionary dictionary];
      [eventData setObject:[notification objectForKey:@"id"] forKey:@"notification"];
      [[NotificarePushLib shared] logEvent:kNotificareEventNotificationOpen withData:eventData completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"logInfluencedNotification" isEqualToString:call.method]) {
      NSDictionary* notification = call.arguments[@"notification"];
      NSMutableDictionary * eventData = [NSMutableDictionary dictionary];
      [eventData setObject:[notification objectForKey:@"id"] forKey:@"notification"];
      [[NotificarePushLib shared] logEvent:kNotificareEventNotificationInfluenced withData:eventData completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"logReceiveNotification" isEqualToString:call.method]) {
      NSDictionary* notification = call.arguments[@"notification"];
      NSMutableDictionary * eventData = [NSMutableDictionary dictionary];
      [eventData setObject:[notification objectForKey:@"id"] forKey:@"notification"];
      [[NotificarePushLib shared] logEvent:kNotificareEventNotificationReceive withData:eventData completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"doCloudHostOperation" isEqualToString:call.method]) {
      NSString* verb = call.arguments[@"verb"];
      NSString* path = call.arguments[@"path"];
      NSDictionary* headers = (call.arguments[@"headers"]) ? call.arguments[@"headers"] : nil;
      NSDictionary* params = (call.arguments[@"params"]) ? call.arguments[@"params"] : nil;
      NSDictionary* body = (call.arguments[@"body"]) ? call.arguments[@"body"] : nil;
      [[NotificarePushLib shared] doCloudHostOperation:verb path:path URLParams:params customHeaders:headers bodyJSON:body completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(response);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"createAccount" isEqualToString:call.method]) {
      NSString* email = call.arguments[@"email"];
      NSString* name = call.arguments[@"name"];
      NSString* password = call.arguments[@"password"];
      [[[NotificarePushLib shared] authManager] createAccount:email withName:name andPassword:password completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"validateAccount" isEqualToString:call.method]) {
         NSString* token = call.arguments[@"token"];
         [[[NotificarePushLib shared] authManager] validateAccount:token completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
             if (!error) {
                 result(nil);
             } else {
                 result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                            message:error.localizedDescription
                                            details:nil]);
             }
         }];
  } else if ([@"resetPassword" isEqualToString:call.method]) {
      NSString* password = call.arguments[@"password"];
      NSString* token = call.arguments[@"token"];
      [[[NotificarePushLib shared] authManager] resetPassword:password withToken:token completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"sendPassword" isEqualToString:call.method]) {
      NSString* email = call.arguments[@"email"];
      [[[NotificarePushLib shared] authManager] sendPassword:email completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"login" isEqualToString:call.method]) {
      NSString* email = call.arguments[@"email"];
      NSString* password = call.arguments[@"password"];
      [[[NotificarePushLib shared] authManager] loginWithUsername:email andPassword:password completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"logout" isEqualToString:call.method]) {
      [[[NotificarePushLib shared] authManager] logoutAccount];
      result(nil);
  } else if ([@"isLoggedIn" isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[[[NotificarePushLib shared] authManager] isLoggedIn]]);
  } else if ([@"generateAccessToken" isEqualToString:call.method]) {
      [[[NotificarePushLib shared] authManager] generateAccessToken:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromUser:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"changePassword" isEqualToString:call.method]) {
      NSString* password = call.arguments[@"password"];
      [[[NotificarePushLib shared] authManager] changePassword:password completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchAccountDetails" isEqualToString:call.method]) {
      [[[NotificarePushLib shared] authManager] fetchAccountDetails:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result([[NotificarePushLibUtils shared] dictionaryFromUser:response]);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"fetchUserPreferences" isEqualToString:call.method]) {
      [[[NotificarePushLib shared] authManager] fetchUserPreferences:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              NSMutableArray * payload = [NSMutableArray array];
              for (NotificareUserPreference * preference in response) {
                  [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromUserPreference:preference]];
              }
              result(payload);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"addSegmentToUserPreference" isEqualToString:call.method]) {
      NSDictionary* segment = call.arguments[@"segment"];
      NSDictionary* userPreference = call.arguments[@"userPreference"];
      [[[NotificarePushLib shared] authManager] addSegment:[[NotificarePushLibUtils shared] segmentFromDictionary:segment] toPreference:[[NotificarePushLibUtils shared] userPreferenceFromDictionary:userPreference] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"removeSegmentFromUserPreference" isEqualToString:call.method]) {
      NSDictionary* segment = call.arguments[@"segment"];
      NSDictionary* userPreference = call.arguments[@"userPreference"];
      [[[NotificarePushLib shared] authManager] addSegment:[[NotificarePushLibUtils shared] segmentFromDictionary:segment] toPreference:[[NotificarePushLibUtils shared] userPreferenceFromDictionary:userPreference] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              result(nil);
          } else {
              result([FlutterError errorWithCode:NOTIFICARE_ERROR
                                         message:error.localizedDescription
                                         details:nil]);
          }
      }];
  } else if ([@"startScannableSession" isEqualToString:call.method]) {
      [[NotificarePushLib shared] startScannableSessionWithQRCode:[self navigationControllerForRootViewController] asModal:YES];
      result([NSNull null]);
  } else if ([@"presentScannable" isEqualToString:call.method]) {
      NSDictionary* scannable = call.arguments[@"scannable"];
      NotificareScannable * item = [[NotificarePushLibUtils shared] scannableFromDictionary:scannable];
      [[NotificarePushLib shared] openScannable:item completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
          if (!error) {
              if ([self isViewController:response]) {
                  UINavigationController *navController = [self navigationControllerForViewControllers:response];
                  [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navController animated:NO completion:^{
                      [[NotificarePushLib shared] presentScannable:item inNavigationController:navController withController:response];
                  }];
              } else {
                  [[NotificarePushLib shared] presentScannable:item inNavigationController:[self navigationControllerForRootViewController] withController:response];
              }
          }
      }];
      result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}


#pragma mark Helper Methods
-(void)close{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(UINavigationController*)navigationControllerForViewControllers:(id)object{
    UINavigationController *navController = [UINavigationController new];
    [[(UIViewController *)object navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageFromBundle:@"closeIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(close)]];
    return navController;
}

-(UINavigationController*)navigationControllerForRootViewController{
    UINavigationController * navController = (UINavigationController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    return navController;
}

-(BOOL)isViewController:(id)controller{
    BOOL result = YES;
    if ([[controller class] isEqual:[UIAlertController class]] ||
        [[controller class] isEqual:[SKStoreProductViewController class]] ||
        [[controller class] isEqual:[NSObject class]] ||
        controller == nil) {
        result = NO;
    }
    return result;
}

#pragma mark Event Sink
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


- (void)notificarePushLib:(NotificarePushLib *)library didLoadInbox:(NSArray<NotificareDeviceInbox*>*)items{
    NSMutableArray * inboxItems = [NSMutableArray array];
    for (NotificareDeviceInbox * inboxItem in items) {
        [inboxItems addObject:[[NotificarePushLibUtils shared] dictionaryFromDeviceInbox:inboxItem]];
    }
    _eventSink(@{@"event":@"inboxLoaded", @"body": inboxItems});
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateBadge:(int)badge{
    _eventSink(@{@"event":@"badgeUpdated", @"body": [NSNumber numberWithInt:badge]});
}


- (void)notificarePushLib:(NotificarePushLib *)library didFailToStartLocationServiceWithError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    _eventSink(@{@"event":@"locationServiceFailedToStart", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveLocationServiceAuthorizationStatus:(NotificareGeoAuthorizationStatus)status{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    
    if (status == NotificareGeoAuthorizationStatusDenied) {
        [payload setObject:@"denied" forKey:@"status"];
    } else if (status == NotificareGeoAuthorizationStatusRestricted) {
        [payload setObject:@"restricted" forKey:@"status"];
    } else if (status == NotificareGeoAuthorizationStatusNotDetermined) {
        [payload setObject:@"notDetermined" forKey:@"status"];
    } else if (status == NotificareGeoAuthorizationStatusAuthorizedAlways) {
        [payload setObject:@"always" forKey:@"status"];
    } else if (status == NotificareGeoAuthorizationStatusAuthorizedWhenInUse) {
        [payload setObject:@"whenInUse" forKey:@"status"];
    }

    _eventSink(@{@"event":@"locationServiceAuthorizationStatusReceived", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateLocations:(NSArray<NotificareLocation*> *)locations{
    NSMutableArray * payload = [NSMutableArray new];
    for (NotificareLocation * location in locations) {
        [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromLocation:location]];
    }
    _eventSink(@{@"event":@"locationsUpdated", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library monitoringDidFailForRegion:(id)region withError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    _eventSink(@{@"event":@"monitoringForRegionFailed", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didStartMonitoringForRegion:(id)region{
    
    if([region isKindOfClass:[NotificareRegion class]]){
        _eventSink(@{@"event":@"monitoringForRegionStarted", @"body": [[NotificarePushLibUtils shared] dictionaryFromRegion:region]});
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        _eventSink(@{@"event":@"monitoringForRegionStarted", @"body": [[NotificarePushLibUtils shared] dictionaryFromBeacon:region]});
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
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromRegion:region] forKey:@"region"];
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromRegion:region] forKey:@"region"];
    }
    
    _eventSink(@{@"event":@"stateForRegionChanged", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didEnterRegion:(id)region{
    
    if([region isKindOfClass:[NotificareRegion class]]){
        _eventSink(@{@"event":@"regionEntered", @"body": [[NotificarePushLibUtils shared] dictionaryFromRegion:region]});
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        _eventSink(@{@"event":@"regionEntered", @"body": [[NotificarePushLibUtils shared] dictionaryFromBeacon:region]});
    }
}

- (void)notificarePushLib:(NotificarePushLib *)library didExitRegion:(id)region{
    
    if([region isKindOfClass:[NotificareRegion class]]){
        _eventSink(@{@"event":@"regionExited", @"body": [[NotificarePushLibUtils shared] dictionaryFromRegion:region]});
    }
    
    if([region isKindOfClass:[NotificareBeacon class]]){
        _eventSink(@{@"event":@"regionExited", @"body": [[NotificarePushLibUtils shared] dictionaryFromBeacon:region]});
    }
    
}

- (void)notificarePushLib:(NotificarePushLib *)library rangingBeaconsDidFailForRegion:(NotificareBeacon *)region withError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromBeacon:region] forKey:@"region"];
    _eventSink(@{@"event":@"rangingBeaconsFailed", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didRangeBeacons:(NSArray<NotificareBeacon *> *)beacons inRegion:(NotificareBeacon *)region{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    NSMutableArray * beaconsList = [NSMutableArray new];
    for (NotificareBeacon * beacon in beacons) {
        [beaconsList addObject:[[NotificarePushLibUtils shared] dictionaryFromBeacon:beacon]];
    }
    [payload setObject:beaconsList forKey:@"beacons"];
    [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromBeacon:region] forKey:@"region"];
    _eventSink(@{@"event":@"beaconsInRangeForRegion", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didUpdateHeading:(NotificareHeading*)heading{
    _eventSink(@{@"event":@"headingUpdated", @"body": [[NotificarePushLibUtils shared] dictionaryFromHeading:heading]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didVisit:(NotificareVisit*)visit{
    _eventSink(@{@"event":@"visitReceived", @"body": [[NotificarePushLibUtils shared] dictionaryFromVisit:visit]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didChangeAccountState:(NSDictionary *)info{
    _eventSink(@{@"event":@"accountStateChanged", @"body": info});
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToRenewAccountSessionWithError:(NSError * _Nullable)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    _eventSink(@{@"event":@"accountSessionFailedToRenewWithError", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveActivationToken:(NSString *)token{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:token forKey:@"token"];
    _eventSink(@{@"event":@"activationTokenReceived", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveResetPasswordToken:(NSString *)token{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:token forKey:@"token"];
    _eventSink(@{@"event":@"resetPasswordTokenReceived", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didLoadStore:(NSArray<NotificareProduct *> *)products{
    NSMutableArray * payload = [NSMutableArray array];
    for (NotificareProduct * product in products) {
        [payload addObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:product]];
    }
    _eventSink(@{@"event":@"storeLoaded", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailToLoadStore:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    _eventSink(@{@"event":@"storeFailedToLoad", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didCompleteProductTransaction:(SKPaymentTransaction *)transaction{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        self->_eventSink(@{@"event":@"productTransactionCompleted", @"body": [[NotificarePushLibUtils shared] dictionaryFromProduct:response]});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didRestoreProductTransaction:(SKPaymentTransaction *)transaction{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        self->_eventSink(@{@"event":@"productTransactionRestored", @"body": [[NotificarePushLibUtils shared] dictionaryFromProduct:response]});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailProductTransaction:(SKPaymentTransaction *)transaction withError:(NSError *)error{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[error localizedDescription] forKey:@"error"];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        self->_eventSink(@{@"event":@"productTransactionFailed", @"body": payload});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didStartDownloadContent:(SKPaymentTransaction *)transaction{
    [[NotificarePushLib shared] fetchProduct:[[transaction payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        self->_eventSink(@{@"event":@"productContentDownloadStarted", @"body": [[NotificarePushLibUtils shared] dictionaryFromProduct:response]});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didPauseDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        self->_eventSink(@{@"event":@"productContentDownloadPaused", @"body": payload});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didCancelDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        self->_eventSink(@{@"event":@"productContentDownloadCancelled", @"body": payload});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didReceiveProgressDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        self->_eventSink(@{@"event":@"productContentDownloadProgress", @"body": payload});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFailDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromSKDownload:download] forKey:@"download"];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        self->_eventSink(@{@"event":@"productContentDownloadFailed", @"body": payload});
    }];
}

- (void)notificarePushLib:(NotificarePushLib *)library didFinishDownloadContent:(SKDownload *)download{
    [[NotificarePushLib shared] fetchProduct:[[[download transaction] payment] productIdentifier] completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * payload = [NSMutableDictionary new];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromSKDownload:download]forKey:@"download"];
        [payload setObject:[[NotificarePushLibUtils shared] dictionaryFromProduct:response] forKey:@"product"];
        self->_eventSink(@{@"event":@"productContentDownloadFinished", @"body": payload});
    }];
}


- (void)notificarePushLib:(NotificarePushLib *)library didStartQRCodeScanner:(UIViewController*)scanner{
    _eventSink(@{@"event":@"qrCodeScannerStarted", @"body": [NSNull null]});
}

- (void)notificarePushLib:(NotificarePushLib *)library didInvalidateScannableSessionWithError:(NSError *)error{
    NSMutableDictionary * payload = [NSMutableDictionary new];
    [payload setObject:[error localizedDescription] forKey:@"error"];
    _eventSink(@{@"event":@"scannableSessionInvalidatedWithError", @"body": payload});
}

- (void)notificarePushLib:(NotificarePushLib *)library didDetectScannable:(NotificareScannable *)scannable{
    _eventSink(@{@"event":@"scannableDetected", @"body": [[NotificarePushLibUtils shared] dictionaryFromScannable:scannable]});
}

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

/* Deprecated Action Methods for iOS 9 and 8
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
*/

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
