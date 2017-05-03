//
//  Reminder.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/3/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic name;
@dynamic location;
@dynamic radius;

+(void)load{
    // Register this subclass with Parse
    [self registerSubclass];
}

+(NSString *) parseClassName {
    // Define entity name for the REST API
    return @"Reminder";
}

@end
