//
//  Listener.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"


@interface Listener : NSObject {

}

@property(strong, nonatomic) CLHeading *listenerHeading;
//@property (nonatomic, retain) CLLocation *listenerLocation;

-(id)initListener;
-(void)updateListenerHeading:(CLHeading *)newHeading;
-(float)getListenerHeadingInDegrees;
/*
-(void)updateListenerLocation:(CLLocation *)newLocation;
-(float)getListenerXPos;
-(float)getListenerZPos;
*/

@end
