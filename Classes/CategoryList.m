//
//  CategoryList.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryList.h"


@implementation CategoryList

@synthesize categoryArray = categoryArray_;

-(NSUInteger)count
{
	return [self.categoryArray count];
}

-(NSString *)categoryAtIndex:(NSUInteger)index
{
	return [self.categoryArray objectAtIndex:index];
}

-(void)awakeFromNib
{
	NSMutableArray *temp = [NSMutableArray array];
	
	[temp addObject:[NSString stringWithFormat:@"ACE"]];
	[temp addObject:[NSString stringWithFormat:@"123"]];
	[temp addObject:[NSString stringWithFormat:@"456"]];
	[temp addObject:[NSString stringWithFormat:@"JMZ"]];
	[temp addObject:[NSString stringWithFormat:@"NQRW"]];
	[temp addObject:[NSString stringWithFormat:@"L"]];
	[temp addObject:[NSString stringWithFormat:@"G"]];
	[temp addObject:[NSString stringWithFormat:@"BDFV"]];
	
	self.categoryArray = [[NSArray alloc] initWithArray:temp];
}

@end
