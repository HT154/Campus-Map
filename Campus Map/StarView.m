//
//  StarView.m
//  Campus Map
//
//  Created by Joshua Basch on 4/18/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (void)drawRect:(CGRect)rect {
    CGFloat dividerH = self.bounds.size.width / 120;
    CGFloat dividerV = self.bounds.size.height / 120;
    
    UIBezierPath* starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint: CGPointMake(60 * dividerH, 0 * dividerV)];
    [starPath addLineToPoint: CGPointMake(73.52 * dividerH, 41.4 * dividerV)];
    [starPath addLineToPoint: CGPointMake(117.06 * dividerH, 41.4 * dividerV)];
    [starPath addLineToPoint: CGPointMake(81.87 * dividerH, 67.11 * dividerV)];
    [starPath addLineToPoint: CGPointMake(95.27 * dividerH, 108.54 * dividerV)];
    [starPath addLineToPoint: CGPointMake(60 * dividerH, 83 * dividerV)];
    [starPath addLineToPoint: CGPointMake(24.73 * dividerH, 108.54 * dividerV)];
    [starPath addLineToPoint: CGPointMake(38.13 * dividerH, 67.11 * dividerV)];
    [starPath addLineToPoint: CGPointMake(2.94 * dividerH, 41.4 * dividerV)];
    [starPath addLineToPoint: CGPointMake(46.48 * dividerH, 41.4 * dividerV)];
    [starPath closePath];
    [[UIColor lightGrayColor] setFill];
    [starPath fill];
}

@end
