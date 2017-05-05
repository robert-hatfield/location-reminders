//
//  LocationBookmark.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LocationBookmark.h"

@implementation LocationBookmark

- (id)initWithName:(NSString *)name
                   latitude:(double)latitude
               andLongitude:(double)longitude {


    self = [super init];
    
    if (self) {
        _name = name;
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return self;
}

- (id)initWithName:(NSString *)name andLocation:(CLLocation*)location {
    self = [super init];
    
    if (self) {
        _name = name;
        _coordinate = location.coordinate;
    }
    return self;
}

@end
