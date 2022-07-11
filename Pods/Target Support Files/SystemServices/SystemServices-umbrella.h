#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SystemServices.h"
#import "route.h"
#import "SSAccelerometerInfo.h"
#import "SSAccessoryInfo.h"
#import "SSApplicationInfo.h"
#import "SSBatteryInfo.h"
#import "SSCarrierInfo.h"
#import "SSDiskInfo.h"
#import "SSHardwareInfo.h"
#import "SSJailbreakCheck.h"
#import "SSLocalizationInfo.h"
#import "SSMemoryInfo.h"
#import "SSNetworkInfo.h"
#import "SSProcessInfo.h"
#import "SSProcessorInfo.h"
#import "SSUUID.h"

FOUNDATION_EXPORT double SystemServicesVersionNumber;
FOUNDATION_EXPORT const unsigned char SystemServicesVersionString[];

