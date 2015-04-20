//
//  BlueBarNavigationController.m
//  Campus Map
//
//  Created by Joshua Basch on 4/20/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "BlueBarNavigationController.h"

@interface BlueBarNavigationController ()

@end

@implementation BlueBarNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationBar.backgroundColor = [UIColor colorWithRed:29.0/256.0 green:54.0/256.0 blue:90.0/256.0 alpha:1.0];
    self.navigationBar.barTintColor = [UIColor colorWithRed:29.0/256.0 green:54.0/256.0 blue:90.0/256.0 alpha:1.0];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"FuturaUCDavis-Book" size:20.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
}

@end
