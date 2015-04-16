//
//  MasterViewController.h
//  Campus Map
//
//  Created by Joshua Basch on 4/13/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Location.h"

@class DetailViewController;

@interface FavoritesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (FavoritesViewController *)sharedInstance;

- (void)addFavorite:(NSDictionary *)loc inCategory:(NSString *)cat;
- (void)removeFavorite:(NSDictionary *)loc inCategory:(NSString *)cat;
- (BOOL)isFavorite:(NSDictionary *)loc inCategory:(NSString *)cat;

@end

