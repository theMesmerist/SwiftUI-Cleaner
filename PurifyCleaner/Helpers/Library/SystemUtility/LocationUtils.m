//
//  LocationUtils.m
//  LocationUtils
//
//  v5.3 new location-based methods
//
//  Copyright (c) 2014 MarkelSoft, Inc. All rights reserved.
//

#import "LocationUtils.h"

@implementation LocationUtils

@synthesize locationManager;
@synthesize geocoder;
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
        NSLog(@"[LocationUtils] setting up location manager...");
    
    verbose = FALSE;
    oldLocation = nil;
    currentAddressPlacemark = nil;
    currentAddress = nil;
    currentGPSSignal = nil;
    currentGPSSignalAccuracy = -1;
    currentHeadingAccuracy = -1;
    currentFormattedLatitude = nil;
    currentFormattedLongitude = nil;
    currentFormattedAltitude = nil;
    currentFormattedSpeed = nil;
    delegate = nil;
    isNewAddress = FALSE;
    gettingAddress = TRUE;

    // start location manager...
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; // send update to this object
    
    // for iOS8+
    if ([LocationUtils isIOS8AndAbove] && [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.geocoder = [[CLGeocoder alloc] init];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    if ([self locationServicesAreEnabled]) {
        if (verbose)
            NSLog(@"location manager enabled");
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    } else {
        if (verbose)
            NSLog(@"location manager not enabled");
        //NSString * msg = @"Location information is required!  Please turn on the Location Services in Settings and restart.";
        //UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //[alert show];
    }

}

// check for if running iOS8+ and above
+ (BOOL)isIOS8AndAbove {
    BOOL result = FALSE;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        result = TRUE;
    
    return result;
}

- (BOOL)locationServicesAreEnabled {
    BOOL enabled = FALSE;
    
    if ([CLLocationManager locationServicesEnabled]) {
        enabled = TRUE;
    }

    return enabled;
}

- (BOOL)isNewAddress {
    
    return isNewAddress;
}

- (BOOL)isGettingAddress {
    
    return gettingAddress;
}

- (CLLocationDistance)getDistanceFilter {
    
    return self.locationManager.distanceFilter;
}

- (void)setDistanceFilter:(CLLocationDistance)distance {
    
    self.locationManager.distanceFilter = distance;
}

- (CLLocationAccuracy)getDesiredAccuracy {
    
    return self.locationManager.desiredAccuracy;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)accuracy {
    
    self.locationManager.desiredAccuracy = accuracy;
}

- (CLLocation *)getCurrentLocation {
    
    return self.locationManager.location;
}

- (CLLocation * )getOldLocation {
    
    return oldLocation;
}

// see if 2 locations are the same location
- (BOOL)isSameLocation:(CLLocation *)location1 location2:(CLLocation*)location2 {
    BOOL result = FALSE;
    
    if (location1 != nil && location2 != nil &&
        location1.coordinate.latitude == location2.coordinate.latitude &&
        location1.coordinate.longitude == location2.coordinate.longitude)
        result = TRUE;
    
    return result;
}

- (CLLocationDistance)getDistanceBetween:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation {
    CLLocationDistance distance;
    
    if (fromLocation != nil && toLocation != nil) {
        distance = [toLocation distanceFromLocation:fromLocation];
    }
    
    return distance;
}

- (NSString *)getFormattedDistanceBetween:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation {
    NSString * formattedDistance = nil;
    
    if (fromLocation != nil && toLocation != nil) {
        CLLocationDistance distanceMoved = [toLocation distanceFromLocation:fromLocation];
        float distance = distanceMoved * 3.2808399;   // get in feet (from meters)
        float distanceMeters = distanceMoved * 1;   // get in meters
        
        if (distance > 5280) {
            float distanceMiles = distance / 5280;
            formattedDistance = [NSString stringWithFormat:@"%.2lf miles (%.2lf m)", distanceMiles, distanceMeters];
        } else {
            formattedDistance = [NSString stringWithFormat:@"%.2lf ft (%.2lf m)", distance, distanceMeters];
        }
    }
    
    return formattedDistance;
}

- (CLLocationCoordinate2D)getCurrentCoordinate {
    
    return [self getCurrentLocation].coordinate;
}

- (NSString *)getCurrentFormattedCoordinate {
    NSString * currentFormattedCoordinate = nil;
    
    @try {
        CLLocationCoordinate2D currentCoordinate = [self getCurrentCoordinate];
        
        // latitude
        NSString * currentLatitudeDirection = signbit(currentCoordinate.latitude) ? @"S" : @"N";
        int dlat = fabs(currentCoordinate.latitude);
        float flat = fabs(currentCoordinate.latitude) - dlat;
        int dlat2 = flat * 60;
        NSString * latitudeStr = [NSString stringWithFormat:@"%d\u00b0 %d' %@", dlat, dlat2, currentLatitudeDirection];
        
        // longitude
        NSString * currentLongitudeDirection = signbit(currentCoordinate.longitude) ? @"W" : @"E";
        int dlng = fabs(currentCoordinate.longitude);
        float flng = fabs(currentCoordinate.longitude) - dlng;
        int dlng2 = flng * 60;
        NSString * longitudeStr = [NSString stringWithFormat:@"%d\u00b0 %d' %@", dlng, dlng2, currentLongitudeDirection];

        currentFormattedCoordinate = [NSString stringWithFormat:@"%@ %@", latitudeStr, longitudeStr];
    }
    @catch (NSException * ex) {
        NSLog(@"[getCurrentFormattedCoordinate] error: %@", [ex description]);
    }

    return currentFormattedCoordinate;
}

- (float)getCurrentLatitude {
    float currentLatitude = 0.00;
    
    CLLocation * currentLocation = [self getCurrentLocation];
    
    if (currentLocation != nil) {
        CLLocationCoordinate2D currentCoordinate = [self getCurrentCoordinate];
        currentLatitude = currentCoordinate.latitude;
    }
    
    return currentLatitude;
}

- (float)getCurrentLongitude {
    float currentLongitude = 0.00;
    
    CLLocation * currentLocation = [self getCurrentLocation];
    
    if (currentLocation != nil) {
        CLLocationCoordinate2D currentCoordinate = [self getCurrentCoordinate];
        currentLongitude = currentCoordinate.longitude;
    }
    
    return currentLongitude;
}

- (float)getCurrentAltitude {
    float currentAltitude = 0.00;
    
    CLLocation * currentLocation = [self getCurrentLocation];
    
    if (currentLocation != nil)
        currentAltitude = currentLocation.altitude;
    
    return currentAltitude;
}

- (float)getCurrentSpeed {
    float currentSpeed = 0.00;
    
    CLLocation * currentLocation = [self getCurrentLocation];

    if (currentLocation != nil)
        currentSpeed = currentLocation.speed;
    
    if (currentSpeed < 0.0)
        currentSpeed = 0.00;
    
    return currentSpeed;
}

- (NSString *)getCurrentAddress {
    
    return currentAddress;
}

- (NSString *)getCurrentAddressNotify:(id<LocationUtilsDelegate>)locationDelegate {

    // set delegate so can see updates as they come in...
    delegate = locationDelegate;
    
    // return current address..
    
    return currentAddress;
}

- (NSString *)getCurrentGPSSignal {
    
    return currentGPSSignal;
}

- (int)getCurrentGPSSignalAccuracy {
    
    return currentGPSSignalAccuracy;
}

- (NSString *)getCurrentHeading {
    
    return currentHeading;
}

- (int)getCurrentHeadingAccuracy {
    
    return currentHeadingAccuracy;
}

- (NSString *)getCurrentFormattedLatitude {
    
    return currentFormattedLatitude;
}

- (NSString *)getCurrentFormattedLongitude {
    
    return currentFormattedLongitude;
}

- (NSString *)getCurrentFormattedAltitude {
    
    return currentFormattedAltitude;
}

- (NSString *)getCurrentFormattedSpeed {
    
    return currentFormattedSpeed;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    
    if (verbose) {
        NSLog(@"[LocationUtils] updated heading...");
        NSLog(@"[LocationUtils] heading accuracy: %f", heading.headingAccuracy);
    }
    
    if (delegate != nil) {
        if (verbose)
            NSLog(@"notifying delegate of heading change...");
        
        [delegate locationManager:manager didUpdateHeading:heading];
    }
    
    NSString * directionStr = @"Not Available";
    int accuracy = [heading headingAccuracy];
    
    if (accuracy > 0) {
        CLLocationDirection direction = heading.trueHeading;
        //NSLog(@"true heading: %.f", direction);
        //CLLocationDirection direction2 = heading.magneticHeading;
        //NSLog(@"megnetic heading: %.f", direction2);
        
        if (direction == 0)
            directionStr = @"North";
        else if (direction == 90)
            directionStr = @"East";
        else if (direction == 180)
            directionStr = @"South";
        else if (direction == 270)
            directionStr = @"West";
        else if (direction > 0 && direction < 90)
            directionStr = @"Northeast";
        else if  (direction > 90 && direction < 180)
            directionStr = @"Southeast";
        else if (direction > 180 && direction < 270)
            directionStr = @"Southwest";
        else if (direction > 270)
            directionStr = @"Northwest";
    } else {
        directionStr = @"Not Available";
    }
    
    currentHeadingAccuracy = accuracy;
    currentHeading = [directionStr copy];

    if (verbose)
        NSLog(@"[LocationUtils] currenHeading %@", currentHeading);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)fromLocation {
    
    if (verbose) {
        NSLog(@"[LocationUtils] location changed...");
        NSLog(@"[LocationUtils] horz accuracy: %lf", [newLocation horizontalAccuracy]);
    }
    
    @try {
        
        if (newLocation == nil)
            return;
        
        if (delegate != nil) {
            if (verbose)
                NSLog(@"notifying delegate of location change...");
            
            [delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:fromLocation];
        }

        if (oldLocation != nil)
            oldLocation = [fromLocation copy];
        
        NSString * longitudeStr = nil;
        NSString * latitudeStr = nil;
        NSString * altitudeStr = nil;;
        
        NSString * currentLatitudeDirection = signbit(newLocation.coordinate.latitude) ? @"S" : @"N";
        NSString * currentLongitudeDirection = signbit(newLocation.coordinate.longitude) ? @"W" : @"E";
        float altitudeMeters = fabs(newLocation.altitude);
        float _altitude = altitudeMeters * 3.2808399;
        
        if (_altitude > 5280) {
            _altitude = _altitude / 5280;
            altitudeStr = [NSString stringWithFormat:@"%.2lf miles (%.2lf m)", _altitude, altitudeMeters];
        } else {
            if (_altitude == 0.0)
                altitudeStr = @"0 feet (0 m)";
            else
                altitudeStr = [NSString stringWithFormat:@"%.2lf feet (%.2lf m)", _altitude, altitudeMeters];
        }
        
        currentFormattedAltitude = [altitudeStr copy];
        
        int dlat = fabs(newLocation.coordinate.latitude);
        float flat = fabs(newLocation.coordinate.latitude) - dlat;
        
        if (verbose)
            NSLog(@"[LocationUtils] flat: %f", newLocation.coordinate.latitude);
        
        //int dlat2 = flat * 100;
        int dlat2 = flat * 60;
        
        latitudeStr = [NSString stringWithFormat:@"%d\u00b0 %d' %@", dlat, dlat2, currentLatitudeDirection];
        currentFormattedLatitude = [latitudeStr copy];
        
        int dlng = fabs(newLocation.coordinate.longitude);
        float flng = fabs(newLocation.coordinate.longitude) - dlng;
        int dlng2 = flng * 60;

        longitudeStr = [NSString stringWithFormat:@"%d\u00b0 %d' %@", dlng, dlng2, currentLongitudeDirection];
        currentFormattedLongitude = [longitudeStr copy];

        if (fabs(newLocation.altitude) == 0.00)
            altitudeStr = @"0 feet";
        
        double speed = [newLocation speed];
        
        if (speed >= 0.0) {
            if (verbose)
                NSLog(@"LocationUtils] speed %.2lf meters/second", speed);
            
            NSString * speedStr = nil;
            
            if (speed > 0.0)
                speedStr = [NSString stringWithFormat:@"%.2lf m/s (%.2lf mph)", speed, speed * 2.23693629];
            else
                speedStr = @"0 m/s (0 mph)";
            
            currentFormattedSpeed = [speedStr copy];
        } else {
            currentFormattedSpeed = @"0 m/s (0 mph)";
        }
        
        NSString * accuracyStr = nil;
        int accuracy = [newLocation horizontalAccuracy];
        
        if (verbose)
            NSLog(@"LocationUtils] accuracy: %d", accuracy);
        
        if (accuracy > 0 && accuracy <= 50) {
            accuracyStr = @"Very strong";
        } else if (accuracy > 50 && accuracy <= 60) {
            accuracyStr = @"Strong";
        } else if (accuracy > 60 && accuracy <= 70) {
            accuracyStr = @"Very good";
        } else if (accuracy > 70 && accuracy <= 90) {
            accuracyStr = @"Good";
        } else if (accuracy > 90 && accuracy <= 100) {
            accuracyStr = @"Borderline";
        } else if (accuracy > 100 && accuracy <= 300) {
            accuracyStr = @"Weak";
        } else if (accuracy > 300 && accuracy <= 500) {
            accuracyStr = @"Weak";
        } else if (accuracy > 500 && accuracy <= 700) {
            accuracyStr = @"Weak";
        } else {
            accuracyStr = @"Very weak";
        }
        
        currentGPSSignalAccuracy = accuracy;
        currentGPSSignal = [accuracyStr copy];
        
        CLLocationCoordinate2D currentCoordinate = newLocation.coordinate;
        
        if (currentCoordinate.latitude != 0.0 && currentCoordinate.longitude != 0.0 && currentAddress != nil && isNewAddress) {
            if (verbose) {
                NSLog(@"[LocationUtils] current coordinate long %f lat %f XXX new address: %@", currentCoordinate.longitude, currentCoordinate.latitude, currentAddress);
            }
            isNewAddress = FALSE;
        }
                
        BOOL locationServicesEnabled = [self locationServicesAreEnabled];
        
        if (locationServicesEnabled && geocoder != nil) {
            if (verbose) {
                NSLog(@"[LocationUtils] reverse encode to determine current address...");
                NSLog(@"[LocationUtils] current coordinate lat: %f long %f", currentCoordinate.latitude, currentCoordinate.longitude);
            }
            
            if (accuracy <= 300) {
                CLLocation * location = [[CLLocation alloc] initWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
                
                if (verbose)
                    NSLog(@"reverse lat %f long %f...", currentCoordinate.latitude, currentCoordinate.longitude);
                
                gettingAddress = TRUE;
                
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks, NSError * error) {
                    
                    dispatch_async(dispatch_get_main_queue() , ^ {
                        // do stuff with placemarks on the main thread
                        
                        //NSLog(@"reverse placemarks array count %d", placemarks.count);
                        
                        //CLPlacemark * placemark = [placemarks objectAtIndex:0];
                        CLPlacemark * placemark = [placemarks lastObject];
                        
                        if (error != nil) {
                            if (verbose)
                                NSLog(@"clGeocoder Error!");
                            [self reverseCLGeocoder:geocoder didFailWithError:error];
                        } else {
                            if (verbose)
                                NSLog(@"clGeocoder OK!");
                            [self reverseCLGeocoder:geocoder didFindPlacemark:placemark];
                        }
                    });
                }];

            
            } else {
                if (verbose)
                    NSLog(@"[LocationUtils] good or better is on and current GPS value is < .50");
            }
        } else {
            if (verbose)
                NSLog(@"[LocationUtils] location services not available yet to determine current address...");
        }
        
        if (verbose)
            NSLog(@"[LocationUtils] currentAddress %@", currentAddress);
    }
    @catch (NSException * ex) {
    }
}

