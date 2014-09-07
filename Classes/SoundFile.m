//
//  SoundFile.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundFile.h"


@implementation SoundFile

@synthesize bufferList = bufferList_;
@synthesize fileID = fileID_;
@synthesize fileName = fileName_;
@synthesize fileSize = fileSize_;
@synthesize bufferIndex = bufferIndex_;
@synthesize loops = loops_;


-(id)initWithFile:(NSString *)filePath
{
	if (self = [super init])
	{
		self.fileName = filePath;
		self.fileID = [self openAudioFile:filePath];
		self.fileSize = [self audioFileSize:self.fileID];
		self.bufferIndex = 0;
		self.loops = YES;
		
		// create bufferList
		NSMutableArray *tempList = [NSMutableArray array];
		int i;
		for (i = 0; i < NUM_BUFFERS; i++)
		{
			ALuint bufferID;
			alGenBuffers(1, &bufferID);
			[tempList addObject:[NSNumber numberWithUnsignedInt:bufferID]];
		}
		self.bufferList = tempList;
		
		AudioFileClose(self.fileID);
		
	}
	
	return self;
}


-(AudioFileID)openAudioFile:(NSString *)filePath
{
	AudioFileID outAFID;
	NSURL *afURL = [NSURL fileURLWithPath:filePath];
	AudioFileOpenURL((CFURLRef)afURL, kAudioFileReadPermission, 0, &outAFID);
	
	return outAFID;
}


-(UInt32)audioFileSize:(AudioFileID)fileDescriptor
{
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);

	return (UInt32)outDataSize;
}

@end
