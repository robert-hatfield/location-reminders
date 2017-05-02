//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Annotation title: %@", self.annotationTitle);
    NSLog(@"Coordinates: %f, %f",
          self.coordinate.latitude,
          self.coordinate.longitude);
}

@end
