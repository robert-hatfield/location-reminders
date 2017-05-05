//
//  LocationPresetsViewController.m
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LocationPresetsViewController.h"


@interface LocationPresetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *bookmarks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation LocationPresetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navBar.backgroundColor = self.backgroundColor;
    
    // Create initial bookmarks & array
    LocationBookmark *bookmark1 = [[LocationBookmark alloc] initWithName:@"Point Defiance"
                                                                latitude:47.301781
                                                            andLongitude:-122.515622];
    LocationBookmark *bookmark2 = [[LocationBookmark alloc] initWithName:@"Code Fellows"
                                                                latitude:47.6182206
                                                            andLongitude:-122.3540207];
    LocationBookmark *bookmark3 = [[LocationBookmark alloc] initWithName:@"Fred Meyer"
                                                                latitude:47.243322
                                                            andLongitude:-122.4978105];
    
    self.bookmarks = [[NSMutableArray alloc] initWithObjects:bookmark1, bookmark2, bookmark3, nil];
}

- (IBAction)closeTableView:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationBookmark* bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = bookmark.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookmarks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Selected row %li", (long)indexPath.row);
    LocationBookmark *bookmark = (LocationBookmark *)[self.bookmarks objectAtIndex:indexPath.row];
    NSLog(@"%f, %f", bookmark.coordinate.latitude, bookmark.coordinate.longitude);
    self.completion(bookmark.coordinate);
    [self dismissViewControllerAnimated:YES completion:nil];
 
}

@end
