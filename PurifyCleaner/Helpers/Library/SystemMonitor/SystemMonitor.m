//
//  SystemMonitor.m
//  System Utilities
//

#import "SystemMonitor.h"

//#import <HockeySDK/HockeySDK.h>
#import "AMLogger.h"
#import "HardcodedDeviceData.h"
#import "AMUtils.h"

@interface SystemMonitor () //<BITHockeyManagerDelegate>

@property (nonatomic, strong) DeviceInfo        * deviceInfo;
@property (nonatomic, strong) DeviceSpecificUI  * deviceSpecificUI;
@property (nonatomic, strong) CPUInfoController * cpuInfoCtrl;

@property (nonatomic, strong) BatteryInfoController * batteryInfoCtrl;
@property (nonatomic, strong) StorageInfoController * storageInfoCtrl;

@end

@implementation SystemMonitor

- (id)init
{
    if (self = [super init]) {
        
        
        // Initialize logger
        [AMLogger sharedLogger];
    }
    return self;
}

//-----------------------------------------------
// BITHockeyManagerDelegate
//-----------------------------------------------

#pragma mark - 

static SystemMonitor * _share;
+ (SystemMonitor*)share {
    if (_share == nil) {
        _share = [[SystemMonitor alloc] init];
    }
    return _share;
}

+ (DeviceInfo*)deviceInfo
{
    if ([self share].deviceInfo == nil) {
        [self share].deviceInfo = [[[DeviceInfoController alloc] init] getDeviceInfo];
    }
    return [self share].deviceInfo;
}

+ (DeviceSpecificUI*)deviceSpecificUI
{
    if ([self share].deviceSpecificUI == nil) {
        [self share].deviceSpecificUI = [[DeviceSpecificUI alloc] init];
    }
    return [self share].deviceSpecificUI;
}

+ (CPUInfoController*)cpuInfoCtrl
{
    if ([self share].cpuInfoCtrl == nil) {
        [self share].cpuInfoCtrl = [[CPUInfoController alloc] init];
        [self.cpuInfoCtrl startCPULoadUpdatesWithFrequency:2];
    }
    return [self share].cpuInfoCtrl;
}

+ (BatteryInfoController*)batteryInfoCtrl
{
    if ([self share].batteryInfoCtrl == nil) {
        [self share].batteryInfoCtrl = [[BatteryInfoController alloc] init];
        [[self share].batteryInfoCtrl startBatteryMonitoring];
    }
    return [self share].batteryInfoCtrl;
}

+ (StorageInfoController*)storageInfoCtrl
{
    if ([self share].storageInfoCtrl == nil) {
        [self share].storageInfoCtrl = [[StorageInfoController alloc] init];
    }
    return [self share].storageInfoCtrl;
}

@end
