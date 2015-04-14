//
//  Location.h
//  Campus Map
//
//  Created by Joshua Basch on 4/14/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * abbr;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * name;

-(NSDictionary *)dictionaryRepresentation;
-(void)takeValuesFrom:(NSDictionary *)dict;

@end
