//
//  NewsFeedItem.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "NewsFeedItem.h"


@implementation NewsFeedItem

@synthesize title = myTitle;
@synthesize link = myLink;
@synthesize author = myAuthor;
@synthesize publishedDate = myPublishedDate;
@synthesize summary = mySummary;
@synthesize content = myContent;
@synthesize thumbnail = myThumbnail;
@synthesize images = myImages;

- (void)dealloc
{
	[myTitle release]; myTitle = nil;
	[myLink release]; myLink = nil;
	[myAuthor release]; myAuthor = nil;
	[myPublishedDate release]; myPublishedDate = nil;
	[mySummary release]; mySummary = nil;
	[myContent release]; myContent = nil;
	[myThumbnail release]; myThumbnail = nil;
	[myImages release]; myImages = nil;
	
	[super dealloc];
}

@end
