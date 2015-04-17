//
//  CategoriesViewController.m
//  Campus Map
//
//  Created by Joshua Basch on 4/13/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "CategoriesViewController.h"
#import "LocationsViewController.h"

@interface CategoriesViewController ()

@property (strong) NSArray *categories;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self refresh];
}

- (void)refresh {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mobile.ucdavis.edu/locations/?format=json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self.refreshControl endRefreshing];
        
        if (connectionError) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Unable to load all locations. Your favorites are still available." preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        } else {
            NSError *jsonError = nil;
            self.categories = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&jsonError];
            
            if (jsonError) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Unable to load all locations. Your favorites are still available." preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:ac animated:YES completion:nil];
            } else {
                self.categories = [self.categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"locations.@count > 0"]];
                
                for (NSMutableDictionary *cat in self.categories) {
                    cat[@"locations"] = [cat[@"locations"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        return [obj1[@"name"] compare:obj2[@"name"]] == NSOrderedDescending;
                    }];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.categories[indexPath.row][@"name"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLocations"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *category = self.categories[indexPath.row];
        LocationsViewController *dest = (LocationsViewController *)segue.destinationViewController;
        dest.category = category[@"name"];
        dest.locations = category[@"locations"];
    }
}

@end
