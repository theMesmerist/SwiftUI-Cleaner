//
//  AirPlayUtils.h
//  AirPlayUtils
//
//  v5.3 new AirPlay Services methods
//
//  Copyright (c) 2014 MarkelSoft, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import <ExternalAccessory/EAAccessoryManager.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSNetServices.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaPlaylist.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

//#import <iAd/iAd.h>

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


/**
 * Delegate protocol.  Implement this if you want to receive a notification when the
 * current address changes
 *
 * When the current address changes, LocationUtils will notify the delegate, passing
 * it the paths of the new address and the old address..
 */
@protocol AirPlayUtilsDelegate <NSObject>
- (void)didGetAirPlayServices:(NSMutableArray *)airPlayServicesNames summary:(NSString *)airPlayServicesStr;
@end

/*!
 * This class check some hardware (and software) informations
 */
@interface AirPlayUtils : NSObject <NSNetServiceBrowserDelegate,  NSNetServiceDelegate> {
    
    NSNetServiceBrowser * browser1;
    NSNetServiceBrowser * browser2;

    NSMutableArray * servicesQueue;
    NSMutableArray * servicesNames;
    NSMutableDictionary * servicesAddresses;
    NSString * servicesStr;
    
    NSMutableArray * airPlayServicesQueue;
    NSMutableArray * airPlayServicesNames;
    NSMutableDictionary * airPlayServicesAddresses;
    NSString * airPlayServicesStr;

    BOOL resolveBonjourServices;
    BOOL findingBonjourServices;    
    BOOL verbose;
}

@property(nonatomic, strong) id<AirPlayUtilsDelegate> delegate;

- (id)init;

+ (BOOL)isIOS8AndAbove;                  // check for if running iOS8+ and above

- (void)setVerbose:(BOOL)verbose;

- (void)sendNotifications:(id<AirPlayUtilsDelegate>)airPlayDelegate;
- (BOOL)isFindingServices;
- (int)getAirPlayServicesCount;
- (int)getServicesCount;
- (NSMutableArray *)getAirPlayServicesNames;
- (NSString *)getAirPlayServicesStr;

@end
