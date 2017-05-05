//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/1/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "HomeViewController.h"
#import "AddReminderViewController.h"
#import "LocationController.h"
#import "Reminder.h"
#import "LocationPresetsViewController.h"

@import MapKit;
@import Parse;
@import ParseUI;

@interface HomeViewController () <MKMapViewDelegate,LocationControllerDelegate,
PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, atomic) UIColor *backgroundColor;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.backgroundColor = [UIColor colorWithRed:0.53
                                               green:0.60
                                                blue:0.70
                                               alpha:1.0];
    self.view.backgroundColor = self.backgroundColor;
    
    [LocationController shared].delegate = self;
    [[LocationController shared] requestPermissions];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
    
    // If no PFUser is defined, present a log in VC.
    if (![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.delegate = self;
        logInViewController.signUpController.delegate = self;
        logInViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook | PFLogInFieldsDismissButton;
        //        logInViewController.logInView.logo = [[UIView alloc] init]; // Override logo on login screen
        logInViewController.logInView.backgroundColor = self.backgroundColor;
        
        [self presentViewController:logInViewController animated:YES completion:nil];
    }
    
    [self fetchReminders];
}

- (void)reminderSavedToParse:(id)sender {
    NSLog(@"Do something once reminder is saved.");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ReminderSavedToParse"
                                                  object:nil];
    // No need to call dealloc on parent class; ARC does this for us.
}

- (void)fetchReminders {
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects,
                                              NSError * _Nullable error) {
        if (error) {
            NSLog(@"An error occurred fetching reminders: %@", error.localizedDescription);
            return ;
        }
        
        NSLog(@"\nLOCATIONS:\n---------");
        for (Reminder *reminder in objects) {
            NSLog(@"Name: %@, Lat: %f Lon: %f | Radius: %@m.",
                  reminder.name,
                  reminder.location.latitude,
                  reminder.location.longitude,
                  reminder.radius);
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminder.location.latitude,
                                                                           reminder.location.longitude);
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate
                                                             radius:reminder.radius.doubleValue];
            [self.mapView addOverlay:circle];
        }
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"addReminderViewController"] &&
        [sender isKindOfClass:[MKAnnotationView class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
        newReminderViewController.view.backgroundColor = self.backgroundColor;
        
        // Create a weak reference to self - this VC - to avoid a retain cycle.
        __weak typeof(self) homeVCweak = self;
        newReminderViewController.completion = ^(MKCircle *circle) {
            // Make the reference to the Home VC strong for the scope of this block.
            __strong typeof(homeVCweak) homeVCstrong = homeVCweak;
            [homeVCstrong.mapView removeAnnotation:annotationView.annotation];
            [homeVCstrong.mapView addOverlay:circle];
        };
    }
    
    if ([segue.identifier isEqualToString:@"showPresets"]) {
        
        LocationPresetsViewController *bookmarkViewController = (LocationPresetsViewController *)segue.destinationViewController;
        bookmarkViewController.backgroundColor = self.backgroundColor;

        __weak typeof (self) homeVCweak = self;
        bookmarkViewController.completion = ^(CLLocationCoordinate2D coordinate){
            __strong typeof (homeVCweak) homeVCStrong = homeVCweak;
            [homeVCStrong.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0)
                                   animated:YES];
        };
    }
}

//MARK: User actions
- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint
                                                  toCoordinateFromView:self.mapView];
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc] init];
        newPoint.coordinate = coordinate;
        newPoint.title = @"Create new reminder";
        [self.mapView addAnnotation:newPoint];
    }
}

//MARK: Delegate methods
- (void)locationControllerUpdatedLocation:(CLLocation *)location {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                   500.0,
                                                                   500.0);
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // Exclude annotation for user location from reassignment.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Cast a reusable annotation view as the pin subclass.
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    // Assign the annotation to the annotation view when it is dequeued.
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        // Create a new annotation view if none are available to be dequeued.
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    // Assign a random color to pin.
    NSArray *colors = @[UIColor.blueColor, UIColor.brownColor, UIColor.cyanColor,
                        UIColor.greenColor, UIColor.magentaColor, UIColor.orangeColor,
                        UIColor.purpleColor, UIColor.redColor];
    UIColor *randomColor = colors[arc4random_uniform(8)];
    annotationView.pinTintColor = randomColor;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeContactAdd];
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"addReminderViewController" sender:view];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.4];
    renderer.lineWidth = 2.0;
    renderer.fillColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.25];
    
    return renderer;
}

//MARK: PFUser delegate methods
- (void)logInViewController:(PFLogInViewController *)logInController
               didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
