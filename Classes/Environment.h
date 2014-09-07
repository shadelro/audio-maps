//
//  Environment.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenAL/al.h"
#import "OpenAL/alc.h"
#import "CoreLocation/CoreLocation.h"

@class AudioPlayer, Category, Listener;

@interface Environment : NSObject {

}

@property(strong, nonatomic) Category *activeCategory;
@property(strong, nonatomic) AudioPlayer *audioPlayer;
@property(strong, nonatomic) NSArray *sourceList;
@property(strong, nonatomic) Listener *activeListener;
@property(assign, nonatomic) NSUInteger maxSources;
@property(assign, nonatomic) float maxDistance;
@property(assign, nonatomic) BOOL tracking;
@property(assign, nonatomic) BOOL isPlaying;

-(id)initEnvironmentWithCategory:(NSString *)category;
-(void)updateListenerHeading:(CLHeading *)newListenerHeading;
-(void)updateSourceGains:(CLHeading *)newListenerHeading;
-(void)updateSourceLocations:(CLLocation *)newListenerLocation;
-(NSArray *)generateSourcesForEnvironment;
-(void)cleanUpOpenAL;
-(float)gaussianBellCurve:(float)difference;
-(NSString *)getClosestPointName;
-(float)getClosestPointDistance:(float)userLatitude withLon:(float)userLongtitude;
-(void)stopTracking;

@end
