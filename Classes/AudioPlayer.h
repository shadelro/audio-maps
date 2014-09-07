//
//  AudioPlayer.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenAL/al.h"
#import "OpenAL/alc.h"
#include "AudioToolbox/AudioToolbox.h"

@class SoundFile, Category, PointOfInterest, Environment;

@interface AudioPlayer : NSObject {

}

-(id)initAudioPlayer;

-(void)playAllSoundsInEnvironment:(Environment *)environmentName;
-(void)stopAllSoundsInEnvironment:(Environment *)environmentName;
-(void)pauseAllSoundsInEnvironment:(Environment *)environmentName;

-(void)preLoadBuffersForCategory:(Category *)categoryName;
-(void)preLinkSourcesForEnvironment:(Environment *)environment;
-(void)reLinkSourcesForEnvironment:(Environment *)environment;
-(BOOL)loadNextStreamingBufferForPoint:(PointOfInterest *)point intoBuffer:(NSUInteger)bufferID;

-(void)playLongSoundFromPoint:(PointOfInterest *)point;
-(void)rotateBufferThread:(PointOfInterest *)point;
-(BOOL)rotateBufferForStreamingSound:(PointOfInterest *)point;

-(void)cleanBuffersForEnvironment:(Environment *)environmentName;

@end
