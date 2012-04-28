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

typedef void(^FeedBlock)(NSArray *);


typedef enum {
    FeedTypeTechcrunch,
    FeedTypeGizmodo
} FeedType;

@interface FeedDownloader : NSObject <ASIHTTPRequestDelegate>
{
	NSMutableArray *myEntries;
}

@property (nonatomic, readonly, retain) NSMutableArray *entries; 

+(FeedDownloader*)sharedController;
- (void)downloadFeed:(FeedType)type withSuccessBlock:(FeedBlock)block;
- (void)saveCache;

@end
