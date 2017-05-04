//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@interface AddReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderText;
@property (weak, nonatomic) IBOutlet UITextField *reminderRadius;

@end

@implementation AddReminderViewController

- (IBAction)click:(UISegmentedControl *)sender {
    NSLog(@"Selected: %li", (long)sender.selectedSegmentIndex);
}

- (IBAction)saveReminder:(UIButton *)sender {
    Reminder *newReminder = [Reminder object];
    newReminder.name = self.reminderText.text;
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude
                                                  longitude:self.coordinate.longitude];
    NSNumber *radius = [NSNumber numberWithFloat:self.reminderRadius.text.floatValue];
    if (radius == 0) {
        radius = [NSNumber numberWithFloat:100];
    }
    newReminder.radius = radius;
    
    // Save reminder asynchronously with the Parse framework.
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Annotation title: %@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
        NSLog(@"Reminder saved successfully: %i - Error: %@", succeeded, error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderSavedToParse"
                                                            object:nil];
        
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.coordinate radius:[radius intValue] identifier:newReminder.name];
            [LocationController.shared startMonitoringForRegion:region];
        }
        
        if (self.completion) {
            CGFloat overlayRadius = radius.floatValue;
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate
                                                             radius:overlayRadius];
            self.completion(circle);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}


@end
