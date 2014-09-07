//
//  RootViewController.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryListViewController.h"
#import "CategoryViewController.h"
#import "CategoryList.h"

@implementation CategoryListViewController

@synthesize categories = categories_;

-(void) viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Subway Lines";
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	cell.textLabel.text = [self.categories categoryAtIndex:indexPath.row];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CategoryViewController *categoryViewController = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
	categoryViewController.activeCategory = [self.categories categoryAtIndex:indexPath.row];
	[self.navigationController pushViewController:categoryViewController animated:YES];
}

@end
