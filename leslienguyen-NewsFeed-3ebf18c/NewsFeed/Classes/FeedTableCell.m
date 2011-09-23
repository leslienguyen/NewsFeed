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
@synthesize buttonLeft = myButtonLeft;
@synthesize bigTitleLeft = myBigTitleLeft;
@synthesize bigTitleViewLeft = myBigTitleViewLeft;
@synthesize imageViewLeft = myImageViewLeft;

@synthesize titleMiddle= myTitleMiddle;
@synthesize buttonMiddle = myButtoMiddle;
@synthesize bigTitleMiddle = myBigTitleMiddle;
@synthesize bigTitleViewMiddle = myBigTitleViewMiddle;
@synthesize imageViewMiddle = myImageViewMiddle;

@synthesize titleRight = myTitleRight;
@synthesize buttonRight = myButtonRight;
@synthesize bigTitleRight = myBigTitleRight;
@synthesize bigTitleViewRight = myBigTitleViewRight;
@synthesize imageViewRight = myImageViewRight;

- (void)dealloc
{
	[myTitleLeft release]; myTitleLeft = nil;
	[myButtonLeft release]; myButtonLeft = nil;
	[myBigTitleLeft release]; myBigTitleLeft = nil;
	[myBigTitleViewLeft release]; myBigTitleViewLeft = nil;
	[myImageViewLeft release]; myImageViewLeft = nil;
	
	[myTitleMiddle release]; myTitleMiddle = nil;
	[myButtonMiddle release]; myButtonMiddle = nil;
	[myBigTitleMiddle release]; myBigTitleMiddle = nil;
	[myBigTitleViewMiddle release]; myBigTitleViewMiddle = nil;
	[myImageViewMiddle release]; myImageViewMiddle = nil;
	
	[myTitleRight release]; myTitleRight = nil;
	[myButtonRight release]; myButtonRight = nil;
	[myBigTitleRight release]; myBigTitleRight = nil;
	[myBigTitleViewRight release]; myBigTitleViewRight = nil;
	[myImageViewRight release]; myImageViewRight = nil;
	
	[super dealloc];
}

@end
