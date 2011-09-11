//
//  NewsFeedController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "NewsFeedController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "NewsFeedItem.h"
#import "NSNotificationCenter+LNExtension.h"

static NewsFeedController *theSharedController = nil;

NSString *NewsFeedDidChangeNotification = @"NewsFeedDidChangeNotification";

@interface NewsFeedController()

@property (nonatomic, readwrite, retain) NSMutableArray *entries;

@end

@implementation NewsFeedController

@synthesize entries = myEntries;

- (id)init
{
	self = [super init];
	
	if(self != nil)
	{
		self.entries = [NSMutableArray array];
	}
	return self;
}

- (void)makeRequest
{
	NSLog(@"Make Request");
	NSURL *url = [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/feed/load?q=http://feeds.feedburner.com/TechCrunch&v=1.0&output=json&num=12"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];	
}

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"requestFinished:");
	
	//remove all old entries
	[self.entries removeAllObjects];
	
	// Use when fetching text data
	NSString *jsonString = [request responseString];
	//NSLog(@"%@", jsonString);
	
	NSDictionary *rootResults = [jsonString objectFromJSONString];
	NSDictionary *responseData = [rootResults objectForKey:@"responseData"];
	NSDictionary *feed = [responseData objectForKey:@"feed"];
	
	NSArray *entries = [feed objectForKey:@"entries"];
	
	for(NSDictionary *entry in entries)
	{
		NewsFeedItem *item = [[[NewsFeedItem alloc] init] autorelease];
		[item setTitle:[entry objectForKey:@"title"]];
		[item setSummary:[entry objectForKey:@"contentSnippet"]];
		
		NSString *linkString = [entry objectForKey:@"link"];
		if([linkString length] > 0)
		{
			[item setLink:[NSURL URLWithString:linkString]];
		}
			 
		[item setContent:[entry objectForKey:@"content"]];
		[item setAuthor:[entry objectForKey:@"author"]];
		
		NSArray *mediaGroups = [entry objectForKey:@"mediaGroups"];
		
		NSDictionary *mediaGroup = [mediaGroups lastObject];
		
		NSArray *contents = [mediaGroup objectForKey:@"contents"];
		
		for(NSDictionary *content in contents)
		{
			//NSString *medium = [content objectForKey:@"medium"];
			//do i need to check if it's an image??
			NSArray *thumbnails = [content objectForKey:@"thumbnails"];
			NSDictionary *thumbnailDict = [thumbnails lastObject];
			NSString *urlString = [thumbnailDict objectForKey:@"url"];
			if([urlString length] > 0)
			{
				NSURL *url = [NSURL URLWithString:urlString];
				UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
				
				if(image != nil)
				{
					[item setThumbnail:image];
				}
				
				break; //currently only need one thumbnail
				
			}
		}
		
		[self.entries addObject:item];							
		
		NSLog(@"Title: %@", [entry objectForKey:@"title"]);		
		
	}
	
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
	
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NewsFeedDidChangeNotification object:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"requestFailed: %@", [error localizedDescription]);
}


#pragma mark Singleton Implementation
//
// Singleton Pattern Implementation
//
//
+ (NewsFeedController *)sharedController
{
    @synchronized(self) 
	{		
        if (theSharedController == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return theSharedController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
	{
        if (theSharedController == nil) 
		{
            theSharedController = [super allocWithZone:zone];
            return theSharedController;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released	
}

- (void)release
{
    //do nothing	
}

- (id)autorelease
{
    return self;	
}

@end
