//
//  RootViewController.h
//  AvatarExplorer
//
//  Created by Ben Scheirman on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface RootViewController : UITableViewController <ASIHTTPRequestDelegate> {
    NSDictionary *avatarInfo;
    NSMutableDictionary *imageCache;
    NSOperationQueue *imageRequestQueue;
    NSMutableSet *imageRequests;
}

@end
