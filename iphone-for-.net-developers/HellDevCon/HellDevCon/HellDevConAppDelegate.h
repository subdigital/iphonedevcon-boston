//
//  HellDevConAppDelegate.h
//  HellDevCon
//
//  Created by Ben Scheirman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HellDevConViewController;

@interface HellDevConAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet HellDevConViewController *viewController;

@end
