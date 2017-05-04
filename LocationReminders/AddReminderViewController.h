//
//  AddReminderViewController.h
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

typedef void(^NewReminderCreatedCompletion) (MKCircle *);

@interface AddReminderViewController : UIViewController

@property (strong, nonatomic) NSString *annotationTitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NewReminderCreatedCompletion completion;

@end
