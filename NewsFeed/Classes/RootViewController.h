//
//  RootViewController.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/4/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedTableCell;

@interface RootViewController : UITableViewController
{
	BOOL gridFormat;
	FeedTableCell *tvCell;
}

@property (nonatomic, assign) IBOutlet FeedTableCell *tvCell;
@end
