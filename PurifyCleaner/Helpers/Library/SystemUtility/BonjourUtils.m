//
//  BonjourUtils.m
//  Bonjour Services
//
//  v5.3 new Bonjour Services methods
//
//  Copyright (c) 2014 MarkelSoft, Inc. All rights reserved.
//

#import "BonjourUtils.h"

@implementation BonjourUtils

@synthesize delegate;

static BOOL autoRun = TRUE;

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
        NSLog(@"[BonjourUtils] setting up Bonjour Services...");
    
    servicesQueue = nil;
    servicesNames = nil;
    servicesAddresses = nil;
    browser1 = nil;
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

- (void)sendNotifications:(id<BonjourUtilsDelegate>)bonjourDelegate {
    
    // set delegate so can see updates as they come in...
    delegate = bonjourDelegate;
    
    if (!findingBonjourServices) {
        if (verbose)
            NSLog(@"refreshing Bonjour Services...");
        
        [self findBonjourServices];
    } else {
        if (verbose)
            NSLog(@"Bonjour Services already running...");
    }
    
    return;
}

- (BOOL)isFindingServices {
    
    return findingBonjourServices;
}

- (int)getServicesCount {
    int servicesCount = 0;
    
    if (servicesNames != nil)
        servicesCount = servicesNames.count;
    
    return servicesCount;
}

- (NSMutableArray *)getServicesNames {
 
    return servicesNames;
}

- (NSString *)getServicesStr {
    
    return servicesStr;
}

- (void)findBonjourServices {
    
    if (!findingBonjourServices)
        [self setupNetworkBrowsers];
    else
        NSLog(@"find of bonjour services already running...");
}

- (void)setupNetworkBrowsers {
    
    if (browser1 == nil) {
        browser1 = [[NSNetServiceBrowser alloc] init];
        [browser1 setDelegate:self];
    }
    
    if (servicesNames == nil)
        servicesNames = [[NSMutableArray alloc] init];
    else
        [servicesNames removeAllObjects];
    
    if (resolveBonjourServices) {
        if (servicesQueue== nil)
            servicesQueue = [[NSMutableArray alloc] init];
        else
            [servicesQueue removeAllObjects];
        
        if (servicesAddresses == nil)
            servicesAddresses = [[NSMutableDictionary alloc] init];
        else
            [servicesAddresses removeAllObjects];
    }
    
    if (verbose)
        NSLog(@"[BonjourUtils] do browser search...");
    
    [browser1 searchForServicesOfType:@"_http._tcp." inDomain:@""];
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
    //int port = [service port];
    
    //NSLog(@"name: %@ hostName: %@ adresses: %@ domain: %@ type: %@ port: %d", name, hostName, addresses, domain, type, port);
    
    if (verbose)
        NSLog(@"type is '%@'", type);
    
    if ([type isEqualToString:@"_http._tcp."]) {
        
        if (resolveBonjourServices)
            [servicesQueue addObject:[name copy]];
        
        [servicesNames addObject:[name copy]];
        
        bonjourService = TRUE;
        //NSLog(@"Bonjour service: %@", name);
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
        
        if (verbose)
            NSLog(@"%d Bonjour Services: %@",  servicesNames.count, servicesStr);

        findingBonjourServices = FALSE;
        
        if (delegate != nil) {
            if (verbose)
                NSLog(@"notifying delegate of acquiring Bonjour Services...");
            
            [delegate didGetBonjourServices:servicesNames summary:[servicesStr copy]];
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
    
    
    if ([type isEqualToString:@"_http._tcp."])
        bonjourService = TRUE;
    
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
        
    }
     **/
}

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    
    NSLog(@"did not resolve service...");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    
    NSLog(@"did remove service...");
}

@end
