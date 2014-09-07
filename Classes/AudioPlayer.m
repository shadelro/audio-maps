//
//  AudioPlayer.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioPlayer.h"

#import "Constants.h"
#import "SoundFile.h"
#import "Category.h"
#import "PointOfInterest.h"
#import "Environment.h"
#import "Source.h"
#import "PointOfInterest.h"


@implementation AudioPlayer

-(id)initAudioPlayer
{
	return self;
}

-(void)playAllSoundsInEnvironment:(Environment *)environmentName
{
	for (int i = 0; i < environmentName.maxSources; i++)
	{
		PointOfInterest *point = [environmentName.activeCategory.pointArray objectAtIndex:i];
		[self playLongSoundFromPoint:point];
	}
}

-(void)pauseAllSoundsInEnvironment:(Environment *)environmentName
{
	for (int i = 0; i < environmentName.maxSources; i++)
	{
		Source *source = [environmentName.sourceList objectAtIndex:i];
		alSourceStop(source.sourceID);
	}
}


-(void)stopAllSoundsInEnvironment:(Environment *)environmentName
{
	for (int i = 0; i < environmentName.maxSources; i++)
	{
		PointOfInterest *point = [environmentName.activeCategory.pointArray objectAtIndex:i];
		Source *source = point.activeSource;
		alSourceStop(source.sourceID);
		point.soundFile.bufferIndex = 0;
	}
	//[self cleanBuffersForEnvironment:environmentName];
}

-(void)cleanBuffersForEnvironment:(Environment *)environmentName
{
	NSMutableArray *outData = [NSMutableArray arrayWithCapacity:BUFFER_SIZE];
	for (int j = 0; j < BUFFER_SIZE; j++)
	{
		[outData addObject:[NSNumber numberWithUnsignedChar:0]];
	}
	
	for (int i = 0; i < environmentName.maxSources; i++)
	{
		PointOfInterest *point = [environmentName.activeCategory.pointArray objectAtIndex:i];
		for (NSNumber *bufferNumber in point.soundFile.bufferList)
		{
			ALuint bufferID = (ALuint)[bufferNumber unsignedIntegerValue];
			alBufferData(bufferID, AL_FORMAT_MONO16, (__bridge const ALvoid *)(outData), BUFFER_SIZE, 44100);
		}
	}
}

-(void)preLoadBuffersForCategory:(Category *)categoryName
{
	for (PointOfInterest *point in categoryName.pointArray)
	{
		for (NSNumber *bufferNumber in point.soundFile.bufferList)
		{
			ALuint bufferID = (ALuint)[bufferNumber unsignedIntegerValue];
			[self loadNextStreamingBufferForPoint:point intoBuffer:bufferID];
		}
	}
}

-(void)preLinkSourcesForEnvironment:(Environment *)environment
{
	for (int i = 0; i < environment.maxSources; i++)
	{
		Source *source = [environment.sourceList objectAtIndex:i];
		ALuint sourceID = source.sourceID;
		PointOfInterest *point = [environment.activeCategory.pointArray objectAtIndex:i];
		
		point.activeSource = source;
		
		for (NSNumber *bufferNumber in point.soundFile.bufferList)
		{
			ALuint bufferID = (ALuint)[bufferNumber unsignedIntegerValue];
			alSourceQueueBuffers(sourceID, 1, &bufferID);
		}
	}
}

