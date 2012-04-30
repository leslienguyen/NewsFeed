//
//  RootViewController.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/4/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDownloader.h"

@class FeedTableCell;

@interface GridViewController : UITableViewController
{
	BOOL myTableFormat;
	FeedTableCell *myTvCell;
	NSMutableDictionary *myCachedImages;
	NSString *myErrorMessage;
    UIActivityIndicatorView *mySpinner;
    FeedType feedType;
}

- (id)initWithFeedType:(FeedType)type;

- (IBAction)displayDetail:(id)sender;

@property (nonatomic, assign) IBOutlet FeedTableCell *tvCell;
@property (nonatomic, assign) FeedType feedType;
@end
