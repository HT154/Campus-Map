//
//  Location.h
//  
//
//  Created by Joshua Basch on 4/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * abbr;
@property (nonatomic) float lat;
@property (nonatomic) float lng;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic) BOOL favorite;

@end
