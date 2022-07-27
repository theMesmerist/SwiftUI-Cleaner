//
//  LocationUtils.h
//  LocationUtils
//
//  v5.3 new location-based methods
//
//  Copyright (c) 2014 MarkelSoft, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import <ExternalAccessory/EAAccessoryManager.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSNetServices.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
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
@protocol LocationUtilsDelegate <NSObject>
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)fromLocation;
- (void)currentAddressChanged:(CLLocation *)currentLocation currentAddress:(NSString *)currentAddress oldAddress:(NSString *)oldAddress;
@end

/*!
 * This class check some hardware (and software) informations
 */
@interface LocationUtils : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager * locationManager;
    CLGeocoder * geocoder;

    CLLocation * oldLocation;
    
    MKPlacemark * currentAddressPlacemark;
    NSString * currentAddress;
    NSString * currentGPSSignal;
    NSString * currentHeading;
    
    NSString * currentFormattedLatitude;
    NSString * currentFormattedLongitude;
    NSString * currentFormattedAltitude;
    NSString * currentFormattedSpeed;

    int currentGPSSignalAccuracy;
    int currentHeadingAccuracy;
    
    BOOL isNewAddress;
    BOOL gettingAddress;
    
    BOOL verbose;
}

@property(nonatomic, strong) id<LocationUtilsDelegate> delegate;

@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic, retain) CLGeocoder * geocoder;
@property (nonatomic, retain) CLLocation * currentLocation;

- (id)init;

+ (BOOL)isIOS8AndAbove;                  // check for if running iOS8+ and above

- (void)setVerbose:(BOOL)verbose;
- (BOOL)locationServicesAreEnabled;

- (BOOL)isGettingAddress;
- (BOOL)isNewAddress;
- (NSString *)getCurrentAddress;
- (NSString *)getCurrentAddressNotify:(id<LocationUtilsDelegate>)locationDelegate;

- (CLLocationDistance)getDistanceFilter;
- (void)setDistanceFilter:(CLLocationDistance)distance;
- (CLLocationAccuracy)getDesiredAccuracy;
- (void)setDesiredAccuracy:(CLLocationAccuracy)accuracy;

- (CLLocation *)getCurrentLocation;
- (CLLocation *)getOldLocation;
- (BOOL)isSameLocation:(CLLocation *)location1 location2:(CLLocation*)location2;

- (CLLocationDistance)getDistanceBetween:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation;
- (NSString *)getFormattedDistanceBetween:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation;

- (CLLocationCoordinate2D)getCurrentCoordinate;
- (NSString *)getCurrentFormattedCoordinate;

- (float)getCurrentLatitude;
- (float)getCurrentLongitude;
- (float)getCurrentAltitude;
- (float)getCurrentSpeed;
- (NSString *)getCurrentFormattedLatitude;
- (NSString *)getCurrentFormattedLongitude;
- (NSString *)getCurrentFormattedAltitude;
- (NSString *)getCurrentFormattedSpeed;

- (NSString *)getCurrentGPSSignal;     // current GPS Signal Strength (uses horizontal accuracy to determine signal strength)
- (int)getCurrentGPSSignalAccuracy;    // current GPS Signal Horizontal Accuracy value

- (NSString *)getCurrentHeading;       // current GPS heading
- (int)getCurrentHeadingAccuracy;      // current heading accuracy


@end
