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

@property (strong) CLLocationManager *locationManager;
@property (strong) MapAnnotation *a;

@property (strong) UIButton *l;
@property (strong) UIButton *r;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        self.l = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [self.l setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
        
        self.r = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [self.r setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem[@"name"];
        
        self.a = [[MapAnnotation alloc] init];
        self.a.coordinate = CLLocationCoordinate2DMake([self.detailItem[@"lat"] doubleValue], [self.detailItem[@"lng"] doubleValue]);
        [self.mapView addAnnotation:self.a];
        [self.mapView selectAnnotation:self.a animated:NO];
        
        if ([[FavoritesViewController sharedInstance] isFavorite:self.detailItem inCategory:self.category]) {
            self.navigationItem.rightBarButtonItem = self.removeFavoriteButton;
        } else {
            self.navigationItem.rightBarButtonItem = self.addFavoriteButton;
        }
    }
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(38.538372, -121.756240), MKCoordinateSpanMake(0.04, 0.04));
}

-(IBAction)addFavoriteButton:(id)sender {
    [[FavoritesViewController sharedInstance] addFavorite:self.detailItem inCategory:self.category];
    
    self.navigationItem.rightBarButtonItem = self.removeFavoriteButton;
}

-(IBAction)removeFavoriteButton:(id)sender {
    [[FavoritesViewController sharedInstance] removeFavorite:self.detailItem inCategory:self.category];
    
    self.navigationItem.rightBarButtonItem = self.addFavoriteButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.mapView.showsUserLocation = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickedLinkButton:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detailItem[@"link"]]];
}

-(IBAction)clickedRouteButton:(id)sender {
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[self.a coordinate] addressDictionary:nil]];
    mapItem.name = self.detailItem[@"name"];
    
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard)}];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if([annotation isKindOfClass:[MapAnnotation class]]){
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if(!annotationView){
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
            annotationView.canShowCallout = YES;
            annotationView.leftCalloutAccessoryView = self.l;
            annotationView.rightCalloutAccessoryView = self.r;
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
        
        [self.r removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.r addTarget:self action:@selector(clickedLinkButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.l removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.l addTarget:self action:@selector(clickedRouteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.r.enabled = self.detailItem[@"link"] && ![self.detailItem[@"link"] isEqualToString:@""];
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end