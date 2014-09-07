//
//  Environment.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"

#include "Constants.h"
#include "AudioPlayer.h"
#include "Category.h"
#include "Source.h"
#include "Listener.h"
#include "SoundFile.h"
#include "PointOfInterest.h"

@implementation Environment

@synthesize maxSources = maxSources_;
@synthesize maxDistance = maxDistance_;
@synthesize activeCategory = activeCategory_;
@synthesize audioPlayer = audioPlayer_;
@synthesize sourceList = sourceList_;
@synthesize tracking = tracking_;
@synthesize activeListener = activeListener_;
@synthesize isPlaying = isPlaying_;

-(id)initEnvironmentWithCategory:(NSString *)category
{
	self.tracking = NO;
	self.isPlaying = NO;
	
	// init activeListener
	self.activeListener = [[Listener alloc] initListener];
	
	// init activeCategory (category inits points, points init soundFiles)
	self.activeCategory = [[Category alloc] initCategoryWithCategory:category];
	
	// define maxSources
	if (MAX_SOURCES < [self.activeCategory.pointArray count]) self.maxSources = MAX_SOURCES;
	else self.maxSources = [self.activeCategory.pointArray count];
	
	// define maxDistance
	self.maxDistance = MAX_DISTANCE;
	
	// init audioPlayer
	self.audioPlayer = [[AudioPlayer alloc] initAudioPlayer];
	
	// init sourceList
	self.sourceList = [[NSArray alloc] initWithArray:[self generateSourcesForEnvironment]];
	
	// prebuffer (all) soundFiles
	[self.audioPlayer preLoadBuffersForCategory:self.activeCategory];
	
	// prelink sources to soundFiles
	[self.audioPlayer preLinkSourcesForEnvironment:self];
	
	return self;
}

-(NSArray *)generateSourcesForEnvironment
{
	NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.maxSources];
	
	for (int i = 0; i < self.maxSources; i++)
	{
		Source *source = [[Source alloc] initSource];
		[temp addObject:source];
		[source release], source = nil;
	}
	
	return temp;
}

-(void)updateListenerHeading:(CLHeading *)newListenerHeading
{
	[self.activeListener updateListenerHeading:newListenerHeading];
}

-(void)updateSourceGains:(CLHeading *)newListenerHeading
{
	float newRotation = newListenerHeading.trueHeading;

	for (int i = 0; i < self.maxSources; i++)
	{
		PointOfInterest *point = [self.activeCategory.pointArray objectAtIndex:i];
		ALuint sourceID = (ALuint)point.activeSource.sourceID;
		
		ALfloat sourceXDir;
		ALfloat sourceZDir;
		ALfloat sourceYDir;
		alGetSource3f(sourceID, AL_POSITION, &sourceXDir, &sourceZDir, &sourceYDir);
		
		float sourceOrientation = atanf(fabsf(sourceXDir) / fabsf(sourceYDir)) * 180 / M_PI;
		
		if (sourceXDir >= 0)
		{
			// if 1st quadrant
			if (sourceYDir < 0)
				;
			// if 2nd quadrant
			else if (sourceYDir > 0)
				sourceOrientation = 180 - sourceOrientation;
			// else 90
			else
				sourceOrientation = 90;
		}
		else
		{
			// if 4th quadrant
			if (sourceYDir < 0)
				sourceOrientation = 360 - sourceOrientation;
			// else if 3rd quadrant
			else if (sourceYDir > 0)
				sourceOrientation = 180 + sourceOrientation;
			// else 270
			else
				sourceOrientation = 270;
		}
		
		float diff = fabsf((fabsf(fabsf(sourceOrientation - newRotation) - 180) / 180) - 1);
		float gainScale = [self gaussianBellCurve:diff];
		
		//gainScale = gainScale * distanceGainScale;
		//if (gainScale < gainFloor) gainScale = gainFloor;
		
		alSourcef(sourceID, AL_GAIN, gainScale);
	}
}

-(float)gaussianBellCurve:(float)difference
{
	float exponent = powf(difference, 2) / (2 * powf(GAUSSIAN_C, 2));
	float gainScale = powf(2.718281828, exponent * -1);
	return gainScale;
}

-(void)updateSourceLocations:(CLLocation *)newListenerLocation
{
	// update and normalize each source location
	NSString *closestSource = @"test";
	float smallestDistance = 1000;
	float closestLat = 1000;
	float closestLon = 1000;
	float maxVal = 0;
	
	
	float GPSX = newListenerLocation.coordinate.longitude;
	float GPSY = newListenerLocation.coordinate.latitude;
	
	for (PointOfInterest *point in self.activeCategory.pointArray)
	{
		float sourceXDir = point.defaultX - GPSX;
		float sourceYDir = point.defaultZ - GPSY;
		
		float currentDistance = sqrtf((sourceXDir * sourceXDir) + (sourceYDir * sourceYDir));
		point.currentDistance = currentDistance;
		
		
		if (currentDistance < smallestDistance)
		{
			smallestDistance = currentDistance;
			closestSource = point.pointName;
			closestLat = point.defaultX;
			closestLon = point.defaultZ;
		}
		
		if (fabsf(sourceXDir) > fabsf(sourceYDir))
			maxVal = fabsf(sourceXDir);
		else
			maxVal = fabsf(sourceYDir);
		
		ALfloat normSourceXDir = sourceXDir / maxVal;
		ALfloat normSourceYDir = sourceYDir / maxVal;
		ALfloat newSourcePos[] = {normSourceXDir, 0, normSourceYDir};
		
		alSourcefv(point.activeSource.sourceID, AL_POSITION, newSourcePos);
		
		point.currentX = normSourceXDir;
		point.currentZ = normSourceYDir;
	}
	// re-sort
	int sortedTest = [self.activeCategory sortPointArray:0];
	self.activeCategory.sorted = 0;

	if (sortedTest == 1)
	{
		[self.audioPlayer reLinkSourcesForEnvironment:self];
	}
}

-(void)updateMaxDistanceSlider:(float)newMaxDistance
{
	self.maxDistance = newMaxDistance;
}

-(void)cleanUpOpenAL
{
	// delete sources
	for (int i = 0; i < self.maxSources; i++)
	{
		Source *source = [self.sourceList objectAtIndex:i];
		ALuint sourceID = source.sourceID;
		alDeleteSources(1, &sourceID);
	}
	
	// delete buffers
	for (PointOfInterest *point in self.activeCategory.pointArray)
	{
		for (int i = 0; i < NUM_BUFFERS; i++)
		{
			ALuint bufferID = (ALuint)[[point.soundFile.bufferList objectAtIndex:i] unsignedIntegerValue];
			alDeleteBuffers(1, &bufferID);
		}
	}
}

-(NSString *)getClosestPointName
{
	PointOfInterest *point = [self.activeCategory.pointArray objectAtIndex:0];
	return point.pointName;
}
	
-(float)getClosestPointDistance:(float)userLatitude withLon:(float)userLongtitude
{
	PointOfInterest *point = [self.activeCategory.pointArray objectAtIndex:0];
	
	CLLocation *poiLoc = [[CLLocation alloc] initWithLatitude:point.defaultZ longitude:point.defaultX];
	CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongtitude];
	
	float smallestDistanceMeters = [userLoc distanceFromLocation:poiLoc];
	
	[poiLoc release];
	[userLoc release];
	
	return smallestDistanceMeters;
}

-(void)stopTracking {
    
}

@end
