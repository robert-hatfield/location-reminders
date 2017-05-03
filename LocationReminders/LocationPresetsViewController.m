//
//  LocationPresetsViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LocationPresetsViewController.h"
#import "HomeViewController.h"
@import MapKit;

@interface LocationPresetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *presetsTableView;
@property (strong, nonatomic) NSArray *presets;

@end

@implementation LocationPresetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.presetsTableView.dataSource = self;
//    // Point Defiance
//   
////    [self.mapView setRegion:region animated:YES];
//    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:47.301781 longitude:-122.515622];
//    // Code Fellows campus
//    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(47.6182206, -122.3540207);
//   
//
//    // Fred Meyer on S 19th St, Tacoma
//    CLLocationCoordinate2D coordinate3 = CLLocationCoordinate2DMake
//    (47.243322, -122.4978105);
    
    
}

- (IBAction)closeTableView:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//}



@end