- (void)reverseCLGeocoder:(CLGeocoder *)geocoder didFailWithError:(NSError *)error {
    
    gettingAddress = FALSE;
    
    if (verbose)
        NSLog(@"[LocationUtils] reverseCLGeocoder.didFailWithError error: %@", error);
}

- (void)reverseCLGeocoder:(CLGeocoder *)geocoder didFindPlacemark:(CLPlacemark *)placemark {
    
    @try {
        
        //NSLog(@"[LocationUtils] reverseCLGeocoder.didFindPlacemark: %@", placemark);
        
        NSString * addressStringUnformatted = [self getUnformattedAddressForPlacemark:placemark];
        NSString * addressStringFormatted = [self getFormattedAddressForPlacemark:placemark];
        
        if (verbose) {
            NSLog(@"addressStringUnformatted: '%@'", addressStringUnformatted);
            NSLog(@"addressStringFormatted: '%@'", addressStringFormatted);
        }
        
        NSString * newAddress = [addressStringUnformatted copy];
        
        if (placemark != nil)
            currentAddressPlacemark = [placemark copy];
        
        isNewAddress = FALSE;
        
        if (currentAddress == nil || [newAddress isEqualToString:currentAddress] == FALSE) {
            NSString * oldAddress = @"";
            
            if (currentAddress != nil)
                oldAddress = [currentAddress copy];
            
            currentAddress = [newAddress copy];
            isNewAddress = TRUE;
            
            if (currentAddress != nil) {
                CLLocationCoordinate2D currentCoordinate = [self getCurrentCoordinate];
                
                if (verbose)
                    NSLog(@"[LocationUtils] current coordinate long %f lat %f address: %@", currentCoordinate.longitude, currentCoordinate.latitude, currentAddress);
                
                if (delegate != nil) {
                    if (verbose)
                        NSLog(@"Notify delegate...");
                    CLLocation * currentLocation = [self getCurrentLocation];
                    
                    if (delegate != nil) {
                        if (verbose)
                            NSLog(@"notifying delegate of address change...");
                        
                        [delegate currentAddressChanged:currentLocation currentAddress:[currentAddress copy] oldAddress:oldAddress];
                    }
                }
            }
        }
    }
    @catch (NSException * ex) {
    }
    
    gettingAddress = FALSE;
}

