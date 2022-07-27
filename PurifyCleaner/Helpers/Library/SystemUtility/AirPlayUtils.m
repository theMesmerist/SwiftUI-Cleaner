//
//  AirPlayUtils.m
//  AirPlayUtils
//
//  v5.3 new AirPlay Services methods
//
//  Copyright (c) 2014 MarkelSoft, Inc. All rights reserved.
//

#import "AirPlayUtils.h"

@implementation AirPlayUtils

@synthesize delegate;

- (id)init
{
    self = [super init];
    [self setup];

    return self;
}

- (void)setVerbose:(BOOL)_verbose {
    
    verbose = _verbose;
}

- (void)setup {
    
    if (verbose)
        NSLog(@"[AirPlayUtils] setting up AirPlay Services...");
    
    servicesQueue = nil;
    servicesNames = nil;
    servicesAddresses = nil;
    airPlayServicesQueue = nil;
    airPlayServicesNames = nil;
    airPlayServicesAddresses = nil;
    browser1 = nil;
    browser2 = nil;
    delegate = nil;
    resolveBonjourServices = FALSE;
    findingBonjourServices = FALSE;
    verbose = FALSE;
    
    [self findBonjourServices];
}

// check for if running iOS8+ and above
+ (BOOL)isIOS8AndAbove {
    BOOL result = FALSE;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        result = TRUE;
    
    return result;
}

- (void)sendNotifications:(id<AirPlayUtilsDelegate>)airPlayDelegate {
    
    // set delegate so can see updates as they come in...
    delegate = airPlayDelegate;
    
    if (!findingBonjourServices) {
        if (verbose)
            NSLog(@"refreshing AirPlay Services...");
        
        [self findBonjourServices];
    } else {
        if (verbose)
            NSLog(@"AirPlay Services alredy running...");
    }
    
    return;
}

- (BOOL)isFindingServices {
    
    return findingBonjourServices;
}

- (int)getAirPlayServicesCount {
    int airPlayServicesCount = 0;
    
    if (airPlayServicesNames != nil)
        airPlayServicesCount = airPlayServicesNames.count;
    
    return airPlayServicesCount;
}

- (int)getServicesCount {
    int servicesCount = 0;
    
    if (servicesNames != nil)
        servicesCount = servicesNames.count;
    
    return servicesCount;
}


- (NSMutableArray *)getAirPlayServicesNames {
    
    return airPlayServicesNames;
}

- (NSString *)getAirPlayServicesStr {
    
    return airPlayServicesStr;
}

- (void)findBonjourServices {
    
    if (!findingBonjourServices)
        [self setupNetworkBrowsers];
    else
        NSLog(@"find of bonjour services already running...");
}

- (void)setupNetworkBrowsers {
    
    /**
     if (browser1 == nil) {
        browser1 = [[NSNetServiceBrowser alloc] init];
        [browser1 setDelegate:self];
    }
     **/
    
    if (browser2 == nil) {
        browser2 = [[NSNetServiceBrowser alloc] init];
        [browser2 setDelegate:self];
    }
    
    if (servicesNames == nil)
        servicesNames = [[NSMutableArray alloc] init];
    else
        [servicesNames removeAllObjects];
    
    if (airPlayServicesNames == nil)
        airPlayServicesNames = [[NSMutableArray alloc] init];
    else
        [airPlayServicesNames removeAllObjects];
    
    if (resolveBonjourServices) {
        if (servicesQueue== nil)
            servicesQueue = [[NSMutableArray alloc] init];
        else
            [servicesQueue removeAllObjects];
        
        if (servicesAddresses == nil)
            servicesAddresses = [[NSMutableDictionary alloc] init];
        else
            [servicesAddresses removeAllObjects];
        
        if (airPlayServicesQueue== nil)
            airPlayServicesQueue = [[NSMutableArray alloc] init];
        else
            [airPlayServicesQueue removeAllObjects];
        
        if (airPlayServicesAddresses == nil)
            airPlayServicesAddresses = [[NSMutableDictionary alloc] init];
        else
            [airPlayServicesAddresses removeAllObjects];
    }
    
    //NSLog(@"[AirPlayUtils] do browser search...");
    //[browser1 searchForServicesOfType:@"_http._tcp." inDomain:@""];
    
    if (verbose)
        NSLog(@"[AirPlayUtils] do browser search...");

    [browser2 searchForServicesOfType:@"_airplay._tcp." inDomain:@""];
}

