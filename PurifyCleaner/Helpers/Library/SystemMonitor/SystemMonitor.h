//
//  SystemMonitor.h
//  System Utilities
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
#import "DeviceSpecificUI.h"
#import "DeviceInfoController.h"
#import "CPUInfoController.h"

#import "BatteryInfo.h"
#import "BatteryInfoController.h"

#import "StorageInfoController.h"

@interface SystemMonitor : NSObject

- (id)init;

+ (DeviceInfo*)deviceInfo;
+ (DeviceSpecificUI*)deviceSpecificUI;

+ (CPUInfoController*)cpuInfoCtrl;

+ (BatteryInfoController*)batteryInfoCtrl;
+ (StorageInfoController*)storageInfoCtrl;

@end
