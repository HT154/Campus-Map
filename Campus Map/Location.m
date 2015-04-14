//
//  Location.m
//  Campus Map
//
//  Created by Joshua Basch on 4/14/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "Location.h"


@implementation Location

@dynamic abbr;
@dynamic category;
@dynamic icon;
@dynamic lat;
@dynamic link;
@dynamic lng;
@dynamic name;

-(NSDictionary *)dictionaryRepresentation {
    return [self dictionaryWithValuesForKeys:@[@"abbr", @"icon", @"lat", @"link", @"lng", @"name"]];
}

-(void)takeValuesFrom:(NSDictionary *)dict {
    self.abbr = dict[@"abbr"];
    self.icon = dict[@"icon"];
    self.lat = @([dict[@"lat"] floatValue]);
    self.link = dict[@"link"];
    self.lng = @([dict[@"lng"] floatValue]);
    self.name = dict[@"name"];
}

@end