- (void)netServiceDidStop:(NSNetService *)sender {
    
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    
    //NSLog(@"will search...");
    findingBonjourServices = TRUE;
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    
    //NSLog(@"search stopped..");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary *)errorDict {
    
    //NSLog(@"did not search...");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domain moreComing:(BOOL)moreComing {
    
    //NSLog(@"found the Bonjour domain: %@", domain);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domain moreComing:(BOOL)moreComing {
    
    //NSLog(@"did remove domain...");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    
    if (verbose)
        NSLog(@"Found service");
    
    NSString * name = [service name];
    //NSString * hostName = [service hostName];
    //NSString * addresses = [service addresses];
    //NSString * domain = [service domain];
    NSString * type = [service type];
    BOOL bonjourService = FALSE;
    BOOL airPlayService = FALSE;
    //int port = [service port];
    
    //NSLog(@"name: %@ hostName: %@ adresses: %@ domain: %@ type: %@ port: %d", name, hostName, addresses, domain, type, port);
    
    if (verbose)
        NSLog(@"type is '%@'", type);
    
    if ([type isEqualToString:@"_http._tcp."]) {
        
        if (resolveBonjourServices)
            [servicesQueue addObject:[name copy]];
        
        [servicesNames addObject:[name copy]];
        
        bonjourService = TRUE;
        airPlayService = FALSE;
        //NSLog(@"Bonjour service: %@", name);
    }
    
    if ([type isEqualToString:@"_airplay._tcp."]) {
        
        if (resolveBonjourServices)
            [airPlayServicesQueue addObject:[name copy]];
        
        [airPlayServicesNames addObject:[name copy]];
        
        bonjourService = TRUE;
        airPlayService = FALSE;
        //NSLog(@"AirPlay service: %@", name);
    }
    
    //NSLog(@"found %@", name);
    
    if (resolveBonjourServices) {
        service.delegate = self;
        [service resolveWithTimeout:10];
    }
    
    if (!moreComing) {
        //NSLog(@"-found all services.");
        
        // show Bonjour Services...
        NSString * name = nil;
        int serviceCount = [servicesNames count];
        
        servicesStr = @"";
        
        if (serviceCount > 0)
            servicesStr = [NSString stringWithFormat:@"(%d) ", serviceCount];
        
        for (int i = 0; i < serviceCount; i++) {
            name = (NSString *)[servicesNames objectAtIndex:i];
            servicesStr = [servicesStr stringByAppendingString:name];
            
            if (i < serviceCount - 1)
                servicesStr = [servicesStr stringByAppendingString:@", "];
        }
        
        if (serviceCount == 0)
            servicesStr = @"No Bonjour services";
        
        //NSLog(@"info: %@", servicesStr);
        
        //[infoView3 setFieldValue:@"Bonjour Services" value:servicesStr];
        
        // show AirPlay services...
        NSString * airPlayName = nil;
        int airPlayServiceCount = [airPlayServicesNames count];

        airPlayServicesStr = @"";

        //NSLog(@"airplay service count %d", airPlayServiceCount);
        
        if (airPlayServiceCount > 0)
            airPlayServicesStr = [NSString stringWithFormat:@"(%d) ", airPlayServiceCount];
        
        for (int i = 0; i < airPlayServiceCount; i++) {
            airPlayName = (NSString *)[airPlayServicesNames objectAtIndex:i];
            airPlayServicesStr = [airPlayServicesStr stringByAppendingString:airPlayName];
            
            if (i < airPlayServiceCount - 1)
                airPlayServicesStr = [airPlayServicesStr stringByAppendingString:@", "];
        }
        
        if (airPlayServiceCount == 0)
            airPlayServicesStr = @"No AirPlay services";
        
        if (verbose)
            NSLog(@"%d AirPlay Services: %@", airPlayServicesNames.count, airPlayServicesStr);
        
        findingBonjourServices = FALSE;
        
        if (delegate != nil) {
            if (verbose)
                NSLog(@"notifying delegate of acquiring AirPlay Services...");
            
            [delegate didGetAirPlayServices:airPlayServicesNames summary:[airPlayServicesStr copy]];
        }
    }
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    
    //NSLog(@"in resolve...");
    
    /**
    NSString * name = [service name];
    //NSString * hostName = [service hostName];
    NSArray * addresses = [service addresses];
    NSString * address = nil;
    NSString * type = [service type];
    BOOL bonjourService = FALSE;
    BOOL airPlayService = FALSE;
    
    //NSLog(@"resolve %@", name);
    //NSLog(@"addresses count is %d", [addresses count]);
    //NSData * txtData = [service TXTRecordData];
    //NSLog(@"txtData is %@", txtData);
    
    
    if ([type isEqualToString:@"_http._tcp."]) {
        bonjourService = TRUE;
        airPlayService = FALSE;
    }
    
    if ([type isEqualToString:@"_airplay._tcp."]) {
        bonjourService = TRUE;
        airPlayService = FALSE;
    }
    
    for (int i = 0; i < [addresses count]; i++) {
        char addr[256];
        
        struct sockaddr *sa = (struct sockaddr *)[[addresses objectAtIndex:i] bytes];
        
        if(sa->sa_family == AF_INET)
        {
            struct sockaddr_in *sin = (struct sockaddr_in *)sa;
            
            if (inet_ntop(AF_INET, &sin->sin_addr, addr, sizeof(addr)))
            {
                NSLog(@"%s", addr);
                address = [NSString stringWithFormat:@"%s", addr];
                //break;
            }
        }
        else if(sa->sa_family == AF_INET6)
        {
            struct sockaddr_in6 * sin6 = (struct sockaddr_in6 *)sa;
            
            if (inet_ntop(AF_INET6, &sin6->sin6_addr, addr, sizeof(addr)))
            {
                NSLog(@"%s", addr);
                address = [NSString stringWithFormat:@"%s", addr];
                //break;
            }
        }
    }
    
    if (bonjourService) {
        [servicesAddresses setObject:[address copy] forKey:name];
        [servicesQueue removeObjectAtIndex:0];
        
        if ([servicesQueue count] == 0) {
            [servicesNames sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            NSLog(@"found all Bonjour services...");
            
        } else {
            
        }
        
        NSLog(@"found the Bonjour service: %@ at %@", name, address);
        
    } else if (airPlayService) {
        [airPlayServicesAddresses setObject:[address copy] forKey:name];
        [airPlayServicesQueue removeObjectAtIndex:0];
        
        if ([airPlayServicesQueue count] == 0) {
            [airPlayServicesNames sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            NSLog(@"found all AirPlay services...");
            
        } else {		
            
        }
        
        NSLog(@"found the AirPlay service: %@ at %@", name, address);
    }
     **/
}

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    
    if (verbose)
        NSLog(@"did not resolve service...");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    
    if (verbose)
        NSLog(@"did remove service...");
}

@end