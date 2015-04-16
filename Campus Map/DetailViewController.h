//
//  DetailViewController.h
//  Campus Map
//
//  Created by Joshua Basch on 4/13/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSDictionary *detailItem;
@property (strong, nonatomic) NSString *category;

@property (strong) IBOutlet UIBarButtonItem *addFavoriteButton;
@property (strong) IBOutlet UIBarButtonItem *removeFavoriteButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)addFavoriteButton:(id)sender;
- (IBAction)removeFavoriteButton:(id)sender;

@end

