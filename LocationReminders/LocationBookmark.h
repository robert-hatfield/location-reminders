//
//  LocationBookmark.h
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface LocationBookmark : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString* name;

- (id)initWithName:(NSString *)name
                   latitude:(double)latitude
               andLongitude:(double)longitude;

- (id)initWithName:(NSString *)name andLocation:(CLLocation*)location;

@end
