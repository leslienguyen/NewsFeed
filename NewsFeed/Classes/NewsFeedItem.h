//
//  NewsFeedItem.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsFeedItem : NSObject 
{
	NSString *myTitle;
	NSURL *myLink;
	NSString *myAuthor;
	NSDate *myPublishedDate;
	NSString *mySummary;
	NSString *myContent;
	NSString *myImageUrl;
    NSString *myThumbnailUrl;
}

@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite, retain) NSURL *link;
@property (nonatomic, readwrite, retain) NSString *author;
@property (nonatomic, readwrite, retain) NSDate *publishedDate;
@property (nonatomic, readwrite, retain) NSString *summary;
@property (nonatomic, readwrite, retain) NSString *content;
@property (nonatomic, readwrite, retain) UIImage *thumbnail;
@property (nonatomic, readwrite, retain) UIImage *image;
@property (nonatomic, readwrite, retain) NSString *thumbnailUrl;
@property (nonatomic, readwrite, retain) NSString *imageUrl;

@end
