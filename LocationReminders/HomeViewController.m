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
@import Parse;
@import MapKit;

@interface HomeViewController () <LocationControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [LocationController shared].delegate = self;
    [[LocationController shared] requestPermissions];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"addReminderViewController"] &&
        [sender isKindOfClass:[MKAnnotationView class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
    }
}

//MARK: User actions
- (IBAction)location1Pressed:(id)sender {
    // Point Defiance
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.301781, -122.515622);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)location2Pressed:(id)sender {
    // Code Fellows campus
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6182206, -122.3540207);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)location3Pressed:(id)sender {
    // Fred Meyer on S 19th St, Tacoma
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake
    (47.243322, -122.4978105);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint
                                                  toCoordinateFromView:self.mapView];
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc] init];
        newPoint.coordinate = coordinate;
        newPoint.title = @"New location";
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
    NSArray *colors = @[UIColor.blueColor, UIColor.brownColor, UIColor.cyanColor, UIColor.greenColor, UIColor.magentaColor, UIColor.orangeColor, UIColor.purpleColor, UIColor.redColor];
    UIColor *randomColor = colors[arc4random_uniform(8)];
    annotationView.pinTintColor = randomColor;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"addReminderViewController" sender:view];
}

@end
