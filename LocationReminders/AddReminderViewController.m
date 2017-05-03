//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"

@interface AddReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderText;
@property (weak, nonatomic) IBOutlet UITextField *reminderRadius;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (IBAction)saveReminder:(UIButton *)sender {
    Reminder *newReminder = [Reminder object];
    newReminder.name = self.reminderText.text;
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude
                                                  longitude:self.coordinate.longitude];
    
    // Save reminder asynchronously with the Parse framework.
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Annotation title: %@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f",
              self.coordinate.latitude,
              self.coordinate.longitude);
        NSLog(@"Reminder saved successful: %i - Error: %@", succeeded, error.localizedDescription);
        
        if (self.completion) {
            CGFloat radius = 100; // change this to use UITextField or UISlider
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius];
            self.completion(circle);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    

}


@end
