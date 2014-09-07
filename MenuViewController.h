//
//  MenuViewController.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenAL/al.h"
#import "OpenAL/alc.h"


@interface MenuViewController : UITableViewController {
	ALCcontext *mContext;
	ALCdevice *mDevice;
}

-(void)initOpenAL;

@end
