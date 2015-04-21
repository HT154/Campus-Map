//
//  CategoriesViewController.m
//  Campus Map
//
//  Created by Joshua Basch on 4/13/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "CategoriesViewController.h"
#import "LocationsViewController.h"
#import "FixedImageWidthTableViewCell.h"

@interface CategoriesViewController ()

@end

@implementation CategoriesViewController {
    NSMutableArray *categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}

- (void)refresh {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mobile.ucdavis.edu/locations/?format=json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self.refreshControl endRefreshing];
        
        if (connectionError) {
            [self presentLoadError:connectionError];
        } else {
            NSError *jsonError = nil;
            categories = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&jsonError];
            
            if (jsonError) {
                [self presentLoadError:jsonError];
            } else {
                [categories filterUsingPredicate:[NSPredicate predicateWithFormat:@"locations.@count > 0"]];
                NSMutableSet *allNames = [NSMutableSet set];
                NSMutableArray *all = [NSMutableArray array];
                
                for (NSMutableDictionary *cat in categories) {
                    for (NSDictionary *loc in cat[@"locations"]) {
                        if (![allNames containsObject:loc[@"name"]]) {
                            [allNames addObject:loc[@"name"]];
                            [all addObject:loc];
                        }
                    }
                    
                    cat[@"locations"] = [cat[@"locations"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        return [obj1[@"name"] caseInsensitiveCompare:obj2[@"name"]] == NSOrderedDescending;
                    }];
                }
                
                [all sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1[@"name"] caseInsensitiveCompare:obj2[@"name"]] == NSOrderedDescending;
                }];
                
                [categories addObject:@{@"name": @"All Locations", @"locations": all}];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

- (void)presentLoadError:(NSError *)error {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Unable to load all locations. Your favorites are still available." preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == categories.count - 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlain" forIndexPath:indexPath];
        cell.textLabel.text = categories[indexPath.row][@"name"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [self configureCell:(FixedImageWidthTableViewCell *)cell atIndexPath:indexPath];
    }
    
    
    return cell;
}

- (void)configureCell:(FixedImageWidthTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel2.text = categories[indexPath.row][@"name"];
    
    UIImage *image = nil;
    
    if (indexPath.row < categories.count - 1) {
        image = [UIImage imageNamed:categories[indexPath.row][@"locations"][0][@"icon"]];
    }
    
    cell.imageView2.image = image;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *category = categories[indexPath.row];
    LocationsViewController *dest = (LocationsViewController *)segue.destinationViewController;
    dest.category = category[@"name"];
    dest.locations = category[@"locations"];
}

@end
