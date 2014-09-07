//
//  Category.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PointOfInterest.h"
#import "SoundFile.h"


@implementation PointOfInterest

@synthesize pointName = pointName_;
@synthesize defaultX = defaultX_;
@synthesize defaultZ = defaultZ_;
@synthesize currentX = currentX_;
@synthesize currentZ = currentZ_;
@synthesize soundFile = soundFile_;
@synthesize activeSource = activeSource_;
@synthesize currentDistance = currentDistance_;


-(id)initWithFile:(NSString *)filePath;
{
	if (self = [super init])
	{
		self.pointName = [[filePath lastPathComponent] stringByDeletingPathExtension];
		
		NSStringEncoding encoding;
        NSError *error;
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:&encoding error:&error];
        
		NSArray *chunks = [contents componentsSeparatedByString:@":"];
		[contents release], contents = nil;
		self.defaultX = [[chunks objectAtIndex:2] floatValue];
		self.defaultZ = [[chunks objectAtIndex:0] floatValue];
		self.currentX = self.defaultX;
		self.currentZ = self.defaultZ;
		
		NSString *soundFileURL = [NSString stringWithFormat:@"%@.caf",[filePath stringByDeletingPathExtension]];
		SoundFile *tempSoundFile = [[SoundFile alloc] initWithFile:soundFileURL];
		self.soundFile = tempSoundFile;
		[tempSoundFile release], tempSoundFile = nil;
		
		self.currentDistance = 0;
	}
	return self;
}

@end
