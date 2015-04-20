//
//  FixedImageWidthTableViewCell.m
//  Campus Map
//
//  Created by Joshua Basch on 4/20/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "FixedImageWidthTableViewCell.h"

@implementation FixedImageWidthTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.textLabel2.textColor = [UIColor whiteColor];
        self.detailTextLabel2.textColor = [UIColor whiteColor];
    } else {
        self.textLabel2.textColor = [UIColor blackColor];
        self.detailTextLabel2.textColor = [UIColor blackColor];
    }
}

@end
