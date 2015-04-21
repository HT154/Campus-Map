//
//  LocationsViewControllerTableViewController.m
//  Campus Map
//
//  Created by Joshua Basch on 4/14/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "LocationsViewController.h"
#import "DetailViewController.h"
#import "FixedImageWidthTableViewCell.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController {
    NSMutableArray *sectionTitles;
    NSMutableDictionary *sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.category;
    
    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}

- (void)setLocations:(NSArray *)locations {
    _locations = locations;
    
    if (!sections) {
        sections = [NSMutableDictionary dictionary];
        sectionTitles = [NSMutableArray array];
    }
    
    [sections removeAllObjects];
    [sectionTitles removeAllObjects];
    
    for (NSDictionary *location in self.locations) {
        NSString *c = [location[@"name"] substringToIndex:1];
        
        if (![sectionTitles containsObject:c]) {
            [sections setValue:[NSMutableArray array] forKey:c];
            [sectionTitles addObject:c];
        }
        
        [sections[c] addObject:location];
    }
    
    [sectionTitles sortedArrayUsingSelector:@selector(compare:)];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sections[sectionTitles[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:(FixedImageWidthTableViewCell *)cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(FixedImageWidthTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel2.text = ((NSArray *)sections[sectionTitles[indexPath.section]])[indexPath.row][@"name"];
    cell.imageView2.image = [UIImage imageNamed:((NSArray *)sections[sectionTitles[indexPath.section]])[indexPath.row][@"icon"]];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionTitles;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
    controller.category = self.category;
    controller.detailItem = ((NSArray *)sections[sectionTitles[indexPath.section]])[indexPath.row];
}

@end
