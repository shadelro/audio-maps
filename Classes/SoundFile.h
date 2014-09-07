//
//  SoundFile.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "OpenAL/al.h"
#include "OpenAL/alc.h"
#include "AudioToolbox/AudioToolbox.h"
#include "Constants.h"


@interface SoundFile : NSObject {

}

@property(strong, nonatomic) NSArray *bufferList;
@property(strong, nonatomic) NSString *fileName;
@property(assign, nonatomic) AudioFileID fileID;
@property(assign, nonatomic) UInt32 fileSize;
@property(assign, nonatomic) UInt32 bufferIndex;
@property(assign, nonatomic) BOOL loops;


-(id)initWithFile:(NSString *)fileURL;
-(AudioFileID)openAudioFile:(NSString *)filePath;
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor;


@end
