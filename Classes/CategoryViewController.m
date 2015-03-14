//
//  CategoryViewController.m
//  AudioMaps
//
//  Created by Brent Shadel on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "Environment.h"
#import "AudioPlayer.h"
#import "Listener.h"

@implementation CategoryViewController

@synthesize activeCategory = activeCategory_;
@synthesize environment = environment_;
@synthesize locationManager = locationManager_;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = self.activeCategory;
	
	self.locationManager = [[CLLocationManager alloc] init];
	[self.locationManager setDelegate:self];
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.headingFilter = 1;
	
	[self loadSelectedPage];
	
	//automatically start tracking?
}

-(void)loadSelectedPage
{
	self.environment = [self.environment initEnvironmentWithCategory:self.activeCategory];
}

-(IBAction)playButtonPressed
{
	if (self.environment.tracking)
	{
		[self.environment.audioPlayer playAllSoundsInEnvironment:self.environment];
		self.environment.isPlaying = YES;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Error" message:@"Must begin tracking first!" delegate:self
							  cancelButtonTitle:@"Return" otherButtonTitles:nil];
		[alert show];
	}

}

-(IBAction)pauseButtonPressed
{
	[self.environment.audioPlayer pauseAllSoundsInEnvironment:self.environment];
	self.environment.isPlaying = NO;
}

-(IBAction)stopButtonPressed
{
	[self.environment.audioPlayer stopAllSoundsInEnvironment:self.environment];
	self.environment.isPlaying = NO;
}

-(IBAction)distanceSliderDidUpdate
{
	self.environment.maxDistance = distanceSlider.value;
	distanceValue.text = [NSString stringWithFormat:@"%1.2f",self.environment.maxDistance];
}


-(IBAction)trackingButtonPressed
{
	if (self.environment.tracking)
	{
		self.environment.tracking = NO;
		[self.locationManager stopUpdatingHeading];
		[self.locationManager stopUpdatingLocation];
		[trackingButton setTitle:@"Start Tracking" forState:UIControlStateNormal];
	}
	else
	{
        [self.locationManager requestWhenInUseAuthorization];
		self.environment.tracking = YES;
		[self.locationManager startUpdatingHeading];
		[self.locationManager startUpdatingLocation];
		[trackingButton setTitle:@"Stop Tracking" forState:UIControlStateNormal];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self.environment updateSourceLocations:location];
    
    xPos.text = [NSString stringWithFormat:@"%.5f",location.coordinate.latitude];
    zPos.text = [NSString stringWithFormat:@"%.5f",location.coordinate.longitude];
    
    sourceName.text = [self.environment getClosestPointName];
    sourceDistance.text = [NSString stringWithFormat:@"%.1f meters",[self.environment getClosestPointDistance:location.coordinate.latitude withLon:location.coordinate.longitude]];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newListenerHeading
{
    [self.environment updateListenerHeading:newListenerHeading];
	
	//[environment updateSourceGains:newListenerHeading];
	
	orientation.text = [NSString stringWithFormat:@"%.0f",[self.environment.activeListener getListenerHeadingInDegrees]];
}

-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    if ([error code] == kCLErrorDenied)
    {
		[self.locationManager stopUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if (self.environment.tracking) {
		self.environment.tracking = NO;
		[self.locationManager stopUpdatingHeading];
		[self.locationManager stopUpdatingLocation];
	}

}
@end
