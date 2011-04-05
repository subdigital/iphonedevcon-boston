//
//  SnowfallAppDelegate.h
//  Snowfall
//
//  Created by Ben Scheirman on 9/28/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnowfallViewController;

@interface SnowfallAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SnowfallViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SnowfallViewController *viewController;

@end

