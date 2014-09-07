//
//  Source.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Source.h"
#include "CoreLocation/CoreLocation.h"


@implementation Source

@synthesize sourceID = sourceID_;
@synthesize xPos = xPos_;
@synthesize zPos = zPos_;
@synthesize gainScale = gainScale_;

-(id)initSourceWithID:(ALuint)newSourceID
{
	self.xPos = 0;
	self.zPos = 0;
	self.gainScale = 1;
	self.sourceID = newSourceID;
	
	return self;
}

-(id)initSource
{
	self.xPos = 0;
	self.zPos = 0;
	self.gainScale = 1;
	
	ALuint tempID;
	alGenSources(1, &tempID);
	
	self.sourceID = tempID;
	
	alSourcef(self.sourceID, AL_PITCH, 1.0f);
	alSourcef(self.sourceID, AL_GAIN, self.gainScale);
	alSourcei(self.sourceID, AL_LOOPING, AL_FALSE);
	ALfloat sourcePosition[] = {self.xPos, 0, self.zPos};
	alSourcefv(self.sourceID, AL_POSITION, sourcePosition);
	
	return self;
}
	
	

-(void)updateSourcePosition:(CLLocation *)newLocation
{
	self.xPos = newLocation.coordinate.longitude;
	self.zPos = newLocation.coordinate.latitude * -1;
	ALfloat sourcePosition[] = {self.xPos, 0, self.zPos};
	alSourcefv(self.sourceID, AL_POSITION, sourcePosition);
}

-(void)updateGainScale:(float)newGainScale
{
	
}

@end
