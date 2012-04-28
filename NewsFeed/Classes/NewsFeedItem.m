//
//  NewsFeedItem.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "NewsFeedItem.h"

static NSString *kNewsFeedItemTitleKey=@"kNewsFeedItemTitleKey";
static NSString *kNewsFeedItemLinkKey=@"kNewsFeedItemLinkKey";
static NSString *kNewsFeedItemAuthorKey=@"kNewsFeedItemAuthorKey";
static NSString *kNewsFeedItemDateKey=@"kNewsFeedItemDateKey";
static NSString *kNewsFeedItemSummaryKey=@"kNewsFeedItemSummaryKey";
static NSString *kNewsFeedItemContentKey=@"kNewsFeedItemContentKey";
static NSString *kNewsFeedItemThumbnailKey=@"kNewsFeedItemThumbnailKey";
static NSString *kNewsFeedItemImageKey=@"kNewsFeedItemImageKey";

@implementation NewsFeedItem

@synthesize title = myTitle;
@synthesize link = myLink;
@synthesize author = myAuthor;
@synthesize publishedDate = myPublishedDate;
@synthesize summary = mySummary;
@synthesize content = myContent;
@synthesize image = myImage;
@synthesize thumbnail = myThumbnail;
@synthesize imageUrl = myImageUrl;
@synthesize thumbnailUrl = myThumbnailUrl;

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self != nil)
	{
		self.title = [decoder decodeObjectForKey:kNewsFeedItemTitleKey];
		self.link = [decoder decodeObjectForKey:kNewsFeedItemLinkKey];
		self.author = [decoder decodeObjectForKey:kNewsFeedItemAuthorKey];
		self.publishedDate = [decoder decodeObjectForKey:kNewsFeedItemDateKey];
		self.summary = [decoder decodeObjectForKey:kNewsFeedItemSummaryKey];
		self.content = [decoder decodeObjectForKey:kNewsFeedItemContentKey];
		
		//UIImage does not support NSCoding
		NSData *thumbnailData = [decoder decodeObjectForKey:kNewsFeedItemThumbnailKey];
		if(thumbnailData)
		{
			self.thumbnail = [UIImage imageWithData:thumbnailData];
		}
		
		NSData *imageData = [decoder decodeObjectForKey:kNewsFeedItemImageKey];
		if(imageData)
		{
			self.image = [UIImage imageWithData:imageData];
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.title forKey:kNewsFeedItemTitleKey];
	[encoder encodeObject:self.link forKey:kNewsFeedItemLinkKey];
	[encoder encodeObject:self.author forKey:kNewsFeedItemAuthorKey];
	[encoder encodeObject:self.publishedDate forKey:kNewsFeedItemDateKey];
	[encoder encodeObject:self.summary forKey:kNewsFeedItemSummaryKey];
	[encoder encodeObject:self.content forKey:kNewsFeedItemContentKey];
	
	if(self.thumbnail)
	{
		NSData *thumbnailData = UIImageJPEGRepresentation(self.thumbnail, 1.0f);	
		if(thumbnailData)
			[encoder encodeObject:thumbnailData forKey:kNewsFeedItemThumbnailKey];
	}
	
	if(self.image)
	{		
		NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0f);
		if(imageData)
			[encoder encodeObject:imageData forKey:kNewsFeedItemImageKey];
	}
}

- (void)dealloc
{
	[myTitle release]; myTitle = nil;
	[myLink release]; myLink = nil;
	[myAuthor release]; myAuthor = nil;
	[myPublishedDate release]; myPublishedDate = nil;
	[mySummary release]; mySummary = nil;
	[myContent release]; myContent = nil;
	[myThumbnail release]; myThumbnail = nil;
	[myImage release]; myImage = nil;
	
	[super dealloc];
}

@end
