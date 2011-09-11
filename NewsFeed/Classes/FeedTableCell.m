//
//  FeedTableCell.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "FeedTableCell.h"


@implementation FeedTableCell

@synthesize titleLeft = myTitleLeft;
@synthesize titleRight = myTitleRight;
@synthesize imageViewLeft = myImageViewLeft;
@synthesize imageViewRight = myImageViewRight;
@synthesize buttonLeft = myButtonLeft;
@synthesize buttonRight = myButtonRight;

- (void)dealloc
{
	[myTitleLeft release]; myTitleLeft = nil;
	[myTitleRight release]; myTitleRight = nil;
	[myImageViewLeft release]; myImageViewLeft = nil;
	[myImageViewRight release]; myImageViewRight = nil;
	[myButtonLeft release]; myButtonLeft = nil;
	[myButtonRight release]; myButtonRight = nil;
	
	[super dealloc];
}

@end
