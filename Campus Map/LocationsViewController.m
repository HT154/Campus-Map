//
//  LocationsViewControllerTableViewController.m
//  Campus Map
//
//  Created by Joshua Basch on 4/14/15.
//  Copyright (c) 2015 HT154. All rights reserved.
//

#import "LocationsViewController.h"
#import "DetailViewController.h"

@interface LocationsViewController ()

@property (strong) NSMutableArray *sectionTitles;
@property (strong) NSMutableDictionary *sections;

@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.category;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLocations:(NSArray *)locations {
    _locations = locations;
    
    if (!self.sections) {
        self.sections = [NSMutableDictionary dictionary];
        self.sectionTitles = [NSMutableArray array];
    }
    
    [self.sections removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
    for (NSDictionary *location in self.locations) {
        NSString *c = [location[@"name"] substringToIndex:1];
        
        if (![self.sectionTitles containsObject:c]) {
            [self.sections setValue:[NSMutableArray array] forKey:c];
            [self.sectionTitles addObject:c];
        }
        
        [self.sections[c] addObject:location];
    }
    
    [self.sectionTitles sortedArrayUsingSelector:@selector(compare:)];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[self.sectionTitles[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = ((NSArray *)self.sections[self.sectionTitles[indexPath.section]])[indexPath.row][@"name"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitles;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.category = self.category;
        controller.detailItem = ((NSArray *)self.sections[self.sectionTitles[indexPath.section]])[indexPath.row];
    }
}

@end
