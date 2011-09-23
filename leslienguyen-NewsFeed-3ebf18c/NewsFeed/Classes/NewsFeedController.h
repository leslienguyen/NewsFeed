//
//  NewsFeedController.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

extern NSString *NewsFeedDidChangeNotification;
extern NSString *NewsFeedRequestDidFailNotification;
extern NSString *NewsFeedErrorKey;

@interface NewsFeedController : NSObject <ASIHTTPRequestDelegate>
{
	NSMutableArray *myEntries;
}

@property (nonatomic, readonly, retain) NSMutableArray *entries; 

+(NewsFeedController*)sharedController;
- (void)makeRequest;
- (void)saveCache;

@end
