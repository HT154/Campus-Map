//
//  DetailViewController.h
//  Campus Map
//
//  Created by Joshua Basch on 4/13/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Location *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

