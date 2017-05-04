//
//  LocationController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LocationController.h"

@interface LocationController () <CLLocationManagerDelegate>

@end

@implementation LocationController

+(instancetype)shared {
    // Create singleton for Employee database.
    static LocationController *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    
    return shared;
}

- (void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100; // meters
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}


//MARK: Delegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed with error: %@ \n %@", error.localizedDescription, error.localizedFailureReason); //ignore if in simulator
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.location = locations.lastObject;
    [self.delegate locationControllerUpdatedLocation:self.location];
}

- (void)startMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startMonitoringForRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"User ENTERED region: %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"User EXITED region: %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    NSLog(@"Location manager registered a visit: %@", visit);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Region successfully started monitoring changes for region: %@", region.identifier);
}

@end
