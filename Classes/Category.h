//
//  Category.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenAL/al.h"
#import "OpenAL/alc.h"

@class PointOfInterest;
@class Source;

@interface Category : NSObject {
    
}

@property(strong, nonatomic) NSMutableArray *pointArray;
@property(assign, nonatomic) int sorted;


-(PointOfInterest *)getPointAtIndex:(NSUInteger)index;
-(id)initCategoryWithCategory:(NSString *)categoryName;
-(NSUInteger)count;
-(NSMutableArray *)generatePointsForCategory:(NSString *)categoryName;
-(int)sortPointArray:(int)index;

// sort points by location

@end
