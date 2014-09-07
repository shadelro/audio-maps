//
//  Category.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Source;
@class SoundFile;

@interface PointOfInterest : NSObject {
    
}

@property(strong, nonatomic) NSString *pointName;
@property(assign, nonatomic) float defaultX;
@property(assign, nonatomic) float defaultZ;
@property(assign, nonatomic) float currentX;
@property(assign, nonatomic) float currentZ;
@property(assign, nonatomic) float currentDistance;
@property(strong, nonatomic) SoundFile *soundFile;
@property(strong, nonatomic) Source *activeSource;



-(id)initWithFile:(NSString *)filePath;


@end
