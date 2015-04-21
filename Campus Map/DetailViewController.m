//
//  DetailViewController.m
//  Campus Map
//
//  Created by Joshua Basch on 4/13/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "DetailViewController.h"
#import "MapAnnotation.h"
#import "FavoritesViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    CLLocationManager *locationManager;
    MapAnnotation *annotation;
    
    UIButton *lButton;
    UIButton *rButton;
    
    BOOL zooming;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        [self configureView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showCorrectFavoritesButton];
}

- (void)configureView {
    if (annotation) {
        [self.mapView removeAnnotation:annotation];
    }
    
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem[@"name"];
        self.addFavoriteButton.enabled = YES;
        self.removeFavoriteButton.enabled = YES;
        
        annotation = [[MapAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([self.detailItem[@"lat"] doubleValue], [self.detailItem[@"lng"] doubleValue]);
        
        //center map on current location
        self.mapView.region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.05, 0.05));
        
        [self.mapView addAnnotation:annotation];
        zooming = NO;
        
        [self showCorrectFavoritesButton];
    } else {
        self.addFavoriteButton.enabled = NO;
        self.removeFavoriteButton.enabled = NO;
        annotation = nil;
        
        //If there is no location (like on first load on iPad or iPhone6+ landscape), center the map roughly on the UCD campus
        self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(38.538372, -121.756240), MKCoordinateSpanMake(0.05, 0.05));
    }
}

- (void)showCorrectFavoritesButton {
    if ([[FavoritesViewController sharedInstance] isFavorite:self.detailItem inCategory:self.category]) {
        self.navigationItem.rightBarButtonItem = self.removeFavoriteButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.addFavoriteButton;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    //If/when the user location dot is added to the map, begin zooming to show both user and current location
    if (annotation && [views[0] isKindOfClass:NSClassFromString(@"MKUserLocationView")]) {
        [self.mapView showAnnotations:mapView.annotations animated:YES];
        zooming = YES;
    }
    
    //If not auhorized to access user location, automatically show annotation view
    if ([CLLocationManager authorizationStatus] <= kCLAuthorizationStatusDenied) {
        [self.mapView selectAnnotation:annotation animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //after zooming to show both user and current location annotations, open the annotation view with the 'route with Maps' and 'open URL' buttons
    if (zooming && annotation) {
        [self.mapView selectAnnotation:annotation animated:YES];
        zooming = NO;
    }
}

- (IBAction)addFavoriteButton:(id)sender {
    [[FavoritesViewController sharedInstance] addFavorite:self.detailItem inCategory:self.category];
    
    self.navigationItem.rightBarButtonItem = self.removeFavoriteButton;
}

- (IBAction)removeFavoriteButton:(id)sender {
    [[FavoritesViewController sharedInstance] removeFavorite:self.detailItem inCategory:self.category];
    
    self.navigationItem.rightBarButtonItem = self.addFavoriteButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [lButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    
    rButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rButton setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    self.mapView.showsUserLocation = YES;
    
    [self configureView];
}

- (IBAction)clickedLinkButton:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detailItem[@"link"]]];
}

- (IBAction)clickedRouteButton:(id)sender {
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[annotation coordinate] addressDictionary:nil]];
    mapItem.name = self.detailItem[@"name"];
    
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard)}];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)a{
    if ([a isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if([a isKindOfClass:[MapAnnotation class]]){
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if(!annotationView){
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
            annotationView.canShowCallout = YES;
            annotationView.leftCalloutAccessoryView = lButton;
            annotationView.rightCalloutAccessoryView = rButton;
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
        
        [rButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [rButton addTarget:self action:@selector(clickedLinkButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [lButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [lButton addTarget:self action:@selector(clickedRouteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        rButton.enabled = self.detailItem[@"link"] && ![self.detailItem[@"link"] isEqualToString:@""];
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end