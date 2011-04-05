//
//  SnowfallViewController.m
//  Snowfall
//
//  Created by Ben Scheirman on 9/28/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "SnowfallViewController.h"

@implementation SnowfallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithRed:.3
												green:.6
												 blue:.9
												alpha:1.0];
	
	flakeImage = [[UIImage imageNamed:@"flake.png"] retain];
	
	[NSTimer scheduledTimerWithTimeInterval:.1
									 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onTimer {
	UIImageView *imageView =[[UIImageView alloc] initWithImage:flakeImage];
	
	int startX = arc4random() % 320;
	int startY = -50;
	
	int endX = arc4random() % 320;
	int endY = 480;
	

	double speed = (1/round(random() % 100) + 1) * 5;
	double scale = (1/round(random() % 100) + 1) * 25;

	imageView.frame = CGRectMake(startX, startY, scale, scale);
	imageView.alpha = 0.25;
	
	[self.view addSubview:imageView];
	[imageView release];
	
	[UIView beginAnimations:@"flake" context:imageView];
	[UIView setAnimationDuration:speed];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	imageView.frame = CGRectMake(endX, endY, scale, scale);
	
	[UIView commitAnimations];
}

-(void)animationFinished:(NSString *)animationName finished:(BOOL)finished context:(void *)context {
	UIImageView *imageView = context;
	[imageView removeFromSuperview];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[flakeImage release];
    [super dealloc];
}

@end
