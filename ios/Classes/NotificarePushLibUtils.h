//
//  NotificarePushLibUtils.h
//  notificare_push_lib
//
//  Created by Joel Oliveira on 08/05/2019.
//

#import <Foundation/Foundation.h>
#import "NotificarePushLib.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificarePushLibUtils : NSObject

+ (NotificarePushLibUtils *)shared;

-(NSDictionary *)dictionaryFromApplication:(NotificareApplication *)application;

-(NSDictionary *)dictionaryFromDevice:(NotificareDevice *)device;

-(NSDictionary *)dictionaryFromUserData:(NotificareUserData *)userData;
-(NotificareUserData *)userDataFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromDeviceDnD:(NotificareDeviceDnD *)deviceDnD;
-(NotificareDeviceDnD *)deviceDnDFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromNotification:(NotificareNotification *)notification;
-(NotificareNotification *)notificationFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromSystemNotification:(NotificareSystemNotification *)notification;

-(NSDictionary *)dictionaryFromAction:(NotificareAction *)action;
-(NotificareAction *)actionFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromDeviceInbox:(NotificareDeviceInbox *)deviceInbox;
-(NotificareDeviceInbox *)deviceInboxFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromAsset:(NotificareAsset *)asset;

-(NSDictionary *)dictionaryFromPass:(NotificarePass *)pass;

-(NSDictionary *)dictionaryFromProduct:(NotificareProduct *)product;

-(NSDictionary *)dictionaryFromUser:(NotificareUser *)user;

-(NSDictionary *)dictionaryFromUserPreference:(NotificareUserPreference *)preference;
-(NotificareUserPreference *)userPreferenceFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromSegment:(NotificareSegment *)segment;
-(NotificareSegment *)segmentFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromLocation:(NotificareLocation *)location;

-(NSDictionary *)dictionaryFromBeacon:(NotificareBeacon *)beacon;

-(NSDictionary *)dictionaryFromRegion:(NotificareRegion *)region;

-(NSDictionary *)dictionaryFromHeading:(NotificareHeading *)heading;

-(NSDictionary *)dictionaryFromVisit:(NotificareVisit *)visit;

-(NSDictionary *)dictionaryFromSKDownload:(SKDownload *)download;

-(NSDictionary *)dictionaryFromScannable:(NotificareScannable *)scannable;
-(NotificareScannable *)scannableFromDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)dictionaryFromNotificationSettings:(UNNotificationSettings *)settings;

@end

NS_ASSUME_NONNULL_END
