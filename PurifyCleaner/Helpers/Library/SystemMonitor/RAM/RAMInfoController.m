//
//  RAMInfoController.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <mach/mach.h>
#import <mach/mach_host.h>
#import "AMLogger.h"
#import "AMUtils.h"
#import "HardcodedDeviceData.h"
#import "RAMUsage.h"
#import "RAMInfoController.h"

@interface RAMInfoController()
@property (nonatomic, strong) RAMInfo           *ramInfo;

@property (nonatomic, assign) NSUInteger        ramUsageHistorySize;
- (void)pushRAMUsage:(RAMUsage*)ramUsage;

@property (nonatomic, strong) NSTimer           *ramUsageTimer;
- (void)ramUsageTimerCB:(NSNotification*)notification;

- (NSUInteger)getRAMTotal;
- (NSString*)getRAMType;
- (RAMUsage*)getRAMUsage;
@end

@implementation RAMInfoController
@synthesize delegate;
@synthesize ramUsageHistory;

@synthesize ramInfo;
@synthesize ramUsageHistorySize;
@synthesize ramUsageTimer;

#pragma mark - override

- (id)init
{
    if (self = [super init])
    {
        self.ramInfo = [[RAMInfo alloc] init];
        self.ramUsageHistory = [@[] mutableCopy];
        self.ramUsageHistorySize = 300;
    }
    return self;
}

#pragma mark - public

- (RAMInfo*)getRAMInfo
{    
    self.ramInfo.totalRam = [self getRAMTotal];
    self.ramInfo.ramType = [self getRAMType];

    return ramInfo;
}

- (void)startRAMUsageUpdatesWithFrequency:(NSUInteger)frequency
{
    [self stopRAMUsageUpdates];
    self.ramUsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / frequency
                                                          target:self
                                                        selector:@selector(ramUsageTimerCB:)
                                                        userInfo:nil
                                                         repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.ramUsageTimer forMode:NSRunLoopCommonModes];
    [self.ramUsageTimer fire];
}

- (void)stopRAMUsageUpdates
{
    [self.ramUsageTimer invalidate];
    self.ramUsageTimer = nil;
}

- (void)setRAMUsageHistorySize:(NSUInteger)size
{
    self.ramUsageHistorySize = size;
}

#pragma mark - private

- (void)ramUsageTimerCB:(NSNotification*)notification
{
    RAMUsage *usage = [self getRAMUsage];
    [self pushRAMUsage:usage];
    [self.delegate ramUsageUpdated:usage];
}

- (void)pushRAMUsage:(RAMUsage*)ramUsage
{
    [self.ramUsageHistory addObject:ramUsage];
    
    while (self.ramUsageHistory.count > self.ramUsageHistorySize)
    {
        [self.ramUsageHistory removeObjectAtIndex:0];
    }
}

- (NSUInteger)getRAMTotal
{
    return [NSProcessInfo processInfo].physicalMemory;
}

- (NSString*)getRAMType
{
    HardcodedDeviceData *hardcodedData = [HardcodedDeviceData sharedDeviceData];
    return (NSString*) [hardcodedData getRAMType];
}

- (RAMUsage*)getRAMUsage
{
    mach_port_t             host_port = mach_host_self();
    mach_msg_type_number_t  host_size = HOST_VM_INFO64_COUNT;
    vm_size_t               pageSize;
    vm_statistics64_data_t  vm_stat;
    
//    if (host_page_size(host_port, &pageSize) != KERN_SUCCESS)
//    {
//        AMLogWarn(@"host_page_size() has failed - defaulting to 4K");
//        pageSize = 4096;
//    }
    // There is a crazy bug(?) on iPhone 5S causing host_page_size give 16384, but host_statistics64 provide statistics
    // relative to 4096 page size. For the moment it is relatively safe to hardcode 4096 here, but in the upcomming updates
    // it can misbehaves very badly.
    pageSize = 4096;
    
    if (host_statistics64(host_port, HOST_VM_INFO64, (host_info64_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        AMLogWarn(@"host_statistics() has failed.");
        return nil;
    }
    
    RAMUsage *usage = [[RAMUsage alloc] init];
    usage.usedRam = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pageSize;
    usage.activeRam = vm_stat.active_count * pageSize;
    usage.inactiveRam = vm_stat.inactive_count * pageSize;
    usage.wiredRam = vm_stat.wire_count * pageSize;
    usage.freeRam = self.ramInfo.totalRam - usage.usedRam;
    usage.pageIns = vm_stat.pageins;
    usage.pageOuts = vm_stat.pageouts;
    usage.pageFaults = vm_stat.faults;
    return usage;
}

@end
