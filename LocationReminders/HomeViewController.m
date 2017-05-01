//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/1/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "HomeViewController.h"
@import Parse;
@import MapKit;

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self requestPermissions];
    self.mapView.showsUserLocation = YES;
    
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"testName"] = @"Robert Hatfield";
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Success saving test object");
//        } else {
//            NSLog(@"There was a problem saving. Save error: %@", error.localizedDescription);
//        }
//    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error when querying: %@", error.localizedDescription);
//        } else {
//            NSLog(@"Query results:\n %@", objects);
//        }
//    }];
}

- (void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.351096);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end