-(void)reLinkSourcesForEnvironment:(Environment *)environment
{
	NSUInteger k = environment.maxSources;
	for (NSUInteger i = 0; i < environment.maxSources; i++)
	{
		PointOfInterest *closePoint = [environment.activeCategory.pointArray objectAtIndex:i];
		if (closePoint.activeSource == nil)
		{
			for (NSUInteger j = k; j < [environment.activeCategory.pointArray count]; j++)
			{
				PointOfInterest *farPoint = [environment.activeCategory.pointArray objectAtIndex:j];
				if (farPoint.activeSource != nil)
				{
					// 1. pause old
					alSourcePause(farPoint.activeSource.sourceID);
					
					// 2. switch sourceIDs
					// 3. reset bufferIndices
					closePoint.activeSource = farPoint.activeSource;
					closePoint.soundFile.bufferIndex = 0;
					
					farPoint.activeSource = nil;
					farPoint.soundFile.bufferIndex = 0;
					
					// 4. switch sourcePositions
			
					ALfloat normSourceXDir = farPoint.currentX;
					ALfloat normSourceYDir = farPoint.currentZ;
					ALfloat newSourcePos[] = {normSourceXDir, 0, normSourceYDir};
					
					alSourcefv(closePoint.activeSource.sourceID, AL_POSITION, newSourcePos);
					
					if (environment.isPlaying) [environment.audioPlayer playLongSoundFromPoint:closePoint];
					
					k = j+1;
					j = [environment.activeCategory.pointArray count];
				}
			}
		}
	}
}

-(BOOL)loadNextStreamingBufferForPoint:(PointOfInterest *)point intoBuffer:(NSUInteger)bufferID
{
	UInt32 tempBufferSize = BUFFER_SIZE;
	
	AudioFileID fileID = [point.soundFile openAudioFile:point.soundFile.fileName];
	UInt32 fileSize = point.soundFile.fileSize;
	UInt32 bufferIndex = point.soundFile.bufferIndex;
	
	UInt32 totalChunks = fileSize / BUFFER_SIZE;
	
	if (bufferIndex > totalChunks)
	{
		point.soundFile.bufferIndex = 0;
		return point.soundFile.loops;
	}
	
	NSUInteger startOffset = bufferIndex * BUFFER_SIZE;
	
	if (bufferIndex == totalChunks)
	{
		UInt32 leftOverBytes = fileSize - (BUFFER_SIZE * totalChunks);
		tempBufferSize = leftOverBytes;
	}
	
	UInt32 bytesToRead = tempBufferSize;
	unsigned char *outData = (unsigned char *)malloc(tempBufferSize);
	
	if (bytesToRead == 0)
	{
		free(outData);
		point.soundFile.bufferIndex = 0;
		return (point.soundFile.loops);
	}
	
	AudioFileReadBytes(fileID, false, startOffset, &bytesToRead, outData);
	alBufferData((ALuint)bufferID, AL_FORMAT_MONO16, outData, bytesToRead, 44100);
	
	free(outData);
	outData = NULL;
	
	
	AudioFileClose(fileID);
	
	bufferIndex++;
	point.soundFile.bufferIndex = bufferIndex;
	
	return YES;
}

-(void)playLongSoundFromPoint:(PointOfInterest *)point
{
	ALuint sourceID = point.activeSource.sourceID;
	
	if (sourceID != 0)
	{
		alSourcePlay(sourceID);
		[NSThread detachNewThreadSelector:@selector(rotateBufferThread:) toTarget:self withObject:point];
	}
}

-(void)rotateBufferThread:(PointOfInterest *)point
{
	@autoreleasepool {
		BOOL stillPlaying = YES;
		while (stillPlaying) {
			stillPlaying = [self rotateBufferForStreamingSound:point];
		}
	}
	alSourceStop(point.activeSource.sourceID);
}

-(BOOL)rotateBufferForStreamingSound:(PointOfInterest *)point
{
	ALuint sourceID = point.activeSource.sourceID;
	
	ALint sourceState;
	alGetSourcei(sourceID, AL_SOURCE_STATE, &sourceState);
	if (sourceState != AL_PLAYING)
	{
		return NO;
	}
	
	ALint buffersProcessed = 0;
	alGetSourcei(sourceID, AL_BUFFERS_PROCESSED, &buffersProcessed);
	
	if (buffersProcessed > 0)
	{
		ALuint bufferID;
		alSourceUnqueueBuffers(sourceID, 1, &bufferID);
		if (![self loadNextStreamingBufferForPoint:point intoBuffer:bufferID])
		{
			return NO;
		}
		alSourceQueueBuffers(sourceID, 1, &bufferID);
	}
	
	return YES;
}


@end