- (NSString *)getUnformattedAddressForPlacemark:(CLPlacemark *)placemark {
    NSString * address = nil;
    
    @try {
        NSArray * lines = placemark.addressDictionary[@"FormattedAddressLines" ];
        address = [lines componentsJoinedByString:@", "];
        //NSLog(@"unformatted address: '%@'", address);
    }
    @catch (NSException * ex) {
        
    }
    return address;
    
}

- (NSString *)getFormattedAddressForPlacemark:(CLPlacemark *)placemark {
    NSString * address = nil;
    
    @try {
        NSArray * lines = placemark.addressDictionary[@"FormattedAddressLines" ];
        address = [lines componentsJoinedByString:@"\n"];
        
        //NSLog(@"formatted address: '%@'", address);
    }
    @catch (NSException * ex) {
        
    }
    return address;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (verbose)
        NSLog(@"LocationUtils] error!");
    
    gettingAddress = FALSE;
    
    switch([error code]) {
            
        case kCLErrorLocationUnknown:
            
            break;
            
        case kCLErrorDenied: {
            
            NSString * msg = @"Location information is required!  You need to allow using your current location.";
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
            
        case kCLErrorNetwork:  {
            
            NSString * msg = @"Please check your network connection or that you are not in airplane mode.";
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
    }
}

@end
