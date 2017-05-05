//
//  LocationPresetsViewController.h
//  LocationReminders
//
//  Created by Robert Hatfield on 5/2/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationBookmark.h"

typedef void(^BookmarkSelectedCompletion)(CLLocationCoordinate2D);

@interface LocationPresetsViewController : UIViewController
@property (strong, nonatomic) BookmarkSelectedCompletion completion;
@property (strong, nonatomic) UIColor *backgroundColor;

@end
