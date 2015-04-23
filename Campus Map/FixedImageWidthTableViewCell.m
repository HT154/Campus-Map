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
    
    self.textLabel2.highlighted = highlighted;
    self.detailTextLabel2.highlighted = highlighted;
    self.imageView2.highlighted = highlighted;
}

@end
