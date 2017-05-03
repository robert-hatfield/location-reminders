//
//  LocationBookmark.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LocationBookmark.h"

@implementation LocationBookmark

-(instancetype)initWithName:(NSString *)name latitude:(double)latitude andLongitude:(double)longitude {
    self.name = name;
    self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    return self;
}

@end
