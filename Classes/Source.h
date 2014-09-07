//
//  Source.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "OpenAL/al.h"
#include "OpenAL/alc.h"


@interface Source : NSObject {
	
}

@property(assign, nonatomic) ALuint sourceID;
@property(assign, nonatomic) float xPos;
@property(assign, nonatomic) float zPos;
@property(assign, nonatomic) float gainScale;


-(id)initSourceWithID:(ALuint)newSourceID;
-(void)updateGainScale:(float)newGainScale;




-(id)initSource;

@end
