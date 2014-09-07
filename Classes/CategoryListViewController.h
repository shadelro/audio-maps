//
//  RootViewController.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryList;

@interface CategoryListViewController : UITableViewController {
}

@property (nonatomic, retain) IBOutlet CategoryList *categories;

@end
