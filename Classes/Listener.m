//
//  Listener.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Listener.h"
#import "OpenAL/al.h"
#import "OpenAL/alc.h"


@implementation Listener

@synthesize listenerHeading = listenerHeading_; //, listenerLocation;

-(id)initListener
{
	ALfloat temp[] = {0, 0, 0, 0, 1, 0};
	alListenerfv(AL_ORIENTATION, temp);
	
	return self;
}

-(void)updateListenerHeading:(CLHeading *)newHeading
{
	self.listenerHeading = newHeading;
	
	float newRotation = self.listenerHeading.trueHeading;
	
	float newRotationRad = newRotation * M_PI / 180;
	float newXDir = sin(newRotationRad);
	float newZDir = cos(newRotationRad * -1) * -1;
	
	ALfloat newListenerOrientation[] = {newXDir, 0.0, newZDir, 0.0, 1.0, 0.0};
	alListenerfv(AL_ORIENTATION, newListenerOrientation);
}

/*
-(void)updateListenerLocation:(CLLocation *)newLocation
{
	self.listenerLocation = newLocation;
}
*/

-(float)getListenerHeadingInDegrees
{
	return self.listenerHeading.trueHeading;
}

/*
-(float)getListenerXPos
{
	return self.listenerLocation.coordinate.latitude;
}

-(float)getListenerZPos
{
	return self.listenerLocation.coordinate.longitude;
}
*/

@end
