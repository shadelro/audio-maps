//
//  CategoryViewController.h
//  AudioMaps
//
//  Created by Brent Shadel on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <UIKit/UIKit.h>
#include "CoreLocation/CoreLocation.h"

@class Environment;

@interface CategoryViewController : UIViewController  <CLLocationManagerDelegate>
{
	IBOutlet UILabel *sourceName;
	IBOutlet UILabel *sourceDistance;
	IBOutlet UILabel *xPos;
	IBOutlet UILabel *zPos;
	IBOutlet UILabel *orientation;
	IBOutlet UILabel *distanceValue;
	IBOutlet UISlider *distanceSlider;
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *pauseButton;
	IBOutlet UIButton *stopButton;
	IBOutlet UIButton *trackingButton;
}

@property(strong, nonatomic) NSString *activeCategory;
@property(strong, nonatomic) IBOutlet Environment *environment;
@property(strong, nonatomic) CLLocationManager *locationManager;

-(void)loadSelectedPage;

-(IBAction)playButtonPressed;
-(IBAction)pauseButtonPressed;
-(IBAction)stopButtonPressed;
-(IBAction)distanceSliderDidUpdate;
-(IBAction)trackingButtonPressed;



@end
